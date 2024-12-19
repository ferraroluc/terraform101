resource "azurerm_resource_group" "terraform101" {
  location = "East US"
  name     = "terraform101-rg"
}

resource "azurerm_virtual_network" "terraform101" {
  name                = "terraform101-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraform101.location
  resource_group_name = azurerm_resource_group.terraform101.name
}

resource "azurerm_subnet" "terraform101" {
  name                 = "terraform101-subnet"
  resource_group_name  = azurerm_resource_group.terraform101.name
  virtual_network_name = azurerm_virtual_network.terraform101.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "terraform101" {
  name                = "terraform101-public-ip"
  location            = azurerm_resource_group.terraform101.location
  resource_group_name = azurerm_resource_group.terraform101.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "terraform101" {
  name                = "terraform101-nsg"
  location            = azurerm_resource_group.terraform101.location
  resource_group_name = azurerm_resource_group.terraform101.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "terraform101" {
  name                = "terraform101-nic"
  location            = azurerm_resource_group.terraform101.location
  resource_group_name = azurerm_resource_group.terraform101.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.terraform101.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform101.id
  }
}

resource "azurerm_network_interface_security_group_association" "terraform101" {
  network_interface_id      = azurerm_network_interface.terraform101.id
  network_security_group_id = azurerm_network_security_group.terraform101.id
}

resource "azurerm_windows_virtual_machine" "terraform101" {
  name                  = "terraform101-vm"
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd1234!"
  location              = azurerm_resource_group.terraform101.location
  resource_group_name   = azurerm_resource_group.terraform101.name
  network_interface_ids = [azurerm_network_interface.terraform101.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "terraform101" {
  name                       = "terraform101-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.terraform101.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
  SETTINGS
}
