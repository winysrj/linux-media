Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42785 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaCAJcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Mar 2014 04:32:06 -0500
Received: by mail-qc0-f180.google.com with SMTP id i17so1890459qcy.25
        for <linux-media@vger.kernel.org>; Sat, 01 Mar 2014 01:32:04 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 1 Mar 2014 10:32:04 +0100
Message-ID: <CA+J5NAHzVvx47RcBrcTcZe8SfJ3wVP3jo3JhH5j68MaU+HZrXQ@mail.gmail.com>
Subject: Unknown EM2800 video grabber (card=0)
From: Jacob Korf <jacobkorf@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I'm trying this video capture stick from Conceptronic, the Home Video
Creator, but I'm not getting it to work with Linux. I'm using kernel
version 3.13.5 and I'm on Arch Linux. More information and specs here:
http://www.conceptronic.net/product.php?id=322&linkid=294.

This is the output from lsusb -v:

Bus 001 Device 005: ID 1d19:6108 Dexatek Technology Ltd.
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1d19 Dexatek Technology Ltd.
  idProduct          0x6108
  bcdDevice           40.01
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          248
    bNumInterfaces          6
    bConfigurationValue     1
    iConfiguration          4
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface             32
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
      iInterface              7
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
      iInterface             20
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
      iInterface             21
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
      iInterface             22
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
      iInterface             23
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
      iInterface             24
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
      iInterface             25
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
      iInterface             26
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
      iInterface             27
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
      iInterface             28
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
      iInterface             31
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
      iInterface             29
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
      iInterface             30
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


I get the following output when I try what this guy says,
http://www.ubuntu-es.org/node/181787:

