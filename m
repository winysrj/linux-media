Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59442 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2D0HHT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 03:07:19 -0400
Received: by pbbrp8 with SMTP id rp8so210985pbb.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 00:07:18 -0700 (PDT)
Date: Fri, 27 Apr 2012 15:07:20 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>,
 <201204152353103757288@gmail.com>,
 <201204201601166255937@gmail.com>,
 <4F9130BB.8060107@iki.fi>,
 <201204211045557968605@gmail.com>,
 <4F958640.9010404@iki.fi>,
 <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>,
 <201204262103053283195@gmail.com>,
 <4F994CA8.8060200@redhat.com>
Subject: [PATCH 4/6 v2] dvbsky, dvb-s/s2 PCI card
Message-ID: <201204271507178436491@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also fix the code style errors checked by checkpatch.pl.
---
 drivers/media/video/cx88/Kconfig      |    2 +
 drivers/media/video/cx88/cx88-cards.c |  682 ++++++++++++++++++---------------
 drivers/media/video/cx88/cx88-dvb.c   |  270 +++++++++----
 drivers/media/video/cx88/cx88-input.c |   12 +-
 drivers/media/video/cx88/cx88.h       |   53 +--
 5 files changed, 604 insertions(+), 415 deletions(-)

diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index 3598dc0..ef21a82 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -57,6 +57,8 @@ config VIDEO_CX88_DVB
 	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
+	select DVB_M88TS202X if !DVB_FE_CUSTOMISE
+	select DVB_M88DS3103 if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index cbd5d11..7a017f0 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -38,13 +38,13 @@ module_param_array(tuner, int, NULL, 0444);
 module_param_array(radio, int, NULL, 0444);
 module_param_array(card,  int, NULL, 0444);
 
-MODULE_PARM_DESC(tuner,"tuner type");
-MODULE_PARM_DESC(radio,"radio tuner type");
-MODULE_PARM_DESC(card,"card type");
+MODULE_PARM_DESC(tuner, "tuner type");
+MODULE_PARM_DESC(radio, "radio tuner type");
+MODULE_PARM_DESC(card, "card type");
 
 static unsigned int latency = UNSET;
-module_param(latency,int,0444);
-MODULE_PARM_DESC(latency,"pci latency timer");
+module_param(latency, int, 0444);
+MODULE_PARM_DESC(latency, "pci latency timer");
 
 static int disable_ir;
 module_param(disable_ir, int, 0444);
