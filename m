Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab1KORuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:11 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 7/9] as3645a: use struct dev_pm_ops
Date: Tue, 15 Nov 2011 19:49:59 +0200
Message-Id: <5ecd481727e221aa7526b5580a727637a305496e.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/as3645a.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index 9aebaa2..774f797 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -646,8 +646,9 @@ static const struct v4l2_subdev_internal_ops as3645a_internal_ops = {
  */
 #ifdef CONFIG_PM
 
-static int as3645a_suspend(struct i2c_client *client, pm_message_t mesg)
+static int as3645a_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct as3645a *flash = to_as3645a(subdev);
 	int rval;
@@ -662,8 +663,9 @@ static int as3645a_suspend(struct i2c_client *client, pm_message_t mesg)
 	return rval;
 }
 
-static int as3645a_resume(struct i2c_client *client)
+static int as3645a_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct as3645a *flash = to_as3645a(subdev);
 	int rval;
@@ -841,14 +843,18 @@ static const struct i2c_device_id as3645a_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, as3645a_id_table);
 
+static const struct dev_pm_ops as3645a_pm_ops = {
+	.suspend = as3645a_suspend,
+	.resume = as3645a_resume,
+};
+
 static struct i2c_driver as3645a_i2c_driver = {
 	.driver	= {
 		.name = AS3645A_NAME,
+		.pm   = &as3645a_pm_ops,
 	},
 	.probe	= as3645a_probe,
 	.remove	= __exit_p(as3645a_remove),
-	.suspend = as3645a_suspend,
-	.resume = as3645a_resume,
 	.id_table = as3645a_id_table,
 };
 
-- 
1.7.7.1

