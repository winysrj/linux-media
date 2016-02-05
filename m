Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbcBEQGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 11:06:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	Juergen Gier <juergen.gier@gmx.de>,
	Darek Zielski <dz1125tor@gmail.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Inki Dae <inki.dae@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>
Subject: [PATCH 2/6] [media] saa7134: use input types, instead of hardcoding strings
Date: Fri,  5 Feb 2016 14:04:56 -0200
Message-Id: <793f4bb5c4fe43cd9f95b70927daff2bd094dc38.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the saa7134 driver is hardcoding input names on each
board entry. More modern drivers define, instead, an enum for each
input type.

While the current logic works, it adds extra complexity at the driver,
as it needs to discover the type of the input using some euristics.

Instead, let's standardize the input types and use a type, instead of
a name on all places.

That will allow further patches to properly report the input type
via VIDIOC_G_INPUT and to remove an extra field from the struct to
identify if the input is for TV.

Please notice that several boards define an input for receiving composite
signals via a S-Video connector. The name of such input was inconsistent,
so this patch cleans it and make it to be properly reported the
same way for all boards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/saa7134/saa7134-cards.c   | 1619 ++++++++++++++-------------
 drivers/media/pci/saa7134/saa7134-core.c    |    2 +-
 drivers/media/pci/saa7134/saa7134-tvaudio.c |   13 +-
 drivers/media/pci/saa7134/saa7134-video.c   |   11 +-
 drivers/media/pci/saa7134/saa7134.h         |   33 +-
 5 files changed, 853 insertions(+), 825 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 29d2094c42a0..19975cec5da7 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -36,17 +36,23 @@
 #include "xc5000.h"
 #include "s5h1411.h"
 
-/* commly used strings */
-static char name_mute[]    = "mute";
-static char name_radio[]   = "Radio";
-static char name_tv[]      = "Television";
-static char name_tv_mono[] = "TV (mono only)";
-static char name_comp[]    = "Composite";
-static char name_comp1[]   = "Composite1";
-static char name_comp2[]   = "Composite2";
-static char name_comp3[]   = "Composite3";
-static char name_comp4[]   = "Composite4";
-static char name_svideo[]  = "S-Video";
+/* Input names */
+const char * const saa7134_input_name[] = {
+	[SAA7134_INPUT_MUTE]       = "mute",
+	[SAA7134_INPUT_RADIO]      = "Radio",
+	[SAA7134_INPUT_TV]         = "Television",
+	[SAA7134_INPUT_TV_MONO]    = "TV (mono only)",
+	[SAA7134_INPUT_COMPOSITE]  = "Composite",
+	[SAA7134_INPUT_COMPOSITE0] = "Composite0",
+	[SAA7134_INPUT_COMPOSITE1] = "Composite1",
+	[SAA7134_INPUT_COMPOSITE2] = "Composite2",
+	[SAA7134_INPUT_COMPOSITE3] = "Composite3",
+	[SAA7134_INPUT_COMPOSITE4] = "Composite4",
+	[SAA7134_INPUT_SVIDEO]     = "S-Video",
+	[SAA7134_INPUT_SVIDEO0]    = "S-Video0",
+	[SAA7134_INPUT_SVIDEO1]    = "S-Video1",
+	[SAA7134_INPUT_COMPOSITE_OVER_SVIDEO] = "Composite over S-Video",
+};
 
 /* ------------------------------------------------------------------ */
 /* board config info                                                  */
@@ -69,7 +75,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 
 		.inputs         = {{
-			.name = "default",
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 0,
 			.amux = LINE1,
 		}},
@@ -84,22 +90,22 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -114,40 +120,40 @@ struct saa7134_board saa7134_boards[] = {
 
 		.gpiomask       = 0xe000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x8000,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x2000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x8000,
 		},
@@ -163,34 +169,34 @@ struct saa7134_board saa7134_boards[] = {
 
 		.gpiomask       = 0xe000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x2000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 			.gpio = 0x8000,
 		},
@@ -205,20 +211,20 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,     /* Composite signal on S-Video input */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -235,40 +241,40 @@ struct saa7134_board saa7134_boards[] = {
 
 		.gpiomask       = 0x1E000,	/* Set GP16 and unused 15,14,13 to Output */
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x10000,	/* GP16=1 selects TV input */
 			.tv   = 1,
 		},{
-/*			.name = name_tv_mono,
+/*			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		},{
-*/			.name = name_comp1,	/* Composite signal on S-Video input */
+*/			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE2,
 /*			.gpio = 0x4000,         */
 		},{
-			.name = name_comp2,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 3,
 			.amux = LINE2,
 /*			.gpio = 0x4000,         */
 		},{
-			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 /*			.gpio = 0x4000,         */
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x00000,	/* GP16=0 selects FM radio antenna */
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x10000,
 		},
@@ -285,40 +291,40 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0xe000,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x8000,
 			.tv   = 1,
 		}, {
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}, {
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x2000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x8000,
 		},
@@ -334,21 +340,21 @@ struct saa7134_board saa7134_boards[] = {
 		.empress_addr 	= 0x20,
 
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 		.mpeg      = SAA7134_MPEG_EMPRESS,
@@ -364,21 +370,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -390,35 +396,35 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
 			/* workaround for problems with normal TV sound */
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	       .mute = {
-		       .name = name_mute,
+		       .type = SAA7134_INPUT_MUTE,
 		       .amux = TV,
 	       },
 	},
