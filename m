Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward18.mail.yandex.net ([95.108.253.143]:54514 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaE0T4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 15:56:13 -0400
From: CrazyCat <crazycat69@narod.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] technisat-sub2: Fix stream curruption on high bitrate
Date: Tue, 27 May 2014 22:45:36 +0300
Message-ID: <1823569.HE0xhFUA0K@computer>
In-Reply-To: <20140525152957.23be9b06.m.chehab@samsung.com>
References: <3539618.frtlsOTgfg@ubuntu> <20140525152957.23be9b06.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 25 May 2014 15:29:57 Mauro Carvalho Chehab wrote:
> Could you please better document this patch? 

Bug "catched" @ new ABS2 satellite (75E). Transponders with bitrate 70-80mbit. Before some european another users report same issue with ~67mbit transponders (S2,8PSK,27500,5/6). So just another bug in this driver :)

> I would be expecting a better description of the problem you faced,
> the version of the board you have (assuming that different versions
> might have different minimal intervals) and an lsusb -v output from
> the board you faced issues, showing what the endpoint descriptors
> say about that.

This device have only one hw revision. lsusb -v output:

Bus 001 Device 009: ID 14f7:0500 TechniSat Digital GmbH DVB-PC TV Star HD
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x14f7 TechniSat Digital GmbH
  idProduct          0x0500 DVB-PC TV Star HD
  bcdDevice            0.01
  iManufacturer           1 TechniSat Digital
  iProduct                2 TechniSat USB device
  iSerial                 3 0008C9F04C76
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           69
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower              300mA
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
        bEndpointAddress     0x01  EP 1 OUT
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
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 1024 bytes
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
        bInterval               0
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
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

> Btw, if those tables are ok, can't we just retrieve the information
> directly from the descriptors, instead of hardcoding it, e. g
> filling it with:
> 
>        interval = 1 << (ep->bInterval - 1);
> 
> at the board probing time, just like we did at changeset 1b3fd2d34266?

good idea :)
