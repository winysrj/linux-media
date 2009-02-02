Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:54949 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZBBWE6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 17:04:58 -0500
Received: by ey-out-2122.google.com with SMTP id 25so411540eya.37
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 14:04:56 -0800 (PST)
Message-ID: <49876E08.1050704@gmail.com>
Date: Mon, 02 Feb 2009 23:04:56 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: michael@mihu.de
CC: linux-media@vger.kernel.org
Subject: [PATCH] decrement address_err as well as retries.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we want to determine whether every retry we had an address_err,
and we decrement retries, we should decrement address_err as well.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index c11da4d..2fac001 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -293,7 +293,7 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 	int i = 0, count = 0;
 	__le32 *buffer = dev->d_i2c.cpu_addr;
 	int err = 0;
-	int address_err = 0;
+	int address_err = retries;
 	int short_delay = 0;
 
 	if (mutex_lock_interruptible(&dev->i2c_lock))
@@ -342,7 +342,7 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 					if( 0 != (SAA7146_USE_I2C_IRQ & dev->ext->flags)) {
 						goto out;
 					}
-					address_err++;
+					address_err--;
 				}
 				DEB_I2C(("error while sending message(s). starting again.\n"));
 				break;
