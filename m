Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:55938 "HELO
	outbound-mail-359.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751307Ab0EOXEn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 19:04:43 -0400
Received: from 226.21.108.93.rev.vodafone.pt ([93.108.21.226] helo=[10.0.0.238])
	by box472.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <seabra@ptolom.eu>)
	id 1ODQPP-00060w-MA
	for linux-media@vger.kernel.org; Sat, 15 May 2010 17:04:41 -0600
Subject: Afatech 9035 + NXP 18291 = GT-U7200
From: =?ISO-8859-1?Q?Jo=E3o?= Seabra <seabra@ptolom.eu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 May 2010 00:04:30 +0100
Message-ID: <1273964670.1693.15.camel@nomad>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good evening,

I have a gigabyte gt-u7200 but since it's new i believe there aren't any
drivers available
On the webpage
http://www.gigabyte.com.tw/Products/TVCard/Products_Spec.aspx?ClassValue=TV+Card&ProductID=2875&ProductName=GT-U7200 says it has a NXP18291 tuner and the decoder chip is Afatech 9035.
All i found related to Afatech 9035 was this post from December 2008:
http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030923.html and
the feature request in ubuntu :
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/519544

I tried to compile the 9035 driver but it has no instructions and fails.

Could someone give me some details if its simple/possible to have a
driver for this usb pen?

Kind Regards,
 João Seabra

dmesg output:
[  115.175224] usbcore: registered new interface driver usbhid
[  115.175227] usbhid: v2.6:USB HID core driver
[ 1967.463143] usb 2-1: USB disconnect, address 2
[ 6654.750267] usb 2-1: new high speed USB device using ehci_hcd and
address 3
[ 6654.907301] usb 2-1: configuration #1 chosen from 1 choice
[ 6654.914557] input: GIGABYTE Technologies Inc. U7200 USB TV Device
as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.1/input/input11
[ 6654.914771] generic-usb 0003:1044:7005.0002: input,hidraw0: USB HID
v1.01 Keyboard [GIGABYTE Technologies Inc. U7200 USB TV Device] on
usb-0000:00:1d.7-1/input1

lsusb -v:
Bus 002 Device 003: ID 1044:7005 Chu Yuen Enterprise Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1044 Chu Yuen Enterprise Co., Ltd
  idProduct          0x7005 
  bcdDevice            2.00
  iManufacturer           1 GIGABYTE Technologies Inc.
  iProduct                2 U7200 USB TV Device
  iSerial                 3 AF0102020700001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          122
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           5
     bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
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
      Endpoint Descriptor:
        bLength                 7
       bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
 bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)


