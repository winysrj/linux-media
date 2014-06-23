Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFWXyK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:10 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 14/23] v4l: vsp1: sru: Make the intensity controllable during streaming
Date: Tue, 24 Jun 2014 01:54:20 +0200
Message-Id: <1403567669-18539-15-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The control value is currently stored in the SRU structure by the
control set handler and written to the hardware at stream on time,
making control set during streaming ineffective. Fix it by writing to
the registers from within the control set handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h |   2 +
 drivers/media/platform/vsp1/vsp1_sru.c  | 101 +++++++++++++++++++-------------
 drivers/media/platform/vsp1/vsp1_sru.h  |   1 -
 3 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 3e74b44..55f163d 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -336,7 +336,9 @@
  */
 
 #define VI6_SRU_CTRL0			0x2200
+#define VI6_SRU_CTRL0_PARAM0_MASK	(0x1ff << 16)
 #define VI6_SRU_CTRL0_PARAM0_SHIFT	16
+#define VI6_SRU_CTRL0_PARAM1_MASK	(0x1f << 8)
 #define VI6_SRU_CTRL0_PARAM1_SHIFT	8
 #define VI6_SRU_CTRL0_MODE_UPSCALE	(4 << 4)
 #define VI6_SRU_CTRL0_PARAM2		(1 << 3)
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 18e127a..b7d3c8b 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -42,39 +42,6 @@ static inline void vsp1_sru_write(struct vsp1_sru *sru, u32 reg, u32 data)
 
 #define V4L2_CID_VSP1_SRU_INTENSITY		(V4L2_CID_USER_BASE + 1)
 
-static int sru_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct vsp1_sru *sru =
-		container_of(ctrl->handler, struct vsp1_sru, ctrls);
-
-	switch (ctrl->id) {
-	case V4L2_CID_VSP1_SRU_INTENSITY:
-		sru->intensity = ctrl->val;
-		break;
-	}
-
-	return 0;
-}
-
-static const struct v4l2_ctrl_ops sru_ctrl_ops = {
-	.s_ctrl = sru_s_ctrl,
-};
-
-static const struct v4l2_ctrl_config sru_intensity_control = {
-	.ops = &sru_ctrl_ops,
-	.id = V4L2_CID_VSP1_SRU_INTENSITY,
-	.name = "Intensity",
-	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = 1,
-	.max = 6,
-	.def = 1,
-	.step = 1,
-};
-
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
- */
-
 struct vsp1_sru_param {
 	u32 ctrl0;
 	u32 ctrl2;
@@ -111,22 +78,66 @@ static const struct vsp1_sru_param vsp1_sru_params[] = {
 	},
 };
 
+static int sru_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_sru *sru =
+		container_of(ctrl->handler, struct vsp1_sru, ctrls);
+	const struct vsp1_sru_param *param;
+	u32 value;
+
+	switch (ctrl->id) {
+	case V4L2_CID_VSP1_SRU_INTENSITY:
+		param = &vsp1_sru_params[ctrl->val - 1];
+
+		value = vsp1_sru_read(sru, VI6_SRU_CTRL0);
+		value &= ~(VI6_SRU_CTRL0_PARAM0_MASK |
+			   VI6_SRU_CTRL0_PARAM1_MASK);
+		value |= param->ctrl0;
+		vsp1_sru_write(sru, VI6_SRU_CTRL0, value);
+
+		vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops sru_ctrl_ops = {
+	.s_ctrl = sru_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config sru_intensity_control = {
+	.ops = &sru_ctrl_ops,
+	.id = V4L2_CID_VSP1_SRU_INTENSITY,
+	.name = "Intensity",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 1,
+	.max = 6,
+	.def = 1,
+	.step = 1,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
 static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
-	const struct vsp1_sru_param *param;
 	struct v4l2_mbus_framefmt *input;
 	struct v4l2_mbus_framefmt *output;
-	bool upscale;
 	u32 ctrl0;
+	int ret;
+
+	ret = vsp1_entity_set_streaming(&sru->entity, enable);
+	if (ret < 0)
+		return ret;
 
 	if (!enable)
 		return 0;
 
 	input = &sru->entity.formats[SRU_PAD_SINK];
 	output = &sru->entity.formats[SRU_PAD_SOURCE];
-	upscale = input->width != output->width;
-	param = &vsp1_sru_params[sru->intensity];
 
 	if (input->code == V4L2_MBUS_FMT_ARGB8888_1X32)
 		ctrl0 = VI6_SRU_CTRL0_PARAM2 | VI6_SRU_CTRL0_PARAM3
@@ -134,10 +145,18 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 	else
 		ctrl0 = VI6_SRU_CTRL0_PARAM3;
 
-	vsp1_sru_write(sru, VI6_SRU_CTRL0, param->ctrl0 | ctrl0 |
-		       (upscale ? VI6_SRU_CTRL0_MODE_UPSCALE : 0));
+	if (input->width != output->width)
+		ctrl0 |= VI6_SRU_CTRL0_MODE_UPSCALE;
+
+	/* Take the control handler lock to ensure that the CTRL0 value won't be
+	 * changed behind our back by a set control operation.
+	 */
+	mutex_lock(sru->ctrls.lock);
+	ctrl0 |= vsp1_sru_read(sru, VI6_SRU_CTRL0)
+	       & (VI6_SRU_CTRL0_PARAM0_MASK | VI6_SRU_CTRL0_PARAM1_MASK);
+	mutex_unlock(sru->ctrls.lock);
+
 	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
-	vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
 
 	return 0;
 }
@@ -359,7 +378,5 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 		return ERR_PTR(ret);
 	}
 
-	v4l2_ctrl_handler_setup(&sru->ctrls);
-
 	return sru;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_sru.h b/drivers/media/platform/vsp1/vsp1_sru.h
index 381870b..b6768bf 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.h
+++ b/drivers/media/platform/vsp1/vsp1_sru.h
@@ -28,7 +28,6 @@ struct vsp1_sru {
 	struct vsp1_entity entity;
 
 	struct v4l2_ctrl_handler ctrls;
-	unsigned int intensity;
 };
 
 static inline struct vsp1_sru *to_sru(struct v4l2_subdev *subdev)
-- 
1.8.5.5

