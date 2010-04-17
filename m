Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.meta.ua ([194.0.131.41]:55306 "EHLO smtp.meta.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab0DQPPh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 11:15:37 -0400
Received: from 198-147-92-178.pool.ukrtel.net ([178.92.147.198]:54777)
	by smtp.meta.ua with esmtpsa id 1O39Rc-0001BP-0J by authid <geroin22@meta.ua>
	for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 17:56:28 +0300
Message-ID: <4BC9CC02.5060305@meta.ua>
Date: Sat, 17 Apr 2010 17:56:02 +0300
From: "geroin22@meta.ua " <geroin22@meta.ua>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Add support analog part of Compro Videomate E800
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Vladimir Geroy geroin22@yandex.ru

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
