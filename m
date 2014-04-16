Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:55787 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDPQeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 12:34:31 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4400F8UU1HKO20@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Apr 2014 12:34:29 -0400 (EDT)
Date: Wed, 16 Apr 2014 13:34:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sat <sattnag@aim.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Help with SMS2270 @ linux-sunxi (A20 devices)
Message-id: <20140416133419.7d0a1e9f@samsung.com>
In-reply-to: <534E4489.6080909@aim.com>
References: <DB7459DA-2266-4DF3-BBD6-3CB991F7738A@eletronica.org>
 <534E4489.6080909@aim.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Apr 2014 17:51:21 +0900
Sat <sattnag@aim.com> escreveu:

> Hi Roberto,
> 
> Did you check if the device id of your tuner is included in smsusb.c?
> id can be gotten by lsusb command.
> 
> Thanks,
> Satoshi
> 
> (2014/04/16 8:28), Roberto Alcantara wrote:
> > Guys,
> >
> > I’m trying enable Siano SMS2270 ISDB-T tuner in development board with Allwinner A20 SoC.
> >
> > I recompiled kernel with modules I can load them but something seems wrong. After insert USB Sms2270 dongle I only see:
> >
> > Jan  1 00:15:20 awsom kernel: [  922.645502] usb 1-1.4: new high-speed USB device number 6 using sw-ehci
> > Jan  1 00:15:20 awsom mtp-probe: checking bus 1, device 6: "/sys/devices/platform/sw-ehci.1/usb1/1-1/1-1.4"
> > Jan  1 00:15:20 awsom mtp-probe: bus: 1, device: 6 was not an MTP device
> >
> > and no more logs.
> >
> > smsusb was loaded with debug=2.
> >
> > The usb dongle is plugged on usb powered hub and other devices like keyboard are working fine with this hub port.
> >
> > What I missing here? Thanks for all tips !  :-)

I suspect that it is trying to load this device via smsdio driver, but
I'm not sure.

Those MTP probe messages look weird to me. I suspect that it didn't even
called the USB probing method for this device, but I'm not a MTP
expert.

Regards,
Mauro

