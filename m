Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51165
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1428891AbdDYJqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 05:46:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Frank Schaefer <fschaefer.oss@googlemail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] ov2640: print error if devm_*_optional*() fails
Date: Tue, 25 Apr 2017 06:45:48 -0300
Message-Id: <20df5459b3f27a642151703501f2bf803cc79c5a.1493113538.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_gpiod_get_optional() can return -ENOSYS if GPIOLIB is
disabled, causing probe to fail. Warn the user if this
happens.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov2640.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 4a2ae24f8722..e6d0c1f64f0b 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -765,17 +765,17 @@ static int ov2640_s_register(struct v4l2_subdev *sd,
 
 static int ov2640_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov2640_priv *priv = to_ov2640(client);
-
 #ifdef CONFIG_GPIOLIB
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct ov2640_priv *priv = to_ov2640(client);
+
 	if (priv->pwdn_gpio)
 		gpiod_direction_output(priv->pwdn_gpio, !on);
 	if (on && priv->resetb_gpio) {
 		/* Active the resetb pin to perform a reset pulse */
 		gpiod_direction_output(priv->resetb_gpio, 1);
 		usleep_range(3000, 5000);
-		gpiod_direction_output(priv->resetb_gpio, 0);
+		gpiod_set_value(priv->resetb_gpio, 0);
 	}
 #endif
 	return 0;
@@ -1048,21 +1048,35 @@ static const struct v4l2_subdev_ops ov2640_subdev_ops = {
 static int ov2640_probe_dt(struct i2c_client *client,
 		struct ov2640_priv *priv)
 {
+	int ret;
+
 	/* Request the reset GPIO deasserted */
 	priv->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
 			GPIOD_OUT_LOW);
+
 	if (!priv->resetb_gpio)
 		dev_dbg(&client->dev, "resetb gpio is not assigned!\n");
-	else if (IS_ERR(priv->resetb_gpio))
-		return PTR_ERR(priv->resetb_gpio);
+
+	ret = PTR_ERR_OR_ZERO(priv->resetb_gpio);
+	if (ret && ret != -ENOSYS) {
+		dev_dbg(&client->dev,
+			"Error %d while getting resetb gpio\n", ret);
+		return ret;
+	}
 
 	/* Request the power down GPIO asserted */
 	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
 			GPIOD_OUT_HIGH);
+
 	if (!priv->pwdn_gpio)
 		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");
-	else if (IS_ERR(priv->pwdn_gpio))
-		return PTR_ERR(priv->pwdn_gpio);
+
+	ret = PTR_ERR_OR_ZERO(priv->pwdn_gpio);
+	if (ret && ret != -ENOSYS) {
+		dev_dbg(&client->dev,
+			"Error %d while getting pwdn gpio\n", ret);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.9.3
