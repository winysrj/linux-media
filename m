Return-path: <mchehab@gaivota>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:60857 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362Ab1EITyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:12 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 03/16] tm6000: change to virtual inputs
Date: Mon,  9 May 2011 21:53:51 +0200
Message-Id: <1304970844-20955-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

change to virtual inputs


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |  257 +++++++++++++++++++++++++++++++--
 drivers/staging/tm6000/tm6000-core.c  |   60 +++++----
 drivers/staging/tm6000/tm6000.h       |   36 ++++--
 3 files changed, 303 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 31ccd2f..9f4daac 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -74,8 +74,6 @@ struct tm6000_board {
 	unsigned	eename_pos;		/* Position where it appears at ROM */
 
 	struct tm6000_capabilities caps;
-	enum            tm6000_inaudio aradio;
-	enum            tm6000_inaudio avideo;
 
 	enum		tm6000_devtype type;	/* variant of the chipset */
 	int             tuner_type;     /* type of the tuner */
@@ -84,6 +82,8 @@ struct tm6000_board {
 
 	struct tm6000_gpio gpio;
 
+	struct tm6000_input	vinput[3];
+	struct tm6000_input	rinput;
 	char		*ir_codes;
 };
 
@@ -96,6 +96,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM5600_BOARD_GENERIC] = {
 		.name         = "Generic tm5600 board",
@@ -108,6 +122,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_GENERIC] = {
 		.name         = "Generic tm6000 board",
@@ -120,6 +148,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_GENERIC] = {
 		.name         = "Generic tm6010 board",
@@ -143,6 +185,20 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM5600_BOARD_10MOONS_UT821] = {
 		.name         = "10Moons UT 821",
@@ -159,6 +215,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM5600_BOARD_10MOONS_UT330] = {
 		.name         = "10Moons UT 330",
@@ -170,6 +240,20 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 0,
 			.has_eeprom   = 1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_ADSTECH_DUAL_TV] = {
 		.name         = "ADSTECH Dual TV USB",
@@ -182,6 +266,20 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 1,
 			.has_eeprom   = 1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_FREECOM_AND_SIMILAR] = {
 		.name         = "Freecom Hybrid Stick / Moka DVB-T Receiver Dual",
@@ -198,6 +296,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_4,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_ADSTECH_MINI_DUAL_TV] = {
 		.name         = "ADSTECH Mini Dual TV USB",
@@ -213,6 +325,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_4,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_HAUPPAUGE_900H] = {
 		.name         = "Hauppauge WinTV HVR-900H / WinTV USB2-Stick",
@@ -239,6 +365,20 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_BEHOLD_WANDER] = {
 		.name         = "Beholder Wander DVB-T/TV/FM USB2.0",
@@ -246,8 +386,6 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
-		.avideo       = TM6000_AIP_SIF1,
-		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner      = 1,
 			.has_dvb        = 1,
@@ -263,14 +401,30 @@ struct tm6000_board tm6000_boards[] = {
 			.demod_reset	= TM6010_GPIO_1,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_AMUX_ADC1,
+		},
 	},
 	[TM6010_BOARD_BEHOLD_VOYAGER] = {
 		.name         = "Beholder Voyager TV/FM USB2.0",
 		.tuner_type   = TUNER_XC5000,
 		.tuner_addr   = 0xc2 >> 1,
 		.type         = TM6010,
-		.avideo       = TM6000_AIP_SIF1,
-		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner      = 1,
 			.has_dvb        = 0,
@@ -285,6 +439,24 @@ struct tm6000_board tm6000_boards[] = {
 			.tuner_reset	= TM6010_GPIO_0,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_AMUX_ADC1,
+		},
 	},
 	[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
 		.name         = "Terratec Cinergy Hybrid XE / Cinergy Hybrid-Stick",
@@ -309,11 +481,39 @@ struct tm6000_board tm6000_boards[] = {
 			.ir		= TM6010_GPIO_0,
 		},
 		.ir_codes = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM5600_BOARD_TERRATEC_GRABSTER] = {
 		.name         = "Terratec Grabster AV 150/250 MX",
 		.type         = TM5600,
 		.tuner_type   = TUNER_ABSENT,
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_TWINHAN_TU501] = {
 		.name         = "Twinhan TU501(704D1)",
@@ -337,6 +537,20 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_VMUX_VIDEO_A,
+			.amux	= TM6000_AMUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_VMUX_VIDEO_AB,
+			.amux	= TM6000_AMUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_BEHOLD_WANDER_LITE] = {
 		.name         = "Beholder Wander Lite DVB-T/TV/FM USB2.0",
@@ -344,8 +558,6 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
-		.avideo       = TM6000_AIP_SIF1,
-		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner      = 1,
 			.has_dvb        = 1,
@@ -361,14 +573,22 @@ struct tm6000_board tm6000_boards[] = {
 			.demod_reset	= TM6010_GPIO_1,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_AMUX_ADC1,
+		},
 	},
 	[TM6010_BOARD_BEHOLD_VOYAGER_LITE] = {
 		.name         = "Beholder Voyager Lite TV/FM USB2.0",
 		.tuner_type   = TUNER_XC5000,
 		.tuner_addr   = 0xc2 >> 1,
 		.type         = TM6010,
-		.avideo       = TM6000_AIP_SIF1,
-		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner      = 1,
 			.has_dvb        = 0,
@@ -383,6 +603,16 @@ struct tm6000_board tm6000_boards[] = {
 			.tuner_reset	= TM6010_GPIO_0,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_VMUX_VIDEO_B,
+			.amux	= TM6000_AMUX_SIF1,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_AMUX_ADC1,
+		},
 	},
 };
 
