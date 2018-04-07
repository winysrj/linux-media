Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37448 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbeDGPsm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 11:48:42 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/6] media: ov772x: allow i2c controllers without I2C_FUNC_PROTOCOL_MANGLING
Date: Sun,  8 Apr 2018 00:48:05 +0900
Message-Id: <1523116090-13101-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver only works when the i2c controller have
I2C_FUNC_PROTOCOL_MANGLING.  However, many i2c controller drivers don't
support it.

The reason that the ov772x requires I2C_FUNC_PROTOCOL_MANGLING is that
it doesn't support repeated starts.

This change adds an alternative method for reading from ov772x register
which uses two separated i2c messages for the i2c controllers without
I2C_FUNC_PROTOCOL_MANGLING.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov772x.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index b62860c..283ae2c 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -424,6 +424,7 @@ struct ov772x_priv {
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
 	unsigned short                    band_filter;
 	unsigned int			  fps;
+	int (*reg_read)(struct i2c_client *client, u8 addr);
 };
 
 /*
@@ -542,11 +543,34 @@ static struct ov772x_priv *to_ov772x(struct v4l2_subdev *sd)
 	return container_of(sd, struct ov772x_priv, subdev);
 }
 
-static inline int ov772x_read(struct i2c_client *client, u8 addr)
+static int ov772x_read(struct i2c_client *client, u8 addr)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov772x_priv *priv = to_ov772x(sd);
+
+	return priv->reg_read(client, addr);
+}
+
+static int ov772x_reg_read(struct i2c_client *client, u8 addr)
 {
 	return i2c_smbus_read_byte_data(client, addr);
 }
 
+static int ov772x_reg_read_fallback(struct i2c_client *client, u8 addr)
+{
+	int ret;
+	u8 val;
+
+	ret = i2c_master_send(client, &addr, 1);
+	if (ret < 0)
+		return ret;
+	ret = i2c_master_recv(client, &val, 1);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
 static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
 {
 	return i2c_smbus_write_byte_data(client, addr, value);
@@ -1255,20 +1279,20 @@ static int ov772x_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
-					      I2C_FUNC_PROTOCOL_MANGLING)) {
-		dev_err(&adapter->dev,
-			"I2C-Adapter doesn't support SMBUS_BYTE_DATA or PROTOCOL_MANGLING\n");
-		return -EIO;
-	}
-	client->flags |= I2C_CLIENT_SCCB;
-
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->info = client->dev.platform_data;
 
+	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
+					     I2C_FUNC_PROTOCOL_MANGLING))
+		priv->reg_read = ov772x_reg_read;
+	else
+		priv->reg_read = ov772x_reg_read_fallback;
+
+	client->flags |= I2C_CLIENT_SCCB;
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
-- 
2.7.4
