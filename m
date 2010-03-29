Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:53039 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab0C2Qwa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 12:52:30 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/3] tm6000: add gpios for tm6010 generic board
Date: Mon, 29 Mar 2010 18:51:12 +0200
Message-Id: <1269881472-28245-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1269881472-28245-2-git-send-email-stefan.ringel@arcor.de>
References: <1269881472-28245-1-git-send-email-stefan.ringel@arcor.de>
 <1269881472-28245-2-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index ab187c3..2f0274d 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -109,12 +109,22 @@ struct tm6000_board tm6000_boards[] = {
 		.type         = TM6010,
 		.tuner_type   = TUNER_XC2028,
 		.tuner_addr   = 0xc2 >> 1,
+		.demod_addr   = 0x1e >> 1,
 		.caps = {
 			.has_tuner	= 1,
 			.has_dvb	= 1,
+			.has_zl10353	= 1,
+			.has_eeprom	= 1,
+			.has_remote	= 1,
 		},
 		.gpio = {
-			.tuner_reset	= TM6010_GPIO_4,
+			.tuner_reset	= TM6010_GPIO_2,
+			.tuner_on	= TM6010_GPIO_3,
+			.demod_reset	= TM6010_GPIO_1,
+			.demod_on	= TM6010_GPIO_4,
+			.power_led	= TM6010_GPIO_7,
+			.dvb_led	= TM6010_GPIO_5,
+			.ir		= TM6010_GPIO_0,
 		},
 	},
 	[TM5600_BOARD_10MOONS_UT821] = {
@@ -400,6 +410,7 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 	case TM6010_BOARD_HAUPPAUGE_900H:
 	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 	case TM6010_BOARD_TWINHAN_TU501:
+	case TM6010_BOARD_GENERIC:
 		/* Turn xceive 3028 on */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.tuner_on, 0x01);
 		msleep(15);
-- 
1.6.6.1

