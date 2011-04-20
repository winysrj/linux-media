Return-path: <mchehab@pedra>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:40441 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931Ab1DTOxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2011 10:53:54 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: add virtual inputs
Date: Wed, 20 Apr 2011 16:53:47 +0200
Message-Id: <1303311227-5445-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

Please don't add this patch. This patch work in video mode perfect,
but radio haven't I tested. We should walk about this patch.



Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-alsa.c  |   10 +-
 drivers/staging/tm6000/tm6000-cards.c |  299 ++++++++++-
 drivers/staging/tm6000/tm6000-core.c  |   69 ++--
 drivers/staging/tm6000/tm6000-input.c |    4 +-
 drivers/staging/tm6000/tm6000-stds.c  |  937 ++++++++-------------------------
 drivers/staging/tm6000/tm6000-video.c |  145 +++---
 drivers/staging/tm6000/tm6000.h       |   41 ++-
 7 files changed, 635 insertions(+), 870 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index acb0317..39c3b73 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -80,12 +80,9 @@ static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 	dprintk(1, "Starting audio DMA\n");
 
 	/* Enables audio */
-	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x40, 0x40);
 
 	tm6000_set_audio_bitrate(core, 48000);
 
-	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0x80);
-
 	return 0;
 }
 
@@ -98,11 +95,6 @@ static int _tm6000_stop_audio_dma(struct snd_tm6000_card *chip)
 
 	dprintk(1, "Stopping audio DMA\n");
 
-	/* Disables audio */
-	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x00, 0x40);
-
-	tm6000_set_reg(core, TM6010_REQ08_R01_A_INIT, 0);
-
 	return 0;
 }
 
@@ -354,9 +346,11 @@ static int snd_tm6000_card_trigger(struct snd_pcm_substream *substream, int cmd)
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
+		printk(KERN_INFO "trigger on\n");
 		atomic_set(&core->stream_started, 1);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
+		printk(KERN_INFO "trigger_off\n");
 		atomic_set(&core->stream_started, 0);
 		break;
 	default:
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 146c7e8..e310e88 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -61,21 +61,26 @@ module_param_array(card,  int, NULL, 0444);
 
 static unsigned long tm6000_devused;
 
+static unsigned int xc2028_mts;
+module_param(xc2028_mts, int, 0644);
+MODULE_PARM_DESC(xc2028_mts, "enable mts firmware (xc2028/3028 only)");
+
+static unsigned int xc2028_dtv78;
+module_param(xc2028_dtv78, int, 0644);
+MODULE_PARM_DESC(xc2028_dtv78, "enable dualband config (xc2028/3028 only)");
 
 struct tm6000_board {
 	char            *name;
 
 	struct tm6000_capabilities caps;
-	enum            tm6000_inaudio aradio;
-	enum            tm6000_inaudio avideo;
-
 	enum		tm6000_devtype type;	/* variant of the chipset */
 	int             tuner_type;     /* type of the tuner */
 	int             tuner_addr;     /* tuner address */
 	int             demod_addr;     /* demodulator address */
 
 	struct tm6000_gpio gpio;
-
+	struct tm6000_input	vinput[3];
+	struct tm6000_input	rinput;
 	char		*ir_codes;
 };
 
