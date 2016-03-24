Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbcCXX2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:10 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 19/51] v4l: vsp1: Don't configure RPF memory buffers before calculating offsets
Date: Fri, 25 Mar 2016 01:27:15 +0200
Message-Id: <1458862067-19525-20-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RPF source memory pointers need to be offset to take the crop
rectangle into account. Offsets are computed in the RPF stream start,
which can happen (when using the DRM pipeline) after calling the RPF
.set_memory() operation that programs the buffer addresses.

The .set_memory() operation tries to guard against the problem by
skipping programming of the registers when the module isn't streaming.
This will however only protect the first use of an RPF in a DRM
pipeline, as in all subsequent uses the module streaming flag will be
set and the .set_memory() operation will use potentially incorrect
offsets.

Fix this by allowing the caller to decide whether to program the
hardware immediately or just cache the addresses. While at it refactor
the memory set code and create a new vsp1_rwpf_set_memory() that cache
addresses and calls the .set_memory() operation to apply them to the
hardware.

As a side effect the driver now writes all three DMA address registers
regardless of the number of planes, and initializes unused addresses to
zero.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c   |  7 ++++--
 drivers/media/platform/vsp1/vsp1_rpf.c   | 37 ++++++++++----------------------
 drivers/media/platform/vsp1/vsp1_rwpf.c  | 26 ++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h  | 11 ++++++++--
 drivers/media/platform/vsp1/vsp1_video.c |  9 ++++++--
 drivers/media/platform/vsp1/vsp1_wpf.c   | 10 ++++-----
 6 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 22f67360b750..96ad8072d5d6 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -420,12 +420,15 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	rpf->location.left = dst->left;
 	rpf->location.top = dst->top;
 
-	/* Set the memory buffer address. */
+	/* Set the memory buffer address but don't apply the values to the
+	 * hardware as the crop offsets haven't been computed yet.
+	 */
 	memory.num_planes = fmtinfo->planes;
 	memory.addr[0] = mem[0];
 	memory.addr[1] = mem[1];
+	memory.addr[2] = 0;
 
-	rpf->ops->set_memory(rpf, &memory);
+	vsp1_rwpf_set_memory(rpf, &memory, false);
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 8c7c385ec046..3509202f1b4a 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -69,25 +69,20 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	pstride = format->plane_fmt[0].bytesperline
 		<< VI6_RPF_SRCM_PSTRIDE_Y_SHIFT;
 
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
-		       rpf->buf_addr[0] + rpf->offsets[0]);
-
 	if (format->num_planes > 1) {
 		rpf->offsets[1] = crop->top * format->plane_fmt[1].bytesperline
 				+ crop->left * fmtinfo->bpp[1] / 8;
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
-
-		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
-			       rpf->buf_addr[1] + rpf->offsets[1]);
-
-		if (format->num_planes > 2)
-			vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
-				       rpf->buf_addr[2] + rpf->offsets[1]);
+	} else {
+		rpf->offsets[1] = 0;
 	}
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
 
+	/* Now that the offsets have been computed program the DMA addresses. */
+	rpf->ops->set_memory(rpf);
+
 	/* Format */
 	infmt = VI6_RPF_INFMT_CIPM
 	      | (fmtinfo->hwfmt << VI6_RPF_INFMT_RDFMT_SHIFT);