@@ -76,16 +76,16 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
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
@@ -97,20 +97,20 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
-			.gpio0  = 0xff00,  // internal decoder
-		},{
+			.gpio0  = 0xff00,  /* internal decoder */
+		}, {
 			.type   = CX88_VMUX_DEBUG,
 			.vmux   = 0,
-			.gpio0  = 0xff01,  // mono from tuner chip
-		},{
+			.gpio0  = 0xff01,  /* mono from tuner chip */
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
@@ -125,10 +125,10 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
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
@@ -139,14 +139,14 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
-			.gpio0  = 0xff00,  // internal decoder
-		},{
+			.gpio0  = 0xff00,  /* internal decoder */
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
@@ -163,15 +163,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -187,21 +187,21 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -221,23 +221,23 @@ static const struct cx88_board cx88_boards[] = {
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
 		},
 	},
 	[CX88_BOARD_MSI_TVANYWHERE_MASTER] = {
-		// added gpio values thanks to Michal
-		// values for PAL from DScaler
+		/* added gpio values thanks to Michal */
+		/* values for PAL from DScaler */
 		.name           = "MSI TV-@nywhere Master",
 		.tuner_type     = TUNER_MT2032,
 		.radio_type     = UNSET,
@@ -250,19 +250,19 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -285,7 +285,7 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio1  = 0x00003004,
 			.gpio2  = 0x0035e700,
 			.gpio3  = 0x02000000,
-		},{
+		}, {
 
 			.type   = CX88_VMUX_COMPOSITE1,
 			.vmux   = 1,
@@ -293,14 +293,14 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -310,7 +310,7 @@ static const struct cx88_board cx88_boards[] = {
 		},
 	},
 	[CX88_BOARD_LEADTEK_PVR2000] = {
-		// gpio values for PAL version from regspy by DScaler
+		/* gpio values for PAL version from regspy by DScaler */
 		.name           = "Leadtek PVR 2000",
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     = UNSET,
@@ -322,17 +322,17 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -349,13 +349,13 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
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
@@ -368,15 +368,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -393,12 +393,12 @@ static const struct cx88_board cx88_boards[] = {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0000fde6,
-		},{
+		}, {
 			.type   = CX88_VMUX_SVIDEO,
 			.vmux   = 2,
-			.gpio0  = 0x0000fde6, // 0x0000fda6 L,R RCA audio in?
+			.gpio0  = 0x0000fde6, /* 0x0000fda6 L,R RCA audio in? */
 			.audioroute = 1,
-		}},
+		} },
 		.radio = {
 			.type   = CX88_RADIO,
 			.gpio0  = 0x0000fde2,
@@ -417,17 +417,17 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -440,12 +440,12 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -458,11 +458,11 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -475,19 +475,19 @@ static const struct cx88_board cx88_boards[] = {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x07f8,
-		},{
+		}, {
 			.type   = CX88_VMUX_DEBUG,
 			.vmux   = 0,
-			.gpio0  = 0x07f9,  // mono from tuner chip
-		},{
+			.gpio0  = 0x07f9,  /* mono from tuner chip */
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
@@ -520,19 +520,19 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -544,7 +544,7 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_CONEXANT_DVB_T1] = {
@@ -556,7 +556,7 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
 			.type   = CX88_VMUX_DVB,
 			.vmux   = 0,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_PROVIDEO_PV259] = {
@@ -569,7 +569,7 @@ static const struct cx88_board cx88_boards[] = {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.audioroute = 1,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_BLACKBIRD,
 	},
 	[CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PLUS] = {
@@ -582,11 +582,11 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -600,12 +600,12 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -631,15 +631,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -647,8 +647,8 @@ static const struct cx88_board cx88_boards[] = {
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_HAUPPAUGE_ROSLYN] = {
-		// entry added by Kaustubh D. Bhalerao <bhalerao.1@osu.edu>
-		// GPIO values obtained from regspy, courtesy Sean Covel
+		/* entry added by Kaustubh D. Bhalerao <bhalerao.1@osu.edu>*/
+		/* GPIO values obtained from regspy, courtesy Sean Covel*/
 		.name           = "Hauppauge WinTV 28xxx (Roslyn) models",
 		.tuner_type     = UNSET,
 		.radio_type     = UNSET,
@@ -659,20 +659,20 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -681,7 +681,8 @@ static const struct cx88_board cx88_boards[] = {
 		.mpeg           = CX88_MPEG_BLACKBIRD,
 	},
 	[CX88_BOARD_DIGITALLOGIC_MEC] = {
-		.name           = "Digital-Logic MICROSPACE Entertainment Center (MEC)",
+		.name           =
+		"Digital-Logic MICROSPACE Entertainment Center (MEC)",
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
@@ -692,17 +693,17 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -721,15 +722,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -738,21 +739,21 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		/* Some variants use a tda9874 and so need the tvaudio module. */
+	/* Some variants use a tda9874 and so need the tvaudio module. */
 		.audio_chip     = V4L2_IDENT_TVAUDIO,
 		.input          = {{
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
@@ -769,15 +770,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -791,12 +792,12 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -805,13 +806,13 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
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
@@ -825,15 +826,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -848,17 +849,17 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -878,14 +879,14 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -900,21 +901,21 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -926,13 +927,13 @@ static const struct cx88_board cx88_boards[] = {
 		.input          = {{
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
@@ -949,21 +950,21 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -978,17 +979,17 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1000,7 +1001,7 @@ static const struct cx88_board cx88_boards[] = {
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_KWORLD_DVBS_100] = {
@@ -1015,17 +1016,17 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1038,18 +1039,19 @@ static const struct cx88_board cx88_boards[] = {
 		.input		= {{
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
 	[CX88_BOARD_HAUPPAUGE_HVR1100LP] = {
-		.name		= "Hauppauge WinTV-HVR1100 DVB-T/Hybrid (Low Profile)",
+		.name		=
+		"Hauppauge WinTV-HVR1100 DVB-T/Hybrid (Low Profile)",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
@@ -1058,10 +1060,10 @@ static const struct cx88_board cx88_boards[] = {
 		.input		= {{
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
@@ -1077,15 +1079,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1106,12 +1108,12 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1124,11 +1126,11 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1142,17 +1144,17 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1170,15 +1172,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1192,15 +1194,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1216,7 +1218,7 @@ static const struct cx88_board cx88_boards[] = {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x0000BDE6
-		}},
+		} },
 		.mpeg           = CX88_MPEG_BLACKBIRD,
 	},
 	[CX88_BOARD_PIXELVIEW_PLAYTV_P7000] = {
@@ -1232,7 +1234,7 @@ static const struct cx88_board cx88_boards[] = {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0  = 0x5da6,
-		}},
+		} },
 		.mpeg           = CX88_MPEG_BLACKBIRD,
 	},
 	[CX88_BOARD_NPGTECH_REALTV_TOP10FM] = {
@@ -1245,15 +1247,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1294,7 +1296,7 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio1  = 0x0000b207,
 			.gpio2  = 0x0001d701,
 			.gpio3  = 0x02000000,
-		}},
+		} },
 		.radio = {
 			 .type  = CX88_RADIO,
 			 .gpio0 = 0x00015702,
@@ -1318,28 +1320,28 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1358,14 +1360,15 @@ static const struct cx88_board cx88_boards[] = {
 		.input  = {{
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
-		.name           = "Hauppauge WinTV-HVR3000 TriMode Analog/DVB-S/DVB-T",
+		.name           =
+			"Hauppauge WinTV-HVR3000 TriMode Analog/DVB-S/DVB-T",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
@@ -1378,19 +1381,19 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1410,18 +1413,19 @@ static const struct cx88_board cx88_boards[] = {
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
-		.name           = "Shenzhen Tungsten Ages Tech TE-DTV-250 / Swann OEM",
+		.name           =
+			"Shenzhen Tungsten Ages Tech TE-DTV-250 / Swann OEM",
 		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
@@ -1433,24 +1437,25 @@ static const struct cx88_board cx88_boards[] = {
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
-		.name		= "Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder",
+		.name		=
+			"Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
@@ -1466,19 +1471,19 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1509,15 +1514,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1530,19 +1535,19 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -1716,16 +1721,21 @@ static const struct cx88_board cx88_boards[] = {
 		},
 	},
 	[CX88_BOARD_POWERCOLOR_REAL_ANGEL] = {
-		.name           = "PowerColor RA330",	/* Long names may confuse LIRC. */
+		.name           = "PowerColor RA330",
+/* Long names may confuse LIRC. */
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
 		.input          = { {
 			.type   = CX88_VMUX_DEBUG,
-			.vmux   = 3,		/* Due to the way the cx88 driver is written,	*/
-			.gpio0 = 0x00ff,	/* there is no way to deactivate audio pass-	*/
-			.gpio1 = 0xf39d,	/* through without this entry. Furthermore, if	*/
-			.gpio3 = 0x0000,	/* the TV mux entry is first, you get audio	*/
-		}, {				/* from the tuner on boot for a little while.	*/
+			.vmux   = 3,
+/* Due to the way the cx88 driver is written,	*/
+			.gpio0 = 0x00ff,
+/* there is no way to deactivate audio pass-	*/
+			.gpio1 = 0xf39d,
+/* through without this entry. Furthermore, if	*/
+			.gpio3 = 0x0000,
+/* the TV mux entry is first, you get audio	*/
+		}, {	/* from the tuner on boot for a little while.	*/
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
 			.gpio0 = 0x00ff,
@@ -1814,15 +1824,15 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -2224,7 +2234,7 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio0	= 0x0400,	/* pin 2 = 0 */
 			.gpio1	= 0x6060,	/* pin 13 = 1, pin 14 = 1 */
 			.gpio2	= 0x0000,
-		}},
+		} },
 		.radio = {
 			.type	= CX88_RADIO,
 			.gpio0	= 0x0400,	/* pin 2 = 0 */
@@ -2275,7 +2285,7 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio1	= 0xF0F7,
 			.gpio2	= 0x0101,
 			.gpio3	= 0x0000,
-		}},
+		} },
 		.radio = {
 			.type	= CX88_RADIO,
 			.gpio0	= 0x0403,
@@ -2309,6 +2319,18 @@ static const struct cx88_board cx88_boards[] = {
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_BST_PS8312] = {
+		.name           = "Bestunar PS8312 DVB-S/S2",
+		.tuner_type     = UNSET,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = {{
+			.type   = CX88_VMUX_DVB,
+			.vmux   = 0,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2319,19 +2341,19 @@ static const struct cx88_subid cx88_subids[] = {
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
@@ -2343,176 +2365,176 @@ static const struct cx88_subid cx88_subids[] = {
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
@@ -2525,55 +2547,55 @@ static const struct cx88_subid cx88_subids[] = {
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
@@ -2585,60 +2607,60 @@ static const struct cx88_subid cx88_subids[] = {
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
@@ -2801,7 +2823,7 @@ static const struct cx88_subid cx88_subids[] = {
 		.subdevice = 0x6f36,
 		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36,
 	}, {
-		/* WinFast TV2000 XP Global with XC4000 tuner and different GPIOs */
+	/* WinFast TV2000 XP Global with XC4000 tuner and different GPIOs */
 		.subvendor = 0x107d,
 		.subdevice = 0x6f43,
 		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43,
@@ -2813,6 +2835,10 @@ static const struct cx88_subid cx88_subids[] = {
 		.subvendor = 0x1822,
 		.subdevice = 0x0023,
 		.card      = CX88_BOARD_TWINHAN_VP1027_DVBS,
+	}, {
+		.subvendor = 0x14f1,
+		.subdevice = 0x8312,
+		.card      = CX88_BOARD_BST_PS8312,
 	},
 };
 
@@ -2857,19 +2883,30 @@ static void hauppauge_eeprom(struct cx88_core *core, u8 *eeprom_data)
 	core->board.radio.type = tv.has_radio ? CX88_RADIO : 0;
 
 	/* Make sure we support the board model */
-	switch (tv.model)
-	{
-	case 14009: /* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in) */
-	case 14019: /* WinTV-HVR3000 (Retail, IR Blaster, b/panel video, 3.5mm audio in) */
-	case 14029: /* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in - 880 bridge) */
-	case 14109: /* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in - low profile) */
-	case 14129: /* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in - 880 bridge - LP) */
-	case 14559: /* WinTV-HVR3000 (OEM, no IR, b/panel video, 3.5mm audio in) */
-	case 14569: /* WinTV-HVR3000 (OEM, no IR, no back panel video) */
-	case 14659: /* WinTV-HVR3000 (OEM, no IR, b/panel video, RCA audio in - Low profile) */
-	case 14669: /* WinTV-HVR3000 (OEM, no IR, no b/panel video - Low profile) */
-	case 28552: /* WinTV-PVR 'Roslyn' (No IR) */
-	case 34519: /* WinTV-PCI-FM */
+	switch (tv.model) {
+	case 14009:
+/* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in) */
+	case 14019:
+/* WinTV-HVR3000 (Retail, IR Blaster, b/panel video, 3.5mm audio in) */
+	case 14029:
+/* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in - 880 bridge) */
+	case 14109:
+/* WinTV-HVR3000 (Retail, IR, b/panel video, 3.5mm audio in - low profile) */
+	case 14129:
+/* WinTV-HVR3000 (Retail, IR, b/panel video,
+3.5mm audio in - 880 bridge - LP) */
+	case 14559:
+/* WinTV-HVR3000 (OEM, no IR, b/panel video, 3.5mm audio in) */
+	case 14569:
+/* WinTV-HVR3000 (OEM, no IR, no back panel video) */
+	case 14659:
+/* WinTV-HVR3000 (OEM, no IR, b/panel video, RCA audio in - Low profile) */
+	case 14669:
+/* WinTV-HVR3000 (OEM, no IR, no b/panel video - Low profile) */
+	case 28552:
+/* WinTV-PVR 'Roslyn' (No IR) */
+	case 34519:
+/* WinTV-PCI-FM */
 	case 69009:
 		/* WinTV-HVR4000 (DVBS/S2/T, Video and IR, back panel inputs) */
 	case 69100: /* WinTV-HVR4000LITE (DVBS/S2, IR) */
@@ -2915,33 +2952,33 @@ static const struct {
 	int  fm;
 	const char *name;
 } gdi_tuner[] = {
-	[ 0x01 ] = { .id   = TUNER_ABSENT,
+	[0x01] = { .id   = TUNER_ABSENT,
 		     .name = "NTSC_M" },
-	[ 0x02 ] = { .id   = TUNER_ABSENT,
+	[0x02] = { .id   = TUNER_ABSENT,
 		     .name = "PAL_B" },
-	[ 0x03 ] = { .id   = TUNER_ABSENT,
+	[0x03] = { .id   = TUNER_ABSENT,
 		     .name = "PAL_I" },
-	[ 0x04 ] = { .id   = TUNER_ABSENT,
+	[0x04] = { .id   = TUNER_ABSENT,
 		     .name = "PAL_D" },
-	[ 0x05 ] = { .id   = TUNER_ABSENT,
+	[0x05] = { .id   = TUNER_ABSENT,
 		     .name = "SECAM" },
 
-	[ 0x10 ] = { .id   = TUNER_ABSENT,
+	[0x10] = { .id   = TUNER_ABSENT,
 		     .fm   = 1,
 		     .name = "TEMIC_4049" },
-	[ 0x11 ] = { .id   = TUNER_TEMIC_4136FY5,
+	[0x11] = { .id   = TUNER_TEMIC_4136FY5,
 		     .name = "TEMIC_4136" },
-	[ 0x12 ] = { .id   = TUNER_ABSENT,
+	[0x12] = { .id   = TUNER_ABSENT,
 		     .name = "TEMIC_4146" },
 
-	[ 0x20 ] = { .id   = TUNER_PHILIPS_FQ1216ME,
+	[0x20] = { .id   = TUNER_PHILIPS_FQ1216ME,
 		     .fm   = 1,
 		     .name = "PHILIPS_FQ1216_MK3" },
-	[ 0x21 ] = { .id   = TUNER_ABSENT, .fm = 1,
+	[0x21] = { .id   = TUNER_ABSENT, .fm = 1,
 		     .name = "PHILIPS_FQ1236_MK3" },
-	[ 0x22 ] = { .id   = TUNER_ABSENT,
+	[0x22] = { .id   = TUNER_ABSENT,
 		     .name = "PHILIPS_FI1236_MK3" },
-	[ 0x23 ] = { .id   = TUNER_ABSENT,
+	[0x23] = { .id   = TUNER_ABSENT,
 		     .name = "PHILIPS_FI1216_MK3" },
 };
 
@@ -3241,15 +3278,15 @@ int cx88_tuner_callback(void *priv, int component, int command, int arg)
 		return -EINVAL;
 
 	switch (core->board.tuner_type) {
-		case TUNER_XC2028:
-			info_printk(core, "Calling XC2028/3028 callback\n");
-			return cx88_xc2028_tuner_callback(core, command, arg);
-		case TUNER_XC4000:
-			info_printk(core, "Calling XC4000 callback\n");
-			return cx88_xc4000_tuner_callback(core, command, arg);
-		case TUNER_XC5000:
-			info_printk(core, "Calling XC5000 callback\n");
-			return cx88_xc5000_tuner_callback(core, command, arg);
+	case TUNER_XC2028:
+		info_printk(core, "Calling XC2028/3028 callback\n");
+		return cx88_xc2028_tuner_callback(core, command, arg);
+	case TUNER_XC4000:
+		info_printk(core, "Calling XC4000 callback\n");
+		return cx88_xc4000_tuner_callback(core, command, arg);
+	case TUNER_XC5000:
+		info_printk(core, "Calling XC5000 callback\n");
+		return cx88_xc5000_tuner_callback(core, command, arg);
 	}
 	err_printk(core, "Error: Calling callback for tuner %d\n",
 		   core->board.tuner_type);
@@ -3266,19 +3303,20 @@ static void cx88_card_list(struct cx88_core *core, struct pci_dev *pci)
 	if (0 == pci->subsystem_vendor &&
 	    0 == pci->subsystem_device) {
 		printk(KERN_ERR
-		       "%s: Your board has no valid PCI Subsystem ID and thus can't\n"
-		       "%s: be autodetected.  Please pass card=<n> insmod option to\n"
-		       "%s: workaround that.  Redirect complaints to the vendor of\n"
+		"%s: Your board has no valid PCI Subsystem ID and thus can't\n"
+		"%s: be autodetected.  Please pass card=<n> insmod option to\n"
+		"%s: workaround that.  Redirect complaints to the vendor of\n"
 		       "%s: the TV card.  Best regards,\n"
 		       "%s:         -- tux\n",
-		       core->name,core->name,core->name,core->name,core->name);
+		       core->name, core->name, core->name,
+			core->name, core->name);
 	} else {
 		printk(KERN_ERR
-		       "%s: Your board isn't known (yet) to the driver.  You can\n"
+		"%s: Your board isn't known (yet) to the driver.  You can\n"
 		       "%s: try to pick one of the existing card configs via\n"
 		       "%s: card=<n> insmod option.  Updating to the latest\n"
 		       "%s: version might help as well.\n",
-		       core->name,core->name,core->name,core->name);
+		       core->name, core->name, core->name, core->name);
 	}
 	err_printk(core, "Here is a list of valid choices for the card=<n> "
 		   "insmod option:\n");
@@ -3292,7 +3330,8 @@ static void cx88_card_setup_pre_i2c(struct cx88_core *core)
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
 		/*
-		 * Bring the 702 demod up before i2c scanning/attach or devices are hidden
+		 * Bring the 702 demod up
+		* before i2c scanning/attach or devices are hidden
 		 * We leave here with the 702 on the bus
 		 *
 		 * "reset the IR receiver on GPIO[3]"
@@ -3494,18 +3533,18 @@ static void cx88_card_setup(struct cx88_core *core)
 		if (0 == core->i2c_rc) {
 			/* enable tuner */
 			int i;
-			static const u8 buffer [][2] = {
-				{0x10,0x12},
-				{0x13,0x04},
-				{0x16,0x00},
-				{0x14,0x04},
-				{0x17,0x00}
+			static const u8 buffer[][2] = {
+				{0x10, 0x12},
+				{0x13, 0x04},
+				{0x16, 0x00},
+				{0x14, 0x04},
+				{0x17, 0x00}
 			};
 			core->i2c_client.addr = 0x0a;
 
 			for (i = 0; i < ARRAY_SIZE(buffer); i++)
 				if (2 != i2c_master_send(&core->i2c_client,
-							buffer[i],2))
+							buffer[i], 2))
 					warn_printk(core, "Unable to enable "
 						    "tuner(%i).\n", i);
 		}
@@ -3547,6 +3586,12 @@ static void cx88_card_setup(struct cx88_core *core)
 		cx_write(MO_SRST_IO, 1);
 		msleep(100);
 		break;
+	case  CX88_BOARD_BST_PS8312:
+		cx_write(MO_GP1_IO, 0x808000);
+		msleep(100);
+		cx_write(MO_GP1_IO, 0x808080);
+		msleep(100);
+		break;
 	} /*end switch() */
 
 
@@ -3653,8 +3698,8 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
 
 int cx88_get_resources(const struct cx88_core *core, struct pci_dev *pci)
 {
-	if (request_mem_region(pci_resource_start(pci,0),
-			       pci_resource_len(pci,0),
+	if (request_mem_region(pci_resource_start(pci, 0),
+			       pci_resource_len(pci, 0),
 			       core->name))
 		return 0;
 	printk(KERN_ERR
@@ -3728,7 +3773,8 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	if (!core->board.num_frontends && (core->board.mpeg & CX88_MPEG_DVB))
 		core->board.num_frontends = 1;
 
-	info_printk(core, "subsystem: %04x:%04x, board: %s [card=%d,%s], frontend(s): %d\n",
+	info_printk(core, "subsystem: %04x:%04x, \
+		board: %s [card=%d,%s], frontend(s): %d\n",
 		pci->subsystem_vendor, pci->subsystem_device, core->board.name,
 		core->boardnr, card[core->nr] == core->boardnr ?
 		"insmod option" : "autodetected",
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 003937c..47cfa7e 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -54,6 +54,8 @@
 #include "stv0288.h"
 #include "stb6000.h"
 #include "cx24116.h"
+#include "m88ts202x.h"
+#include "m88ds3103.h"
 #include "stv0900.h"
 #include "stb6100.h"
 #include "stb6100_proc.h"
@@ -68,7 +70,7 @@ MODULE_VERSION(CX88_VERSION);
 
 static unsigned int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"enable debug messages [dvb]");
+MODULE_PARM_DESC(debug, "enable debug messages [dvb]");
 
 static unsigned int dvb_buf_tscnt = 32;
 module_param(dvb_buf_tscnt, int, 0644);
@@ -76,8 +78,8 @@ MODULE_PARM_DESC(dvb_buf_tscnt, "DVB Buffer TS count [dvb]");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define dprintk(level,fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "%s/2-dvb: " fmt, core->name, ## arg)
+#define dprintk(level, fmt, arg...)	{if (debug >= level) \
+	printk(KERN_DEBUG "%s/2-dvb: " fmt, core->name, ## arg)}
 
 /* ------------------------------------------------------------------ */
 
@@ -98,19 +100,19 @@ static int dvb_buf_prepare(struct videobuf_queue *q,
 			   struct videobuf_buffer *vb, enum v4l2_field field)
 {
 	struct cx8802_dev *dev = q->priv_data;
-	return cx8802_buf_prepare(q, dev, (struct cx88_buffer*)vb,field);
+	return cx8802_buf_prepare(q, dev, (struct cx88_buffer *)vb, field);
 }
 
 static void dvb_buf_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 {
 	struct cx8802_dev *dev = q->priv_data;
-	cx8802_buf_queue(dev, (struct cx88_buffer*)vb);
+	cx8802_buf_queue(dev, (struct cx88_buffer *)vb);
 }
 
 static void dvb_buf_release(struct videobuf_queue *q,
 			    struct videobuf_buffer *vb)
 {
-	cx88_free_buffer(q, (struct cx88_buffer*)vb);
+	cx88_free_buffer(q, (struct cx88_buffer *)vb);
 }
 
 static const struct videobuf_queue_ops dvb_qops = {
@@ -122,9 +124,9 @@ static const struct videobuf_queue_ops dvb_qops = {
 
 /* ------------------------------------------------------------------ */
 
-static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
+static int cx88_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx8802_driver *drv = NULL;
 	int ret = 0;
 	int fe_id;
@@ -138,7 +140,7 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 	mutex_lock(&dev->core->lock);
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
 	if (drv) {
-		if (acquire){
+		if (acquire) {
 			dev->frontends.active_fe_id = fe_id;
 			ret = drv->request_acquire(drv);
 		} else {
@@ -175,13 +177,13 @@ static void cx88_dvb_gate_ctrl(struct cx88_core  *core, int open)
 
 /* ------------------------------------------------------------------ */
 
-static int dvico_fusionhdtv_demod_init(struct dvb_frontend* fe)
+static int dvico_fusionhdtv_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { CLOCK_CTL,  0x38, 0x39 };
-	static const u8 reset []         = { RESET,      0x80 };
-	static const u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
-	static const u8 agc_cfg []       = { AGC_TARGET, 0x24, 0x20 };
-	static const u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
+	static const u8 clock_config[]  = { CLOCK_CTL,  0x38, 0x39 };
+	static const u8 reset[]         = { RESET,      0x80 };
+	static const u8 adc_ctl_1_cfg[] = { ADC_CTL_1,  0x40 };
+	static const u8 agc_cfg[]       = { AGC_TARGET, 0x24, 0x20 };
+	static const u8 gpp_ctl_cfg[]   = { GPP_CTL,    0x33 };
 	static const u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
@@ -197,11 +199,11 @@ static int dvico_fusionhdtv_demod_init(struct dvb_frontend* fe)
 
 static int dvico_dual_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { CLOCK_CTL,  0x38, 0x38 };
-	static const u8 reset []         = { RESET,      0x80 };
-	static const u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
-	static const u8 agc_cfg []       = { AGC_TARGET, 0x28, 0x20 };
-	static const u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
+	static const u8 clock_config[]  = { CLOCK_CTL,  0x38, 0x38 };
+	static const u8 reset[]         = { RESET,      0x80 };
+	static const u8 adc_ctl_1_cfg[] = { ADC_CTL_1,  0x40 };
+	static const u8 agc_cfg[]       = { AGC_TARGET, 0x28, 0x20 };
+	static const u8 gpp_ctl_cfg[]   = { GPP_CTL,    0x33 };
 	static const u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
@@ -216,12 +218,12 @@ static int dvico_dual_demod_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int dntv_live_dvbt_demod_init(struct dvb_frontend* fe)
+static int dntv_live_dvbt_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { 0x89, 0x38, 0x39 };
-	static const u8 reset []         = { 0x50, 0x80 };
-	static const u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
-	static const u8 agc_cfg []       = { 0x67, 0x10, 0x23, 0x00, 0xFF, 0xFF,
+	static const u8 clock_config[]  = { 0x89, 0x38, 0x39 };
+	static const u8 reset[]         = { 0x50, 0x80 };
+	static const u8 adc_ctl_1_cfg[] = { 0x8E, 0x40 };
+	static const u8 agc_cfg[]       = { 0x67, 0x10, 0x23, 0x00, 0xFF, 0xFF,
 				       0x00, 0xFF, 0x00, 0x40, 0x40 };
 	static const u8 dntv_extra[]     = { 0xB5, 0x7A };
 	static const u8 capt_range_cfg[] = { 0x75, 0x32 };
@@ -264,13 +266,14 @@ static struct mb86a16_config twinhan_vp1027 = {
 	.demod_address  = 0x08,
 };
 
-#if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
-static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
+#if defined(CONFIG_VIDEO_CX88_VP3054) || \
+(defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
+static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend *fe)
 {
-	static const u8 clock_config []  = { 0x89, 0x38, 0x38 };
-	static const u8 reset []         = { 0x50, 0x80 };
-	static const u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
-	static const u8 agc_cfg []       = { 0x67, 0x10, 0x20, 0x00, 0xFF, 0xFF,
+	static const u8 clock_config[]  = { 0x89, 0x38, 0x38 };
+	static const u8 reset[]         = { 0x50, 0x80 };
+	static const u8 adc_ctl_1_cfg[] = { 0x8E, 0x40 };
+	static const u8 agc_cfg[]       = { 0x67, 0x10, 0x20, 0x00, 0xFF, 0xFF,
 				       0x00, 0xFF, 0x00, 0x40, 0x40 };
 	static const u8 dntv_extra[]     = { 0xB5, 0x7A };
 	static const u8 capt_range_cfg[] = { 0x75, 0x32 };
@@ -327,9 +330,9 @@ static const struct cx22702_config hauppauge_hvr_config = {
 	.output_mode   = CX22702_SERIAL_OUTPUT,
 };
 
-static int or51132_set_ts_param(struct dvb_frontend* fe, int is_punctured)
+static int or51132_set_ts_param(struct dvb_frontend *fe, int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	dev->ts_gen_cntrl = is_punctured ? 0x04 : 0x00;
 	return 0;
 }
@@ -339,9 +342,9 @@ static const struct or51132_config pchdtv_hd3000 = {
 	.set_ts_params = or51132_set_ts_param,
 };
 
-static int lgdt330x_pll_rf_set(struct dvb_frontend* fe, int index)
+static int lgdt330x_pll_rf_set(struct dvb_frontend *fe, int index)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	dprintk(1, "%s: index = %d\n", __func__, index);
@@ -352,9 +355,9 @@ static int lgdt330x_pll_rf_set(struct dvb_frontend* fe, int index)
 	return 0;
 }
 
-static int lgdt330x_set_ts_param(struct dvb_frontend* fe, int is_punctured)
+static int lgdt330x_set_ts_param(struct dvb_frontend *fe, int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	if (is_punctured)
 		dev->ts_gen_cntrl |= 0x04;
 	else
@@ -383,9 +386,9 @@ static const struct lgdt330x_config pchdtv_hd5500 = {
 	.set_ts_params = lgdt330x_set_ts_param,
 };
 
-static int nxt200x_set_ts_param(struct dvb_frontend* fe, int is_punctured)
+static int nxt200x_set_ts_param(struct dvb_frontend *fe, int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	dev->ts_gen_cntrl = is_punctured ? 0x04 : 0x00;
 	return 0;
 }
@@ -395,18 +398,18 @@ static const struct nxt200x_config ati_hdtvwonder = {
 	.set_ts_params = nxt200x_set_ts_param,
 };
 
-static int cx24123_set_ts_param(struct dvb_frontend* fe,
+static int cx24123_set_ts_param(struct dvb_frontend *fe,
 	int is_punctured)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	dev->ts_gen_cntrl = 0x02;
 	return 0;
 }
 
-static int kworld_dvbs_100_set_voltage(struct dvb_frontend* fe,
+static int kworld_dvbs_100_set_voltage(struct dvb_frontend *fe,
 				       fe_sec_voltage_t voltage)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	if (voltage == SEC_VOLTAGE_OFF)
@@ -422,11 +425,11 @@ static int kworld_dvbs_100_set_voltage(struct dvb_frontend* fe,
 static int geniatech_dvbs_set_voltage(struct dvb_frontend *fe,
 				      fe_sec_voltage_t voltage)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	if (voltage == SEC_VOLTAGE_OFF) {
-		dprintk(1,"LNB Voltage OFF\n");
+		dprintk(1, "LNB Voltage OFF\n");
 		cx_write(MO_GP0_IO, 0x0000efff);
 	}
 
@@ -438,7 +441,7 @@ static int geniatech_dvbs_set_voltage(struct dvb_frontend *fe,
 static int tevii_dvbs_set_voltage(struct dvb_frontend *fe,
 				      fe_sec_voltage_t voltage)
 {
-	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx8802_dev *dev = fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
 	cx_set(MO_GP0_IO, 0x6040);
@@ -458,6 +461,55 @@ static int tevii_dvbs_set_voltage(struct dvb_frontend *fe,
 		return core->prev_set_voltage(fe, voltage);
 	return 0;
 }
+/*CX88_BOARD_BST_PS8312*/
+static int bst_dvbs_set_voltage(struct dvb_frontend *fe,
+				      fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev = fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	cx_write(MO_GP1_IO, 0x111111);
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		cx_write(MO_GP1_IO, 0x020200);
+		break;
+	case SEC_VOLTAGE_18:
+		cx_write(MO_GP1_IO, 0x020202);
+		break;
+	case SEC_VOLTAGE_OFF:
+		cx_write(MO_GP1_IO, 0x111100);
+		break;
+	}
+
+	if (core->prev_set_voltage)
+		return core->prev_set_voltage(fe, voltage);
+	return 0;
+}
+
+static int bst_dvbs_set_voltage_v2(struct dvb_frontend *fe,
+				      fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev = fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	cx_write(MO_GP1_IO, 0x111101);
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		cx_write(MO_GP1_IO, 0x020200);
+		break;
+	case SEC_VOLTAGE_18:
+
+		cx_write(MO_GP1_IO, 0x020202);
+		break;
+	case SEC_VOLTAGE_OFF:
+		cx_write(MO_GP1_IO, 0x111110);
+		break;
+	}
+
+	if (core->prev_set_voltage)
+		return core->prev_set_voltage(fe, voltage);
+	return 0;
+}
 
 static int vp1027_set_voltage(struct dvb_frontend *fe,
 				    fe_sec_voltage_t voltage)
@@ -700,6 +752,17 @@ static struct ds3000_config tevii_ds3000_config = {
 	.set_ts_params = ds3000_set_ts_param,
 };
 
+static struct m88ts202x_config dvbsky_ts202x_config = {
+	.bypasson = 0,
+	.clkout = 0,
+	.clkdiv = 0,
+};
+
+static struct m88ds3103_config dvbsky_ds3103_config = {
+	.demod_address = 0x68,
+	.set_ts_params = ds3000_set_ts_param,
+};
+
 static const struct stv0900_config prof_7301_stv0900_config = {
 	.demod_address = 0x6a,
 /*	demod_mode = 0,*/
@@ -949,6 +1012,51 @@ static const struct stv0299_config samsung_stv0299_config = {
 	.set_symbol_rate = samsung_smt_7020_stv0299_set_symbol_rate,
 };
 
+static struct dvb_frontend *dvbsky_pci_frontend_attach(
+					struct m88ds3103_config *pdconf,
+					struct m88ts202x_config *ptconf,
+					struct i2c_adapter *i2c)
+{
+	struct dvb_frontend *fe;
+	struct m88ts202x_devctl *ctrl;
+	int ret;
+	u8 b0[] = { 0x60 };
+	u8 b1[2] = { 0 };
+	struct i2c_msg msg[] = {
+			{
+			.addr = 0x50,
+			.flags = 0,
+			.buf = b0,
+			.len = 1
+			}, {
+			.addr = 0x50,
+			.flags = I2C_M_RD,
+			.buf = b1,
+			.len = 2
+			}
+		};
+	fe = dvb_attach(m88ds3103_attach, pdconf, i2c);
+	if (!fe)
+		return NULL;
+	ctrl = dvb_attach(m88ts202x_attach, fe, ptconf, i2c);
+	if (ctrl) {
+		pdconf->tuner_init = ctrl->tuner_init;
+		pdconf->tuner_sleep = ctrl->tuner_sleep;
+		pdconf->tuner_wakeup = ctrl->tuner_wakeup;
+		pdconf->tuner_set_frequency = ctrl->tuner_set_frequency;
+		pdconf->tuner_get_rfgain = ctrl->tuner_get_rfgain;
+	}
+
+	ret = i2c_transfer(i2c, msg, 2);
+	printk(KERN_INFO "PS8312: config = %02x, %02x", b1[0], b1[1]);
+	if (b1[0] == 0xaa)
+		fe->ops.set_voltage = bst_dvbs_set_voltage_v2;
+	else
+		fe->ops.set_voltage = bst_dvbs_set_voltage;
+
+	return	fe;
+}
+
 static int dvb_register(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
@@ -957,7 +1065,8 @@ static int dvb_register(struct cx8802_dev *dev)
 	int res = -EINVAL;
 
 	if (0 != core->i2c_rc) {
-		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
+		printk(KERN_ERR "%s/2: no i2c-bus available,"
+				" cannot attach dvb drivers\n", core->name);
 		goto frontend_detach;
 	}
 
@@ -1121,10 +1230,12 @@ static int dvb_register(struct cx8802_dev *dev)
 		}
 		break;
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
-#if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
+#if defined(CONFIG_VIDEO_CX88_VP3054) || \
+(defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
 		/* MT352 is on a secondary I2C bus made from some GPIO lines */
-		fe0->dvb.frontend = dvb_attach(mt352_attach, &dntv_live_dvbt_pro_config,
-					       &dev->vp3054->adap);
+		fe0->dvb.frontend = dvb_attach(mt352_attach,
+						&dntv_live_dvbt_pro_config,
+						&dev->vp3054->adap);
 		if (fe0->dvb.frontend != NULL) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
 					&core->i2c_adap, 0x61,
@@ -1274,7 +1385,7 @@ static int dvb_register(struct cx8802_dev *dev)
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(isl6421_attach, fe0->dvb.frontend,
-					&core->i2c_adap, 0x08, ISL6421_DCL, 0x00))
+				&core->i2c_adap, 0x08, ISL6421_DCL, 0x00))
 				goto frontend_detach;
 		}
 		break;
@@ -1283,8 +1394,10 @@ static int dvb_register(struct cx8802_dev *dev)
 					       &kworld_dvbs_100_config,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
-			core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
-			fe0->dvb.frontend->ops.set_voltage = kworld_dvbs_100_set_voltage;
+			core->prev_set_voltage =
+					fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+						kworld_dvbs_100_set_voltage;
 		}
 		break;
 	case CX88_BOARD_GENIATECH_DVBS:
@@ -1292,8 +1405,10 @@ static int dvb_register(struct cx8802_dev *dev)
 					       &geniatech_dvbs_config,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
-			core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
-			fe0->dvb.frontend->ops.set_voltage = geniatech_dvbs_set_voltage;
+			core->prev_set_voltage =
+				fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+						geniatech_dvbs_set_voltage;
 		}
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
@@ -1439,19 +1554,24 @@ static int dvb_register(struct cx8802_dev *dev)
 			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend, 0x60,
 					&core->i2c_adap, DVB_PLL_OPERA1))
 				goto frontend_detach;
-			core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
-			fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+			core->prev_set_voltage =
+					fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+							tevii_dvbs_set_voltage;
 
 		} else {
 			fe0->dvb.frontend = dvb_attach(stv0288_attach,
-							    &tevii_tuner_earda_config,
+						&tevii_tuner_earda_config,
 							    &core->i2c_adap);
 				if (fe0->dvb.frontend != NULL) {
-					if (!dvb_attach(stb6000_attach, fe0->dvb.frontend, 0x61,
+					if (!dvb_attach(stb6000_attach,
+						fe0->dvb.frontend, 0x61,
 						&core->i2c_adap))
-					goto frontend_detach;
-				core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
-				fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+						goto frontend_detach;
+				core->prev_set_voltage =
+					fe0->dvb.frontend->ops.set_voltage;
+				fe0->dvb.frontend->ops.set_voltage =
+							tevii_dvbs_set_voltage;
 			}
 		}
 		break;
@@ -1460,7 +1580,8 @@ static int dvb_register(struct cx8802_dev *dev)
 					       &tevii_s460_config,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend != NULL)
-			fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+						tevii_dvbs_set_voltage;
 		break;
 	case CX88_BOARD_TEVII_S464:
 		fe0->dvb.frontend = dvb_attach(ds3000_attach,
@@ -1470,6 +1591,12 @@ static int dvb_register(struct cx8802_dev *dev)
 			fe0->dvb.frontend->ops.set_voltage =
 							tevii_dvbs_set_voltage;
 		break;
+	case CX88_BOARD_BST_PS8312:
+		fe0->dvb.frontend = dvbsky_pci_frontend_attach(
+						&dvbsky_ds3103_config,
+						&dvbsky_ts202x_config,
+						&core->i2c_adap);
+		break;
 	case CX88_BOARD_OMICOM_SS4_PCI:
 	case CX88_BOARD_TBS_8920:
 	case CX88_BOARD_PROF_7300:
@@ -1478,11 +1605,12 @@ static int dvb_register(struct cx8802_dev *dev)
 					       &hauppauge_hvr4000_config,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend != NULL)
-			fe0->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+						tevii_dvbs_set_voltage;
 		break;
 	case CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII:
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
-					       &cx88_terratec_cinergy_ht_pci_mkii_config,
+				&cx88_terratec_cinergy_ht_pci_mkii_config,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
@@ -1559,7 +1687,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		break;
 	}
 
-	if ( (NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend) ) {
+	if ((NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend)) {
 		printk(KERN_ERR
 		       "%s/2: frontend initialization failed\n",
 		       core->name);
@@ -1596,7 +1724,7 @@ static int cx8802_dvb_advise_acquire(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __func__);
+	dprintk(1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -1660,7 +1788,7 @@ static int cx8802_dvb_advise_release(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __func__);
+	dprintk(1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -1683,8 +1811,8 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 	struct videobuf_dvb_frontend *fe;
 	int i;
 
-	dprintk( 1, "%s\n", __func__);
-	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
+	dprintk(1, "%s\n", __func__);
+	dprintk(1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		core->boardnr,
 		core->name,
 		core->pci_bus,
@@ -1742,7 +1870,7 @@ static int cx8802_dvb_remove(struct cx8802_driver *drv)
 	struct cx88_core *core = drv->core;
 	struct cx8802_dev *dev = drv->core->dvbdev;
 
-	dprintk( 1, "%s\n", __func__);
+	dprintk(1, "%s\n", __func__);
 
 	videobuf_dvb_unregister_bus(&dev->frontends);
 
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index ebf448c..9b0559b 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -96,7 +96,7 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 
 		auxgpio = cx_read(MO_GP1_IO);
 		/* Take out the parity part */
-		gpio=(gpio & 0x7fd) + (auxgpio & 0xef);
+		gpio = (gpio & 0x7fd) + (auxgpio & 0xef);
 		break;
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_DTV1800H:
@@ -332,7 +332,8 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		ir->gpio_addr = MO_GP1_IO;
 		ir->mask_keyup = 0x80;
 		ir->polling = 10; /* ms */
-		hardware_mask = 0x3f;	/* Hardware returns only 6 bits from command part */
+		hardware_mask = 0x3f;
+		/* Hardware returns only 6 bits from command part */
 		break;
 	case CX88_BOARD_PROLINK_PV_8000GT:
 	case CX88_BOARD_PROLINK_PV_GLOBAL_XTREME:
@@ -419,6 +420,10 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		rc_type          = RC_TYPE_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
+	case CX88_BOARD_BST_PS8312:
+		ir_codes         = RC_MAP_DVBSKY;
+		ir->sampling     = 0xff00; /* address */
+		break;
 	}
 
 	if (!ir_codes) {
@@ -614,7 +619,8 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 			core->init_data.name = "cx88 Hauppauge XVR remote";
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
 			core->init_data.type = RC_TYPE_RC5;
-			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
+			core->init_data.internal_get_key_func =
+							IR_KBD_GET_KEY_HAUP_XVR;
 
 			info.platform_data = &core->init_data;
 		}
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index c9659de..c423b16 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -93,13 +93,13 @@ enum cx8802_board_access {
 /* ----------------------------------------------------------- */
 /* tv norms                                                    */
 
-static unsigned int inline norm_maxw(v4l2_std_id norm)
+static inline unsigned int norm_maxw(v4l2_std_id norm)
 {
 	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
 }
 
 
-static unsigned int inline norm_maxh(v4l2_std_id norm)
+static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_625_50) ? 576 : 480;
 }
@@ -246,6 +246,7 @@ extern const struct sram_channel const cx88_sram_channels[];
 #define CX88_BOARD_WINFAST_DTV1800H_XC4000 88
 #define CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36 89
 #define CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43 90
+#define CX88_BOARD_BST_PS8312              91
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
@@ -368,9 +369,11 @@ struct cx88_core {
 
 	/* config info -- dvb */
 #if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
-	int 			   (*prev_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
+	int			(*prev_set_voltage)(struct dvb_frontend *fe,
+						fe_sec_voltage_t voltage);
 #endif
-	void			   (*gate_ctrl)(struct cx88_core  *core, int open);
+	void			(*gate_ctrl)(struct cx88_core  *core,
+						int open);
 
 	/* state info */
 	struct task_struct         *kthread;
@@ -416,7 +419,8 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
 		if (!core->i2c_rc) {				\
 			if (core->gate_ctrl)			\
 				core->gate_ctrl(core, 1);	\
-			v4l2_device_call_all(&core->v4l2_dev, grpid, o, f, ##args); \
+			v4l2_device_call_all(&core->v4l2_dev, \
+					grpid, o, f, ##args); \
 			if (core->gate_ctrl)			\
 				core->gate_ctrl(core, 0);	\
 		}						\
@@ -443,7 +447,7 @@ struct cx8800_fh {
 
 	/* video capture */
 	const struct cx8800_fmt    *fmt;
-	unsigned int               width,height;
+	unsigned int               width, height;
 	struct videobuf_queue      vidq;
 
 	/* vbi capture */
@@ -466,7 +470,7 @@ struct cx8800_dev {
 
 	/* pci i/o */
 	struct pci_dev             *pci;
-	unsigned char              pci_rev,pci_lat;
+	unsigned char              pci_rev, pci_lat;
 
 
 	/* capture queues */
@@ -531,7 +535,7 @@ struct cx8802_dev {
 
 	/* pci i/o */
 	struct pci_dev             *pci;
-	unsigned char              pci_rev,pci_lat;
+	unsigned char              pci_rev, pci_lat;
 
 	/* dma queues */
 	struct cx88_dmaqueue       mpegq;
@@ -549,7 +553,8 @@ struct cx8802_dev {
 	u32                        mailbox;
 	int                        width;
 	int                        height;
-	unsigned char              mpeg_active; /* nonzero if mpeg encoder is active */
+	unsigned char              mpeg_active;
+		/* nonzero if mpeg encoder is active */
 
 	/* mpeg params */
 	struct cx2341x_mpeg_params params;
@@ -577,30 +582,31 @@ struct cx8802_dev {
 /* ----------------------------------------------------------- */
 
 #define cx_read(reg)             readl(core->lmmio + ((reg)>>2))
-#define cx_write(reg,value)      writel((value), core->lmmio + ((reg)>>2))
-#define cx_writeb(reg,value)     writeb((value), core->bmmio + (reg))
+#define cx_write(reg, value)      writel((value), core->lmmio + ((reg)>>2))
+#define cx_writeb(reg, value)     writeb((value), core->bmmio + (reg))
 
-#define cx_andor(reg,mask,value) \
+#define cx_andor(reg, mask, value) \
   writel((readl(core->lmmio+((reg)>>2)) & ~(mask)) |\
   ((value) & (mask)), core->lmmio+((reg)>>2))
-#define cx_set(reg,bit)          cx_andor((reg),(bit),(bit))
-#define cx_clear(reg,bit)        cx_andor((reg),(bit),0)
+#define cx_set(reg, bit)          cx_andor((reg), (bit), (bit))
+#define cx_clear(reg, bit)        cx_andor((reg), (bit), 0)
 
 #define cx_wait(d) { if (need_resched()) schedule(); else udelay(d); }
 
 /* shadow registers */
 #define cx_sread(sreg)		    (core->shadow[sreg])
-#define cx_swrite(sreg,reg,value) \
+#define cx_swrite(sreg, reg, value) \
   (core->shadow[sreg] = value, \
    writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
-#define cx_sandor(sreg,reg,mask,value) \
+#define cx_sandor(sreg, reg, mask, value) \
   (core->shadow[sreg] = (core->shadow[sreg] & ~(mask)) | ((value) & (mask)), \
    writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
 
 /* ----------------------------------------------------------- */
 /* cx88-core.c                                                 */
 
-extern void cx88_print_irqbits(const char *name, const char *tag, const char *strings[],
+extern void cx88_print_irqbits(const char *name, const char *tag,
+				const char *strings[],
 			       int len, u32 bits, u32 mask);
 
 extern int cx88_core_irq(struct cx88_core *core, u32 status);
@@ -640,7 +646,7 @@ extern struct video_device *cx88_vdev_init(struct cx88_core *core,
 					   struct pci_dev *pci,
 					   const struct video_device *template_,
 					   const char *type);
-extern struct cx88_core* cx88_core_get(struct pci_dev *pci);
+extern struct cx88_core *cx88_core_get(struct pci_dev *pci);
 extern void cx88_core_put(struct cx88_core *core,
 			  struct pci_dev *pci);
 
@@ -652,7 +658,7 @@ extern int cx88_stop_audio_dma(struct cx88_core *core);
 /* cx88-vbi.c                                                  */
 
 /* Can be used as g_vbi_fmt, try_vbi_fmt and s_vbi_fmt */
-int cx8800_vbi_fmt (struct file *file, void *priv,
+int cx8800_vbi_fmt(struct file *file, void *priv,
 					struct v4l2_format *f);
 
 /*
@@ -695,7 +701,8 @@ int cx8802_register_driver(struct cx8802_driver *drv);
 int cx8802_unregister_driver(struct cx8802_driver *drv);
 
 /* Caller must hold core->lock */
-struct cx8802_driver * cx8802_get_driver(struct cx8802_dev *dev, enum cx88_board_type btype);
+struct cx8802_driver *cx8802_get_driver(struct cx8802_dev *dev,
+					enum cx88_board_type btype);
 
 /* ----------------------------------------------------------- */
 /* cx88-dsp.c                                                  */
@@ -715,7 +722,7 @@ extern void cx88_i2c_init_ir(struct cx88_core *core);
 /* ----------------------------------------------------------- */
 /* cx88-mpeg.c                                                 */
 
-int cx8802_buf_prepare(struct videobuf_queue *q,struct cx8802_dev *dev,
+int cx8802_buf_prepare(struct videobuf_queue *q, struct cx8802_dev *dev,
 			struct cx88_buffer *buf, enum v4l2_field field);
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf);
 void cx8802_cancel_buffers(struct cx8802_dev *dev);
@@ -725,8 +732,8 @@ void cx8802_cancel_buffers(struct cx8802_dev *dev);
 extern const u32 cx88_user_ctrls[];
 extern int cx8800_ctrl_query(struct cx88_core *core,
 			     struct v4l2_queryctrl *qctrl);
-int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i);
-int cx88_set_freq (struct cx88_core  *core,struct v4l2_frequency *f);
+int cx88_enum_input(struct cx88_core  *core, struct v4l2_input *i);
+int cx88_set_freq(struct cx88_core  *core, struct v4l2_frequency *f);
 int cx88_get_control(struct cx88_core *core, struct v4l2_control *ctl);
 int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl);
 int cx88_video_mux(struct cx88_core *core, unsigned int input);
-- 
1.7.9.5