@@ -432,32 +438,32 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux   = LINE2,
 			.tv   = 1,
 		},{
 
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
 
-			.name = "CVid over SVid",
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -472,24 +478,24 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf	= TDA9887_PRESENT,
 		.gpiomask	= 0x820000,
 		.inputs		= {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x20000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x20000,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x20000,
 		}},
 		.radio		= {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x20000,
 		},
@@ -504,20 +510,20 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 4,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp2, /* CVideo over SVideo Connector */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE1,
 		}}
@@ -531,31 +537,31 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
 			/* workaround for problems with normal TV sound */
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -567,15 +573,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
@@ -590,25 +596,25 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp2, /* CVideo over SVideo Connector */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -622,25 +628,25 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE2,
 	       },
 	       .mute = {
-		       .name = name_mute,
+		       .type = SAA7134_INPUT_MUTE,
 		       .amux = TV,
 		},
 	},
@@ -655,21 +661,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE2,
 		},
 	},
@@ -681,15 +687,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = LINE2,
 			.tv   = 1,
@@ -703,16 +709,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 7,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 8,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 8,
 			.amux = LINE2,
 			.tv   = 1,
@@ -726,21 +732,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 6,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 7,
 			.amux = LINE1,
 		}},
 		.mute           = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 		},
 	},
@@ -753,21 +759,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 		},
 	},
@@ -780,29 +786,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x200000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x0000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
 			.amux = LINE2,
 			.gpio = 0x0000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE2,
 			.gpio = 0x0000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x200000,
 		},
 		.mute  = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.gpio = 0x0000,
 		},
 
@@ -815,15 +821,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
@@ -839,34 +845,34 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0xe000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x2000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 			.gpio = 0x8000,
 		},
@@ -881,23 +887,23 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.empress_addr 	= 0x20,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
 			.amux = LINE1,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_comp3,
+			.type = SAA7134_INPUT_COMPOSITE3,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_comp4,
+			.type = SAA7134_INPUT_COMPOSITE4,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
@@ -912,15 +918,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
@@ -935,17 +941,17 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x06c00012,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x0ac20012,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x08c20012,
@@ -968,23 +974,23 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0xcf00,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.gpio = 2 << 14,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 0,
 			.gpio = 1 << 14,
 		},{
-			.name = name_comp3,
+			.type = SAA7134_INPUT_COMPOSITE3,
 			.vmux = 0,
 			.gpio = 0 << 14,
 		},{
-			.name = name_comp4,
+			.type = SAA7134_INPUT_COMPOSITE4,
 			.vmux = 0,
 			.gpio = 3 << 14,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.gpio = 2 << 14,
 		}},
@@ -999,34 +1005,34 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask	= 0x03,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x00,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x02,
 		}, {
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 0,
 			.amux = LINE1,
 			.gpio = 0x02,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x02,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 			.gpio = 0x01,
 		},
 		.mute  = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x00,
 		},
@@ -1041,15 +1047,15 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.empress_addr 	= 0x20,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
@@ -1068,22 +1074,22 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 		},
 	},
@@ -1096,20 +1102,20 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_INTERCARRIER | TDA9887_PORT2_INACTIVE,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 1,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -1123,21 +1129,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -1150,21 +1156,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -1177,16 +1183,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -1199,30 +1205,30 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux   = 1,
 			.amux   = LINE2,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		},{
-			.name   = "CVid over SVid",
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux   = 0,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE2,
 		},
 	},
@@ -1234,30 +1240,30 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux   = 1,
 			.amux   = LINE2,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		},{
-			.name   = "CVid over SVid",
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux   = 0,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE2,
 		},
 	},
@@ -1270,30 +1276,30 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux   = 1,
 			.amux   = LINE2,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		},{
-			.name   = "CVid over SVid",
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux   = 0,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE2,
 		},
 	},
@@ -1306,30 +1312,30 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x200000,
 		},
@@ -1343,10 +1349,10 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 		}},
 	},
@@ -1360,7 +1366,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		 .mpeg           = SAA7134_MPEG_DVB,
 		 .inputs         = {{
-			 .name = name_tv,
+			 .type = SAA7134_INPUT_TV,
 			 .vmux = 1,
 			 .amux = TV,
 			 .tv   = 1,
@@ -1375,15 +1381,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 		}},
 	},
@@ -1396,29 +1402,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -1432,29 +1438,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		}, {
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -1467,12 +1473,12 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 7,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 7,
 			.amux = LINE1,
 		}},
@@ -1486,21 +1492,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -1512,25 +1518,25 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp2, /* CVideo over SVideo Connector */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE1,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 		},
 	},
@@ -1544,29 +1550,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask	= 0x808c0080,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x00080,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x00080,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2_LEFT,
 			.tv   = 1,
 			.gpio = 0x00080,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x80000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 			.gpio = 0x40000,
 		},
@@ -1580,21 +1586,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE2,
 		},
 	},
@@ -1607,15 +1613,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
@@ -1631,29 +1637,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x4000,
 		.inputs         = {{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x8000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x8000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE1,
 			.gpio = 0x8000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 			.gpio = 0x8000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio =0x8000,
 		}
@@ -1672,29 +1678,29 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x03,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x00,
 		},{
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x02,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x02,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 			.gpio = 0x01,
 		},
 		.mute  = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 			.gpio = 0x00,
 		},
