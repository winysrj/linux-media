Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma04.mx.aol.com ([64.12.206.42]:59383 "EHLO
	imr-ma04.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KHUYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 15:24:32 -0500
Received: from mtaout-mb05.r1000.mx.aol.com (mtaout-mb05.r1000.mx.aol.com [172.29.41.69])
	by imr-ma04.mx.aol.com (8.14.1/8.14.1) with ESMTP id qA8KOOb2020788
	for <linux-media@vger.kernel.org>; Thu, 8 Nov 2012 15:24:24 -0500
Received: from [192.168.1.35] (unknown [190.50.16.77])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-mb05.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id DDD7DE0000E4
	for <linux-media@vger.kernel.org>; Thu,  8 Nov 2012 15:24:22 -0500 (EST)
Message-ID: <509C12BA.2030008@netscape.net>
Date: Thu, 08 Nov 2012 17:14:50 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] Add RC support for MyGica X8507 - remote keytable definition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add remote keytable definition

Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>


diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index ab84d66..c6a6ef0 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -76,23 +76,24 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
                        rc-purpletv.o \
                        rc-pv951.o \
                        rc-hauppauge.o \
                        rc-rc6-mce.o \
                        rc-real-audio-220-32-keys.o \
                        rc-snapstream-firefly.o \
                        rc-streamzap.o \
                        rc-tbs-nec.o \
                        rc-technisat-usb2.o \
                        rc-terratec-cinergy-xs.o \
                        rc-terratec-slim.o \
                        rc-terratec-slim-2.o \
                        rc-tevii-nec.o \
                        rc-tivo.o \
                        rc-total-media-in-hand.o \
+                       rc-total-media-in-hand-02.o \
                        rc-trekstor.o \
                        rc-tt-1500.o \
                        rc-twinhan1027.o \
                        rc-videomate-m1f.o \
                        rc-videomate-s350.o \
                        rc-videomate-tv-pvr.o \
                        rc-winfast.o \
                        rc-winfast-usbii-deluxe.o
diff --git a/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c b/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c
new file mode 100644
index 0000000..b109eff
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-total-media-in-hand-02.c
@@ -0,0 +1,86 @@
+/*
+ * Total Media In Hand_02 remote controller keytable for Mygica X8507
+ *
+ * Copyright (C) 2012 Alfredo J. Delaiti <alfredodelaiti@netscape.net>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License along
+ *    with this program; if not, write to the Free Software Foundation, Inc.,
+ *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+
+static struct rc_map_table total_media_in_hand_02[] = {
+       { 0x0000, KEY_0 },
+       { 0x0001, KEY_1 },
+       { 0x0002, KEY_2 },
+       { 0x0003, KEY_3 },
+       { 0x0004, KEY_4 },
+       { 0x0005, KEY_5 },
+       { 0x0006, KEY_6 },
+       { 0x0007, KEY_7 },
+       { 0x0008, KEY_8 },
+       { 0x0009, KEY_9 },
+       { 0x000a, KEY_MUTE },
+       { 0x000b, KEY_STOP },                   /* Stop */
+       { 0x000c, KEY_POWER2 },                 /* Turn on/off application */
+       { 0x000d, KEY_OK },                     /* OK */
+       { 0x000e, KEY_CAMERA },                 /* Snapshot */
+       { 0x000f, KEY_ZOOM },                   /* Full Screen/Restore */
+       { 0x0010, KEY_RIGHT },                  /* Right arrow */
+       { 0x0011, KEY_LEFT },                   /* Left arrow */
+       { 0x0012, KEY_CHANNELUP },
+       { 0x0013, KEY_CHANNELDOWN },
+       { 0x0014, KEY_SHUFFLE },
+       { 0x0016, KEY_PAUSE },
+       { 0x0017, KEY_PLAY },                   /* Play */
+       { 0x001e, KEY_TIME },                   /* Time Shift */
+       { 0x001f, KEY_RECORD },
+       { 0x0020, KEY_UP },
+       { 0x0021, KEY_DOWN },
+       { 0x0025, KEY_POWER },                  /* Turn off computer */
+       { 0x0026, KEY_REWIND },                 /* FR << */
+       { 0x0027, KEY_FASTFORWARD },            /* FF >> */
+       { 0x0029, KEY_ESC },
+       { 0x002b, KEY_VOLUMEUP },
+       { 0x002c, KEY_VOLUMEDOWN },
+       { 0x002d, KEY_CHANNEL },                /* CH Surfing */
+       { 0x0038, KEY_VIDEO },                  /* TV/AV/S-Video/YPbPr */
+};
+
+static struct rc_map_list total_media_in_hand_02_map = {
+       .map = {
+               .scan    = total_media_in_hand_02,
+               .size    = ARRAY_SIZE(total_media_in_hand_02),
+               .rc_type = RC_TYPE_RC5,
+               .name    = RC_MAP_TOTAL_MEDIA_IN_HAND_02,
+       }
+};
+
+static int __init init_rc_map_total_media_in_hand_02(void)
+{
+       return rc_map_register(&total_media_in_hand_02_map);
+}
+
+static void __exit exit_rc_map_total_media_in_hand_02(void)
+{
+       rc_map_unregister(&total_media_in_hand_02_map);
+}
+
+module_init(init_rc_map_total_media_in_hand_02)
+module_exit(exit_rc_map_total_media_in_hand_02)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(" Alfredo J. Delaiti <alfredodelaiti@netscape.net>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 74f55a3..f74ee6f 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -170,28 +170,29 @@ void rc_map_init(void);
 #define RC_MAP_PV951                     "rc-pv951"
 #define RC_MAP_HAUPPAUGE                 "rc-hauppauge"
 #define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_SNAPSTREAM_FIREFLY        "rc-snapstream-firefly"
 #define RC_MAP_STREAMZAP                 "rc-streamzap"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
 #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
 #define RC_MAP_TERRATEC_SLIM             "rc-terratec-slim"
 #define RC_MAP_TERRATEC_SLIM_2           "rc-terratec-slim-2"
 #define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
 #define RC_MAP_TIVO                      "rc-tivo"
 #define RC_MAP_TOTAL_MEDIA_IN_HAND       "rc-total-media-in-hand"
+#define RC_MAP_TOTAL_MEDIA_IN_HAND_02    "rc-total-media-in-hand-02"
 #define RC_MAP_TREKSTOR                  "rc-trekstor"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
 #define RC_MAP_TWINHAN_VP1027_DVBS       "rc-twinhan1027"
 #define RC_MAP_VIDEOMATE_K100            "rc-videomate-k100"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
 
 /*
  * Please, do not just append newer Remote Controller names at the end.
  * The names should be ordered in alphabetical order
  */


-- 
Dona tu voz
http://www.voxforge.org/es
