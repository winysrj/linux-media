Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35149 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaDYSb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 14:31:28 -0400
Received: by mail-ob0-f182.google.com with SMTP id uy5so4648381obc.41
        for <linux-media@vger.kernel.org>; Fri, 25 Apr 2014 11:31:27 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 25 Apr 2014 19:31:27 +0100
Message-ID: <CAOS+5GGaHQvO30fhgG6PYGc2POHFiFwHvDozZ6k6f_1MEy9_eA@mail.gmail.com>
Subject: Elgato Eye TV Deluxe V2 supported?
From: Another Sillyname <anothersname@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an Elgato Eye TV V2 USB device  USB ID 0fd9:002c which reading here....

https://github.com/mirrors/linux-2.6/blob/master/drivers/staging/media/as102/as102_usb_drv.h

Looks like it should be supported (it looks like Devin wrote some of
the code?)......it gets recognised in dmesg and indeed lsusb sees it,
but no firmware is loaded (I have the required as102 files in
/lib/firmware) and in effect it never 'initialises'.

Has something broken since kernel 2.6 (I'm currently running 3.13.10)
or did it never work?

Googling around pops up a load of contradictory information whether it
works or not.

lsusb gives me this...

lsusb -v -d 0fd9:002c

Bus 002 Device 004: ID 0fd9:002c Elgato Systems GmbH EyeTV DTT Deluxe v2
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0fd9 Elgato Systems GmbH
  idProduct          0x002c EyeTV DTT Deluxe v2
  bcdDevice            1.00
  iManufacturer           1 Elgato
  iProduct                2 EyeTV DTT Dlx
  iSerial                 3 0000xxxxxxxxxxxx
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              300mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
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
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)



lsusb ends



Any ideas?

Thanks in advance.

Tony
