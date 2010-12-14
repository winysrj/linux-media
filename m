Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:43200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab0LNJ52 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 04:57:28 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBE9vSZ7006751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 04:57:28 -0500
Received: from rincewind.home.kraxel.org (vpn1-4-240.ams2.redhat.com [10.36.4.240])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBE9vOVi025721
	for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 04:57:25 -0500
Message-ID: <4D073F83.8010301@redhat.com>
Date: Tue, 14 Dec 2010 10:57:23 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge USB Live 2
Content-Type: multipart/mixed;
 boundary="------------000803050109010901080606"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------000803050109010901080606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

   Hi folks,

Got a "Hauppauge USB Live 2" after google found me that there is a linux 
driver for it.  Unfortunaly linux doesn't manage to initialize the device.

I've connected the device to a Thinkpad T60.  It runs a 2.6.37-rc5 
kernel with the linuxtv/staging/for_v2.6.38 branch merged in.

Kernel log and lsusb output are attached.

Ideas anyone?

cheers,
   Gerd

--------------000803050109010901080606
Content-Type: text/plain;
 name="live2-dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="live2-dmesg.txt"

[  231.994065] usb 1-2: new high speed USB device using ehci_hcd and address 5
[  232.110991] usb 1-2: New USB device found, idVendor=2040, idProduct=c200
[  232.110998] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  232.111023] usb 1-2: Product: Hauppauge Device
[  232.111029] usb 1-2: Manufacturer: Hauppauge
[  232.111033] usb 1-2: SerialNumber: 0013566174
[  232.465523] IR NEC protocol handler initialized
[  232.489573] Linux video capture interface: v2.00
[  232.499834] IR RC5(x) protocol handler initialized
[  232.518668] IR RC6 protocol handler initialized
[  232.541743] IR JVC protocol handler initialized
[  232.579260] IR Sony protocol handler initialized
[  232.614172] lirc_dev: IR Remote Control driver registered, major 250 
[  232.643778] IR LIRC bridge handler initialized
[  232.656779] cx231xx v4l2 driver loaded.
[  232.656844] cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
[  232.656848] cx231xx #0: registering interface 1
[  232.659017] cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
[  232.660130] cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
[  232.661252] cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
[  232.686363] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[  232.686726] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[  232.687166] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[  232.687479] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[  232.687853] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[  232.688348] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[  232.688727] cx231xx #0: UsbInterface::sendCommand, failed with status --32
[  232.688731] cx231xx #0: cx231xx_dev_init: cx231xx_afe init super block - errCode [-32]!
[  232.688845] cx231xx #0: cx231xx_init_dev: cx231xx_i2c_register - errCode [-32]!
[  232.688859] cx231xx: probe of 1-2:1.1 failed with error -32
[  232.688915] usbcore: registered new interface driver cx231xx

--------------000803050109010901080606
Content-Type: text/plain;
 name="live2-lsusb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="live2-lsusb.txt"


Bus 001 Device 005: ID 2040:c200 Hauppauge 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x2040 Hauppauge
  idProduct          0xc200 
  bcdDevice           40.01
  iManufacturer           1 Hauppauge
  iProduct                2 Hauppauge Device
  iSerial                 3 0013566174
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          248
    bNumInterfaces          6
    bConfigurationValue     1
    iConfiguration          4 Hauppauge Device
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              340mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             32 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8e  EP 14 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0e  EP 14 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               4
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         1
      bInterfaceCount         5
      bFunctionClass        255 Vendor Specific Class
      bFunctionSubClass     255 Vendor Specific Subclass
      bFunctionProtocol     255 Vendor Specific Protocol
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              7 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8f  EP 15 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             20 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             21 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x001c  1x 28 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             22 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0034  1x 52 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             23 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             24 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00b8  1x 184 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             25 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x02d8  1x 728 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             26 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x13c4  3x 964 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             27 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0b84  2x 900 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             28 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             31 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             29 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             30 Hauppauge Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0240  1x 576 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--------------000803050109010901080606--
