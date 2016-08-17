Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42981 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbcHQG3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 02:29:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Songjun Wu <songjun.wu@microchip.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/7] ov7670: add media controller support
Date: Wed, 17 Aug 2016 08:29:37 +0200
Message-Id: <1471415383-38531-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add media controller support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 56cfb5c..25f46c7 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -210,6 +210,7 @@ struct ov7670_devtype {
 struct ov7670_format_struct;  /* coming later */
 struct ov7670_info {
 	struct v4l2_subdev sd;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
 	struct {
 		/* gain cluster */
@@ -1641,6 +1642,16 @@ static int ov7670_probe(struct i2c_client *client,
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
@@ -1662,6 +1673,9 @@ static int ov7670_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&sd->entity);
+#endif
 	return 0;
 }
 
-- 
2.8.1

