Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbcBEQGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 11:06:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Juergen Gier <juergen.gier@gmx.de>,
	Darek Zielski <dz1125tor@gmail.com>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH 4/6] [media] saa7134: Get rid of struct saa7134_input.tv field
Date: Fri,  5 Feb 2016 14:04:58 -0200
Message-Id: <cf018b0faf9a81642eb7a407c31b8d57c4f318a9.1454688188.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The saa7134_input.tv field was used to indicate if an input had
a RF signal for TV input. This is not needed anymore, as the input
type can be checked directly by the driver.

Also, due to a past bug when setting the TV standard at the
demod, all inputs should have this field set, with is wrong.

This reduces the size of the saa7134_boards by about 8KB,
on i386 (and probably twice on 64 bits), with is a nice
colateral effect:

   text	   data	    bss	    dec	    hex	filename
 241047	 136831	  66356	 444234	  6c74a	drivers/media/pci/saa7134/saa7134.o.old
 240851  128895   66292  436038   6a746 drivers/media/pci/saa7134/saa7134.o

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/saa7134/saa7134-cards.c | 194 ------------------------------
 drivers/media/pci/saa7134/saa7134-video.c |  13 +-
 drivers/media/pci/saa7134/saa7134.h       |   1 -
 3 files changed, 10 insertions(+), 198 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 19975cec5da7..9a2fdc78eb85 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -97,12 +97,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.radio = {
 			.type = SAA7134_INPUT_RADIO,
@@ -124,13 +122,11 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x8000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -173,7 +169,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -214,7 +209,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
@@ -245,13 +239,11 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x10000,	/* GP16=1 selects TV input */
-			.tv   = 1,
 		},{
 /*			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		},{
 */			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
@@ -295,13 +287,11 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x8000,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -351,7 +341,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.radio = {
 			.type = SAA7134_INPUT_RADIO,
@@ -373,7 +362,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -399,13 +387,11 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			/* workaround for problems with normal TV sound */
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -441,12 +427,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux   = LINE2,
-			.tv   = 1,
 		},{
 
 			.type = SAA7134_INPUT_SVIDEO,
@@ -481,7 +465,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x20000,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,
@@ -513,7 +496,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 4,
@@ -540,13 +522,11 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			/* workaround for problems with normal TV sound */
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -584,7 +564,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_CINERGY600] = {
@@ -599,7 +578,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
@@ -631,7 +609,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
@@ -664,7 +641,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -698,7 +674,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_ELSA_500TV] = {
@@ -716,12 +691,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 8,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 8,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_ELSA_700TV] = {
@@ -735,7 +708,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 6,
@@ -762,7 +734,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
@@ -790,7 +761,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x0000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
@@ -832,7 +802,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_10MOONSTVMASTER] = {
@@ -849,7 +818,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -929,7 +897,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUS] = {
@@ -955,7 +922,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x08c20012,
-			.tv   = 1,
 		}},				/* radio and probably mute is missing */
 	},
 	[SAA7134_BOARD_CRONOS_PLUS] = {
@@ -1008,7 +974,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x00,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -1058,7 +1023,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}},
 		.mpeg      = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
