Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:60174 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779Ab0BORiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:18 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 05/11] tm6000: add card setup for terratec cinergy hybrid
Date: Mon, 15 Feb 2010 18:37:18 +0100
Message-Id: <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 5a8d716..7a60e5c 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -332,6 +332,31 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
 		msleep(11);
 		break;
+	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		/* Turn zarlink zl10353 on */
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_4, 0x00);
+		msleep(15);
+		/* Reset zarlink zl10353 */
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_1, 0x00);
+		msleep(50);
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_1, 0x01);
+		msleep(15);
+		/* Turn zarlink zl10353 off */
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_4, 0x01);
+		msleep(15);
+		/* ir ? */
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_0, 0x01);
+		msleep(15);
+		/* Power led on (blue) */
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_7, 0x00);
+		msleep(15);
+		/* DVB led off (orange) */
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_5, 0x01);
+		msleep(15);
+		/* Turn zarlink zl10353 on */
+		tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_4, 0x00);
+		msleep(15);
+		break;
 	default:
 		break;
 	}
-- 
1.6.6.1

