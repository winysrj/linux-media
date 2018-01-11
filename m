Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34864 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753757AbeAKKTS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 05:19:18 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: arnd@arndb.de
Subject: [PATCH v2 1/1] media: entity: Add a nop variant of media_entity_cleanup
Date: Thu, 11 Jan 2018 12:19:15 +0200
Message-Id: <20180111101915.10985-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add nop variant of media_entity_cleanup. This allows calling
media_entity_cleanup whether or not Media controller is enabled,
simplifying driver code.

Also drop #ifdefs on a few drivers around media_entity_cleanup().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1:

- Remove "r" at the end of the subject line

 drivers/media/i2c/mt9m111.c  | 2 --
 drivers/media/i2c/ov2640.c   | 4 ----
 drivers/media/i2c/ov2659.c   | 4 ----
 drivers/media/i2c/ov7670.c   | 4 ----
 drivers/media/i2c/ov7740.c   | 2 --
 drivers/media/i2c/tvp514x.c  | 4 ----
 include/media/media-entity.h | 6 +++++-
 7 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index d74f254db661..efda1aa95ca0 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -1046,9 +1046,7 @@ static int mt9m111_remove(struct i2c_client *client)
 	struct mt9m111 *mt9m111 = to_mt9m111(client);
 
 	v4l2_async_unregister_subdev(&mt9m111->subdev);
-#ifdef CONFIG_MEDIA_CONTROLLER
 	media_entity_cleanup(&mt9m111->subdev.entity);
-#endif
 	v4l2_clk_put(mt9m111->clk);
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 
diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 518868388d65..4c3b92763243 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -1147,9 +1147,7 @@ static int ov2640_probe(struct i2c_client *client,
 	return 0;
 
 err_videoprobe:
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&priv->subdev.entity);
-#endif
 err_hdl:
 	v4l2_ctrl_handler_free(&priv->hdl);
 err_clk:
@@ -1163,9 +1161,7 @@ static int ov2640_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&priv->subdev.entity);
-#endif
 	v4l2_device_unregister_subdev(&priv->subdev);
 	clk_disable_unprepare(priv->clk);
 	return 0;
diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 122dd6c5eb38..4715edc8ca33 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1474,9 +1474,7 @@ static int ov2659_probe(struct i2c_client *client,
 
 error:
 	v4l2_ctrl_handler_free(&ov2659->ctrls);
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&sd->entity);
-#endif
 	mutex_destroy(&ov2659->lock);
 	return ret;
 }
@@ -1488,9 +1486,7 @@ static int ov2659_remove(struct i2c_client *client)
 
 	v4l2_ctrl_handler_free(&ov2659->ctrls);
 	v4l2_async_unregister_subdev(sd);
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&sd->entity);
-#endif
 	mutex_destroy(&ov2659->lock);
 
 	return 0;
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index fd229bc8a0e5..28571de1c2f6 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1846,9 +1846,7 @@ static int ov7670_probe(struct i2c_client *client,
 	return 0;
 
 entity_cleanup:
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&info->sd.entity);
-#endif
 hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
 power_off:
@@ -1867,9 +1865,7 @@ static int ov7670_remove(struct i2c_client *client)
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
 	clk_disable_unprepare(info->clk);
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&info->sd.entity);
-#endif
 	ov7670_s_power(sd, 0);
 	return 0;
 }
diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 0308ba437bbb..576ce0640297 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1148,9 +1148,7 @@ static int ov7740_remove(struct i2c_client *client)
 
 	mutex_destroy(&ov7740->mutex);
 	v4l2_ctrl_handler_free(ov7740->subdev.ctrl_handler);
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&ov7740->subdev.entity);
-#endif
 	v4l2_async_unregister_subdev(sd);
 	ov7740_free_controls(ov7740);
 
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index d575b3e7e835..8b0aa9297bde 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1131,9 +1131,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 done:
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&decoder->hdl);
-#if defined(CONFIG_MEDIA_CONTROLLER)
 		media_entity_cleanup(&decoder->sd.entity);
-#endif
 	}
 	return ret;
 }
@@ -1151,9 +1149,7 @@ static int tvp514x_remove(struct i2c_client *client)
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
 	v4l2_async_unregister_subdev(&decoder->sd);
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&decoder->sd.entity);
-#endif
 	v4l2_ctrl_handler_free(&decoder->hdl);
 	return 0;
 }
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index d7a669058b5e..a732af1dbba0 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -634,7 +634,11 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
  * This function must be called during the cleanup phase after unregistering
  * the entity (currently, it does nothing).
  */
-static inline void media_entity_cleanup(struct media_entity *entity) {};
+#if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
+static inline void media_entity_cleanup(struct media_entity *entity) {}
+#else
+#define media_entity_cleanup(entity) do { } while (false)
+#endif
 
 /**
  * media_create_pad_link() - creates a link between two entities.
-- 
2.11.0
