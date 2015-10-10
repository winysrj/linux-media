Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 02/26] [media] tuner.h: Make checkpatch.pl happier
Date: Sat, 10 Oct 2015 10:35:45 -0300
Message-Id: <62e93f090b0903def1d7455c311c50b9e6f38ef2.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove some bad whitespaces before tabs and fix the initial
comment to be compliant with Kernel coding style.

Now, the only complains are about long comment lines at the
defines. Those warnings should be ok to be kept.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/tuner.h b/include/media/tuner.h
index 4445dcbfdb80..486b6a54363b 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -1,23 +1,19 @@
 /*
-    tuner.h - definition for different tuners
-
-    Copyright (C) 1997 Markus Schroeder (schroedm@uni-duesseldorf.de)
-    minor modifications by Ralph Metzler (rjkm@thp.uni-koeln.de)
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
+ * tuner.h - definition for different tuners
+ *
+ * Copyright (C) 1997 Markus Schroeder (schroedm@uni-duesseldorf.de)
+ * minor modifications by Ralph Metzler (rjkm@thp.uni-koeln.de)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
 
 #ifndef _TUNER_H
 #define _TUNER_H
@@ -83,8 +79,11 @@
 #define TUNER_PHILIPS_FM1236_MK3	43
 
 #define TUNER_PHILIPS_4IN1		44	/* ATI TV Wonder Pro - Conexant */
-/* Microtune merged with Temic 12/31/1999 partially financed by Alps - these may be similar to Temic */
-#define TUNER_MICROTUNE_4049FM5 	45
+	/*
+	 * Microtune merged with Temic 12/31/1999 partially financed by Alps.
+	 * these may be similar to Temic
+	 */
+#define TUNER_MICROTUNE_4049FM5		45
 #define TUNER_PANASONIC_VP27		46
 #define TUNER_LG_NTSC_TAPE		47
 
@@ -115,11 +114,11 @@
 
 #define TUNER_PHILIPS_TUV1236D		68	/* ATI HDTV Wonder */
 #define TUNER_TNF_5335MF                69	/* Sabrent Bt848   */
-#define TUNER_SAMSUNG_TCPN_2121P30A     70 	/* Hauppauge PVR-500MCE NTSC */
+#define TUNER_SAMSUNG_TCPN_2121P30A     70	/* Hauppauge PVR-500MCE NTSC */
 #define TUNER_XC2028			71
 
 #define TUNER_THOMSON_FE6600		72	/* DViCO FusionHDTV DVB-T Hybrid */
-#define TUNER_SAMSUNG_TCPG_6121P30A     73 	/* Hauppauge PVR-500 PAL */
+#define TUNER_SAMSUNG_TCPG_6121P30A     73	/* Hauppauge PVR-500 PAL */
 #define TUNER_TDA9887                   74      /* This tuner should be used only internally */
 #define TUNER_TEA5761			75	/* Only FM Radio Tuner */
 #define TUNER_XC5000			76	/* Xceive Silicon Tuner */
@@ -143,25 +142,26 @@
 #define TUNER_SONY_BTF_PB463Z		91	/* NTSC */
 
 /* tv card specific */
-#define TDA9887_PRESENT 		(1<<0)
-#define TDA9887_PORT1_INACTIVE 		(1<<1)
-#define TDA9887_PORT2_INACTIVE 		(1<<2)
-#define TDA9887_QSS 			(1<<3)
-#define TDA9887_INTERCARRIER 		(1<<4)
-#define TDA9887_PORT1_ACTIVE 		(1<<5)
-#define TDA9887_PORT2_ACTIVE 		(1<<6)
-#define TDA9887_INTERCARRIER_NTSC 	(1<<7)
+#define TDA9887_PRESENT			(1<<0)
+#define TDA9887_PORT1_INACTIVE		(1<<1)
+#define TDA9887_PORT2_INACTIVE		(1<<2)
+#define TDA9887_QSS			(1<<3)
+#define TDA9887_INTERCARRIER		(1<<4)
+#define TDA9887_PORT1_ACTIVE		(1<<5)
+#define TDA9887_PORT2_ACTIVE		(1<<6)
+#define TDA9887_INTERCARRIER_NTSC	(1<<7)
 /* Tuner takeover point adjustment, in dB, -16 <= top <= 15 */
-#define TDA9887_TOP_MASK 		(0x3f << 8)
-#define TDA9887_TOP_SET 		(1 << 13)
-#define TDA9887_TOP(top) 		(TDA9887_TOP_SET | (((16 + (top)) & 0x1f) << 8))
+#define TDA9887_TOP_MASK		(0x3f << 8)
+#define TDA9887_TOP_SET			(1 << 13)
+#define TDA9887_TOP(top)		(TDA9887_TOP_SET | \
+					 (((16 + (top)) & 0x1f) << 8))
 
 /* config options */
-#define TDA9887_DEEMPHASIS_MASK 	(3<<16)
-#define TDA9887_DEEMPHASIS_NONE 	(1<<16)
-#define TDA9887_DEEMPHASIS_50 		(2<<16)
-#define TDA9887_DEEMPHASIS_75 		(3<<16)
-#define TDA9887_AUTOMUTE 		(1<<18)
+#define TDA9887_DEEMPHASIS_MASK		(3<<16)
+#define TDA9887_DEEMPHASIS_NONE		(1<<16)
+#define TDA9887_DEEMPHASIS_50		(2<<16)
+#define TDA9887_DEEMPHASIS_75		(3<<16)
+#define TDA9887_AUTOMUTE		(1<<18)
 #define TDA9887_GATING_18		(1<<19)
 #define TDA9887_GAIN_NORMAL		(1<<20)
 #define TDA9887_RIF_41_3		(1<<21)  /* radio IF1 41.3 vs 33.3 */
@@ -183,7 +183,7 @@
 enum tuner_mode {
 	T_RADIO		= 1 << V4L2_TUNER_RADIO,
 	T_ANALOG_TV     = 1 << V4L2_TUNER_ANALOG_TV,
-	/* Don't need to map V4L2_TUNER_DIGITAL_TV, as tuner-core won't use it */
+	/* Don't map V4L2_TUNER_DIGITAL_TV, as tuner-core won't use it */
 };
 
 /**
@@ -227,7 +227,7 @@ struct tuner_setup {
 	unsigned int	type;
 	unsigned int	mode_mask;
 	void		*config;
-	int (*tuner_callback) (void *dev, int component, int cmd, int arg);
+	int (*tuner_callback)(void *dev, int component, int cmd, int arg);
 };
 
 #endif /* __KERNEL__ */
-- 
2.4.3