@@ -1709,29 +1715,29 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask       = 0x00300003,
 		/* .gpiomask       = 0x8c240003, */
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x01,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 			.gpio = 0x02,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE1,
 			.gpio = 0x02,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x00300001,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x01,
 		},
@@ -1745,21 +1751,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 		},
 	},
@@ -1774,24 +1780,24 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x08000000,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x08000000,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x08000000,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x08000000,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x00000000,
 		},
@@ -1805,21 +1811,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
@@ -1834,25 +1840,25 @@ struct saa7134_board saa7134_boards[] = {
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp2, /* CVideo over SVideo Connector */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -1866,29 +1872,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask	= 0x1ce780,
 		.inputs		= {{
-			.name = name_svideo,
-			.vmux = 0,		/* CVideo over SVideo Connector - ok? */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
+			.vmux = 0,
 			.amux = LINE1,
 			.gpio = 0x008080,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x008080,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x008080,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x80000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 			.gpio = 0x0c8000,
 		},
@@ -1903,20 +1909,20 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_INTERCARRIER | TDA9887_PORT2_INACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 1,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -1931,22 +1937,22 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -1961,25 +1967,25 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -1995,26 +2001,26 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask	= 0x00200000,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
 			.tv   = 1,
 		},{
-			.name = name_comp1,	/* Composite signal on S-Video input */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
 		},
@@ -2028,11 +2034,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
@@ -2049,20 +2055,20 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
@@ -2075,16 +2081,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -2098,29 +2104,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask	= 0x0700,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 			.gpio   = 0x000,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 			.gpio   = 0x200,		/* gpio by DScaler */
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 0,
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE1,
 			.gpio   = 0x100,
 		},
 		.mute  = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x000,
 		},
@@ -2135,26 +2141,26 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask	= 0x00200000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
 			.tv   = 1,
 		},{
-			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		},{
-			.name = name_comp1,	/* Composite signal on S-Video input */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
 		},
@@ -2168,29 +2174,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = 0x60,
 		.gpiomask       = 0x8c1880,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 0,
 			.amux = LINE1,
 			.gpio = 0x800800,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x801000,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x800000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x880000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 			.gpio = 0x840000,
 		},
@@ -2213,29 +2219,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= 0x60,
 		.gpiomask	= 0x0700,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 			.gpio   = 0x000,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 			.gpio   = 0x200,		/* gpio by DScaler */
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 0,
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE1,
 			.gpio   = 0x100,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x000,
 		},
@@ -2248,30 +2254,30 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,		/* radio unconfirmed */
+			.type = SAA7134_INPUT_RADIO,		/* radio unconfirmed */
 			.amux = LINE2,
 		},
 	},
@@ -2286,24 +2292,24 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.gpiomask       = 1 << 21,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x0000000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,     /* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x0000000,
 		},{
-			.name = name_svideo,    /* S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x0000000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0200000,
 		},
@@ -2322,29 +2328,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr= ADDR_UNSET,
 		.gpiomask       = 0x00010003,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x01,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x02,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE2,
 			.gpio = 0x02,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 			.gpio = 0x00010003,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x01,
 		},
@@ -2362,21 +2368,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			  .name = name_tv,
+			  .type = SAA7134_INPUT_TV,
 			  .vmux = 3,
 			  .amux = TV,
 			  .tv   = 1,
 		},{
-			  .name = name_comp1,
+			  .type = SAA7134_INPUT_COMPOSITE1,
 			  .vmux = 1,
 			  .amux = LINE1,
 		},{
-			  .name = name_svideo,
+			  .type = SAA7134_INPUT_SVIDEO,
 			  .vmux = 8,
 			  .amux = LINE1,
 		}},
 		.radio = {
-			  .name = name_radio,
+			  .type = SAA7134_INPUT_RADIO,
 			  .amux = LINE2,
 		},
 	},
@@ -2392,34 +2398,34 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf    = TDA9887_PRESENT,
 		.gpiomask        = 0x00200003,
 		.inputs          = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x00200003,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x00200003,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x00200003,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x00200003,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x00200003,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x00200003,
 		},
@@ -2434,16 +2440,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE2,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		}},
@@ -2458,16 +2464,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE2,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		}},
@@ -2481,11 +2487,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
@@ -2499,27 +2505,28 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.empress_addr 	= 0x21,
 		.inputs		= {{
-			.name   = "Composite 0",
+			.type = SAA7134_INPUT_COMPOSITE0,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = "Composite 1",
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE2,
 		},{
-			.name   = "Composite 2",
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux   = 2,
 			.amux   = LINE1,
 		},{
-			.name   = "Composite 3",
+			.type = SAA7134_INPUT_COMPOSITE3,
 			.vmux   = 3,
 			.amux   = LINE2,
 		},{
-			.name   = "S-Video 0",
+			.type = SAA7134_INPUT_SVIDEO0,
+
 			.vmux   = 8,
 			.amux   = LINE1,
 		},{
-			.name   = "S-Video 1",
+			.type = SAA7134_INPUT_SVIDEO1,
 			.vmux   = 9,
 			.amux   = LINE2,
 		}},
@@ -2538,27 +2545,27 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs		= {{
-			.name   = "Composite 0",
+			.type = SAA7134_INPUT_COMPOSITE0,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = "Composite 1",
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE2,
 		},{
-			.name   = "Composite 2",
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux   = 2,
 			.amux   = LINE1,
 		},{
-			.name   = "Composite 3",
+			.type = SAA7134_INPUT_COMPOSITE3,
 			.vmux   = 3,
 			.amux   = LINE2,
 		},{
-			.name   = "S-Video 0",
+			.type = SAA7134_INPUT_SVIDEO0,
 			.vmux   = 8,
 			.amux   = LINE1,
 		},{
-			.name   = "S-Video 1",
+			.type = SAA7134_INPUT_SVIDEO1,
 			.vmux   = 9,
 			.amux   = LINE2,
 		}},
@@ -2572,20 +2579,20 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,     /* Composite signal on S-Video input */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -2604,11 +2611,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -2622,16 +2629,16 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 
 		.inputs         = {{
-			  .name = name_tv,
+			  .type = SAA7134_INPUT_TV,
 			  .vmux = 1,
 			  .amux = TV,
 			  .tv   = 1,
 		},{
-			  .name = name_comp1,
+			  .type = SAA7134_INPUT_COMPOSITE1,
 			  .vmux = 3,
 			  .amux = LINE1,
 		},{
-			  .name = name_svideo,
+			  .type = SAA7134_INPUT_SVIDEO,
 			  .vmux = 6,
 			  .amux = LINE1,
 		}},
