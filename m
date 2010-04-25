Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36002 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0DYGu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 02:50:58 -0400
Received: by gwj19 with SMTP id 19so3420791gwj.19
        for <linux-media@vger.kernel.org>; Sat, 24 Apr 2010 23:50:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 25 Apr 2010 14:50:57 +0800
Message-ID: <l2z6e8e83e21004242350u269f1167le20731e41fadedb6@mail.gmail.com>
Subject: [PATCH 1/2] tm6000 : Add additional GPIO for UT821 during frmware
	loading
From: Bee Hock Goh <beehock@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bee Hock Goh <beehock@gmail.com>

diff --git a/drivers/staging/tm6000/tm6000-cards.c
b/drivers/staging/tm6000/tm6000-cards.c
index f795a3e..ced8fce 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -349,6 +349,22 @@ int tm6000_tuner_callback(void *ptr, int
component, int command, int arg)
 		case 0:
 			/* newer tuner can faster reset */
 			switch (dev->model) {
+			case TM5600_BOARD_10MOONS_UT821:
+				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+					       dev->gpio.tuner_reset, 0x01);
+				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+					       0x300, 0x01);
+				msleep(10);
+				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+					       dev->gpio.tuner_reset, 0x00);
+				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+					       0x300, 0x00);
+				msleep(10);
+				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+					       dev->gpio.tuner_reset, 0x01);
+				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+					       0x300, 0x01);
+				break;
 			case TM6010_BOARD_HAUPPAUGE_900H:
 			case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 			case TM6010_BOARD_TWINHAN_TU501:
