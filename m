Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35316 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753329AbcISWDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 08/18] smiapp: Fix resource management in registration failure
Date: Tue, 20 Sep 2016 01:02:41 +0300
Message-Id: <1474322571-20290-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the registered() callback failed, resources were left unaccounted for.
Fix this, as well as add unregistering the sub-devices in driver
unregistered() callback.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 8a58c64..9d7af8b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2524,12 +2524,22 @@ static int smiapp_register_subdev(struct smiapp_sensor *sensor,
 	if (rval) {
 		dev_err(&client->dev,
 			"media_create_pad_link failed\n");
+		v4l2_device_unregister_subdev(&ssd->sd);
 		return rval;
 	}
 
 	return 0;
 }
 
+static void smiapp_unregistered(struct v4l2_subdev *subdev)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	unsigned int i;
+
+	for (i = 1; i < sensor->ssds_used; i++)
+		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
+}
+
 static int smiapp_registered(struct v4l2_subdev *subdev)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -2544,10 +2554,19 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 			return rval;
 	}
 
-	return smiapp_register_subdev(
+	rval = smiapp_register_subdev(
 		sensor, sensor->pixel_array, sensor->binner,
 		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
 		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (rval)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	smiapp_unregistered(subdev);
+
+	return rval;
 }
 
 static void smiapp_cleanup(struct smiapp_sensor *sensor)
@@ -2894,6 +2913,7 @@ static const struct media_entity_operations smiapp_entity_ops = {
 
 static const struct v4l2_subdev_internal_ops smiapp_internal_src_ops = {
 	.registered = smiapp_registered,
+	.unregistered = smiapp_unregistered,
 	.open = smiapp_open,
 	.close = smiapp_close,
 };
-- 
2.1.4