@@ -88,6 +93,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM5600_BOARD_GENERIC] = {
 		.name         = "Generic tm5600 board",
@@ -100,6 +119,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_GENERIC] = {
 		.name         = "Generic tm6000 board",
@@ -112,6 +145,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_GENERIC] = {
 		.name         = "Generic tm6010 board",
@@ -135,6 +182,20 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM5600_BOARD_10MOONS_UT821] = {
 		.name         = "10Moons UT 821",
@@ -148,6 +209,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM5600_BOARD_10MOONS_UT330] = {
 		.name         = "10Moons UT 330",
@@ -159,6 +234,20 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 0,
 			.has_eeprom   = 1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_ADSTECH_DUAL_TV] = {
 		.name         = "ADSTECH Dual TV USB",
@@ -171,6 +260,20 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 1,
 			.has_eeprom   = 1,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_FREECOM_AND_SIMILAR] = {
 		.name         = "Freecom Hybrid Stick / Moka DVB-T Receiver Dual",
@@ -187,6 +290,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_4,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6000_BOARD_ADSTECH_MINI_DUAL_TV] = {
 		.name         = "ADSTECH Mini Dual TV USB",
@@ -202,6 +319,20 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio = {
 			.tuner_reset	= TM6000_GPIO_4,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_HAUPPAUGE_900H] = {
 		.name         = "Hauppauge WinTV HVR-900H / WinTV USB2-Stick",
@@ -225,6 +356,20 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_BEHOLD_WANDER] = {
 		.name         = "Beholder Wander DVB-T/TV/FM USB2.0",
@@ -232,43 +377,73 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
-		.avideo       = TM6000_AIP_SIF1,
-		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner      = 1,
 			.has_dvb        = 1,
 			.has_zl10353    = 1,
 			.has_eeprom     = 1,
 			.has_remote     = 1,
-			.has_input_comp = 1,
-			.has_input_svid = 1,
+			.has_radio      = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
 			.demod_reset	= TM6010_GPIO_1,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_MUX_ADC1,
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
 			.has_zl10353    = 0,
 			.has_eeprom     = 1,
 			.has_remote     = 1,
-			.has_input_comp = 1,
-			.has_input_svid = 1,
+			.has_radio      = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_MUX_ADC1,
+		},
 	},
 	[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
 		.name         = "Terratec Cinergy Hybrid XE / Cinergy Hybrid-Stick",
@@ -282,6 +457,7 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 1,
 			.has_eeprom   = 1,
 			.has_remote   = 1,
+			.has_radio    = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_2,
@@ -293,11 +469,43 @@ struct tm6000_board tm6000_boards[] = {
 			.ir		= TM6010_GPIO_0,
 		},
 		.ir_codes = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_MUX_SIF1,
+		},
 	},
 	[TM5600_BOARD_TERRATEC_GRABSTER] = {
 		.name         = "Terratec Grabster AV 150/250 MX",
 		.type         = TM5600,
 		.tuner_type   = TUNER_ABSENT,
+		.vinput = { {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_ADC1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE2,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_TWINHAN_TU501] = {
 		.name         = "Twinhan TU501(704D1)",
@@ -321,6 +529,20 @@ struct tm6000_board tm6000_boards[] = {
 			.dvb_led	= TM6010_GPIO_5,
 			.ir		= TM6010_GPIO_0,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			}, {
+			.type	= TM6000_INPUT_COMPOSITE1,
+			.vmux	= TM6000_MUX_VIDEO_A,
+			.amux	= TM6000_MUX_ADC2,
+			}, {
+			.type	= TM6000_INPUT_SVIDEO,
+			.vmux	= TM6000_MUX_VIDEO_AB,
+			.amux	= TM6000_MUX_ADC2,
+			},
+		},
 	},
 	[TM6010_BOARD_BEHOLD_WANDER_LITE] = {
 		.name         = "Beholder Wander Lite DVB-T/TV/FM USB2.0",
@@ -328,43 +550,57 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
-		.avideo       = TM6000_AIP_SIF1,
-		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner      = 1,
 			.has_dvb        = 1,
 			.has_zl10353    = 1,
 			.has_eeprom     = 1,
 			.has_remote     = 0,
-			.has_input_comp = 0,
-			.has_input_svid = 0,
+			.has_radio      = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
 			.demod_reset	= TM6010_GPIO_1,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_MUX_ADC1,
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
 			.has_zl10353    = 0,
 			.has_eeprom     = 1,
 			.has_remote     = 0,
-			.has_input_comp = 0,
-			.has_input_svid = 0,
+			.has_radio      = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_0,
 			.power_led	= TM6010_GPIO_6,
 		},
+		.vinput = { {
+			.type	= TM6000_INPUT_TV,
+			.vmux	= TM6000_MUX_VIDEO_B,
+			.amux	= TM6000_MUX_SIF1,
+			},
+		},
+		.rinput = {
+			.type	= TM6000_INPUT_RADIO,
+			.amux	= TM6000_MUX_ADC1,
+		},
 	},
 };
 
@@ -679,12 +915,17 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
 		memset(&ctl, 0, sizeof(ctl));
 
-		ctl.input1 = 1;
-		ctl.read_not_reliable = 0;
 		ctl.msleep = 10;
 		ctl.demod = XC3028_FE_ZARLINK456;
-		ctl.vhfbw7 = 1;
-		ctl.uhfbw8 = 1;
+
+		if (xc2028_dtv78) {
+			ctl.vhfbw7 = 1;
+			ctl.uhfbw8 = 1;
+		}
+
+		if (xc2028_mts)
+			ctl.mts = 1;
+
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
 
@@ -751,8 +992,14 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 
 	dev->caps = tm6000_boards[dev->model].caps;
 
-	dev->avideo = tm6000_boards[dev->model].avideo;
-	dev->aradio = tm6000_boards[dev->model].aradio;
+/*	dev->avideo = tm6000_boards[dev->model].avideo;
+	dev->aradio = tm6000_boards[dev->model].aradio; */
+	
+	dev->vinput[0] = tm6000_boards[dev->model].vinput[0];
+	dev->vinput[1] = tm6000_boards[dev->model].vinput[1];
+	dev->vinput[2] = tm6000_boards[dev->model].vinput[2];
+	dev->rinput = tm6000_boards[dev->model].rinput;
+	
 	/* initialize hardware */
 	rc = tm6000_init(dev);
 	if (rc < 0)
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 778e534..48a4de8 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -50,7 +50,7 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 		memcpy(data, buf, len);
 	}
 
-	if (tm6000_debug & V4L2_DEBUG_I2C) {
+	if (tm6000_debug) {
 		printk("(dev %p, pipe %08x): ", dev->udev, pipe);
 
 		printk("%s: %02x %02x %02x %02x %02x %02x %02x %02x ",
@@ -274,7 +274,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 							0x60, 0x60);
 		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
 							0x00, 0x40);
-		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
+//		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
 
 	} else {
 		/* Enables soft reset */
@@ -301,6 +301,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		/* Disables soft reset */
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
 
+		/* can remove begin */
 		/* E3: Select input 0 - TV tuner */
 		tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x00);
 		tm6000_set_reg(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0x60);
@@ -308,6 +309,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 		/* This controls input */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_2, 0x0);
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_3, 0x01);
+		/* can remove ends */
 	}
 	msleep(20);
 
@@ -323,11 +325,11 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	 * beginning, we needed to add this hack. The better would be to
 	 * discover some way to make tm6000 to wake up without this hack.
 	 */
-	f.frequency = dev->freq;
+/*	f.frequency = dev->freq;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
-
+*/
 	msleep(100);
-	tm6000_set_standard(dev, &dev->norm);
+	tm6000_set_standard(dev);
 	tm6000_set_vbi(dev);
 	tm6000_set_audio_bitrate(dev, 48000);
 
@@ -657,21 +659,22 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 }
 EXPORT_SYMBOL_GPL(tm6000_set_audio_bitrate);
 
