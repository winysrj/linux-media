Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49326 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab2ECKyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 06:54:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] [media] Convert I2C drivers to dev_pm_ops
Date: Thu,  3 May 2012 11:54:51 +0100
Message-Id: <1336042491-28403-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The legacy I2C PM functions have been deprecated and warning on boot
for over a year, convert the drivers still using them to dev_pm_ops.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/media/video/msp3400-driver.c |   15 +++++++++++----
 drivers/media/video/tuner-core.c     |   15 +++++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
index 82ce507..aeb22be 100644
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -597,19 +597,23 @@ static int msp_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int msp_suspend(struct i2c_client *client, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int msp_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	v4l_dbg(1, msp_debug, client, "suspend\n");
 	msp_reset(client);
 	return 0;
 }
 
-static int msp_resume(struct i2c_client *client)
+static int msp_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	v4l_dbg(1, msp_debug, client, "resume\n");
 	msp_wake_thread(client);
 	return 0;
 }
+#endif
 
 /* ----------------------------------------------------------------------- */
 
@@ -863,6 +867,10 @@ static int msp_remove(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct dev_pm_ops msp3400_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(msp_suspend, msp_resume)
+};
+
 static const struct i2c_device_id msp_id[] = {
 	{ "msp3400", 0 },
 	{ }
@@ -873,11 +881,10 @@ static struct i2c_driver msp_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= "msp3400",
+		.pm	= &msp3400_pm_ops,
 	},
 	.probe		= msp_probe,
 	.remove		= msp_remove,
-	.suspend	= msp_suspend,
-	.resume		= msp_resume,
 	.id_table	= msp_id,
 };
 
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index a5c6397..3e050e1 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1241,8 +1241,10 @@ static int tuner_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int tuner_suspend(struct i2c_client *c, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int tuner_suspend(struct device *dev)
 {
+	struct i2c_client *c = to_i2c_client(dev);
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
@@ -1254,8 +1256,9 @@ static int tuner_suspend(struct i2c_client *c, pm_message_t state)
 	return 0;
 }
 
-static int tuner_resume(struct i2c_client *c)
+static int tuner_resume(struct device *dev)
 {
+	struct i2c_client *c = to_i2c_client(dev);
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 
 	tuner_dbg("resume\n");
@@ -1266,6 +1269,7 @@ static int tuner_resume(struct i2c_client *c)
 
 	return 0;
 }
+#endif
 
 static int tuner_command(struct i2c_client *client, unsigned cmd, void *arg)
 {
@@ -1310,6 +1314,10 @@ static const struct v4l2_subdev_ops tuner_ops = {
  * I2C structs and module init functions
  */
 
+static const struct dev_pm_ops tuner_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(tuner_suspend, tuner_resume)
+};
+
 static const struct i2c_device_id tuner_id[] = {
 	{ "tuner", }, /* autodetect */
 	{ }
@@ -1320,12 +1328,11 @@ static struct i2c_driver tuner_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= "tuner",
+		.pm	= &tuner_pm_ops,
 	},
 	.probe		= tuner_probe,
 	.remove		= tuner_remove,
 	.command	= tuner_command,
-	.suspend	= tuner_suspend,
-	.resume		= tuner_resume,
 	.id_table	= tuner_id,
 };
 
-- 
1.7.10

