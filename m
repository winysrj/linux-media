Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37397 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752689AbeCBTfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 14:35:03 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/8] media: em28xx: improve the logic with sets Xclk and I2C speed
Date: Fri,  2 Mar 2018 16:34:43 -0300
Message-Id: <19bdfad37599b5f12c824f37a08f635cf6126018.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic there should be called on two places. Also,
ideally, it should not be modifying the device struct.

So, change the logic accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 45 +++++++++++++++++----------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 34e16f6ab4ac..cbd7a43bd559 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2669,20 +2669,35 @@ int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
 }
 EXPORT_SYMBOL_GPL(em28xx_tuner_callback);
 
-static inline void em28xx_set_model(struct em28xx *dev)
+static inline void em28xx_set_xclk_i2c_speed(struct em28xx *dev)
 {
-	dev->board = em28xx_boards[dev->model];
+	struct em28xx_board *board = &em28xx_boards[dev->model];
+	u8 xclk = board->xclk, i2c_speed = board->i2c_speed;
 
 	/* Those are the default values for the majority of boards
 	   Use those values if not specified otherwise at boards entry
 	 */
-	if (!dev->board.xclk)
-		dev->board.xclk = EM28XX_XCLK_IR_RC5_MODE |
+	if (!xclk)
+		xclk = EM28XX_XCLK_IR_RC5_MODE |
 				  EM28XX_XCLK_FREQUENCY_12MHZ;
 
-	if (!dev->board.i2c_speed)
-		dev->board.i2c_speed = EM28XX_I2C_CLK_WAIT_ENABLE |
-				       EM28XX_I2C_FREQ_100_KHZ;
+	em28xx_write_reg(dev, EM28XX_R0F_XCLK, xclk);
+
+
+	if (!i2c_speed)
+		i2c_speed = EM28XX_I2C_CLK_WAIT_ENABLE |
+			    EM28XX_I2C_FREQ_100_KHZ;
+
+	if (!dev->board.is_em2800)
+		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, i2c_speed);
+	msleep(50);
+}
+
+static inline void em28xx_set_model(struct em28xx *dev)
+{
+	dev->board = em28xx_boards[dev->model];
+
+	em28xx_set_xclk_i2c_speed(dev);
 
 	/* Should be initialized early, for I2C to work */
 	dev->def_i2c_bus = dev->board.def_i2c_bus;
@@ -2725,10 +2740,7 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 {
 	/* Set the initial XCLK and I2C clock values based on the board
 	   definition */
-	em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk & 0x7f);
-	if (!dev->board.is_em2800)
-		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
-	msleep(50);
+	em28xx_set_xclk_i2c_speed(dev);
 
 	/* request some modules */
 	switch (dev->model) {
@@ -3382,17 +3394,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	em28xx_pre_card_setup(dev);
 
-	if (!dev->board.is_em2800) {
-		/* Resets I2C speed */
-		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
-		if (retval < 0) {
-			dev_err(&dev->intf->dev,
-			       "%s: em28xx_write_reg failed! retval [%d]\n",
-			       __func__, retval);
-			return retval;
-		}
-	}
-
 	rt_mutex_init(&dev->i2c_bus_lock);
 
 	/* register i2c bus 0 */
-- 
2.14.3
