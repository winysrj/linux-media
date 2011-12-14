Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47379 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab1LNQa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 11:30:27 -0500
Received: by faar15 with SMTP id r15so1348133faa.19
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2011 08:30:26 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media i.MX27 camera: add support for YUV420 format.
Date: Wed, 14 Dec 2011 17:30:14 +0100
Message-Id: <1323880214-26086-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch uses channel 2 of the eMMa-PrP to convert
format provided by the sensor to YUV420.

This format is very useful since it is used by the
internal H.264 encoder.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |  291 +++++++++++++++++++++++++++++++-------
 1 files changed, 241 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 9c81c6d..ea1f4dc 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -207,6 +207,22 @@
 
 #define MAX_VIDEO_MEM	16
 
+struct mx2_prp_cfg {
+	int channel;
+	u32 in_fmt;
+	u32 out_fmt;
+	u32 src_pixel;
+	u32 ch1_pixel;
+	u32 irq_flags;
+};
+
+/* prp configuration for a client-host fmt pair */
+struct mx2_fmt_cfg {
+	enum v4l2_mbus_pixelcode	in_fmt;
+	u32				out_fmt;
+	struct mx2_prp_cfg		cfg;
+};
+
 struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
@@ -238,6 +254,7 @@ struct mx2_camera_dev {
 	void			*discard_buffer;
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
+	struct mx2_fmt_cfg	*emma_prp;
 };
 
 /* buffer for one video frame */
@@ -250,6 +267,59 @@ struct mx2_buffer {
 	int bufnum;
 };
 
+static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
+	/*
+	 * This is a generic configuration which is valid for most
+	 * prp input-output format combinations.
+	 * We set the incomming and outgoing pixelformat to a
+	 * 16 Bit wide format and adjust the bytesperline
+	 * accordingly. With this configuration the inputdata
+	 * will not be changed by the emma and could be any type
+	 * of 16 Bit Pixelformat.
+	 */
+	{
+		.in_fmt		= 0,
+		.out_fmt	= 0,
+		.cfg		= {
+			.channel	= 1,
+			.in_fmt		= PRP_CNTL_DATA_IN_RGB16,
+			.out_fmt	= PRP_CNTL_CH1_OUT_RGB16,
+			.src_pixel	= 0x2ca00565, /* RGB565 */
+			.ch1_pixel	= 0x2ca00565, /* RGB565 */
+			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH1WERR |
+						PRP_INTR_CH1FC | PRP_INTR_LBOVF,
+		}
+	},
+	{
+		.in_fmt		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.out_fmt	= V4L2_PIX_FMT_YUV420,
+		.cfg		= {
+			.channel	= 2,
+			.in_fmt		= PRP_CNTL_DATA_IN_YUV422,
+			.out_fmt	= PRP_CNTL_CH2_OUT_YUV420,
+			.src_pixel	= 0x22000888, /* YUV422 (YUYV) */
+			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH2WERR |
+					PRP_INTR_CH2FC | PRP_INTR_LBOVF |
+					PRP_INTR_CH2OVF,
+		}
+	},
+};
+
+static struct mx2_fmt_cfg *mx27_emma_prp_get_format(
+					enum v4l2_mbus_pixelcode in_fmt,
+					u32 out_fmt)
+{
+	int i;
+
+	for (i = 1; i < ARRAY_SIZE(mx27_emma_prp_table); i++)
+		if ((mx27_emma_prp_table[i].in_fmt == in_fmt) &&
+				(mx27_emma_prp_table[i].out_fmt == out_fmt)) {
+			return &mx27_emma_prp_table[i];
+		}
+	/* If no match return the most generic configuration */
+	return &mx27_emma_prp_table[0];
+};
+
 static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
 	unsigned long flags;
