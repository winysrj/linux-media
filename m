Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56225 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0L2JsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 04:48:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LE6009GJOKLRY80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Dec 2010 09:48:22 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LE6004Z6OKK2M@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Dec 2010 09:48:21 +0000 (GMT)
Date: Wed, 29 Dec 2010 10:48:16 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/2] v4l: saa7134: remove radio, vbi, mpeg, input, alsa,
 tvaudio, saa6752hs support
In-reply-to: <1293616097-24167-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1293616097-24167-2-git-send-email-s.nawrocki@samsung.com>
References: <1293616097-24167-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch is meant for the videobuf2 testing purposes only,
until there exist more complete vb2 based driver for a widely
available hardware.

Signed-off: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/saa7134/Makefile        |    8 +-
 drivers/media/video/saa7134/saa7134-cards.c | 1415 ++++++++++-----------------
 drivers/media/video/saa7134/saa7134-core.c  |  165 +---
 drivers/media/video/saa7134/saa7134-video.c |  299 +-----
 drivers/media/video/saa7134/saa7134.h       |   35 +-
 5 files changed, 571 insertions(+), 1351 deletions(-)

diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 8a5ff4d..c0fc84de 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -1,14 +1,8 @@
 
 saa7134-y :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o
-saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
 saa7134-y +=	saa7134-video.o
-saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-input.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
-
-obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
-
-obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa7134.o
 
 EXTRA_CFLAGS += -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index e7aa588..359c6bd 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -36,7 +36,6 @@
 
 /* commly used strings */
 static char name_mute[]    = "mute";
-static char name_radio[]   = "Radio";
 static char name_tv[]      = "Television";
 static char name_tv_mono[] = "TV (mono only)";
 static char name_comp[]    = "Composite";
@@ -57,9 +56,8 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "UNKNOWN/GENERIC",
 		.audio_clock	= 0x00187de7,
 		.tuner_type	= TUNER_ABSENT,
