Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43341 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbeJTWh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 18:37:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id 30-v6so17102067plb.10
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 07:26:47 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v4 2/6] media: video-i2c: use i2c regmap
Date: Sat, 20 Oct 2018 23:26:24 +0900
Message-Id: <1540045588-9091-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use regmap for i2c register access.  This simplifies register accesses and
chooses suitable access commands based on the functionality that the
adapter supports.

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v4
- No changes from v3

 drivers/media/i2c/video-i2c.c | 68 ++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 27 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index f27d294..f23cb91 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of_device.h>
+#include <linux/regmap.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
@@ -38,7 +39,7 @@ struct video_i2c_buffer {
 };
 
 struct video_i2c_data {
-	struct i2c_client *client;
+	struct regmap *regmap;
 	const struct video_i2c_chip *chip;
 	struct mutex lock;
 	spinlock_t slock;
@@ -62,6 +63,12 @@ static const struct v4l2_frmsize_discrete amg88xx_size = {
 	.height = 8,
 };
 
+static const struct regmap_config amg88xx_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = 0xff
+};
+
 struct video_i2c_chip {
 	/* video dimensions */
 	const struct v4l2_fmtdesc *format;
@@ -76,6 +83,8 @@ struct video_i2c_chip {
 	/* pixel size in bits */
 	unsigned int bpp;
 
+	const struct regmap_config *regmap_config;
+
 	/* xfer function */
 	int (*xfer)(struct video_i2c_data *data, char *buf);
 
@@ -83,26 +92,16 @@ struct video_i2c_chip {
 	int (*hwmon_init)(struct video_i2c_data *data);
 };
 
-static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
-{
-	struct i2c_client *client = data->client;
-	struct i2c_msg msg[2];
-	u8 reg = 0x80;
-	int ret;
-
-	msg[0].addr = client->addr;
-	msg[0].flags = 0;
-	msg[0].len = 1;
-	msg[0].buf  = (char *)&reg;
+/* Thermistor register */
+#define AMG88XX_REG_TTHL	0x0e
 
-	msg[1].addr = client->addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].len = data->chip->buffer_size;
-	msg[1].buf = (char *)buf;
+/* Temperature register */
+#define AMG88XX_REG_T01L	0x80
 
-	ret = i2c_transfer(client->adapter, msg, 2);
-
-	return (ret == 2) ? 0 : -EIO;
+static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
+{
+	return regmap_bulk_read(data->regmap, AMG88XX_REG_T01L, buf,
+				data->chip->buffer_size);
 }
 
 #if IS_ENABLED(CONFIG_HWMON)
@@ -133,12 +132,15 @@ static int amg88xx_read(struct device *dev, enum hwmon_sensor_types type,
 			u32 attr, int channel, long *val)
 {
 	struct video_i2c_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
-	int tmp = i2c_smbus_read_word_data(client, 0x0e);
+	__le16 buf;
+	int tmp;
 
-	if (tmp < 0)
+	tmp = regmap_bulk_read(data->regmap, AMG88XX_REG_TTHL, &buf, 2);
+	if (tmp)
 		return tmp;
 
+	tmp = le16_to_cpu(buf);
+
 	/*
 	 * Check for sign bit, this isn't a two's complement value but an
 	 * absolute temperature that needs to be inverted in the case of being
@@ -164,8 +166,9 @@ static const struct hwmon_chip_info amg88xx_chip_info = {
 
 static int amg88xx_hwmon_init(struct video_i2c_data *data)
 {
-	void *hwmon = devm_hwmon_device_register_with_info(&data->client->dev,
-				"amg88xx", data, &amg88xx_chip_info, NULL);
+	struct device *dev = regmap_get_device(data->regmap);
+	void *hwmon = devm_hwmon_device_register_with_info(dev, "amg88xx", data,
+						&amg88xx_chip_info, NULL);
 
 	return PTR_ERR_OR_ZERO(hwmon);
 }
@@ -182,6 +185,7 @@ static const struct video_i2c_chip video_i2c_chip[] = {
 		.max_fps	= 10,
 		.buffer_size	= 128,
 		.bpp		= 16,
+		.regmap_config	= &amg88xx_regmap_config,
 		.xfer		= &amg88xx_xfer,
 		.hwmon_init	= amg88xx_hwmon_init,
 	},
@@ -350,7 +354,8 @@ static int video_i2c_querycap(struct file *file, void  *priv,
 				struct v4l2_capability *vcap)
 {
 	struct video_i2c_data *data = video_drvdata(file);
-	struct i2c_client *client = data->client;
+	struct device *dev = regmap_get_device(data->regmap);
+	struct i2c_client *client = to_i2c_client(dev);
 
 	strlcpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, data->vdev.name, sizeof(vcap->card));
@@ -515,6 +520,7 @@ static void video_i2c_release(struct video_device *vdev)
 	v4l2_device_unregister(&data->v4l2_dev);
 	mutex_destroy(&data->lock);
 	mutex_destroy(&data->queue_lock);
+	regmap_exit(data->regmap);
 	kfree(data);
 }
 
@@ -537,13 +543,18 @@ static int video_i2c_probe(struct i2c_client *client,
 	else
 		goto error_free_device;
 
-	data->client = client;
+	data->regmap = regmap_init_i2c(client, data->chip->regmap_config);
+	if (IS_ERR(data->regmap)) {
+		ret = PTR_ERR(data->regmap);
+		goto error_free_device;
+	}
+
 	v4l2_dev = &data->v4l2_dev;
 	strlcpy(v4l2_dev->name, VIDEO_I2C_DRIVER, sizeof(v4l2_dev->name));
 
 	ret = v4l2_device_register(&client->dev, v4l2_dev);
 	if (ret < 0)
-		goto error_free_device;
+		goto error_regmap_exit;
 
 	mutex_init(&data->lock);
 	mutex_init(&data->queue_lock);
@@ -602,6 +613,9 @@ static int video_i2c_probe(struct i2c_client *client,
 	mutex_destroy(&data->lock);
 	mutex_destroy(&data->queue_lock);
 
+error_regmap_exit:
+	regmap_exit(data->regmap);
+
 error_free_device:
 	kfree(data);
 
-- 
2.7.4
