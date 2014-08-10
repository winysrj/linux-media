Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59153 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaHJJlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 05:41:55 -0400
Received: by mail-pa0-f50.google.com with SMTP id et14so9536610pad.9
        for <linux-media@vger.kernel.org>; Sun, 10 Aug 2014 02:41:55 -0700 (PDT)
Message-ID: <1407663709.6912.8.camel@phoenix>
Subject: [PATCH] [media] mt9v032: Remove duplicate test for
 I2C_FUNC_SMBUS_WORD_DATA functionality
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Date: Sun, 10 Aug 2014 17:41:49 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit b42261078a91 ("regmap: i2c: fallback to SMBus if the adapter
does not support standard I2C"), regmap-i2c will check the
I2C_FUNC_SMBUS_[BYTE|WORD]_DATA functionality based on the regmap_config
setting if the adapter does not support standard I2C.

So remove the I2C_FUNC_SMBUS_WORD_DATA functionality check in the driver code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/i2c/mt9v032.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index d044bce..f9e4bf7 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -879,13 +879,6 @@ static int mt9v032_probe(struct i2c_client *client,
 	unsigned int i;
 	int ret;
 
-	if (!i2c_check_functionality(client->adapter,
-				     I2C_FUNC_SMBUS_WORD_DATA)) {
-		dev_warn(&client->adapter->dev,
-			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
-		return -EIO;
-	}
-
 	mt9v032 = devm_kzalloc(&client->dev, sizeof(*mt9v032), GFP_KERNEL);
 	if (!mt9v032)
 		return -ENOMEM;
-- 
1.9.1



