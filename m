Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:60003 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbZHDFiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 01:38:11 -0400
Received: by pzk34 with SMTP id 34so2778687pzk.4
        for <linux-media@vger.kernel.org>; Mon, 03 Aug 2009 22:38:11 -0700 (PDT)
Subject: [Fwd: [PATCH] Support for Kaiser Baas ExpressCard Dual HD Tuner]
From: James A Webb <jamesawebb@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-A7Vzq8IcwO0NaJe3VTou"
Date: Tue, 04 Aug 2009 15:38:05 +1000
Message-Id: <1249364285.14551.2.camel@cobra.jamesawebb.dyndns.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-A7Vzq8IcwO0NaJe3VTou
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I didn't see this email go come through the forum.  I'm resending
(without PGP sig).  Apologies for any duplicates.

James.

-------- Forwarded Message --------

Second attempt to support recently purchased Kaiser Baas ExpressCard
Dual HD Tuner.  The card is reported as YUAN High-Tech Development Co.,
Ltd STK7700D (lsusb -v attached).

Err, I don't (yet) have a Developer's Certificate of Origin.  Would this
mean that someone will (eventually) commit the patch on my behalf?

Signed-off-by: James A Webb <jamesawebb@gmail.com>


--=-A7Vzq8IcwO0NaJe3VTou
Content-Disposition: attachment; filename="patch"
Content-Type: text/x-patch; name="patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff -r b15490457d60 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sat Aug 01 01:38:01 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Mon Aug 03 12:11:49 2009 +1000
@@ -1501,6 +1501,7 @@
 	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_H) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_T3) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_T5) },
+	{ USB_DEVICE(USB_VID_YUAN,	USB_PID_DIBCOM_STK7700DY) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1628,7 +1629,7 @@
 			}
 		},
 
-		.num_device_descs = 4,
+		.num_device_descs = 5,
 		.devices = {
 			{   "Pinnacle PCTV 2000e",
 				{ &dib0700_usb_id_table[11], NULL },
@@ -1646,6 +1647,10 @@
 				{ &dib0700_usb_id_table[14], NULL },
 				{ NULL },
 			},
+			{   "YUAN High-Tech DiBcom STK7700D",
+				{ &dib0700_usb_id_table[54], NULL },
+				{ NULL },
+			},
 
 		},
 
diff -r b15490457d60 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Aug 01 01:38:01 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Mon Aug 03 12:11:49 2009 +1000
@@ -91,6 +91,7 @@
 #define USB_PID_DIBCOM_STK7700P				0x1e14
 #define USB_PID_DIBCOM_STK7700P_PC			0x1e78
 #define USB_PID_DIBCOM_STK7700D				0x1ef0
+#define USB_PID_DIBCOM_STK7700DY			0x1e8c
 #define USB_PID_DIBCOM_STK7700_U7000			0x7001
 #define USB_PID_DIBCOM_STK7070P				0x1ebc
 #define USB_PID_DIBCOM_STK7070PD			0x1ebe

--=-A7Vzq8IcwO0NaJe3VTou
Content-Disposition: attachment; filename="lsusb.txt"
Content-Type: text/plain; name="lsusb.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Bus 001 Device 004: ID 1164:1e8c YUAN High-Tech Development Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1164 YUAN High-Tech Development Co., Ltd
  idProduct          0x1e8c 
  bcdDevice            1.00
  iManufacturer           1 YUANRD
  iProduct                2 STK7700D
  iSerial                 3 0000000001
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

--=-A7Vzq8IcwO0NaJe3VTou--

