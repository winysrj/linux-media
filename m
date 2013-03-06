Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54781 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab3CFLyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:54:36 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 03/12] media: fimc-lite: Adding support for Exynos5
Date: Wed,  6 Mar 2013 17:23:49 +0530
Message-Id: <1362570838-4737-4-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the following functionalities to existing driver

1] FIMC-LITE supports multiple DMA shadow registers from Exynos5 onwards.
This patch adds the functionality of using shadow registers by
checking the current FIMC-LITE hardware version.
2] Fixes Buffer corruption on DMA output from fimc-lite
3] Modified the driver to be used as pipeline endpoint

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |   16 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.h |   41 ++++-
 drivers/media/platform/s5p-fimc/fimc-lite.c     |  196 +++++++++++++++++++++--
 drivers/media/platform/s5p-fimc/fimc-lite.h     |    3 +-
 4 files changed, 236 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
index 3c7dd65..3d63526 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
@@ -68,7 +68,8 @@ void flite_hw_set_interrupt_mask(struct fimc_lite *dev)
 	if (atomic_read(&dev->out_path) == FIMC_IO_DMA) {
 		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
 			 FLITE_REG_CIGCTRL_IRQ_LASTEN |
-			 FLITE_REG_CIGCTRL_IRQ_STARTEN;
+			 FLITE_REG_CIGCTRL_IRQ_STARTEN |
+			 FLITE_REG_CIGCTRL_IRQ_ENDEN;
 	} else {
 		/* An output to the FIMC-IS */
 		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
@@ -215,6 +216,18 @@ void flite_hw_set_camera_bus(struct fimc_lite *dev,
 	flite_hw_set_camera_port(dev, si->mux_id);
 }
 
+static void flite_hw_set_pack12(struct fimc_lite *dev, int on)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
+
+	cfg &= ~FLITE_REG_CIODMAFMT_PACK12;
+
+	if (on)
+		cfg |= FLITE_REG_CIODMAFMT_PACK12;
+
+	writel(cfg, dev->regs + FLITE_REG_CIODMAFMT);
+}
+
 static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
 {
 	static const u32 pixcode[4][2] = {
@@ -267,6 +280,7 @@ void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
 
 	flite_hw_set_out_order(dev, f);
 	flite_hw_set_dma_window(dev, f);
+	flite_hw_set_pack12(dev, 0);
 }
 
 void flite_hw_dump_regs(struct fimc_lite *dev, const char *label)
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.h b/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
index 0e34584..716df6c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.h
@@ -120,6 +120,10 @@
 /* b0: 1 - camera B, 0 - camera A */
 #define FLITE_REG_CIGENERAL_CAM_B		(1 << 0)
 
+
+#define FLITE_REG_CIFCNTSEQ			0x100
+#define FLITE_REG_CIOSAN(x)			(0x200 + (4 * (x)))
+
 /* ----------------------------------------------------------------------------
  * Function declarations
  */
@@ -143,8 +147,41 @@ void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f);
 void flite_hw_set_test_pattern(struct fimc_lite *dev, bool on);
 void flite_hw_dump_regs(struct fimc_lite *dev, const char *label);
 
-static inline void flite_hw_set_output_addr(struct fimc_lite *dev, u32 paddr)
+static inline void flite_hw_set_output_addr(struct fimc_lite *dev,
+	u32 paddr, u32 index)
+{
+	u32 config;
+
+	/* FLITE in EXYNOS4 has only one DMA register */
+	if (dev->variant->version == FLITE_VER_EXYNOS4)
+		index = 0;
+
+	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
+	config |= 1 << index;
+	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
+
+	if (index == 0)
+		writel(paddr, dev->regs + FLITE_REG_CIOSA);
+	else
+		writel(paddr, dev->regs + FLITE_REG_CIOSAN(index-1));
+}
+
+static inline void flite_hw_clear_output_addr(struct fimc_lite *dev, u32 index)
 {
-	writel(paddr, dev->regs + FLITE_REG_CIOSA);
+	u32 config;
+
+	/* FLITE in EXYNOS4 has only one DMA register */
+	if (dev->variant->version == FLITE_VER_EXYNOS4)
+		index = 0;
+
+	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
+	config &= ~(1 << index);
+	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
 }
+
+static inline void flite_hw_clear_output_index(struct fimc_lite *dev)
+{
+	writel(0, dev->regs + FLITE_REG_CIFCNTSEQ);
+}
+
 #endif /* FIMC_LITE_REG_H */
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index eb64f87..1edc5ce 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -136,6 +136,8 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 	if (fimc->fmt == NULL)
 		return -EINVAL;
 
+	flite_hw_clear_output_index(fimc);
+
 	/* Get sensor configuration data from the sensor subdev */
 	src_info = v4l2_get_subdev_hostdata(sensor);
 	spin_lock_irqsave(&fimc->slock, flags);
@@ -266,19 +268,24 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 
 	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART) &&
 	    test_bit(ST_FLITE_RUN, &fimc->state) &&