@@ -2645,25 +2652,25 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.gpiomask       = 0x080200000,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE2,
 		}, {
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 0,
 			.amux = LINE2,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0200000,
 		},
@@ -2678,29 +2685,29 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask	= 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x0000000,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0200000,
 		},
@@ -2717,21 +2724,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.gpiomask       = 0xe880c0,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -2745,16 +2752,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
@@ -2770,21 +2777,21 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -2798,25 +2805,25 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 1 << 21,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux   = 3,
 			.amux   = LINE2,	/* unconfirmed, taken from Philips driver */
 		},{
-			.name   = name_comp2,
-			.vmux   = 0,		/* untested, Composite over S-Video */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
+			.vmux   = 0,		/* untested */
 			.amux   = LINE2,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -2834,17 +2841,17 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x80200000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_svideo,  /* NOT tested */
+			.type = SAA7134_INPUT_SVIDEO,  /* NOT tested */
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -2861,26 +2868,26 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask	= 0x00200000,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,	/* Analog broadcast/cable TV */
+			.type = SAA7134_INPUT_TV,	/* Analog broadcast/cable TV */
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
 			.tv   = 1,
 		},{
-			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		},{
-			.name = name_comp1,	/* Composite signal on S-Video input */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
 		},
@@ -2894,11 +2901,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
@@ -2914,11 +2921,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_comp1,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -2933,7 +2940,7 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x00600000, /* Bit 21 0=Radio, Bit 22 0=TV */
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
@@ -2950,25 +2957,25 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 1 << 21,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -2983,21 +2990,21 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 1 << 21,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -3012,16 +3019,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
@@ -3052,17 +3059,17 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0xca60000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x04a61000,
 		},{
-			.name = name_comp2,  /*  Composite SVIDEO (B/W if signal is carried with SVIDEO) */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 1,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 9,           /* 9 is correct as S-VIDEO1 according to a169.inf! */
 			.amux = LINE1,
 		}},
@@ -3086,26 +3093,26 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x00600000, /* Bit 21 0=Radio, Bit 22 0=TV */
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
 			.tv   = 1,
 		},{
-			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		},{
-			.name = name_comp1,	/* Composite signal on S-Video input */
+			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 3,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
 		},
@@ -3121,40 +3128,40 @@ struct saa7134_board saa7134_boards[] = {
 
 		.gpiomask       = 0xe000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x8000,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x4000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x2000,
 		},
 			.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x8000,
 		},
@@ -3168,16 +3175,16 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
@@ -3193,11 +3200,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_comp1,	/* Composite input */
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
@@ -3211,25 +3218,25 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -3244,21 +3251,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 		},
 	},
@@ -3272,21 +3279,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT| TDA9887_PORT1_ACTIVE | TDA9887_PORT2_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 4,
 			.amux   = LINE2,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE1,
 		},
 	},
@@ -3301,25 +3308,25 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x000200000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE2,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -3335,34 +3342,34 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x03,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x00,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x00,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x00,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x00,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x01,
 		},
 		.mute  = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 			.gpio = 0x00,
 		},
@@ -3378,16 +3385,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE2,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		}},
@@ -3405,22 +3412,22 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200100,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x0000100,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0200100,
 		},
@@ -3438,22 +3445,22 @@ struct saa7134_board saa7134_boards[] = {
 		.ts_force_val   = 1,
 		.gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x0000100,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0800100, /* GPIO 23 HI for FM */
 		},
@@ -3470,22 +3477,22 @@ struct saa7134_board saa7134_boards[] = {
 		.ts_type	= SAA7134_MPEG_TS_SERIAL,
 		.gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x0000100,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0800100, /* GPIO 23 HI for FM */
 		},
@@ -3499,16 +3506,16 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 6,
 			.amux   = LINE1,
 		}},
@@ -3523,33 +3530,33 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = 3,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 7,
 			.amux = 4,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = 2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 0,
 			.amux = 2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 /*			.gpio = 0x00300001,*/
 			.gpio = 0x20000,
 
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = 0,
 		},
 	},
