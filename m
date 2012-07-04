Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33558 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2GDNVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 09:21:05 -0400
Received: by ghrr11 with SMTP id r11so6429892ghr.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 06:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4Xxq9LXGXQKRiNsU_tE8LcyJY64Wk5H4OFzEyhhXtsJJy3dw@mail.gmail.com>
References: <CAD4Xxq_s4zbRKBrjcQAfn4v5Dp0sytU=8_=XUViice98aQFysQ@mail.gmail.com>
	<CAD4Xxq9LXGXQKRiNsU_tE8LcyJY64Wk5H4OFzEyhhXtsJJy3dw@mail.gmail.com>
Date: Wed, 4 Jul 2012 23:21:03 +1000
Message-ID: <CAD4Xxq8c_SBbJsZc764oFwNjRDeGKuVEX_042ry=xeZBY_ZH-A@mail.gmail.com>
Subject: ATI theatre 750 HD tuner USB stick
From: Fisher Grubb <fisher.grubb@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

My name is Fisher Grubb, I have an ATI (now AMD) theatre 750 HD based
TV tuner USB stick.  I don't think this ATI chipset is supported by
linuxTV and have had no joy search google as others also hit a dead
end.

I have put USB bus dump for that device and the chip part numbers at the bottom.

Please may I have a quick reply if someone looks at this, thanks.

Model number is U5071, manufacturer site: http://www.geniatech.com/pa/u5071.asp

I think this is a very impressive piece of hardware as it can do:
Analogue TV, DVB, AV capture and S video capture.  There is an IR
receiver on board and came with IR remote control.

I'm happy to provide any info on it that you may want such as picture
of board & chips.  I'm almost finished my electronics degree and so
can do hardware probing if someone may give me something specific to
look for.  I'm also happy to run software or commands to dump stuff or
even help with dumping things from the windows drivers if I've given
directions etc.

Thank you,

Fisher

lsusb: Bus 002 Device 021: ID 0438:ac14 Advanced Micro Devices, Inc.

sudo lsusb -vd 0438:ac14

Bus 002 Device 021: ID 0438:ac14 Advanced Micro Devices, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0438 Advanced Micro Devices, Inc.
  idProduct          0xac14
  bcdDevice            1.00
  iManufacturer           1 AMD
  iProduct                2 Cali TV Card
  iSerial                 3 1234-5678
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           97
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
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
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
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               3
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
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
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               3
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

Chips:
ATI:
T507
0930
MADE IN TAIWAN
P0U493.00
215-0692014

NXP:
TDA18271HDC2
P3KN4 02
PG09361
