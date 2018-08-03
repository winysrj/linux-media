Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45377 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732233AbeHCMgw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 08:36:52 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        dan.carpenter@oracle.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: [PATCH] media: i2c: mt9v111: Fix v4l2-ctrl error handling
Date: Fri,  3 Aug 2018 12:40:58 +0200
Message-Id: <1533292858-28022-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix error handling of v4l2_ctrl creation by inspecting the ctrl.error flag
instead of testing for each returned value correctness.

As reported by Dan Carpenter returning PTR_ERR() on the v4l2_ctrl_new_std()
return value is also wrong, as that function return NULL on error.

While at there re-order the cleanup path to respect the operation inverse
order.

Fixes: aab7ed1c "media: i2c: Add driver for Aptina MT9V111"
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/mt9v111.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
index da8f6ab..2b87bf9 100644
--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -1159,41 +1159,21 @@ static int mt9v111_probe(struct i2c_client *client)
 					      V4L2_CID_AUTO_WHITE_BALANCE,
 					      0, 1, 1,
 					      V4L2_WHITE_BALANCE_AUTO);
-	if (IS_ERR_OR_NULL(mt9v111->auto_awb)) {
-		ret = PTR_ERR(mt9v111->auto_awb);
-		goto error_free_ctrls;
-	}
-
 	mt9v111->auto_exp = v4l2_ctrl_new_std_menu(&mt9v111->ctrls,
 						   &mt9v111_ctrl_ops,
 						   V4L2_CID_EXPOSURE_AUTO,
 						   V4L2_EXPOSURE_MANUAL,
 						   0, V4L2_EXPOSURE_AUTO);
-	if (IS_ERR_OR_NULL(mt9v111->auto_exp)) {
-		ret = PTR_ERR(mt9v111->auto_exp);
-		goto error_free_ctrls;
-	}
-
-	/* Initialize timings */
 	mt9v111->hblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
 					    V4L2_CID_HBLANK,
 					    MT9V111_CORE_R05_MIN_HBLANK,
 					    MT9V111_CORE_R05_MAX_HBLANK, 1,
 					    MT9V111_CORE_R05_DEF_HBLANK);
-	if (IS_ERR_OR_NULL(mt9v111->hblank)) {
-		ret = PTR_ERR(mt9v111->hblank);
-		goto error_free_ctrls;
-	}
-
 	mt9v111->vblank = v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
 					    V4L2_CID_VBLANK,
 					    MT9V111_CORE_R06_MIN_VBLANK,
 					    MT9V111_CORE_R06_MAX_VBLANK, 1,
 					    MT9V111_CORE_R06_DEF_VBLANK);
-	if (IS_ERR_OR_NULL(mt9v111->vblank)) {
-		ret = PTR_ERR(mt9v111->vblank);
-		goto error_free_ctrls;
-	}

 	/* PIXEL_RATE is fixed: just expose it to user space. */
 	v4l2_ctrl_new_std(&mt9v111->ctrls, &mt9v111_ctrl_ops,
@@ -1201,6 +1181,10 @@ static int mt9v111_probe(struct i2c_client *client)
 			  DIV_ROUND_CLOSEST(mt9v111->sysclk, 2), 1,
 			  DIV_ROUND_CLOSEST(mt9v111->sysclk, 2));

+	if (mt9v111->ctrls.error) {
+		ret = mt9v111->ctrls.error;
+		goto error_free_ctrls;
+	}
 	mt9v111->sd.ctrl_handler = &mt9v111->ctrls;

 	/* Start with default configuration: 640x480 UYVY. */
@@ -1226,26 +1210,27 @@ static int mt9v111_probe(struct i2c_client *client)
 	mt9v111->pad.flags	= MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_pads_init(&mt9v111->sd.entity, 1, &mt9v111->pad);
 	if (ret)
-		goto error_free_ctrls;
+		goto error_free_entity;
 #endif

 	ret = mt9v111_chip_probe(mt9v111);
 	if (ret)
-		goto error_free_ctrls;
+		goto error_free_entity;

 	ret = v4l2_async_register_subdev(&mt9v111->sd);
 	if (ret)
-		goto error_free_ctrls;
+		goto error_free_entity;

 	return 0;

-error_free_ctrls:
-	v4l2_ctrl_handler_free(&mt9v111->ctrls);
-
+error_free_entity:
 #if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&mt9v111->sd.entity);
 #endif

+error_free_ctrls:
+	v4l2_ctrl_handler_free(&mt9v111->ctrls);
+
 	mutex_destroy(&mt9v111->pwr_mutex);
 	mutex_destroy(&mt9v111->stream_mutex);

@@ -1259,12 +1244,12 @@ static int mt9v111_remove(struct i2c_client *client)

 	v4l2_async_unregister_subdev(sd);

-	v4l2_ctrl_handler_free(&mt9v111->ctrls);
-
 #if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&sd->entity);
 #endif

+	v4l2_ctrl_handler_free(&mt9v111->ctrls);
+
 	mutex_destroy(&mt9v111->pwr_mutex);
 	mutex_destroy(&mt9v111->stream_mutex);

--
2.7.4