[ 1822.015471] usb 1-1.6: new high-speed USB device number 5 using ehci-pci
[ 2163.941596] media: Linux media interface: v0.10
[ 2163.948219] Linux video capture interface: v2.00
[ 2163.956048] usbcore: registered new interface driver em28xx
[ 2176.350939] em28xx: error: skipping audio endpoint 0x83, because it
uses bulk transfers !
[ 2176.350947] em28xx: New device DK Video Grabber @ 480 Mbps
(1d19:6108, interface 2, class 2)
[ 2176.350951] em28xx: Audio interface 2 found (Vendor Class)
[ 2176.351510] em28xx #0: Config register raw data: 0xfffffffb
[ 2176.351859] em28xx #0: AC97 chip type couldn't be determined
[ 2176.351863] em28xx #0: No AC97 audio processor
[ 2176.351891] em28xx: New device DK Video Grabber @ 480 Mbps
(1d19:6108, interface 3, class 3)
[ 2176.351894] em28xx: DVB interface 3 found: bulk isoc
[ 2176.425034] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.425040] em28xx #1: board has no eeprom
[ 2176.435008] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.445036] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.455005] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.465030] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.475029] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.485028] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.495027] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.505026] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.515025] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.525025] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.535024] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.545023] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.555022] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.565021] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.574973] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.585019] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.595018] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.605017] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.615016] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.625015] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.635015] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.645014] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.655010] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.665014] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.675011] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.685010] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.695009] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.705008] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.715007] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.725006] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.735005] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.745005] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.754985] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.765003] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.775002] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.785001] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.795000] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.804999] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.814998] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.824997] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.834996] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.844994] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.854930] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.864993] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.874993] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.884992] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.894991] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.904990] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.914989] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.924988] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.934987] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.944986] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.954902] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.964985] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.974988] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.984983] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2176.994982] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.005137] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.014980] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.024980] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.034978] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.044977] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.054976] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.064975] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.074975] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.085121] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.094973] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.104972] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.114971] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.124970] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.134969] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.144968] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.154966] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.164823] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.174966] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.184967] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.194964] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.204947] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.214962] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.224961] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.234960] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.244947] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.254955] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.264951] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.274940] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.284958] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.294954] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.304940] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.314946] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.324910] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.334951] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.344950] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.354949] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.364948] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.374947] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.384946] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.394945] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.405069] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.414943] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.424942] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.434942] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.444940] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.454940] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.464941] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.474938] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.484914] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.494936] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.504935] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.514937] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.524930] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.534797] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.544931] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.554781] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.564918] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.575006] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.584928] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.594927] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.604926] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.614925] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.624927] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.634923] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.644922] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.654919] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.664923] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.674920] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.684921] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.694918] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.704920] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.704926] em28xx #1: Your board has no unique USB ID and thus
need a hint to be detected.
[ 2177.704929] em28xx #1: You may try to use card=<n> insmod option to
workaround that.
[ 2177.704931] em28xx #1: Please send an email with this log to:
[ 2177.704933] em28xx #1:     V4L Mailing List <linux-media@vger.kernel.org>
[ 2177.704935] em28xx #1: Board eeprom hash is 0x00000000
[ 2177.704938] em28xx #1: Board i2c devicelist hash is 0x1b800080
[ 2177.704945] em28xx #1: Here is a list of valid choices for the
card=<n> insmod option:
[ 2177.704948] em28xx #1:     card=0 -> Unknown EM2800 video grabber
[ 2177.704951] em28xx #1:     card=1 -> Unknown EM2750/28xx video grabber
[ 2177.704953] em28xx #1:     card=2 -> Terratec Cinergy 250 USB
[ 2177.704956] em28xx #1:     card=3 -> Pinnacle PCTV USB 2
[ 2177.704958] em28xx #1:     card=4 -> Hauppauge WinTV USB 2
[ 2177.704961] em28xx #1:     card=5 -> MSI VOX USB 2.0
[ 2177.704963] em28xx #1:     card=6 -> Terratec Cinergy 200 USB
[ 2177.704965] em28xx #1:     card=7 -> Leadtek Winfast USB II
[ 2177.704968] em28xx #1:     card=8 -> Kworld USB2800
[ 2177.704971] em28xx #1:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 /
Plextor ConvertX PX-AV100U
[ 2177.704974] em28xx #1:     card=10 -> Hauppauge WinTV HVR 900
[ 2177.704976] em28xx #1:     card=11 -> Terratec Hybrid XS
[ 2177.704979] em28xx #1:     card=12 -> Kworld PVR TV 2800 RF
[ 2177.704981] em28xx #1:     card=13 -> Terratec Prodigy XS
[ 2177.704984] em28xx #1:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[ 2177.704986] em28xx #1:     card=15 -> V-Gear PocketTV
[ 2177.704989] em28xx #1:     card=16 -> Hauppauge WinTV HVR 950
[ 2177.704991] em28xx #1:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 2177.704994] em28xx #1:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 2177.704996] em28xx #1:     card=19 -> EM2860/SAA711X Reference Design
[ 2177.704999] em28xx #1:     card=20 -> AMD ATI TV Wonder HD 600
[ 2177.705001] em28xx #1:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[ 2177.705004] em28xx #1:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 2177.705006] em28xx #1:     card=23 -> Huaqi DLCW-130
[ 2177.705009] em28xx #1:     card=24 -> D-Link DUB-T210 TV Tuner
[ 2177.705011] em28xx #1:     card=25 -> Gadmei UTV310
[ 2177.705014] em28xx #1:     card=26 -> Hercules Smart TV USB 2.0
[ 2177.705016] em28xx #1:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 2177.705019] em28xx #1:     card=28 -> Leadtek Winfast USB II Deluxe
[ 2177.705021] em28xx #1:     card=29 -> EM2860/TVP5150 Reference Design
[ 2177.705024] em28xx #1:     card=30 -> Videology 20K14XUSB USB2.0
[ 2177.705026] em28xx #1:     card=31 -> Usbgear VD204v9
[ 2177.705028] em28xx #1:     card=32 -> Supercomp USB 2.0 TV
[ 2177.705031] em28xx #1:     card=33 -> Elgato Video Capture
[ 2177.705034] em28xx #1:     card=34 -> Terratec Cinergy A Hybrid XS
[ 2177.705036] em28xx #1:     card=35 -> Typhoon DVD Maker
[ 2177.705038] em28xx #1:     card=36 -> NetGMBH Cam
[ 2177.705041] em28xx #1:     card=37 -> Gadmei UTV330
[ 2177.705043] em28xx #1:     card=38 -> Yakumo MovieMixer
[ 2177.705046] em28xx #1:     card=39 -> KWorld PVRTV 300U
[ 2177.705048] em28xx #1:     card=40 -> Plextor ConvertX PX-TV100U
[ 2177.705051] em28xx #1:     card=41 -> Kworld 350 U DVB-T
[ 2177.705053] em28xx #1:     card=42 -> Kworld 355 U DVB-T
[ 2177.705056] em28xx #1:     card=43 -> Terratec Cinergy T XS
[ 2177.705058] em28xx #1:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 2177.705060] em28xx #1:     card=45 -> Pinnacle PCTV DVB-T
[ 2177.705067] em28xx #1:     card=46 -> Compro, VideoMate U3
[ 2177.705070] em28xx #1:     card=47 -> KWorld DVB-T 305U
[ 2177.705072] em28xx #1:     card=48 -> KWorld DVB-T 310U
[ 2177.705074] em28xx #1:     card=49 -> MSI DigiVox A/D
[ 2177.705077] em28xx #1:     card=50 -> MSI DigiVox A/D II
[ 2177.705079] em28xx #1:     card=51 -> Terratec Hybrid XS Secam
[ 2177.705081] em28xx #1:     card=52 -> DNT DA2 Hybrid
[ 2177.705084] em28xx #1:     card=53 -> Pinnacle Hybrid Pro
[ 2177.705086] em28xx #1:     card=54 -> Kworld VS-DVB-T 323UR
[ 2177.705089] em28xx #1:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[ 2177.705092] em28xx #1:     card=56 -> Pinnacle Hybrid Pro (330e)
[ 2177.705094] em28xx #1:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 2177.705097] em28xx #1:     card=58 -> Compro VideoMate ForYou/Stereo
[ 2177.705099] em28xx #1:     card=59 -> (null)
[ 2177.705101] em28xx #1:     card=60 -> Hauppauge WinTV HVR 850
[ 2177.705104] em28xx #1:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 2177.705106] em28xx #1:     card=62 -> Gadmei TVR200
[ 2177.705109] em28xx #1:     card=63 -> Kaiomy TVnPC U2
[ 2177.705111] em28xx #1:     card=64 -> Easy Cap Capture DC-60
[ 2177.705113] em28xx #1:     card=65 -> IO-DATA GV-MVP/SZ
[ 2177.705116] em28xx #1:     card=66 -> Empire dual TV
[ 2177.705118] em28xx #1:     card=67 -> Terratec Grabby
[ 2177.705120] em28xx #1:     card=68 -> Terratec AV350
[ 2177.705123] em28xx #1:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 2177.705125] em28xx #1:     card=70 -> Evga inDtube
[ 2177.705128] em28xx #1:     card=71 -> Silvercrest Webcam 1.3mpix
[ 2177.705130] em28xx #1:     card=72 -> Gadmei UTV330+
[ 2177.705133] em28xx #1:     card=73 -> Reddo DVB-C USB TV Box
[ 2177.705135] em28xx #1:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[ 2177.705138] em28xx #1:     card=75 -> Dikom DK300
[ 2177.705140] em28xx #1:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[ 2177.705143] em28xx #1:     card=77 -> EM2874 Leadership ISDBT
[ 2177.705145] em28xx #1:     card=78 -> PCTV nanoStick T2 290e
[ 2177.705147] em28xx #1:     card=79 -> Terratec Cinergy H5
[ 2177.705150] em28xx #1:     card=80 -> PCTV DVB-S2 Stick (460e)
[ 2177.705152] em28xx #1:     card=81 -> Hauppauge WinTV HVR 930C
[ 2177.705155] em28xx #1:     card=82 -> Terratec Cinergy HTC Stick
[ 2177.705157] em28xx #1:     card=83 -> Honestech Vidbox NW03
[ 2177.705160] em28xx #1:     card=84 -> MaxMedia UB425-TC
[ 2177.705162] em28xx #1:     card=85 -> PCTV QuatroStick (510e)
[ 2177.705165] em28xx #1:     card=86 -> PCTV QuatroStick nano (520e)
[ 2177.705167] em28xx #1:     card=87 -> Terratec Cinergy HTC USB XS
[ 2177.705170] em28xx #1:     card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
[ 2177.705172] em28xx #1:     card=89 -> Delock 61959
[ 2177.705175] em28xx #1:     card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
[ 2177.705177] em28xx #1: Board not discovered
[ 2177.705179] em28xx #1: Identified as Unknown EM2800 video grabber (card=0)
[ 2177.705182] em28xx #1: Your board has no unique USB ID and thus
need a hint to be detected.
[ 2177.705184] em28xx #1: You may try to use card=<n> insmod option to
workaround that.
[ 2177.705186] em28xx #1: Please send an email with this log to:
[ 2177.705188] em28xx #1:     V4L Mailing List <linux-media@vger.kernel.org>
[ 2177.705190] em28xx #1: Board eeprom hash is 0x00000000
[ 2177.705192] em28xx #1: Board i2c devicelist hash is 0x1b800080
[ 2177.705194] em28xx #1: Here is a list of valid choices for the
card=<n> insmod option:
[ 2177.705196] em28xx #1:     card=0 -> Unknown EM2800 video grabber
[ 2177.705199] em28xx #1:     card=1 -> Unknown EM2750/28xx video grabber
[ 2177.705201] em28xx #1:     card=2 -> Terratec Cinergy 250 USB
[ 2177.705204] em28xx #1:     card=3 -> Pinnacle PCTV USB 2
[ 2177.705206] em28xx #1:     card=4 -> Hauppauge WinTV USB 2
[ 2177.705208] em28xx #1:     card=5 -> MSI VOX USB 2.0
[ 2177.705211] em28xx #1:     card=6 -> Terratec Cinergy 200 USB
[ 2177.705213] em28xx #1:     card=7 -> Leadtek Winfast USB II
[ 2177.705215] em28xx #1:     card=8 -> Kworld USB2800
[ 2177.705218] em28xx #1:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 /
Plextor ConvertX PX-AV100U
[ 2177.705221] em28xx #1:     card=10 -> Hauppauge WinTV HVR 900
[ 2177.705223] em28xx #1:     card=11 -> Terratec Hybrid XS
[ 2177.705226] em28xx #1:     card=12 -> Kworld PVR TV 2800 RF
[ 2177.705228] em28xx #1:     card=13 -> Terratec Prodigy XS
[ 2177.705231] em28xx #1:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[ 2177.705233] em28xx #1:     card=15 -> V-Gear PocketTV
[ 2177.705235] em28xx #1:     card=16 -> Hauppauge WinTV HVR 950
[ 2177.705238] em28xx #1:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 2177.705240] em28xx #1:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 2177.705243] em28xx #1:     card=19 -> EM2860/SAA711X Reference Design
[ 2177.705245] em28xx #1:     card=20 -> AMD ATI TV Wonder HD 600
[ 2177.705248] em28xx #1:     card=21 -> eMPIA Technology, Inc.
GrabBeeX+ Video Encoder
[ 2177.705250] em28xx #1:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 2177.705252] em28xx #1:     card=23 -> Huaqi DLCW-130
[ 2177.705255] em28xx #1:     card=24 -> D-Link DUB-T210 TV Tuner
[ 2177.705257] em28xx #1:     card=25 -> Gadmei UTV310
[ 2177.705259] em28xx #1:     card=26 -> Hercules Smart TV USB 2.0
[ 2177.705262] em28xx #1:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 2177.705264] em28xx #1:     card=28 -> Leadtek Winfast USB II Deluxe
[ 2177.705267] em28xx #1:     card=29 -> EM2860/TVP5150 Reference Design
[ 2177.705269] em28xx #1:     card=30 -> Videology 20K14XUSB USB2.0
[ 2177.705272] em28xx #1:     card=31 -> Usbgear VD204v9
[ 2177.705274] em28xx #1:     card=32 -> Supercomp USB 2.0 TV
[ 2177.705276] em28xx #1:     card=33 -> Elgato Video Capture
[ 2177.705279] em28xx #1:     card=34 -> Terratec Cinergy A Hybrid XS
[ 2177.705281] em28xx #1:     card=35 -> Typhoon DVD Maker
[ 2177.705283] em28xx #1:     card=36 -> NetGMBH Cam
[ 2177.705286] em28xx #1:     card=37 -> Gadmei UTV330
[ 2177.705288] em28xx #1:     card=38 -> Yakumo MovieMixer
[ 2177.705290] em28xx #1:     card=39 -> KWorld PVRTV 300U
[ 2177.705293] em28xx #1:     card=40 -> Plextor ConvertX PX-TV100U
[ 2177.705295] em28xx #1:     card=41 -> Kworld 350 U DVB-T
[ 2177.705298] em28xx #1:     card=42 -> Kworld 355 U DVB-T
[ 2177.705300] em28xx #1:     card=43 -> Terratec Cinergy T XS
[ 2177.705302] em28xx #1:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 2177.705305] em28xx #1:     card=45 -> Pinnacle PCTV DVB-T
[ 2177.705307] em28xx #1:     card=46 -> Compro, VideoMate U3
[ 2177.705310] em28xx #1:     card=47 -> KWorld DVB-T 305U
[ 2177.705312] em28xx #1:     card=48 -> KWorld DVB-T 310U
[ 2177.705314] em28xx #1:     card=49 -> MSI DigiVox A/D
[ 2177.705316] em28xx #1:     card=50 -> MSI DigiVox A/D II
[ 2177.705319] em28xx #1:     card=51 -> Terratec Hybrid XS Secam
[ 2177.705321] em28xx #1:     card=52 -> DNT DA2 Hybrid
[ 2177.705323] em28xx #1:     card=53 -> Pinnacle Hybrid Pro
[ 2177.705326] em28xx #1:     card=54 -> Kworld VS-DVB-T 323UR
[ 2177.705328] em28xx #1:     card=55 -> Terratec Cinnergy Hybrid T
USB XS (em2882)
[ 2177.705331] em28xx #1:     card=56 -> Pinnacle Hybrid Pro (330e)
[ 2177.705333] em28xx #1:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 2177.705336] em28xx #1:     card=58 -> Compro VideoMate ForYou/Stereo
[ 2177.705338] em28xx #1:     card=59 -> (null)
[ 2177.705340] em28xx #1:     card=60 -> Hauppauge WinTV HVR 850
[ 2177.705343] em28xx #1:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 2177.705345] em28xx #1:     card=62 -> Gadmei TVR200
[ 2177.705347] em28xx #1:     card=63 -> Kaiomy TVnPC U2
[ 2177.705350] em28xx #1:     card=64 -> Easy Cap Capture DC-60
[ 2177.705352] em28xx #1:     card=65 -> IO-DATA GV-MVP/SZ
[ 2177.705354] em28xx #1:     card=66 -> Empire dual TV
[ 2177.705356] em28xx #1:     card=67 -> Terratec Grabby
[ 2177.705359] em28xx #1:     card=68 -> Terratec AV350
[ 2177.705361] em28xx #1:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 2177.705363] em28xx #1:     card=70 -> Evga inDtube
[ 2177.705366] em28xx #1:     card=71 -> Silvercrest Webcam 1.3mpix
[ 2177.705368] em28xx #1:     card=72 -> Gadmei UTV330+
[ 2177.705371] em28xx #1:     card=73 -> Reddo DVB-C USB TV Box
[ 2177.705373] em28xx #1:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[ 2177.705375] em28xx #1:     card=75 -> Dikom DK300
[ 2177.705378] em28xx #1:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[ 2177.705380] em28xx #1:     card=77 -> EM2874 Leadership ISDBT
[ 2177.705383] em28xx #1:     card=78 -> PCTV nanoStick T2 290e
[ 2177.705385] em28xx #1:     card=79 -> Terratec Cinergy H5
[ 2177.705387] em28xx #1:     card=80 -> PCTV DVB-S2 Stick (460e)
[ 2177.705390] em28xx #1:     card=81 -> Hauppauge WinTV HVR 930C
[ 2177.705392] em28xx #1:     card=82 -> Terratec Cinergy HTC Stick
[ 2177.705395] em28xx #1:     card=83 -> Honestech Vidbox NW03
[ 2177.705397] em28xx #1:     card=84 -> MaxMedia UB425-TC
[ 2177.705399] em28xx #1:     card=85 -> PCTV QuatroStick (510e)
[ 2177.705402] em28xx #1:     card=86 -> PCTV QuatroStick nano (520e)
[ 2177.705404] em28xx #1:     card=87 -> Terratec Cinergy HTC USB XS
[ 2177.705407] em28xx #1:     card=88 -> C3 Tech Digital Duo HDTV/SDTV USB
[ 2177.705409] em28xx #1:     card=89 -> Delock 61959
[ 2177.705411] em28xx #1:     card=90 -> KWorld USB ATSC TV Stick UB435-Q V2
[ 2177.718126] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.728170] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.738164] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.748162] em28xx #1: failed to get i2c transfer status from
bridge register (error=-5)
[ 2177.748516] em28xx #1: Config register raw data: 0xfffffffb
[ 2177.748865] em28xx #1: AC97 chip type couldn't be determined
[ 2177.748868] em28xx #1: No AC97 audio processor
[ 2177.748873] em28xx #1: v4l2 driver version 0.2.0
[ 2178.108259] em28xx #1: V4L2 video device registered as video0
[ 2178.108264] em28xx #1: dvb set to isoc mode.
[ 2229.546070] em28xx #1: no endpoint for analog mode and transfer type 0

I hope you guys can help me out, if you need more information let me know,

Thanks in advance,

Jacob
