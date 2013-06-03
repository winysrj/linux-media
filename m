Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47736 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759535Ab3FCSKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 14:10:38 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so1532235eak.22
        for <linux-media@vger.kernel.org>; Mon, 03 Jun 2013 11:10:37 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/4] em28xx: remove GPIO register caching
Date: Mon,  3 Jun 2013 20:12:05 +0200
Message-Id: <1370283125-2231-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1370283125-2231-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GPIO register caching is the result of wrong assumptions and incomplete
knowledge about the GPIO registers and their functionality.
Today, we know that it is not needed.
It is also limited to a single register and therefore incomplete (newer chips
are using multiple registers).

Instead of extending the caching, get rid of it, because it has no real
benefits and just bloats/complicates the code.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   12 ------------
 drivers/media/usb/em28xx/em28xx-core.c  |   27 ++-------------------------
 drivers/media/usb/em28xx/em28xx.h       |    6 ------
 3 Dateien geändert, 2 Zeilen hinzugefügt(+), 43 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 7f1422b..1a59cbc 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2897,10 +2897,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	em28xx_set_model(dev);
 
-	/* Set the default GPO/GPIO for legacy devices */
-	dev->reg_gpo_num = EM2880_R04_GPO;
-	dev->reg_gpio_num = EM2820_R08_GPIO_CTRL;
-
 	dev->wait_after_write = 5;
 
 	/* Based on the Chip ID, set the device configuration */
@@ -2948,13 +2944,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2874:
 			chip_name = "em2874";
-			dev->reg_gpio_num = EM2874_R80_GPIO_P0_CTRL;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
 		case CHIP_ID_EM28174:
 			chip_name = "em28174";
-			dev->reg_gpio_num = EM2874_R80_GPIO_P0_CTRL;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
@@ -2964,7 +2958,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2884:
 			chip_name = "em2884";
-			dev->reg_gpio_num = EM2874_R80_GPIO_P0_CTRL;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
@@ -2993,11 +2986,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		return 0;
 	}
 
-	/* Prepopulate cached GPO register content */
-	retval = em28xx_read_reg(dev, dev->reg_gpo_num);
-	if (retval >= 0)
-		dev->reg_gpo = retval;
-
 	em28xx_pre_card_setup(dev);
 
 	if (!dev->board.is_em2800) {
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index a802128..fc157af 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -193,23 +193,7 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 
 int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len)
 {
-	int rc;
-
-	rc = em28xx_write_regs_req(dev, USB_REQ_GET_STATUS, reg, buf, len);
-
-	/* Stores GPO/GPIO values at the cache, if changed
-	   Only write values should be stored, since input on a GPIO
-	   register will return the input bits.
-	   Not sure what happens on reading GPO register.
-	 */
-	if (rc >= 0) {
-		if (reg == dev->reg_gpo_num)
-			dev->reg_gpo = buf[0];
-		else if (reg == dev->reg_gpio_num)
-			dev->reg_gpio = buf[0];
-	}
-
-	return rc;
+	return em28xx_write_regs_req(dev, USB_REQ_GET_STATUS, reg, buf, len);
 }
 EXPORT_SYMBOL_GPL(em28xx_write_regs);
 
@@ -231,14 +215,7 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
 	int oldval;
 	u8 newval;
 
-	/* Uses cache for gpo/gpio registers */
-	if (reg == dev->reg_gpo_num)
-		oldval = dev->reg_gpo;
-	else if (reg == dev->reg_gpio_num)
-		oldval = dev->reg_gpio;
-	else
-		oldval = em28xx_read_reg(dev, reg);
-
+	oldval = em28xx_read_reg(dev, reg);
 	if (oldval < 0)
 		return oldval;
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 59a9580..205e903 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -637,12 +637,6 @@ struct em28xx {
 
 	enum em28xx_mode mode;
 
-	/* register numbers for GPO/GPIO registers */
-	u16 reg_gpo_num, reg_gpio_num;
-
-	/* Caches GPO and GPIO registers */
-	unsigned char	reg_gpo, reg_gpio;
-
 	/* Snapshot button */
 	char snapshot_button_path[30];	/* path of the input dev */
 	struct input_dev *sbutton_input_dev;
-- 
1.7.10.4

