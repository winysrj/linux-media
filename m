Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:59390 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZDZWNX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 18:13:23 -0400
To: linux-media@vger.kernel.org
Date: Sun, 26 Apr 2009 22:11:15 +0200 (CEST)
From: =?us-ascii?Q?tomas=20petr?= <tom-petr@seznam.cz>
Subject: =?us-ascii?Q?=5BPATCH=5D=20Leadtek=20WinFast=20DTV=20Dongle=20H?=
Mime-Version: 1.0
Message-Id: <62.15-8877-1988000526-1240776675@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Leadtek WinFast DTV Dongle H" is a hybrid digital/analog USB-stick TV receiver. The code below allows the digital part to work with dvb_usb in linux.

in /linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h add a new device number
--- dvb-usb-ids.h.old   2009-04-26 22:02:14.000000000 +0200
+++ dvb-usb-ids.h       2009-04-26 21:17:14.000000000 +0200
@@ -224,6 +224,8 @@
 #define USB_PID_WINFAST_DTV_DONGLE_COLD                        0x6025
 #define USB_PID_WINFAST_DTV_DONGLE_WARM                        0x6026
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P            0x6f00
+/* added */
+#define USB_PID_WINFAST_DTV_DONGLE_H                   0x60f6
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2          0x6f01
 #define USB_PID_WINFAST_DTV_DONGLE_GOLD                        0x6029

 #define USB_PID_GENPIX_8PSK_REV_1_COLD                 0x0200


in ./linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- dib0700_devices.c.old       2009-04-26 22:07:12.000000000 +0200
+++ dib0700_devices.c   2009-04-26 21:26:44.000000000 +0200
@@ -1498,6 +1498,8 @@ struct usb_device_id dib0700_usb_id_tabl
        { USB_DEVICE(USB_VID_YUAN,      USB_PID_YUAN_MC770) },
        { USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DTT) },
 /* 50 */{ USB_DEVICE(USB_VID_ELGATO,   USB_PID_ELGATO_EYETV_DTT_Dlx) },
+       /* added */
+/* 51 */{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_H) },
        { 0 }           /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1821,7 +1823,7 @@ struct dvb_usb_device_properties dib0700
                        },
                },

-               .num_device_descs = 7,
+               .num_device_descs = 8,
                .devices = {
                        {   "Terratec Cinergy HT USB XE",
                                { &dib0700_usb_id_table[27], NULL },
@@ -1851,6 +1853,11 @@ struct dvb_usb_device_properties dib0700
                                { &dib0700_usb_id_table[48], NULL },
                                { NULL },
                        },
+                       /* added */
+                       {   "Leadtek WinFast DTV Dongle H",
+                               { &dib0700_usb_id_table[51], NULL },
+                               { NULL },
+                       },
                },
                .rc_interval      = DEFAULT_RC_INTERVAL,
                .rc_key_map       = dib0700_rc_keys,




I am not the author of this code (the original author is maybe here http://www.pslib.cz/petr.cvek/?), but as the patch lies around the net for a year or even longer and it did not find its way to the v4l-dvb yet, I try to send it myself. I hope it might help to someone.

Tomas
