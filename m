Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:41040 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753813AbdKXWEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 17:04:46 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] [media] v4l: mt9v032: Disable clock on error paths
Date: Sat, 25 Nov 2017 01:04:37 +0300
Message-Id: <1511561077-25192-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mt9v032_power_on() leaves clk enabled in case of errors,
but it is not expected by its callers.
There is a similar problem in mt9v032_registered().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/i2c/mt9v032.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 8a430640c85d..4de63b2df334 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -294,14 +294,22 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
 	/* Reset the chip and stop data read out */
 	ret = regmap_write(map, MT9V032_RESET, 1);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	ret = regmap_write(map, MT9V032_RESET, 0);
 	if (ret < 0)
-		return ret;
+		goto err;
+
+	ret = regmap_write(map, MT9V032_CHIP_CONTROL,
+			   MT9V032_CHIP_CONTROL_MASTER_MODE);
+	if (ret < 0)
+		goto err;
+
+	return 0;
 
-	return regmap_write(map, MT9V032_CHIP_CONTROL,
-			    MT9V032_CHIP_CONTROL_MASTER_MODE);
+err:
+	clk_disable_unprepare(mt9v032->clk);
+	return ret;
 }
 
 static void mt9v032_power_off(struct mt9v032 *mt9v032)
@@ -876,6 +884,9 @@ static int mt9v032_registered(struct v4l2_subdev *subdev)
 
 	/* Read and check the sensor version */
 	ret = regmap_read(mt9v032->regmap, MT9V032_CHIP_VERSION, &version);
+
+	mt9v032_power_off(mt9v032);
+
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed reading chip version\n");
 		return ret;
@@ -894,8 +905,6 @@ static int mt9v032_registered(struct v4l2_subdev *subdev)
 		return -ENODEV;
 	}
 
-	mt9v032_power_off(mt9v032);
-
 	dev_info(&client->dev, "%s detected at address 0x%02x\n",
 		 mt9v032->version->name, client->addr);
 
-- 
2.7.4
