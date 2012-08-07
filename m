Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab2HGCsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:48:01 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:48:00 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 14/24] au0828: speed up i2c clock when doing xc5000 firmware load
Date: Mon,  6 Aug 2012 22:47:04 -0400
Message-Id: <1344307634-11673-15-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put a hack in place to speed up the firmware load in the case that the
xc5000 has just been reset.  The chip can safely do 400 KHz in this mode,
while in normal operation it can only do 100 KHz.

This reduces the firmware load time from 6.9 seconds to 4.2.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-i2c.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-i2c.c b/drivers/media/video/au0828/au0828-i2c.c
index 05c299f..d454555 100644
--- a/drivers/media/video/au0828/au0828-i2c.c
+++ b/drivers/media/video/au0828/au0828-i2c.c
@@ -26,7 +26,7 @@
 #include <linux/io.h>
 
 #include "au0828.h"
-
+#include "media/tuner.h"
 #include <media/v4l2-common.h>
 
 static int i2c_scan;
@@ -147,8 +147,18 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 	au0828_write(dev, AU0828_I2C_MULTIBYTE_MODE_2FF, 0x01);
 
 	/* Set the I2C clock */
-	au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
-		     dev->board.i2c_clk_divider);
+	if ((dev->board.tuner_type == TUNER_XC5000) &&
+	    (dev->board.tuner_addr == msg->addr) &&
+	    (msg->len == 64)) {
+		/* Hack to speed up firmware load.  The xc5000 lets us do up
+		   to 400 KHz when in firmware download mode */
+		au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
+			     AU0828_I2C_CLK_250KHZ);
+	} else {
+		/* Use the i2c clock speed in the board configuration */
+		au0828_write(dev, AU0828_I2C_CLK_DIVIDER_202,
+			     dev->board.i2c_clk_divider);
+	}
 
 	/* Hardware needs 8 bit addresses */
 	au0828_write(dev, AU0828_I2C_DEST_ADDR_203, msg->addr << 1);
-- 
1.7.1

