Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/18] [media] cx88: fix cards table CodingStyle
Date: Wed, 24 Sep 2014 19:27:08 -0300
Message-Id: <8a74e66165214b9b59aaeddeb79032d1b8251a67.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is actually a coding style issue, but it was generating lots
of smatch warnings:

drivers/media/pci/cx88/cx88-cards.c:1513:37: warning: Initializer entry defined twice
drivers/media/pci/cx88/cx88-cards.c:1517:19:   also defined here
drivers/media/pci/cx88/cx88-cards.c:1533:36: warning: Initializer entry defined twice
drivers/media/pci/cx88/cx88-cards.c:1538:19:   also defined here
...

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index e18a7ace08b1..851754bf1291 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -78,19 +78,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 0,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE2,
 			.vmux   = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE3,
 			.vmux   = 2,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE4,
 			.vmux   = 3,
-		}},
+		} },
 	},
 	[CX88_BOARD_HAUPPAUGE] = {
 		.name		= "Hauppauge WinTV 34xxx models",
@@ -99,23 +99,23 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0xff00,  // internal decoder
-		},{
+		}, {
 			.type   = CX88_VMUX_DEBUG,
 			.vmux   = 0,
 			.gpio0  = 0xff01,  // mono from tuner chip
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0xff02,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0xff02,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0xff01,
@@ -127,13 +127,13 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
-		}},
+		} },
 	},
 	[CX88_BOARD_PIXELVIEW] = {
 		.name           = "PixelView",
@@ -141,17 +141,17 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0xff00,  // internal decoder
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
-		}},
+		} },
 		.radio = {
 			 .type  = CX88_RADIO,
 			 .gpio0 = 0xff10,
@@ -164,19 +164,19 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_INTERCARRIER,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x03ff,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x03fe,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x03fe,
-		}},
+		} },
 	},
 	[CX88_BOARD_WINFAST2000XP_EXPERT] = {
 		.name           = "Leadtek Winfast 2000XP Expert",
@@ -185,28 +185,28 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0	= 0x00F5e700,
 			.gpio1  = 0x00003004,
 			.gpio2  = 0x00F5e700,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0	= 0x00F5c700,
 			.gpio1  = 0x00003004,
 			.gpio2  = 0x00F5c700,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0	= 0x00F5c700,
 			.gpio1  = 0x00003004,
 			.gpio2  = 0x00F5c700,
 			.gpio3  = 0x02000000,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0	= 0x00F5d700,
@@ -222,19 +222,19 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio1  = 0xe09f,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio1  = 0xe05f,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio1  = 0xe05f,
-		}},
+		} },
 		.radio = {
 			.gpio1  = 0xe0df,
 			.type   = CX88_RADIO,
@@ -249,25 +249,25 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf	= TDA9887_PRESENT | TDA9887_INTERCARRIER_NTSC,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x000040bf,
 			.gpio1  = 0x000080c0,
 			.gpio2  = 0x0000ff40,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x000040bf,
 			.gpio1  = 0x000080c0,
 			.gpio2  = 0x0000ff40,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x000040bf,
 			.gpio1  = 0x000080c0,
 			.gpio2  = 0x0000ff40,
-		}},
+		} },
 		.radio = {
 			 .type   = CX88_RADIO,
 			 .vmux   = 3,
@@ -283,14 +283,14 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0035e700,
 			.gpio1  = 0x00003004,
 			.gpio2  = 0x0035e700,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
@@ -298,14 +298,14 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio1  = 0x00003004,
 			.gpio2  = 0x0035c700,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x0035c700,
 			.gpio1  = 0x0035c700,
 			.gpio2  = 0x02000000,
 			.gpio3  = 0x02000000,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x0035d700,
@@ -322,22 +322,22 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0000bde2,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x0000bde6,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x0000bde6,
 			.audioroute = 1,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x0000bd62,
@@ -351,16 +351,16 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 0,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE2,
 			.vmux   = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
-		}},
+		} },
 	},
 	[CX88_BOARD_PROLINK_PLAYTVPVR] = {
 		.name           = "Prolink PlayTV PVR",
@@ -369,19 +369,19 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf	= TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0xbff0,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0xbff3,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0xbff3,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0xbff0,
@@ -394,16 +394,16 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0000fde6,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x0000fde6, // 0x0000fda6 L,R RCA audio in?
 			.audioroute = 1,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x0000fde2,
@@ -417,22 +417,22 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00000fbf,
 			.gpio2  = 0x0000fc08,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x00000fbf,
 			.gpio2  = 0x0000fc68,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x00000fbf,
 			.gpio2  = 0x0000fc68,
-		}},
+		} },
 	},
 	[CX88_BOARD_KWORLD_DVB_T] = {
 		.name           = "KWorld/VStream XPert DVB-T",
@@ -440,17 +440,17 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x0700,
 			.gpio2  = 0x0101,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x0700,
 			.gpio2  = 0x0101,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_DVB_T1] = {
@@ -459,15 +459,15 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x000027df,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x000027df,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_KWORLD_LTV883] = {
@@ -476,23 +476,23 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x07f8,
-		},{
+		}, {
 			.type   = CX88_VMUX_DEBUG,
 			.vmux   = 0,
 			.gpio0  = 0x07f9,  // mono from tuner chip
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x000007fa,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x000007fa,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x000007f8,
@@ -521,23 +521,23 @@ static const struct cx88_board cx88_boards[] = {
 		    0 - normal RF
 		    1 - high RF
 		*/
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0	= 0x0f0d,
-		},{
+		}, {
 			.type   = CX88_VMUX_CABLE,
 			.vmux   = 0,
 			.gpio0	= 0x0f05,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0	= 0x0f00,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0	= 0x0f00,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_HAUPPAUGE_DVB_T1] = {
@@ -546,10 +546,10 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_CONEXANT_DVB_T1] = {
@@ -558,10 +558,10 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_PROVIDEO_PV259] = {
@@ -570,11 +570,11 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.audioroute = 1,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_BLACKBIRD,
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PLUS] = {
@@ -583,15 +583,15 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x000027df,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x000027df,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_DNTV_LIVE_DVB_T] = {
@@ -600,17 +600,17 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input		= {{
+		.input		= { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x00000700,
 			.gpio2  = 0x00000101,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x00000700,
 			.gpio2  = 0x00000101,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_PCHDTV_HD3000] = {
@@ -632,19 +632,19 @@ static const struct cx88_board cx88_boards[] = {
 		 *
 		 * GPIO[16] = Remote control input
 		 */
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00008484,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x00008400,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x00008400,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x00008404,
@@ -659,25 +659,25 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0xed1a,
 			.gpio2  = 0x00ff,
-		},{
+		}, {
 			.type   = CX88_VMUX_DEBUG,
 			.vmux   = 0,
 			.gpio0  = 0xff01,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0xff02,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0xed92,
 			.gpio2  = 0x00ff,
-		}},
+		} },
 		.radio = {
 			 .type   = CX88_RADIO,
 			 .gpio0  = 0xed96,
@@ -692,22 +692,22 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00009d80,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x00009d76,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x00009d76,
 			.audioroute = 1,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x00009d00,
@@ -722,19 +722,19 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 1,
 			.gpio1  = 0x0000e03f,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 2,
 			.gpio1  = 0x0000e07f,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 3,
 			.gpio1  = 0x0000e07f,
-		}}
+		} }
 	},
 	[CX88_BOARD_PIXELVIEW_PLAYTV_ULTRA_PRO] = {
 		.name           = "PixelView PlayTV Ultra Pro (Stereo)",
@@ -745,19 +745,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		/* Some variants use a tda9874 and so need the tvaudio module. */
 		.audio_chip     = CX88_AUDIO_TVAUDIO,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0xbf61,  /* internal decoder */
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0	= 0xbf63,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0	= 0xbf63,
-		}},
+		} },
 		.radio = {
 			 .type  = CX88_RADIO,
 			 .gpio0 = 0xbf60,
@@ -770,19 +770,19 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x97ed,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x97e9,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x97e9,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_ADSTECH_DVB_T_PCI] = {
@@ -791,32 +791,32 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x0700,
 			.gpio2  = 0x0101,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x0700,
 			.gpio2  = 0x0101,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1] = {
 		.name           = "TerraTec Cinergy 1400 DVB-T",
 		.tuner_type     = TUNER_ABSENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 2,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD] = {
@@ -826,19 +826,19 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x87fd,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x87f9,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x87f9,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_AVERMEDIA_ULTRATV_MC_550] = {
@@ -848,22 +848,22 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 0,
 			.gpio0  = 0x0000cd73,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 1,
 			.gpio0  = 0x0000cd73,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 3,
 			.gpio0  = 0x0000cdb3,
 			.audioroute = 1,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.vmux   = 2,
@@ -876,21 +876,21 @@ static const struct cx88_board cx88_boards[] = {
 		 /* Alexander Wold <awold@bigfoot.com> */
 		 .name           = "Kworld V-Stream Xpert DVD",
 		 .tuner_type     = UNSET,
-		 .input          = {{
+		 .input          = { {
 			 .type   = CX88_VMUX_COMPOSITE1,
 			 .vmux   = 1,
 			 .gpio0  = 0x03000000,
 			 .gpio1  = 0x01000000,
 			 .gpio2  = 0x02000000,
 			 .gpio3  = 0x00100000,
-		 },{
+		 }, {
 			 .type   = CX88_VMUX_SVIDEO,
 			 .vmux   = 2,
 			 .gpio0  = 0x03000000,
 			 .gpio1  = 0x01000000,
 			 .gpio2  = 0x02000000,
 			 .gpio3  = 0x00100000,
-		 }},
+		 } },
 	},
 	[CX88_BOARD_ATI_HDTVWONDER] = {
 		.name           = "ATI HDTV Wonder",
@@ -898,28 +898,28 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00000ff7,
 			.gpio1  = 0x000000ff,
 			.gpio2  = 0x00000001,
 			.gpio3  = 0x00000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x00000ffe,
 			.gpio1  = 0x000000ff,
 			.gpio2  = 0x00000001,
 			.gpio3  = 0x00000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x00000ffe,
 			.gpio1  = 0x000000ff,
 			.gpio2  = 0x00000001,
 			.gpio3  = 0x00000000,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_WINFAST_DTV1000] = {
@@ -928,16 +928,16 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_AVERTV_303] = {
@@ -947,28 +947,28 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00ff,
 			.gpio1  = 0xe09f,
 			.gpio2  = 0x0010,
 			.gpio3  = 0x0000,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x00ff,
 			.gpio1  = 0xe05f,
 			.gpio2  = 0x0010,
 			.gpio3  = 0x0000,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x00ff,
 			.gpio1  = 0xe05f,
 			.gpio2  = 0x0010,
 			.gpio3  = 0x0000,
-		}},
+		} },
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1] = {
 		.name		= "Hauppauge Nova-S-Plus DVB-S",
@@ -978,22 +978,22 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.audio_chip	= CX88_AUDIO_WM8775,
 		.i2sinputcntl   = 2,
-		.input		= {{
+		.input		= { {
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
 			/* 2: Line-In */
 			.audioroute = 2,
-		},{
+		}, {
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
 			/* 2: Line-In */
 			.audioroute = 2,
-		},{
+		}, {
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
 			/* 2: Line-In */
 			.audioroute = 2,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASE2_S1] = {
@@ -1002,10 +1002,10 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input		= {{
+		.input		= { {
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_KWORLD_DVBS_100] = {
@@ -1015,22 +1015,22 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.audio_chip = CX88_AUDIO_WM8775,
-		.input		= {{
+		.input		= { {
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
 			/* 2: Line-In */
 			.audioroute = 2,
-		},{
+		}, {
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
 			/* 2: Line-In */
 			.audioroute = 2,
-		},{
+		}, {
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
 			/* 2: Line-In */
 			.audioroute = 2,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_HAUPPAUGE_HVR1100] = {
@@ -1040,16 +1040,16 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input		= {{
+		.input		= { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
-		},{
+		}, {
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
-		},{
+		}, {
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
-		}},
+		} },
 		/* fixme: Add radio support */
 		.mpeg           = CX88_MPEG_DVB,
 	},
@@ -1060,13 +1060,13 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input		= {{
+		.input		= { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
-		},{
+		}, {
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
-		}},
+		} },
 		/* fixme: Add radio support */
 		.mpeg           = CX88_MPEG_DVB,
 	},
@@ -1078,19 +1078,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE |
 				  TDA9887_PORT2_ACTIVE,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0xf80808,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0	= 0xf80808,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0	= 0xf80808,
-		}},
+		} },
 		.radio = {
 			 .type  = CX88_RADIO,
 			 .gpio0 = 0xf80808,
@@ -1106,17 +1106,17 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x0700,
 			.gpio2  = 0x0101,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x0700,
 			.gpio2  = 0x0101,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL] = {
@@ -1125,15 +1125,15 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x000067df,
-		 },{
+		 }, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x000067df,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_KWORLD_HARDWARE_MPEG_TV_XPERT] = {
@@ -1142,22 +1142,22 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x3de2,
 			.gpio2  = 0x00ff,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x3de6,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x3de6,
 			.audioroute = 1,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x3de6,
@@ -1171,19 +1171,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0000a75f,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x0000a75b,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x0000a75b,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_PCHDTV_HD5500] = {
@@ -1193,19 +1193,19 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x87fd,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x87f9,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x87f9,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_KWORLD_MCE200_DELUXE] = {
@@ -1217,11 +1217,11 @@ static const struct cx88_board cx88_boards[] = {
 		.tda9887_conf   = TDA9887_PRESENT,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0000BDE6
-		}},
+		} },
 		.mpeg           = CX88_MPEG_BLACKBIRD,
 	},
 	[CX88_BOARD_PIXELVIEW_PLAYTV_P7000] = {
@@ -1233,11 +1233,11 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_addr	= ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT | TDA9887_PORT1_ACTIVE |
 				  TDA9887_PORT2_ACTIVE,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x5da6,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_BLACKBIRD,
 	},
 	[CX88_BOARD_NPGTECH_REALTV_TOP10FM] = {
@@ -1246,19 +1246,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0	= 0x0788,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0	= 0x078b,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0	= 0x078b,
-		}},
+		} },
 		.radio = {
 			 .type  = CX88_RADIO,
 			 .gpio0 = 0x074a,
@@ -1271,7 +1271,7 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00017304,
@@ -1299,7 +1299,7 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio1  = 0x0000b207,
 			.gpio2  = 0x0001d701,
 			.gpio3  = 0x02000000,
-		}},
+		} },
 		.radio = {
 			 .type  = CX88_RADIO,
 			 .gpio0 = 0x00015702,
@@ -1316,35 +1316,35 @@ static const struct cx88_board cx88_boards[] = {
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00017300,
 			.gpio1  = 0x00008207,
 			.gpio2	= 0x00000000,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x00018300,
 			.gpio1  = 0x0000f207,
 			.gpio2	= 0x00017304,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x00018301,
 			.gpio1  = 0x0000f207,
 			.gpio2	= 0x00017304,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x00018301,
 			.gpio1  = 0x0000f207,
 			.gpio2	= 0x00017304,
 			.gpio3  = 0x02000000,
-		}},
+		} },
 		.radio = {
 			 .type  = CX88_RADIO,
 			 .gpio0 = 0x00015702,
@@ -1360,13 +1360,13 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type    = UNSET,
 		.tuner_addr    = ADDR_UNSET,
 		.radio_addr    = ADDR_UNSET,
-		.input  = {{
+		.input  = { {
 			.type  = CX88_VMUX_DVB,
 			.vmux  = 0,
-		},{
+		}, {
 			.type  = CX88_VMUX_COMPOSITE1,
 			.vmux  = 1,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_HAUPPAUGE_HVR3000] = {
@@ -1377,25 +1377,25 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.audio_chip     = CX88_AUDIO_WM8775,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x84bf,
 			/* 1: TV Audio / FM Mono */
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x84bf,
 			/* 2: Line-In */
 			.audioroute = 2,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x84bf,
 			/* 2: Line-In */
 			.audioroute = 2,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0	= 0x84bf,
@@ -1411,19 +1411,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0709,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x070b,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x070b,
-		}},
+		} },
 	},
 	[CX88_BOARD_TE_DTV_250_OEM_SWANN] = {
 		.name           = "Shenzhen Tungsten Ages Tech TE-DTV-250 / Swann OEM",
@@ -1431,28 +1431,28 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x003fffff,
 			.gpio1  = 0x00e00000,
 			.gpio2  = 0x003fffff,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x003fffff,
 			.gpio1  = 0x00e00000,
 			.gpio2  = 0x003fffff,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x003fffff,
 			.gpio1  = 0x00e00000,
 			.gpio2  = 0x003fffff,
 			.gpio3  = 0x02000000,
-		}},
+		} },
 	},
 	[CX88_BOARD_HAUPPAUGE_HVR1300] = {
 		.name		= "Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder",
@@ -1465,25 +1465,25 @@ static const struct cx88_board cx88_boards[] = {
 		/*
 		 * gpio0 as reported by Mike Crash <mike AT mikecrash.com>
 		 */
-		.input		= {{
+		.input		= { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0	= 0xef88,
 			/* 1: TV Audio / FM Mono */
 			.audioroute = 1,
-		},{
+		}, {
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
 			.gpio0	= 0xef88,
 			/* 2: Line-In */
 			.audioroute = 2,
-		},{
+		}, {
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
 			.gpio0	= 0xef88,
 			/* 2: Line-In */
 			.audioroute = 2,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB | CX88_MPEG_BLACKBIRD,
 		.radio = {
 			.type   = CX88_RADIO,
@@ -1510,19 +1510,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DEBUG,
 			.vmux   = 3,
 			.gpio0  = 0x04ff,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x07fa,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x07fa,
-		}},
+		} },
 	},
 	[CX88_BOARD_PINNACLE_PCTV_HD_800i] = {
 		.name           = "Pinnacle PCTV HD 800i",
@@ -1530,24 +1530,24 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x04fb,
 			.gpio1  = 0x10ff,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x04fb,
 			.gpio1  = 0x10ef,
 			.audioroute = 1,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x04fb,
 			.gpio1  = 0x10ef,
 			.audioroute = 1,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO] = {
@@ -1557,7 +1557,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x000027df, /* Unconfirmed */
@@ -1815,19 +1815,19 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x10df,
-		},{
+		}, {
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
 			.gpio0  = 0x16d9,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
 			.gpio0  = 0x16d9,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_PROLINK_PV_8000GT] = {
@@ -1967,7 +1967,7 @@ static const struct cx88_board cx88_boards[] = {
 		 * 3: Line-In Expansion
 		 * 4: FM Stereo
 		 */
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0xc4bf,
@@ -2001,7 +2001,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2013,7 +2013,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2025,7 +2025,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2037,7 +2037,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2049,7 +2049,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2061,7 +2061,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2073,7 +2073,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 			.gpio0  = 0x8080,
@@ -2086,7 +2086,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2098,7 +2098,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2110,7 +2110,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
 		} },
@@ -2170,7 +2170,7 @@ static const struct cx88_board cx88_boards[] = {
 		 * 13: audio source (0=tuner audio,1=line in)
 		 * 14: FM (0=on,1=off ???)
 		 */
-		.input          = {{
+		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0400,       /* pin 2 = 0 */
@@ -2211,7 +2211,7 @@ static const struct cx88_board cx88_boards[] = {
 		 * 13: audio source (0=tuner audio,1=line in)
 		 * 14: FM (0=on,1=off ???)
 		 */
-		.input		= {{
+		.input		= { {
 			.type	= CX88_VMUX_TELEVISION,
 			.vmux	= 0,
 			.gpio0	= 0x0400,	/* pin 2 = 0 */
@@ -2229,7 +2229,7 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio0	= 0x0400,	/* pin 2 = 0 */
 			.gpio1	= 0x6060,	/* pin 13 = 1, pin 14 = 1 */
 			.gpio2	= 0x0000,
-		}},
+		} },
 		.radio = {
 			.type	= CX88_RADIO,
 			.gpio0	= 0x0400,	/* pin 2 = 0 */
@@ -2252,7 +2252,7 @@ static const struct cx88_board cx88_boards[] = {
 		 *  14: 0: FM radio
 		 *  16: 0: RF input is cable
 		 */
-		.input		= {{
+		.input		= { {
 			.type	= CX88_VMUX_TELEVISION,
 			.vmux	= 0,
 			.gpio0	= 0x0403,
@@ -2280,7 +2280,7 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio1	= 0xF0F7,
 			.gpio2	= 0x0101,
 			.gpio3	= 0x0000,
-		}},
+		} },
 		.radio = {
 			.type	= CX88_RADIO,
 			.gpio0	= 0x0403,
@@ -2308,7 +2308,7 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.input          = {{
+		.input          = { {
 		       .type   = CX88_VMUX_DVB,
 		       .vmux   = 0,
 		} },
@@ -2324,19 +2324,19 @@ static const struct cx88_subid cx88_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0x3400,
 		.card      = CX88_BOARD_HAUPPAUGE,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x3401,
 		.card      = CX88_BOARD_HAUPPAUGE,
-	},{
+	}, {
 		.subvendor = 0x14c7,
 		.subdevice = 0x0106,
 		.card      = CX88_BOARD_GDI,
-	},{
+	}, {
 		.subvendor = 0x14c7,
 		.subdevice = 0x0107, /* with mpeg encoder */
 		.card      = CX88_BOARD_GDI,
-	},{
+	}, {
 		.subvendor = PCI_VENDOR_ID_ATI,
 		.subdevice = 0x00f8,
 		.card      = CX88_BOARD_ATI_WONDER_PRO,
@@ -2348,176 +2348,176 @@ static const struct cx88_subid cx88_subids[] = {
 		.subvendor = 0x107d,
 		.subdevice = 0x6611,
 		.card      = CX88_BOARD_WINFAST2000XP_EXPERT,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x6613,	/* NTSC */
 		.card      = CX88_BOARD_WINFAST2000XP_EXPERT,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x6620,
 		.card      = CX88_BOARD_WINFAST_DV2000,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x663b,
 		.card      = CX88_BOARD_LEADTEK_PVR2000,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x663c,
 		.card      = CX88_BOARD_LEADTEK_PVR2000,
-	},{
+	}, {
 		.subvendor = 0x1461,
 		.subdevice = 0x000b,
 		.card      = CX88_BOARD_AVERTV_STUDIO_303,
-	},{
+	}, {
 		.subvendor = 0x1462,
 		.subdevice = 0x8606,
 		.card      = CX88_BOARD_MSI_TVANYWHERE_MASTER,
-	},{
+	}, {
 		.subvendor = 0x10fc,
 		.subdevice = 0xd003,
 		.card      = CX88_BOARD_IODATA_GVVCP3PCI,
-	},{
+	}, {
 		.subvendor = 0x1043,
 		.subdevice = 0x4823,  /* with mpeg encoder */
 		.card      = CX88_BOARD_ASUS_PVR_416,
-	},{
+	}, {
 		.subvendor = 0x17de,
 		.subdevice = 0x08a6,
 		.card      = CX88_BOARD_KWORLD_DVB_T,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xd810,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xd820,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_T,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb00,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_DVB_T1,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9002,
 		.card      = CX88_BOARD_HAUPPAUGE_DVB_T1,
-	},{
+	}, {
 		.subvendor = 0x14f1,
 		.subdevice = 0x0187,
 		.card      = CX88_BOARD_CONEXANT_DVB_T1,
-	},{
+	}, {
 		.subvendor = 0x1540,
 		.subdevice = 0x2580,
 		.card      = CX88_BOARD_PROVIDEO_PV259,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb10,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PLUS,
-	},{
+	}, {
 		.subvendor = 0x1554,
 		.subdevice = 0x4811,
 		.card      = CX88_BOARD_PIXELVIEW,
-	},{
+	}, {
 		.subvendor = 0x7063,
 		.subdevice = 0x3000, /* HD-3000 card */
 		.card      = CX88_BOARD_PCHDTV_HD3000,
-	},{
+	}, {
 		.subvendor = 0x17de,
 		.subdevice = 0xa8a6,
 		.card      = CX88_BOARD_DNTV_LIVE_DVB_T,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x2801,
 		.card      = CX88_BOARD_HAUPPAUGE_ROSLYN,
-	},{
+	}, {
 		.subvendor = 0x14f1,
 		.subdevice = 0x0342,
 		.card      = CX88_BOARD_DIGITALLOGIC_MEC,
-	},{
+	}, {
 		.subvendor = 0x10fc,
 		.subdevice = 0xd035,
 		.card      = CX88_BOARD_IODATA_GVBCTV7E,
-	},{
+	}, {
 		.subvendor = 0x1421,
 		.subdevice = 0x0334,
 		.card      = CX88_BOARD_ADSTECH_DVB_T_PCI,
-	},{
+	}, {
 		.subvendor = 0x153b,
 		.subdevice = 0x1166,
 		.card      = CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xd500,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD,
-	},{
+	}, {
 		.subvendor = 0x1461,
 		.subdevice = 0x8011,
 		.card      = CX88_BOARD_AVERMEDIA_ULTRATV_MC_550,
-	},{
+	}, {
 		.subvendor = PCI_VENDOR_ID_ATI,
 		.subdevice = 0xa101,
 		.card      = CX88_BOARD_ATI_HDTVWONDER,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x665f,
 		.card      = CX88_BOARD_WINFAST_DTV1000,
-	},{
+	}, {
 		.subvendor = 0x1461,
 		.subdevice = 0x000a,
 		.card      = CX88_BOARD_AVERTV_303,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9200,
 		.card      = CX88_BOARD_HAUPPAUGE_NOVASE2_S1,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9201,
 		.card      = CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9202,
 		.card      = CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1,
-	},{
+	}, {
 		.subvendor = 0x17de,
 		.subdevice = 0x08b2,
 		.card      = CX88_BOARD_KWORLD_DVBS_100,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9400,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR1100,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9402,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR1100,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9800,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR1100LP,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9802,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR1100LP,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9001,
 		.card      = CX88_BOARD_HAUPPAUGE_DVB_T1,
-	},{
+	}, {
 		.subvendor = 0x1822,
 		.subdevice = 0x0025,
 		.card      = CX88_BOARD_DNTV_LIVE_DVB_T_PRO,
-	},{
+	}, {
 		.subvendor = 0x17de,
 		.subdevice = 0x08a1,
 		.card      = CX88_BOARD_KWORLD_DVB_T_CX22702,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb50,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb54,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL,
 		/* Re-branded DViCO: DigitalNow DVB-T Dual */
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb11,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PLUS,
@@ -2530,55 +2530,55 @@ static const struct cx88_subid cx88_subids[] = {
 		.subvendor = 0x17de,
 		.subdevice = 0x0840,
 		.card      = CX88_BOARD_KWORLD_HARDWARE_MPEG_TV_XPERT,
-	},{
+	}, {
 		.subvendor = 0x1421,
 		.subdevice = 0x0305,
 		.card      = CX88_BOARD_KWORLD_HARDWARE_MPEG_TV_XPERT,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb40,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_HYBRID,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb44,
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_HYBRID,
-	},{
+	}, {
 		.subvendor = 0x7063,
 		.subdevice = 0x5500,
 		.card      = CX88_BOARD_PCHDTV_HD5500,
-	},{
+	}, {
 		.subvendor = 0x17de,
 		.subdevice = 0x0841,
 		.card      = CX88_BOARD_KWORLD_MCE200_DELUXE,
-	},{
+	}, {
 		.subvendor = 0x1822,
 		.subdevice = 0x0019,
 		.card      = CX88_BOARD_DNTV_LIVE_DVB_T_PRO,
-	},{
+	}, {
 		.subvendor = 0x1554,
 		.subdevice = 0x4813,
 		.card      = CX88_BOARD_PIXELVIEW_PLAYTV_P7000,
-	},{
+	}, {
 		.subvendor = 0x14f1,
 		.subdevice = 0x0842,
 		.card      = CX88_BOARD_NPGTECH_REALTV_TOP10FM,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x665e,
 		.card      = CX88_BOARD_WINFAST_DTV2000H,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x6f2b,
 		.card      = CX88_BOARD_WINFAST_DTV2000H_J,
-	},{
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
-	},{
+	}, {
 		.subvendor = 0x14f1,
 		.subdevice = 0x0084,
 		.card      = CX88_BOARD_GENIATECH_DVBS,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x1404,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR3000,
@@ -2590,60 +2590,60 @@ static const struct cx88_subid cx88_subids[] = {
 		.subvendor = 0x18ac,
 		.subdevice = 0xdccd,
 		.card      = CX88_BOARD_SAMSUNG_SMT_7020,
-	},{
+	}, {
 		.subvendor = 0x1461,
 		.subdevice = 0xc111, /* AverMedia M150-D */
 		/* This board is known to work with the ASUS PVR416 config */
 		.card      = CX88_BOARD_ASUS_PVR_416,
-	},{
+	}, {
 		.subvendor = 0xc180,
 		.subdevice = 0xc980,
 		.card      = CX88_BOARD_TE_DTV_250_OEM_SWANN,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9600,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR1300,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9601,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR1300,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9602,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR1300,
-	},{
+	}, {
 		.subvendor = 0x107d,
 		.subdevice = 0x6632,
 		.card      = CX88_BOARD_LEADTEK_PVR2000,
-	},{
+	}, {
 		.subvendor = 0x12ab,
 		.subdevice = 0x2300, /* Club3D Zap TV2100 */
 		.card      = CX88_BOARD_KWORLD_DVB_T_CX22702,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x9000,
 		.card      = CX88_BOARD_HAUPPAUGE_DVB_T1,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x1400,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR3000,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x1401,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR3000,
-	},{
+	}, {
 		.subvendor = 0x0070,
 		.subdevice = 0x1402,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR3000,
-	},{
+	}, {
 		.subvendor = 0x1421,
 		.subdevice = 0x0341, /* ADS Tech InstantTV DVB-S */
 		.card      = CX88_BOARD_KWORLD_DVBS_100,
-	},{
+	}, {
 		.subvendor = 0x1421,
 		.subdevice = 0x0390,
 		.card      = CX88_BOARD_ADSTECH_PTV_390,
-	},{
+	}, {
 		.subvendor = 0x11bd,
 		.subdevice = 0x0051,
 		.card      = CX88_BOARD_PINNACLE_PCTV_HD_800i,
-- 
1.9.3

