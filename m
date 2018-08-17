Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51100 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbeHQUuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 16:50:55 -0400
Received: by mail-wm0-f65.google.com with SMTP id s12-v6so8319760wmc.0
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2018 10:46:36 -0700 (PDT)
Message-ID: <7233ce5ecd19fa6942afc1d86e3a7e97f8c3d734.camel@gmail.com>
Subject: Re: [PATCH] uvcvideo: add quirk to force Phytec CAM 004H to GBRG
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        chf.fritz@googlemail.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>,
        Dirk Bender <D.bender@phytec.de>
Date: Fri, 17 Aug 2018 19:46:33 +0200
In-Reply-To: <4073605.T2oYED4Iz8@avalon>
References: <1519212389.11643.13.camel@googlemail.com>
         <1860315.IXoSrtTCf6@avalon> <1534423695.2246.15.camel@googlemail.com>
         <4073605.T2oYED4Iz8@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Donnerstag, den 16.08.2018, 19:39 +0300 schrieb Laurent Pinchart:
> Hi Christoph,
> 
> (Philipp, there's a question for you at the end)
> 
> On Thursday, 16 August 2018 15:48:15 EEST Christoph Fritz wrote:
[...]
> >                         format->fcc = dev->forced_color_format;
> >                         format->bpp = 8;
> >                         width_multiplier = 2;
> 
> bpp and multiplier are more annoying. bpp is a property of the format, which 
> we could add to the uvc_fmts array. 
> 
> I believe the multiplier could be computed by device bpp / bpp from uvc_fmts. 
> That would work at least for the Oculus VR Positional Tracker DK2, but I don't 
> have the Oculus VR Rift Sensor descriptors to check that. Philipp, if you 
> still have access to the device, could you send that to me ?

Full lsusb -v output below, the UVC descriptors are not decoded because
bFunctionClass is set to 255. The YUY2 uncompressed format descriptor
looks like this:

               ___guidFormat__________________________________
1b 24 04 01 04 59 55 59 32 00 00 10 00 80 00 00 aa 00 38 9b 71 10 01 00 00 00 00
                                                               ^^
so,                                           bBitsPerPixel == 16.

----------8<----------
$ lsusb -d 2833:0211 -v

Bus 003 Device 002: ID 2833:0211  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0         9
  idVendor           0x2833 
  idProduct          0x0211 
  bcdDevice            0.00
  iManufacturer           1 Oculus VR
  iProduct                2 Rift Sensor
  iSerial                 3 WMTD303N602SK6
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          342
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              200mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass        255 Vendor Specific Class
      bFunctionSubClass       3 
      bFunctionProtocol       0 
      iFunction               4 CV1 External Camera
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      0 
      iInterface              4 CV1 External Camera
      ** UNRECOGNIZED:  0d 24 01 00 01 4e 00 00 5a 62 02 01 01
      ** UNRECOGNIZED:  12 24 02 01 01 02 00 00 00 00 00 00 00 00 03 0e 00 00
      ** UNRECOGNIZED:  09 24 03 02 01 01 00 04 00
      ** UNRECOGNIZED:  0b 24 05 03 01 00 00 02 7f 14 00
      ** UNRECOGNIZED:  1b 24 06 04 ad cc b1 c2 f6 ab b8 48 8e 37 32 d4 f3 a3 fe ec 05 01 03 02 06 0e 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval              11
        bMaxBurst               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      2 
      bInterfaceProtocol      0 
      iInterface              0 
      ** UNRECOGNIZED:  0e 24 01 01 a7 00 81 00 02 00 01 01 01 00
      ** UNRECOGNIZED:  1b 24 04 01 04 59 55 59 32 00 00 10 00 80 00 00 aa 00 38 9b 71 10 01 00 00 00 00
      ** UNRECOGNIZED:  1e 24 05 01 00 80 02 d0 02 00 00 5e 1a 00 00 5e 1a 00 10 0e 00 3a c6 02 00 01 3a c6 02 00
      ** UNRECOGNIZED:  1e 24 05 02 00 e0 01 40 02 00 00 bb 17 00 00 bb 17 00 70 08 00 07 b2 01 00 01 07 b2 01 00
      ** UNRECOGNIZED:  1e 24 05 03 00 e0 01 c0 03 00 00 bb 17 00 00 bb 17 00 10 0e 00 61 d3 02 00 01 61 d3 02 00
      ** UNRECOGNIZED:  1e 24 05 04 00 80 02 c0 03 00 00 4c 1d 00 00 4c 1d 00 c0 12 00 40 0d 03 00 01 40 0d 03 00
      ** UNRECOGNIZED:  06 24 0d 01 01 04
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      2 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
        bMaxBurst               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      2 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
        bMaxBurst              15
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           22
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000006
      Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat           4 micro seconds
    bU2DevExitLat           4 micro seconds
Device Status:     0x000c
  (Bus Powered)
  U1 Enabled
  U2 Enabled
---------->8----------

regards
Philipp
