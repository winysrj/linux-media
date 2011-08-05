Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1HEVhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 17:37:14 -0400
Date: Fri, 5 Aug 2011 23:36:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/6 v5] V4L: vb2: prepare to support multi-size buffers
In-Reply-To: <Pine.LNX.4.64.1108050926210.26715@axis700.grange>
Message-ID: <Pine.LNX.4.64.1108052335140.26715@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <Pine.LNX.4.64.1108050926210.26715@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for the forthcoming VIDIOC_CREATE_BUFS ioctl change
the type of the sizes[] argument of the .queue_setup() vb2 operation
from unsigned long to unsigned int to match with the __u32 type of
buffer size variables elsewhere in V4L2. Drivers will also need the
fourcc value, passed along with the new ioctl(), to correctly set
up the queue, it has to be supplied with the .buf_init() vb2 method.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v5: the fourcc value, that we now send with the CREATE_BUFS ioctl() has to 
be passed on to the drivers. Add it to the vb2 .buf_init() method.

 drivers/media/video/atmel-isi.c              |    4 ++--
 drivers/media/video/marvell-ccic/mcam-core.c |    4 ++--
 drivers/media/video/mem2mem_testdev.c        |    2 +-
 drivers/media/video/mx3_camera.c             |    4 ++--
 drivers/media/video/pwc/pwc-if.c             |    4 ++--
 drivers/media/video/s5p-fimc/fimc-capture.c  |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |    4 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |    4 ++--
 drivers/media/video/s5p-tv/mixer_video.c     |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c   |    6 +++---
 drivers/media/video/videobuf2-core.c         |   10 +++++-----
 drivers/media/video/vivi.c                   |    4 ++--
 include/media/videobuf2-core.h               |    4 ++--
 14 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 3e3d4cc..11b6d54 100644
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
@@ -295,7 +295,7 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
+static int buffer_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
 
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 83c1451..262b861 100644
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
@@ -1000,7 +1000,7 @@ static const struct vb2_ops mcam_vb2_ops = {
  * Scatter/gather mode uses all of the above functions plus a
  * few extras to deal with DMA mapping.
  */
-static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
+static int mcam_vb_sg_buf_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
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
index 3f37522f..b48b2a4 100644
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
@@ -387,7 +387,7 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&mx3_cam->lock, flags);
 }
 
-static int mx3_videobuf_init(struct vb2_buffer *vb)
+static int mx3_videobuf_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	struct mx3_camera_buffer *buf = to_mx3_vb(vb);
 	/* This is for locking debugging only */
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 51ca358..5b63910 100644
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
@@ -762,7 +762,7 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
+static int buffer_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 
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
index b2c5052..f5b590b 100644
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
@@ -813,7 +813,7 @@ static void s5p_mfc_lock(struct vb2_queue *q)
 	mutex_lock(&dev->mfc_mutex);
 }
 
-static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+static int s5p_mfc_buf_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index fee094a..755c353 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1514,7 +1514,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		       unsigned int *buf_count, unsigned int *plane_count,
-		       unsigned long psize[], void *allocators[])
+		       unsigned int psize[], void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
 
@@ -1570,7 +1570,7 @@ static void s5p_mfc_lock(struct vb2_queue *q)
 	mutex_lock(&dev->mfc_mutex);
 }
 
-static int s5p_mfc_buf_init(struct vb2_buffer *vb)
+static int s5p_mfc_buf_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
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
index dedc981..583d771 100644
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
@@ -421,7 +421,7 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 	spin_unlock_irq(&pcdev->lock);
 }
 
-static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
+static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	/* This is for locking debugging only */
 	INIT_LIST_HEAD(&to_ceu_vb(vb)->queue);
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index fb7a3ac..c5fcc6a 100644
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
@@ -181,7 +181,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 			 * callback, if given. An error in initialization
 			 * results in queue setup failure.
 			 */
-			ret = call_qop(q, buf_init, vb);
+			ret = call_qop(q, buf_init, vb, 0);
 			if (ret) {
 				dprintk(1, "Buffer %d %p initialization"
 					" failed\n", buffer, vb);
@@ -455,7 +455,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	unsigned int num_buffers, num_planes;
-	unsigned long plane_sizes[VIDEO_MAX_PLANES];
+	unsigned int plane_sizes[VIDEO_MAX_PLANES];
 	int ret = 0;
 
 	if (q->fileio) {
@@ -773,7 +773,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	 * Call driver-specific initialization on the newly acquired buffer,
 	 * if provided.
 	 */
-	ret = call_qop(q, buf_init, vb);
+	ret = call_qop(q, buf_init, vb, 0);
 	if (ret) {
 		dprintk(1, "qbuf: buffer initialization failed\n");
 		goto err;
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index a848bd2..e25ac97 100644
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
@@ -680,7 +680,7 @@ static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	return 0;
 }
 
-static int buffer_init(struct vb2_buffer *vb)
+static int buffer_init(struct vb2_buffer *vb, u32 fourcc)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 65946c5..b0f68fb 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -213,13 +213,13 @@ struct vb2_buffer {
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
-			   unsigned int *num_planes, unsigned long sizes[],
+			   unsigned int *num_planes, unsigned int sizes[],
 			   void *alloc_ctxs[]);
 
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
 
-	int (*buf_init)(struct vb2_buffer *vb);
+	int (*buf_init)(struct vb2_buffer *vb, u32 fourcc);
 	int (*buf_prepare)(struct vb2_buffer *vb);
 	int (*buf_finish)(struct vb2_buffer *vb);
 	void (*buf_cleanup)(struct vb2_buffer *vb);
-- 
1.7.2.5