-	    !list_empty(&fimc->active_buf_q) &&
 	    !list_empty(&fimc->pending_buf_q)) {
+		vbuf = fimc_lite_pending_queue_pop(fimc);
+		flite_hw_set_output_addr(fimc, vbuf->paddr,
+					vbuf->vb.v4l2_buf.index);
+		fimc_lite_active_queue_add(fimc, vbuf);
+	}
+
+	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMEND) &&
+	    test_bit(ST_FLITE_RUN, &fimc->state) &&
+	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
 		ktime_get_ts(&ts);
 		tv = &vbuf->vb.v4l2_buf.timestamp;
 		tv->tv_sec = ts.tv_sec;
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
+		flite_hw_clear_output_addr(fimc, vbuf->vb.v4l2_buf.index);
 		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
-
-		vbuf = fimc_lite_pending_queue_pop(fimc);
-		flite_hw_set_output_addr(fimc, vbuf->paddr);
-		fimc_lite_active_queue_add(fimc, vbuf);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
@@ -406,7 +413,8 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (!test_bit(ST_FLITE_SUSPENDED, &fimc->state) &&
 	    !test_bit(ST_FLITE_STREAM, &fimc->state) &&
 	    list_empty(&fimc->active_buf_q)) {
-		flite_hw_set_output_addr(fimc, buf->paddr);
+		flite_hw_set_output_addr(fimc, buf->paddr,
+					buf->vb.v4l2_buf.index);
 		fimc_lite_active_queue_add(fimc, buf);
 	} else {
 		fimc_lite_pending_queue_add(fimc, buf);
@@ -646,7 +654,7 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
 	cap->bus_info[0] = 0;
 	cap->card[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
 	return 0;
 }
 
@@ -725,13 +733,125 @@ static int fimc_lite_try_fmt_mplane(struct file *file, void *fh,
 	return fimc_lite_try_fmt(fimc, &f->fmt.pix_mp, NULL);
 }
 
-static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
-				  struct v4l2_format *f)
+static struct media_entity *fimc_pipeline_get_head(struct media_entity *me)
 {
-	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
-	struct fimc_lite *fimc = video_drvdata(file);
+	struct media_pad *pad = &me->pads[0];
+
+	while (!(pad->flags & MEDIA_PAD_FL_SOURCE)) {
+		pad = media_entity_remote_source(pad);
+		if (!pad)
+			break;
+		me = pad->entity;
+		pad = &me->pads[0];
+	}
+
+	return me;
+}
+
+/**
+ * fimc_pipeline_try_format - negotiate and/or set formats at pipeline
+ *                            elements
+ * @ctx: FIMC capture context
+ * @tfmt: media bus format to try/set on subdevs
+ * @fmt_id: fimc pixel format id corresponding to returned @tfmt (output)
+ * @set: true to set format on subdevs, false to try only
+ */
+static int fimc_pipeline_try_format(struct fimc_lite *fimc,
+				    struct v4l2_mbus_framefmt *tfmt,
+				    struct fimc_fmt **fmt_id,
+				    bool set)
+{
+	struct v4l2_subdev *sd;
+	struct v4l2_subdev_format sfmt;
+	struct v4l2_mbus_framefmt *mf = &sfmt.format;
+	struct media_entity *me;
+	struct fimc_fmt *ffmt;
+	struct media_pad *pad;
+	int ret, i = 1;
+	u32 fcc;
+
+	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops,
+					get_subdev_sensor, &fimc->pipeline);
+
+	if (WARN_ON(!sd || !tfmt))
+		return -EINVAL;
+
+	memset(&sfmt, 0, sizeof(sfmt));
+	sfmt.format = *tfmt;
+	sfmt.which = set ? V4L2_SUBDEV_FORMAT_ACTIVE : V4L2_SUBDEV_FORMAT_TRY;
+
+	me = fimc_pipeline_get_head(&sd->entity);
+
+	while (1) {
+		ffmt = fimc_lite_find_format(NULL,
+				mf->code != 0 ? &mf->code : NULL, i++);
+		if (ffmt == NULL) {
+			/*
+			 * Notify user-space if common pixel code for
+			 * host and sensor does not exist.
+			 */
+			return -EINVAL;
+		}
+		mf->code = tfmt->code = ffmt->mbus_code;
+
+		/* set format on all pipeline subdevs */
+		while (me != &fimc->subdev.entity) {
+			sd = media_entity_to_v4l2_subdev(me);
+
+			sfmt.pad = 0;
+			ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &sfmt);
+			if (ret)
+				return ret;
+
+			if (me->pads[0].flags & MEDIA_PAD_FL_SINK) {
+				sfmt.pad = me->num_pads - 1;
+				sfmt.format.code = tfmt->code;
+				ret = v4l2_subdev_call(sd, pad, set_fmt, NULL,
+									&sfmt);
+				if (ret)
+					return ret;
+			}
+
+			pad = media_entity_remote_source(&me->pads[sfmt.pad]);
+			if (!pad)
+				return -EINVAL;
+			me = pad->entity;
+		}
+
+		if (mf->code != tfmt->code)
+			continue;
+
+		fcc = ffmt->fourcc;
+		tfmt->width  = mf->width;
+		tfmt->height = mf->height;
+		ffmt = fimc_lite_try_format(fimc, &tfmt->width, &tfmt->height,
+					NULL, &fcc, FIMC_SD_PAD_SINK);
+		ffmt = fimc_lite_try_format(fimc, &tfmt->width, &tfmt->height,
+					NULL, &fcc, FIMC_SD_PAD_SOURCE);
+		if (ffmt && ffmt->mbus_code)
+			mf->code = ffmt->mbus_code;
+		if (mf->width != tfmt->width || mf->height != tfmt->height)
+			continue;
+		tfmt->code = mf->code;
+		break;
+	}
+
+	if (fmt_id && ffmt)
+		*fmt_id = ffmt;
+	*tfmt = *mf;
+
+	return 0;
+}
+
+
+static int __fimc_lite_set_format(struct fimc_lite *fimc,
+				     struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	struct flite_frame *frame = &fimc->out_frame;
 	const struct fimc_fmt *fmt = NULL;
+	struct v4l2_mbus_framefmt mf;
+	struct fimc_fmt *s_fmt = NULL;
 	int ret;
 
 	if (vb2_is_busy(&fimc->vb_queue))
@@ -741,15 +861,59 @@ static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
+	/* Reset cropping and set format at the camera interface input */
+	if (!fimc->user_subdev_api) {
+		fimc->inp_frame.f_width = pix_mp->width;
+		fimc->inp_frame.f_height = pix_mp->height;
+		fimc->inp_frame.rect.top = 0;
+		fimc->inp_frame.rect.left = 0;
+		fimc->inp_frame.rect.width = pix_mp->width;
+		fimc->inp_frame.rect.height = pix_mp->height;
+	}
+
+	/* Try to match format at the host and the sensor */
+	if (!fimc->user_subdev_api) {
+		mf.code   = fmt->mbus_code;
+		mf.width  = pix_mp->width;
+		mf.height = pix_mp->height;
+		ret = fimc_pipeline_try_format(fimc, &mf, &s_fmt, true);
+		if (ret)
+			return ret;
+
+		pix_mp->width  = mf.width;
+		pix_mp->height = mf.height;
+	}
+
 	fimc->fmt = fmt;
-	fimc->payload[0] = max((pixm->width * pixm->height * fmt->depth[0]) / 8,
-			       pixm->plane_fmt[0].sizeimage);
-	frame->f_width = pixm->width;
-	frame->f_height = pixm->height;
+	fimc->payload[0] = max((pix_mp->width * pix_mp->height *
+			fmt->depth[0]) / 8, pix_mp->plane_fmt[0].sizeimage);
+	frame->f_width = pix_mp->width;
+	frame->f_height = pix_mp->height;
 
 	return 0;
 }
 
