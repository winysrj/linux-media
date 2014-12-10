Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40805 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933214AbaLJVQi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 16:16:38 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id D230F6009C
	for <linux-media@vger.kernel.org>; Wed, 10 Dec 2014 23:16:34 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 3/7] smiapp: Clean up smiapp_init_controls()
Date: Wed, 10 Dec 2014 23:16:16 +0200
Message-Id: <1418246180-667-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
References: <1418246180-667-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clean up smiapp_init_controls() by adding newlines to appropriate places and
by removing superfluous error handling. The caller will clean up control
handlers in any case if the function fails.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 72a0de6..66d94c3 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -527,6 +527,7 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 12);
 	if (rval)
 		return rval;
+
 	sensor->pixel_array->ctrl_handler.lock = &sensor->mutex;
 
 	sensor->analog_gain = v4l2_ctrl_new_std(
@@ -585,8 +586,7 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 		dev_err(&client->dev,
 			"pixel array controls initialization failed (%d)\n",
 			sensor->pixel_array->ctrl_handler.error);
-		rval = sensor->pixel_array->ctrl_handler.error;
-		goto error;
+		return sensor->pixel_array->ctrl_handler.error;
 	}
 
 	sensor->pixel_array->sd.ctrl_handler =
@@ -596,7 +596,8 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 
 	rval = v4l2_ctrl_handler_init(&sensor->src->ctrl_handler, 0);
 	if (rval)
-		goto error;
+		return rval;
+
 	sensor->src->ctrl_handler.lock = &sensor->mutex;
 
 	for (max = 0; sensor->platform_data->op_sys_clock[max + 1]; max++);
@@ -614,20 +615,12 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 		dev_err(&client->dev,
 			"src controls initialization failed (%d)\n",
 			sensor->src->ctrl_handler.error);
-		rval = sensor->src->ctrl_handler.error;
-		goto error;
+		return sensor->src->ctrl_handler.error;
 	}
 
-	sensor->src->sd.ctrl_handler =
-		&sensor->src->ctrl_handler;
+	sensor->src->sd.ctrl_handler = &sensor->src->ctrl_handler;
 
 	return 0;
-
-error:
-	v4l2_ctrl_handler_free(&sensor->pixel_array->ctrl_handler);
-	v4l2_ctrl_handler_free(&sensor->src->ctrl_handler);
-
-	return rval;
 }
 
 static void smiapp_free_controls(struct smiapp_sensor *sensor)
-- 
1.7.10.4