-int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
+
+int tm6000_set_audio_rinput(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
 		/* Audio crossbar setting, default SIF1 */
 		u8 areg_f0 = 0x03;
 
-		switch (ainp) {
-		case TM6000_AIP_SIF1:
-		case TM6000_AIP_SIF2:
+		switch (dev->rinput.amux) {
+		case TM6000_MUX_SIF1:
+		case TM6000_MUX_SIF2:
 			areg_f0 = 0x03;
 			break;
-		case TM6000_AIP_LINE1:
+		case TM6000_MUX_ADC1:
 			areg_f0 = 0x00;
 			break;
-		case TM6000_AIP_LINE2:
+		case TM6000_MUX_ADC2:
 			areg_f0 = 0x08;
 			break;
 		default:
@@ -685,11 +688,11 @@ int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
 		/* Audio setting, default LINE1 */
 		u8 areg_eb = 0x00;
 
-		switch (ainp) {
-		case TM6000_AIP_LINE1:
+		switch (dev->rinput.amux) {
+		case TM6000_MUX_ADC1:
 			areg_eb = 0x00;
 			break;
-		case TM6000_AIP_LINE2:
+		case TM6000_MUX_ADC2:
 			areg_eb = 0x04;
 			break;
 		default:
@@ -702,7 +705,7 @@ int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tm6000_set_audio_input);
+
 
 void tm6010_set_mute_sif(struct tm6000_core *dev, u8 mute)
 {
@@ -736,16 +739,17 @@ void tm6010_set_mute_adc(struct tm6000_core *dev, u8 mute)
 
 int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 {
-	enum tm6000_inaudio ainp;
+	enum tm6000_mux mux;
 
+	printk("set mute\n");
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
+	case TM6000_MUX_SIF1:
+	case TM6000_MUX_SIF2:
 		if (dev->dev_type == TM6010)
 			tm6010_set_mute_sif(dev, mute);
 		else {
@@ -755,8 +759,8 @@ int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 			return -EINVAL;
 		}
 		break;
-	case TM6000_AIP_LINE1:
-	case TM6000_AIP_LINE2:
+	case TM6000_MUX_ADC1:
+	case TM6000_MUX_ADC2:
 		tm6010_set_mute_adc(dev, mute);
 		break;
 	default:
@@ -765,7 +769,6 @@ int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tm6000_tvaudio_set_mute);
 
 void tm6010_set_volume_sif(struct tm6000_core *dev, int vol)
 {
@@ -797,17 +800,18 @@ void tm6010_set_volume_adc(struct tm6000_core *dev, int vol)
 
 void tm6000_set_volume(struct tm6000_core *dev, int vol)
 {
-	enum tm6000_inaudio ainp;
+	enum tm6000_mux mux;
 
+	printk(KERN_INFO "set volume\n");
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
+	case TM6000_MUX_SIF1:
+	case TM6000_MUX_SIF2:
 		if (dev->dev_type == TM6010)
 			tm6010_set_volume_sif(dev, vol);
 		else
@@ -815,15 +819,14 @@ void tm6000_set_volume(struct tm6000_core *dev, int vol)
 					" SIF audio inputs. Please check the %s"
 					" configuration.\n", dev->name);
 		break;
-	case TM6000_AIP_LINE1:
-	case TM6000_AIP_LINE2:
+	case TM6000_MUX_ADC1:
+	case TM6000_MUX_ADC2:
 		tm6010_set_volume_adc(dev, vol);
 		break;
 	default:
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(tm6000_set_volume);
 
 static LIST_HEAD(tm6000_devlist);
 static DEFINE_MUTEX(tm6000_devlist_mutex);
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index dae2f1f..21e7da4 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -313,8 +313,6 @@ int tm6000_ir_int_start(struct tm6000_core *dev)
 		return -ENODEV;
 
 	ir->int_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!ir->int_urb)
-		return -ENOMEM;
 
 	pipe = usb_rcvintpipe(dev->udev,
 		dev->int_in.endp->desc.bEndpointAddress
@@ -376,7 +374,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	rc = rc_allocate_device();
-	if (!ir || !rc)
+	if (!ir | !rc)
 		goto out;
 
 	/* record handles to ourself */
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index da3e51b..45a2885 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -22,71 +22,24 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 
+static unsigned int tm6010_a_mode = 0;
+module_param(tm6010_a_mode, int, 0644);
+MODULE_PARM_DESC(tm6010_a_mode, "set sif audio mode (tm6010 only)");
+
 struct tm6000_reg_settings {
 	unsigned char req;
 	unsigned char reg;
 	unsigned char value;
 };
 
-enum tm6000_audio_std {
-	BG_NICAM,
-	BTSC,
-	BG_A2,
-	DK_NICAM,
-	EIAJ,
-	FM_RADIO,
-	I_NICAM,
-	KOREA_A2,
-	L_NICAM,
-};
-
-struct tm6000_std_tv_settings {
-	v4l2_std_id id;
-	enum tm6000_audio_std audio_default_std;
-
-	struct tm6000_reg_settings sif[12];
-	struct tm6000_reg_settings nosif[12];
-	struct tm6000_reg_settings common[26];
-};
-
 struct tm6000_std_settings {
 	v4l2_std_id id;
-	enum tm6000_audio_std audio_default_std;
-	struct tm6000_reg_settings common[37];
+	struct tm6000_reg_settings common[27];
 };
 
-static struct tm6000_std_tv_settings tv_stds[] = {
+static struct tm6000_std_settings comp_stds[] = {
 	{
 		.id = V4L2_STD_PAL_M,
-		.audio_default_std = BTSC,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
 		.common = {
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x04},
@@ -109,45 +62,14 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
 			{TM6010_REQ07_R3F_RESET, 0x00},
 
 			{0, 0, 0},
 		},
 	}, {
 		.id = V4L2_STD_PAL_Nc,
-		.audio_default_std = BTSC,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
 		.common = {
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x36},
@@ -170,45 +92,14 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
 			{TM6010_REQ07_R3F_RESET, 0x00},
 
 			{0, 0, 0},
 		},
 	}, {
 		.id = V4L2_STD_PAL,
-		.audio_default_std = BG_A2,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0}
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
 		.common = {
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x32},
@@ -231,163 +122,14 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
 			{TM6010_REQ07_R3F_RESET, 0x00},
 
 			{0, 0, 0},
 		},
 	}, {
-		.id = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G,
-		.audio_default_std = BG_NICAM,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_SECAM_DK,
-		.audio_default_std = DK_NICAM,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
-		.common = {
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
 		.id = V4L2_STD_NTSC,
-		.audio_default_std = BTSC,
-		.sif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
-			{0, 0, 0},
-		},
-		.nosif = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-			{0, 0, 0},
-		},
 		.common = {
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x00},
@@ -410,163 +152,15 @@ static struct tm6000_std_tv_settings tv_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-
-			{TM6010_REQ07_R3F_RESET, 0x00},
-
-			{0, 0, 0},
-		},
-	},
-};
-
-static struct tm6000_std_settings composite_stds[] = {
-	{
-		.id = V4L2_STD_PAL_M,
-		.audio_default_std = BTSC,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x04},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x83},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x0a},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe0},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x20},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
 			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	 }, {
-		.id = V4L2_STD_PAL_Nc,
-		.audio_default_std = BTSC,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x36},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x91},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x1f},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x0c},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
 
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
 	}, {
-		.id = V4L2_STD_PAL,
-		.audio_default_std = BG_A2,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x32},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x25},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0xd5},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x63},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x50},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	 }, {
 		.id = V4L2_STD_SECAM,
-		.audio_default_std = BG_NICAM,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -588,92 +182,6 @@ static struct tm6000_std_settings composite_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_SECAM_DK,
-		.audio_default_std = DK_NICAM,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_NTSC,
-		.audio_default_std = BTSC,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x00},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x8b},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xa2},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe9},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x1c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
@@ -684,20 +192,7 @@ static struct tm6000_std_settings composite_stds[] = {
 static struct tm6000_std_settings svideo_stds[] = {
 	{
 		.id = V4L2_STD_PAL_M,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x05},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -719,7 +214,6 @@ static struct tm6000_std_settings svideo_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
 			{TM6010_REQ07_R3F_RESET, 0x00},
@@ -727,20 +221,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL_Nc,
-		.audio_default_std = BTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x37},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -762,7 +243,6 @@ static struct tm6000_std_settings svideo_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
 			{TM6010_REQ07_R3F_RESET, 0x00},
@@ -770,20 +250,7 @@ static struct tm6000_std_settings svideo_stds[] = {
 		},
 	}, {
 		.id = V4L2_STD_PAL,
-		.audio_default_std = BG_A2,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x33},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -805,70 +272,44 @@ static struct tm6000_std_settings svideo_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
 			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
