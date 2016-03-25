Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbcCYKon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:43 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 16/54] v4l: vsp1: sru: Don't program intensity in control set handler
Date: Fri, 25 Mar 2016 12:43:50 +0200
Message-Id: <1458902668-1141-17-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The datasheet clearly states that all but a few registers can't be
modified when the device is running. Programming the intensity
parameters in the control set handler is thus prohibited. Program it
when starting the module instead.

This requires storing the intensity value internally as the module can
be started from the frame completion interrupt handler, and accessing
control values requires taking a mutex.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_sru.c | 35 +++++++++-------------------------
 drivers/media/platform/vsp1/vsp1_sru.h |  2 ++
 2 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 149ee1cd0b5a..d2c705563cd7 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -26,11 +26,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_sru_read(struct vsp1_sru *sru, u32 reg)
-{
-	return vsp1_read(sru->entity.vsp1, reg);
-}
-
 static inline void vsp1_sru_write(struct vsp1_sru *sru, u32 reg, u32 data)
 {
 	vsp1_write(sru->entity.vsp1, reg, data);
@@ -82,20 +77,10 @@ static int sru_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vsp1_sru *sru =
 		container_of(ctrl->handler, struct vsp1_sru, ctrls);
-	const struct vsp1_sru_param *param;
-	u32 value;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VSP1_SRU_INTENSITY:
-		param = &vsp1_sru_params[ctrl->val - 1];
-
-		value = vsp1_sru_read(sru, VI6_SRU_CTRL0);
-		value &= ~(VI6_SRU_CTRL0_PARAM0_MASK |
-			   VI6_SRU_CTRL0_PARAM1_MASK);
-		value |= param->ctrl0;
-		vsp1_sru_write(sru, VI6_SRU_CTRL0, value);
-
-		vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
+		sru->intensity = ctrl->val;
 		break;
 	}
 
@@ -123,6 +108,7 @@ static const struct v4l2_ctrl_config sru_intensity_control = {
 
 static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 {
+	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(subdev);
 	struct v4l2_mbus_framefmt *input;
 	struct v4l2_mbus_framefmt *output;
@@ -148,18 +134,13 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (input->width != output->width)
 		ctrl0 |= VI6_SRU_CTRL0_MODE_UPSCALE;
 
-	/* Take the control handler lock to ensure that the CTRL0 value won't be
-	 * changed behind our back by a set control operation.
-	 */
-	if (sru->entity.vsp1->info->uapi)
-		mutex_lock(sru->ctrls.lock);
-	ctrl0 |= vsp1_sru_read(sru, VI6_SRU_CTRL0)
-	       & (VI6_SRU_CTRL0_PARAM0_MASK | VI6_SRU_CTRL0_PARAM1_MASK);
-	vsp1_sru_write(sru, VI6_SRU_CTRL0, ctrl0);
-	if (sru->entity.vsp1->info->uapi)
-		mutex_unlock(sru->ctrls.lock);
+	param = &vsp1_sru_params[sru->intensity - 1];
+
+	ctrl0 |= param->ctrl0;
 
+	vsp1_sru_write(sru, VI6_SRU_CTRL0, ctrl0);
 	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
+	vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
 
 	return 0;
 }
@@ -378,6 +359,8 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 	v4l2_ctrl_handler_init(&sru->ctrls, 1);
 	v4l2_ctrl_new_custom(&sru->ctrls, &sru_intensity_control, NULL);
 
+	sru->intensity = 1;
+
 	sru->entity.subdev.ctrl_handler = &sru->ctrls;
 
 	if (sru->ctrls.error) {
diff --git a/drivers/media/platform/vsp1/vsp1_sru.h b/drivers/media/platform/vsp1/vsp1_sru.h
index b6768bf3dc47..85e241457af2 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.h
+++ b/drivers/media/platform/vsp1/vsp1_sru.h
@@ -28,6 +28,8 @@ struct vsp1_sru {
 	struct vsp1_entity entity;
 
 	struct v4l2_ctrl_handler ctrls;
+
+	unsigned int intensity;
 };
 
 static inline struct vsp1_sru *to_sru(struct v4l2_subdev *subdev)
-- 
2.7.3

