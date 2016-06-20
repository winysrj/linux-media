Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbcFTTMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:12:07 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 14/24] v4l: vsp1: lut: Expose configuration through a control
Date: Mon, 20 Jun 2016 22:10:32 +0300
Message-Id: <1466449842-29502-15-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the custom ioctl with a V4L2 control in order to standardize the
API.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lut.c | 76 +++++++++++++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_lut.h |  6 +--
 include/uapi/linux/vsp1.h              | 34 ---------------
 3 files changed, 54 insertions(+), 62 deletions(-)
 delete mode 100644 include/uapi/linux/vsp1.h

diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 9a2c55b3570a..70f189ee235c 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -13,7 +13,6 @@
 
 #include <linux/device.h>
 #include <linux/gfp.h>
-#include <linux/vsp1.h>
 
 #include <media/v4l2-subdev.h>
 
@@ -35,43 +34,60 @@ static inline void vsp1_lut_write(struct vsp1_lut *lut, struct vsp1_dl_list *dl,
 }
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
+ * Controls
  */
 
-static int lut_set_table(struct vsp1_lut *lut, struct vsp1_lut_config *config)
+#define V4L2_CID_VSP1_LUT_TABLE			(V4L2_CID_USER_BASE | 0x1001)
+
+static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 {
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_fragment_alloc(lut->entity.vsp1, ARRAY_SIZE(config->lut));
+	dlb = vsp1_dl_fragment_alloc(lut->entity.vsp1, 256);
 	if (!dlb)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(config->lut); ++i)
+	for (i = 0; i < 256; ++i)
 		vsp1_dl_fragment_write(dlb, VI6_LUT_TABLE + 4 * i,
-				       config->lut[i]);
+				       ctrl->p_new.p_u32[i]);
 
-	mutex_lock(&lut->lock);
 	swap(lut->lut, dlb);
-	mutex_unlock(&lut->lock);
 
 	vsp1_dl_fragment_free(dlb);
 	return 0;
 }
 
-static long lut_ioctl(struct v4l2_subdev *subdev, unsigned int cmd, void *arg)
+static int lut_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct vsp1_lut *lut = to_lut(subdev);
-
-	switch (cmd) {
-	case VIDIOC_VSP1_LUT_CONFIG:
-		return lut_set_table(lut, arg);
+	struct vsp1_lut *lut =
+		container_of(ctrl->handler, struct vsp1_lut, ctrls);
 
-	default:
-		return -ENOIOCTLCMD;
+	switch (ctrl->id) {
+	case V4L2_CID_VSP1_LUT_TABLE:
+		lut_set_table(lut, ctrl);
+		break;
 	}
+
+	return 0;
 }
 
+static const struct v4l2_ctrl_ops lut_ctrl_ops = {
+	.s_ctrl = lut_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config lut_table_control = {
+	.ops = &lut_ctrl_ops,
+	.id = V4L2_CID_VSP1_LUT_TABLE,
+	.name = "Look-Up Table",
+	.type = V4L2_CTRL_TYPE_U32,
+	.min = 0x00000000,
+	.max = 0x00ffffff,
+	.step = 1,
+	.def = 0,
+	.dims = { 256},
+};
+
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Pad Operations
  */
@@ -147,10 +163,6 @@ static int lut_set_format(struct v4l2_subdev *subdev,
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_core_ops lut_core_ops = {
-	.ioctl = lut_ioctl,
-};
-
 static struct v4l2_subdev_pad_ops lut_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lut_enum_mbus_code,
@@ -160,7 +172,6 @@ static struct v4l2_subdev_pad_ops lut_pad_ops = {
 };
 
 static struct v4l2_subdev_ops lut_ops = {
-	.core	= &lut_core_ops,
 	.pad    = &lut_pad_ops,
 };
 
@@ -176,12 +187,14 @@ static void lut_configure(struct vsp1_entity *entity,
 
 	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
 
-	mutex_lock(&lut->lock);
+	mutex_lock(lut->ctrls.lock);
+
 	if (lut->lut) {
 		vsp1_dl_list_add_fragment(dl, lut->lut);
 		lut->lut = NULL;
 	}
-	mutex_unlock(&lut->lock);
+
+	mutex_unlock(lut->ctrls.lock);
 }
 
 static const struct vsp1_entity_operations lut_entity_ops = {
@@ -201,8 +214,6 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (lut == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_init(&lut->lock);
-
 	lut->entity.ops = &lut_entity_ops;
 	lut->entity.type = VSP1_ENTITY_LUT;
 
@@ -211,5 +222,20 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&lut->ctrls, 1);
+	v4l2_ctrl_new_custom(&lut->ctrls, &lut_table_control, NULL);
+
+	lut->entity.subdev.ctrl_handler = &lut->ctrls;
+
+	if (lut->ctrls.error) {
+		dev_err(vsp1->dev, "lut: failed to initialize controls\n");
+		ret = lut->ctrls.error;
+		vsp1_entity_destroy(&lut->entity);
+		return ERR_PTR(ret);
+	}
+
+	v4l2_ctrl_handler_setup(&lut->ctrls);
+
 	return lut;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
index cef874f22b6a..021898fc0ce5 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.h
+++ b/drivers/media/platform/vsp1/vsp1_lut.h
@@ -13,9 +13,8 @@
 #ifndef __VSP1_LUT_H__
 #define __VSP1_LUT_H__
 
-#include <linux/mutex.h>
-
 #include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 
 #include "vsp1_entity.h"
@@ -28,7 +27,8 @@ struct vsp1_device;
 struct vsp1_lut {
 	struct vsp1_entity entity;
 
-	struct mutex lock;
+	struct v4l2_ctrl_handler ctrls;
+
 	struct vsp1_dl_body *lut;
 };
 
diff --git a/include/uapi/linux/vsp1.h b/include/uapi/linux/vsp1.h
deleted file mode 100644
index 9a823696d816..000000000000
--- a/include/uapi/linux/vsp1.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * vsp1.h
- *
- * Renesas R-Car VSP1 - User-space API
- *
- * Copyright (C) 2013 Renesas Corporation
- *
- * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __VSP1_USER_H__
-#define __VSP1_USER_H__
-
-#include <linux/types.h>
-#include <linux/videodev2.h>
-
-/*
- * Private IOCTLs
- *
- * VIDIOC_VSP1_LUT_CONFIG - Configure the lookup table
- */
-
-#define VIDIOC_VSP1_LUT_CONFIG \
-	_IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct vsp1_lut_config)
-
-struct vsp1_lut_config {
-	__u32 lut[256];
-};
-
-#endif	/* __VSP1_USER_H__ */
-- 
Regards,

Laurent Pinchart