-	 }, {
-		.id = V4L2_STD_SECAM,
-		.audio_default_std = BG_NICAM,
+	}, {
+		.id = V4L2_STD_NTSC,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x39},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
+			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x01},
+			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
 			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
 			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x03},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
+			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x30},
+			{TM6010_REQ07_R17_HLOOP_MAXSTATE, 0x8b},
+			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
+			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x8b},
+			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xa2},
+			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe9},
 			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
 			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
 			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
 			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2a},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
+			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
+			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
+			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
+			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x1c},
+			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
+			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
+			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
 		},
 	}, {
-		.id = V4L2_STD_SECAM_DK,
-		.audio_default_std = DK_NICAM,
+		.id = V4L2_STD_SECAM,
 		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
 			{TM6010_REQ07_R3F_RESET, 0x01},
 			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x39},
 			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
@@ -890,51 +331,6 @@ static struct tm6000_std_settings svideo_stds[] = {
 			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
 			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
 			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
-
-			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
-			{TM6010_REQ07_R3F_RESET, 0x00},
-			{0, 0, 0},
-		},
-	}, {
-		.id = V4L2_STD_NTSC,
-		.audio_default_std = BTSC,
-		.common = {
-			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
-			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
-			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
-			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
-			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
-			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
-			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
-			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
-			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
-			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
-			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
-
-			{TM6010_REQ07_R3F_RESET, 0x01},
-			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x01},
-			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
-			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
-			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x03},
-			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x30},
-			{TM6010_REQ07_R17_HLOOP_MAXSTATE, 0x8b},
-			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
-			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x8b},
-			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xa2},
-			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe9},
-			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
-			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
-			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
-			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
-			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
-			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
-			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
-			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x1c},
-			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
-			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
-			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
-
-			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
 			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
 			{TM6010_REQ07_R3F_RESET, 0x00},
 			{0, 0, 0},
@@ -943,11 +339,10 @@ static struct tm6000_std_settings svideo_stds[] = {
 };
 
 