-		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.inputs         = {{
 			.name = "default",
@@ -72,9 +70,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "Proteus Pro [philips reference design]",
 		.audio_clock	= 0x00187de7,
 		.tuner_type	= TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.inputs         = {{
 			.name = name_comp1,
@@ -91,19 +89,16 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.tv   = 1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_FLYVIDEO3000] = {
 		/* "Marco d'Itri" <md@Linux.IT> */
 		.name		= "LifeView FlyVIDEO3000",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.gpiomask       = 0xe000,
 		.inputs         = {{
@@ -134,11 +129,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x2000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -150,9 +141,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView/Typhoon FlyVIDEO2000",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.gpiomask       = 0xe000,
 		.inputs         = {{
@@ -177,11 +168,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x2000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE2,
@@ -193,9 +180,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView FlyTV Platinum Mini",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.inputs         = {{
 			.name = name_tv,
@@ -222,9 +209,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView FlyTV Platinum FM / Gold",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.gpiomask       = 0x1E000,	/* Set GP16 and unused 15,14,13 to Output */
 		.inputs         = {{
@@ -255,11 +242,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 /*			.gpio = 0x4000,         */
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x00000,	/* GP16=0 selects FM radio antenna */
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -272,9 +255,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "RoverMedia TV Link Pro FM",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3, /* TCL MFPE05 2 */
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0xe000,
 		.inputs         = { {
@@ -305,25 +288,15 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x4000,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x2000,
-		},
-		.mute = {
-			.name = name_mute,
-			.amux = TV,
-			.gpio = 0x8000,
-		},
 	},
 	[SAA7134_BOARD_EMPRESS] = {
 		/* "Gert Vervoort" <gert.vervoort@philips.com> */
 		.name		= "EMPRESS",
 		.audio_clock	= 0x00187de7,
 		.tuner_type	= TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.empress_addr 	= 0x20,
 
 		.inputs         = {{
@@ -340,10 +313,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.tv   = 1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 		.mpeg      = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 	},
@@ -352,9 +322,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "SKNet Monster TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC_M,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.inputs         = {{
 			.name = name_tv,
@@ -370,18 +340,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_MD9717] = {
 		.name		= "Tevion MD 9717",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -406,10 +373,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	       .mute = {
 		       .name = name_mute,
 		       .amux = TV,
@@ -420,9 +384,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "KNC One TV-Station RDS / Typhoon TV Tuner RDS",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -449,18 +413,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 0,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_TVSTATION_DVR] = {
 		.name		= "KNC One TV-Station DVR",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.empress_addr 	= 0x20,
 		.tda9887_conf	= TDA9887_PRESENT,
 		.gpiomask	= 0x820000,
@@ -481,11 +442,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x20000,
 		}},
-		.radio		= {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x20000,
-		},
+
 		.mpeg           = SAA7134_MPEG_EMPRESS,
 		.video_out	= CCIR656,
 	},
@@ -493,9 +450,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Terratec Cinergy 400 TV",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -519,9 +476,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Medion 5044",
 		.audio_clock    = 0x00187de7, /* was: 0x00200000, */
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -547,18 +504,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_KWORLD] = {
 		.name           = "Kworld/KuroutoShikou SAA7130-TVPCI",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC_M,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -578,9 +532,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Terratec Cinergy 600 TV",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -600,18 +554,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 0,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_MD7134] = {
 		.name           = "Medion 7134",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
@@ -628,10 +579,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE2,
-	       },
+
 	       .mute = {
 		       .name = name_mute,
 		       .amux = TV,
@@ -643,9 +591,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Typhoon TV+Radio 90031",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name   = name_tv,
@@ -661,18 +609,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_ELSA] = {
 		.name           = "ELSA EX-VISION 300TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_HITACHI_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -692,9 +637,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ELSA EX-VISION 500TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_HITACHI_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 7,
@@ -715,9 +660,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ELSA EX-VISION 700TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_HITACHI_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 4,
@@ -741,9 +686,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ASUS TV-FM 7134",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -759,18 +704,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 6,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-		},
+
 	},
 	[SAA7134_BOARD_ASUSTeK_TVFM7135] = {
 		.name           = "ASUS TV-FM 7135",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x200000,
 		.inputs         = {{
 			.name = name_tv,
@@ -789,11 +731,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x0000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x200000,
-		},
+
 		.mute  = {
 			.name = name_mute,
 			.gpio = 0x0000,
@@ -804,9 +742,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AOPEN VA1000 POWER",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -827,9 +765,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "10MOONS PCI TV CAPTURE CARD",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0xe000,
 		.inputs         = {{
 			.name = name_tv,
@@ -853,11 +791,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x2000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE2,
@@ -869,9 +803,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "BMK MPEX No Tuner",
 		.audio_clock	= 0x200000,
 		.tuner_type	= TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.empress_addr 	= 0x20,
 		.inputs         = {{
 			.name = name_comp1,
@@ -901,9 +835,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Compro VideoMate TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC_M,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -924,9 +858,9 @@ struct saa7134_board saa7134_boards[] = {
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC_M,
 		.gpiomask       = 0x800c0000,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -956,9 +890,9 @@ struct saa7134_board saa7134_boards[] = {
 		*/
 		.name           = "Matrox CronosPlus",
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0xcf00,
 		.inputs         = {{
 			.name = name_comp1,
@@ -986,9 +920,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AverMedia M156 / Medion 2819",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask	= 0x03,
 		.inputs         = {{
@@ -1013,11 +947,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x02,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-			.gpio = 0x01,
-		},
+
 		.mute  = {
 			.name = name_mute,
 			.amux = TV,
@@ -1029,9 +959,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "BMK MPEX Tuner",
 		.audio_clock    = 0x200000,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.empress_addr 	= 0x20,
 		.inputs         = {{
 			.name = name_comp1,
@@ -1056,9 +986,9 @@ struct saa7134_board saa7134_boards[] = {
 		/* probably wrong, the 7133 one is the NTSC version ...
 		* .tuner_type  = TUNER_PHILIPS_FM1236_MK3 */
 		.tuner_type     = TUNER_LG_NTSC_NEW_TAPC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -1075,18 +1005,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 6,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-		},
+
 	},
 	[SAA7134_BOARD_PINNACLE_PCTV_STEREO] = {
 		.name           = "Pinnacle PCTV Stereo (saa7134)",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_MT2032,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_INTERCARRIER | TDA9887_PORT2_INACTIVE,
 		.inputs         = {{
 			.name = name_tv,
@@ -1112,9 +1039,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Manli MuchTV M-TV002",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -1129,19 +1056,16 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.tv   = 1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_MANLI_MTV001] = {
 		/* Ognjen Nastic <ognjen@logosoft.ba> UNTESTED */
 		.name           = "Manli MuchTV M-TV001",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -1166,9 +1090,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Nagase Sangyo TransGear 3000TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC_M,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -1188,9 +1112,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Elitegroup ECS TVP3XP FM1216 Tuner Card(PAL-BG,FM) ",
 		.audio_clock    = 0x187de7,  /* xtal 32.1 MHz */
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name   = name_tv,
 			.vmux   = 1,
@@ -1214,18 +1138,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 0,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_ECS_TVP3XP_4CB5] = {
 		.name           = "Elitegroup ECS TVP3XP FM1236 Tuner Card (NTSC,FM)",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name   = name_tv,
 			.vmux   = 1,
@@ -1249,19 +1170,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 0,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE2,
-		},
+
 	},
     [SAA7134_BOARD_ECS_TVP3XP_4CB6] = {
 		/* Barry Scott <barry.scott@onelan.co.uk> */
 		.name		= "Elitegroup ECS TVP3XP FM1246 Tuner Card (PAL,FM)",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_PHILIPS_PAL_I,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name   = name_tv,
 			.vmux   = 1,
@@ -1285,19 +1203,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 0,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_AVACSSMARTTV] = {
 		/* Roman Pszonczenko <romka@kolos.math.uni.lodz.pl> */
 		.name           = "AVACS SmartTV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -1321,20 +1236,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x200000,
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_DVD_EZMAKER] = {
 		/* Michael Smith <msmith@cbnco.com> */
 		.name           = "AVerMedia DVD EZMaker",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_comp1,
 			.vmux = 3,
@@ -1348,9 +1259,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AVerMedia MiniPCI DVB-T Hybrid M103",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		 .mpeg           = SAA7134_MPEG_DVB,
 		 .inputs         = {{
 			 .name = name_tv,
@@ -1364,9 +1275,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Noval Prime TV 7133",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_ALPS_TSBH1_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_comp1,
 			.vmux = 3,
@@ -1384,9 +1295,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AverMedia AverTV Studio 305",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1256_IH3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -1406,10 +1317,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE1,
@@ -1420,9 +1328,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AverMedia AverTV Studio 505",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {
 			.name = name_tv,
@@ -1442,10 +1350,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE1,
@@ -1455,9 +1360,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "UPMOST PURPLE TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1236_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -1475,9 +1380,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Items MuchTV Plus / IT-005",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 3,
@@ -1492,18 +1397,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_CINERGY200] = {
 		.name           = "Terratec Cinergy 200 TV",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -1532,9 +1434,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Compro VideoMate TV PVR/FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC_M,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask	= 0x808c0080,
 		.inputs         = {{
 			.name = name_svideo,
@@ -1553,11 +1455,7 @@ struct saa7134_board saa7134_boards[] = {
 			.tv   = 1,
 			.gpio = 0x00080,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x80000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE2,
@@ -1569,9 +1467,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Sabrent SBT-TVFM (saa7130)",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC_M,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_comp1,
 			.vmux = 1,
@@ -1586,19 +1484,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_ZOLID_XPERT_TV7134] = {
 		/* Helge Jensen <helge.jensen@slog.dk> */
 		.name           = ":Zolid Xpert TV7134",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_svideo,
 			.vmux = 8,
@@ -1619,9 +1514,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Empire PCI TV-Radio LE",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x4000,
 		.inputs         = {{
 			.name = name_tv_mono,
@@ -1640,11 +1535,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x8000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-			.gpio = 0x8000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -1659,9 +1550,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia AVerTV Studio 307",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1256_IH3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x03,
 		.inputs         = {{
@@ -1681,11 +1572,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x02,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-			.gpio = 0x01,
-		},
+
 		.mute  = {
 			.name = name_mute,
 			.amux = LINE1,
@@ -1696,9 +1583,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia AVerTV GO 007 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x00300003,
 		/* .gpiomask       = 0x8c240003, */
 		.inputs         = {{
@@ -1718,11 +1605,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x02,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x00300001,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -1734,9 +1617,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AVerMedia Cardbus TV/Radio (E500)",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -1751,19 +1634,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_CARDBUS_501] = {
 		/* Oldrich Jedlicka <oldium.pro@seznam.cz> */
 		.name           = "AVerMedia Cardbus TV/Radio (E501R)",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_ALPS_TSBE5_PAL,
-		.radio_type     = TUNER_TEA5767,
+
 		.tuner_addr	= 0x61,
-		.radio_addr	= 0x60,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x08000000,
 		.inputs         = { {
@@ -1783,19 +1663,15 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x08000000,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x00000000,
-		},
+
 	},
 	[SAA7134_BOARD_CINERGY400_CARDBUS] = {
 		.name           = "Terratec Cinergy 400 mobile",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_ALPS_TSBE5_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -1821,9 +1697,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Terratec Cinergy 600 TV MK3",
 		.audio_clock    = 0x00200000,
 		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
@@ -1844,19 +1720,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 0,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_VIDEOMATE_GOLD_PLUS] = {
 		/* Dylan Walkden <dylan_walkden@hotmail.com> */
 		.name		= "Compro VideoMate Gold+ Pal",
 		.audio_clock	= 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_PAL,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask	= 0x1ce780,
 		.inputs		= {{
 			.name = name_svideo,
@@ -1875,11 +1748,7 @@ struct saa7134_board saa7134_boards[] = {
 			.tv   = 1,
 			.gpio = 0x008080,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x80000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE2,
@@ -1890,9 +1759,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Pinnacle PCTV 300i DVB-T + PAL",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_MT2032,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_INTERCARRIER | TDA9887_PORT2_INACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -1919,9 +1788,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "ProVideo PV952",
 		.audio_clock	= 0x00187de7,
 		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_comp1,
@@ -1938,10 +1807,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.tv   = 1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_305] = {
 		/* much like the "studio" version but without radio
@@ -1949,9 +1815,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AverMedia AverTV/305",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FQ1216ME,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -1982,9 +1848,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView FlyDVB-T DUO / MSI TV@nywhere Duo",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask	= 0x00200000,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -2006,19 +1872,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
-		},
+
 	},
 	[SAA7134_BOARD_PHILIPS_TOUGH] = {
 		.name           = "Philips TOUGH DVB-T reference design",
 		.tuner_type	= TUNER_ABSENT,
 		.audio_clock    = 0x00187de7,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_comp1,
@@ -2037,9 +1899,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia AVerTV 307",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FQ1216ME,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -2064,9 +1926,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ADS Tech Instant TV (saa7135)",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -2086,9 +1948,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Kworld/Tevion V-Stream Xpert TV PVR7134",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_PAL_I,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask	= 0x0700,
 		.inputs = {{
 			.name   = name_tv,
@@ -2107,11 +1969,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE1,
-			.gpio   = 0x100,
-		},
+
 		.mute  = {
 			.name = name_mute,
 			.amux = TV,
@@ -2122,9 +1980,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "LifeView/Typhoon/Genius FlyDVB-T Duo Cardbus",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask	= 0x00200000,
 		.inputs         = {{
@@ -2146,19 +2004,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 3,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
-		},
+
 	},
 	[SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII] = {
 		.name           = "Compro VideoMate TV Gold+II",
 		.audio_clock    = 0x002187de7,
 		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
-		.radio_type     = TUNER_TEA5767,
+
 		.tuner_addr     = 0x63,
-		.radio_addr     = 0x60,
+
 		.gpiomask       = 0x8c1880,
 		.inputs         = {{
 			.name = name_svideo,
@@ -2177,11 +2031,7 @@ struct saa7134_board saa7134_boards[] = {
 			.tv   = 1,
 			.gpio = 0x800000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x880000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE2,
@@ -2201,9 +2051,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Kworld Xpert TV PVR7134",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_TENA_9533_DI,
-		.radio_type     = TUNER_TEA5767,
+
 		.tuner_addr	= 0x61,
-		.radio_addr	= 0x60,
+
 		.gpiomask	= 0x0700,
 		.inputs = {{
 			.name   = name_tv,
@@ -2222,11 +2072,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE1,
-			.gpio   = 0x100,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -2237,9 +2083,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "FlyTV mini Asus Digimatrix",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_LG_TALN,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -2263,10 +2109,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,		/* radio unconfirmed */
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_KWORLD_TERMINATOR] = {
 		/* Kworld V-Stream Studio TV Terminator */
@@ -2274,9 +2117,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "V-Stream Studio TV Terminator",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.gpiomask       = 1 << 21,
 		.inputs         = {{
 			.name = name_tv,
@@ -2295,11 +2138,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x0000000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_YUAN_TUN900] = {
 		/* FIXME:
@@ -2310,9 +2149,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Yuan TUN-900 (saa7135)",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr= ADDR_UNSET,
-		.radio_addr= ADDR_UNSET,
+
 		.gpiomask       = 0x00010003,
 		.inputs         = {{
 			.name = name_tv,
@@ -2331,11 +2170,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x02,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-			.gpio = 0x00010003,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -2349,9 +2184,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 409 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -2368,10 +2203,7 @@ struct saa7134_board saa7134_boards[] = {
 			  .vmux = 8,
 			  .amux = LINE1,
 		}},
-		.radio = {
-			  .name = name_radio,
-			  .amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_GOTVIEW_7135] = {
 		/* Mike Baikov <mike@baikov.com> */
@@ -2379,9 +2211,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name            = "GoTView 7135 PCI",
 		.audio_clock     = 0x00187de7,
 		.tuner_type      = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type      = UNSET,
+
 		.tuner_addr      = ADDR_UNSET,
-		.radio_addr      = ADDR_UNSET,
+
 		.tda9887_conf    = TDA9887_PRESENT,
 		.gpiomask        = 0x00200003,
 		.inputs          = {{
@@ -2406,11 +2238,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x00200003,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x00200003,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -2421,9 +2249,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Philips EUROPA V3 reference design",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TD1316,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= 0x61,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
@@ -2445,9 +2273,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Compro Videomate DVB-T300",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TD1316,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= 0x61,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
@@ -2469,9 +2297,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Compro Videomate DVB-T200",
 		.tuner_type	= TUNER_ABSENT,
 		.audio_clock    = 0x00187de7,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_comp1,
@@ -2487,9 +2315,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "RTD Embedded Technologies VFG7350",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_ABSENT,
-		.radio_type	= UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.empress_addr 	= 0x21,
 		.inputs		= {{
 			.name   = "Composite 0",
@@ -2527,9 +2355,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "RTD Embedded Technologies VFG7330",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_ABSENT,
-		.radio_type	= UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs		= {{
 			.name   = "Composite 0",
 			.vmux   = 0,
@@ -2560,9 +2388,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView FlyTV Platinum Mini2",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.inputs         = {{
 			.name = name_tv,
@@ -2592,9 +2420,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AVerMedia AVerTVHD MCE A180",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
 			.name = name_comp1,
@@ -2610,9 +2438,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "SKNet MonsterTV Mobile",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 
 		.inputs         = {{
 			  .name = name_tv,
@@ -2633,9 +2461,9 @@ struct saa7134_board saa7134_boards[] = {
 	       .name           = "Pinnacle PCTV 40i/50i/110i (saa7133)",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.gpiomask       = 0x080200000,
 		.inputs         = { {
 			.name = name_tv,
@@ -2655,19 +2483,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_ASUSTeK_P7131_DUAL] = {
 		.name           = "ASUSTeK P7131 Dual",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask	= 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -2692,11 +2516,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_SEDNA_PC_TV_CARDBUS] = {
 		/* Paul Tom Zalac <pzalac@gmail.com> */
@@ -2705,9 +2525,9 @@ struct saa7134_board saa7134_boards[] = {
 				/* Sedna/MuchTV (OEM) Cardbus TV Tuner */
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.gpiomask       = 0xe880c0,
 		.inputs         = {{
 			.name = name_tv,
@@ -2723,10 +2543,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 6,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_ASUSTEK_DIGIMATRIX_TV] = {
 		/* "Cyril Lacoux (Yack)" <clacoux@ifeelgood.org> */
@@ -2734,9 +2551,9 @@ struct saa7134_board saa7134_boards[] = {
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_FQ1216ME,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -2756,9 +2573,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Philips Tiger reference design",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
@@ -2776,19 +2593,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_MSI_TVATANYWHERE_PLUS] = {
 		.name           = "MSI TV@Anywhere plus",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 1 << 21,
 		.inputs = {{
 			.name   = name_tv,
@@ -2808,11 +2621,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE2,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_CINERGY250PCI] = {
 		/* remote-control does not work. The signal about a
@@ -2822,9 +2631,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Terratec Cinergy 250 PCI TV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x80200000,
 		.inputs         = {{
 			.name = name_tv,
@@ -2836,11 +2645,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_FLYDVB_TRIO] = {
 		/* LifeView LR319 FlyDVB Trio */
@@ -2848,9 +2653,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView FlyDVB Trio",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask	= 0x00200000,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -2872,19 +2677,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 3,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_777] = {
 		.name           = "AverTV DVB-T 777",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_comp1,
@@ -2902,9 +2703,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView FlyDVB-T / Genius VideoWonder DVB-T",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
 			.name = name_comp1,	/* Composite input */
@@ -2920,9 +2721,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ADS Instant TV Duo Cardbus PTV331",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x00600000, /* Bit 21 0=Radio, Bit 22 0=TV */
 		.inputs = {{
@@ -2937,9 +2738,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Tevion/KWorld DVB-T 220RF",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 1 << 21,
 		.inputs = {{
@@ -2960,19 +2761,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_KWORLD_DVBT_210] = {
 		.name           = "KWorld DVB-T 210",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 1 << 21,
 		.inputs = {{
@@ -2989,19 +2786,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_KWORLD_ATSC110] = {
 		.name           = "Kworld ATSC110/115",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TUV1236D,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -3027,9 +2820,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "AVerMedia A169 B",
 		.audio_clock    = 0x02187de7,
 		.tuner_type	= TUNER_LG_TALN,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x0a60000,
 	},
@@ -3039,9 +2832,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "AVerMedia A169 B1",
 		.audio_clock    = 0x02187de7,
 		.tuner_type	= TUNER_LG_TALN,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0xca60000,
 		.inputs         = {{
@@ -3064,18 +2857,18 @@ struct saa7134_board saa7134_boards[] = {
 		/* The second saa7134 on this card only serves as DVB-S host bridge */
 		.name           = "Medion 7134 Bridge #2",
 		.audio_clock    = 0x00187de7,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 	},
 	[SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS] = {
 		.name		= "LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x00600000, /* Bit 21 0=Radio, Bit 22 0=TV */
 		.inputs         = {{
@@ -3097,20 +2890,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 3,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
-		},
+
 	},
 	[SAA7134_BOARD_FLYVIDEO3000_NTSC] = {
 		/* "Zac Bowling" <zac@zacbowling.com> */
 		.name           = "LifeView FlyVIDEO3000 (NTSC)",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_NTSC,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 
 		.gpiomask       = 0xe000,
 		.inputs         = {{
@@ -3141,11 +2930,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x2000,
-		},
+
 			.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -3156,9 +2941,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Medion Md8800 Quadro",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
@@ -3181,9 +2966,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "LifeView FlyDVB-S /Acorp TV134DS",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
 			.name = name_comp1,	/* Composite input */
@@ -3199,9 +2984,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Proteus Pro 2309",
 		.audio_clock    = 0x00187de7,
 		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -3231,9 +3016,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "AVerMedia TV Hybrid A16AR",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_PHILIPS_TD1316, /* untested */
-		.radio_type     = TUNER_TEA5767, /* untested */
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = 0x60,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -3250,18 +3035,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-		},
+
 	},
 	[SAA7134_BOARD_ASUS_EUROPA2_HYBRID] = {
 		.name           = "Asus Europa2 OEM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT| TDA9887_PORT1_ACTIVE | TDA9887_PORT2_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
@@ -3278,18 +3060,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE2,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE1,
-		},
+
 	},
 	[SAA7134_BOARD_PINNACLE_PCTV_310i] = {
 		.name           = "Pinnacle PCTV 310i",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 1,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x000200000,
@@ -3311,20 +3091,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_STUDIO_507] = {
 		/* Mikhail Fedotov <mo_fedotov@mail.ru> */
 		.name           = "Avermedia AVerTV Studio 507",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1256_IH3,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x03,
 		.inputs         = {{
@@ -3349,11 +3125,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x00,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x01,
-		},
+
 		.mute  = {
 			.name = name_mute,
 			.amux = LINE1,
@@ -3365,9 +3137,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Compro Videomate DVB-T200A",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
@@ -3391,9 +3163,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Hauppauge WinTV-HVR1110 DVB-T/Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 1,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200100,
@@ -3412,19 +3185,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0200100,
-		},
+
 	},
 	[SAA7134_BOARD_HAUPPAUGE_HVR1150] = {
 		.name           = "Hauppauge WinTV-HVR1150 ATSC/QAM-Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 3,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_SERIAL,
@@ -3445,19 +3215,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0800100, /* GPIO 23 HI for FM */
-		},
+
 	},
 	[SAA7134_BOARD_HAUPPAUGE_HVR1120] = {
 		.name           = "Hauppauge WinTV-HVR1120 DVB-T/Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 3,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_SERIAL,
@@ -3477,19 +3244,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0800100, /* GPIO 23 HI for FM */
-		},
+
 	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {
 		.name           = "Terratec Cinergy HT PCMCIA",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
@@ -3512,9 +3275,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Encore ENLTV",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_TNF_5335MF,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -3534,13 +3297,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 0,
 			.amux = 2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-/*			.gpio = 0x00300001,*/
-			.gpio = 0x20000,
-
-		},
 		.mute = {
 			.name = name_mute,
 			.amux = 0,
@@ -3551,9 +3307,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Encore ENLTV-FM",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_FCV1236D,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -3573,12 +3329,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 0,
 			.amux = 2,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x20000,
-
-		},
 		.mute = {
 			.name = name_mute,
 			.amux = 0,
@@ -3588,9 +3338,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Encore ENLTV-FM v5.3",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_TNF_5335MF,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask	= 0x7000,
 		.inputs         = { {
 			.name = name_tv,
@@ -3609,11 +3359,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = 2,
 			.gpio = 0x2000,
 		} },
-		.radio = {
-			.name = name_radio,
-			.vmux = 1,
-			.amux = 1,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.gpio = 0xf000,
@@ -3624,9 +3370,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Terratec Cinergy HT PCI",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
@@ -3647,9 +3393,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Philips Tiger - S Reference design",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config   = 2,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
@@ -3667,19 +3413,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_M102] = {
 		.name           = "Avermedia M102",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 1<<21,
 		.inputs         = {{
 			.name = name_tv,
@@ -3700,9 +3442,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ASUS P7131 4871",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config   = 2,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
@@ -3718,9 +3460,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ASUSTeK P7131 Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config   = 2,
 		.gpiomask	= 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
@@ -3746,19 +3488,15 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_ASUSTeK_P7131_ANALOG] = {
 	       .name           = "ASUSTeK P7131 Analog",
 	       .audio_clock    = 0x00187de7,
 	       .tuner_type     = TUNER_PHILIPS_TDA8290,
-	       .radio_type     = UNSET,
+
 	       .tuner_addr     = ADDR_UNSET,
-	       .radio_addr     = ADDR_UNSET,
+
 	       .gpiomask       = 1 << 21,
 	       .inputs         = {{
 		       .name = name_tv,
@@ -3779,19 +3517,16 @@ struct saa7134_board saa7134_boards[] = {
 		       .vmux = 8,
 		       .amux = LINE2,
 	       } },
-	       .radio = {
-		       .name = name_radio,
-		       .amux = TV,
-		       .gpio = 0x0200000,
-	       },
+
 	},
 	[SAA7134_BOARD_SABRENT_TV_PCB05] = {
 		.name           = "Sabrent PCMCIA TV-PCB05",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -3820,9 +3555,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "10MOONS TM300 TV Card",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.gpiomask       = 0x7000,
 		.inputs         = {{
 			.name = name_tv,
@@ -3851,9 +3587,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia Super 007",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
@@ -3867,9 +3604,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia PCI pure analog (M135A)",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 2,
 		.gpiomask       = 0x020200000,
 		.inputs         = {{
@@ -3886,11 +3624,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x00200000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -3901,9 +3635,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "Avermedia PCI M733A",
 		.audio_clock	= 0x00187de7,
 		.tuner_type	= TUNER_PHILIPS_TDA8290,
-		.radio_type	= UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config	= 0,
 		.gpiomask	= 0x020200000,
 		.inputs		= {{
@@ -3920,11 +3654,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x00200000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -3937,9 +3667,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 401",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FQ1216ME,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
 			.name = name_svideo,
@@ -3966,9 +3696,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 403",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FQ1216ME,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
 			.name = name_svideo,
@@ -3991,9 +3721,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 403 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FQ1216ME,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
 			.name = name_svideo,
@@ -4009,10 +3739,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.tv   = 1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_405] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4020,9 +3747,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 405",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4047,9 +3775,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 405 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4066,10 +3795,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE2,
 			.tv   = 1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_407] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4077,9 +3803,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name 		= "Beholder BeholdTV 407",
 		.audio_clock 	= 0x00187de7,
 		.tuner_type 	= TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type 	= UNSET,
+
 		.tuner_addr 	= ADDR_UNSET,
-		.radio_addr 	= ADDR_UNSET,
+
 		.tda9887_conf 	= TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs = {{
@@ -4106,9 +3832,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name 		= "Beholder BeholdTV 407 FM",
 		.audio_clock 	= 0x00187de7,
 		.tuner_type 	= TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type 	= UNSET,
+
 		.tuner_addr 	= ADDR_UNSET,
-		.radio_addr 	= ADDR_UNSET,
+
 		.tda9887_conf 	= TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs = {{
@@ -4128,11 +3854,7 @@ struct saa7134_board saa7134_boards[] = {
 			.tv = 1,
 			.gpio = 0xc0c000,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0xc0c000,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_409] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4140,9 +3862,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 409",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4166,9 +3889,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 505 FM",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4189,10 +3913,7 @@ struct saa7134_board saa7134_boards[] = {
 			.name = name_mute,
 			.amux = LINE1,
 		},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_505RDS_MK5] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4200,9 +3921,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 505 RDS",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
@@ -4224,10 +3946,7 @@ struct saa7134_board saa7134_boards[] = {
 			.name = name_mute,
 			.amux = LINE1,
 		},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_507_9FM] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4235,9 +3954,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 507 FM / BeholdTV 509 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4254,10 +3974,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-			.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_507RDS_MK5] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4265,9 +3982,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 507 RDS",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
@@ -4285,10 +4003,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-			.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_507RDS_MK3] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4296,9 +4011,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 507 RDS",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
@@ -4316,10 +4032,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-			.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM] = {
 		/*       Beholder Intl. Ltd. 2008      */
@@ -4327,9 +4040,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV Columbus TV/FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ALPS_TSBE5_PAL,
-		.radio_type     = TUNER_TEA5767,
+
 		.tuner_addr     = 0xc2 >> 1,
-		.radio_addr     = 0xc0 >> 1,
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x000A8004,
 		.inputs         = {{
@@ -4349,20 +4062,17 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x000A8000,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x000A8000,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_607FM_MK3] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 607 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4378,19 +4088,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_609FM_MK3] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 609 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4406,19 +4114,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_607FM_MK5] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 607 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4434,19 +4140,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_609FM_MK5] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 609 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4462,19 +4166,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_607RDS_MK3] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 607 RDS",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
@@ -4491,19 +4193,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_609RDS_MK3] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 609 RDS",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
@@ -4520,19 +4220,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_607RDS_MK5] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 607 RDS",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
@@ -4549,19 +4247,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_609RDS_MK5] = {
 		/* Andrey Melnikoff <temnota@kmv.ru> */
 		.name           = "Beholder BeholdTV 609 RDS",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
@@ -4578,10 +4274,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		}},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_M6] = {
 		/* Igor Kuznetsov <igk@igk.ru> */
@@ -4591,9 +4284,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV M6",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {
@@ -4610,10 +4304,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4628,9 +4319,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV M63",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {
@@ -4647,10 +4339,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4666,9 +4355,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
@@ -4686,10 +4376,7 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4701,9 +4388,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Twinhan Hybrid DTV-DVB 3056 PCI",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config   = 2,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
@@ -4721,20 +4408,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,		/* untested */
 			.amux   = LINE1,
 		} },
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_GENIUS_TVGO_A11MCE] = {
 		/* Adrian Pardini <pardo.bsso@gmail.com> */
 		.name		= "Genius TVGO AM11MCE",
 		.audio_clock	= 0x00200000,
 		.tuner_type	= TUNER_TNF_5335MF,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0xf000,
 		.inputs         = {{
 			.name = name_tv_mono,
@@ -4754,11 +4437,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x2000,
 	} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x1000,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = LINE2,
@@ -4769,9 +4448,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "NXP Snake DVB-S reference design",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_comp1,
@@ -4787,9 +4467,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name         = "Medion/Creatix CTX953 Hybrid",
 		.audio_clock  = 0x00187de7,
 		.tuner_type   = TUNER_PHILIPS_TDA8290,
-		.radio_type   = UNSET,
+
 		.tuner_addr   = ADDR_UNSET,
-		.radio_addr   = ADDR_UNSET,
+
 		.tuner_config = 0,
 		.mpeg         = SAA7134_MPEG_DVB,
 		.inputs       = {{
@@ -4811,9 +4491,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "MSI TV@nywhere A/D v1.1",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config   = 2,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
@@ -4831,19 +4511,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE1,
 		} },
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_CARDBUS_506] = {
 		.name           = "AVerMedia Cardbus TV/Radio (E506R)",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		 .mpeg           = SAA7134_MPEG_DVB,
 		 .inputs         = {{
 			 .name = name_tv,
@@ -4859,18 +4535,15 @@ struct saa7134_board saa7134_boards[] = {
 			 .vmux = 8,
 			 .amux = LINE2,
 		 } },
-		 .radio = {
-			 .name = name_radio,
-			 .amux = TV,
-		 },
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_A16D] = {
 		.name           = "AVerMedia Hybrid TV/Radio (A16D)",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
 			.name = name_tv,
@@ -4886,18 +4559,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 0,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-		},
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_M115] = {
 		.name           = "Avermedia M115",
 		.audio_clock    = 0x187de7,
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs         = {{
 			.name = name_tv,
 			.vmux = 1,
@@ -4918,9 +4588,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Compro VideoMate T750",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.inputs = {{
 			.name   = name_tv,
 			.vmux   = 3,
@@ -4935,19 +4605,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE2,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-		}
+
 	},
 	[SAA7134_BOARD_AVERMEDIA_A700_PRO] = {
 		/* Matthias Schwarzott <zzam@gentoo.org> */
 		.name           = "Avermedia DVB-S Pro A700",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ABSENT,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name = name_comp,
@@ -4964,9 +4632,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia DVB-S Hybrid+FM A700",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name   = name_tv,
@@ -4982,19 +4651,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 6,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_H6] = {
 		/* Igor Kuznetsov <igk@igk.ru> */
 		.name           = "Beholder BeholdTV H6",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FMD1216MEX_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -5011,18 +4678,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_ASUSTeK_TIGER_3IN1] = {
 		.name           = "Asus Tiger 3in1",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 2,
 		.gpiomask       = 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
@@ -5040,19 +4705,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_REAL_ANGEL_220] = {
 		.name           = "Zogis Real Angel 220",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_TNF_5335MF,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.gpiomask       = 0x801a8087,
 		.inputs = { {
 			.name   = name_tv,
@@ -5071,11 +4733,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux   = LINE1,
 			.gpio   = 0x624000,
 		} },
-		.radio = {
-			.name   = name_radio,
-			.amux   = LINE2,
-			.gpio   = 0x624001,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -5085,9 +4743,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "ADS Tech Instant HDTV",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TUV1236D,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
@@ -5109,9 +4768,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Asus Tiger Rev:1.00",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
@@ -5133,19 +4792,15 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 8,
 			.amux   = LINE2,
 		} },
-		.radio = {
-			.name   = name_radio,
-			.amux   = TV,
-			.gpio   = 0x0200000,
-		},
+
 	},
 	[SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG] = {
 		.name           = "Kworld Plus TV Analog Lite PCI",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_YMEC_TVF_5533MF,
-		.radio_type     = TUNER_TEA5767,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = 0x60,
+
 		.gpiomask       = 0x80000700,
 		.inputs = { {
 			.name   = name_tv,
@@ -5164,12 +4819,6 @@ struct saa7134_board saa7134_boards[] = {
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		} },
-		.radio = {
-			.name   = name_radio,
-			.vmux   = 1,
-			.amux   = LINE1,
-			.gpio   = 0x100,
-		},
 		.mute = {
 			.name = name_mute,
 			.vmux = 8,
@@ -5191,8 +4840,6 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 #endif
-		.radio_type     = UNSET,
-		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x8e054000,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
@@ -5232,9 +4879,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia AVerTV GO 007 FM Plus",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.gpiomask       = 0x00300003,
 		/* .gpiomask       = 0x8c240003, */
 		.inputs         = { {
@@ -5249,11 +4896,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x02,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-			.gpio = 0x00300001,
-		},
+
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -5265,9 +4908,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Avermedia AVerTV Studio 507UA",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3, /* Should be MK5 */
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x03,
 		.inputs         = { {
@@ -5287,11 +4931,7 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = LINE1,
 			.gpio = 0x00,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-			.gpio = 0x01,
-		},
+
 		.mute  = {
 			.name = name_mute,
 			.amux = LINE1,
@@ -5303,9 +4943,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name		= "Compro VideoMate S350/S300",
 		.audio_clock	= 0x00187de7,
 		.tuner_type	= TUNER_ABSENT,
-		.radio_type	= UNSET,
+
 		.tuner_addr	= ADDR_UNSET,
-		.radio_addr	= ADDR_UNSET,
+
 		.mpeg		= SAA7134_MPEG_DVB,
 		.inputs = { {
 			.name	= name_comp1,
@@ -5322,9 +4962,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV X7",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC5000,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name = name_tv,
@@ -5340,18 +4981,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 9,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-		},
+
 	},
 	[SAA7134_BOARD_ZOLID_HYBRID_PCI] = {
 		.name           = "Zolid Hybrid TV Tuner PCI",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tuner_config   = 0,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
@@ -5361,18 +5000,15 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = TV,
 			.tv   = 1,
 		} },
-		.radio = {	/* untested */
-			.name = name_radio,
-			.amux = TV,
-		},
+
 	},
 	[SAA7134_BOARD_ASUS_EUROPA_HYBRID] = {
 		.name           = "Asus Europa Hybrid OEM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TD1316,
-		.radio_type     = UNSET,
+
 		.tuner_addr	= 0x61,
-		.radio_addr	= ADDR_UNSET,
+
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = { {
@@ -5394,9 +5030,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Leadtek Winfast DTV1000S",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name = name_comp1,
@@ -5412,9 +5049,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV 505 RDS",
 		.audio_clock    = 0x00200000,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
@@ -5436,10 +5074,7 @@ struct saa7134_board saa7134_boards[] = {
 			.name = name_mute,
 			.amux = LINE1,
 		},
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
+
 	},
 	[SAA7134_BOARD_HAWELL_HW_404M7] = {
 		/* Hawell HW-404M7 & Hawell HW-808M7  */
@@ -5447,9 +5082,9 @@ struct saa7134_board saa7134_boards[] = {
 		.name         = "Hawell HW-404M7",
 		.audio_clock   = 0x00200000,
 		.tuner_type    = UNSET,
-		.radio_type    = UNSET,
+
 		.tuner_addr   = ADDR_UNSET,
-		.radio_addr   = ADDR_UNSET,
+
 		.gpiomask      = 0x389c00,
 		.inputs       = {{
 			.name = name_comp1,
@@ -5463,9 +5098,10 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Beholder BeholdTV H7",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC5000,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
 		.inputs         = { {
@@ -5482,19 +5118,17 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 9,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-		},
+
 	},
 	[SAA7134_BOARD_BEHOLD_A7] = {
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV A7",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC5000,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.inputs         = { {
 			.name = name_tv,
 			.vmux = 2,
@@ -5509,18 +5143,16 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 9,
 			.amux = LINE1,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
-		},
+
 	},
 	[SAA7134_BOARD_TECHNOTREND_BUDGET_T3000] = {
 		.name           = "TechoTrend TT-budget T-3000",
 		.tuner_type     = TUNER_PHILIPS_TD1316,
 		.audio_clock    = 0x00187de7,
-		.radio_type     = UNSET,
+
 		.tuner_addr     = 0x63,
-		.radio_addr     = ADDR_UNSET,
+
+
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
@@ -5543,9 +5175,7 @@ struct saa7134_board saa7134_boards[] = {
 		.name           = "Compro VideoMate Vista M1F",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
-		.radio_type     = TUNER_TEA5767,
 		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = 0x60,
 		.inputs         = { {
 			.name = name_tv,
 			.vmux = 1,
@@ -5560,10 +5190,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 8,
 			.amux = LINE2,
 		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE1,
-		},
 		.mute = {
 			.name = name_mute,
 			.amux = TV,
@@ -7303,16 +6929,6 @@ static void saa7134_tuner_setup(struct saa7134_dev *dev)
 	memset(&tun_setup, 0, sizeof(tun_setup));
 	tun_setup.tuner_callback = saa7134_tuner_callback;
 
-	if (saa7134_boards[dev->board].radio_type != UNSET) {
-		tun_setup.type = saa7134_boards[dev->board].radio_type;
-		tun_setup.addr = saa7134_boards[dev->board].radio_addr;
-
-		tun_setup.mode_mask = T_RADIO;
-
-		saa_call_all(dev, tuner, s_type_addr, &tun_setup);
-		mode_mask &= ~T_RADIO;
-	}
-
 	if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type != UNSET)) {
 		tun_setup.type = dev->tuner_type;
 		tun_setup.addr = dev->tuner_addr;
@@ -7697,10 +7313,7 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 
 		/* Note: radio tuner address is always filled in,
 		   so we do not need to probe for a radio tuner device. */
-		if (dev->radio_type != UNSET)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner",
-				dev->radio_addr, NULL);
+
 		if (has_demod)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_adap, "tuner",
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 756a278..dc7b592 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -68,21 +68,15 @@ MODULE_PARM_DESC(no_overlay,"allow override overlay default (0 disables, 1 enabl
 		" [some VIA/SIS chipsets are known to have problem with overlay]");
 
 static unsigned int video_nr[] = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
-static unsigned int vbi_nr[]   = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
-static unsigned int radio_nr[] = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
 static unsigned int tuner[]    = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
 static unsigned int card[]     = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
 
 
 module_param_array(video_nr, int, NULL, 0444);
-module_param_array(vbi_nr,   int, NULL, 0444);
-module_param_array(radio_nr, int, NULL, 0444);
 module_param_array(tuner,    int, NULL, 0444);
 module_param_array(card,     int, NULL, 0444);
 
 MODULE_PARM_DESC(video_nr, "video device number");
-MODULE_PARM_DESC(vbi_nr,   "vbi device number");
-MODULE_PARM_DESC(radio_nr, "radio device number");
 MODULE_PARM_DESC(tuner,    "tuner type");
 MODULE_PARM_DESC(card,     "card type");
 
@@ -331,10 +325,6 @@ void saa7134_buffer_next(struct saa7134_dev *dev,
 		dprintk("buffer_next %p\n",NULL);
 		saa7134_set_dmabits(dev);
 		del_timer(&q->timeout);
-
-		if (card_has_mpeg(dev))
-			if (dev->ts_started)
-				saa7134_ts_stop(dev);
 	}
 }
 
@@ -397,17 +387,6 @@ int saa7134_set_dmabits(struct saa7134_dev *dev)
 		ov = dev->ovfield;
 	}
 
-	/* vbi capture -- dma 0 + vbi task A+B */
-	if (dev->vbi_q.curr) {
-		task |= 0x22;
-		ctrl |= SAA7134_MAIN_CTRL_TE2 |
-			SAA7134_MAIN_CTRL_TE3;
-		irq  |= SAA7134_IRQ1_INTE_RA0_7 |
-			SAA7134_IRQ1_INTE_RA0_6 |
-			SAA7134_IRQ1_INTE_RA0_5 |
-			SAA7134_IRQ1_INTE_RA0_4;
-	}
-
 	/* audio capture -- dma 3 */
 	if (dev->dmasound.dma_running) {
 		ctrl |= SAA7134_MAIN_CTRL_TE6;
@@ -544,13 +523,7 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 		    (status & 0x60) == 0)
 			saa7134_irq_video_done(dev,status);
 
-		if ((report & SAA7134_IRQ_REPORT_DONE_RA0) &&
-		    (status & 0x40) == 0x40)
-			saa7134_irq_vbi_done(dev,status);
 
-		if ((report & SAA7134_IRQ_REPORT_DONE_RA2) &&
-		    card_has_mpeg(dev))
-			saa7134_irq_ts_done(dev,status);
 
 		if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			switch (dev->has_remote) {
@@ -673,9 +646,7 @@ static int saa7134_hwinit1(struct saa7134_dev *dev)
 
 	saa7134_track_gpio(dev,"pre-init");
 	saa7134_video_init1(dev);
-	saa7134_vbi_init1(dev);
-	if (card_has_mpeg(dev))
-		saa7134_ts_init1(dev);
+
 	saa7134_input_init1(dev);
 
 	saa7134_hw_enable1(dev);
@@ -725,7 +696,7 @@ static int saa7134_hwinit2(struct saa7134_dev *dev)
 	dprintk("hwinit2\n");
 
 	saa7134_video_init2(dev);
-	saa7134_tvaudio_init2(dev);
+
 
 	saa7134_hw_enable2(dev);
 
@@ -738,11 +709,9 @@ static int saa7134_hwfini(struct saa7134_dev *dev)
 {
 	dprintk("hwfini\n");
 
-	if (card_has_mpeg(dev))
-		saa7134_ts_fini(dev);
+
 	saa7134_input_fini(dev);
-	saa7134_vbi_fini(dev);
-	saa7134_tvaudio_fini(dev);
+
 	return 0;
 }
 
@@ -801,53 +770,16 @@ static void saa7134_unregister_video(struct saa7134_dev *dev)
 			video_device_release(dev->video_dev);
 		dev->video_dev = NULL;
 	}
-	if (dev->vbi_dev) {
-		if (video_is_registered(dev->vbi_dev))
-			video_unregister_device(dev->vbi_dev);
-		else
-			video_device_release(dev->vbi_dev);
-		dev->vbi_dev = NULL;
-	}
-	if (dev->radio_dev) {
-		if (video_is_registered(dev->radio_dev))
-			video_unregister_device(dev->radio_dev);
-		else
-			video_device_release(dev->radio_dev);
-		dev->radio_dev = NULL;
-	}
-}
-
-static void mpeg_ops_attach(struct saa7134_mpeg_ops *ops,
-			    struct saa7134_dev *dev)
-{
-	int err;
 
-	if (NULL != dev->mops)
-		return;
-	if (saa7134_boards[dev->board].mpeg != ops->type)
-		return;
-	err = ops->init(dev);
-	if (0 != err)
-		return;
-	dev->mops = ops;
 }
 
-static void mpeg_ops_detach(struct saa7134_mpeg_ops *ops,
-			    struct saa7134_dev *dev)
-{
-	if (NULL == dev->mops)
-		return;
-	if (dev->mops != ops)
-		return;
-	dev->mops->fini(dev);
-	dev->mops = NULL;
-}
+
 
 static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 				     const struct pci_device_id *pci_id)
 {
 	struct saa7134_dev *dev;
-	struct saa7134_mpeg_ops *mops;
+
 	int err;
 
 	if (saa7134_devcount == SAA7134_MAXBOARDS)
@@ -937,8 +869,6 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	dev->autodetected = card[dev->nr] != dev->board;
 	dev->tuner_type = saa7134_boards[dev->board].tuner_type;
 	dev->tuner_addr = saa7134_boards[dev->board].tuner_addr;
-	dev->radio_type = saa7134_boards[dev->board].radio_type;
-	dev->radio_addr = saa7134_boards[dev->board].radio_addr;
 	dev->tda9887_conf = saa7134_boards[dev->board].tda9887_conf;
 	if (UNSET != tuner[dev->nr])
 		dev->tuner_type = tuner[dev->nr];
@@ -998,27 +928,11 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 			sd->grp_id = GRP_EMPRESS;
 	}
 
-	if (saa7134_boards[dev->board].rds_addr) {
-		struct v4l2_subdev *sd;
-
-		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "saa6588",
-				0, I2C_ADDRS(saa7134_boards[dev->board].rds_addr));
-		if (sd) {
-			printk(KERN_INFO "%s: found RDS decoder\n", dev->name);
-			dev->has_rds = 1;
-		}
-	}
-
 	request_submodules(dev);
 
 	v4l2_prio_init(&dev->prio);
 
-	mutex_lock(&saa7134_devlist_lock);
-	list_for_each_entry(mops, &mops_list, next)
-		mpeg_ops_attach(mops, dev);
-	list_add_tail(&dev->devlist, &saa7134_devlist);
-	mutex_unlock(&saa7134_devlist_lock);
+
 
 	/* check for signal */
 	saa7134_irq_video_signalchange(dev);
@@ -1041,25 +955,6 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
 	       dev->name, video_device_node_name(dev->video_dev));
 
-	dev->vbi_dev = vdev_init(dev, &saa7134_video_template, "vbi");
-
-	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
-				    vbi_nr[dev->nr]);
-	if (err < 0)
-		goto fail4;
-	printk(KERN_INFO "%s: registered device %s\n",
-	       dev->name, video_device_node_name(dev->vbi_dev));
-
-	if (card_has_radio(dev)) {
-		dev->radio_dev = vdev_init(dev,&saa7134_radio_template,"radio");
-		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
-					    radio_nr[dev->nr]);
-		if (err < 0)
-			goto fail4;
-		printk(KERN_INFO "%s: registered device %s\n",
-		       dev->name, video_device_node_name(dev->radio_dev));
-	}
-
 	/* everything worked */
 	saa7134_devcount++;
 
@@ -1089,8 +984,6 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct saa7134_dev *dev = container_of(v4l2_dev, struct saa7134_dev, v4l2_dev);
-	struct saa7134_mpeg_ops *mops;
-
 	/* Release DMA sound modules if present */
 	if (saa7134_dmasound_exit && dev->dmasound.priv_data) {
 		saa7134_dmasound_exit(dev);
@@ -1115,11 +1008,7 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 	saa7134_hwfini(dev);
 
 	/* unregister */
-	mutex_lock(&saa7134_devlist_lock);
-	list_del(&dev->devlist);
-	list_for_each_entry(mops, &mops_list, next)
-		mpeg_ops_detach(mops, dev);
-	mutex_unlock(&saa7134_devlist_lock);
+
 	saa7134_devcount--;
 
 	saa7134_i2c_unregister(dev);
@@ -1199,7 +1088,7 @@ static int saa7134_suspend(struct pci_dev *pci_dev , pm_message_t state)
 	   fill them on resume*/
 
 	del_timer(&dev->video_q.timeout);
-	del_timer(&dev->vbi_q.timeout);
+
 	del_timer(&dev->ts_q.timeout);
 
 	if (dev->remote)
@@ -1240,10 +1129,7 @@ static int saa7134_resume(struct pci_dev *pci_dev)
 
 	/*saa7134_hwinit2*/
 	saa7134_set_tvnorm_hw(dev);
-	saa7134_tvaudio_setmute(dev);
-	saa7134_tvaudio_setvolume(dev, dev->ctl_volume);
-	saa7134_tvaudio_init(dev);
-	saa7134_tvaudio_do_scan(dev);
+
 	saa7134_enable_i2s(dev);
 	saa7134_hw_enable2(dev);
 
@@ -1252,7 +1138,7 @@ static int saa7134_resume(struct pci_dev *pci_dev)
 	/*resume unfinished buffer(s)*/
 	spin_lock_irqsave(&dev->slock, flags);
 	saa7134_buffer_requeue(dev, &dev->video_q);
-	saa7134_buffer_requeue(dev, &dev->vbi_q);
+
 	saa7134_buffer_requeue(dev, &dev->ts_q);
 
 	/* FIXME: Disable DMA audio sound - temporary till proper support
@@ -1272,34 +1158,6 @@ static int saa7134_resume(struct pci_dev *pci_dev)
 
 /* ----------------------------------------------------------- */
 
-int saa7134_ts_register(struct saa7134_mpeg_ops *ops)
-{
-	struct saa7134_dev *dev;
-
-	mutex_lock(&saa7134_devlist_lock);
-	list_for_each_entry(dev, &saa7134_devlist, devlist)
-		mpeg_ops_attach(ops, dev);
-	list_add_tail(&ops->next,&mops_list);
-	mutex_unlock(&saa7134_devlist_lock);
-	return 0;
-}
-
-void saa7134_ts_unregister(struct saa7134_mpeg_ops *ops)
-{
-	struct saa7134_dev *dev;
-
-	mutex_lock(&saa7134_devlist_lock);
-	list_del(&ops->next);
-	list_for_each_entry(dev, &saa7134_devlist, devlist)
-		mpeg_ops_detach(ops, dev);
-	mutex_unlock(&saa7134_devlist_lock);
-}
-
-EXPORT_SYMBOL(saa7134_ts_register);
-EXPORT_SYMBOL(saa7134_ts_unregister);
-
-/* ----------------------------------------------------------- */
-
 static struct pci_driver saa7134_pci_driver = {
 	.name     = "saa7134",
 	.id_table = saa7134_pci_tbl,
@@ -1318,6 +1176,7 @@ static int __init saa7134_init(void)
 	       (SAA7134_VERSION_CODE >> 16) & 0xff,
 	       (SAA7134_VERSION_CODE >>  8) & 0xff,
 	       SAA7134_VERSION_CODE & 0xff);
+	printk(KERN_INFO "saa7130/34: w/o radio and vbi\n");
 #ifdef SNAPSHOT
 	printk(KERN_INFO "saa7130/34: snapshot date %04d-%02d-%02d\n",
 	       SNAPSHOT/10000, (SNAPSHOT/100)%100, SNAPSHOT%100);
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index ad22be2..0202d20 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -30,7 +30,7 @@
 #include "saa7134-reg.h"
 #include "saa7134.h"
 #include <media/v4l2-common.h>
-#include <media/rds.h>
+
 
 /* ------------------------------------------------------------------ */
 
@@ -198,9 +198,6 @@ static struct saa7134_format formats[] = {
 		.h_stop        = 719,	\
 		.video_v_start = 24,	\
 		.video_v_stop  = 311,	\
-		.vbi_v_start_0 = 7,	\
-		.vbi_v_stop_0  = 22,	\
-		.vbi_v_start_1 = 319,   \
 		.src_timing    = 4
 
 #define NORM_525_60			\
@@ -208,9 +205,6 @@ static struct saa7134_format formats[] = {
 		.h_stop        = 719,	\
 		.video_v_start = 23,	\
 		.video_v_stop  = 262,	\
-		.vbi_v_start_0 = 10,	\
-		.vbi_v_stop_0  = 21,	\
-		.vbi_v_start_1 = 273,	\
 		.src_timing    = 7
 
 static struct saa7134_tvnorm tvnorms[] = {
@@ -565,7 +559,7 @@ static void video_mux(struct saa7134_dev *dev, int input)
 	dprintk("video input = %d [%s]\n", input, card_in(dev, input).name);
 	dev->ctl_input = input;
 	set_tvnorm(dev, dev->tvnorm);
-	saa7134_tvaudio_setinput(dev, &card_in(dev, input));
+
 }
 
 
@@ -1224,14 +1218,7 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
 		saa_writeb(SAA7134_DEC_CHROMA_SATURATION,
 			   dev->ctl_invert ? -dev->ctl_saturation : dev->ctl_saturation);
 		break;
-	case V4L2_CID_AUDIO_MUTE:
-		dev->ctl_mute = c->value;
-		saa7134_tvaudio_setmute(dev);
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		dev->ctl_volume = c->value;
-		saa7134_tvaudio_setvolume(dev,dev->ctl_volume);
-		break;
+
 	case V4L2_CID_PRIVATE_INVERT:
 		dev->ctl_invert = c->value;
 		saa_writeb(SAA7134_DEC_LUMA_CONTRAST,
@@ -1303,9 +1290,7 @@ static struct videobuf_queue* saa7134_queue(struct saa7134_fh *fh)
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		q = &fh->cap;
 		break;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		q = &fh->vbi;
-		break;
+
 	default:
 		BUG();
 	}
@@ -1330,7 +1315,7 @@ static int video_open(struct file *file)
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh;
 	enum v4l2_buf_type type = 0;
-	int radio = 0;
+
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -1339,13 +1324,10 @@ static int video_open(struct file *file)
 	case VFL_TYPE_VBI:
 		type = V4L2_BUF_TYPE_VBI_CAPTURE;
 		break;
-	case VFL_TYPE_RADIO:
-		radio = 1;
-		break;
+
 	}
 
-	dprintk("open dev=%s radio=%d type=%s\n", video_device_node_name(vdev),
-		radio, v4l2_type_names[type]);
+
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
@@ -1354,7 +1336,7 @@ static int video_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev      = dev;
-	fh->radio    = radio;
+
 	fh->type     = type;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	fh->width    = 720;
@@ -1367,23 +1349,14 @@ static int video_open(struct file *file)
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct saa7134_buf),
 			    fh, NULL);
-	videobuf_queue_sg_init(&fh->vbi, &saa7134_vbi_qops,
-			    &dev->pci->dev, &dev->slock,
-			    V4L2_BUF_TYPE_VBI_CAPTURE,
-			    V4L2_FIELD_SEQ_TB,
-			    sizeof(struct saa7134_buf),
-			    fh, NULL);
+
 	saa7134_pgtable_alloc(dev->pci,&fh->pt_cap);
-	saa7134_pgtable_alloc(dev->pci,&fh->pt_vbi);
 
-	if (fh->radio) {
-		/* switch to radio mode */
-		saa7134_tvaudio_setinput(dev,&card(dev).radio);
-		saa_call_all(dev, tuner, s_radio);
-	} else {
+
+
 		/* switch to video/vbi mode */
 		video_mux(dev,dev->ctl_input);
-	}
+
 	return 0;
 }
 
@@ -1419,8 +1392,7 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
 
-	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)
-		return videobuf_poll_stream(file, &fh->vbi, wait);
+
 
 	if (res_check(fh,RESOURCE_VIDEO)) {
 		mutex_lock(&fh->cap.vb_lock);
@@ -1459,7 +1431,7 @@ static int video_release(struct file *file)
 {
 	struct saa7134_fh  *fh  = file->private_data;
 	struct saa7134_dev *dev = fh->dev;
-	struct rds_command cmd;
+
 	unsigned long flags;
 
 	/* turn off overlay */
@@ -1481,26 +1453,16 @@ static int video_release(struct file *file)
 	}
 
 	/* stop vbi capture */
-	if (res_check(fh, RESOURCE_VBI)) {
-		videobuf_stop(&fh->vbi);
-		res_free(dev,fh,RESOURCE_VBI);
-	}
 
-	/* ts-capture will not work in planar mode, so turn it off Hac: 04.05*/
-	saa_andorb(SAA7134_OFMT_VIDEO_A, 0x1f, 0);
-	saa_andorb(SAA7134_OFMT_VIDEO_B, 0x1f, 0);
-	saa_andorb(SAA7134_OFMT_DATA_A, 0x1f, 0);
-	saa_andorb(SAA7134_OFMT_DATA_B, 0x1f, 0);
 
 	saa_call_all(dev, core, s_power, 0);
-	if (fh->radio)
-		saa_call_all(dev, core, ioctl, RDS_CMD_CLOSE, &cmd);
+
 
 	/* free stuff */
 	videobuf_mmap_free(&fh->cap);
-	videobuf_mmap_free(&fh->vbi);
+
 	saa7134_pgtable_free(dev->pci,&fh->pt_cap);
-	saa7134_pgtable_free(dev->pci,&fh->pt_vbi);
+
 
 	v4l2_prio_close(&dev->prio, fh->prio);
 	file->private_data = NULL;
@@ -1515,59 +1477,9 @@ static int video_mmap(struct file *file, struct vm_area_struct * vma)
 	return videobuf_mmap_mapper(saa7134_queue(fh), vma);
 }
 
-static ssize_t radio_read(struct file *file, char __user *data,
-			 size_t count, loff_t *ppos)
-{
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
-	struct rds_command cmd;
-
-	cmd.block_count = count/3;
-	cmd.buffer = data;
-	cmd.instance = file;
-	cmd.result = -ENODEV;
-
-	saa_call_all(dev, core, ioctl, RDS_CMD_READ, &cmd);
-
-	return cmd.result;
-}
-
-static unsigned int radio_poll(struct file *file, poll_table *wait)
-{
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
-	struct rds_command cmd;
-
-	cmd.instance = file;
-	cmd.event_list = wait;
-	cmd.result = -ENODEV;
-	saa_call_all(dev, core, ioctl, RDS_CMD_POLL, &cmd);
-
-	return cmd.result;
-}
 
 /* ------------------------------------------------------------------ */
 
-static int saa7134_try_get_set_fmt_vbi_cap(struct file *file, void *priv,
-						struct v4l2_format *f)
-{
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
-	struct saa7134_tvnorm *norm = dev->tvnorm;
-
-	f->fmt.vbi.sampling_rate = 6750000 * 4;
-	f->fmt.vbi.samples_per_line = 2048 /* VBI_LINE_LENGTH */;
-	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
-	f->fmt.vbi.offset = 64 * 4;
-	f->fmt.vbi.start[0] = norm->vbi_v_start_0;
-	f->fmt.vbi.count[0] = norm->vbi_v_stop_0 - norm->vbi_v_start_0 +1;
-	f->fmt.vbi.start[1] = norm->vbi_v_start_1;
-	f->fmt.vbi.count[1] = f->fmt.vbi.count[0];
-	f->fmt.vbi.flags = 0; /* VBI_UNSYNC VBI_INTERLACED */
-
-	return 0;
-}
-
 static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
@@ -1818,8 +1730,7 @@ static int saa7134_querycap(struct file *file, void  *priv,
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING |
 		V4L2_CAP_TUNER;
-	if (dev->has_rds)
-		cap->capabilities |= V4L2_CAP_RDS_CAPTURE;
+
 	if (saa7134_no_overlay <= 0)
 		cap->capabilities |= V4L2_CAP_VIDEO_OVERLAY;
 
@@ -1895,7 +1806,7 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 	} else
 		set_tvnorm(dev, &tvnorms[i]);
 
-	saa7134_tvaudio_do_scan(dev);
+
 	mutex_unlock(&dev->lock);
 	return 0;
 }
@@ -2014,8 +1925,7 @@ static int saa7134_g_tuner(struct file *file, void *priv,
 			V4L2_TUNER_CAP_LANG1 |
 			V4L2_TUNER_CAP_LANG2;
 		t->rangehigh = 0xffffffffUL;
-		t->rxsubchans = saa7134_tvaudio_getstereo(dev);
-		t->audmode = saa7134_tvaudio_rx2mode(t->rxsubchans);
+
 	}
 	if (0 != (saa_readb(SAA7134_STATUS_VIDEO1) & 0x03))
 		t->signal = 0xffff;
@@ -2027,19 +1937,13 @@ static int saa7134_s_tuner(struct file *file, void *priv,
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
-	int rx, mode, err;
+
+	int err;
 
 	err = v4l2_prio_check(&dev->prio, fh->prio);
 	if (0 != err)
 		return err;
 
-	mode = dev->thread.mode;
-	if (UNSET == mode) {
-		rx   = saa7134_tvaudio_getstereo(dev);
-		mode = saa7134_tvaudio_rx2mode(t->rxsubchans);
-	}
-	if (mode != t->audmode)
-		dev->thread.mode = t->audmode;
 
 	return 0;
 }
@@ -2050,7 +1954,8 @@ static int saa7134_g_frequency(struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+
+	f->type = V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->ctl_freq;
 
 	return 0;
@@ -2069,16 +1974,17 @@ static int saa7134_s_frequency(struct file *file, void *priv,
 
 	if (0 != f->tuner)
 		return -EINVAL;
-	if (0 == fh->radio && V4L2_TUNER_ANALOG_TV != f->type)
-		return -EINVAL;
-	if (1 == fh->radio && V4L2_TUNER_RADIO != f->type)
+
+	if (V4L2_TUNER_ANALOG_TV != f->type)
 		return -EINVAL;
+
+
 	mutex_lock(&dev->lock);
 	dev->ctl_freq = f->frequency;
 
 	saa_call_all(dev, tuner, s_frequency, f);
 
-	saa7134_tvaudio_do_scan(dev);
+
 	mutex_unlock(&dev->lock);
 	return 0;
 }
@@ -2299,112 +2205,6 @@ static int vidioc_s_register (struct file *file, void *priv,
 }
 #endif
 
-static int radio_querycap(struct file *file, void *priv,
-					struct v4l2_capability *cap)
-{
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
-
-	strcpy(cap->driver, "saa7134");
-	strlcpy(cap->card, saa7134_boards[dev->board].name, sizeof(cap->card));
-	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->version = SAA7134_VERSION_CODE;
-	cap->capabilities = V4L2_CAP_TUNER;
-	return 0;
-}
-
-static int radio_g_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *t)
-{
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
-
-	if (0 != t->index)
-		return -EINVAL;
-
-	memset(t, 0, sizeof(*t));
-	strcpy(t->name, "Radio");
-	t->type = V4L2_TUNER_RADIO;
-
-	saa_call_all(dev, tuner, g_tuner, t);
-	if (dev->input->amux == TV) {
-		t->signal = 0xf800 - ((saa_readb(0x581) & 0x1f) << 11);
-		t->rxsubchans = (saa_readb(0x529) & 0x08) ?
-				V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
-	}
-	return 0;
-}
-static int radio_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *t)
-{
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
-
-	if (0 != t->index)
-		return -EINVAL;
-
-	saa_call_all(dev, tuner, s_tuner, t);
-	return 0;
-}
-
-static int radio_enum_input(struct file *file, void *priv,
-					struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-
-	strcpy(i->name, "Radio");
-	i->type = V4L2_INPUT_TYPE_TUNER;
-
-	return 0;
-}
-
-static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int radio_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	memset(a, 0, sizeof(*a));
-	strcpy(a->name, "Radio");
-	return 0;
-}
-
-static int radio_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	return 0;
-}
-
-static int radio_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	return 0;
-}
-
-static int radio_s_std(struct file *file, void *fh, v4l2_std_id *norm)
-{
-	return 0;
-}
-
-static int radio_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *c)
-{
-	const struct v4l2_queryctrl *ctrl;
-
-	if (c->id <  V4L2_CID_BASE ||
-	    c->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		ctrl = ctrl_by_id(c->id);
-		*c = *ctrl;
-	} else
-		*c = no_ctrl;
-	return 0;
-}
-
 static const struct v4l2_file_operations video_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -2426,9 +2226,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fmt_vid_overlay	= saa7134_g_fmt_vid_overlay,
 	.vidioc_try_fmt_vid_overlay	= saa7134_try_fmt_vid_overlay,
 	.vidioc_s_fmt_vid_overlay	= saa7134_s_fmt_vid_overlay,
-	.vidioc_g_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
-	.vidioc_try_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
-	.vidioc_s_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
+
 	.vidioc_g_audio			= saa7134_g_audio,
 	.vidioc_s_audio			= saa7134_s_audio,
 	.vidioc_cropcap			= saa7134_cropcap,
@@ -2464,31 +2262,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 #endif
 };
 
-static const struct v4l2_file_operations radio_fops = {
-	.owner	  = THIS_MODULE,
-	.open	  = video_open,
-	.read     = radio_read,
-	.release  = video_release,
-	.ioctl	  = video_ioctl2,
-	.poll     = radio_poll,
-};
 
-static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap	= radio_querycap,
-	.vidioc_g_tuner		= radio_g_tuner,
-	.vidioc_enum_input	= radio_enum_input,
-	.vidioc_g_audio		= radio_g_audio,
-	.vidioc_s_tuner		= radio_s_tuner,
-	.vidioc_s_audio		= radio_s_audio,
-	.vidioc_s_input		= radio_s_input,
-	.vidioc_s_std		= radio_s_std,
-	.vidioc_queryctrl	= radio_queryctrl,
-	.vidioc_g_input		= radio_g_input,
-	.vidioc_g_ctrl		= saa7134_g_ctrl,
-	.vidioc_s_ctrl		= saa7134_s_ctrl,
-	.vidioc_g_frequency	= saa7134_g_frequency,
-	.vidioc_s_frequency	= saa7134_s_frequency,
-};
 
 /* ----------------------------------------------------------- */
 /* exported stuff                                              */
@@ -2501,11 +2275,7 @@ struct video_device saa7134_video_template = {
 	.current_norm			= V4L2_STD_PAL,
 };
 
-struct video_device saa7134_radio_template = {
-	.name			= "saa7134-radio",
-	.fops			= &radio_fops,
-	.ioctl_ops 		= &radio_ioctl_ops,
-};
+
 
 int saa7134_video_init1(struct saa7134_dev *dev)
 {
@@ -2583,8 +2353,7 @@ int saa7134_video_init2(struct saa7134_dev *dev)
 	/* init video hw */
 	set_tvnorm(dev,&tvnorms[0]);
 	video_mux(dev,0);
-	saa7134_tvaudio_setmute(dev);
-	saa7134_tvaudio_setvolume(dev,dev->ctl_volume);
+
 	return 0;
 }
 
@@ -2606,10 +2375,10 @@ void saa7134_irq_video_signalchange(struct saa7134_dev *dev)
 		/* no video signal -> mute audio */
 		if (dev->ctl_automute)
 			dev->automute = 1;
-		saa7134_tvaudio_setmute(dev);
+
 	} else {
 		/* wake up tvaudio audio carrier scan thread */
-		saa7134_tvaudio_do_scan(dev);
+
 	}
 
 	if ((st2 & 0x80) && !noninterlaced && !dev->nosignal)
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 5b0a347..bc521e8 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -371,14 +371,14 @@ struct saa7134_board {
 	/* input switching */
 	unsigned int            gpiomask;
 	struct saa7134_input    inputs[SAA7134_INPUT_MAX];
-	struct saa7134_input    radio;
+
 	struct saa7134_input    mute;
 
 	/* i2c chip info */
 	unsigned int            tuner_type;
-	unsigned int		radio_type;
+
 	unsigned char		tuner_addr;
-	unsigned char		radio_addr;
+
 	unsigned char		empress_addr;
 	unsigned char		rds_addr;
 
@@ -393,7 +393,7 @@ struct saa7134_board {
 	unsigned int            ts_force_val:1;
 };
 
-#define card_has_radio(dev)   (NULL != saa7134_boards[dev->board].radio.name)
+
 #define card_is_empress(dev)  (SAA7134_MPEG_EMPRESS == saa7134_boards[dev->board].mpeg)
 #define card_is_dvb(dev)      (SAA7134_MPEG_DVB     == saa7134_boards[dev->board].mpeg)
 #define card_has_mpeg(dev)    (SAA7134_MPEG_UNUSED  != saa7134_boards[dev->board].mpeg)
@@ -460,7 +460,7 @@ struct saa7134_dmaqueue {
 /* video filehandle status */
 struct saa7134_fh {
 	struct saa7134_dev         *dev;
-	unsigned int               radio;
+
 	enum v4l2_buf_type         type;
 	unsigned int               resources;
 	enum v4l2_priority	   prio;
@@ -477,8 +477,7 @@ struct saa7134_fh {
 	struct saa7134_pgtable     pt_cap;
 
 	/* vbi capture */
-	struct videobuf_queue      vbi;
-	struct saa7134_pgtable     pt_vbi;
+
 };
 
 /* dmasound dsp status */
@@ -545,8 +544,7 @@ struct saa7134_dev {
 	/* various device info */
 	unsigned int               resources;
 	struct video_device        *video_dev;
-	struct video_device        *radio_dev;
-	struct video_device        *vbi_dev;
+
 	struct saa7134_dmasound    dmasound;
 
 	/* infrared remote */
@@ -564,9 +562,9 @@ struct saa7134_dev {
 	/* config info */
 	unsigned int               board;
 	unsigned int               tuner_type;
-	unsigned int 		   radio_type;
+
 	unsigned char		   tuner_addr;
-	unsigned char		   radio_addr;
+
 
 	unsigned int               tda9887_conf;
 	unsigned int               gpio_value;
@@ -585,9 +583,8 @@ struct saa7134_dev {
 
 	/* video+ts+vbi capture */
 	struct saa7134_dmaqueue    video_q;
-	struct saa7134_dmaqueue    vbi_q;
+
 	unsigned int               video_fieldcount;
-	unsigned int               vbi_fieldcount;
 
 	/* various v4l controls */
 	struct saa7134_tvnorm      *tvnorm;              /* video */
@@ -753,7 +750,6 @@ int saa7134_i2c_unregister(struct saa7134_dev *dev);
 
 extern unsigned int video_debug;
 extern struct video_device saa7134_video_template;
-extern struct video_device saa7134_radio_template;
 
 int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c);
 int saa7134_g_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c);
@@ -789,17 +785,6 @@ int saa7134_ts_start(struct saa7134_dev *dev);
 int saa7134_ts_stop(struct saa7134_dev *dev);
 
 /* ----------------------------------------------------------- */
-/* saa7134-vbi.c                                               */
-
-extern struct videobuf_queue_ops saa7134_vbi_qops;
-extern struct video_device saa7134_vbi_template;
-
-int saa7134_vbi_init1(struct saa7134_dev *dev);
-int saa7134_vbi_fini(struct saa7134_dev *dev);
-void saa7134_irq_vbi_done(struct saa7134_dev *dev, unsigned long status);
-
-
-/* ----------------------------------------------------------- */
 /* saa7134-tvaudio.c                                           */
 
 int saa7134_tvaudio_rx2mode(u32 rx);
-- 
1.7.2.3

