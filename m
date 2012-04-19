Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19569 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab2DSNsR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 09:48:17 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] as3645a: move .remove under .devexit.text
Date: Thu, 19 Apr 2012 16:48:10 +0300
Message-Id: <1334843290-29668-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no needs to keep .remove under .exit.text. This driver is for a
standalone chip that could be on any board and connected to any i2c bus.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/as3645a.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index 7a3371f..dc2571f 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
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

