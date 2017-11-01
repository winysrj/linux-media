Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38468 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754372AbdKAJn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 05:43:29 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: leonl@leopardimaging.com
Subject: [PATCH 1/1] imx274: Fix error handling, add MAINTAINERS entry
Date: Wed,  1 Nov 2017 11:43:27 +0200
Message-Id: <20171101094327.7702-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the missing MAINTAINERS entry for imx274, fix error handling in driver
probe and unregister the correct control handler in driver remove.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
The earlier version of the imx274 patchset got merged, this is the diff
between what was merged and what was intended.

 MAINTAINERS                | 8 ++++++++
 drivers/media/i2c/imx274.c | 5 ++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index adbf69306e9e..a50dc70ae30b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12494,6 +12494,14 @@ S:	Maintained
 F:	drivers/ssb/
 F:	include/linux/ssb/
 
+SONY IMX274 SENSOR DRIVER
+M:	Leon Luo <leonl@leopardimaging.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/imx274.c
+F:	Documentation/devicetree/bindings/media/i2c/imx274.txt
+
 SONY MEMORYSTICK CARD SUPPORT
 M:	Alex Dubov <oakad@yahoo.com>
 W:	http://tifmxx.berlios.de/
diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index ab6a5f31da74..737dbf59a0d2 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1770,8 +1770,7 @@ static int imx274_probe(struct i2c_client *client,
 	return 0;
 
 err_ctrls:
-	v4l2_async_unregister_subdev(sd);
-	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	v4l2_ctrl_handler_free(&imx274->ctrls.handler);
 err_me:
 	media_entity_cleanup(&sd->entity);
 err_regmap:
@@ -1788,7 +1787,7 @@ static int imx274_remove(struct i2c_client *client)
 	imx274_write_table(imx274, mode_table[IMX274_MODE_STOP_STREAM]);
 
 	v4l2_async_unregister_subdev(sd);
-	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	v4l2_ctrl_handler_free(&imx274->ctrls.handler);
 	media_entity_cleanup(&sd->entity);
 	mutex_destroy(&imx274->lock);
 	return 0;
-- 
2.11.0
