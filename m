Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1658 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbaJWLWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 07:22:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 13/15] v4l: convert vb2_plane_vaddr to vb2_plane_begin_cpu_access
Date: Thu, 23 Oct 2014 13:21:40 +0200
Message-Id: <1414063302-26903-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
References: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c          | 16 ++++++--
 drivers/media/parport/bw-qcam.c                    |  5 ++-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |  6 ++-
 drivers/media/platform/davinci/vpbe_display.c      |  3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    | 26 ++++++++++++-
 drivers/media/platform/mem2mem_testdev.c           | 22 ++++++++---
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 17 +++++---
 drivers/media/platform/soc_camera/mx2_camera.c     | 24 +++++++-----
 drivers/media/platform/soc_camera/mx3_camera.c     | 10 ++++-
 drivers/media/platform/soc_camera/rcar_vin.c       |  4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 14 +++++--
 drivers/media/platform/vivid/vivid-kthread-cap.c   | 13 +++++--
 drivers/media/platform/vivid/vivid-sdr-cap.c       |  3 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |  6 ++-
 drivers/media/platform/vivid/vivid-vbi-out.c       |  3 +-
 drivers/media/usb/airspy/airspy.c                  | 21 ++++++++--
 drivers/media/usb/em28xx/em28xx-vbi.c              | 13 +++++--
 drivers/media/usb/em28xx/em28xx-video.c            | 12 ++++--
 drivers/media/usb/go7007/go7007-driver.c           |  7 +---
 drivers/media/usb/go7007/go7007-priv.h             |  1 +
 drivers/media/usb/go7007/go7007-v4l2.c             |  6 ++-
 drivers/media/usb/hackrf/hackrf.c                  | 21 ++++++++--
 drivers/media/usb/msi2500/msi2500.c                | 22 +++++++++--
 drivers/media/usb/pwc/pwc-if.c                     |  5 ++-
 drivers/media/usb/pwc/pwc-uncompress.c             |  2 +-
 drivers/media/usb/pwc/pwc.h                        |  1 +
 drivers/media/usb/s2255/s2255drv.c                 | 12 +++++-
 drivers/media/usb/stk1160/stk1160-v4l.c            | 45 ++++++++++++++--------
 drivers/media/usb/stk1160/stk1160-video.c          |  1 +
 drivers/media/usb/usbtv/usbtv-video.c              | 19 +++++++--
 drivers/media/usb/usbtv/usbtv.h                    |  1 +
 drivers/media/usb/uvc/uvc_queue.c                  |  5 ++-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  5 +--
 drivers/usb/gadget/function/uvc_queue.c            | 10 ++++-
 34 files changed, 281 insertions(+), 100 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 7bf98cf..9e1fafd 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -105,6 +105,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 struct rtl2832_sdr_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