-static int tm6000_set_audio_std(struct tm6000_core *dev,
-				enum tm6000_audio_std std)
+static int tm6000_set_audio_std(struct tm6000_core *dev)
 {
 	uint8_t areg_02 = 0x04; /* GC1 Fixed gain 0dB */
-	uint8_t areg_05 = 0x09; /* Auto 4.5 = M Japan, Auto 6.5 = DK */
+	uint8_t areg_05 = 0x01; /* Auto 4.5 = M Japan, Auto 6.5 = DK */
 	uint8_t areg_06 = 0x02; /* Auto de-emphasis, mannual channel mode */
 	uint8_t mono_flag = 0;  /* No mono */
 	uint8_t nicam_flag = 0; /* No NICAM */
@@ -968,52 +363,87 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 		return 0;
 	}
 
-	switch (std) {
-#if 0
-	case DK_MONO:
-		mono_flag = 1;
-		break;
-	case DK_A2_1:
-		break;
-	case DK_A2_3:
-		areg_05 = 0x0b;
-		break;
-	case BG_MONO:
-		mono_flag = 1;
-		areg_05 = 0x05;
-		break;
-#endif
-	case BG_NICAM:
-		areg_05 = 0x07;
-		nicam_flag = 1;
-		break;
-	case BTSC:
-		areg_05 = 0x02;
-		break;
-	case BG_A2:
-		areg_05 = 0x05;
-		break;
-	case DK_NICAM:
-		areg_05 = 0x06;
-		nicam_flag = 1;
-		break;
-	case EIAJ:
-		areg_05 = 0x02;
-		break;
-	case I_NICAM:
-		areg_05 = 0x08;
-		nicam_flag = 1;
+	switch (tm6010_a_mode) {
+	/* auto */
+	case 0:
+		printk(KERN_INFO "sif auto\n");
+		switch (dev->norm) {
+		case V4L2_STD_NTSC_M_KR:
+			areg_05 |= 0x00;
+			break;
+		case V4L2_STD_NTSC_M_JP:
+			areg_05 |= 0x40;
+			break;
+		case V4L2_STD_NTSC_M:
+		case V4L2_STD_PAL_M:
+		case V4L2_STD_PAL_N:
+			areg_05 |= 0x20;
+			break;
+		case V4L2_STD_PAL_Nc:
+			areg_05 |= 0x60;
+			break;
+		case V4L2_STD_SECAM_L:
+			areg_05 |= 0x00;
+			break;
+		case V4L2_STD_DK:
+			areg_05 |= 0x10;
+			break;
+		default:
+			break;
+		}
 		break;
-	case KOREA_A2:
-		areg_05 = 0x04;
+	/* A2 */
+	case 1:
+		switch (dev->norm) {
+		case V4L2_STD_B:
+		case V4L2_STD_GH:
+			areg_05 = 0x05;
+			break;
+		case V4L2_STD_DK:
+			areg_05 = 0x09;
+			break;
+		}
 		break;
-	case L_NICAM:
-		areg_02 = 0x02; /* GC1 Fixed gain +12dB */
-		areg_05 = 0x0a;
+	/* NICAM */
+	case 2:
+		switch (dev->norm) {
+		case V4L2_STD_B:
+		case V4L2_STD_GH:
+			areg_05 = 0x07;
+			break;
+		case V4L2_STD_DK:
+			areg_05 = 0x06;
+			break;
+		case V4L2_STD_PAL_I:
+			areg_05 = 0x08;
+			break;
+		case V4L2_STD_SECAM_L:
+			areg_05 = 0x0a;
+			areg_02 = 0x02;
+			break;
+		}
 		nicam_flag = 1;
 		break;
-	default:
-		/* do nothink */
+	/* other */
+	case 3:
+		switch (dev->norm) {
+		/* DK3_A2 */
+		case V4L2_STD_DK:
+			areg_05 = 0x0b;
+			break;
+		/* Korea */
+		case V4L2_STD_NTSC_M_KR:
+			areg_05 = 0x04;
+			break;
+		/* EIAJ */
+		case V4L2_STD_NTSC_M_JP:
+			areg_05 = 0x03;
+			break;
+		/* BTSC */
+		default:
+			areg_05 = 0x02;
+			break;
+		}
 		break;
 	}
 
@@ -1031,15 +461,12 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 	}
 #endif
 
-	if (mono_flag)
-		areg_06 = 0x00;
-
 	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
 	tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, areg_02);
 	tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
 	tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0xa0);
 	tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, areg_05);
-	tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, areg_06);
+	tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x06);
 	tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, 0x00);
 	tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, 0x00);
 	tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
@@ -1068,7 +495,6 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
 	tm6000_set_reg(dev, TM6010_REQ08_R20_A_TEST_PIN_SEL, 0x00);
 	tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
 	tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
-	tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
 	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
 
 	return 0;
@@ -1111,53 +537,109 @@ static int tm6000_load_std(struct tm6000_core *dev,
 	return 0;
 }
 