@@ -3562,32 +3569,32 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = 3,
 			.tv   = 1,
 		},{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 7,
 			.amux = 4,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = 2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 0,
 			.amux = 2,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x20000,
 
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = 0,
 		},
 	},
@@ -3600,29 +3607,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask	= 0x7000,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = 1,
 			.tv   = 1,
 			.gpio = 0x50000,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = 2,
 			.gpio = 0x2000,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = 2,
 			.gpio = 0x2000,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.vmux = 1,
 			.amux = 1,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.gpio = 0xf000,
 			.amux = 0,
 		},
@@ -3635,26 +3642,26 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= 0x61,
 		.radio_addr	= 0x60,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.vmux = 1,
 			.amux = LINE1,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 			.gpio = 0x43000,
 		},
@@ -3668,16 +3675,16 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 6,
 			.amux   = LINE1,
 		}},
@@ -3693,21 +3700,21 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		},{
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		}},
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -3721,16 +3728,16 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 1<<21,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE2,
 		}},
@@ -3746,7 +3753,7 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
@@ -3764,29 +3771,29 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask	= 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x0000000,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 0,
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x0200000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0200000,
 		},
@@ -3800,26 +3807,26 @@ struct saa7134_board saa7134_boards[] = {
 	       .radio_addr     = ADDR_UNSET,
 	       .gpiomask       = 1 << 21,
 	       .inputs         = {{
-		       .name = name_tv,
+		       .type = SAA7134_INPUT_TV,
 		       .vmux = 1,
 		       .amux = TV,
 		       .tv   = 1,
 		       .gpio = 0x0000000,
 	       }, {
-		       .name = name_comp1,
+		       .type = SAA7134_INPUT_COMPOSITE1,
 		       .vmux = 3,
 		       .amux = LINE2,
 	       }, {
-		       .name = name_comp2,
+		       .type = SAA7134_INPUT_COMPOSITE2,
 		       .vmux = 0,
 		       .amux = LINE2,
 	       }, {
-		       .name = name_svideo,
+		       .type = SAA7134_INPUT_SVIDEO,
 		       .vmux = 8,
 		       .amux = LINE2,
 	       } },
 	       .radio = {
-		       .name = name_radio,
+		       .type = SAA7134_INPUT_RADIO,
 		       .amux = TV,
 		       .gpio = 0x0200000,
 	       },
@@ -3832,25 +3839,25 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 0,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 		},
 	},
@@ -3864,24 +3871,24 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.gpiomask       = 0x7000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x2000,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x2000,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 			.gpio = 0x3000,
 		},
@@ -3896,7 +3903,7 @@ struct saa7134_board saa7134_boards[] = {
 		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv, /* FIXME: analog tv untested */
+			.type = SAA7134_INPUT_TV, /* FIXME: analog tv untested */
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
@@ -3912,26 +3919,26 @@ struct saa7134_board saa7134_boards[] = {
 		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.gpiomask       = 0x020200000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x00200000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x01,
 		},
@@ -3946,26 +3953,26 @@ struct saa7134_board saa7134_boards[] = {
 		.tda829x_conf	= { .lna_cfg = TDA8290_LNA_OFF },
 		.gpiomask	= 0x020200000,
 		.inputs		= {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x00200000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x01,
 		},
@@ -3981,21 +3988,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -4010,15 +4017,15 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
@@ -4035,21 +4042,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4065,15 +4072,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
@@ -4092,21 +4099,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4122,17 +4129,17 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf 	= TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0xc0c000,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 			.gpio = 0xc0c000,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv = 1,
@@ -4151,24 +4158,24 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf 	= TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs = {{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0xc0c000,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 			.gpio = 0xc0c000,
 		},{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv = 1,
 			.gpio = 0xc0c000,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0xc0c000,
 		},
@@ -4185,16 +4192,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
@@ -4211,25 +4218,25 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4246,25 +4253,25 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4280,21 +4287,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 			.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4311,21 +4318,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 			.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4342,21 +4349,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 			.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4372,24 +4379,24 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x000A8004,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x000A8004,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 			.gpio = 0x000A8000,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x000A8000,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x000A8000,
 		},
@@ -4404,21 +4411,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4432,21 +4439,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4460,21 +4467,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4488,21 +4495,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4517,21 +4524,21 @@ struct saa7134_board saa7134_boards[] = {
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4546,21 +4553,21 @@ struct saa7134_board saa7134_boards[] = {
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4575,21 +4582,21 @@ struct saa7134_board saa7134_boards[] = {
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4604,21 +4611,21 @@ struct saa7134_board saa7134_boards[] = {
 		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		},{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		},{
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -4636,21 +4643,21 @@ struct saa7134_board saa7134_boards[] = {
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 		.mpeg  = SAA7134_MPEG_EMPRESS,
@@ -4673,21 +4680,21 @@ struct saa7134_board saa7134_boards[] = {
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 		.mpeg  = SAA7134_MPEG_EMPRESS,
@@ -4712,21 +4719,21 @@ struct saa7134_board saa7134_boards[] = {
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 		.mpeg  = SAA7134_MPEG_EMPRESS,
@@ -4747,21 +4754,21 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,		/* untested */
 			.amux   = LINE1,
 		} },
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -4776,30 +4783,30 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0xf000,
 		.inputs         = {{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x2000,
 			.tv = 1
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x2000,
 	} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x1000,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE2,
 			.gpio = 0x6000,
 		},
@@ -4813,11 +4820,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		} },
@@ -4832,16 +4839,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda829x_conf = { .lna_cfg = TDA8290_LNA_OFF },
 		.mpeg         = SAA7134_MPEG_DVB,
 		.inputs       = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
@@ -4857,21 +4864,21 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		} },
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -4885,21 +4892,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		 .mpeg           = SAA7134_MPEG_DVB,
 		 .inputs         = {{
-			 .name = name_tv,
+			 .type = SAA7134_INPUT_TV,
 			 .vmux = 1,
 			 .amux = TV,
 			 .tv   = 1,
 		 }, {
-			 .name = name_comp1,
+			 .type = SAA7134_INPUT_COMPOSITE1,
 			 .vmux = 3,
 			 .amux = LINE1,
 		 }, {
-			 .name = name_svideo,
+			 .type = SAA7134_INPUT_SVIDEO,
 			 .vmux = 8,
 			 .amux = LINE2,
 		 } },
 		 .radio = {
-			 .name = name_radio,
+			 .type = SAA7134_INPUT_RADIO,
 			 .amux = TV,
 		 },
 	},
@@ -4912,21 +4919,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		}, {
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 0,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 		},
 	},
