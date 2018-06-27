Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:38953 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeF0ETE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 00:19:04 -0400
Received: by mail-pl0-f68.google.com with SMTP id s24-v6so395780plq.6
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2018 21:19:03 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        linux-hwmon@vger.kernel.org
Subject: [PATCH v2] media: video-i2c: add hwmon support for amg88xx
Date: Tue, 26 Jun 2018 21:18:58 -0700
Message-Id: <20180627041858.22186-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AMG88xx has an on-board thermistor which is used for more accurate
processing of its temperature readings from the 8x8 thermopile array

Cc: linux-hwmon@vger.kernel.org
Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
---
 drivers/media/i2c/video-i2c.c | 77 +++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

Changes from v1:
* remove unneeded include statement
* removed evil &NULL dereference if hwmon isn't enabled
* return PTR_ERR instead of boolean IS_ERR from amg88xx_hwmon_init()
* use error code returned from hwmon_init() to display dev_warn

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 0b347cc19aa5..834cd4401e38 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -10,6 +10,7 @@
 
 #include <linux/delay.h>
 #include <linux/freezer.h>
+#include <linux/hwmon.h>
 #include <linux/kthread.h>
 #include <linux/i2c.h>
 #include <linux/list.h>
@@ -77,6 +78,9 @@ struct video_i2c_chip {
 
 	/* xfer function */
 	int (*xfer)(struct video_i2c_data *data, char *buf);
+
+	/* hwmon init function */
+	int (*hwmon_init)(struct video_i2c_data *data);
 };
 
 static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
@@ -101,6 +105,70 @@ static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
 	return (ret == 2) ? 0 : -EIO;
 }
 
+#if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
+
+static const u32 amg88xx_temp_config[] = {
+	HWMON_T_INPUT,
+	0
+};
+
+static const struct hwmon_channel_info amg88xx_temp = {
+	.type = hwmon_temp,
+	.config = amg88xx_temp_config,
+};
+
+static const struct hwmon_channel_info *amg88xx_info[] = {
+	&amg88xx_temp,
+	NULL
+};
+
+static umode_t amg88xx_is_visible(const void *drvdata,
+				  enum hwmon_sensor_types type,
+				  u32 attr, int channel)
+{
+	return 0444;
+}
+
+static int amg88xx_read(struct device *dev, enum hwmon_sensor_types type,
+			u32 attr, int channel, long *val)
+{
+	struct video_i2c_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+	int tmp = i2c_smbus_read_word_data(client, 0x0e);
+
+	if (tmp < 0)
+		return tmp;
+
+	/* check for sign bit, and invert temp reading to a negative value */
+	if (tmp & BIT(11))
+		tmp = -(tmp & 0x7ff);
+
+	*val = (tmp * 625) / 10;
+
+	return 0;
+}
+
+static const struct hwmon_ops amg88xx_hwmon_ops = {
+	.is_visible = amg88xx_is_visible,
+	.read = amg88xx_read,
+};
+
+static const struct hwmon_chip_info amg88xx_chip_info = {
+	.ops = &amg88xx_hwmon_ops,
+	.info = amg88xx_info,
+};
+
+static int amg88xx_hwmon_init(struct video_i2c_data *data)
+{
+	void *hwmon = devm_hwmon_device_register_with_info(&data->client->dev,
+				"amg88xx", data, &amg88xx_chip_info, NULL);
+
+	return PTR_ERR(hwmon);
+}
+#else
+#define	amg88xx_hwmon_init	NULL
+#endif
+
 #define AMG88XX		0
 
 static const struct video_i2c_chip video_i2c_chip[] = {
@@ -111,6 +179,7 @@ static const struct video_i2c_chip video_i2c_chip[] = {
 		.buffer_size	= 128,
 		.bpp		= 16,
 		.xfer		= &amg88xx_xfer,
+		.hwmon_init	= amg88xx_hwmon_init,
 	},
 };
 
@@ -505,6 +574,14 @@ static int video_i2c_probe(struct i2c_client *client,
 	video_set_drvdata(&data->vdev, data);
 	i2c_set_clientdata(client, data);
 
+	if (data->chip->hwmon_init) {
+		ret = data->chip->hwmon_init(data);
+		if (ret < 0) {
+			dev_warn(&client->dev,
+				 "failed to register hwmon device\n");
+		}
+	}
+
 	ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
 		goto error_unregister_device;
-- 
2.17.1