-static int tm6000_set_tv(struct tm6000_core *dev, int pos)
-{
-	int rc;
-
-	/* FIXME: This code is for tm6010 - not tested yet - doesn't work with
-	   tm5600
-	 */
-
-	/* FIXME: This is tuner-dependent */
-	int nosif = 0;
-
-	if (nosif) {
-		rc = tm6000_load_std(dev, tv_stds[pos].nosif,
-				     sizeof(tv_stds[pos].nosif));
-	} else {
-		rc = tm6000_load_std(dev, tv_stds[pos].sif,
-				     sizeof(tv_stds[pos].sif));
-	}
-	if (rc < 0)
-		return rc;
-	rc = tm6000_load_std(dev, tv_stds[pos].common,
-			     sizeof(tv_stds[pos].common));
-
-	tm6000_set_audio_std(dev, tv_stds[pos].audio_default_std);
-
-	return rc;
-}
-
-int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id * norm)
+int tm6000_set_standard(struct tm6000_core *dev)
 {
 	int i, rc = 0;
+	u8 reg_07_fe = 0x8a;
+	u8 reg_08_f1 = 0xfc;
+	u8 reg_08_e2 = 0xf0;
+	u8 reg_08_e6 = 0x0f;
 
-	dev->norm = *norm;
 	tm6000_get_std_res(dev);
 
-	switch (dev->input) {
-	case TM6000_INPUT_TV:
-		for (i = 0; i < ARRAY_SIZE(tv_stds); i++) {
-			if (*norm & tv_stds[i].id) {
-				rc = tm6000_set_tv(dev, i);
-				goto ret;
-			}
+	/* 1. switch video path
+	   2. set video norm
+	   3. switch audio path
+	   4. set audio norm
+	 */
+	printk(KERN_INFO "set standard\n");
+	/* switch video path, audio path and power controls */ 
+	if (dev->dev_type == TM6010) {
+		switch (dev->vinput[dev->input].vmux) {
+		case TM6000_MUX_VIDEO_A:
+			tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4);
+			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
+			tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1);
+			tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0);
+			tm6000_set_reg(dev, TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2);
+			tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe8);
+			reg_07_fe |= 0x01;
+			break;
+		case TM6000_MUX_VIDEO_B:
+			tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8);
+			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
+			tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1);
+			tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0);
+			tm6000_set_reg(dev, TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2);
+			tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe8);
+			reg_07_fe |= 0x01;
+			break;
+		/* S-Video */
+		case TM6000_MUX_VIDEO_AB:
+			tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc);
+			tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8);
+			reg_08_e6 = 0x00;
+			tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2);
+			tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0);
+			tm6000_set_reg(dev, TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2);
+			tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe0);
+			break;
 		}
