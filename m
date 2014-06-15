Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:20644 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaFOURj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 16:17:39 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/2] media: mt9m111: add device-tree suppport
Date: Sun, 15 Jun 2014 22:17:31 +0200
Message-Id: <1402863452-30365-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree support for mt9m111 camera sensor.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/i2c/soc_camera/mt9m111.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index ccf5940..7d283ea 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -923,6 +923,12 @@ done:
 	return ret;
 }
 
+static int of_get_mt9m111_platform_data(struct device *dev,
+					struct soc_camera_subdev_desc *desc)
+{
+	return 0;
+}
+
 static int mt9m111_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
@@ -931,6 +937,15 @@ static int mt9m111_probe(struct i2c_client *client,
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
+	if (client->dev.of_node) {
+		ssdd = devm_kzalloc(&client->dev, sizeof(*ssdd), GFP_KERNEL);
+		if (!ssdd)
+			return -ENOMEM;
+		client->dev.platform_data = ssdd;
+		ret = of_get_mt9m111_platform_data(&client->dev, ssdd);
+		if (ret < 0)
+			return ret;
+	}
 	if (!ssdd) {
 		dev_err(&client->dev, "mt9m111: driver needs platform data\n");
 		return -EINVAL;
@@ -1015,6 +1030,11 @@ static int mt9m111_remove(struct i2c_client *client)
 
 	return 0;
 }
+static const struct of_device_id mt9m111_of_match[] = {
+	{ .compatible = "micron,mt9m111", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, mt9m111_of_match);
 
 static const struct i2c_device_id mt9m111_id[] = {
 	{ "mt9m111", 0 },
@@ -1025,6 +1045,7 @@ MODULE_DEVICE_TABLE(i2c, mt9m111_id);
 static struct i2c_driver mt9m111_i2c_driver = {
 	.driver = {
 		.name = "mt9m111",
+		.of_match_table = of_match_ptr(mt9m111_of_match),
 	},
 	.probe		= mt9m111_probe,
 	.remove		= mt9m111_remove,
-- 
2.0.0.rc2