@@ -154,24 +149,14 @@ static struct v4l2_subdev_ops rpf_ops = {
  * Video Device Operations
  */
 
-static void rpf_set_memory(struct vsp1_rwpf *rpf, struct vsp1_rwpf_memory *mem)
+static void rpf_set_memory(struct vsp1_rwpf *rpf)
 {
-	unsigned int i;
-
-	for (i = 0; i < 3; ++i)
-		rpf->buf_addr[i] = mem->addr[i];
-
-	if (!vsp1_entity_is_streaming(&rpf->entity))
-		return;
-
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
-		       mem->addr[0] + rpf->offsets[0]);
-	if (mem->num_planes > 1)
-		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
-			       mem->addr[1] + rpf->offsets[1]);
-	if (mem->num_planes > 2)
-		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
-			       mem->addr[2] + rpf->offsets[1]);
+		       rpf->buf_addr[0] + rpf->offsets[0]);
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
+		       rpf->buf_addr[1] + rpf->offsets[1]);
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
+		       rpf->buf_addr[2] + rpf->offsets[1]);
 }
 
 static const struct vsp1_rwpf_operations rpf_vdev_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index ba50386db35c..54070ccdc2ff 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -265,3 +265,29 @@ int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf)
 
 	return rwpf->ctrls.error;
 }
+
+/* -----------------------------------------------------------------------------
+ * Buffers
+ */
+
+/**
+ * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
+ * @rwpf: the [RW]PF instance
+ * @mem: DMA memory addresses
+ * @apply: whether to apply the configuration to the hardware
+ *
+ * This function stores the DMA addresses for all planes in the rwpf instance
+ * and optionally applies the configuration to hardware registers if the apply
+ * argument is set to true.
+ */
+void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf, struct vsp1_rwpf_memory *mem,
+			  bool apply)
+{
+	unsigned int i;
+
+	for (i = 0; i < 3; ++i)
+		rwpf->buf_addr[i] = mem->addr[i];
+
+	if (apply)
+		rwpf->ops->set_memory(rwpf);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 66af2a06dd8b..bda0416dc7db 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -34,9 +34,13 @@ struct vsp1_rwpf_memory {
 	unsigned int length[3];
 };
 
+/**
+ * struct vsp1_rwpf_operations - RPF and WPF operations
+ * @set_memory: Setup memory buffer access. This operation applies the settings
+ *		stored in the rwpf buf_addr field to the hardware.
+ */
 struct vsp1_rwpf_operations {
-	void (*set_memory)(struct vsp1_rwpf *rwpf,
-			   struct vsp1_rwpf_memory *mem);
+	void (*set_memory)(struct vsp1_rwpf *rwpf);
 };
 
 struct vsp1_rwpf {
@@ -93,4 +97,7 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_selection *sel);
 
+void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf, struct vsp1_rwpf_memory *mem,
+			  bool apply);
+
 #endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index b97bbdb1a256..96b04fcd33ae 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -443,7 +443,7 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	video->rwpf->ops->set_memory(video->rwpf, &buf->mem);
+	vsp1_rwpf_set_memory(video->rwpf, &buf->mem, true);
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
@@ -522,6 +522,11 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 			return -EINVAL;
 	}
 
+	for ( ; i < 3; ++i) {
+		buf->mem.addr[i] = 0;
+		buf->mem.length[i] = 0;
+	}
+
 	return 0;
 }
 
@@ -544,7 +549,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
-	video->rwpf->ops->set_memory(video->rwpf, &buf->mem);
+	vsp1_rwpf_set_memory(video->rwpf, &buf->mem, true);
 	pipe->buffers_ready |= 1 << video->pipe_index;
 
 	if (vb2_is_streaming(&video->queue) &&
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index a7101f700d9e..978dd6cda9d3 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -157,13 +157,11 @@ static struct v4l2_subdev_ops wpf_ops = {
  * Video Device Operations
  */
 
-static void wpf_set_memory(struct vsp1_rwpf *wpf, struct vsp1_rwpf_memory *mem)
+static void wpf_set_memory(struct vsp1_rwpf *wpf)
 {
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, mem->addr[0]);
-	if (mem->num_planes > 1)
-		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, mem->addr[1]);
-	if (mem->num_planes > 2)
-		vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, mem->addr[2]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, wpf->buf_addr[0]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, wpf->buf_addr[1]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->buf_addr[2]);
 }
 
 static const struct vsp1_rwpf_operations wpf_vdev_ops = {
-- 
2.7.3

