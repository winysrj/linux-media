Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39529 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3EXQcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 May 2013 12:32:41 -0400
Received: by mail-ee0-f44.google.com with SMTP id b57so2846090eek.31
        for <linux-media@vger.kernel.org>; Fri, 24 May 2013 09:32:39 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/2] em28xx: complete GPIO register caching
Date: Fri, 24 May 2013 18:34:08 +0200
Message-Id: <1369413248-7028-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1369413248-7028-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1369413248-7028-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current GPIO register caching is incomplete.
Only one GPIO register and one GPO register is cached, but
nearly all chip variants have more than one GPIO register.
Caching of pure GPO registers (reg 0x04) also isn't needed.
At least parts of register 0x0c seem to be assigned to GPIO lines,
so we need to cache this register, too.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 12 ---------
 drivers/media/usb/em28xx/em28xx-core.c  | 43 ++++++++++++++++++++++-----------
 drivers/media/usb/em28xx/em28xx.h       | 15 ++++++++----
 3 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 83bfbe4..7486533 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2881,10 +2881,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	em28xx_set_model(dev);
 
-	/* Set the default GPO/GPIO for legacy devices */
-	dev->reg_gpo_num = EM2880_R04_GPO;
-	dev->reg_gpio_num = EM28XX_R08_GPIO;
-
 	dev->wait_after_write = 5;
 
 	/* Based on the Chip ID, set the device configuration */
@@ -2932,13 +2928,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
@@ -2948,7 +2942,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2884:
 			chip_name = "em2884";
-			dev->reg_gpio_num = EM2874_R80_GPIO;
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
@@ -2977,11 +2970,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
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
index a802128..58f8d22 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -197,16 +197,19 @@ int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len)
 
 	rc = em28xx_write_regs_req(dev, USB_REQ_GET_STATUS, reg, buf, len);
 
-	/* Stores GPO/GPIO values at the cache, if changed
-	   Only write values should be stored, since input on a GPIO
-	   register will return the input bits.
-	   Not sure what happens on reading GPO register.
-	 */
+
 	if (rc >= 0) {
-		if (reg == dev->reg_gpo_num)
-			dev->reg_gpo = buf[0];
-		else if (reg == dev->reg_gpio_num)
-			dev->reg_gpio = buf[0];
+		/* Cache gpio register values (see em28xx_write_reg_bits()) */
+		if (reg == EM28XX_R08_GPIO)
+			dev->gpio_reg08_val = buf[0];
+		else if (reg == EM28XX_R0C_USBSUSP)
+			dev->gpio_reg0C_val = buf[0];
+		else if (reg == EM25XX_R80_GPIO_P0_W)
+			dev->gpio_reg80_val = buf[0];
+		else if (reg == EM25XX_R81_GPIO_P1_W)
+			dev->gpio_reg81_val = buf[0];
+		else if (reg == EM25XX_R83_GPIO_P3_W)
+			dev->gpio_reg83_val = buf[0];
 	}
 
 	return rc;
@@ -231,11 +234,23 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
 	int oldval;
 	u8 newval;
 
-	/* Uses cache for gpo/gpio registers */
-	if (reg == dev->reg_gpo_num)
-		oldval = dev->reg_gpo;
-	else if (reg == dev->reg_gpio_num)
-		oldval = dev->reg_gpio;
+	/* Use cached values for gpio registers */
+	/* NOTE: for unmasked bits corresponding to input lines we can't take
+	 * the current value from the register, because reads and writes have
+	 * different meanings in this case:
+	 * write: enable/disable input; read: current line state (if enenabled)
+	 * => if input is enabled and line is low, we would disable the input !
+	 */
+	if (reg == EM28XX_R08_GPIO)
+		oldval = dev->gpio_reg08_val;
+	else if (reg == EM28XX_R0C_USBSUSP)
+		oldval = dev->gpio_reg0C_val;
+	else if (reg == EM25XX_R80_GPIO_P0_W)
+		oldval = dev->gpio_reg80_val;
+	else if (reg == EM25XX_R81_GPIO_P1_W)
+		oldval = dev->gpio_reg81_val;
+	else if (reg == EM25XX_R83_GPIO_P3_W)
+		oldval = dev->gpio_reg83_val;
 	else
 		oldval = em28xx_read_reg(dev, reg);
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a9323b6..a536eb6 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -636,11 +636,16 @@ struct em28xx {
 
 	enum em28xx_mode mode;
 
-	/* register numbers for GPO/GPIO registers */
-	u16 reg_gpo_num, reg_gpio_num;
-
-	/* Caches GPO and GPIO registers */
-	unsigned char	reg_gpo, reg_gpio;
+	/* GPIO register values */
+	/*
+	 * NOTE: GPI config needs to be cached for em28xx_write_reg_bits().
+	 *       There is no need to cache pure GPO registers.
+	 */
+	unsigned char gpio_reg08_val;
+	unsigned char gpio_reg0C_val;
+	unsigned char gpio_reg80_val;
+	unsigned char gpio_reg81_val;
+	unsigned char gpio_reg83_val;
 
 	/* Snapshot button */
 	char snapshot_button_path[30];	/* path of the input dev */
-- 
1.8.1.2

