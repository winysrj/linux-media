Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:60971 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaKIPFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Nov 2014 10:05:42 -0500
Received: by mail-qc0-f175.google.com with SMTP id b13so5189578qcw.20
        for <linux-media@vger.kernel.org>; Sun, 09 Nov 2014 07:05:41 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 9 Nov 2014 16:05:41 +0100
Message-ID: <CAKm1XeJh9UjYvsoJUeLDwW6whkkm1cfFPHCrH0fX0vX20Fg9hQ@mail.gmail.com>
Subject: Problems with USB DVB-T stick by MAGIX (TerraTec Cinergy T USB XE Ver.2)
From: Maksym Gendin <maksym.gendin@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

I'm new here and I have some problems with a TerraTec Cinergy T USB XE
DVB-T stick by german manufactor MAGIX on Arch Linux.

dmesg output when I plug the stick in:

[  267.443420] usb 3-2: new high-speed USB device number 2 using ehci-pci

Here is what lsusb is saying about the stick:

Bus 003 Device 002: ID 0ccd:0095 TerraTec Electronic GmbH
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0ccd TerraTec Electronic GmbH
  idProduct          0x0095
  bcdDevice            2.00
  iManufacturer           1 TerraTec
  iProduct                2 Cinergy T USB XE Ver.2
  iSerial                 3 10012007
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
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
      bNumEndpoints           4
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

It looks like it is a Cinergy T USB XE Ver.2 stick with a different
USB ID (0095 instead of 0069).

I've tried to change the USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2 value
to 0x0095 in the file "dvb-usb-ids.h" and to recompile the package.
The stick was recognized then, but there were other errors when I
tried to use it in VLC. Is there something else which I have to do to
get the stick to work? Unfortunately I don't have the error logs
anymore, but if you need them I can reproduce it.

Best regards,
Maksym
