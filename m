Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47311 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaFWXyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:15 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 22/23] v4l: vsp1: bru: Make the background color configurable
Date: Tue, 24 Jun 2014 01:54:28 +0200
Message-Id: <1403567669-18539-23-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Expose the background color to userspace through the V4L2_CID_BG_COLOR
control.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c | 51 ++++++++++++++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_bru.h |  3 ++
 2 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 86b32bc..a0c1984 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -38,6 +38,32 @@ static inline void vsp1_bru_write(struct vsp1_bru *bru, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+static int bru_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_bru *bru =
+		container_of(ctrl->handler, struct vsp1_bru, ctrls);
+
+	if (!vsp1_entity_is_streaming(&bru->entity))
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BG_COLOR:
+		vsp1_bru_write(bru, VI6_BRU_VIRRPF_COL, ctrl->val |
+			       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops bru_ctrl_ops = {
+	.s_ctrl = bru_s_ctrl,
+};
+
+/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Core Operations
  */
 
@@ -48,6 +74,11 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
 	unsigned int i;
+	int ret;
+
+	ret = vsp1_entity_set_streaming(&bru->entity, enable);
+	if (ret < 0)
+		return ret;
 
 	if (!enable)
 		return 0;
@@ -68,15 +99,11 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
 
-	/* Set the background position to cover the whole output image and
-	 * set its color to opaque black.
-	 */
+	/* Set the background position to cover the whole output image. */
 	vsp1_bru_write(bru, VI6_BRU_VIRRPF_SIZE,
 		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
 		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
 	vsp1_bru_write(bru, VI6_BRU_VIRRPF_LOC, 0);
-	vsp1_bru_write(bru, VI6_BRU_VIRRPF_COL,
-		       0xff << VI6_BRU_VIRRPF_COL_A_SHIFT);
 
 	/* Route BRU input 1 as SRC input to the ROP unit and configure the ROP
 	 * unit with a NOP operation to make BRU input 1 available as the
@@ -407,5 +434,19 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 
 	vsp1_entity_init_formats(subdev, NULL);
 
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&bru->ctrls, 1);
+	v4l2_ctrl_new_std(&bru->ctrls, &bru_ctrl_ops, V4L2_CID_BG_COLOR,
+			  0, 0xffffff, 1, 0);
+
+	bru->entity.subdev.ctrl_handler = &bru->ctrls;
+
+	if (bru->ctrls.error) {
+		dev_err(vsp1->dev, "bru: failed to initialize controls\n");
+		ret = bru->ctrls.error;
+		vsp1_entity_destroy(&bru->entity);
+		return ERR_PTR(ret);
+	}
+
 	return bru;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_bru.h b/drivers/media/platform/vsp1/vsp1_bru.h
index 5b03479..16b1c65 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.h
+++ b/drivers/media/platform/vsp1/vsp1_bru.h
@@ -14,6 +14,7 @@
 #define __VSP1_BRU_H__
 
 #include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 
 #include "vsp1_entity.h"
@@ -27,6 +28,8 @@ struct vsp1_rwpf;
 struct vsp1_bru {
 	struct vsp1_entity entity;
 
+	struct v4l2_ctrl_handler ctrls;
+
 	struct {
 		struct vsp1_rwpf *rpf;
 		struct v4l2_rect compose;
-- 
1.8.5.5

