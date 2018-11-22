Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42501 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730352AbeKWCyM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 21:54:12 -0500
Received: by mail-pg1-f195.google.com with SMTP id d72so1912307pga.9
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 08:14:10 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v5] media: video-i2c: support runtime PM
Date: Fri, 23 Nov 2018 01:13:56 +0900
Message-Id: <1542903236-20392-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AMG88xx has a register for setting operating mode.  This adds support
runtime PM by changing the operating mode.

The instruction for changing sleep mode to normal mode is from the
reference specifications.

https://docid81hrs3j1.cloudfront.net/medialibrary/2017/11/PANA-S-A0002141979-1.pdf

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Reviewed-by: Matt Ranostay <matt.ranostay@konsulko.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
This is an update of "[PATCH v4 6/6] media: video-i2c: support runtime PM"
in the patchset "[PATCH v4 0/6] media: video-i2c: support changing frame
interval and runtime PM".

* v5
- don't use msleep for 1ms - 20ms

 drivers/media/i2c/video-i2c.c | 141 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 139 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index dff218c..77080d7 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -94,10 +95,23 @@ struct video_i2c_chip {
 	/* xfer function */
 	int (*xfer)(struct video_i2c_data *data, char *buf);
 
+	/* power control function */
+	int (*set_power)(struct video_i2c_data *data, bool on);
+
 	/* hwmon init function */
 	int (*hwmon_init)(struct video_i2c_data *data);
 };
 
+/* Power control register */
+#define AMG88XX_REG_PCTL	0x00
+#define AMG88XX_PCTL_NORMAL		0x00
+#define AMG88XX_PCTL_SLEEP		0x10
+
+/* Reset register */
+#define AMG88XX_REG_RST		0x01
+#define AMG88XX_RST_FLAG		0x30
+#define AMG88XX_RST_INIT		0x3f
+
 /* Frame rate register */
 #define AMG88XX_REG_FPSC	0x02
 #define AMG88XX_FPSC_1FPS		BIT(0)
@@ -127,6 +141,59 @@ static int amg88xx_setup(struct video_i2c_data *data)
 	return regmap_update_bits(data->regmap, AMG88XX_REG_FPSC, mask, val);
 }
 
