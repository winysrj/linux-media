Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59609 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZJRVl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Oct 2009 17:41:26 -0400
Received: by fxm18 with SMTP id 18so4367618fxm.37
        for <linux-media@vger.kernel.org>; Sun, 18 Oct 2009 14:41:29 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 18 Oct 2009 23:41:29 +0200
Message-ID: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
Subject: pctv nanoStick Solo not recognized
From: Matteo Miraz <telegraph.road@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've just bought a new DVB USB card, but it seems that the current
version of linux tv does not recognize it at all.
I tried both the ubuntu kernel (9.04 and 9.10) and the latest drivers
downloaded with mercurial from http://linuxtv.org/hg/v4l-dvb

The card is a PCTV nanoStick Solo, and chip seems to be a "73E SE".
Looking at the lsusb output (reported below), it seems that it is not
a pinnacle, but a new brand (the Vendor ID is different from the
pinnacle's one).

Can you help me?

Thanks,
Matteo
---

lsusb output:

Bus 001 Device 011: ID 2013:0245
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x2013
  idProduct          0x0245
  bcdDevice            1.00
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
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
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
       bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
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
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
