Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55019 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbbLECNF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:05 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 06/32] v4l: vsp1: Make rwpf operations independent of video device
Date: Sat,  5 Dec 2015 04:12:40 +0200
Message-Id: <1449281586-25726-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rwpf queue operation doesn't queue a buffer but sets the memory
address for the next run. Rename it to set_memory and pass it a new
structure independent of the video buffer than only contains memory
information.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c   | 16 ++++++++--------
 drivers/media/platform/vsp1/vsp1_rwpf.h  | 10 ++++++++--
 drivers/media/platform/vsp1/vsp1_video.c | 15 +++++++++------
 drivers/media/platform/vsp1/vsp1_video.h |  7 +++----
 drivers/media/platform/vsp1/vsp1_wpf.c   | 14 +++++++-------
 5 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 085d10056297..c0b7f76cd0b5 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -186,28 +186,28 @@ static struct v4l2_subdev_ops rpf_ops = {
  * Video Device Operations
  */
 
-static void rpf_buf_queue(struct vsp1_rwpf *rpf, struct vsp1_vb2_buffer *buf)
+static void rpf_set_memory(struct vsp1_rwpf *rpf, struct vsp1_rwpf_memory *mem)
 {
 	unsigned int i;
 
 	for (i = 0; i < 3; ++i)
-		rpf->buf_addr[i] = buf->addr[i];
+		rpf->buf_addr[i] = mem->addr[i];
 
 	if (!vsp1_entity_is_streaming(&rpf->entity))
 		return;
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
-		       buf->addr[0] + rpf->offsets[0]);
-	if (buf->buf.vb2_buf.num_planes > 1)
+		       mem->addr[0] + rpf->offsets[0]);
+	if (mem->num_planes > 1)
 		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
-			       buf->addr[1] + rpf->offsets[1]);
-	if (buf->buf.vb2_buf.num_planes > 2)
+			       mem->addr[1] + rpf->offsets[1]);
+	if (mem->num_planes > 2)
 		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
-			       buf->addr[2] + rpf->offsets[1]);
+			       mem->addr[2] + rpf->offsets[1]);
 }
 
 static const struct vsp1_rwpf_operations rpf_vdev_ops = {
-	.queue = rpf_buf_queue,
+	.set_memory = rpf_set_memory,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index ee2a8bf269fa..0076920adb28 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -24,10 +24,16 @@
 #define RWPF_PAD_SOURCE				1
 
 struct vsp1_rwpf;
-struct vsp1_vb2_buffer;
+
+struct vsp1_rwpf_memory {
+	unsigned int num_planes;
+	dma_addr_t addr[3];
+	unsigned int length[3];
+};
 
 struct vsp1_rwpf_operations {
-	void (*queue)(struct vsp1_rwpf *rwpf, struct vsp1_vb2_buffer *buf);
+	void (*set_memory)(struct vsp1_rwpf *rwpf,
+			   struct vsp1_rwpf_memory *mem);
 };
 
 struct vsp1_rwpf {
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 3086cdbeaf9a..0d600b8de6b1 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -613,7 +613,8 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	done->buf.sequence = video->sequence++;
 	v4l2_get_timestamp(&done->buf.timestamp);
 	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
-		vb2_set_plane_payload(&done->buf.vb2_buf, i, done->length[i]);
+		vb2_set_plane_payload(&done->buf.vb2_buf, i,
+				      done->mem.length[i]);
 	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
 	return next;
@@ -631,7 +632,7 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	video->rwpf->ops->queue(video->rwpf, buf);
+	video->rwpf->ops->set_memory(video->rwpf, &buf->mem);
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
@@ -830,11 +831,13 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 	if (vb->num_planes < format->num_planes)
 		return -EINVAL;
 
+	buf->mem.num_planes = vb->num_planes;
+
 	for (i = 0; i < vb->num_planes; ++i) {
-		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
-		buf->length[i] = vb2_plane_size(vb, i);
+		buf->mem.addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
+		buf->mem.length[i] = vb2_plane_size(vb, i);
 
-		if (buf->length[i] < format->plane_fmt[i].sizeimage)
+		if (buf->mem.length[i] < format->plane_fmt[i].sizeimage)
 			return -EINVAL;
 	}
 
@@ -860,7 +863,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	video->rwpf->ops->queue(video->rwpf, buf);
+	video->rwpf->ops->set_memory(video->rwpf, &buf->mem);
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	if (vb2_is_streaming(&video->queue) &&
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index cbd44c336169..21096d82af05 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -20,7 +20,8 @@
 #include <media/media-entity.h>
 #include <media/videobuf2-v4l2.h>
 
-struct vsp1_rwpf;
+#include "vsp1_rwpf.h"
+
 struct vsp1_video;
 
 /*
@@ -97,9 +98,7 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 struct vsp1_vb2_buffer {
 	struct vb2_v4l2_buffer buf;
 	struct list_head queue;
-
-	dma_addr_t addr[3];
-	unsigned int length[3];
+	struct vsp1_rwpf_memory mem;
 };
 
 static inline struct vsp1_vb2_buffer *
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index a4c0888a1b46..d2537b46fc46 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -195,17 +195,17 @@ static struct v4l2_subdev_ops wpf_ops = {
  * Video Device Operations
  */
 
-static void wpf_buf_queue(struct vsp1_rwpf *wpf, struct vsp1_vb2_buffer *buf)
+static void wpf_set_memory(struct vsp1_rwpf *wpf, struct vsp1_rwpf_memory *mem)
 {
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, buf->addr[0]);
-	if (buf->buf.vb2_buf.num_planes > 1)
-		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, buf->addr[1]);
-	if (buf->buf.vb2_buf.num_planes > 2)
-		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, buf->addr[2]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, mem->addr[0]);
+	if (mem->num_planes > 1)
+		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, mem->addr[1]);
+	if (mem->num_planes > 2)
+		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, mem->addr[2]);
 }
 
 static const struct vsp1_rwpf_operations wpf_vdev_ops = {
-	.queue = wpf_buf_queue,
+	.set_memory = wpf_set_memory,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.4.10

