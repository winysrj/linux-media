Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaFWXyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:14 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 20/23] v4l: vsp1: bru: Support premultiplied alpha at the BRU inputs
Date: Tue, 24 Jun 2014 01:54:26 +0200
Message-Id: <1403567669-18539-21-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the BRU blending formula to avoid the multiplication by alpha
when the corresponding input format is premultiplied. As this requires
access to the RPFs connected to the BRU inputs from the BRU module,
store pointers to the RPFs in the BRU structure when validating the
pipeline.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c   | 27 ++++++++++++-------
 drivers/media/platform/vsp1/vsp1_bru.h   |  6 ++++-
 drivers/media/platform/vsp1/vsp1_video.c | 45 +++++++++++++++++++-------------
 3 files changed, 50 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index f806954..d8d49fb 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -18,6 +18,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_rwpf.h"
 
 #define BRU_MIN_SIZE				4U
 #define BRU_MAX_SIZE				8190U
@@ -40,11 +41,6 @@ static inline void vsp1_bru_write(struct vsp1_bru *bru, u32 reg, u32 data)
  * V4L2 Subdevice Core Operations
  */
 
-static bool bru_is_input_enabled(struct vsp1_bru *bru, unsigned int input)
-{
-	return media_entity_remote_pad(&bru->entity.pads[input]) != NULL;
-}
-
 static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
@@ -84,6 +80,7 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 		       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
 
 	for (i = 0; i < 4; ++i) {
+		bool premultiplied = false;
 		u32 ctrl = 0;
 
 		/* Configure all Blend/ROP units corresponding to an enabled BRU
@@ -91,11 +88,15 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 		 * disabled BRU inputs are used in ROP NOP mode to ignore the
 		 * SRC input.
 		 */
-		if (bru_is_input_enabled(bru, i))
+		if (bru->inputs[i].rpf) {
 			ctrl |= VI6_BRU_CTRL_RBC;
-		else
+
+			premultiplied = bru->inputs[i].rpf->video.format.flags
+				      & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA;
+		} else {
 			ctrl |= VI6_BRU_CTRL_CROP(VI6_ROP_NOP)
 			     |  VI6_BRU_CTRL_AROP(VI6_ROP_NOP);
+		}
 
 		/* Select the virtual RPF as the Blend/ROP unit A DST input to
 		 * serve as a background color.
@@ -117,10 +118,18 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 		 *
 		 *	DSTc = DSTc * (1 - SRCa) + SRCc * SRCa
 		 *	DSTa = DSTa * (1 - SRCa) + SRCa
+		 *
+		 * when the SRC input isn't premultiplied, and to
+		 *
+		 *	DSTc = DSTc * (1 - SRCa) + SRCc
+		 *	DSTa = DSTa * (1 - SRCa) + SRCa
+		 *
+		 * otherwise.
 		 */
 		vsp1_bru_write(bru, VI6_BRU_BLD(i),
 			       VI6_BRU_BLD_CCMDX_255_SRC_A |
-			       VI6_BRU_BLD_CCMDY_SRC_A |
+			       (premultiplied ? VI6_BRU_BLD_CCMDY_COEFY :
+						VI6_BRU_BLD_CCMDY_SRC_A) |
 			       VI6_BRU_BLD_ACMDX_255_SRC_A |
 			       VI6_BRU_BLD_ACMDY_COEFY |
 			       (0xff << VI6_BRU_BLD_COEFY_SHIFT));
@@ -192,7 +201,7 @@ static struct v4l2_rect *bru_get_compose(struct vsp1_bru *bru,
 	case V4L2_SUBDEV_FORMAT_TRY:
 		return v4l2_subdev_get_try_crop(fh, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
-		return &bru->compose[pad];
+		return &bru->inputs[pad].compose;
 	default:
 		return NULL;
 	}
diff --git a/drivers/media/platform/vsp1/vsp1_bru.h b/drivers/media/platform/vsp1/vsp1_bru.h
index 3706270..5b03479 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.h
+++ b/drivers/media/platform/vsp1/vsp1_bru.h
@@ -19,6 +19,7 @@
 #include "vsp1_entity.h"
 
 struct vsp1_device;
+struct vsp1_rwpf;
 
 #define BRU_PAD_SINK(n)				(n)
 #define BRU_PAD_SOURCE				4
@@ -26,7 +27,10 @@ struct vsp1_device;
 struct vsp1_bru {
 	struct vsp1_entity entity;
 
-	struct v4l2_rect compose[4];
+	struct {
+		struct vsp1_rwpf *rpf;
+		struct v4l2_rect compose;
+	} inputs[4];
 };
 
 static inline struct vsp1_bru *to_bru(struct v4l2_subdev *subdev)
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4dd4d61..58fc076 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -334,7 +334,10 @@ static int vsp1_pipeline_validate_branch(struct vsp1_rwpf *input,
 		 */
 		if (entity->type == VSP1_ENTITY_BRU) {
 			struct vsp1_bru *bru = to_bru(&entity->subdev);
-			struct v4l2_rect *rect = &bru->compose[pad->index];
+			struct v4l2_rect *rect =
+				&bru->inputs[pad->index].compose;
+
+			bru->inputs[pad->index].rpf = input;
 
 			input->location.left = rect->left;
 			input->location.top = rect->top;
@@ -373,6 +376,26 @@ static int vsp1_pipeline_validate_branch(struct vsp1_rwpf *input,
 	return 0;
 }
 
+static void __vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)
+{
+	if (pipe->bru) {
+		struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
+		unsigned int i;
+
+		for (i = 0; i < ARRAY_SIZE(bru->inputs); ++i)
+			bru->inputs[i].rpf = NULL;
+	}
+
+	INIT_LIST_HEAD(&pipe->entities);
+	pipe->state = VSP1_PIPELINE_STOPPED;
+	pipe->buffers_ready = 0;
+	pipe->num_video = 0;
+	pipe->num_inputs = 0;
+	pipe->output = NULL;
+	pipe->bru = NULL;
+	pipe->lif = NULL;
+}
+
 static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 				  struct vsp1_video *video)
 {
@@ -437,13 +460,7 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 	return 0;
 
 error:
-	INIT_LIST_HEAD(&pipe->entities);
-	pipe->buffers_ready = 0;
-	pipe->num_video = 0;
-	pipe->num_inputs = 0;
-	pipe->output = NULL;
-	pipe->bru = NULL;
-	pipe->lif = NULL;
+	__vsp1_pipeline_cleanup(pipe);
 	return ret;
 }
 
@@ -474,16 +491,8 @@ static void vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)
 	mutex_lock(&pipe->lock);
 
 	/* If we're the last user clean up the pipeline. */
-	if (--pipe->use_count == 0) {
-		INIT_LIST_HEAD(&pipe->entities);
-		pipe->state = VSP1_PIPELINE_STOPPED;
-		pipe->buffers_ready = 0;
-		pipe->num_video = 0;
-		pipe->num_inputs = 0;
-		pipe->output = NULL;
-		pipe->bru = NULL;
-		pipe->lif = NULL;
-	}
+	if (--pipe->use_count == 0)
+		__vsp1_pipeline_cleanup(pipe);
 
 	mutex_unlock(&pipe->lock);
 }
-- 
1.8.5.5