@@ -4938,16 +4945,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		} },
@@ -4962,21 +4969,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE2,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 		}
 	},
@@ -4990,11 +4997,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE1,
 		} },
@@ -5009,21 +5016,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 4,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 		},
 	},
@@ -5038,21 +5045,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -5067,21 +5074,21 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask       = 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 0,
 			.amux = LINE2,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0200000,
 		},
@@ -5097,21 +5104,21 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask       = 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 0,
 			.amux = LINE2,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0200000,
 		},
@@ -5125,29 +5132,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.gpiomask       = 0x801a8087,
 		.inputs = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = LINE2,
 			.tv     = 1,
 			.gpio   = 0x624000,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
 			.amux   = LINE1,
 			.gpio   = 0x624000,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 1,
 			.amux   = LINE1,
 			.gpio   = 0x624000,
 		} },
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = LINE2,
 			.gpio   = 0x624001,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 		},
 	},
@@ -5161,16 +5168,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 4,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
@@ -5186,25 +5193,25 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE2,
 		}, {
-			.name   = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux   = 0,
 			.amux   = LINE2,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		} },
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x0200000,
 		},
@@ -5218,30 +5225,30 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = 0x60,
 		.gpiomask       = 0x80000700,
 		.inputs = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = LINE2,
 			.tv     = 1,
 			.gpio   = 0x100,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		} },
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.vmux   = 1,
 			.amux   = LINE1,
 			.gpio   = 0x100,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.vmux = 8,
 			.amux = 2,
 		},
@@ -5257,18 +5264,18 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
 		.inputs = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 #if 0	/* FIXME */
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 			.gpio   = 0x200,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 			.gpio   = 0x200,
@@ -5276,14 +5283,14 @@ struct saa7134_board saa7134_boards[] = {
 		} },
 #if 0
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.vmux   = 1,
 			.amux   = LINE1,
 			.gpio   = 0x100,
 		},
 #endif
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.vmux = 0,
 			.amux = TV,
 		},
@@ -5298,24 +5305,24 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask       = 0x00300003,
 		/* .gpiomask       = 0x8c240003, */
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x01,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 			.amux = LINE1,
 			.gpio = 0x02,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x00300001,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 			.gpio = 0x01,
 		},
@@ -5331,29 +5338,29 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x03,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x00,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x00,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 			.gpio = 0x00,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 			.gpio = 0x01,
 		},
 		.mute  = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 			.gpio = 0x00,
 		},
@@ -5368,11 +5375,11 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.mpeg		= SAA7134_MPEG_DVB,
 		.inputs = { {
-			.name	= name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux	= 0,
 			.amux	= LINE1,
 		}, {
-			.name	= name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux	= 8, /* Not tested */
 			.amux	= LINE1
 		} },
@@ -5387,21 +5394,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 2,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 9,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 		},
 	},
@@ -5416,13 +5423,13 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		} },
 		.radio = {	/* untested */
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 		},
 	},
@@ -5436,16 +5443,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 4,
 			.amux   = LINE2,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		} },
@@ -5459,10 +5466,10 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 		} },
 	},
@@ -5479,25 +5486,25 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE2,
 		},
 	},
@@ -5512,7 +5519,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr   = ADDR_UNSET,
 		.gpiomask      = 0x389c00,
 		.inputs       = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x01fc00,
@@ -5529,21 +5536,21 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 2,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 9,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 		},
 	},
@@ -5556,21 +5563,21 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 2,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 9,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 		},
 	},
@@ -5584,16 +5591,16 @@ struct saa7134_board saa7134_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE2,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		} },
@@ -5607,25 +5614,25 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = 0x60,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = TV,
 		},
 	},
