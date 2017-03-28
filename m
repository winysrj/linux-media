Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:50032 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754563AbdC1I2d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 04:28:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv6 13/14] ov2640: add MC support
Date: Tue, 28 Mar 2017 10:23:46 +0200
Message-Id: <20170328082347.11159-14-hverkuil@xs4all.nl>
In-Reply-To: <20170328082347.11159-1-hverkuil@xs4all.nl>
References: <20170328082347.11159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The MC support is needed by the em28xx driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov2640.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 0445963c5fae..e8875cc19e3d 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -282,6 +282,9 @@ struct ov2640_win_size {
 
 struct ov2640_priv {
 	struct v4l2_subdev		subdev;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad pad;
+#endif
 	struct v4l2_ctrl_handler	hdl;
 	u32	cfmt_code;
 	struct clk			*clk;
@@ -1063,6 +1066,7 @@ static int ov2640_probe(struct i2c_client *client,
 		goto err_clk;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
+	priv->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
 	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
@@ -1073,19 +1077,30 @@ static int ov2640_probe(struct i2c_client *client,
 		ret = priv->hdl.error;
 		goto err_hdl;
 	}
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
+	priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
+	if (ret < 0)
+		goto err_hdl;
+#endif
 
 	ret = ov2640_video_probe(client);
 	if (ret < 0)
-		goto err_hdl;
+		goto err_videoprobe;
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret < 0)
-		goto err_hdl;
+		goto err_videoprobe;
 
 	dev_info(&adapter->dev, "OV2640 Probed\n");
 
 	return 0;
 
+err_videoprobe:
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&priv->subdev.entity);
+#endif
 err_hdl:
 	v4l2_ctrl_handler_free(&priv->hdl);
 err_clk:
@@ -1099,6 +1114,9 @@ static int ov2640_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&priv->subdev.entity);
+#endif
 	v4l2_device_unregister_subdev(&priv->subdev);
 	clk_disable_unprepare(priv->clk);
 	return 0;
-- 
2.11.0
