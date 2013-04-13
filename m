Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-233.synserver.de ([212.40.185.233]:1533 "EHLO
	smtp-out-233.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3DMJcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 05:32:00 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Federico Vaga <federico.vaga@gmail.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>, linux-media@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] media:adv7180: Use dev_pm_ops
Date: Sat, 13 Apr 2013 11:25:59 +0200
Message-Id: <1365845159-12739-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 34f39d3..3d75423 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -612,9 +612,10 @@ static const struct i2c_device_id adv7180_id[] = {
 	{},
 };
 
-#ifdef CONFIG_PM
-static int adv7180_suspend(struct i2c_client *client, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int adv7180_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	int ret;
 
 	ret = i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG,
@@ -624,8 +625,9 @@ static int adv7180_suspend(struct i2c_client *client, pm_message_t state)
 	return 0;
 }
 
-static int adv7180_resume(struct i2c_client *client)
+static int adv7180_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7180_state *state = to_state(sd);
 	int ret;
@@ -639,6 +641,12 @@ static int adv7180_resume(struct i2c_client *client)
 		return ret;
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
+#define ADV7180_PM_OPS (&adv7180_pm_ops)
+
+#else
+#define ADV7180_PM_OPS NULL
 #endif
 
 MODULE_DEVICE_TABLE(i2c, adv7180_id);
@@ -647,13 +655,10 @@ static struct i2c_driver adv7180_driver = {
 	.driver = {
 		   .owner = THIS_MODULE,
 		   .name = KBUILD_MODNAME,
+		   .pm = ADV7180_PM_OPS,
 		   },
 	.probe = adv7180_probe,
 	.remove = adv7180_remove,
-#ifdef CONFIG_PM
-	.suspend = adv7180_suspend,
-	.resume = adv7180_resume,
-#endif
 	.id_table = adv7180_id,
 };
 
-- 
1.8.0

