Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48008 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753529AbdA3OJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 09:09:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 12/16] ov2640: add MC support
Date: Mon, 30 Jan 2017 15:06:24 +0100
Message-Id: <20170130140628.18088-13-hverkuil@xs4all.nl>
In-Reply-To: <20170130140628.18088-1-hverkuil@xs4all.nl>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The MC support is needed by the em28xx driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov2640.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index bd96889..29d4217 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -281,6 +281,9 @@ struct ov2640_win_size {
 
 struct ov2640_priv {
 	struct v4l2_subdev		subdev;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad pad;
+#endif
 	struct v4l2_ctrl_handler	hdl;
 	u32	cfmt_code;
 	struct clk			*clk;
@@ -1053,19 +1056,30 @@ static int ov2640_probe(struct i2c_client *client,
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
 	return ret;
@@ -1077,6 +1091,9 @@ static int ov2640_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&priv->subdev.entity);
+#endif
 	v4l2_device_unregister_subdev(&priv->subdev);
 	return 0;
 }
-- 
2.10.2

