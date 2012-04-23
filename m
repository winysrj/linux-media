Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab2DWOCt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 10:02:49 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv2] as3645a: move relevant code under __devinit/__devexit
Date: Mon, 23 Apr 2012 17:02:42 +0300
Message-Id: <1335189762-4991-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1578696.ouKf8xKIQt@avalon>
References: <1578696.ouKf8xKIQt@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no needs to keep .remove under .exit.text. This driver is for a
standalone chip that could be on any board and connected to any i2c bus.

At the same time we don't need to keep the as3645a_probe() after initializing
the device. Therefore we mark it and relevant functions with __devinit tag.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/as3645a.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index 7a3371f..c4b0357 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -713,7 +713,7 @@ static int as3645a_resume(struct device *dev)
  * The number of LEDs reported in platform data is used to compute default
  * limits. Parameters passed through platform data can override those limits.
  */
-static int as3645a_init_controls(struct as3645a *flash)
+static int __devinit as3645a_init_controls(struct as3645a *flash)
 {
 	const struct as3645a_platform_data *pdata = flash->pdata;
 	struct v4l2_ctrl *ctrl;
@@ -804,8 +804,8 @@ static int as3645a_init_controls(struct as3645a *flash)
 	return flash->ctrls.error;
 }
 
-static int as3645a_probe(struct i2c_client *client,
-			 const struct i2c_device_id *devid)
+static int __devinit as3645a_probe(struct i2c_client *client,
+				   const struct i2c_device_id *devid)
 {
 	struct as3645a *flash;
 	int ret;
@@ -846,7 +846,7 @@ done:
 	return ret;
 }
 
-static int __exit as3645a_remove(struct i2c_client *client)
+static int __devexit as3645a_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct as3645a *flash = to_as3645a(subdev);
@@ -877,7 +877,7 @@ static struct i2c_driver as3645a_i2c_driver = {
 		.pm   = &as3645a_pm_ops,
 	},
 	.probe	= as3645a_probe,
-	.remove	= __exit_p(as3645a_remove),
+	.remove	= __devexit_p(as3645a_remove),
 	.id_table = as3645a_id_table,
 };
 
-- 
1.7.9.1