+static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	int ret;
+
+	exynos_pipeline_graph_lock(fimc->pipeline_ops, &fimc->pipeline);
+	/*
+	 * The graph is walked within __fimc_lite_set_format() to set
+	 * the format at subdevs thus the graph mutex needs to be held at
+	 * this point and acquired before the video mutex, to avoid  AB-BA
+	 * deadlock when fimc_md_link_notify() is called by other thread.
+	 * Ideally the graph walking and setting format at the whole pipeline
+	 * should be removed from this driver and handled in userspace only.
+	 */
+	ret = __fimc_lite_set_format(fimc, f);
+
+	exynos_pipeline_graph_unlock(fimc->pipeline_ops, &fimc->pipeline);
+	return ret;
+}
+
 static int fimc_pipeline_validate(struct fimc_lite *fimc)
 {
 	struct v4l2_subdev *sd = &fimc->subdev;
@@ -1247,7 +1411,7 @@ static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	mutex_lock(&fimc->lock);
 	if (on) {
 		flite_hw_reset(fimc);
-		ret = fimc_lite_hw_init(fimc, true);
+		ret = fimc_lite_hw_init(fimc, false);
 		if (!ret) {
 			spin_lock_irqsave(&fimc->slock, flags);
 			flite_hw_capture_start(fimc);
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
index ef43fe0..7ea57c8 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.h
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
@@ -52,7 +52,6 @@ enum {
 #define FLITE_VER_EXYNOS4	0
 #define FLITE_VER_EXYNOS5	1
 
-
 struct flite_variant {
 	unsigned short max_width;
 	unsigned short max_height;
@@ -175,6 +174,8 @@ struct fimc_lite {
 	unsigned int		reqbufs_count;
 	int			ref_count;
 
+	bool			user_subdev_api;
+
 	struct fimc_lite_events	events;
 };
 
-- 
1.7.9.5

