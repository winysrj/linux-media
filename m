Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58960 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752389AbcLLPzY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/15] ov7670: add media controller support
Date: Mon, 12 Dec 2016 16:55:06 +0100
Message-Id: <20161212155520.41375-2-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add media controller support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 56cfb5c..b0315bb 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -210,6 +210,9 @@ struct ov7670_devtype {
 struct ov7670_format_struct;  /* coming later */
 struct ov7670_info {
 	struct v4l2_subdev sd;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad pad;
+#endif
 	struct v4l2_ctrl_handler hdl;
 	struct {
 		/* gain cluster */
@@ -1641,6 +1644,16 @@ static int ov7670_probe(struct i2c_client *client,
 		v4l2_ctrl_handler_free(&info->hdl);
 		return err;
 	}
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	info->pad.flags = MEDIA_PAD_FL_SOURCE;
+	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
+	if (ret < 0) {
+		v4l2_ctrl_handler_free(&info->hdl);
+		return ret;
+	}
+#endif
 	/*
 	 * We have checked empirically that hw allows to read back the gain
 	 * value chosen by auto gain but that's not the case for auto exposure.
@@ -1662,6 +1675,9 @@ static int ov7670_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&sd->entity);
+#endif
 	return 0;
 }
 
-- 
2.10.2

