Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33495 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbeG3K7K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 06:59:10 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/3] media: usb: em28xx: Replace mdelay() with msleep() in em28xx_pre_card_setup()
Date: Mon, 30 Jul 2018 17:24:59 +0800
Message-Id: <20180730092459.7848-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_pre_card_setup() is never called in atomic context.
It calls mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6e0e67d23876..24ac257fd421 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2825,13 +2825,13 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		em28xx_write_reg(dev, EM2880_R04_GPO, 0x01);
 		usleep_range(10000, 11000);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
-		mdelay(70);
+		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfc);
-		mdelay(70);
+		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xdc);
-		mdelay(70);
+		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfc);
-		mdelay(70);
+		msleep(70);
 		break;
 	case EM2870_BOARD_TERRATEC_XS_MT2060:
 		/*
@@ -2839,11 +2839,11 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		 * demod work
 		 */
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
-		mdelay(70);
+		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xde);
-		mdelay(70);
+		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
-		mdelay(70);
+		msleep(70);
 		break;
 	case EM2870_BOARD_PINNACLE_PCTV_DVB:
 		/*
@@ -2851,11 +2851,11 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		 * DVB-T demod work
 		 */
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
-		mdelay(70);
+		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xde);
-		mdelay(70);
+		msleep(70);
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfe);
-		mdelay(70);
+		msleep(70);
 		break;
 	case EM2820_BOARD_GADMEI_UTV310:
 	case EM2820_BOARD_MSI_VOX_USB_2:
-- 
2.17.0