+	void *vaddr;
 };
 
 struct rtl2832_sdr_state {
@@ -415,7 +416,6 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 	}
 
 	if (likely(urb->actual_length > 0)) {
-		void *ptr;
 		unsigned int len;
 		/* get free framebuffer */
 		fbuf = rtl2832_sdr_get_next_fill_buf(s);
@@ -428,8 +428,7 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		len = rtl2832_sdr_convert_stream(s, ptr, urb->transfer_buffer,
+		len = rtl2832_sdr_convert_stream(s, fbuf->vaddr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
@@ -644,12 +643,20 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 static int rtl2832_sdr_buf_prepare(struct vb2_buffer *vb)
 {
 	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct rtl2832_sdr_frame_buf *buf =
+			container_of(vb, struct rtl2832_sdr_frame_buf, vb);
 
 	/* Don't allow queing new buffers after device disconnection */
 	if (!s->udev)
 		return -ENODEV;
 
-	return 0;
+	buf->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->vaddr ? 0 : -ENOMEM;
+}
+
+static void rtl2832_sdr_buf_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
@@ -1073,6 +1080,7 @@ static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 static struct vb2_ops rtl2832_sdr_vb2_ops = {
 	.queue_setup            = rtl2832_sdr_queue_setup,
 	.buf_prepare            = rtl2832_sdr_buf_prepare,
+	.buf_finish             = rtl2832_sdr_buf_finish,
 	.buf_queue              = rtl2832_sdr_buf_queue,
 	.start_streaming        = rtl2832_sdr_start_streaming,
 	.stop_streaming         = rtl2832_sdr_stop_streaming,
diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index 67b9da1..7d4fa3a 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -670,11 +670,11 @@ static void buffer_queue(struct vb2_buffer *vb)
 static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct qcam *qcam = vb2_get_drv_priv(vb->vb2_queue);
-	void *vbuf = vb2_plane_vaddr(vb, 0);
+	void *vbuf = vb2_plane_begin_cpu_access(vb, 0);
 	int size = vb->vb2_queue->plane_sizes[0];
 	int len;
 
-	if (!vb2_is_streaming(vb->vb2_queue))
+	if (vbuf == NULL || !vb2_is_streaming(vb->vb2_queue))
 		return;
 
 	mutex_lock(&qcam->lock);
@@ -694,6 +694,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 	if (len != size)
 		vb->state = VB2_BUF_STATE_ERROR;
 	vb2_set_plane_payload(vb, 0, len);
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 static struct vb2_ops qcam_video_qops = {
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 63ae8a6..0c5e159 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -201,13 +201,17 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 		goto finish_buf;
 
 	if (erase_off(solo_dev)) {
-		void *p = vb2_plane_vaddr(vb, 0);
+		void *p = vb2_plane_begin_cpu_access(vb, 0);
 		int image_size = solo_image_size(solo_dev);
 
+		if (p == NULL)
+			goto finish_buf;
+
 		for (i = 0; i < image_size; i += 2) {
 			((u8 *)p)[i] = 0x80;
 			((u8 *)p)[i + 1] = 0x00;
 		}
+		vb2_plane_end_cpu_access(vb, 0);
 		error = 0;
 	} else {
 		fdma_addr = SOLO_DISP_EXT_ADDR + (solo_dev->old_write *
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 73496d9..8c58f1c 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -219,8 +219,7 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
 	if (vb->state != VB2_BUF_STATE_ACTIVE &&
 		vb->state != VB2_BUF_STATE_PREPARED) {
 		vb2_set_plane_payload(vb, 0, layer->pix_fmt.sizeimage);
-		if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
 			return -EINVAL;
 
 		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index d48c3d4..7fa90c6 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -223,6 +223,9 @@ struct mcam_vb_buffer {
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
 	struct yuv_pointer_t yuv_p;
+#ifdef MCAM_MODE_VMALLOC
+	void *vaddr;
+#endif
 };
 
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
@@ -457,7 +460,7 @@ static void mcam_frame_tasklet(unsigned long data)
 		 * Drop the lock during the big copy.  This *should* be safe...
 		 */
 		spin_unlock_irqrestore(&cam->dev_lock, flags);
-		memcpy(vb2_plane_vaddr(&buf->vb_buf, 0), cam->dma_bufs[bufno],
+		memcpy(buf->vaddr, cam->dma_bufs[bufno],
 				cam->pix_format.sizeimage);
 		mcam_buffer_done(cam, bufno, &buf->vb_buf);
 		spin_lock_irqsave(&cam->dev_lock, flags);
@@ -1103,6 +1106,25 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 		mcam_read_setup(cam);
 }
 
+static int mcam_vb_buf_prepare(struct vb2_buffer *vb)
+{
+#ifdef MCAM_MODE_VMALLOC
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+
+	mvb->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return mvb->vaddr ? 0 : -ENOMEM;
+#else
+	return 0;
+#endif
+}
+
+static void mcam_vb_buf_finish(struct vb2_buffer *vb)
+{
+#ifdef MCAM_MODE_VMALLOC
+	vb2_plane_end_cpu_access(vb, 0);
+#endif
+}
+
 
 /*
  * vb2 uses these to release the mutex when waiting in dqbuf.  I'm
@@ -1190,6 +1212,8 @@ static void mcam_vb_stop_streaming(struct vb2_queue *vq)
 static const struct vb2_ops mcam_vb2_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_queue		= mcam_vb_buf_queue,
+	.buf_prepare		= mcam_vb_buf_prepare,
+	.buf_finish		= mcam_vb_buf_finish,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
 	.wait_prepare		= mcam_vb_wait_prepare,
diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 9ee80cd..6a82842 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -206,10 +206,11 @@ static int device_process(struct m2mtest_ctx *ctx,
 {
 	struct m2mtest_dev *dev = ctx->dev;
 	struct m2mtest_q_data *q_data;
-	u8 *p_in, *p_out;
+	u8 *p_in, *p_out = NULL;
 	int x, y, t, w;
 	int tile_w, bytes_left;
 	int width, height, bytesperline;
+	int err = 0;
 
 	q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 
@@ -217,17 +218,20 @@ static int device_process(struct m2mtest_ctx *ctx,
 	height	= q_data->height;
 	bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
 
-	p_in = vb2_plane_vaddr(in_vb, 0);
-	p_out = vb2_plane_vaddr(out_vb, 0);
+	p_in = vb2_plane_begin_cpu_access(in_vb, 0);
+	if (p_in)
+		p_out = vb2_plane_begin_cpu_access(out_vb, 0);
 	if (!p_in || !p_out) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
-		return -EFAULT;
+		err = -EFAULT;
+		goto fail;
 	}
 
 	if (vb2_plane_size(in_vb, 0) > vb2_plane_size(out_vb, 0)) {
 		v4l2_err(&dev->v4l2_dev, "Output buffer is too small\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto fail;
 	}
 
 	tile_w = (width * (q_data[V4L2_M2M_DST].fmt->depth >> 3))
@@ -331,7 +335,13 @@ static int device_process(struct m2mtest_ctx *ctx,
 		}
 	}
 
-	return 0;
+fail:
+	if (p_in)
+		vb2_plane_end_cpu_access(in_vb, 0);
+	if (p_out)
+		vb2_plane_end_cpu_access(out_vb, 0);
+
+	return err;
 }
 
 static void schedule_irq(struct m2mtest_dev *dev, int msec_timeout)
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e525a7c..b19a855 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2165,11 +2165,18 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 	if (ctx->mode == S5P_JPEG_DECODE &&
 	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		struct s5p_jpeg_q_data tmp, *q_data;
-		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
-		     (unsigned long)vb2_plane_vaddr(vb, 0),
-		     min((unsigned long)ctx->out_q.size,
-			 vb2_get_plane_payload(vb, 0)), ctx);
-		if (!ctx->hdr_parsed) {
+		void *vaddr = vb2_plane_begin_cpu_access(vb, 0);
+
+		if (vaddr) {
+			tmp.w = tmp.h = 0;
+			ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
+					(unsigned long)vaddr,
+					min((unsigned long)ctx->out_q.size,
+						vb2_get_plane_payload(vb, 0)),
+					ctx);
+			vb2_plane_end_cpu_access(vb, 0);
+		}
+		if (!vaddr || !ctx->hdr_parsed) {
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			return;
 		}
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 2347612a..1b3635b 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -505,21 +505,26 @@ static int mx2_videobuf_prepare(struct vb2_buffer *vb)
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	int ret = 0;
 
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+	dev_dbg(icd->parent, "%s (vb=0x%p) %lu\n", __func__,
+		vb, vb2_get_plane_payload(vb, 0));
 
 #ifdef DEBUG
 	/*
 	 * This can be useful if you want to see if we actually fill
 	 * the buffer with something
 	 */
-	memset((void *)vb2_plane_vaddr(vb, 0),
-	       0xaa, vb2_get_plane_payload(vb, 0));
+	{
+		void *vaddr = vb2_plane_begin_cpu_access(vb, 0);
+
+		if (vaddr) {
+			memset(vaddr, 0xaa, vb2_get_plane_payload(vb, 0));
+			vb2_plane_end_cpu_access(vb, 0);
+		}
+	}
 #endif
 
 	vb2_set_plane_payload(vb, 0, icd->sizeimage);
-	if (vb2_plane_vaddr(vb, 0) &&
-	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -539,8 +544,8 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
 	unsigned long flags;
 
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+	dev_dbg(icd->parent, "%s (vb=0x%p) %lu\n", __func__,
+		vb, vb2_get_plane_payload(vb, 0));
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
@@ -1330,8 +1335,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 			}
 		}
 #endif
-		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
-				vb2_plane_vaddr(vb, 0),
+		dev_dbg(pcdev->dev, "%s (vb=0x%p) %lu\n", __func__, vb,
 				vb2_get_plane_payload(vb, 0));
 
 		list_del_init(&buf->internal.queue);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 7696a87..2fb395f 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -323,8 +323,14 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 
 #ifdef DEBUG
 	/* helps to see what DMA actually has written */
-	if (vb2_plane_vaddr(vb, 0))
-		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
+	{
+		void *vaddr = vb2_plane_begin_cpu_access(vb, 0);
+
+		if (vaddr) {
+			memset(vaddr, 0xaa, vb2_get_plane_payload(vb, 0));
+			vb2_plane_end_cpu_access(vb, 0);
+		}
+	}
 #endif
 
 	spin_lock_irq(&mx3_cam->lock);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 20defcb..debec8f 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -428,8 +428,8 @@ static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
 
 	vb2_set_plane_payload(vb, 0, size);
 
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+	dev_dbg(icd->parent, "%s (vb=0x%p) %lu\n", __func__,
+		vb, vb2_get_plane_payload(vb, 0));
 
 	spin_lock_irq(&priv->lock);
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 20ad4a5..26031b2 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -395,16 +395,22 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 
 	vb2_set_plane_payload(vb, 0, size);
 
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
+	dev_dbg(icd->parent, "%s (vb=0x%p) %lu\n", __func__,
+		vb, vb2_get_plane_payload(vb, 0));
 
 #ifdef DEBUG
 	/*
 	 * This can be useful if you want to see if we actually fill
 	 * the buffer with something
 	 */
-	if (vb2_plane_vaddr(vb, 0))
-		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
+	{
+		void *vaddr = vb2_plane_begin_cpu_access(vb, 0);
+
+		if (vaddr) {
+			memset(vaddr, 0xaa, vb2_get_plane_payload(vb, 0));
+			vb2_plane_end_cpu_access(vb, 0);
+		}
+	}
 #endif
 
 	spin_lock_irq(&pcdev->lock);
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 39a67cf..dbb6ceb 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -269,7 +269,7 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 
 	vid_cap_buf->vb.v4l2_buf.field = vid_out_buf->vb.v4l2_buf.field;
 
-	voutbuf = vb2_plane_vaddr(&vid_out_buf->vb, p) +
+	voutbuf = vb2_plane_begin_cpu_access(&vid_out_buf->vb, p) +
 				  vid_out_buf->vb.v4l2_planes[p].data_offset;
 	voutbuf += dev->loop_vid_out.left * pixsize + dev->loop_vid_out.top * stride_out;
 	vcapbuf += dev->compose_cap.left * pixsize + dev->compose_cap.top * stride_cap;
@@ -281,6 +281,7 @@ static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
 		 */
 		for (y = 0; y < hmax; y++, vcapbuf += stride_cap)
 			memcpy(vcapbuf, tpg->black_line[p], img_width * pixsize);
+		vb2_plane_end_cpu_access(&vid_out_buf->vb, p);
 		return 0;
 	}
 
@@ -386,6 +387,7 @@ update_vid_out_y:
 		}
 	}
 
+	vb2_plane_end_cpu_access(&vid_out_buf->vb, p);
 	if (!blank)
 		return 0;
 	for (; y < img_height; y++, vcapbuf += stride_cap)
@@ -442,7 +444,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	vivid_precalc_copy_rects(dev);
 
 	for (p = 0; p < tpg_g_planes(&dev->tpg); p++) {
-		void *vbuf = vb2_plane_vaddr(&buf->vb, p);
+		void *vbuf = vb2_plane_begin_cpu_access(&buf->vb, p);
 
 		/*
 		 * The first plane of a multiplanar format has a non-zero
@@ -457,6 +459,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 		tpg_calc_text_basep(&dev->tpg, basep, p, vbuf);
 		if (!is_loop || vivid_copy_buffer(dev, p, vbuf, buf))
 			tpg_fillbuffer(&dev->tpg, vivid_get_std_cap(dev), p, vbuf);
+		vb2_plane_end_cpu_access(&buf->vb, p);
 	}
 	dev->must_blank[buf->vb.v4l2_buf.index] = false;
 
@@ -577,7 +580,7 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 	struct tpg_data *tpg = &dev->tpg;
 	unsigned pixsize = tpg_g_twopixelsize(tpg, 0) / 2;
 	void *vbase = dev->fb_vbase_cap;
-	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	void *vbuf;
 	unsigned img_width = dev->compose_cap.width;
 	unsigned img_height = dev->compose_cap.height;
 	unsigned stride = tpg->bytesperline[0];
@@ -590,7 +593,6 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 	    dev->overlay_cap_field != buf->vb.v4l2_buf.field)
 		return;
 
-	vbuf += dev->compose_cap.left * pixsize + dev->compose_cap.top * stride;
 	x = dev->overlay_cap_left;
 	w = img_width;
 	if (x < 0) {
@@ -604,6 +606,8 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 	}
 	if (w <= 0)
 		return;
+	vbuf = vb2_plane_begin_cpu_access(&buf->vb, 0);
+	vbuf += dev->compose_cap.left * pixsize + dev->compose_cap.top * stride;
 	if (dev->overlay_cap_top >= 0)
 		vbase += dev->overlay_cap_top * dev->fb_cap.fmt.bytesperline;
 	for (y = dev->overlay_cap_top;
@@ -629,6 +633,7 @@ static void vivid_overlay(struct vivid_dev *dev, struct vivid_buffer *buf)
 		}
 		vbase += dev->fb_cap.fmt.bytesperline;
 	}
+	vb2_plane_end_cpu_access(&buf->vb, 0);
 }
 
 static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 8c5d661..a2747d2 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -453,7 +453,7 @@ static inline s32 fixp_sin(unsigned int x)
 
 void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
-	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *vbuf = vb2_plane_begin_cpu_access(&buf->vb, 0);
 	unsigned long i;
 	unsigned long plane_size = vb2_plane_size(&buf->vb, 0);
 	int fixp_src_phase_step, fixp_i, fixp_q;
@@ -496,4 +496,5 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 		*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, FIXP_FRAC * 10);
 		*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, FIXP_FRAC * 10);
 	}
+	vb2_plane_end_cpu_access(&buf->vb, 0);
 }
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 2166d0b..73d3746 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -94,7 +94,7 @@ static void vivid_g_fmt_vbi_cap(struct vivid_dev *dev, struct v4l2_vbi_format *v
 void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
 	struct v4l2_vbi_format vbi;
-	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	u8 *vbuf = vb2_plane_begin_cpu_access(&buf->vb, 0);
 
 	vivid_g_fmt_vbi_cap(dev, &vbi);
 	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
@@ -107,6 +107,7 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
 		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
+	vb2_plane_end_cpu_access(&buf->vb, 0);
 
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
@@ -115,7 +116,7 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
-	struct v4l2_sliced_vbi_data *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	struct v4l2_sliced_vbi_data *vbuf = vb2_plane_begin_cpu_access(&buf->vb, 0);
 
 	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
@@ -130,6 +131,7 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *bu
 		for (i = 0; i < 25; i++)
 			vbuf[i] = dev->vbi_gen.data[i];
 	}
+	vb2_plane_end_cpu_access(&buf->vb, 0);
 
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 9d00a07..406c0fd 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -219,7 +219,7 @@ int vidioc_s_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format
 
 void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
-	struct v4l2_sliced_vbi_data *vbi = vb2_plane_vaddr(&buf->vb, 0);
+	struct v4l2_sliced_vbi_data *vbi = vb2_plane_begin_cpu_access(&buf->vb, 0);
 	unsigned elems = vb2_get_plane_payload(&buf->vb, 0) / sizeof(*vbi);
 
 	dev->vbi_out_have_cc[0] = false;
@@ -245,4 +245,5 @@ void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *bu
 		}
 		vbi++;
 	}
+	vb2_plane_end_cpu_access(&buf->vb, 0);
 }
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 4069234..594a1d6 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -99,6 +99,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 struct airspy_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
+	void *vaddr;
 };
 
 struct airspy {
@@ -297,7 +298,6 @@ static void airspy_urb_complete(struct urb *urb)
 	}
 
 	if (likely(urb->actual_length > 0)) {
-		void *ptr;
 		unsigned int len;
 		/* get free framebuffer */
 		fbuf = airspy_get_next_fill_buf(s);
@@ -310,8 +310,7 @@ static void airspy_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		len = airspy_convert_stream(s, ptr, urb->transfer_buffer,
+		len = airspy_convert_stream(s, fbuf->vaddr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
@@ -521,6 +520,20 @@ static void airspy_buf_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 }
 
+static int airspy_buf_prepare(struct vb2_buffer *vb)
+{
+	struct airspy_frame_buf *buf =
+			container_of(vb, struct airspy_frame_buf, vb);
+
+	buf->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->vaddr ? 0 : -ENOMEM;
+}
+
+static void airspy_buf_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
+}
+
 static int airspy_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
@@ -606,6 +619,8 @@ static void airspy_stop_streaming(struct vb2_queue *vq)
 static struct vb2_ops airspy_vb2_ops = {
 	.queue_setup            = airspy_queue_setup,
 	.buf_queue              = airspy_buf_queue,
+	.buf_prepare            = airspy_buf_prepare,
+	.buf_finish             = airspy_buf_finish,
 	.start_streaming        = airspy_start_streaming,
 	.stop_streaming         = airspy_stop_streaming,
 	.wait_prepare           = vb2_ops_wait_prepare,
diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 34ee1e0..014ed97 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -72,8 +72,15 @@ static int vbi_buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	vb2_set_plane_payload(&buf->vb, 0, size);
+	buf->length = size;
+	buf->mem = vb2_plane_begin_cpu_access(vb, 0);
 
-	return 0;
+	return buf->mem ? 0 : -ENOMEM;
+}
+
+static void vbi_buffer_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 static void
@@ -84,9 +91,6 @@ vbi_buffer_queue(struct vb2_buffer *vb)
 	struct em28xx_dmaqueue *vbiq = &dev->vbiq;
 	unsigned long flags = 0;
 
-	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
-
 	spin_lock_irqsave(&dev->slock, flags);
 	list_add_tail(&buf->list, &vbiq->active);
 	spin_unlock_irqrestore(&dev->slock, flags);
@@ -96,6 +100,7 @@ vbi_buffer_queue(struct vb2_buffer *vb)
 struct vb2_ops em28xx_vbi_qops = {
 	.queue_setup    = vbi_queue_setup,
 	.buf_prepare    = vbi_buffer_prepare,
+	.buf_finish     = vbi_buffer_finish,
 	.buf_queue      = vbi_buffer_queue,
 	.start_streaming = em28xx_start_analog_streaming,
 	.stop_streaming = em28xx_stop_vbi_streaming,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 03d5ece..0e287b0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -918,8 +918,15 @@ buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	vb2_set_plane_payload(&buf->vb, 0, size);
+	buf->length = size;
+	buf->mem = vb2_plane_begin_cpu_access(vb, 0);
 
-	return 0;
+	return buf->mem ? 0 : -ENOMEM;
+}
+
+static void buffer_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
@@ -1049,8 +1056,6 @@ buffer_queue(struct vb2_buffer *vb)
 	unsigned long flags = 0;
 
 	em28xx_videodbg("%s\n", __func__);
-	buf->mem = vb2_plane_vaddr(vb, 0);
-	buf->length = vb2_plane_size(vb, 0);
 
 	spin_lock_irqsave(&dev->slock, flags);
 	list_add_tail(&buf->list, &vidq->active);
@@ -1060,6 +1065,7 @@ buffer_queue(struct vb2_buffer *vb)
 static struct vb2_ops em28xx_video_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare    = buffer_prepare,
+	.buf_finish     = buffer_finish,
 	.buf_queue      = buffer_queue,
 	.start_streaming = em28xx_start_analog_streaming,
 	.stop_streaming = em28xx_stop_streaming,
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 95cffb7..e5a37ed 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -386,11 +386,8 @@ start_error:
  */
 static inline void store_byte(struct go7007_buffer *vb, u8 byte)
 {
-	if (vb && vb->vb.v4l2_planes[0].bytesused < GO7007_BUF_SIZE) {
-		u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
-
-		ptr[vb->vb.v4l2_planes[0].bytesused++] = byte;
-	}
+	if (vb && vb->vb.v4l2_planes[0].bytesused < GO7007_BUF_SIZE)
+		vb->vaddr[vb->vb.v4l2_planes[0].bytesused++] = byte;
 }
 
 static void go7007_set_motion_regions(struct go7007 *go, struct go7007_buffer *vb,
diff --git a/drivers/media/usb/go7007/go7007-priv.h b/drivers/media/usb/go7007/go7007-priv.h
index 2251c3f..73571f2 100644
--- a/drivers/media/usb/go7007/go7007-priv.h
+++ b/drivers/media/usb/go7007/go7007-priv.h
@@ -140,6 +140,7 @@ struct go7007_buffer {
 	struct list_head list;
 	unsigned int frame_offset;
 	u32 modet_active;
+	u8 *vaddr;
 };
 
 #define GO7007_RATIO_1_1	0
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index ec799b4..ad9b877 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -52,7 +52,7 @@ static bool valid_pixelformat(u32 pixelformat)
 
 static u32 get_frame_type_flag(struct go7007_buffer *vb, int format)
 {
-	u8 *ptr = vb2_plane_vaddr(&vb->vb, 0);
+	u8 *ptr = vb->vaddr;
 
 	switch (format) {
 	case V4L2_PIX_FMT_MJPEG:
@@ -401,7 +401,8 @@ static int go7007_buf_prepare(struct vb2_buffer *vb)
 	go7007_vb->modet_active = 0;
 	go7007_vb->frame_offset = 0;
 	vb->v4l2_planes[0].bytesused = 0;
-	return 0;
+	go7007_vb->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return go7007_vb->vaddr ? 0 : -ENOMEM;
 }
 
 static void go7007_buf_finish(struct vb2_buffer *vb)
@@ -413,6 +414,7 @@ static void go7007_buf_finish(struct vb2_buffer *vb)
 	u32 frame_type_flag = get_frame_type_flag(go7007_vb, go->format);
 	struct v4l2_buffer *buf = &vb->v4l2_buf;
 
+	vb2_plane_end_cpu_access(vb, 0);
 	buf->flags &= ~(V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_BFRAME |
 			V4L2_BUF_FLAG_PFRAME);
 	buf->flags |= frame_type_flag;
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 328b5ba..60a8a95 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -87,6 +87,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 struct hackrf_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
+	void *vaddr;
 };
 
 struct hackrf_dev {
@@ -274,7 +275,6 @@ static void hackrf_urb_complete(struct urb *urb)
 	}
 
 	if (likely(urb->actual_length > 0)) {
-		void *ptr;
 		unsigned int len;
 		/* get free framebuffer */
 		fbuf = hackrf_get_next_fill_buf(dev);
@@ -287,8 +287,7 @@ static void hackrf_urb_complete(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		len = hackrf_convert_stream(dev, ptr, urb->transfer_buffer,
+		len = hackrf_convert_stream(dev, fbuf->vaddr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
 		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
@@ -493,6 +492,20 @@ static void hackrf_buf_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&dev->queued_bufs_lock, flags);
 }
 
+static int hackrf_buf_prepare(struct vb2_buffer *vb)
+{
+	struct hackrf_frame_buf *buf =
+			container_of(vb, struct hackrf_frame_buf, vb);
+
+	buf->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->vaddr ? 0 : -ENOMEM;
+}
+
+static void hackrf_buf_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
+}
+
 static int hackrf_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
@@ -574,6 +587,8 @@ static void hackrf_stop_streaming(struct vb2_queue *vq)
 static struct vb2_ops hackrf_vb2_ops = {
 	.queue_setup            = hackrf_queue_setup,
 	.buf_queue              = hackrf_buf_queue,
+	.buf_prepare            = hackrf_buf_prepare,
+	.buf_finish             = hackrf_buf_finish,
 	.start_streaming        = hackrf_start_streaming,
 	.stop_streaming         = hackrf_stop_streaming,
 	.wait_prepare           = vb2_ops_wait_prepare,
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index efc761c..09b624a 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -117,6 +117,7 @@ static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 struct msi2500_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
+	void *vaddr;
 };
 
 struct msi2500_state {
@@ -403,8 +404,6 @@ static void msi2500_isoc_handler(struct urb *urb)
 
 	/* Compact data */
 	for (i = 0; i < urb->number_of_packets; i++) {
-		void *ptr;
-
 		/* Check frame error */
 		fstatus = urb->iso_frame_desc[i].status;
 		if (unlikely(fstatus)) {
@@ -432,8 +431,7 @@ static void msi2500_isoc_handler(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		flen = msi2500_convert_stream(s, ptr, iso_buf, flen);
+		flen = msi2500_convert_stream(s, fbuf->vaddr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
 	}
@@ -647,6 +645,20 @@ static void msi2500_buf_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
 }
 
+static int msi2500_buf_prepare(struct vb2_buffer *vb)
+{
+	struct msi2500_frame_buf *buf =
+			container_of(vb, struct msi2500_frame_buf, vb);
+
+	buf->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->vaddr ? 0 : -ENOMEM;
+}
+
+static void msi2500_buf_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
+}
+
 #define CMD_WREG               0x41
 #define CMD_START_STREAMING    0x43
 #define CMD_STOP_STREAMING     0x45
@@ -879,6 +891,8 @@ static void msi2500_stop_streaming(struct vb2_queue *vq)
 static struct vb2_ops msi2500_vb2_ops = {
 	.queue_setup            = msi2500_queue_setup,
 	.buf_queue              = msi2500_buf_queue,
+	.buf_prepare            = msi2500_buf_prepare,
+	.buf_finish             = msi2500_buf_finish,
 	.start_streaming        = msi2500_start_streaming,
 	.stop_streaming         = msi2500_stop_streaming,
 	.wait_prepare           = vb2_ops_wait_prepare,
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 15b754d..6cde648 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -606,12 +606,14 @@ static int buffer_init(struct vb2_buffer *vb)
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 
 	/* Don't allow queing new buffers after device disconnection */
 	if (!pdev->udev)
 		return -ENODEV;
 
-	return 0;
+	buf->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->vaddr ? 0 : -ENOMEM;
 }
 
 static void buffer_finish(struct vb2_buffer *vb)
@@ -628,6 +630,7 @@ static void buffer_finish(struct vb2_buffer *vb)
 		 */
 		pwc_decompress(pdev, buf);
 	}
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 static void buffer_cleanup(struct vb2_buffer *vb)
diff --git a/drivers/media/usb/pwc/pwc-uncompress.c b/drivers/media/usb/pwc/pwc-uncompress.c
index b65903f..de43a4d 100644
--- a/drivers/media/usb/pwc/pwc-uncompress.c
+++ b/drivers/media/usb/pwc/pwc-uncompress.c
@@ -40,7 +40,7 @@ int pwc_decompress(struct pwc_device *pdev, struct pwc_frame_buf *fbuf)
 	u16 *src;
 	u16 *dsty, *dstu, *dstv;
 
-	image = vb2_plane_vaddr(&fbuf->vb, 0);
+	image = fbuf->vaddr;
 
 	yuv = fbuf->data + pdev->frame_header_size;  /* Skip header */
 
diff --git a/drivers/media/usb/pwc/pwc.h b/drivers/media/usb/pwc/pwc.h
index 81b017a..3a90ab2 100644
--- a/drivers/media/usb/pwc/pwc.h
+++ b/drivers/media/usb/pwc/pwc.h
@@ -213,6 +213,7 @@ struct pwc_frame_buf
 	struct vb2_buffer vb;	/* common v4l buffer stuff -- must be first */
 	struct list_head list;
 	void *data;
+	void *vaddr;
 	int filled;		/* number of bytes filled */
 };
 
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index ccc0009..ea3e07f 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -295,6 +295,7 @@ struct s2255_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct vb2_buffer vb;
 	struct list_head list;
+	void *vaddr;
 };
 
 
@@ -609,7 +610,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 {
 	int pos = 0;
 	const char *tmpbuf;
-	char *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+	char *vbuf = buf->vaddr;
 	unsigned long last_frame;
 	struct s2255_dev *dev = vc->dev;
 
@@ -699,7 +700,13 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	}
 
 	vb2_set_plane_payload(&buf->vb, 0, size);
-	return 0;
+	buf->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->vaddr ? 0 : -ENOMEM;
+}
+
+static void buffer_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
@@ -719,6 +726,7 @@ static void stop_streaming(struct vb2_queue *vq);
 static struct vb2_ops s2255_video_qops = {
 	.queue_setup = queue_setup,
 	.buf_prepare = buffer_prepare,
+	.buf_finish = buffer_finish,
 	.buf_queue = buffer_queue,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 2330543..55f501e 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -542,6 +542,32 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
 	return 0;
 }
 
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct stk1160 *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct stk1160_buffer *buf =
+		container_of(vb, struct stk1160_buffer, vb);
+
+	buf->length = vb2_plane_size(vb, 0);
+	buf->bytesused = 0;
+	buf->pos = 0;
+
+	/*
+	 * If buffer length is less from expected then we return
+	 * the buffer to userspace directly.
+	 */
+	if (buf->length < dev->width * dev->height * 2)
+		return -EINVAL;
+
+	buf->mem = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->mem ? 0 : -ENOMEM;
+}
+
+static void buffer_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
+}
+
 static void buffer_queue(struct vb2_buffer *vb)
 {
 	unsigned long flags;
@@ -557,21 +583,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		 */
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	} else {
-
-		buf->mem = vb2_plane_vaddr(vb, 0);
-		buf->length = vb2_plane_size(vb, 0);
-		buf->bytesused = 0;
-		buf->pos = 0;
-
-		/*
-		 * If buffer length is less from expected then we return
-		 * the buffer to userspace directly.
-		 */
-		if (buf->length < dev->width * dev->height * 2)
-			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
-		else
-			list_add_tail(&buf->list, &dev->avail_bufs);
-
+		list_add_tail(&buf->list, &dev->avail_bufs);
 	}
 	spin_unlock_irqrestore(&dev->buf_lock, flags);
 }
@@ -592,6 +604,8 @@ static void stop_streaming(struct vb2_queue *vq)
 static struct vb2_ops stk1160_video_qops = {
 	.queue_setup		= queue_setup,
 	.buf_queue		= buffer_queue,
+	.buf_prepare		= buffer_prepare,
+	.buf_finish		= buffer_finish,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
 	.wait_prepare		= vb2_ops_wait_prepare,
@@ -620,6 +634,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = list_first_entry(&dev->avail_bufs,
 			struct stk1160_buffer, list);
 		list_del(&buf->list);
+		vb2_plane_end_cpu_access(&buf->vb, 0);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 		stk1160_info("buffer [%p/%d] aborted\n",
 				buf, buf->vb.v4l2_buf.index);
diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
index 39f1aae..da5c08f 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -104,6 +104,7 @@ void stk1160_buffer_done(struct stk1160 *dev)
 	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 
 	vb2_set_plane_payload(&buf->vb, 0, buf->bytesused);
+	vb2_plane_end_cpu_access(&buf->vb, 0);
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 
 	dev->isoc_ctl.buf = NULL;
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 9d3525f..d69e730 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -275,7 +275,6 @@ static void usbtv_chunk_to_vbuf(u32 *frame, __be32 *src, int chunk_no, int odd)
 static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 {
 	int frame_id, odd, chunk_no;
-	u32 *frame;
 	struct usbtv_buf *buf;
 	unsigned long flags;
 
@@ -306,10 +305,9 @@ static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 
 	/* First available buffer. */
 	buf = list_first_entry(&usbtv->bufs, struct usbtv_buf, list);
-	frame = vb2_plane_vaddr(&buf->vb, 0);
 
 	/* Copy the chunk data. */
-	usbtv_chunk_to_vbuf(frame, &chunk[1], chunk_no, odd);
+	usbtv_chunk_to_vbuf(buf->vaddr, &chunk[1], chunk_no, odd);
 	usbtv->chunks_done++;
 
 	/* Last chunk in a frame, signalling an end */
@@ -628,6 +626,19 @@ static void usbtv_buf_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&usbtv->buflock, flags);
 }
 
+static int usbtv_buf_prepare(struct vb2_buffer *vb)
+{
+	struct usbtv_buf *buf = container_of(vb, struct usbtv_buf, vb);
+
+	buf->vaddr = vb2_plane_begin_cpu_access(vb, 0);
+	return buf->vaddr ? 0 : -ENOMEM;
+}
+
+static void usbtv_buf_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
+}
+
 static int usbtv_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct usbtv *usbtv = vb2_get_drv_priv(vq);
@@ -649,6 +660,8 @@ static void usbtv_stop_streaming(struct vb2_queue *vq)
 static struct vb2_ops usbtv_vb2_ops = {
 	.queue_setup = usbtv_queue_setup,
 	.buf_queue = usbtv_buf_queue,
+	.buf_prepare = usbtv_buf_prepare,
+	.buf_finish = usbtv_buf_finish,
 	.start_streaming = usbtv_start_streaming,
 	.stop_streaming = usbtv_stop_streaming,
 };
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 9681195..751ddea 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -63,6 +63,7 @@ struct usbtv_norm_params {
 struct usbtv_buf {
 	struct vb2_buffer vb;
 	struct list_head list;
+	void *vaddr;
 };
 
 /* Per-device structure. */
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 6e92d20..664c0c6 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -76,14 +76,14 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 
 	buf->state = UVC_BUF_STATE_QUEUED;
 	buf->error = 0;
-	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->mem = vb2_plane_begin_cpu_access(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
 	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
 		buf->bytesused = vb2_get_plane_payload(vb, 0);
 
-	return 0;
+	return buf->mem ? 0 : -ENOMEM;
 }
 
 static void uvc_buffer_queue(struct vb2_buffer *vb)
@@ -115,6 +115,7 @@ static void uvc_buffer_finish(struct vb2_buffer *vb)
 
 	if (vb->state == VB2_BUF_STATE_DONE)
 		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 static void uvc_wait_prepare(struct vb2_queue *vq)
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 6f9171c..eccf84c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1133,9 +1133,8 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 
 	/* Initialize buffer */
 	vb2_set_plane_payload(vb, 0, video->fmt.fmt.pix.sizeimage);
-	if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
-			return -EINVAL;
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		return -EINVAL;
 
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	/* Make sure user addresses are aligned to 32 bytes */
diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 8ea8b3b..b4f6189 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -73,14 +73,19 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 		return -ENODEV;
 
 	buf->state = UVC_BUF_STATE_QUEUED;
-	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->mem = vb2_plane_begin_cpu_access(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
 	if (vb->v4l2_buf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		buf->bytesused = 0;
 	else
 		buf->bytesused = vb2_get_plane_payload(vb, 0);
 
-	return 0;
+	return buf->mem ? 0 : -ENOMEM;
+}
+
+static void uvc_buffer_finish(struct vb2_buffer *vb)
+{
+	vb2_plane_end_cpu_access(vb, 0);
 }
 
 static void uvc_buffer_queue(struct vb2_buffer *vb)
@@ -121,6 +126,7 @@ static void uvc_wait_finish(struct vb2_queue *vq)
 static struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
+	.buf_finish = uvc_buffer_finish,
 	.buf_queue = uvc_buffer_queue,
 	.wait_prepare = uvc_wait_prepare,
 	.wait_finish = uvc_wait_finish,
-- 
2.1.1