@@ -763,8 +993,11 @@ static int fill_board_specific_data(struct tm6000_core *dev)
 
 	dev->caps = tm6000_boards[dev->model].caps;
 
-	dev->avideo = tm6000_boards[dev->model].avideo;
-	dev->aradio = tm6000_boards[dev->model].aradio;
+	dev->vinput[0] = tm6000_boards[dev->model].vinput[0];
+	dev->vinput[1] = tm6000_boards[dev->model].vinput[1];
+	dev->vinput[2] = tm6000_boards[dev->model].vinput[2];
+	dev->rinput = tm6000_boards[dev->model].rinput;
+
 	/* initialize hardware */
 	rc = tm6000_init(dev);
 	if (rc < 0)
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 778e534..f4b9fcd 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -661,20 +661,25 @@ int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
 {
 	if (dev->dev_type == TM6010) {
 		/* Audio crossbar setting, default SIF1 */
-		u8 areg_f0 = 0x03;
+		u8 areg_f0;
 
-		switch (ainp) {
-		case TM6000_AIP_SIF1:
-		case TM6000_AIP_SIF2:
+		switch (dev->rinput.amux) {
+		case TM6000_AMUX_SIF1:
+		case TM6000_AMUX_SIF2:
 			areg_f0 = 0x03;
 			break;
-		case TM6000_AIP_LINE1:
+		case TM6000_AMUX_ADC1:
 			areg_f0 = 0x00;
 			break;
-		case TM6000_AIP_LINE2:
+		case TM6000_AMUX_ADC2:
 			areg_f0 = 0x08;
 			break;
+		case TM6000_AMUX_I2S:
+			areg_f0 = 0x04;
+			break;
 		default:
+			printk(KERN_INFO "%s: audio input dosn't support\n",
+				dev->name);
 			return 0;
 			break;
 		}
@@ -682,17 +687,18 @@ int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
 		tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
 							areg_f0, 0x0f);
 	} else {
+		u8 areg_eb;
 		/* Audio setting, default LINE1 */
-		u8 areg_eb = 0x00;
-
-		switch (ainp) {
-		case TM6000_AIP_LINE1:
+		switch (dev->rinput.amux) {
+		case TM6000_AMUX_ADC1:
 			areg_eb = 0x00;
 			break;
-		case TM6000_AIP_LINE2:
+		case TM6000_AMUX_ADC2:
 			areg_eb = 0x04;
 			break;
 		default:
+			printk(KERN_INFO "%s: audio input dosn't support\n",
+				dev->name);
 			return 0;
 			break;
 		}
@@ -736,16 +742,16 @@ void tm6010_set_mute_adc(struct tm6000_core *dev, u8 mute)
 
 int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 {
-	enum tm6000_inaudio ainp;
+	enum tm6000_mux mux;
 
 	if (dev->radio)
-		ainp = dev->aradio;
+		mux = dev->rinput.amux;
 	else
-		ainp = dev->avideo;
+		mux = dev->vinput[dev->input].amux;
 
-	switch (ainp) {
-	case TM6000_AIP_SIF1:
-	case TM6000_AIP_SIF2:
+	switch (mux) {
+	case TM6000_AMUX_SIF1:
+	case TM6000_AMUX_SIF2:
 		if (dev->dev_type == TM6010)
 			tm6010_set_mute_sif(dev, mute);
 		else {
@@ -755,8 +761,8 @@ int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 			return -EINVAL;
 		}
 		break;
-	case TM6000_AIP_LINE1:
-	case TM6000_AIP_LINE2:
+	case TM6000_AMUX_ADC1:
+	case TM6000_AMUX_ADC2:
 		tm6010_set_mute_adc(dev, mute);
 		break;
 	default:
@@ -797,17 +803,17 @@ void tm6010_set_volume_adc(struct tm6000_core *dev, int vol)
 
 void tm6000_set_volume(struct tm6000_core *dev, int vol)
 {
-	enum tm6000_inaudio ainp;
+	enum tm6000_mux mux;
 
 	if (dev->radio) {
-		ainp = dev->aradio;
+		mux = dev->rinput.amux;
 		vol += 8; /* Offset to 0 dB */
 	} else
-		ainp = dev->avideo;
+		mux = dev->vinput[dev->input].amux;
 
-	switch (ainp) {
-	case TM6000_AIP_SIF1:
-	case TM6000_AIP_SIF2:
+	switch (mux) {
+	case TM6000_AMUX_SIF1:
+	case TM6000_AMUX_SIF2:
 		if (dev->dev_type == TM6010)
 			tm6010_set_volume_sif(dev, vol);
 		else
@@ -815,8 +821,8 @@ void tm6000_set_volume(struct tm6000_core *dev, int vol)
 					" SIF audio inputs. Please check the %s"
 					" configuration.\n", dev->name);
 		break;
-	case TM6000_AIP_LINE1:
-	case TM6000_AIP_LINE2:
+	case TM6000_AMUX_ADC1:
+	case TM6000_AMUX_ADC2:
 		tm6010_set_volume_adc(dev, vol);
 		break;
 	default:
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 43b0d62..650decd 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -40,11 +40,24 @@
 #define TM6000_VERSION KERNEL_VERSION(0, 0, 2)
 
 /* Inputs */
-
 enum tm6000_itype {
-	TM6000_INPUT_TV	= 0,
-	TM6000_INPUT_COMPOSITE,
+	TM6000_INPUT_TV	= 1,
+	TM6000_INPUT_COMPOSITE1,
+	TM6000_INPUT_COMPOSITE2,
 	TM6000_INPUT_SVIDEO,
+	TM6000_INPUT_DVB,
+	TM6000_INPUT_RADIO,
+};
+
+enum tm6000_mux {
+	TM6000_VMUX_VIDEO_A = 1,
+	TM6000_VMUX_VIDEO_B,
+	TM6000_VMUX_VIDEO_AB,
+	TM6000_AMUX_ADC1,
+	TM6000_AMUX_ADC2,
+	TM6000_AMUX_SIF1,
+	TM6000_AMUX_SIF2,
+	TM6000_AMUX_I2S,
 };
 
 enum tm6000_devtype {
@@ -53,12 +66,12 @@ enum tm6000_devtype {
 	TM6010,
 };
 
-enum tm6000_inaudio {
-	TM6000_AIP_UNK = 0,
-	TM6000_AIP_SIF1,
-	TM6000_AIP_SIF2,
-	TM6000_AIP_LINE1,
-	TM6000_AIP_LINE2,
+struct tm6000_input {
+	enum tm6000_itype	type;
+	enum tm6000_mux		vmux;
+	enum tm6000_mux		amux;
+	unsigned int		v_gpio;
+	unsigned int		a_gpio;
 };
 
 /* ------------------------------------------------------------------
@@ -214,6 +227,9 @@ struct tm6000_core {
 	struct v4l2_device		v4l2_dev;
 
 	int				input;
+	struct tm6000_input		vinput[3];	/* video input */
+	struct tm6000_input		rinput;		/* radio input */
+
 	int				freq;
 	unsigned int			fourcc;
 
@@ -230,8 +246,6 @@ struct tm6000_core {
 	struct snd_tm6000_card		*adev;
 	struct work_struct		wq_trigger;   /* Trigger to start/stop audio for alsa module */
 	atomic_t			stream_started;  /* stream should be running if true */
-	enum tm6000_inaudio		avideo;
-	enum tm6000_inaudio		aradio;
 
 	struct tm6000_IR		*ir;
 
-- 
1.7.4.2

