Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44088 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752851AbcKSWYf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 17:24:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: arnd@arndb.de
Subject: [PATCH v2 2/2] smiapp: Make suspend and resume functions __maybe_unused
Date: Sun, 20 Nov 2016 00:24:26 +0200
Message-Id: <1479594266-3034-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1479594266-3034-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1479594266-3034-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The smiapp_suspend() and smiapp_resume() functions will end up being unused
if CONFIG_PM is enabled but CONFIG_PM_SLEEP is disabled, causing a
compiler warning from both of the function definitions. Fix this by
marking the functions with __maybe_unused.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index b20886f..ab48a85 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2741,7 +2741,7 @@ static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
  * I2C Driver
  */
 
-static int smiapp_suspend(struct device *dev)
+static int __maybe_unused smiapp_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -2766,7 +2766,7 @@ static int smiapp_suspend(struct device *dev)
 	return 0;
 }
 
-static int smiapp_resume(struct device *dev)
+static int __maybe_unused smiapp_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
-- 
2.1.4