@@ -1077,7 +1041,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -1105,7 +1068,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -1140,7 +1102,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.radio = {
 			.type = SAA7134_INPUT_RADIO,
@@ -1167,7 +1128,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.mute = {
 			.type = SAA7134_INPUT_MUTE,
@@ -1186,7 +1146,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -1208,12 +1167,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux   = 1,
 			.amux   = LINE2,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -1243,12 +1200,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux   = 1,
 			.amux   = LINE2,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -1279,12 +1234,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux   = 1,
 			.amux   = LINE2,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -1315,12 +1268,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -1369,7 +1320,6 @@ struct saa7134_board saa7134_boards[] = {
 			 .type = SAA7134_INPUT_TV,
 			 .vmux = 1,
 			 .amux = TV,
-			 .tv   = 1,
 		 } },
 	},
 	[SAA7134_BOARD_NOVAC_PRIMETV7133] = {
@@ -1387,7 +1337,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
@@ -1405,7 +1354,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -1441,7 +1389,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -1476,7 +1423,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 7,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 7,
@@ -1495,7 +1441,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
@@ -1521,7 +1466,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
@@ -1563,7 +1507,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2_LEFT,
-			.tv   = 1,
 			.gpio = 0x00080,
 		}},
 		.radio = {
@@ -1593,7 +1536,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
@@ -1624,7 +1566,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_EMPIRE_PCI_TV_RADIO_LE] = {
@@ -1641,7 +1582,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x8000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -1681,7 +1621,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x00,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE,
@@ -1718,7 +1657,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x01,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -1754,7 +1692,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -1783,7 +1720,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x08000000,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -1814,12 +1750,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -1843,7 +1777,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 4,
@@ -1885,7 +1818,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x008080,
 		}},
 		.radio = {
@@ -1912,7 +1844,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -1944,12 +1875,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.radio = {
 			.type = SAA7134_INPUT_RADIO,
@@ -1970,7 +1899,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -2005,7 +1933,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
@@ -2058,7 +1985,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -2084,7 +2010,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -2107,7 +2032,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 			.gpio   = 0x000,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -2145,7 +2069,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
@@ -2187,7 +2110,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x800000,
 		}},
 		.radio = {
@@ -2222,7 +2144,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 			.gpio   = 0x000,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -2257,12 +2178,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -2296,7 +2215,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x0000000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -2331,7 +2249,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x01,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -2371,7 +2288,6 @@ struct saa7134_board saa7134_boards[] = {
 			  .type = SAA7134_INPUT_TV,
 			  .vmux = 3,
 			  .amux = TV,
-			  .tv   = 1,
 		},{
 			  .type = SAA7134_INPUT_COMPOSITE1,
 			  .vmux = 1,
@@ -2401,7 +2317,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x00200003,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
@@ -2443,7 +2358,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
@@ -2467,7 +2381,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
@@ -2582,7 +2495,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
 			.vmux = 0,
@@ -2632,7 +2544,6 @@ struct saa7134_board saa7134_boards[] = {
 			  .type = SAA7134_INPUT_TV,
 			  .vmux = 1,
 			  .amux = TV,
-			  .tv   = 1,
 		},{
 			  .type = SAA7134_INPUT_COMPOSITE1,
 			  .vmux = 3,
@@ -2655,7 +2566,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -2688,7 +2598,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x0000000,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -2727,7 +2636,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -2755,7 +2663,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -2780,7 +2687,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -2808,7 +2714,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux   = 3,
@@ -2844,7 +2749,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,  /* NOT tested */
 			.vmux = 8,
@@ -2872,7 +2776,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
@@ -2943,7 +2846,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 			.gpio   = 0x00200000,
 		}},
 	},
@@ -2960,7 +2862,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -2993,7 +2894,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -3022,7 +2922,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3062,7 +2961,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x04a61000,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE_OVER_SVIDEO,
@@ -3097,7 +2995,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x200000,	/* GPIO21=High for TV input */
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
@@ -3132,13 +3029,11 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = TV,
 			.gpio = 0x8000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -3178,7 +3073,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
@@ -3221,7 +3115,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -3254,7 +3147,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3282,7 +3174,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 4,
@@ -3311,7 +3202,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 4,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -3345,7 +3235,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x00,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -3388,7 +3277,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
@@ -3415,7 +3303,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x0000100,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -3448,7 +3335,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x0000100,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -3480,7 +3366,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x0000100,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -3509,7 +3394,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
@@ -3533,12 +3417,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = 3,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 7,
 			.amux = 4,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3572,12 +3454,10 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = 3,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_TV_MONO,
 			.vmux = 7,
 			.amux = 4,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3610,7 +3490,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = 1,
-			.tv   = 1,
 			.gpio = 0x50000,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -3645,7 +3524,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3678,7 +3556,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
@@ -3703,7 +3580,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -3731,7 +3607,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -3756,7 +3631,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 			.gpio   = 0x0200000,
 		}},
 	},
@@ -3774,7 +3648,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x0000000,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -3810,7 +3683,6 @@ struct saa7134_board saa7134_boards[] = {
 		       .type = SAA7134_INPUT_TV,
 		       .vmux = 1,
 		       .amux = TV,
-		       .tv   = 1,
 		       .gpio = 0x0000000,
 	       }, {
 		       .type = SAA7134_INPUT_COMPOSITE1,
@@ -3842,7 +3714,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3875,7 +3746,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3906,7 +3776,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV, /* FIXME: analog tv untested */
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		}},
 	},
 	[SAA7134_BOARD_AVERMEDIA_M135A] = {
@@ -3922,7 +3791,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3956,7 +3824,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -3999,7 +3866,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.mute = {
 			.type = SAA7134_INPUT_MUTE,
@@ -4028,7 +3894,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_BEHOLD_403FM] = {
@@ -4053,7 +3918,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.radio = {
 			.type = SAA7134_INPUT_RADIO,
@@ -4083,7 +3947,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 	},
 	[SAA7134_BOARD_BEHOLD_405FM] = {
@@ -4110,7 +3973,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}},
 		.radio = {
 			.type = SAA7134_INPUT_RADIO,
@@ -4142,7 +4004,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv = 1,
 			.gpio = 0xc0c000,
 		}},
 	},
