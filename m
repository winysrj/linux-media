Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:37196 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972Ab0C2Qw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 12:52:28 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/3] tm6000: add gpios to board struct
Date: Mon, 29 Mar 2010 18:51:11 +0200
Message-Id: <1269881472-28245-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1269881472-28245-1-git-send-email-stefan.ringel@arcor.de>
References: <1269881472-28245-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   37 +++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 1710990..ab187c3 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -195,9 +195,16 @@ struct tm6000_board tm6000_boards[] = {
 			.has_dvb      = 1,
 			.has_zl10353  = 1,
 			.has_eeprom   = 1,
+			.has_remote   = 1,
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_2,
+			.tuner_on	= TM6010_GPIO_3,
+			.demod_reset	= TM6010_GPIO_1,
+			.demod_on	= TM6010_GPIO_4,
+			.power_led	= TM6010_GPIO_7,
+			.dvb_led	= TM6010_GPIO_5,
+			.ir		= TM6010_GPIO_0,
 		},
 	},
 	[TM6010_BOARD_BEHOLD_WANDER] = {
@@ -248,6 +255,12 @@ struct tm6000_board tm6000_boards[] = {
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_2,
+			.tuner_on	= TM6010_GPIO_3,
+			.demod_reset	= TM6010_GPIO_1,
+			.demod_on	= TM6010_GPIO_4,
+			.power_led	= TM6010_GPIO_7,
+			.dvb_led	= TM6010_GPIO_5,
+			.ir		= TM6010_GPIO_0,
 		},
 	},
 	[TM6010_BOARD_TWINHAN_TU501] = {
@@ -265,6 +278,12 @@ struct tm6000_board tm6000_boards[] = {
 		},
 		.gpio = {
 			.tuner_reset	= TM6010_GPIO_2,
+			.tuner_on	= TM6010_GPIO_3,
+			.demod_reset	= TM6010_GPIO_1,
+			.demod_on	= TM6010_GPIO_4,
+			.power_led	= TM6010_GPIO_7,
+			.dvb_led	= TM6010_GPIO_5,
+			.ir		= TM6010_GPIO_0,
 		},
 	}
 };
@@ -382,30 +401,30 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 	case TM6010_BOARD_TWINHAN_TU501:
 		/* Turn xceive 3028 on */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.tuner_on, 0x01);
 		msleep(15);
 		/* Turn zarlink zl10353 on */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_4, 0x00);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_on, 0x00);
 		msleep(15);
 		/* Reset zarlink zl10353 */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_1, 0x00);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_reset, 0x00);
 		msleep(50);
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_1, 0x01);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_reset, 0x01);
 		msleep(15);
 		/* Turn zarlink zl10353 off */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_4, 0x01);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_on, 0x01);
 		msleep(15);
 		/* ir ? */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_0, 0x01);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.ir, 0x01);
 		msleep(15);
 		/* Power led on (blue) */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_7, 0x00);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.power_led, 0x00);
 		msleep(15);
 		/* DVB led off (orange) */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_5, 0x01);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.dvb_led, 0x01);
 		msleep(15);
 		/* Turn zarlink zl10353 on */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_4, 0x00);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_on, 0x00);
 		msleep(15);
 		break;
 	default:
-- 
1.6.6.1

