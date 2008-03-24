Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fridge.mylittleisp.net ([82.70.254.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@mdsh.com>) id 1JdmPv-0006oh-GK
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 14:08:51 +0100
Received: from macmini.mdsh.local (toaster.mylittleisp.net [82.70.254.29])
	by fridge.mylittleisp.net (8.12.8/8.12.8) with ESMTP id m2OD8NZ7006509
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 13:08:24 GMT
Message-ID: <47E7A7C7.1050906@mdsh.com>
Date: Mon, 24 Mar 2008 13:08:23 +0000
From: Mark Himsley <mark@mdsh.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------050503050108000402070804"
Subject: [linux-dvb] Nebula DigiTV USB slave DVB-T is not working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------050503050108000402070804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have two Nebula DigiTV master DVB-T USB devices and one slave device.
All three worked in Windows in any combination (so long as a master was 
also attached if the slave was).

In Linux the two masters work perfectly, I can make multiple recordings
off two multiplexes in MythTV. I cannot make the slave work though.

Attached is the output of `sudo lsusb -v >
digiTV-slave-master-master.txt` - Bus 005 Device 008 is the
slave and Bus 5 device  006 and 004 are the masters.

Attached is also the end of /var/log/syslog showing the moment the slave
is connected. I am interested that the slave device mentions an
IR-receiver, I thought only the masters had that (perhaps the salve is
only lacking the actual IR receiver component from the PCB).

I can use tzap on all three devices and they achieve lock and report
similar signal strength & snr and report ber & unc are both zero.

Currently I have the two master devices plugged in first so they are
/dev/dvb/adapter0 and 1, and the slave device plugged in last so it is
dev/dvb/adapter2.

The problem I am seeing is that I cannot get any data out of
/dev/dvb/adapter2/dvr0.

If I `tzap -a 2 -r 'BBC ONE'` in one terminal and `cat
/dev/dvb/adapter2/dvr0 > temp.ts` for ten seconds I get a grand total of
zero bytes. If I do the same to adapter 0 or 1 I get lots of bytes.

I also have an issue when I unplug the slave device, /dev/dvb/adapter2/*
does not disappear and I need to reboot, so I have also attached the end
of /var/log/syslog when the device is removed.

Is this a known issue or can I provide any further information to get 
this working.

Thanks.

--------------050503050108000402070804
Content-Type: text/plain;
 name="digiTV-slave-master-master.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="digiTV-slave-master-master.txt"


Bus 005 Device 008: ID 0547:0201 Anchor Chips, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0547 Anchor Chips, Inc.
  idProduct          0x0201 
  bcdDevice            0.00
  iManufacturer           1 
  iProduct                2 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x40
      (Missing must-be-set bit!)
      Self Powered
    MaxPower              400mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled

Bus 005 Device 006: ID 0547:0201 Anchor Chips, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0547 Anchor Chips, Inc.
  idProduct          0x0201 
  bcdDevice            0.00
  iManufacturer           1 
  iProduct                2 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x40
      (Missing must-be-set bit!)
      Self Powered
    MaxPower              400mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled

Bus 005 Device 004: ID 0547:0201 Anchor Chips, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0547 Anchor Chips, Inc.
  idProduct          0x0201 
  bcdDevice            0.00
  iManufacturer           1 
  iProduct                2 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x40
      (Missing must-be-set bit!)
      Self Powered
    MaxPower              400mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled

Bus 005 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-14-generic ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength              11
  bDescriptorType      41
  nNbrPorts             8
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00 0x00
  PortPwrCtrlMask    0xff 0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0503 highspeed power enable connect
   Port 4: 0000.0503 highspeed power enable connect
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
   Port 7: 0000.0100 power
   Port 8: 0000.0503 highspeed power enable connect
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 004 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-14-generic uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 003 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-14-generic uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 002 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-14-generic uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Bus 001 Device 001: ID 0000:0000  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed hub
  bMaxPacketSize0        64
  idVendor           0x0000 
  idProduct          0x0000 
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.22-14-generic uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled


--------------050503050108000402070804
Content-Type: text/plain;
 name="syslog-insert"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog-insert"

Mar 24 11:48:22 bedroom kernel: [760308.452226] usb 5-8: new high speed USB device using ehci_hcd and address 7
Mar 24 11:48:22 bedroom kernel: [760308.584562] usb 5-8: configuration #1 chosen from 1 choice
Mar 24 11:48:22 bedroom kernel: [760308.584630] dvb-usb: found a 'Nebula Electronics uDigiTV DVB-T USB2.0)' in cold state, will try to load a firmware
Mar 24 11:48:22 bedroom NetworkManager: <debug> [1206359302.601952] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1'). 
Mar 24 11:48:22 bedroom kernel: [760308.634520] dvb-usb: downloading firmware from file 'dvb-usb-digitv-02.fw'
Mar 24 11:48:22 bedroom kernel: [760308.665416] usb 5-8: USB disconnect, address 7
Mar 24 11:48:22 bedroom kernel: [760308.668126] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
Mar 24 11:48:22 bedroom NetworkManager: <debug> [1206359302.932929] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_ffffffff_ffffffff_noserial'). 
Mar 24 11:48:22 bedroom NetworkManager: <debug> [1206359302.937207] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_ffffffff_ffffffff_noserial'). 
Mar 24 11:48:22 bedroom NetworkManager: <debug> [1206359302.944824] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1'). 
Mar 24 11:48:24 bedroom kernel: [760310.419189] usb 5-8: new high speed USB device using ehci_hcd and address 8
Mar 24 11:48:24 bedroom kernel: [760310.551578] usb 5-8: string descriptor 0 read error: -22
Mar 24 11:48:24 bedroom kernel: [760310.551701] usb 5-8: string descriptor 0 read error: -22
Mar 24 11:48:24 bedroom kernel: [760310.551783] usb 5-8: configuration #1 chosen from 1 choice
Mar 24 11:48:24 bedroom kernel: [760310.551976] dvb-usb: found a 'Nebula Electronics uDigiTV DVB-T USB2.0)' in warm state.
Mar 24 11:48:24 bedroom kernel: [760310.551997] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 24 11:48:24 bedroom kernel: [760310.552091] DVB: registering new adapter (Nebula Electronics uDigiTV DVB-T USB2.0)).
Mar 24 11:48:24 bedroom kernel: [760310.567197] DVB: registering frontend 2 (Zarlink MT352 DVB-T)...
Mar 24 11:48:24 bedroom kernel: [760310.567616] input: IR-receiver inside an USB DVB receiver as /class/input/input8
Mar 24 11:48:24 bedroom kernel: [760310.567638] dvb-usb: schedule remote query interval to 1000 msecs.
Mar 24 11:48:24 bedroom kernel: [760310.567641] dvb-usb: Nebula Electronics uDigiTV DVB-T USB2.0) successfully initialized and connected.
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.569962] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1'). 
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.627292] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_if0'). 
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.693741] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_dvb'). 
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.694330] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_dvb_0'). 
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.694911] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_dvb_1'). 
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.695472] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_dvb_2'). 
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.724135] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_usbraw'). 
Mar 24 11:48:24 bedroom NetworkManager: <debug> [1206359304.819362] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_logicaldev_input'). 


--------------050503050108000402070804
Content-Type: text/plain;
 name="syslog-remove"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog-remove"

Mar 24 12:47:43 bedroom kernel: [763867.512043] usb 5-8: USB disconnect, address 8
Mar 24 12:47:43 bedroom kernel: [763867.523684] dvb-usb: recv bulk message failed: -22
Mar 24 12:47:43 bedroom kernel: [763867.523695] dvb-usb: bulk message failed: -22 (7/-1)
Mar 24 12:47:43 bedroom kernel: [763867.523697] dvb-usb: bulk message failed: -22 (7/-1)
Mar 24 12:47:43 bedroom kernel: [763867.523957] dvb-usb: bulk message failed: -22 (7/7)
Mar 24 12:47:43 bedroom NetworkManager: <debug> [1206362863.397312] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_547_201_noserial_1_logicaldev_input'). 


--------------050503050108000402070804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------050503050108000402070804--