@@ -4171,7 +4032,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv = 1,
 			.gpio = 0xc0c000,
 		}},
 		.radio = {
@@ -4195,7 +4055,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4221,7 +4080,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4256,7 +4114,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4290,7 +4147,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4321,7 +4177,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4352,7 +4207,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4382,7 +4236,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x000A8004,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -4414,7 +4267,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4442,7 +4294,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4470,7 +4321,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4498,7 +4348,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4527,7 +4376,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4556,7 +4404,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4585,7 +4432,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4614,7 +4460,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		},{
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4646,7 +4491,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4683,7 +4527,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4722,7 +4565,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -4757,7 +4599,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -4787,13 +4628,11 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = LINE2,
 			.gpio = 0x0000,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x2000,
-			.tv = 1
 		}, {
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
@@ -4842,7 +4681,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -4867,7 +4705,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -4895,7 +4732,6 @@ struct saa7134_board saa7134_boards[] = {
 			 .type = SAA7134_INPUT_TV,
 			 .vmux = 1,
 			 .amux = TV,
-			 .tv   = 1,
 		 }, {
 			 .type = SAA7134_INPUT_COMPOSITE1,
 			 .vmux = 3,
@@ -4922,7 +4758,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 8,
@@ -4948,7 +4783,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -4972,7 +4806,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 1,
@@ -5019,7 +4852,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 4,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 1,
@@ -5048,7 +4880,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -5077,7 +4908,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 0,
@@ -5107,7 +4937,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 0,
@@ -5135,7 +4964,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = LINE2,
-			.tv     = 1,
 			.gpio   = 0x624000,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -5171,7 +4999,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 4,
@@ -5196,7 +5023,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 3,
@@ -5228,7 +5054,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = LINE2,
-			.tv     = 1,
 			.gpio   = 0x100,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -5267,7 +5092,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 #if 0	/* FIXME */
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -5308,7 +5132,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x01,
 		}, {
 			.type = SAA7134_INPUT_SVIDEO,
@@ -5341,7 +5164,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 			.gpio = 0x00,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -5397,7 +5219,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 2,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -5426,7 +5247,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		} },
 		.radio = {	/* untested */
 			.type = SAA7134_INPUT_RADIO,
@@ -5446,7 +5266,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 4,
@@ -5489,7 +5308,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -5539,7 +5357,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 2,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -5566,7 +5383,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 2,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -5594,7 +5410,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 3,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux   = 0,
@@ -5617,7 +5432,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
@@ -5652,7 +5466,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 			.gpio   = 0x00050000,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
@@ -5691,7 +5504,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -5720,7 +5532,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = LINE2,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 1,
@@ -5770,7 +5581,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux   = 1,
 			.amux   = TV,
-			.tv     = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux   = 3,
@@ -5819,7 +5629,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE,
 			.vmux = 4,
@@ -5851,7 +5660,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 3,
 			.amux = TV,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_SVIDEO,
 			.vmux = 6,
@@ -5872,7 +5680,6 @@ struct saa7134_board saa7134_boards[] = {
 			.type = SAA7134_INPUT_TV,
 			.vmux = 1,
 			.amux = LINE2,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 0,
@@ -5904,7 +5711,6 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux = 1,
 			.amux = LINE1,
 			.gpio = 0x00,
-			.tv   = 1,
 		}, {
 			.type = SAA7134_INPUT_COMPOSITE1,
 			.vmux = 3,
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 59781755247a..9debfb549887 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1384,10 +1384,16 @@ int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 	if (card_in(dev, i->index).type == SAA7134_NO_INPUT)
 		return -EINVAL;
 	i->index = n;
-	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, saa7134_input_name[card_in(dev, n).type]);
-	if (card_in(dev, n).tv)
+	switch (card_in(dev, n).type) {
+	case SAA7134_INPUT_TV:
+	case SAA7134_INPUT_TV_MONO:
 		i->type = V4L2_INPUT_TYPE_TUNER;
+		break;
+	default:
+		i->type  = V4L2_INPUT_TYPE_CAMERA;
+		break;
+	}
 	if (n == dev->ctl_input) {
 		int v1 = saa_readb(SAA7134_STATUS_VIDEO1);
 		int v2 = saa_readb(SAA7134_STATUS_VIDEO2);
@@ -1656,7 +1662,8 @@ int saa7134_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 	memset(t, 0, sizeof(*t));
 	for (n = 0; n < SAA7134_INPUT_MAX; n++) {
-		if (card_in(dev, n).tv)
+		if (card_in(dev, n).type == SAA7134_INPUT_TV ||
+		    card_in(dev, n).type == SAA7134_INPUT_TV_MONO)
 			break;
 	}
 	if (n == SAA7134_INPUT_MAX)
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 274a472e7d6b..e3e2392f87d6 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -384,7 +384,6 @@ struct saa7134_input {
 	unsigned int             vmux;
 	enum saa7134_audio_in    amux;
 	unsigned int             gpio;
-	unsigned int             tv:1;
 };
 
 enum saa7134_mpeg_type {
-- 
2.5.0


