Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:61203 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754113AbdHWO6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 10:58:39 -0400
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id v7NEmPsn012471
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 14:48:27 GMT
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [GIT PULL FOR v4.14] v2: More constify, some fixes
Message-ID: <84bd1126-a313-6477-b79c-2896eec62db9@cisco.com>
Date: Wed, 23 Aug 2017 16:48:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some more constify stuff and some fixes. The vb2 patch required to fix a
venus bug is the most interesting change here.

I tried the -p flag for this pull request. I'm not convinced how useful it
is since it doesn't include the commit logs.

Regards,

	Hans

Change since the v1 pull request (marked that as superseded):

Added fix "media: venus: venc: set correct resolution on compressed stream"
(with a CC to stable for 4.13)


The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14k

for you to fetch changes up to 373ad449f9d3ad8a9c701034920a43f71885c98b:

  venus: fix copy/paste error in return_buf_error (2017-08-23 16:45:47 +0200)

----------------------------------------------------------------
Arvind Yadav (3):
      saa7146: constify videobuf_queue_ops structures
      pci: constify videobuf_queue_ops structures
      platform: constify videobuf_queue_ops structures

Bhumika Goyal (2):
      bt8xx: Make i2c_algo_bit_data const
      cx18: Make i2c_algo_bit_data const

Colin Ian King (1):
      em28xx: calculate left volume level correctly

Gustavo A. R. Silva (1):
      venus: fix copy/paste error in return_buf_error

Stanimir Varbanov (2):
      media: vb2: add bidirectional flag in vb2_queue
      media: venus: venc: set correct resolution on compressed stream

 drivers/media/common/saa7146/saa7146_vbi.c     |  2 +-
 drivers/media/common/saa7146/saa7146_video.c   |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c          |  2 +-
 drivers/media/pci/bt8xx/bttv-i2c.c             |  2 +-
 drivers/media/pci/cx18/cx18-i2c.c              |  2 +-
 drivers/media/platform/davinci/vpfe_capture.c  |  2 +-
 drivers/media/platform/fsl-viu.c               |  2 +-
 drivers/media/platform/qcom/venus/helpers.c    |  2 +-
 drivers/media/platform/qcom/venus/venc.c       |  8 +++++---
 drivers/media/usb/em28xx/em28xx-audio.c        |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c       | 17 ++++++++---------
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  3 ++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     |  6 ++++--
 drivers/media/v4l2-core/videobuf2-vmalloc.c    |  6 ++++--
 include/media/videobuf2-core.h                 | 13 +++++++++++++
 15 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index 3553ac4cba5c..d79e4d7ecd9f 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -308,7 +308,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	saa7146_dma_free(dev,q,buf);
 }

-static struct videobuf_queue_ops vbi_qops = {
+static const struct videobuf_queue_ops vbi_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index b3b29d4f36ed..37b4654dc21c 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1187,7 +1187,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	release_all_pagetables(dev, buf);
 }

-static struct videobuf_queue_ops video_qops = {
+static const struct videobuf_queue_ops video_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 40110be4e986..227086a2e99c 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1702,7 +1702,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	bttv_dma_free(q,fh->btv,buf);
 }

-static struct videobuf_queue_ops bttv_video_qops = {
+static const struct videobuf_queue_ops bttv_video_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index 274fd036b306..eccd1e3d717a 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -97,7 +97,7 @@ static int bttv_bit_getsda(void *data)
 	return state;
 }