@@ -5642,29 +5649,29 @@ struct saa7134_board saa7134_boards[] = {
 		.mpeg		= SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
 		.inputs		= { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 			.gpio   = 0x00050000,
 		}, {
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
 			.amux   = LINE1,
 			.gpio   = 0x00050000,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 			.gpio   = 0x00050000,
 		} },
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio   = 0x00050000,
 		},
 		.mute = {
-			.name   = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.vmux   = 0,
 			.amux   = TV,
 			.gpio   = 0x00050000,
@@ -5681,21 +5688,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.gpiomask       = 0x00008000,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -5710,21 +5717,21 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.gpiomask       = 0x00008000,
 		.inputs         = { {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -5736,15 +5743,15 @@ struct saa7134_board saa7134_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.inputs		= {{
-			.name   = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
 			.amux   = LINE1,
 		}, {
-			.name   = name_comp3,
+			.type = SAA7134_INPUT_COMPOSITE3,
 			.vmux   = 2,
 			.amux   = LINE1,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE1,
 		} },
@@ -5760,21 +5767,21 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask       = 1 << 21,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
 		.inputs = { {
-			.name   = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
 			.tv     = 1,
 		}, {
-			.name   = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux   = 3,
 			.amux   = LINE1,
 		}, {
-			.name   = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux   = 8,
 			.amux   = LINE2,
 		} },
 		.radio = {
-			.name   = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux   = TV,
 			.gpio	= 0x0000000,
 		},
@@ -5790,7 +5797,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr   = ADDR_UNSET,
 		.gpiomask      = 0x618E700,
 		.inputs       = {{
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x6010000,
@@ -5809,21 +5816,21 @@ struct saa7134_board saa7134_boards[] = {
 		.gpiomask       = 1 << 11,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_comp,
+			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 4,
 			.amux = LINE1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE1,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = TV,
 			.gpio = 0x0000800,
 		},
@@ -5837,16 +5844,16 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.mpeg		= SAA7134_MPEG_GO7007,
 		.inputs		= { {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		}, {
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
 			.tv   = 1,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
 		.amux = LINE1,
 		} },
@@ -5862,25 +5869,25 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
-			.name = name_tv,
+			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
 			.amux = LINE2,
 		}, {
-			.name = name_comp2,
+			.type = SAA7134_INPUT_COMPOSITE2,
 			.vmux = 3,
 			.amux = LINE2,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 		} },
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 		},
 	},
@@ -5893,29 +5900,29 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask       = 0x0d,
 		.inputs         = {{
-			.name = name_tv_mono,
+			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE1,
 			.gpio = 0x00,
 			.tv   = 1,
 		}, {
-			.name = name_comp1,
+			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE2,
 			.gpio = 0x08,
 		}, {
-			.name = name_svideo,
+			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
 			.amux = LINE2,
 			.gpio = 0x08,
 		} },
 		.radio = {
-			.name = name_radio,
+			.type = SAA7134_INPUT_RADIO,
 			.amux = LINE1,
 			.gpio = 0x04,
 		},
 		.mute = {
-			.name = name_mute,
+			.type = SAA7134_INPUT_MUTE,
 			.amux = LINE1,
 			.gpio = 0x08,
 		},
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index e227b02cc122..31048f9b516a 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -112,7 +112,7 @@ int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 		printk(KERN_DEBUG pr_fmt("irq: " fmt), ## arg); \
 	} while (0)
 
-void saa7134_track_gpio(struct saa7134_dev *dev, char *msg)
+void saa7134_track_gpio(struct saa7134_dev *dev, const char *msg)
 {
 	unsigned long mode,status;
 
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 21a579309575..38f94b742e28 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -192,7 +192,7 @@ static void mute_input_7134(struct saa7134_dev *dev)
 	in   = dev->input;
 	mute = (dev->ctl_mute ||
 		(dev->automute  &&  (&card(dev).radio) != in));
-	if (card(dev).mute.name) {
+	if (card(dev).mute.type) {
 		/*
 		 * 7130 - we'll mute using some unconnected audio input
 		 * 7134 - we'll probably should switch external mux with gpio
@@ -204,13 +204,14 @@ static void mute_input_7134(struct saa7134_dev *dev)
 	if (dev->hw_mute  == mute &&
 		dev->hw_input == in && !dev->insuspend) {
 		audio_dbg(1, "mute/input: nothing to do [mute=%d,input=%s]\n",
-			  mute, in->name);
+			  mute, saa7134_input_name[in->type]);
 		return;
 	}
 
 	audio_dbg(1, "ctl_mute=%d automute=%d input=%s  =>  mute=%d input=%s\n",
 		  dev->ctl_mute, dev->automute,
-		  dev->input->name, mute, in->name);
+		  saa7134_input_name[dev->input->type], mute,
+		  saa7134_input_name[in->type]);
 	dev->hw_mute  = mute;
 	dev->hw_input = in;
 
@@ -245,7 +246,7 @@ static void mute_input_7134(struct saa7134_dev *dev)
 	mask = card(dev).gpiomask;
 	saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   mask, mask);
 	saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, mask, in->gpio);
-	saa7134_track_gpio(dev,in->name);
+	saa7134_track_gpio(dev, saa7134_input_name[in->type]);
 }
 
 static void tvaudio_setmode(struct saa7134_dev *dev,
@@ -756,14 +757,14 @@ static int mute_input_7133(struct saa7134_dev *dev)
 	if (0 != card(dev).gpiomask) {
 		mask = card(dev).gpiomask;
 
-		if (card(dev).mute.name && dev->ctl_mute)
+		if (card(dev).mute.type && dev->ctl_mute)
 			in = &card(dev).mute;
 		else
 			in = dev->input;
 
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   mask, mask);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, mask, in->gpio);
-		saa7134_track_gpio(dev,in->name);
+		saa7134_track_gpio(dev, saa7134_input_name[in->type]);
 	}
 
 	return 0;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 7a42d3ae3ac9..ae52ef019e43 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -409,7 +409,8 @@ static void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
 
 static void video_mux(struct saa7134_dev *dev, int input)
 {
-	video_dbg("video input = %d [%s]\n", input, card_in(dev, input).name);
+	video_dbg("video input = %d [%s]\n",
+		  input, saa7134_input_name[card_in(dev, input).type]);
 	dev->ctl_input = input;
 	set_tvnorm(dev, dev->tvnorm);
 	saa7134_tvaudio_setinput(dev, &card_in(dev, input));
@@ -1381,11 +1382,11 @@ int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 	n = i->index;
 	if (n >= SAA7134_INPUT_MAX)
 		return -EINVAL;
-	if (NULL == card_in(dev, i->index).name)
+	if (card_in(dev, i->index).type == SAA7134_NO_INPUT)
 		return -EINVAL;
 	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
-	strcpy(i->name, card_in(dev, n).name);
+	strcpy(i->name, saa7134_input_name[card_in(dev, n).type]);
 	if (card_in(dev, n).tv)
 		i->type = V4L2_INPUT_TYPE_TUNER;
 	if (n == dev->ctl_input) {
@@ -1419,7 +1420,7 @@ int saa7134_s_input(struct file *file, void *priv, unsigned int i)
 
 	if (i >= SAA7134_INPUT_MAX)
 		return -EINVAL;
-	if (NULL == card_in(dev, i).name)
+	if (card_in(dev, i).type == SAA7134_NO_INPUT)
 		return -EINVAL;
 	video_mux(dev, i);
 	return 0;
@@ -1661,7 +1662,7 @@ int saa7134_g_tuner(struct file *file, void *priv,
 	}
 	if (n == SAA7134_INPUT_MAX)
 		return -EINVAL;
-	if (NULL != card_in(dev, n).name) {
+	if (card_in(dev, n).type != SAA7134_NO_INPUT) {
 		strcpy(t->name, "Television");
 		t->type = V4L2_TUNER_ANALOG_TV;
 		saa_call_all(dev, tuner, g_tuner, t);
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 5938bc781999..274a472e7d6b 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -361,12 +361,30 @@ struct saa7134_card_ir {
 #define SET_CLOCK_INVERTED			(1 << 2)
 #define SET_VSYNC_OFF				(1 << 3)
 
+enum saa7134_input_types {
+	SAA7134_NO_INPUT = 0,
+	SAA7134_INPUT_MUTE,
+	SAA7134_INPUT_RADIO,
+	SAA7134_INPUT_TV,
+	SAA7134_INPUT_TV_MONO,
+	SAA7134_INPUT_COMPOSITE,
+	SAA7134_INPUT_COMPOSITE0,
+	SAA7134_INPUT_COMPOSITE1,
+	SAA7134_INPUT_COMPOSITE2,
+	SAA7134_INPUT_COMPOSITE3,
+	SAA7134_INPUT_COMPOSITE4,
+	SAA7134_INPUT_SVIDEO,
+	SAA7134_INPUT_SVIDEO0,
+	SAA7134_INPUT_SVIDEO1,
+	SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
+};
+
 struct saa7134_input {
-	char                    *name;
-	unsigned int            vmux;
-	enum saa7134_audio_in   amux;
-	unsigned int            gpio;
-	unsigned int            tv:1;
+	enum saa7134_input_types type;
+	unsigned int             vmux;
+	enum saa7134_audio_in    amux;
+	unsigned int             gpio;
+	unsigned int             tv:1;
 };
 
 enum saa7134_mpeg_type {
@@ -410,7 +428,7 @@ struct saa7134_board {
 	unsigned int            ts_force_val:1;
 };
 
-#define card_has_radio(dev)   (NULL != saa7134_boards[dev->board].radio.name)
+#define card_has_radio(dev)   (SAA7134_NO_INPUT != saa7134_boards[dev->board].radio.type)
 #define card_is_empress(dev)  (SAA7134_MPEG_EMPRESS == saa7134_boards[dev->board].mpeg)
 #define card_is_dvb(dev)      (SAA7134_MPEG_DVB     == saa7134_boards[dev->board].mpeg)
 #define card_is_go7007(dev)   (SAA7134_MPEG_GO7007  == saa7134_boards[dev->board].mpeg)
@@ -727,7 +745,7 @@ extern struct mutex saa7134_devlist_lock;
 extern int saa7134_no_overlay;
 extern bool saa7134_userptr;
 
-void saa7134_track_gpio(struct saa7134_dev *dev, char *msg);
+void saa7134_track_gpio(struct saa7134_dev *dev, const char *msg);
 void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value);
 
 #define SAA7134_PGTABLE_SIZE 4096
@@ -760,6 +778,7 @@ extern int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 /* saa7134-cards.c                                             */
 
 extern struct saa7134_board saa7134_boards[];
+extern const char * const saa7134_input_name[];
 extern const unsigned int saa7134_bcount;
 extern struct pci_device_id saa7134_pci_tbl[];
 
-- 
2.5.0


