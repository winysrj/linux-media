Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55019 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbbLECND (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:03 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 04/32] v4l: vsp1: Rename vsp1_video_buffer to vsp1_vb2_buffer
Date: Sat,  5 Dec 2015 04:12:38 +0200
Message-Id: <1449281586-25726-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structure represent a vsp1 videobuf2 buffer, name it accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c   |  2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h  |  4 ++--
 drivers/media/platform/vsp1/vsp1_video.c | 20 ++++++++++----------
 drivers/media/platform/vsp1/vsp1_video.h |  8 ++++----
 drivers/media/platform/vsp1/vsp1_wpf.c   |  2 +-
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index ee0a1472a13c..1f91fc4c4857 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -186,7 +186,7 @@ static struct v4l2_subdev_ops rpf_ops = {
  * Video Device Operations
  */
 
-static void rpf_buf_queue(struct vsp1_rwpf *rpf, struct vsp1_video_buffer *buf)
+static void rpf_buf_queue(struct vsp1_rwpf *rpf, struct vsp1_vb2_buffer *buf)
 {
 	unsigned int i;
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 3cc80be03524..aa22cc062ff3 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -25,10 +25,10 @@
 #define RWPF_PAD_SOURCE				1
 
 struct vsp1_rwpf;
-struct vsp1_video_buffer;
+struct vsp1_vb2_buffer;
 
 struct vsp1_rwpf_operations {
-	void (*queue)(struct vsp1_rwpf *rwpf, struct vsp1_video_buffer *buf);
+	void (*queue)(struct vsp1_rwpf *rwpf, struct vsp1_vb2_buffer *buf);
 };
 
 struct vsp1_rwpf {
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 932225ec45f6..e96160d90b35 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -577,12 +577,12 @@ static bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
  *
  * Return the next queued buffer or NULL if the queue is empty.
  */
-static struct vsp1_video_buffer *
+static struct vsp1_vb2_buffer *
 vsp1_video_complete_buffer(struct vsp1_video *video)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
-	struct vsp1_video_buffer *next = NULL;
-	struct vsp1_video_buffer *done;
+	struct vsp1_vb2_buffer *next = NULL;
+	struct vsp1_vb2_buffer *done;
 	unsigned long flags;
 	unsigned int i;
 
@@ -594,7 +594,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	}
 
 	done = list_first_entry(&video->irqqueue,
-				struct vsp1_video_buffer, queue);
+				struct vsp1_vb2_buffer, queue);
 
 	/* In DU output mode reuse the buffer if the list is singular. */
 	if (pipe->lif && list_is_singular(&video->irqqueue)) {
@@ -606,7 +606,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 
 	if (!list_empty(&video->irqqueue))
 		next = list_first_entry(&video->irqqueue,
-					struct vsp1_video_buffer, queue);
+					struct vsp1_vb2_buffer, queue);
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
@@ -622,7 +622,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 				 struct vsp1_video *video)
 {
-	struct vsp1_video_buffer *buf;
+	struct vsp1_vb2_buffer *buf;
 	unsigned long flags;
 
 	buf = vsp1_video_complete_buffer(video);
@@ -823,7 +823,7 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
-	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vbuf);
+	struct vsp1_vb2_buffer *buf = to_vsp1_vb2_buffer(vbuf);
 	const struct v4l2_pix_format_mplane *format = &video->rwpf->format;
 	unsigned int i;
 
@@ -846,7 +846,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
-	struct vsp1_video_buffer *buf = to_vsp1_video_buffer(vbuf);
+	struct vsp1_vb2_buffer *buf = to_vsp1_vb2_buffer(vbuf);
 	unsigned long flags;
 	bool empty;
 
@@ -938,7 +938,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
-	struct vsp1_video_buffer *buffer;
+	struct vsp1_vb2_buffer *buffer;
 	unsigned long flags;
 	int ret;
 
@@ -1263,7 +1263,7 @@ int vsp1_video_init(struct vsp1_video *video, struct vsp1_rwpf *rwpf)
 	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	video->queue.lock = &video->lock;
 	video->queue.drv_priv = video;
-	video->queue.buf_struct_size = sizeof(struct vsp1_video_buffer);
+	video->queue.buf_struct_size = sizeof(struct vsp1_vb2_buffer);
 	video->queue.ops = &vsp1_video_queue_qops;
 	video->queue.mem_ops = &vb2_dma_contig_memops;
 	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 72be847f2df9..c7e143125ef7 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -94,7 +94,7 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 		return NULL;
 }
 
-struct vsp1_video_buffer {
+struct vsp1_vb2_buffer {
 	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
 
@@ -102,10 +102,10 @@ struct vsp1_video_buffer {
 	unsigned int length[3];
 };
 
-static inline struct vsp1_video_buffer *
-to_vsp1_video_buffer(struct vb2_v4l2_buffer *vbuf)
+static inline struct vsp1_vb2_buffer *
+to_vsp1_vb2_buffer(struct vb2_v4l2_buffer *vbuf)
 {
-	return container_of(vbuf, struct vsp1_video_buffer, buf);
+	return container_of(vbuf, struct vsp1_vb2_buffer, buf);
 }
 
 struct vsp1_video {
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index b25c5e6976ef..e41d8bcd9d97 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -195,7 +195,7 @@ static struct v4l2_subdev_ops wpf_ops = {
  * Video Device Operations
  */
 
-static void wpf_buf_queue(struct vsp1_rwpf *wpf, struct vsp1_video_buffer *buf)
+static void wpf_buf_queue(struct vsp1_rwpf *wpf, struct vsp1_vb2_buffer *buf)
 {
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, buf->addr[0]);
 	if (buf->buf.vb2_buf.num_planes > 1)
-- 
2.4.10