-static struct i2c_algo_bit_data bttv_i2c_algo_bit_template = {
+static const struct i2c_algo_bit_data bttv_i2c_algo_bit_template = {
 	.setsda  = bttv_bit_setsda,
 	.setscl  = bttv_bit_setscl,
 	.getsda  = bttv_bit_getsda,
diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index b89fbcbfb491..a99bd9997f33 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -216,7 +216,7 @@ static struct i2c_adapter cx18_i2c_adap_template = {
 #define CX18_SCL_PERIOD (10) /* usecs. 10 usec is period for a 100 KHz clock */
 #define CX18_ALGO_BIT_TIMEOUT (2) /* seconds */

-static struct i2c_algo_bit_data cx18_i2c_algo_template = {
+static const struct i2c_algo_bit_data cx18_i2c_algo_template = {
 	.setsda		= cx18_setsda,
 	.setscl		= cx18_setscl,
 	.getsda		= cx18_getsda,
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index b1bf4a7e8eb7..6792da16d9c7 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1288,7 +1288,7 @@ static void vpfe_videobuf_release(struct videobuf_queue *vq,
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }

-static struct videobuf_queue_ops vpfe_videobuf_qops = {
+static const struct videobuf_queue_ops vpfe_videobuf_qops = {
 	.buf_setup      = vpfe_videobuf_setup,
 	.buf_prepare    = vpfe_videobuf_prepare,
 	.buf_queue      = vpfe_videobuf_queue,
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index f7b88e58d00e..2e06dd564442 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -549,7 +549,7 @@ static void buffer_release(struct videobuf_queue *vq,
 	free_buffer(vq, buf);
 }

-static struct videobuf_queue_ops viu_video_qops = {
+static const struct videobuf_queue_ops viu_video_qops = {
 	.buf_setup      = buffer_setup,
 	.buf_prepare    = buffer_prepare,
 	.buf_queue      = buffer_queue,
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 5f4434c0a8f1..2d6187904552 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -243,7 +243,7 @@ static void return_buf_error(struct venus_inst *inst,
 	if (vbuf->vb2_buf.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
 	else
-		v4l2_m2m_src_buf_remove_by_buf(m2m_ctx, vbuf);
+		v4l2_m2m_dst_buf_remove_by_buf(m2m_ctx, vbuf);

 	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 }
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 39748e7a08e4..01af1ac89edf 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -289,7 +289,7 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	pixmp->height = clamp(pixmp->height, inst->cap_height.min,
 			      inst->cap_height.max);

-	if (inst->core->res->hfi_version == HFI_VERSION_1XX)
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		pixmp->height = ALIGN(pixmp->height, 32);

 	pixmp->width = ALIGN(pixmp->width, 2);
@@ -747,8 +747,8 @@ static int venc_init_session(struct venus_inst *inst)
 	if (ret)
 		return ret;

-	ret = venus_helper_set_input_resolution(inst, inst->out_width,
-						inst->out_height);
+	ret = venus_helper_set_input_resolution(inst, inst->width,
+						inst->height);
 	if (ret)
 		goto deinit;

@@ -1010,6 +1010,8 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 1;
 	src_vq->dev = inst->core->dev;
+	if (inst->core->res->hfi_version == HFI_VERSION_1XX)
+		src_vq->bidirectional = 1;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 261620a57420..4628d73f46f2 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -564,7 +564,7 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 		val, (int)kcontrol->private_value);

 	value->value.integer.value[0] = 0x1f - (val & 0x1f);
-	value->value.integer.value[1] = 0x1f - ((val << 8) & 0x1f);
+	value->value.integer.value[1] = 0x1f - ((val >> 8) & 0x1f);

 	return 0;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0924594989b4..cb115ba6a1d2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -194,8 +194,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 	int ret = -ENOMEM;
@@ -209,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)

 		mem_priv = call_ptr_memop(vb, alloc,
 				q->alloc_devs[plane] ? : q->dev,
-				q->dma_attrs, size, dma_dir, q->gfp_flags);
+				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
 		if (IS_ERR_OR_NULL(mem_priv)) {
 			if (mem_priv)
 				ret = PTR_ERR(mem_priv);
@@ -978,8 +976,6 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;

 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1030,7 +1026,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 		mem_priv = call_ptr_memop(vb, get_userptr,
 				q->alloc_devs[plane] ? : q->dev,
 				planes[plane].m.userptr,
-				planes[plane].length, dma_dir);
+				planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed acquiring userspace memory for plane %d\n",
 				plane);
@@ -1096,8 +1092,6 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;

 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1156,7 +1150,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, attach_dmabuf,
 				q->alloc_devs[plane] ? : q->dev,
-				dbuf, planes[plane].length, dma_dir);
+				dbuf, planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed to attach dmabuf\n");
 			ret = PTR_ERR(mem_priv);
@@ -2003,6 +1997,11 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_buffer);

+	if (q->bidirectional)
+		q->dma_dir = DMA_BIDIRECTIONAL;
+	else
+		q->dma_dir = q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_queue_init);
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 5b90a66b9e78..9f389f36566d 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -508,7 +508,8 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->dma_dir = dma_dir;

 	offset = vaddr & ~PAGE_MASK;
-	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE ||
+					       dma_dir == DMA_BIDIRECTIONAL);
 	if (IS_ERR(vec)) {
 		ret = PTR_ERR(vec);
 		goto fail_buf;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 54f33938d45b..6808231a6bdc 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -239,7 +239,8 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 	buf->dma_sgt = &buf->sg_table;
-	vec = vb2_create_framevec(vaddr, size, buf->dma_dir == DMA_FROM_DEVICE);
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE ||
+					       dma_dir == DMA_BIDIRECTIONAL);
 	if (IS_ERR(vec))
 		goto userptr_fail_pfnvec;
 	buf->vec = vec;
@@ -292,7 +293,8 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(buf->dma_sgt);
 	while (--i >= 0) {
-		if (buf->dma_dir == DMA_FROM_DEVICE)
+		if (buf->dma_dir == DMA_FROM_DEVICE ||
+		    buf->dma_dir == DMA_BIDIRECTIONAL)
 			set_page_dirty_lock(buf->pages[i]);
 	}
 	vb2_destroy_framevec(buf->vec);
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index 6bc130fe84f6..3a7c80cd1a17 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -87,7 +87,8 @@ static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
 	buf->dma_dir = dma_dir;
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
-	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE ||
+					       dma_dir == DMA_BIDIRECTIONAL);
 	if (IS_ERR(vec)) {
 		ret = PTR_ERR(vec);
 		goto fail_pfnvec_create;
@@ -137,7 +138,8 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 		pages = frame_vector_pages(buf->vec);
 		if (vaddr)
 			vm_unmap_ram((void *)vaddr, n_pages);
-		if (buf->dma_dir == DMA_FROM_DEVICE)
+		if (buf->dma_dir == DMA_FROM_DEVICE ||
+		    buf->dma_dir == DMA_BIDIRECTIONAL)
 			for (i = 0; i < n_pages; i++)
 				set_page_dirty_lock(pages[i]);
 	} else {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cb97c224be73..ef9b64398c8c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -427,6 +427,16 @@ struct vb2_buf_ops {
  * @dev:	device to use for the default allocation context if the driver
  *		doesn't fill in the @alloc_devs array.
  * @dma_attrs:	DMA attributes to use for the DMA.
+ * @bidirectional: when this flag is set the DMA direction for the buffers of
+ *		this queue will be overridden with DMA_BIDIRECTIONAL direction.
+ *		This is useful in cases where the hardware (firmware) writes to
+ *		a buffer which is mapped as read (DMA_TO_DEVICE), or reads from
+ *		buffer which is mapped for write (DMA_FROM_DEVICE) in order
+ *		to satisfy some internal hardware restrictions or adds a padding
+ *		needed by the processing algorithm. In case the DMA mapping is
+ *		not bidirectional but the hardware (firmware) trying to access
+ *		the buffer (in the opposite direction) this could lead to an
+ *		IOMMU protection faults.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -465,6 +475,7 @@ struct vb2_buf_ops {
  * Private elements (won't appear at the uAPI book):
  * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
  * @memory:	current memory type used
+ * @dma_dir:	DMA mapping direction.
  * @bufs:	videobuf buffer structures
  * @num_buffers: number of allocated/used buffers
  * @queued_list: list of buffers currently queued from userspace
@@ -495,6 +506,7 @@ struct vb2_queue {
 	unsigned int			io_modes;
 	struct device			*dev;
 	unsigned long			dma_attrs;
+	unsigned			bidirectional:1;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
@@ -516,6 +528,7 @@ struct vb2_queue {
 	/* private: internal use only */
 	struct mutex			mmap_lock;
 	unsigned int			memory;
+	enum dma_data_direction		dma_dir;
 	struct vb2_buffer		*bufs[VB2_MAX_FRAME];
 	unsigned int			num_buffers;
