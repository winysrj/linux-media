Return-path: <linux-media-owner@vger.kernel.org>
Received: from asav4.lyse.net ([81.167.36.150]:45963 "EHLO asav4.lyse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab2K1SxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 13:53:21 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by asav4.lyse.net (Postfix) with ESMTP id 05A426C225
	for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 19:29:24 +0100 (CET)
Received: from [192.168.1.104] (4.84-234-173.customer.lyse.net [84.234.173.4])
	by asav4.lyse.net (Postfix) with ESMTP id 423376C226
	for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 19:29:17 +0100 (CET)
Message-ID: <50B657FC.2060404@i100.no>
Date: Wed, 28 Nov 2012 19:29:16 +0100
From: =?ISO-8859-1?Q?Alf_H=F8gemark?= <alf@i100.no>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] cx231xx : Add support for Elgato Video Capture V2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This patch adds support for the Elgato Video Capture, version 2, device.

The device is added based on the code for 
CX231XX_BOARD_HAUPPAUGE_USBLIVE2, it is simply a
copy of the code for that board, with the proper USB device info for the
Elgato Video Capture V2 device.

Signed-off-by: Alf Høgemark <alf@i100.no>

---

I have opened the device, and found out that it uses the CX 23112 chip.
There is no visual indication on the device that it is "Version 2", but 
the lsusb shows "Video Capture V2".
I do not know how the "Version 1" looks like.

Based on the fact that "lsusb -v" on the following page
http://www.linuxtv.org/wiki/index.php/Hauppauge_USB-Live-2
matches very closely the "lsusb -v" from my device, I decided to patch 
the cx231xx driver, using the same setup
as defined in the driver for the CX231XX_BOARD_HAUPPAUGE_USBLIVE2 device.

The patch has been tested using vlc to play and grab some VHS cassettes, 
in PAL format.
I get nice video and sound quality. My VHS player does not have stereo, 
so I cannot test if it supports stereo.

The Elgato Video Capture, version 1, is already defined in the em2xx driver
em28xx/em28xx.h:#define EM2860_BOARD_ELGATO_VIDEO_CAPTURE      33
with this USB info :
        { USB_DEVICE(0x0fd9, 0x0033),
                         .driver_info = EM2860_BOARD_ELGATO_VIDEO_CAPTURE},
So my device, the version 2, has different hardware compared to version 1.

Here is the output of "lsusb -v" for my device :

Bus 002 Device 023: ID 0fd9:0037 Elgato Systems GmbH Video Capture v2
Couldn't open device, some information will be missing
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass          239 Miscellaneous Device
   bDeviceSubClass         2 ?
   bDeviceProtocol         1 Interface Association
   bMaxPacketSize0        64
   idVendor           0x0fd9 Elgato Systems GmbH
   idProduct          0x0037 Video Capture v2
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

Regards
Alf Hogemark


diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c 
b/drivers/media/video/cx231xx/cx231xx-cards.c
index 53dae2a..7cc6cdc 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -603,6 +603,33 @@ struct cx231xx_board cx231xx_boards[] = {
                         .gpio = NULL,
                 } },
         },
+       [CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2] = {
+               .name = "Elgato Video Capture V2",
+               .tuner_type = TUNER_ABSENT,
+               .decoder = CX231XX_AVDECODER,
+               .output_mode = OUT_MODE_VIP11,
+               .demod_xfer_mode = 0,
+               .ctl_pin_status_mask = 0xFFFFFFC4,
+               .agc_analog_digital_select_gpio = 0x0c,
+               .gpio_pin_status_mask = 0x4001000,
+               .norm = V4L2_STD_NTSC,
+               .no_alt_vanc = 1,
+               .external_av = 1,
+               .dont_use_port_3 = 1,
+               .input = {{
+                       .type = CX231XX_VMUX_COMPOSITE1,
+                       .vmux = CX231XX_VIN_2_1,
+                       .amux = CX231XX_AMUX_LINE_IN,
+                       .gpio = NULL,
+               }, {
+                       .type = CX231XX_VMUX_SVIDEO,
+                       .vmux = CX231XX_VIN_1_1 |
+                               (CX231XX_VIN_1_2 << 8) |
+                               CX25840_SVIDEO_ON,
+                       .amux = CX231XX_AMUX_LINE_IN,
+                       .gpio = NULL,
+               } },
+       },
  };
  const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);

@@ -642,6 +669,8 @@ struct usb_device_id cx231xx_id_table[] = {
          .driver_info = CX231XX_BOARD_KWORLD_UB430_USB_HYBRID},
         {USB_DEVICE(0x1f4d, 0x0237),
          .driver_info = CX231XX_BOARD_ICONBIT_U100},
+       {USB_DEVICE(0x0fd9, 0x0037),
+        .driver_info = CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2},
         {},
  };

diff --git a/drivers/media/video/cx231xx/cx231xx.h 
b/drivers/media/video/cx231xx/cx231xx.h
index 2000bc6..cbe0c86 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -69,6 +69,7 @@
  #define CX231XX_BOARD_ICONBIT_U100 13
  #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL 14
  #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC 15
+#define CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2 16

  /* Limits minimum and default number of buffers */
  #define CX231XX_MIN_BUF                 4