+static int amg88xx_set_power_on(struct video_i2c_data *data)
+{
+	int ret;
+
+	ret = regmap_write(data->regmap, AMG88XX_REG_PCTL, AMG88XX_PCTL_NORMAL);
+	if (ret)
+		return ret;
+
+	msleep(50);
+
+	ret = regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST_INIT);
+	if (ret)
+		return ret;
+
+	usleep_range(2000, 3000);
+
+	ret = regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST_FLAG);
+	if (ret)
+		return ret;
+
+	/*
+	 * Wait two frames before reading thermistor and temperature registers
+	 */
+	msleep(200);
+
+	return 0;
+}
+
+static int amg88xx_set_power_off(struct video_i2c_data *data)
+{
+	int ret;
+
+	ret = regmap_write(data->regmap, AMG88XX_REG_PCTL, AMG88XX_PCTL_SLEEP);
+	if (ret)
+		return ret;
+	/*
+	 * Wait for a while to avoid resuming normal mode immediately after
+	 * entering sleep mode, otherwise the device occasionally goes wrong
+	 * (thermistor and temperature registers are not updated at all)
+	 */
+	msleep(100);
+
+	return 0;
+}
+
+static int amg88xx_set_power(struct video_i2c_data *data, bool on)
+{
+	if (on)
+		return amg88xx_set_power_on(data);
+
+	return amg88xx_set_power_off(data);
+}
+
 #if IS_ENABLED(CONFIG_HWMON)
 
 static const u32 amg88xx_temp_config[] = {
@@ -158,7 +225,15 @@ static int amg88xx_read(struct device *dev, enum hwmon_sensor_types type,
 	__le16 buf;
 	int tmp;
 
+	tmp = pm_runtime_get_sync(regmap_get_device(data->regmap));
+	if (tmp < 0) {
+		pm_runtime_put_noidle(regmap_get_device(data->regmap));
+		return tmp;
+	}
+
 	tmp = regmap_bulk_read(data->regmap, AMG88XX_REG_TTHL, &buf, 2);
+	pm_runtime_mark_last_busy(regmap_get_device(data->regmap));
+	pm_runtime_put_autosuspend(regmap_get_device(data->regmap));
 	if (tmp)
 		return tmp;
 
@@ -217,6 +292,7 @@ static const struct video_i2c_chip video_i2c_chip[] = {
 		.regmap_config	= &amg88xx_regmap_config,
 		.setup		= &amg88xx_setup,
 		.xfer		= &amg88xx_xfer,
+		.set_power	= amg88xx_set_power,
 		.hwmon_init	= amg88xx_hwmon_init,
 	},
 };
@@ -343,14 +419,21 @@ static void video_i2c_del_list(struct vb2_queue *vq, enum vb2_buffer_state state
 static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct video_i2c_data *data = vb2_get_drv_priv(vq);
+	struct device *dev = regmap_get_device(data->regmap);
 	int ret;
 
 	if (data->kthread_vid_cap)
 		return 0;
 
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
+		goto error_del_list;
+	}
+
 	ret = data->chip->setup(data);
 	if (ret)
-		goto error_del_list;
+		goto error_rpm_put;
 
 	data->sequence = 0;
 	data->kthread_vid_cap = kthread_run(video_i2c_thread_vid_cap, data,
@@ -359,6 +442,9 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (!ret)
 		return 0;
 
+error_rpm_put:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 error_del_list:
 	video_i2c_del_list(vq, VB2_BUF_STATE_QUEUED);
 
@@ -374,6 +460,8 @@ static void stop_streaming(struct vb2_queue *vq)
 
 	kthread_stop(data->kthread_vid_cap);
 	data->kthread_vid_cap = NULL;
+	pm_runtime_mark_last_busy(regmap_get_device(data->regmap));
+	pm_runtime_put_autosuspend(regmap_get_device(data->regmap));
 
 	video_i2c_del_list(vq, VB2_BUF_STATE_ERROR);
 }
@@ -648,6 +736,16 @@ static int video_i2c_probe(struct i2c_client *client,
 	video_set_drvdata(&data->vdev, data);
 	i2c_set_clientdata(client, data);
 
+	ret = data->chip->set_power(data, true);
+	if (ret)
+		goto error_unregister_device;
+
+	pm_runtime_get_noresume(&client->dev);
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+	pm_runtime_set_autosuspend_delay(&client->dev, 2000);
+	pm_runtime_use_autosuspend(&client->dev);
+
 	if (data->chip->hwmon_init) {
 		ret = data->chip->hwmon_init(data);
 		if (ret < 0) {
@@ -658,10 +756,19 @@ static int video_i2c_probe(struct i2c_client *client,
 
 	ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
-		goto error_unregister_device;
+		goto error_pm_disable;
+
+	pm_runtime_mark_last_busy(&client->dev);
+	pm_runtime_put_autosuspend(&client->dev);
 
 	return 0;
 
+error_pm_disable:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+	data->chip->set_power(data, false);
+
 error_unregister_device:
 	v4l2_device_unregister(v4l2_dev);
 	mutex_destroy(&data->lock);
@@ -680,11 +787,40 @@ static int video_i2c_remove(struct i2c_client *client)
 {
 	struct video_i2c_data *data = i2c_get_clientdata(client);
 
+	pm_runtime_get_sync(&client->dev);
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+	data->chip->set_power(data, false);
+
 	video_unregister_device(&data->vdev);
 
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static int video_i2c_pm_runtime_suspend(struct device *dev)
+{
+	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
+
+	return data->chip->set_power(data, false);
+}
+
+static int video_i2c_pm_runtime_resume(struct device *dev)
+{
+	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
+
+	return data->chip->set_power(data, true);
+}
+
+#endif
+
+static const struct dev_pm_ops video_i2c_pm_ops = {
+	SET_RUNTIME_PM_OPS(video_i2c_pm_runtime_suspend,
+			   video_i2c_pm_runtime_resume, NULL)
+};
+
 static const struct i2c_device_id video_i2c_id_table[] = {
 	{ "amg88xx", AMG88XX },
 	{}
@@ -701,6 +837,7 @@ static struct i2c_driver video_i2c_driver = {
 	.driver = {
 		.name	= VIDEO_I2C_DRIVER,
 		.of_match_table = video_i2c_of_match,
+		.pm	= &video_i2c_pm_ops,
 	},
 	.probe		= video_i2c_probe,
 	.remove		= video_i2c_remove,
-- 
2.7.4
