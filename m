Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1HaSDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:03:07 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 4/9 v6] V4L: vb2: prepare to support multi-size buffers
Date: Wed, 31 Aug 2011 20:02:43 +0200
Message-Id: <1314813768-27752-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for the forthcoming VIDIOC_CREATE_BUFS ioctl add a
"const struct v4l2_format *" argument to the .queue_setup() vb2
operation.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/atmel-isi.c              |    6 +++---
 drivers/media/video/marvell-ccic/mcam-core.c |    3 ++-
 drivers/media/video/mem2mem_testdev.c        |    7 ++++---
 drivers/media/video/mx3_camera.c             |    1 +
 drivers/media/video/pwc/pwc-if.c             |    6 +++---
 drivers/media/video/s5p-fimc/fimc-capture.c  |    6 +++---
 drivers/media/video/s5p-fimc/fimc-core.c     |    6 +++---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |    7 ++++---
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |    5 +++--
 drivers/media/video/s5p-tv/mixer_video.c     |    4 ++--
 drivers/media/video/sh_mobile_ceu_camera.c   |    1 +
 drivers/media/video/videobuf2-core.c         |    6 +++---
 drivers/media/video/vivi.c                   |    6 +++---
 include/media/videobuf2-core.h               |    6 +++---
 14 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 3e3d4cc..7c41a87 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -249,9 +249,9 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
-static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
-				void *alloc_ctxs[])
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 83c1451..65517c8 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -883,7 +883,8 @@ static int mcam_read_setup(struct mcam_camera *cam)
  * Videobuf2 interface code.
  */
 
-static int mcam_vb_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
+static int mcam_vb_queue_setup(struct vb2_queue *vq,
+		const struct v4l2_format *fmt, unsigned int *nbufs,
 		unsigned int *num_planes, unsigned long sizes[],
 		void *alloc_ctxs[])
 {
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 166bf93..c0e633f 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -738,9 +738,10 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
  * Queue operations
  */
 
-static int m2mtest_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
-				void *alloc_ctxs[])
+static int m2mtest_queue_setup(struct vb2_queue *vq,
+				const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vq);
 	struct m2mtest_q_data *q_data;
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 3f37522f..6bfbce9 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -191,6 +191,7 @@ static void mx3_cam_dma_done(void *arg)
  * Calculate the __buffer__ (not data) size and number of buffers.
  */
 static int mx3_videobuf_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned long sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 51ca358..d6ff2c9 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -744,9 +744,9 @@ static int pwc_video_mmap(struct file *file, struct vm_area_struct *vma)
 /***************************************************************************/
 /* Videobuf2 operations */
 
-static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
-				void *alloc_ctxs[])
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 0d730e5..36d71a1 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -264,9 +264,9 @@ static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
 	return fr->f_width * fr->f_height * fr->fmt->depth[plane] / 8;
 }
 
-static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
-		       unsigned int *num_planes, unsigned long sizes[],
-		       void *allocators[])
+static int queue_setup(struct vb2_queue *vq,  const struct v4l2_format *pfmt,
+		       unsigned int *num_buffers, unsigned int *num_planes,
+		       unsigned long sizes[], void *allocators[])
 {
 	struct fimc_ctx *ctx = vq->drv_priv;
 	struct fimc_fmt *fmt = ctx->d_frame.fmt;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index aa55066..26348e2 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -691,9 +691,9 @@ static void fimc_job_abort(void *priv)
 	fimc_m2m_shutdown(priv);
 }
 
-static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
-			    unsigned int *num_planes, unsigned long sizes[],
-			    void *allocators[])
+static int fimc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			    unsigned int *num_buffers, unsigned int *num_planes,
+			    unsigned long sizes[], void *allocators[])
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
 	struct fimc_frame *f;
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index b2c5052..06f317c 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -744,9 +744,10 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_g_crop = vidioc_g_crop,
 };
 
-static int s5p_mfc_queue_setup(struct vb2_queue *vq, unsigned int *buf_count,
-			       unsigned int *plane_count, unsigned long psize[],
-			       void *allocators[])
+static int s5p_mfc_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt, unsigned int *buf_count,
+			unsigned int *plane_count, unsigned long psize[],
+			void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index fee094a..0c1a22f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1513,8 +1513,9 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 }
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
-		       unsigned int *buf_count, unsigned int *plane_count,
-		       unsigned long psize[], void *allocators[])
+			const struct v4l2_format *fmt,
+			unsigned int *buf_count, unsigned int *plane_count,
+			unsigned long psize[], void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 43ac22f..74b86aa 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -727,8 +727,8 @@ static const struct v4l2_file_operations mxr_fops = {
 	.unlocked_ioctl = video_ioctl2,
 };
 
-static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-	unsigned int *nplanes, unsigned long sizes[],
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+	unsigned int *nbuffers, unsigned int *nplanes, unsigned long sizes[],
 	void *alloc_ctxs[])
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 8b344d4..db3a24d 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -193,6 +193,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
  *  Videobuf operations
  */
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned long sizes[], void *alloc_ctxs[])
 {
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 4153da2..7a9ac8a 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -525,7 +525,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 	 * Ask the driver how many buffers and planes per buffer it requires.
 	 * Driver also sets the size and allocator context for each plane.
 	 */
-	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
+	ret = call_qop(q, queue_setup, q, NULL, &num_buffers, &num_planes,
 		       plane_sizes, q->alloc_ctx);
 	if (ret)
 		return ret;
@@ -545,8 +545,8 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		unsigned int orig_num_buffers;
 
 		orig_num_buffers = num_buffers = ret;
-		ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
-			       plane_sizes, q->alloc_ctx);
+		ret = call_qop(q, queue_setup, q, NULL, &num_buffers,
+			       &num_planes, plane_sizes, q->alloc_ctx);
 		if (ret)
 			goto free_mem;
 
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index a848bd2..0b24508 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -650,9 +650,9 @@ static void vivi_stop_generating(struct vivi_dev *dev)
 /* ------------------------------------------------------------------
 	Videobuf operations
    ------------------------------------------------------------------*/
-static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
-				void *alloc_ctxs[])
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long size;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 65946c5..d043132 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -212,9 +212,9 @@ struct vb2_buffer {
  *			the buffer back by calling vb2_buffer_done() function
  */
 struct vb2_ops {
-	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
-			   unsigned int *num_planes, unsigned long sizes[],
-			   void *alloc_ctxs[]);
+	int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
+			   unsigned int *num_buffers, unsigned int *num_planes,
+			   unsigned long sizes[], void *alloc_ctxs[]);
 
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
-- 
1.7.2.5

