Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49589 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbbA2Bnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:43:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH v2 6/6] staging: media: omap4iss: ipipe: Expose the RGB2RGB blending matrix
Date: Wed, 28 Jan 2015 11:17:19 +0200
Message-Id: <1422436639-18292-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Expose the module as two controls, one for the 3x3 multiplier matrix and
one for the 3x1 offset vector.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_ipipe.c | 129 ++++++++++++++++++++++++++++-
 drivers/staging/media/omap4iss/iss_ipipe.h |  17 ++++
 2 files changed, 144 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index 73b165e..624c5d2 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -119,6 +119,105 @@ static void ipipe_configure(struct iss_ipipe_device *ipipe)
 }
 
 /* -----------------------------------------------------------------------------
+ * V4L2 controls
+ */
+
+#define OMAP4ISS_IPIPE_CID_BASE			(V4L2_CID_USER_BASE | 0xf000)
+#define OMAP4ISS_IPIPE_CID_RGB2RGB_MULT		(OMAP4ISS_IPIPE_CID_BASE + 0)
+#define OMAP4ISS_IPIPE_CID_RGB2RGB_OFFSET	(OMAP4ISS_IPIPE_CID_BASE + 1)
+
+/*
+ * ipipe_s_ctrl - Handle set control subdev method
+ * @ctrl: pointer to v4l2 control structure
+ */
+static int ipipe_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct iss_ipipe_device *ipipe =
+		container_of(ctrl->handler, struct iss_ipipe_device, ctrls);
+	struct iss_device *iss = to_iss_device(ipipe);
+	unsigned int i;
+
+	mutex_lock(&ipipe->lock);
+
+	if (ipipe->state == ISS_PIPELINE_STREAM_STOPPED)
+		goto done;
+
+	switch (ctrl->id) {
+	case OMAP4ISS_IPIPE_CID_RGB2RGB_MULT:
+	case OMAP4ISS_IPIPE_CID_RGB2RGB_OFFSET:
+		ctrl = ipipe->rgb2rgb_mult;
+		for (i = 0; i < ctrl->elems; ++i)
+			iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE,
+				      IPIPE_RGB1_MUL_RR + 4 * i,
+				      ctrl->p_new.p_s16[i]);
+
+		ctrl = ipipe->rgb2rgb_offset;
+		for (i = 0; i < ctrl->elems; ++i)
+			iss_reg_write(iss, OMAP4_ISS_MEM_ISP_IPIPE,
+				      IPIPE_RGB1_OFT_OR + 4 * i,
+				      ctrl->p_new.p_s16[i]);
+		break;
+	}
+
+done:
+	mutex_unlock(&ipipe->lock);
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops ipipe_ctrl_ops = {
+	.s_ctrl = ipipe_s_ctrl,
+};
+
+static void ipipe_ctrl_type_init(const struct v4l2_ctrl *ctrl,
+				 union v4l2_ctrl_ptr ptr)
+{
+	unsigned int i;
+
+	switch (ctrl->id) {
+	case OMAP4ISS_IPIPE_CID_RGB2RGB_MULT:
+		/*
+		 * Initialize the diagonal to 1.0 and all other elements to
+		 * 0.0.
+		 */
+		for (i = 0; i < ctrl->elems; ++i)
+			ptr.p_s16[i] = (i % 4) ? 0 : 256;
+		break;
+	}
+}
+
+static const struct v4l2_ctrl_type_ops ipipe_ctrl_type_ops = {
+	.equal = v4l2_ctrl_type_std_equal,
+	.init = ipipe_ctrl_type_init,
+	.log = v4l2_ctrl_type_std_log,
+	.validate = v4l2_ctrl_type_std_validate,
+};
+
+static const struct v4l2_ctrl_config ipipe_ctrls[] = {
+	{
+		.ops = &ipipe_ctrl_ops,
+		.type_ops = &ipipe_ctrl_type_ops,
+		.id = OMAP4ISS_IPIPE_CID_RGB2RGB_MULT,
+		.name = "RGB2RGB Multiplier",
+		.type = V4L2_CTRL_TYPE_S16,
+		.def = 0,
+		.min = -2048,
+		.max = 2047,
+		.step = 1,
+		.dims = { 3, 3 },
+	}, {
+		.ops = &ipipe_ctrl_ops,
+		.id = OMAP4ISS_IPIPE_CID_RGB2RGB_OFFSET,
+		.name = "RGB2RGB Offset",
+		.type = V4L2_CTRL_TYPE_S16,
+		.def = 0,
+		.min = -4096,
+		.max = 4095,
+		.step = 1,
+		.dims = { 3 },
+	},
+};
+
+/* -----------------------------------------------------------------------------
  * V4L2 subdev operations
  */
 
