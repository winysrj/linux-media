Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaG1SH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 14:07:28 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] au0828: improve I2C speed
Date: Mon, 28 Jul 2014 15:07:19 -0300
Message-Id: <1406570842-26316-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
References: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commits 21dc61d3c0a4 and 7a1dd50b89d4 reduced the board I2C
speed to 20 MHz by default, due to a I2C stretch issue:
while xc5000 uses i2c stretch when a command is sent to it,
au0828 doesn't support this feature.

However, this is needed only for Xceive tuners. The other
I2C devices can work at the max speed.

So, revert the workarounds at board level, handling it at
I2C level, only when talking with xc5000.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-cards.c |  6 +++---
 drivers/media/usb/au0828/au0828-i2c.c   | 23 +++++++++++++----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 7fdadf9bc90b..3a7924044a87 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -46,7 +46,7 @@ struct au0828_board au0828_boards[] = {
 		.name	= "Hauppauge HVR850",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
-		.i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
+		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 		.input = {
 			{
 				.type = AU0828_VMUX_TELEVISION,
@@ -77,7 +77,7 @@ struct au0828_board au0828_boards[] = {
 		   stretch fits inside of a normal clock cycle, or else the
 		   au0828 fails to set the STOP bit.  A 30 KHz clock puts the
 		   clock pulse width at 18us */
-		.i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
+		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 		.input = {
 			{
 				.type = AU0828_VMUX_TELEVISION,
@@ -108,7 +108,7 @@ struct au0828_board au0828_boards[] = {
 		.name	= "DViCO FusionHDTV USB",
 		.tuner_type = UNSET,
 		.tuner_addr = ADDR_UNSET,
-		.i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
+		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 	},
 	[AU0828_BOARD_HAUPPAUGE_WOODBURY] = {
 		.name = "Hauppauge Woodbury",
diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
index 17ec3651b10e..ac8e94795f48 100644
--- a/drivers/media/usb/au0828/au0828-i2c.c
+++ b/drivers/media/usb/au0828/au0828-i2c.c
@@ -141,25 +141,28 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 {
 	int i, strobe = 0;
 	struct au0828_dev *dev = i2c_adap->algo_data;
+	u8 i2c_speed = dev->board.i2c_clk_divider;
 
 	dprintk(4, "%s()\n", __func__);
 
 	au0828_write(dev, AU0828_I2C_MULTIBYTE_MODE_2FF, 0x01);
 
 	/* Set the I2C clock */
+
 	if (((dev->board.tuner_type == TUNER_XC5000) ||
 	     (dev->board.tuner_type == TUNER_XC5000C)) &&
-	    (dev->board.tuner_addr == msg->addr) &&
-	    (msg->len == 64)) {
-		/* Hack to speed up firmware load.  The xc5000 lets us do up
-		   to 400 KHz when in firmware download mode */
-		au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
-			     AU0828_I2C_CLK_250KHZ);
-	} else {
-		/* Use the i2c clock speed in the board configuration */
-		au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
-			     dev->board.i2c_clk_divider);
+	    (dev->board.tuner_addr == msg->addr)) {
+		/*
+		 * Due to I2C clock stretch, we need to use a lower speed
+		 * on xc5000 for commands. However, firmware transfer can
+		 * speed up to 400 KHz.
+		 */
+		if (msg->len == 64)
+			i2c_speed = AU0828_I2C_CLK_250KHZ;
+		else
+			i2c_speed = AU0828_I2C_CLK_20KHZ;
 	}
+	au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202, i2c_speed);
 
 	/* Hardware needs 8 bit addresses */
 	au0828_write(dev, AU0828_I2C_DEST_ADDR_203, msg->addr << 1);
-- 
1.9.3

