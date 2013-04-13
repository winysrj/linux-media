Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48439 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3DMJrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 05:47:42 -0400
Received: by mail-ee0-f50.google.com with SMTP id e53so1623649eek.9
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 02:47:40 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/3] em28xx: give up GPIO register tracking/caching
Date: Sat, 13 Apr 2013 11:48:39 +0200
Message-Id: <1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GPIO register tracking/caching code is partially broken, because newer
devices provide more than one GPIO register and some of them are even using
separate registers for read and write access.
Making it work would be too complicated.
It is also used nowhere and doesn't make sense in cases where input lines are
connected to buttons etc.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   12 ------------
 drivers/media/usb/em28xx/em28xx-core.c  |   27 ++-------------------------
 drivers/media/usb/em28xx/em28xx.h       |    6 ------
 3 Dateien geändert, 2 Zeilen hinzugefügt(+), 43 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index bec604f..e328159 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2880,10 +2880,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	em28xx_set_model(dev);
 
-	/* Set the default GPO/GPIO for legacy devices */
-	dev->reg_gpo_num = EM2880_R04_GPO;
-	dev->reg_gpio_num = EM28XX_R08_GPIO;
-
 	dev->wait_after_write = 5;
 
 	/* Based on the Chip ID, set the device configuration */
@@ -2930,13 +2926,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2874:
 			chip_name = "em2874";
-			dev->reg_gpio_num = EM2874_R80_GPIO;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
 		case CHIP_ID_EM28174:
 			chip_name = "em28174";
-			dev->reg_gpio_num = EM2874_R80_GPIO;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
@@ -2946,7 +2940,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2884:
 			chip_name = "em2884";
-			dev->reg_gpio_num = EM2874_R80_GPIO;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
@@ -2975,11 +2968,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
index a9323b6..e070de0 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -636,12 +636,6 @@ struct em28xx {
 
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

