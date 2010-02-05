Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:44426 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968Ab0BEXFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 18:05:11 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 6/12] tm6000: tuner reset timeing optimation
Date: Sat,  6 Feb 2010 00:04:14 +0100
Message-Id: <1265411060-12125-6-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 1167b01..5cf5d58 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -271,11 +271,14 @@ static int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 		switch (arg) {
 		case 0:
 			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+					dev->tuner_reset_gpio, 0x01);
+			msleep(60);
+			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
 					dev->tuner_reset_gpio, 0x00);
-			msleep(130);
+			msleep(75);
 			tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
 					dev->tuner_reset_gpio, 0x01);
-			msleep(130);
+			msleep(60);
 			break;
 		case 1:
 			tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT,
@@ -288,10 +291,10 @@ static int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 						TM6000_GPIO_CLK, 0);
 			if (rc<0)
 				return rc;
-			msleep(100);
+			msleep(10);
 			rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
 						TM6000_GPIO_CLK, 1);
-			msleep(100);
+			msleep(10);
 			break;
 		}
 	}
-- 
1.6.6.1