> >
> > Best regards,
> >   - Roberto
> >
> >
> > root@awsom:/home/linaro# lsmod
> > Module                  Size  Used by
> > sunxi_cedar_mod        10284  0
> > smsdvb                 13909  0
> > smsusb                  8936  0
> > smsmdtv                28266  2 smsdvb,smsusb
> > disp_ump                 854  0
> > mali_drm                2638  1
> > mali                  113459  0
> > ump                    56392  4 disp_ump,mali
> > lcd                     3646  0
> >
> > root@awsom:/home/linaro# lsusb
> > Bus 001 Device 002: ID 058f:6254 Alcor Micro Corp. USB Hub
> > Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 001 Device 003: ID 0e8f:0021 GreenAsia Inc. Multimedia Keyboard Controller
> > Bus 001 Device 004: ID 187f:0600 Siano Mobile Silicon
> >
> > root@awsom:/home/linaro# uname -a
> > Linux awsom 3.4.75.sun7i_CRAFF+ #4 SMP PREEMPT Thu Apr 10 01:17:47 BRT 2014 armv7l armv7l armv7l GNU/Linux
> >
> >
> >
> >
> > root@awsom:/home/linaro# lsusb -v
> >
> > Bus 001 Device 002: ID 058f:6254 Alcor Micro Corp. USB Hub
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               2.00
> >    bDeviceClass            9 Hub
> >    bDeviceSubClass         0 Unused
> >    bDeviceProtocol         1 Single TT
> >    bMaxPacketSize0        64
> >    idVendor           0x058f Alcor Micro Corp.
> >    idProduct          0x6254 USB Hub
> >    bcdDevice            1.00
> >    iManufacturer           0
> >    iProduct                1 USB2.0Hub
> >    iSerial                 0
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           25
> >      bNumInterfaces          1
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0xe0
> >        Self Powered
> >        Remote Wakeup
> >      MaxPower              100mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         9 Hub
> >        bInterfaceSubClass      0 Unused
> >        bInterfaceProtocol      0 Full speed (or root) hub
> >        iInterface              0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0001  1x 1 bytes
> >          bInterval              12
> > Hub Descriptor:
> >    bLength               9
> >    bDescriptorType      41
> >    nNbrPorts             4
> >    wHubCharacteristic 0x0080
> >      Ganged power switching
> >      Ganged overcurrent protection
> >      TT think time 8 FS bits
> >      Port indicators
> >    bPwrOn2PwrGood       50 * 2 milli seconds
> >    bHubContrCurrent    100 milli Ampere
> >    DeviceRemovable    0x00
> >    PortPwrCtrlMask    0xff
> >   Hub Port Status:
> >     Port 1: 0000.0303 lowspeed power enable connect
> >     Port 2: 0000.0100 power
> >     Port 3: 0000.0100 power
> >     Port 4: 0000.0503 highspeed power enable connect
> > Device Qualifier (for other device speed):
> >    bLength                10
> >    bDescriptorType         6
> >    bcdUSB               2.00
> >    bDeviceClass            9 Hub
> >    bDeviceSubClass         0 Unused
> >    bDeviceProtocol         0 Full speed (or root) hub
> >    bMaxPacketSize0        64
> >    bNumConfigurations      1
> > Device Status:     0x0001
> >    Self Powered
> >
> > Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               2.00
> >    bDeviceClass            9 Hub
> >    bDeviceSubClass         0 Unused
> >    bDeviceProtocol         0 Full speed (or root) hub
> >    bMaxPacketSize0        64
> >    idVendor           0x1d6b Linux Foundation
> >    idProduct          0x0002 2.0 root hub
> >    bcdDevice            3.04
> >    iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ehci_hcd
> >    iProduct                2 SW USB2.0 'Enhanced' Host Controller (EHCI) Driver
> >    iSerial                 1 sw-ehci
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           25
> >      bNumInterfaces          1
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0xe0
> >        Self Powered
> >        Remote Wakeup
> >      MaxPower                0mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         9 Hub
> >        bInterfaceSubClass      0 Unused
> >        bInterfaceProtocol      0 Full speed (or root) hub
> >        iInterface              0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0004  1x 4 bytes
> >          bInterval              12
> > Hub Descriptor:
> >    bLength               9
> >    bDescriptorType      41
> >    nNbrPorts             1
> >    wHubCharacteristic 0x000a
> >      No power switching (usb 1.0)
> >      Per-port overcurrent protection
> >    bPwrOn2PwrGood       10 * 2 milli seconds
> >    bHubContrCurrent      0 milli Ampere
> >    DeviceRemovable    0x00
> >    PortPwrCtrlMask    0xff
> >   Hub Port Status:
> >     Port 1: 0000.0503 highspeed power enable connect
> > Device Status:     0x0001
> >    Self Powered
> >
> > Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               1.10
> >    bDeviceClass            9 Hub
> >    bDeviceSubClass         0 Unused
> >    bDeviceProtocol         0 Full speed (or root) hub
> >    bMaxPacketSize0        64
> >    idVendor           0x1d6b Linux Foundation
> >    idProduct          0x0001 1.1 root hub
> >    bcdDevice            3.04
> >    iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ohci_hcd
> >    iProduct                2 SW USB2.0 'Open' Host Controller (OHCI) Driver
> >    iSerial                 1 sw-ohci
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           25
> >      bNumInterfaces          1
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0xe0
> >        Self Powered
> >        Remote Wakeup
> >      MaxPower                0mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         9 Hub
> >        bInterfaceSubClass      0 Unused
> >        bInterfaceProtocol      0 Full speed (or root) hub
> >        iInterface              0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0002  1x 2 bytes
> >          bInterval             255
> > Hub Descriptor:
> >    bLength               9
> >    bDescriptorType      41
> >    nNbrPorts             1
> >    wHubCharacteristic 0x0012
> >      No power switching (usb 1.0)
> >      No overcurrent protection
> >    bPwrOn2PwrGood        2 * 2 milli seconds
> >    bHubContrCurrent      0 milli Ampere
> >    DeviceRemovable    0x00
> >    PortPwrCtrlMask    0xff
> >   Hub Port Status:
> >     Port 1: 0000.0100 power
> > Device Status:     0x0001
> >    Self Powered
> >
> > Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               2.00
> >    bDeviceClass            9 Hub
> >    bDeviceSubClass         0 Unused
> >    bDeviceProtocol         0 Full speed (or root) hub
> >    bMaxPacketSize0        64
> >    idVendor           0x1d6b Linux Foundation
> >    idProduct          0x0002 2.0 root hub
> >    bcdDevice            3.04
> >    iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ehci_hcd
> >    iProduct                2 SW USB2.0 'Enhanced' Host Controller (EHCI) Driver
> >    iSerial                 1 sw-ehci
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           25
> >      bNumInterfaces          1
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0xe0
> >        Self Powered
> >        Remote Wakeup
> >      MaxPower                0mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         9 Hub
> >        bInterfaceSubClass      0 Unused
> >        bInterfaceProtocol      0 Full speed (or root) hub
> >        iInterface              0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0004  1x 4 bytes
> >          bInterval              12
> > Hub Descriptor:
> >    bLength               9
> >    bDescriptorType      41
> >    nNbrPorts             1
> >    wHubCharacteristic 0x000a
> >      No power switching (usb 1.0)
> >      Per-port overcurrent protection
> >    bPwrOn2PwrGood       10 * 2 milli seconds
> >    bHubContrCurrent      0 milli Ampere
> >    DeviceRemovable    0x00
> >    PortPwrCtrlMask    0xff
> >   Hub Port Status:
> >     Port 1: 0000.0100 power
> > Device Status:     0x0001
> >    Self Powered
> >
> > Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               1.10
> >    bDeviceClass            9 Hub
> >    bDeviceSubClass         0 Unused
> >    bDeviceProtocol         0 Full speed (or root) hub
> >    bMaxPacketSize0        64
> >    idVendor           0x1d6b Linux Foundation
> >    idProduct          0x0001 1.1 root hub
> >    bcdDevice            3.04
> >    iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ohci_hcd
> >    iProduct                2 SW USB2.0 'Open' Host Controller (OHCI) Driver
> >    iSerial                 1 sw-ohci
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           25
> >      bNumInterfaces          1
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0xe0
> >        Self Powered
> >        Remote Wakeup
> >      MaxPower                0mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         9 Hub
> >        bInterfaceSubClass      0 Unused
> >        bInterfaceProtocol      0 Full speed (or root) hub
> >        iInterface              0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0002  1x 2 bytes
> >          bInterval             255
> > Hub Descriptor:
> >    bLength               9
> >    bDescriptorType      41
> >    nNbrPorts             1
> >    wHubCharacteristic 0x0012
> >      No power switching (usb 1.0)
> >      No overcurrent protection
> >    bPwrOn2PwrGood        2 * 2 milli seconds
> >    bHubContrCurrent      0 milli Ampere
> >    DeviceRemovable    0x00
> >    PortPwrCtrlMask    0xff
> >   Hub Port Status:
> >     Port 1: 0000.0100 power
> > Device Status:     0x0001
> >    Self Powered
> >
> > Bus 001 Device 003: ID 0e8f:0021 GreenAsia Inc. Multimedia Keyboard Controller
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               1.10
> >    bDeviceClass            0 (Defined at Interface level)
> >    bDeviceSubClass         0
> >    bDeviceProtocol         0
> >    bMaxPacketSize0         8
> >    idVendor           0x0e8f GreenAsia Inc.
> >    idProduct          0x0021 Multimedia Keyboard Controller
> >    bcdDevice            2.07
> >    iManufacturer           1 CZW
> >    iProduct                2 USB Keyboard
> >    iSerial                 0
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           59
> >      bNumInterfaces          2
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0xa0
> >        (Bus Powered)
> >        Remote Wakeup
> >      MaxPower              100mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         3 Human Interface Device
> >        bInterfaceSubClass      1 Boot Interface Subclass
> >        bInterfaceProtocol      1 Keyboard
> >        iInterface              0
> >          HID Device Descriptor:
> >            bLength                 9
> >            bDescriptorType        33
> >            bcdHID               1.10
> >            bCountryCode            0 Not supported
> >            bNumDescriptors         1
> >            bDescriptorType        34 Report
> >            wDescriptorLength      62
> >           Report Descriptors:
> >             ** UNAVAILABLE **
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0008  1x 8 bytes
> >          bInterval              10
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        1
> >        bAlternateSetting       0
> >        bNumEndpoints           1
> >        bInterfaceClass         3 Human Interface Device
> >        bInterfaceSubClass      0 No Subclass
> >        bInterfaceProtocol      0 None
> >        iInterface              1 CZW
> >          HID Device Descriptor:
> >            bLength                 9
> >            bDescriptorType        33
> >            bcdHID               1.10
> >            bCountryCode            0 Not supported
> >            bNumDescriptors         1
> >            bDescriptorType        34 Report
> >            wDescriptorLength      50
> >           Report Descriptors:
> >             ** UNAVAILABLE **
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x82  EP 2 IN
> >          bmAttributes            3
> >            Transfer Type            Interrupt
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0008  1x 8 bytes
> >          bInterval              10
> > Device Status:     0x0000
> >    (Bus Powered)
> >
> > Bus 001 Device 004: ID 187f:0600 Siano Mobile Silicon
> > Device Descriptor:
> >    bLength                18
> >    bDescriptorType         1
> >    bcdUSB               2.00
> >    bDeviceClass            0 (Defined at Interface level)
> >    bDeviceSubClass         0
> >    bDeviceProtocol         0
> >    bMaxPacketSize0        64
> >    idVendor           0x187f Siano Mobile Silicon
> >    idProduct          0x0600
> >    bcdDevice            0.08
> >    iManufacturer           1 MDTV Receiver
> >    iProduct                2 MDTV Receiver
> >    iSerial                 0
> >    bNumConfigurations      1
> >    Configuration Descriptor:
> >      bLength                 9
> >      bDescriptorType         2
> >      wTotalLength           32
> >      bNumInterfaces          1
> >      bConfigurationValue     1
> >      iConfiguration          0
> >      bmAttributes         0x80
> >        (Bus Powered)
> >      MaxPower              100mA
> >      Interface Descriptor:
> >        bLength                 9
> >        bDescriptorType         4
> >        bInterfaceNumber        0
> >        bAlternateSetting       0
> >        bNumEndpoints           2
> >        bInterfaceClass       255 Vendor Specific Class
> >        bInterfaceSubClass    255 Vendor Specific Subclass
> >        bInterfaceProtocol    255 Vendor Specific Protocol
> >        iInterface              0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x81  EP 1 IN
> >          bmAttributes            2
> >            Transfer Type            Bulk
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0200  1x 512 bytes
> >          bInterval               0
> >        Endpoint Descriptor:
> >          bLength                 7
> >          bDescriptorType         5
> >          bEndpointAddress     0x02  EP 2 OUT
> >          bmAttributes            2
> >            Transfer Type            Bulk
> >            Synch Type               None
> >            Usage Type               Data
> >          wMaxPacketSize     0x0200  1x 512 bytes
> >          bInterval               0
> > Device Qualifier (for other device speed):
> >    bLength                10
> >    bDescriptorType         6
> >    bcdUSB               2.00
> >    bDeviceClass          255 Vendor Specific Class
> >    bDeviceSubClass       255 Vendor Specific Subclass
> >    bDeviceProtocol       255 Vendor Specific Protocol
> >    bMaxPacketSize0        64
> >    bNumConfigurations      1
> > Device Status:     0x0000
> >    (Bus Powered)
> > root@awsom:/home/linaro#
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Regards,
Mauro