@@ -666,51 +736,74 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
+
+	if (prp->cfg.channel == 1) {
+		writel(pcdev->discard_buffer_dma,
+				pcdev->base_emma + PRP_DEST_RGB1_PTR);
+		writel(pcdev->discard_buffer_dma,
+				pcdev->base_emma + PRP_DEST_RGB2_PTR);
+
+		writel(PRP_CNTL_CH1EN |
+				PRP_CNTL_CSIEN |
+				prp->cfg.in_fmt |
+				prp->cfg.out_fmt |
+				PRP_CNTL_CH1_LEN |
+				PRP_CNTL_CH1BYP |
+				PRP_CNTL_CH1_TSKIP(0) |
+				PRP_CNTL_IN_TSKIP(0),
+				pcdev->base_emma + PRP_CNTL);
+
+		writel((icd->user_width << 16) | icd->user_height,
+			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
+		writel((icd->user_width << 16) | icd->user_height,
+			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
+		writel(bytesperline,
+			pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
+		writel(prp->cfg.src_pixel,
+			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
+		writel(prp->cfg.ch1_pixel,
+			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
+	} else { /* channel 2 */
+		writel(pcdev->discard_buffer_dma,
+			pcdev->base_emma + PRP_DEST_Y_PTR);
+		writel(pcdev->discard_buffer_dma,
+			pcdev->base_emma + PRP_SOURCE_Y_PTR);
+
+		if (prp->cfg.out_fmt == PRP_CNTL_CH2_OUT_YUV420) {
+			writel(pcdev->discard_buffer_dma + imgsize,
+				pcdev->base_emma + PRP_DEST_CB_PTR);
+			writel(pcdev->discard_buffer_dma + ((5 * imgsize) / 4),
+				pcdev->base_emma + PRP_DEST_CR_PTR);
+			writel(pcdev->discard_buffer_dma + imgsize,
+				pcdev->base_emma + PRP_SOURCE_CB_PTR);
+			writel(pcdev->discard_buffer_dma + ((5 * imgsize) / 4),
+				pcdev->base_emma + PRP_SOURCE_CR_PTR);
+		}
 
-	writel(pcdev->discard_buffer_dma,
-			pcdev->base_emma + PRP_DEST_RGB1_PTR);
-	writel(pcdev->discard_buffer_dma,
-			pcdev->base_emma + PRP_DEST_RGB2_PTR);
-
-	/*
-	 * We only use the EMMA engine to get rid of the broken
-	 * DMA Engine. No color space consversion at the moment.
-	 * We set the incomming and outgoing pixelformat to an
-	 * 16 Bit wide format and adjust the bytesperline
-	 * accordingly. With this configuration the inputdata
-	 * will not be changed by the emma and could be any type
-	 * of 16 Bit Pixelformat.
-	 */
-	writel(PRP_CNTL_CH1EN |
+		writel(PRP_CNTL_CH2EN |
 			PRP_CNTL_CSIEN |
-			PRP_CNTL_DATA_IN_RGB16 |
-			PRP_CNTL_CH1_OUT_RGB16 |
-			PRP_CNTL_CH1_LEN |
-			PRP_CNTL_CH1BYP |
-			PRP_CNTL_CH1_TSKIP(0) |
+			prp->cfg.in_fmt |
+			prp->cfg.out_fmt |
+			PRP_CNTL_CH2_LEN |
+			PRP_CNTL_CH2_TSKIP(0) |
 			PRP_CNTL_IN_TSKIP(0),
 			pcdev->base_emma + PRP_CNTL);
 
-	writel(((bytesperline >> 1) << 16) | icd->user_height,
+		writel((icd->user_width << 16) | icd->user_height,
 			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
-	writel(((bytesperline >> 1) << 16) | icd->user_height,
-			pcdev->base_emma + PRP_CH1_OUT_IMAGE_SIZE);
-	writel(bytesperline,
-			pcdev->base_emma + PRP_DEST_CH1_LINE_STRIDE);
-	writel(0x2ca00565, /* RGB565 */
+
+		writel((icd->user_width << 16) | icd->user_height,
+			pcdev->base_emma + PRP_CH2_OUT_IMAGE_SIZE);
+
+		writel(prp->cfg.src_pixel,
 			pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
-	writel(0x2ca00565, /* RGB565 */
-			pcdev->base_emma + PRP_CH1_PIXEL_FORMAT_CNTL);
+
+	}
 
 	/* Enable interrupts */
-	writel(PRP_INTR_RDERR |
-			PRP_INTR_CH1WERR |
-			PRP_INTR_CH2WERR |
-			PRP_INTR_CH1FC |
-			PRP_INTR_CH2FC |
-			PRP_INTR_LBOVF |
-			PRP_INTR_CH2OVF,
-			pcdev->base_emma + PRP_INTR_CNTL);
+	writel(prp->cfg.irq_flags, pcdev->base_emma + PRP_INTR_CNTL);
 }
 
 static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
@@ -858,9 +951,58 @@ static int mx2_camera_set_crop(struct soc_camera_device *icd,
 	return ret;
 }
 
+static int mx2_camera_get_formats(struct soc_camera_device *icd,
+				  unsigned int idx,
+				  struct soc_camera_format_xlate *xlate)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	const struct soc_mbus_pixelfmt *fmt;
+	struct device *dev = icd->parent;
+	enum v4l2_mbus_pixelcode code;
+	int ret, formats = 0;
+
+	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/* no more formats */
+		return 0;
+
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
+		return 0;
+	}
+
+	if (code == V4L2_MBUS_FMT_YUYV8_2X8) {
+		formats++;
+		if (xlate) {
+			/*
+			 * CH2 can output YUV420 which is a standard format in
+			 * soc_mediabus.c
+			 */
+			xlate->host_fmt =
+				soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_YUYV8_1_5X8);
+			xlate->code	= code;
+			dev_dbg(dev, "Providing host format %s for sensor code %d\n",
+			       xlate->host_fmt->name, code);
+			xlate++;
+		}
+	}
+
+	/* Generic pass-trough */
+	formats++;
+	if (xlate) {
+		xlate->host_fmt = fmt;
+		xlate->code	= code;
+		xlate++;
+	}
+	return formats;
+}
+
 static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 			       struct v4l2_format *f)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mx2_camera_dev *pcdev = ici->priv;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
@@ -893,6 +1035,10 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
+	if (mx27_camera_emma(pcdev))
+		pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
+						xlate->host_fmt->fourcc);
+
 	return 0;
 }
 
@@ -958,7 +1104,12 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 
 	if (mf.field == V4L2_FIELD_ANY)
 		mf.field = V4L2_FIELD_NONE;
-	if (mf.field != V4L2_FIELD_NONE) {
+	/*
+	 * Driver supports interlaced images provided they have
+	 * both fields so that they can be processed as if they
+	 * where progressive.
+	 */
+	if (mf.field != V4L2_FIELD_NONE && !V4L2_FIELD_HAS_BOTH(mf.field)) {
 		dev_err(icd->parent, "Field type %d unsupported.\n",
 				mf.field);
 		return -EINVAL;
@@ -1009,6 +1160,7 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 	.remove		= mx2_camera_remove_device,
 	.set_fmt	= mx2_camera_set_fmt,
 	.set_crop	= mx2_camera_set_crop,
+	.get_formats	= mx2_camera_get_formats,
 	.try_fmt	= mx2_camera_try_fmt,
 	.init_videobuf	= mx2_camera_init_videobuf,
 	.reqbufs	= mx2_camera_reqbufs,
@@ -1020,6 +1172,8 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		int bufnum, int state)
 {
+	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 	struct mx2_buffer *buf;
 	struct videobuf_buffer *vb;
 	unsigned long phys;
@@ -1033,12 +1187,22 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		vb = &buf->vb;
 #ifdef DEBUG
 		phys = videobuf_to_dma_contig(vb);
-		if (readl(pcdev->base_emma + PRP_DEST_RGB1_PTR + 4 * bufnum)
-				!= phys) {
-			dev_err(pcdev->dev, "%p != %p\n", phys,
-					readl(pcdev->base_emma +
-						PRP_DEST_RGB1_PTR +
-						4 * bufnum));
+		if (prp->cfg.channel == 1) {
+			if (readl(pcdev->base_emma + PRP_DEST_RGB1_PTR +
+				4 * bufnum) != phys) {
+				dev_err(pcdev->dev, "%p != %p\n", phys,
+						readl(pcdev->base_emma +
+							PRP_DEST_RGB1_PTR +
+							4 * bufnum));
+			}
+		} else {
+			if (readl(pcdev->base_emma + PRP_DEST_Y_PTR -
+				0x14 * bufnum) != phys) {
+				dev_err(pcdev->dev, "%p != %p\n", phys,
+						readl(pcdev->base_emma +
+							PRP_DEST_Y_PTR -
+							0x14 * bufnum));
+			}
 		}
 #endif
 		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__, vb,
@@ -1053,8 +1217,22 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	}
 
 	if (list_empty(&pcdev->capture)) {
-		writel(pcdev->discard_buffer_dma, pcdev->base_emma +
-				PRP_DEST_RGB1_PTR + 4 * bufnum);
+		if (prp->cfg.channel == 1) {
+			writel(pcdev->discard_buffer_dma, pcdev->base_emma +
+					PRP_DEST_RGB1_PTR + 4 * bufnum);
+		} else {
+			writel(pcdev->discard_buffer_dma, pcdev->base_emma +
+						PRP_DEST_Y_PTR -
+						0x14 * bufnum);
+			if (prp->out_fmt == V4L2_PIX_FMT_YUV420) {
+				writel(pcdev->discard_buffer_dma + imgsize,
+				       pcdev->base_emma + PRP_DEST_CB_PTR -
+				       0x14 * bufnum);
+				writel(pcdev->discard_buffer_dma +
+				       ((5 * imgsize) / 4), pcdev->base_emma +
+				       PRP_DEST_CR_PTR - 0x14 * bufnum);
+			}
+		}
 		return;
 	}
 
@@ -1069,7 +1247,18 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	vb->state = VIDEOBUF_ACTIVE;
 
 	phys = videobuf_to_dma_contig(vb);
-	writel(phys, pcdev->base_emma + PRP_DEST_RGB1_PTR + 4 * bufnum);
+	if (prp->cfg.channel == 1) {
+		writel(phys, pcdev->base_emma + PRP_DEST_RGB1_PTR + 4 * bufnum);
+	} else {
+		writel(phys, pcdev->base_emma +
+				PRP_DEST_Y_PTR - 0x14 * bufnum);
+		if (prp->cfg.out_fmt == PRP_CNTL_CH2_OUT_YUV420) {
+			writel(phys + imgsize, pcdev->base_emma +
+					PRP_DEST_CB_PTR - 0x14 * bufnum);
+			writel(phys + ((5 * imgsize) / 4), pcdev->base_emma +
+					PRP_DEST_CR_PTR - 0x14 * bufnum);
+		}
+	}
 }
 
 static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
@@ -1089,10 +1278,12 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		 * the next one.
 		 */
 		cntl = readl(pcdev->base_emma + PRP_CNTL);
-		writel(cntl & ~PRP_CNTL_CH1EN, pcdev->base_emma + PRP_CNTL);
+		writel(cntl & ~(PRP_CNTL_CH1EN | PRP_CNTL_CH2EN),
+		       pcdev->base_emma + PRP_CNTL);
 		writel(cntl, pcdev->base_emma + PRP_CNTL);
 	}
-	if ((status & (3 << 5)) == (3 << 5)
+	if ((((status & (3 << 5)) == (3 << 5)) ||
+		((status & (3 << 3)) == (3 << 3)))
 			&& !list_empty(&pcdev->active_bufs)) {
 		/*
 		 * Both buffers have triggered, process the one we're expecting
@@ -1103,9 +1294,9 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		mx27_camera_frame_done_emma(pcdev, buf->bufnum, VIDEOBUF_DONE);
 		status &= ~(1 << (6 - buf->bufnum)); /* mark processed */
 	}
-	if (status & (1 << 6))
+	if ((status & (1 << 6)) || (status & (1 << 4)))
 		mx27_camera_frame_done_emma(pcdev, 0, VIDEOBUF_DONE);
-	if (status & (1 << 5))
+	if ((status & (1 << 5)) || (status & (1 << 3)))
 		mx27_camera_frame_done_emma(pcdev, 1, VIDEOBUF_DONE);
 
 	writel(status, pcdev->base_emma + PRP_INTRSTATUS);
-- 
1.7.0.4

