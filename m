Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:45274 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932699AbeGIPlh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 11:41:37 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH -next v3 2/2] media: ov772x: use SCCB helpers
Date: Tue, 10 Jul 2018 00:41:14 +0900
Message-Id: <1531150874-4595-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert ov772x register access to use SCCB helpers.

Cc: Peter Rosin <peda@axentia.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov772x.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 7158c31..8a9a9ca 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -17,7 +17,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
-#include <linux/i2c.h>
+#include <linux/i2c-sccb.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -551,22 +551,12 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
 
 static int ov772x_read(struct i2c_client *client, u8 addr)
 {
-	int ret;
-	u8 val;
-
-	ret = i2c_master_send(client, &addr, 1);
-	if (ret < 0)
-		return ret;
-	ret = i2c_master_recv(client, &val, 1);
-	if (ret < 0)
-		return ret;
-
-	return val;
+	return sccb_read_byte(client, addr);
 }
 
 static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
 {
-	return i2c_smbus_write_byte_data(client, addr, value);
+	return sccb_write_byte(client, addr, value);
 }
 
 static int ov772x_mask_set(struct i2c_client *client, u8  command, u8  mask,
@@ -1395,9 +1385,9 @@ static int ov772x_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+	if (!sccb_is_available(adapter)) {
 		dev_err(&adapter->dev,
-			"I2C-Adapter doesn't support SMBUS_BYTE_DATA\n");
+			"I2C-Adapter doesn't support SCCB\n");
 		return -EIO;
 	}
 
-- 
2.7.4
