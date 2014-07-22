Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:34267 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaGVSDf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 14:03:35 -0400
Received: by mail-oa0-f52.google.com with SMTP id o6so17978oag.39
        for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 11:03:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3072133.WlkirvIpIB@avalon>
References: <CAC8M0Evra8ipDo9Tgasd2AtWWLZQ8M2Ty37i6R3nc7H0-C3_wg@mail.gmail.com>
	<3072133.WlkirvIpIB@avalon>
Date: Tue, 22 Jul 2014 11:03:35 -0700
Message-ID: <CAC8M0Esy+sRt0OGychoTBfgEBznTnwiCpaC0UzZgd9ga-QSWNg@mail.gmail.com>
Subject: Re: Fresco Logic FL2000
From: Michael Durkin <kc7noa@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

as sudo su

root@SDR-client:/home/mike# lsusb -v -d 1d5c:2000

Bus 002 Device 003: ID 1d5c:2000
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.10
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1d5c
  idProduct          0x2000
  bcdDevice            1.00
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          269
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              270mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         3
      bFunctionClass         14 Video
      bFunctionSubClass       1 Video Control
      bFunctionProtocol       3
      iFunction               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        16
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        16
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      ** UNRECOGNIZED:  04 21 00 01
      ** UNRECOGNIZED:  06 25 01 00 00 00
      ** UNRECOGNIZED:  06 25 02 00 00 00
      ** UNRECOGNIZED:  0a 22 01 00 05 00 02 00 00 00
      ** UNRECOGNIZED:  06 25 01 00 00 00
      ** UNRECOGNIZED:  0a 22 02 00 10 00 14 00 0d 00
      ** UNRECOGNIZED:  0a 23 03 00 0d 00 05 00 00 00
      ** UNRECOGNIZED:  06 25 02 00 01 00
      ** UNRECOGNIZED:  10 26 01 00 00 00 00 00 64 00 00 00 01 00 00 00
      ** UNRECOGNIZED:  0a 24 01 00 14 00 00 00 00 00
      ** UNRECOGNIZED:  06 25 03 00 01 00
      ** UNRECOGNIZED:  0a 24 02 00 02 00 00 00 00 00
      ** UNRECOGNIZED:  06 25 03 00 01 00
      ** UNRECOGNIZED:  06 25 0c 00 00 00
      ** UNRECOGNIZED:  06 25 09 00 02 00
      ** UNRECOGNIZED:  06 25 0b 00 01 00
      ** UNRECOGNIZED:  14 27 00 00 01 00 3c 00 01 00 02 00 03 00 00
00 00 00 02 00
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        16
      bInterfaceSubClass      2
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
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass        16
      bInterfaceSubClass      2
      bInterfaceProtocol      1
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
        bmAttributes           25
          Transfer Type            Isochronous
          Synch Type               Adaptive
          Usage Type               Feedback
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval               7
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
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            9
          Transfer Type            Isochronous
          Synch Type               Adaptive
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        16
      bInterfaceSubClass      2
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           22
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000002
      Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000c
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   2
      Lowest fully-functional device speed is High Speed (480Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat        2047 micro seconds
Device Status:     0x0000
  (Bus Powered)
root@SDR-client:/home/mike#

On Mon, Jul 21, 2014 at 9:24 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Michael,
>
> On Tuesday 20 May 2014 18:32:08 Michael Durkin wrote:
>> It was suggested to me to inquire here if anyone was working on
>> drivers or support for the Fresco Logic FL2000 1d5c:2000
>
> Could you please post the output of
>
> lsusb -v -d 1d5c:2000
>
> (if possible running as root) ?
>
> --
> Regards,
>
> Laurent Pinchart
>
