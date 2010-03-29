Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:39310 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261Ab0C2Qw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 12:52:29 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/3] tm6000: switch to gpio strcut
Date: Mon, 29 Mar 2010 18:51:10 +0200
Message-Id: <1269881472-28245-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

switch to a gpio structure

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   68 ++++++++++++++++++++++----------
 drivers/staging/tm6000/tm6000.h       |   13 ++++++-
 2 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 2053008..1710990 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -66,7 +66,8 @@ struct tm6000_board {
 	int             tuner_type;     /* type of the tuner */
 	int             tuner_addr;     /* tuner address */
 	int             demod_addr;     /* demodulator address */
-	int		gpio_addr_tun_reset;	/* GPIO used for tuner reset */
+
+	struct tm6000_gpio gpio;
 };
 
 struct tm6000_board tm6000_boards[] = {
@@ -75,7 +76,9 @@ struct tm6000_board tm6000_boards[] = {
 		.caps = {
 			.has_tuner    = 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_1,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_1,
+		},
 	},
 	[TM5600_BOARD_GENERIC] = {
 		.name         = "Generic tm5600 board",
@@ -85,7 +88,9 @@ struct tm6000_board tm6000_boards[] = {
 		.caps = {
 			.has_tuner	= 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_1,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_1,
+		},
 	},
 	[TM6000_BOARD_GENERIC] = {
 		.name         = "Generic tm6000 board",
@@ -95,7 +100,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_tuner	= 1,
 			.has_dvb	= 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_1,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_1,
+		},
 	},
 	[TM6010_BOARD_GENERIC] = {
 		.name         = "Generic tm6010 board",
@@ -106,7 +113,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_tuner	= 1,
 			.has_dvb	= 1,
 		},
-		.gpio_addr_tun_reset = TM6010_GPIO_4,
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_4,
+		},
 	},
 	[TM5600_BOARD_10MOONS_UT821] = {
 		.name         = "10Moons UT 821",
@@ -117,7 +126,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_tuner    = 1,
 			.has_eeprom   = 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_1,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_1,
+		},
 	},
 	[TM5600_BOARD_10MOONS_UT330] = {
 		.name         = "10Moons UT 330",
@@ -154,7 +165,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom   = 0,
 			.has_remote   = 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_4,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_4,
+		},
 	},
 	[TM6000_BOARD_ADSTECH_MINI_DUAL_TV] = {
 		.name         = "ADSTECH Mini Dual TV USB",
@@ -167,7 +180,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 1,
 			.has_eeprom   = 0,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_4,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_4,
+		},
 	},
 	[TM6010_BOARD_HAUPPAUGE_900H] = {
 		.name         = "Hauppauge WinTV HVR-900H / WinTV USB2-Stick",
@@ -181,7 +196,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 1,
 			.has_eeprom   = 1,
 		},
-		.gpio_addr_tun_reset = TM6010_GPIO_2,
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_2,
+		},
 	},
 	[TM6010_BOARD_BEHOLD_WANDER] = {
 		.name         = "Beholder Wander DVB-T/TV/FM USB2.0",
@@ -196,7 +213,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom   = 1,
 			.has_remote   = 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_2,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_2,
+		},
 	},
 	[TM6010_BOARD_BEHOLD_VOYAGER] = {
 		.name         = "Beholder Voyager TV/FM USB2.0",
@@ -210,7 +229,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom   = 1,
 			.has_remote   = 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_2,
+		.gpio = {
+			.tuner_reset	= TM6000_GPIO_2,
+		},
 	},
 	[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
 		.name         = "Terratec Cinergy Hybrid XE / Cinergy Hybrid-Stick",
@@ -225,7 +246,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom   = 1,
 			.has_remote   = 1,
 		},
-		.gpio_addr_tun_reset = TM6010_GPIO_2,
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_2,
+		},
 	},
 	[TM6010_BOARD_TWINHAN_TU501] = {
 		.name         = "Twinhan TU501(704D1)",
@@ -240,7 +263,9 @@ struct tm6000_board tm6000_boards[] = {
 			.has_eeprom   = 1,
 			.has_remote   = 1,
 		},
-		.gpio_addr_tun_reset = TM6010_GPIO_2,
+		.gpio = {
+			.tuner_reset	= TM6010_GPIO_2,
+		},
 	}
 };
 
@@ -299,21 +324,21 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 			case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 			case TM6010_BOARD_TWINHAN_TU501:
 				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					       dev->tuner_reset_gpio, 0x01);
+					       dev->gpio.tuner_reset, 0x01);
 				msleep(60);
 				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					       dev->tuner_reset_gpio, 0x00);
+					       dev->gpio.tuner_reset, 0x00);
 				msleep(75);
 				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					       dev->tuner_reset_gpio, 0x01);
+					       dev->gpio.tuner_reset, 0x01);
 				msleep(60);
 				break;
 			default:
 				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					       dev->tuner_reset_gpio, 0x00);
+					       dev->gpio.tuner_reset, 0x00);
 				msleep(130);
 				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					       dev->tuner_reset_gpio, 0x01);
+					       dev->gpio.tuner_reset, 0x01);
 				msleep(130);
 				break;
 			}
@@ -396,7 +421,7 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 	 */
 	for (i = 0; i < 2; i++) {
 		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x00);
+					dev->gpio.tuner_reset, 0x00);
 		if (rc < 0) {
 			printk(KERN_ERR "Error %i doing GPIO1 reset\n", rc);
 			return rc;
@@ -404,7 +429,7 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 
 		msleep(10); /* Just to be conservative */
 		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x01);
+					dev->gpio.tuner_reset, 0x01);
 		if (rc < 0) {
 			printk(KERN_ERR "Error %i doing GPIO1 reset\n", rc);
 			return rc;
@@ -501,7 +526,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	dev->dev_type   = tm6000_boards[dev->model].type;
 	dev->tuner_type = tm6000_boards[dev->model].tuner_type;
 	dev->tuner_addr = tm6000_boards[dev->model].tuner_addr;
-	dev->tuner_reset_gpio = tm6000_boards[dev->model].gpio_addr_tun_reset;
+
+	dev->gpio = tm6000_boards[dev->model].gpio;
 
 	dev->demod_addr = tm6000_boards[dev->model].demod_addr;
 
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index bd727f1..172f7d7 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -103,6 +103,16 @@ enum tm6000_mode {
 	TM6000_MODE_DIGITAL,
 };
 
+struct tm6000_gpio {
+	int		tuner_reset;
+	int		tuner_on;
+	int		demod_reset;
+	int		demod_on;
+	int		power_led;
+	int		dvb_led;
+	int		ir;
+}
+
 struct tm6000_capabilities {
 	unsigned int    has_tuner:1;
 	unsigned int    has_tda9874:1;
@@ -140,7 +150,8 @@ struct tm6000_core {
 	/* Tuner configuration */
 	int				tuner_type;		/* type of the tuner */
 	int				tuner_addr;		/* tuner address */
-	int				tuner_reset_gpio;	/* GPIO used for tuner reset */
+
+	struct tm6000_gpio		gpio;
 
 	/* Demodulator configuration */
 	int				demod_addr;	/* demodulator address */
-- 
1.6.6.1

