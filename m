Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward9.mail.yandex.net ([77.88.61.48]:56252 "HELO
	forward9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932646AbZLMBRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 20:17:23 -0500
Message-ID: <4B239C27.2040201@yandex.ru>
Date: Sat, 12 Dec 2009 15:35:35 +0200
From: geroin22 <geroin22@yandex.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, stoth@linuxtv.org
Subject: [PATCH] Analog TV for Compro E800 and cx23885-alsa
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve

Use your cx23885-alsa tree and this message 
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/13481, 
I have analog TV for Compro E800 now. But I have no sound on some PAL 
channels (maybe they have stereo sound, or some other).   
Tested with Tvtime and mplayer.
Other inputs not tested.


diff -Naur a/linux/drivers/media/video/cx23885/cx23885-cards.c 
b/linux/drivers/media/video/cx23885/cx23885-cards.c
--- a/linux/drivers/media/video/cx23885/cx23885-cards.c    2009-11-27 
16:52:15.000000000 +0200
+++ b/linux/drivers/media/video/cx23885/cx23885-cards.c    2009-12-12 
15:26:41.370488942 +0200
@@ -287,7 +287,29 @@
     },
     [CX23885_BOARD_COMPRO_VIDEOMATE_E800] = {
         .name        = "Compro VideoMate E800",
-        .portc        = CX23885_MPEG_DVB,
+        .porta        = CX23885_ANALOG_VIDEO,
+         .portc        = CX23885_MPEG_DVB,
+        .tuner_type    = TUNER_XC2028,
+        .tuner_addr    = 0x61,
+        .input        = {
+            {
+                .type   = CX23885_VMUX_TELEVISION,
+                .vmux   = CX25840_COMPOSITE2,
+            }, {
+                .type   = CX23885_VMUX_COMPOSITE1,
+                .vmux   = CX25840_COMPOSITE8,
+            }, {
+                .type   = CX23885_VMUX_SVIDEO,
+                .vmux   = CX25840_SVIDEO_LUMA3 |
+                    CX25840_SVIDEO_CHROMA4,
+            }, {
+                .type   = CX23885_VMUX_COMPONENT,
+                .vmux   = CX25840_COMPONENT_ON |
+                    CX25840_VIN1_CH1 |
+                    CX25840_VIN6_CH2 |
+                    CX25840_VIN7_CH3,
+            },
+        },
     },
     [CX23885_BOARD_HAUPPAUGE_HVR1290] = {
         .name        = "Hauppauge WinTV-HVR1290",




                                             

