Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab1HEHrg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 03:47:36 -0400
Date: Fri, 5 Aug 2011 09:47:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/6 v4] V4L: vb2: change .queue_setup() argument to unsigned
 int
In-Reply-To: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
Message-ID: <Pine.LNX.4.64.1108050926210.26715@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for the forthcoming VIDIOC_CREATE_BUFS ioctl change
the type of the sizes[] argument of the .queue_setup() vb2 operation
from unsigned long to unsigned int to match with the __u32 type of
buffer size variables elsewhere in V4L2.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/atmel-isi.c              |    2 +-
 drivers/media/video/marvell-ccic/mcam-core.c |    2 +-
 drivers/media/video/mem2mem_testdev.c        |    2 +-
 drivers/media/video/mx3_camera.c             |    2 +-
 drivers/media/video/pwc/pwc-if.c             |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |    2 +-
 drivers/media/video/s5p-tv/mixer_video.c     |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c   |    4 ++--
 drivers/media/video/videobuf2-core.c         |    6 +++---
 drivers/media/video/vivi.c                   |    2 +-
 include/media/videobuf2-core.h               |    2 +-
 14 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 3e3d4cc..1cc05e9 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -250,7 +250,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
 	Videobuf operations
    ------------------------------------------------------------------*/
 static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
+				unsigned int *nplanes, unsigned int sizes[],
 				void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 83c1451..744cf37 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -884,7 +884,7 @@ static int mcam_read_setup(struct mcam_camera *cam)
  */
 
 static int mcam_vb_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
-		unsigned int *num_planes, unsigned long sizes[],
+		unsigned int *num_planes, unsigned int sizes[],
 		void *alloc_ctxs[])
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 166bf93..0d0c0d5 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -739,7 +739,7 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
  */
 
 static int m2mtest_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
+				unsigned int *nplanes, unsigned int sizes[],
 				void *alloc_ctxs[])
 {
 	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vq);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 3f37522f..2902c02 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -192,7 +192,7 @@ static void mx3_cam_dma_done(void *arg)
  */
 static int mx3_videobuf_setup(struct vb2_queue *vq,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned long sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 51ca358..a7e4f56 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -745,7 +745,7 @@ static int pwc_video_mmap(struct file *file, struct vm_area_struct *vma)
 /* Videobuf2 operations */
 
 static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
+				unsigned int *nplanes, unsigned int sizes[],
 				void *alloc_ctxs[])
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vq);
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 0d730e5..e6afe5f 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -265,7 +265,7 @@ static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
 }
 
 static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
-		       unsigned int *num_planes, unsigned long sizes[],
+		       unsigned int *num_planes, unsigned int sizes[],
 		       void *allocators[])
 {
 	struct fimc_ctx *ctx = vq->drv_priv;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index aa55066..36d127f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -692,7 +692,7 @@ static void fimc_job_abort(void *priv)
 }
 
 static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
-			    unsigned int *num_planes, unsigned long sizes[],
+			    unsigned int *num_planes, unsigned int sizes[],
 			    void *allocators[])
 {
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index b2c5052..dbc94b8 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -745,7 +745,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 };
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq, unsigned int *buf_count,
-			       unsigned int *plane_count, unsigned long psize[],
+			       unsigned int *plane_count, unsigned int psize[],
 			       void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index fee094a..019a9e7 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1514,7 +1514,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		       unsigned int *buf_count, unsigned int *plane_count,
-		       unsigned long psize[], void *allocators[])
+		       unsigned int psize[], void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 43ac22f..8bea0f3 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -728,7 +728,7 @@ static const struct v4l2_file_operations mxr_fops = {
 };
 
 static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-	unsigned int *nplanes, unsigned long sizes[],
+	unsigned int *nplanes, unsigned int sizes[],
 	void *alloc_ctxs[])
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index dedc981..26d0248 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -194,7 +194,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
  */
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			unsigned int *count, unsigned int *num_planes,
-			unsigned long sizes[], void *alloc_ctxs[])
+			unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -219,7 +219,7 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			*count = pcdev->video_limit / PAGE_ALIGN(sizes[0]);
 	}
 
-	dev_dbg(icd->parent, "count=%d, size=%lu\n", *count, sizes[0]);
+	dev_dbg(icd->parent, "count=%d, size=%u\n", *count, sizes[0]);
 
 	return 0;
 }
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index fb7a3ac..7045d1f 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -44,7 +44,7 @@ module_param(debug, int, 0644);
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb,
-				unsigned long *plane_sizes)
+				unsigned int *plane_sizes)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	void *mem_priv;
@@ -142,7 +142,7 @@ static void __setup_offsets(struct vb2_queue *q)
  */
 static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			     unsigned int num_buffers, unsigned int num_planes,
-			     unsigned long plane_sizes[])
+			     unsigned int plane_sizes[])
 {
 	unsigned int buffer;
 	struct vb2_buffer *vb;
@@ -455,7 +455,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	unsigned int num_buffers, num_planes;
-	unsigned long plane_sizes[VIDEO_MAX_PLANES];
+	unsigned int plane_sizes[VIDEO_MAX_PLANES];
 	int ret = 0;
 
 	if (q->fileio) {
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index a848bd2..26eda47 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -651,7 +651,7 @@ static void vivi_stop_generating(struct vivi_dev *dev)
 	Videobuf operations
    ------------------------------------------------------------------*/
 static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
-				unsigned int *nplanes, unsigned long sizes[],
+				unsigned int *nplanes, unsigned int sizes[],
 				void *alloc_ctxs[])
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 65946c5..7dd6bca 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -213,7 +213,7 @@ struct vb2_buffer {
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
-			   unsigned int *num_planes, unsigned long sizes[],
+			   unsigned int *num_planes, unsigned int sizes[],
 			   void *alloc_ctxs[]);
 
 	void (*wait_prepare)(struct vb2_queue *q);
-- 
1.7.2.5