@@ -133,9 +232,11 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 	struct iss_device *iss = to_iss_device(ipipe);
 	int ret = 0;
 
+	mutex_lock(&ipipe->lock);
+
 	if (ipipe->state == ISS_PIPELINE_STREAM_STOPPED) {
 		if (enable == ISS_PIPELINE_STREAM_STOPPED)
-			return 0;
+			goto done;
 
 		omap4iss_isp_subclk_enable(iss, OMAP4_ISS_ISP_SUBCLK_IPIPE);
 
@@ -161,7 +262,7 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 
 	case ISS_PIPELINE_STREAM_STOPPED:
 		if (ipipe->state == ISS_PIPELINE_STREAM_STOPPED)
-			return 0;
+			goto done;
 		if (omap4iss_module_sync_idle(&sd->entity, &ipipe->wait,
 					      &ipipe->stopping))
 			ret = -ETIMEDOUT;
@@ -172,6 +273,13 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 	}
 
 	ipipe->state = enable;
+
+done:
+	mutex_unlock(&ipipe->lock);
+
+	if (enable == ISS_PIPELINE_STREAM_CONTINUOUS)
+		v4l2_ctrl_handler_setup(ipipe->subdev.ctrl_handler);
+
 	return ret;
 }
 
@@ -501,6 +609,20 @@ static int ipipe_init_entities(struct iss_ipipe_device *ipipe)
 	v4l2_set_subdevdata(sd, ipipe);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
+	v4l2_ctrl_handler_init(&ipipe->ctrls, 2);
+
+	ipipe->rgb2rgb_mult = v4l2_ctrl_new_custom(&ipipe->ctrls,
+						   &ipipe_ctrls[0], NULL);
+	ipipe->rgb2rgb_offset = v4l2_ctrl_new_custom(&ipipe->ctrls,
+						     &ipipe_ctrls[1], NULL);
+
+	if (ipipe->ctrls.error)
+		return ipipe->ctrls.error;
+
+	v4l2_ctrl_cluster(2, &ipipe->rgb2rgb_mult);
+
+	sd->ctrl_handler = &ipipe->ctrls;
+
 	pads[IPIPE_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	pads[IPIPE_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
 
@@ -554,6 +676,7 @@ int omap4iss_ipipe_init(struct iss_device *iss)
 
 	ipipe->state = ISS_PIPELINE_STREAM_STOPPED;
 	init_waitqueue_head(&ipipe->wait);
+	mutex_init(&ipipe->lock);
 
 	return ipipe_init_entities(ipipe);
 }
@@ -566,5 +689,7 @@ void omap4iss_ipipe_cleanup(struct iss_device *iss)
 {
 	struct iss_ipipe_device *ipipe = &iss->ipipe;
 
+	v4l2_ctrl_handler_free(&ipipe->ctrls);
 	media_entity_cleanup(&ipipe->subdev.entity);
+	mutex_destroy(&ipipe->lock);
 }
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.h b/drivers/staging/media/omap4iss/iss_ipipe.h
index c22d904..7684271 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.h
+++ b/drivers/staging/media/omap4iss/iss_ipipe.h
@@ -14,6 +14,10 @@
 #ifndef OMAP4_ISS_IPIPE_H
 #define OMAP4_ISS_IPIPE_H
 
+#include <linux/mutex.h>
+
+#include <media/v4l2-ctrls.h>
+
 #include "iss_video.h"
 
 enum ipipe_input_entity {
@@ -34,9 +38,13 @@ enum ipipe_input_entity {
  * @subdev: V4L2 subdevice
  * @pads: Sink and source media entity pads
  * @formats: Active video formats
+ * @ctrls: Control handler
+ * @rgb2rgb_mult: RGB to RGB matrix multiplier control
+ * @rgb2rgb_offset: RGB to RGB matrix offset control
  * @input: Active input
  * @output: Active outputs
  * @error: A hardware error occurred during capture
+ * @lock: Protects the state field
  * @state: Streaming state
  * @wait: Wait queue used to stop the module
  * @stopping: Stopping state
@@ -46,10 +54,19 @@ struct iss_ipipe_device {
 	struct media_pad pads[IPIPE_PADS_NUM];
 	struct v4l2_mbus_framefmt formats[IPIPE_PADS_NUM];
 
+	struct v4l2_ctrl_handler ctrls;
+	struct {
+		/* RGB2RGB cluster */
+		struct v4l2_ctrl *rgb2rgb_mult;
+		struct v4l2_ctrl *rgb2rgb_offset;
+	};
+
 	enum ipipe_input_entity input;
 	unsigned int output;
 	unsigned int error;
 
+	struct mutex lock;
+	bool streaming;
 	enum iss_pipeline_stream_state state;
 	wait_queue_head_t wait;
 	atomic_t stopping;
-- 
2.0.5

