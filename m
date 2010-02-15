Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:60178 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787Ab0BORiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:18 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 04/11] tm6000: add different tuner reset for terratec
Date: Mon, 15 Feb 2010 18:37:17 +0100
Message-Id: <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index ff04bba..5a8d716 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -269,12 +269,28 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 		/* Reset codes during load firmware */
 		switch (arg) {
 		case 0:
-			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x00);
-			msleep(130);
-			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x01);
-			msleep(130);
+			/* newer tuner can faster reset */
+			switch(dev->model) {
+			case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+				tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+						dev->tuner_reset_gpio, 0x01);
+				msleep(60);
+				tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+						dev->tuner_reset_gpio, 0x00);
+				msleep(75);
+				tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+						dev->tuner_reset_gpio, 0x01);
+				msleep(60);
+				break;
+			default:
+				tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+						dev->tuner_reset_gpio, 0x00);
+				msleep(130);
+				tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+						dev->tuner_reset_gpio, 0x01);
+				msleep(130);
+				break;
+			}
 			break;
 		case 1:
 			tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT,
-- 
1.6.6.1