-		return -EINVAL;
-	case TM6000_INPUT_SVIDEO:
+		switch (dev->vinput[dev->input].amux) {
+		case TM6000_MUX_ADC1:
+			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x00, 0x0f);
+			break;
+		case TM6000_MUX_ADC2:
+			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x08, 0x0f);
+			break;
+		case TM6000_MUX_SIF1:
+			reg_08_e2 |= 0x02;
+			reg_08_e6 = 0x08;
+			reg_07_fe |= 0x40;
+			reg_08_f1 |= 0x02;
+			tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x02, 0x0f);
+			break;
+		}
+		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, reg_08_e2);
+		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, reg_08_e6);
+		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, reg_08_f1);
+		tm6000_set_reg(dev, TM6010_REQ07_RFE_POWER_DOWN, reg_07_fe);
+	} else {
+		switch (dev->vinput[dev->input].vmux) {
+		case TM6000_MUX_VIDEO_A:
+			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x10);
+			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x00);
+			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x0f);
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].gpio, 0x00);
+			break;
+		case TM6000_MUX_VIDEO_B:
+			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x00);
+			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x00);
+			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x0f);
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].gpio, 0x00);
+			break;
+		/* S-Video */
+		case TM6000_MUX_VIDEO_AB:
+			tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x10);
+			tm6000_set_reg(dev, TM6000_REQ07_RE5_VADC_INP_LPF_SEL2, 0x10);
+			tm6000_set_reg(dev, TM6000_REQ07_RE8_VADC_PWDOWN_CTL, 0x00);
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->vinput[dev->input].gpio, 0x01);
+			break;
+		}
+		/* audio path */
+		switch (dev->vinput[dev->input].amux) {
+		case TM6000_MUX_ADC1:
+			tm6000_set_reg_mask(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0x00, 0x0f);
+			break;
+		case TM6000_MUX_ADC2:
+			tm6000_set_reg_mask(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0x04, 0x0f);
+			break;
+		}
+	}
+	/* load video standards */
+	if (dev->vinput[dev->input].type == TM6000_INPUT_SVIDEO) {
 		for (i = 0; i < ARRAY_SIZE(svideo_stds); i++) {
-			if (*norm & svideo_stds[i].id) {
+			if (dev->norm & svideo_stds[i].id) {
 				rc = tm6000_load_std(dev, svideo_stds[i].common,
 						     sizeof(svideo_stds[i].
 							    common));
@@ -1165,14 +647,12 @@ int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id * norm)
 			}
 		}
 		return -EINVAL;
-	case TM6000_INPUT_COMPOSITE:
-		for (i = 0; i < ARRAY_SIZE(composite_stds); i++) {
-			if (*norm & composite_stds[i].id) {
-				rc = tm6000_load_std(dev,
-						     composite_stds[i].common,
-						     sizeof(composite_stds[i].
+	} else {
+		for (i = 0; i < ARRAY_SIZE(comp_stds); i++) {
+			if (dev->norm & comp_stds[i].id) {
+				rc = tm6000_load_std(dev, comp_stds[i].common,
+						     sizeof(comp_stds[i].
 							    common));
-				tm6000_set_audio_std(dev, composite_stds[i].audio_default_std);
 				goto ret;
 			}
 		}
@@ -1183,6 +663,13 @@ ret:
 	if (rc < 0)
 		return rc;
 
+	/* set sif audio standard */
+	if ((dev->dev_type == TM6010) && 
+	    ((dev->vinput[dev->input].amux == TM6000_MUX_SIF1) ||
+	    (dev->vinput[dev->input].amux == TM6000_MUX_SIF2))) {
+		printk(KERN_INFO "set sif parameter\n");
+		tm6000_set_audio_std(dev);
+	}
 	msleep(40);
 
 
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c80a316..35e712c 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1077,35 +1077,36 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	return 0;
 }
 
+static const char *iname [] = {
+	[TM6000_INPUT_TV] = "Television",
+	[TM6000_INPUT_COMPOSITE1] = "Composite 1",
+	[TM6000_INPUT_COMPOSITE2] = "Composite 2",
+	[TM6000_INPUT_SVIDEO] = "S-Video",
+};
+
 static int vidioc_enum_input(struct file *file, void *priv,
-				struct v4l2_input *inp)
+				struct v4l2_input *i)
 {
 	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
+	unsigned int		n;
 
-	switch (inp->index) {
-	case TM6000_INPUT_TV:
-		inp->type = V4L2_INPUT_TYPE_TUNER;
-		strcpy(inp->name, "Television");
-		break;
-	case TM6000_INPUT_COMPOSITE:
-		if (dev->caps.has_input_comp) {
-			inp->type = V4L2_INPUT_TYPE_CAMERA;
-			strcpy(inp->name, "Composite");
-		} else
-			return -EINVAL;
-		break;
-	case TM6000_INPUT_SVIDEO:
-		if (dev->caps.has_input_svid) {
-			inp->type = V4L2_INPUT_TYPE_CAMERA;
-			strcpy(inp->name, "S-Video");
-		} else
-			return -EINVAL;
-		break;
-	default:
+	n = i->index;
+	if (n >= 3) /* check */
 		return -EINVAL;
-	}
-	inp->std = TM6000_STD;
+	if (0 == dev->vinput[n].type)
+		return -EINVAL;
+
+	i->index = n;
+
+	if (dev->vinput[n].type == TM6000_INPUT_TV)
+		i->type = V4L2_INPUT_TYPE_TUNER;
+	else
+		i->type = V4L2_INPUT_TYPE_CAMERA;
+
+	strcpy(i->name, iname[dev->vinput[n].type]);
+
+	i->std = TM6000_STD;
 
 	return 0;
 }
@@ -1123,34 +1124,21 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct tm6000_fh   *fh = priv;
 	struct tm6000_core *dev = fh->dev;
-	int rc = 0;
-	char buf[1];
+	int		rc;
 
-	switch (i) {
-	case TM6000_INPUT_TV:
-		dev->input = i;
-		*buf = 0;
-		break;
-	case TM6000_INPUT_COMPOSITE:
-	case TM6000_INPUT_SVIDEO:
-		dev->input = i;
-		*buf = 1;
-		break;
-	default:
+	if (i >= 3) /* check */
+		return -EINVAL;
+	if (0 == dev->vinput[i].type)
 		return -EINVAL;
-	}
-	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
-			       REQ_03_SET_GET_MCU_PIN, 0x03, 1, buf, 1);
 
-	if (!rc) {
-		dev->input = i;
-		rc = vidioc_s_std(file, priv, &dev->vfd->current_norm);
-	}
+	dev->input = i;
+
+	rc = vidioc_s_std(file, priv, &dev->vfd->current_norm); /* ? */
 
 	return rc;
 }
 
-	/* --- controls ---------------------------------------------- */
+/* --- controls ---------------------------------------------- */
 static int vidioc_queryctrl(struct file *file, void *priv,
 				struct v4l2_queryctrl *qc)
 {
@@ -1340,8 +1328,8 @@ static int radio_g_tuner(struct file *file, void *priv,
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
 
-	if ((dev->aradio == TM6000_AIP_LINE1) ||
-				(dev->aradio == TM6000_AIP_LINE2)) {
+	if ((dev->rinput.amux == TM6000_MUX_ADC1) ||
+				(dev->rinput.amux == TM6000_MUX_ADC2)) {
 		t->rxsubchans = V4L2_TUNER_SUB_MONO;
 	}
 	else {
@@ -1368,9 +1356,15 @@ static int radio_s_tuner(struct file *file, void *priv,
 static int radio_enum_input(struct file *file, void *priv,
 					struct v4l2_input *i)
 {
+	struct tm6000_fh   *fh = priv;
+	struct tm6000_core *dev = fh->dev;
+
 	if (i->index != 0)
 		return -EINVAL;
 
+	if (dev->rinput.type == 0)
+		return -EINVAL;
+
 	strcpy(i->name, "Radio");
 	i->type = V4L2_INPUT_TYPE_TUNER;
 
@@ -1379,7 +1373,14 @@ static int radio_enum_input(struct file *file, void *priv,
 
 static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
 {
-	*i = 0;
+	struct tm6000_fh   *fh = priv;
+	struct tm6000_core *dev = fh->dev;
+
+	if (dev->input != 5)
+		return -EINVAL;
+
+	*i = dev->input - 5;
+
 	return 0;
 }
 
@@ -1399,6 +1400,17 @@ static int radio_s_audio(struct file *file, void *priv,
 
 static int radio_s_input(struct file *filp, void *priv, unsigned int i)
 {
+	struct tm6000_fh   *fh = priv;
+	struct tm6000_core *dev = fh->dev;
+
+	if (i != 0)
+		return -EINVAL;
+
+	if (0 == dev->rinput.type)
+		return -EINVAL;
+
+	dev->input = i + 5;
+
 	return 0;
 }
 
@@ -1512,16 +1524,13 @@ static int tm6000_open(struct file *file)
 
 	if (fh->radio) {
 		dprintk(dev, V4L2_DEBUG_OPEN, "video_open: setting radio device\n");
-		tm6000_set_audio_input(dev, dev->aradio);
-		tm6000_set_volume(dev, dev->ctl_volume);
+		dev->input = 5; //radio
+		tm6000_set_audio_rinput(dev);
+//		tm6000_set_volume(dev, dev->ctl_volume);
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
 		tm6000_prepare_isoc(dev);
 		tm6000_start_thread(dev);
 	}
-	else {
-		tm6000_set_audio_input(dev, dev->avideo);
-		tm6000_set_volume(dev, dev->ctl_volume);
-	}
 
 	return 0;
 }
@@ -1730,24 +1739,26 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	printk(KERN_INFO "%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vfd));
 
-	dev->radio_dev = vdev_init(dev, &tm6000_radio_template,
+	if (dev->caps.has_radio) {
+		dev->radio_dev = vdev_init(dev, &tm6000_radio_template,
 						   "radio");
-	if (!dev->radio_dev) {
-		printk(KERN_INFO "%s: can't register radio device\n",
-		       dev->name);
-		return ret; /* FIXME release resource */
-	}
+		if (!dev->radio_dev) {
+			printk(KERN_INFO "%s: can't register radio device\n",
+			       dev->name);
+			return ret; /* FIXME release resource */
+		}
 
-	ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 				    radio_nr);
-	if (ret < 0) {
-		printk(KERN_INFO "%s: can't register radio device\n",
-		       dev->name);
-		return ret; /* FIXME release resource */
-	}
+		if (ret < 0) {
+			printk(KERN_INFO "%s: can't register radio device\n",
+			       dev->name);
+			return ret; /* FIXME release resource */
+		}
 
-	printk(KERN_INFO "%s: registered device %s\n",
-	       dev->name, video_device_node_name(dev->radio_dev));
+		printk(KERN_INFO "%s: registered device %s\n",
+		       dev->name, video_device_node_name(dev->radio_dev));
+	}
 
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 99ae50e..15b6cc9 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -42,9 +42,22 @@
 /* Inputs */
 
 enum tm6000_itype {
-	TM6000_INPUT_TV	= 0,
-	TM6000_INPUT_COMPOSITE,
+	TM6000_INPUT_TV	= 1,
+	TM6000_INPUT_COMPOSITE1,
+	TM6000_INPUT_COMPOSITE2, /* if hasn't a tuner */
 	TM6000_INPUT_SVIDEO,
+	TM6000_INPUT_DVB,
+	TM6000_INPUT_RADIO,
+};
+
+enum tm6000_mux {
+	TM6000_MUX_VIDEO_A	= 1,
+	TM6000_MUX_VIDEO_B,
+	TM6000_MUX_VIDEO_AB,
+	TM6000_MUX_ADC1,
+	TM6000_MUX_ADC2,
+	TM6000_MUX_SIF1,
+	TM6000_MUX_SIF2,
 };
 
 enum tm6000_devtype {
@@ -53,6 +66,14 @@ enum tm6000_devtype {
 	TM6010,
 };
 
+struct tm6000_input {
+	enum tm6000_itype	type;
+	unsigned int		vmux;
+	unsigned int		amux;
+	unsigned int		gpio;
+};
+
+/* old
 enum tm6000_inaudio {
 	TM6000_AIP_UNK = 0,
 	TM6000_AIP_SIF1,
@@ -60,6 +81,7 @@ enum tm6000_inaudio {
 	TM6000_AIP_LINE1,
 	TM6000_AIP_LINE2,
 };
+*/
 
 /* ------------------------------------------------------------------
  *	Basic structures
@@ -129,8 +151,9 @@ struct tm6000_capabilities {
 	unsigned int    has_zl10353:1;
 	unsigned int    has_eeprom:1;
 	unsigned int    has_remote:1;
-	unsigned int    has_input_comp:1;
-	unsigned int    has_input_svid:1;
+	unsigned int    has_radio:1;
+/*	unsigned int    has_input_comp:1;
+	unsigned int    has_input_svid:1; */
 };
 
 struct tm6000_dvb {
@@ -211,6 +234,8 @@ struct tm6000_core {
 	struct v4l2_device		v4l2_dev;
 
 	int				input;
+	struct tm6000_input		vinput[3]; /* array all aviable inputs, max 3 */
+	struct tm6000_input		rinput;
 	int				freq;
 	unsigned int			fourcc;
 
@@ -226,9 +251,9 @@ struct tm6000_core {
 	struct snd_tm6000_card		*adev;
 	struct work_struct		wq_trigger;   /* Trigger to start/stop audio for alsa module */
 	atomic_t			stream_started;  /* stream should be running if true */
-	enum tm6000_inaudio		avideo;
+/*	enum tm6000_inaudio		avideo;
 	enum tm6000_inaudio		aradio;
-
+*/
 	struct tm6000_IR		*ir;
 
 	/* locks */
@@ -302,7 +327,7 @@ int tm6000_init(struct tm6000_core *dev);
 int tm6000_init_analog_mode(struct tm6000_core *dev);
 int tm6000_init_digital_mode(struct tm6000_core *dev);
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate);
-int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp);
+int tm6000_set_audio_rinput(struct tm6000_core *dev);
 int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute);
 void tm6000_set_volume(struct tm6000_core *dev, int vol);
 
@@ -323,7 +348,7 @@ int tm6000_call_fillbuf(struct tm6000_core *dev, enum tm6000_ops_type type,
 
 /* In tm6000-stds.c */
 void tm6000_get_std_res(struct tm6000_core *dev);
-int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id *norm);
+int tm6000_set_standard(struct tm6000_core *dev);
 
 /* In tm6000-i2c.c */
 int tm6000_i2c_register(struct tm6000_core *dev);
-- 
1.7.3.4

