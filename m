Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52348 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbbIMU5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:11 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 03/32] v4l: vsp1: Move video operations to vsp1_rwpf
Date: Sun, 13 Sep 2015 23:56:41 +0300
Message-Id: <1442177830-24536-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This removes the dependency of vsp1_rpf and vsp1_wpf on vsp1_video,
making it possible to reuse the operations without a V4L2 video device
node.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c   | 11 +++++------
 drivers/media/platform/vsp1/vsp1_rwpf.h  |  9 +++++++++
 drivers/media/platform/vsp1/vsp1_video.c |  4 ++--
 drivers/media/platform/vsp1/vsp1_video.h |  6 ------
 drivers/media/platform/vsp1/vsp1_wpf.c   | 12 +++++-------
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 6e0564b5b37b..a17154d98a54 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -186,10 +186,8 @@ static struct v4l2_subdev_ops rpf_ops = {
  * Video Device Operations
  */
 
-static void rpf_vdev_queue(struct vsp1_video *video,
-			   struct vsp1_video_buffer *buf)
+static void rpf_buf_queue(struct vsp1_rwpf *rpf, struct vsp1_video_buffer *buf)
 {
-	struct vsp1_rwpf *rpf = container_of(video, struct vsp1_rwpf, video);
 	unsigned int i;
 
 	for (i = 0; i < 3; ++i)
@@ -208,8 +206,8 @@ static void rpf_vdev_queue(struct vsp1_video *video,
 			       buf->addr[2] + rpf->offsets[1]);
 }
 
-static const struct vsp1_video_operations rpf_vdev_ops = {
-	.queue = rpf_vdev_queue,
+static const struct vsp1_rwpf_operations rpf_vdev_ops = {
+	.queue = rpf_buf_queue,
 };
 
 /* -----------------------------------------------------------------------------
@@ -227,6 +225,8 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (rpf == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	rpf->ops = &rpf_vdev_ops;
+
 	rpf->max_width = RPF_MAX_WIDTH;
 	rpf->max_height = RPF_MAX_HEIGHT;
 
@@ -269,7 +269,6 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	video->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	video->vsp1 = vsp1;
-	video->ops = &rpf_vdev_ops;
 
 	ret = vsp1_video_init(video, rpf);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 8609c3d02679..3cc80be03524 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -24,11 +24,20 @@
 #define RWPF_PAD_SINK				0
 #define RWPF_PAD_SOURCE				1
 
+struct vsp1_rwpf;
+struct vsp1_video_buffer;
+
+struct vsp1_rwpf_operations {
+	void (*queue)(struct vsp1_rwpf *rwpf, struct vsp1_video_buffer *buf);
+};
+
 struct vsp1_rwpf {
 	struct vsp1_entity entity;
 	struct vsp1_video video;
 	struct v4l2_ctrl_handler ctrls;
 
+	const struct vsp1_rwpf_operations *ops;
+
 	unsigned int max_width;
 	unsigned int max_height;
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 90d5791c80b6..2ddbcbaf498f 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -631,7 +631,7 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	video->ops->queue(video, buf);
+	video->rwpf->ops->queue(video->rwpf, buf);
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
@@ -857,7 +857,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	video->ops->queue(video, buf);
+	video->rwpf->ops->queue(video->rwpf, buf);
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	if (vb2_is_streaming(&video->queue) &&
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index dbcb7b5b6c95..34efc471351c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -108,16 +108,10 @@ to_vsp1_video_buffer(struct vb2_buffer *vb)
 	return container_of(vb, struct vsp1_video_buffer, buf);
 }
 
-struct vsp1_video_operations {
-	void (*queue)(struct vsp1_video *video, struct vsp1_video_buffer *buf);
-};
-
 struct vsp1_video {
 	struct vsp1_device *vsp1;
 	struct vsp1_rwpf *rwpf;
 
-	const struct vsp1_video_operations *ops;
-
 	struct video_device video;
 	enum v4l2_buf_type type;
 	struct media_pad pad;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index b14070d1e457..f93b545949b6 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -195,11 +195,8 @@ static struct v4l2_subdev_ops wpf_ops = {
  * Video Device Operations
  */
 
-static void wpf_vdev_queue(struct vsp1_video *video,
-			   struct vsp1_video_buffer *buf)
+static void wpf_buf_queue(struct vsp1_rwpf *wpf, struct vsp1_video_buffer *buf)
 {
-	struct vsp1_rwpf *wpf = container_of(video, struct vsp1_rwpf, video);
-
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, buf->addr[0]);
 	if (buf->buf.num_planes > 1)
 		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, buf->addr[1]);
@@ -207,8 +204,8 @@ static void wpf_vdev_queue(struct vsp1_video *video,
 		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, buf->addr[2]);
 }
 
-static const struct vsp1_video_operations wpf_vdev_ops = {
-	.queue = wpf_vdev_queue,
+static const struct vsp1_rwpf_operations wpf_vdev_ops = {
+	.queue = wpf_buf_queue,
 };
 
 /* -----------------------------------------------------------------------------
@@ -227,6 +224,8 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (wpf == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	wpf->ops = &wpf_vdev_ops;
+
 	wpf->max_width = WPF_MAX_WIDTH;
 	wpf->max_height = WPF_MAX_HEIGHT;
 
@@ -269,7 +268,6 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	video->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	video->vsp1 = vsp1;
-	video->ops = &wpf_vdev_ops;
 
 	ret = vsp1_video_init(video, wpf);
 	if (ret < 0)
-- 
2.4.6

