Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35553 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161503Ab3FUHzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 03:55:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Wei Yongjun <weiyj.lk@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 4/8] [media] coda: update CODA7541 to firmware 1.4.50
Date: Fri, 21 Jun 2013 09:55:30 +0200
Message-Id: <1371801334-22324-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
References: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch splits the global workbuf into a global tempbuf and a per-context
workbuf, adds the codec mode aux register, and restores the work buffer
pointer on commands. With the new firmware, there is only a single set of
read/write pointers which need to be restored between context switches.
This allows more than four active contexts at the same time.
All auxiliary buffers are now allocated through a helper function to avoid
code duplication.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 235 +++++++++++++++++++++++++++++++-----------
 drivers/media/platform/coda.h |   9 ++
 2 files changed, 182 insertions(+), 62 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 6d76f1d..28ee3f7 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -41,7 +41,8 @@
 
 #define CODA_FMO_BUF_SIZE	32
 #define CODADX6_WORK_BUF_SIZE	(288 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
-#define CODA7_WORK_BUF_SIZE	(512 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
+#define CODA7_WORK_BUF_SIZE	(128 * 1024)
+#define CODA7_TEMP_BUF_SIZE	(304 * 1024)
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
 #define CODADX6_IRAM_SIZE	0xb000
@@ -129,6 +130,7 @@ struct coda_dev {
 	struct clk		*clk_ahb;
 
 	struct coda_aux_buf	codebuf;
+	struct coda_aux_buf	tempbuf;
 	struct coda_aux_buf	workbuf;
 	struct gen_pool		*iram_pool;
 	long unsigned int	iram_vaddr;
@@ -153,6 +155,7 @@ struct coda_params {
 	u8			mpeg4_inter_qp;
 	u8			gop_size;
 	int			codec_mode;
+	int			codec_mode_aux;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
 	u32			framerate;
 	u16			bitrate;
@@ -192,8 +195,10 @@ struct coda_ctx {
 	int				vpu_header_size[3];
 	struct coda_aux_buf		parabuf;
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
+	struct coda_aux_buf		workbuf;
 	int				num_internal_frames;
 	int				idx;
+	int				reg_idx;
 	struct coda_iram_info		iram_info;
 };
 
@@ -241,10 +246,18 @@ static int coda_wait_timeout(struct coda_dev *dev)
 static void coda_command_async(struct coda_ctx *ctx, int cmd)
 {
 	struct coda_dev *dev = ctx->dev;
+
+	if (dev->devtype->product == CODA_7541) {
+		/* Restore context related registers to CODA */
+		coda_write(dev, ctx->workbuf.paddr, CODA_REG_BIT_WORK_BUF_ADDR);
+	}
+
 	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
 
 	coda_write(dev, ctx->idx, CODA_REG_BIT_RUN_INDEX);
 	coda_write(dev, ctx->params.codec_mode, CODA_REG_BIT_RUN_COD_STD);
+	coda_write(dev, ctx->params.codec_mode_aux, CODA7_REG_BIT_RUN_AUX_STD);
+
 	coda_write(dev, cmd, CODA_REG_BIT_RUN_COMMAND);
 }
 
@@ -959,21 +972,6 @@ static void coda_wait_finish(struct vb2_queue *q)
 	coda_lock(ctx);
 }
 
-static void coda_free_framebuffers(struct coda_ctx *ctx)
-{
-	int i;
-
-	for (i = 0; i < CODA_MAX_FRAMEBUFFERS; i++) {
-		if (ctx->internal_frames[i].vaddr) {
-			dma_free_coherent(&ctx->dev->plat_dev->dev,
-				ctx->internal_frames[i].size,
-				ctx->internal_frames[i].vaddr,
-				ctx->internal_frames[i].paddr);
-			ctx->internal_frames[i].vaddr = NULL;
-		}
-	}
-}
-
 static void coda_parabuf_write(struct coda_ctx *ctx, int index, u32 value)
 {
 	struct coda_dev *dev = ctx->dev;
@@ -985,28 +983,69 @@ static void coda_parabuf_write(struct coda_ctx *ctx, int index, u32 value)
 		p[index ^ 1] = value;
 }
 
+static int coda_alloc_aux_buf(struct coda_dev *dev,
+			      struct coda_aux_buf *buf, size_t size)
+{
+	buf->vaddr = dma_alloc_coherent(&dev->plat_dev->dev, size, &buf->paddr,
+					GFP_KERNEL);
+	if (!buf->vaddr)
+		return -ENOMEM;
+
+	buf->size = size;
+
+	return 0;
+}
+
+static inline int coda_alloc_context_buf(struct coda_ctx *ctx,
+					 struct coda_aux_buf *buf, size_t size)
+{
+	return coda_alloc_aux_buf(ctx->dev, buf, size);
+}
+
+static void coda_free_aux_buf(struct coda_dev *dev,
+			      struct coda_aux_buf *buf)
+{
+	if (buf->vaddr) {
+		dma_free_coherent(&dev->plat_dev->dev, buf->size,
+				  buf->vaddr, buf->paddr);
+		buf->vaddr = NULL;
+		buf->size = 0;
+	}
+}
+
+static void coda_free_framebuffers(struct coda_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < CODA_MAX_FRAMEBUFFERS; i++)
+		coda_free_aux_buf(ctx->dev, &ctx->internal_frames[i]);
+}
+
 static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_data, u32 fourcc)
 {
 	struct coda_dev *dev = ctx->dev;
-
 	int height = q_data->height;
 	dma_addr_t paddr;
 	int ysize;
+	int ret;
 	int i;
 
+	if (ctx->codec && ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
+		height = round_up(height, 16);
 	ysize = round_up(q_data->width, 8) * height;
 
 	/* Allocate frame buffers */
 	for (i = 0; i < ctx->num_internal_frames; i++) {
-		ctx->internal_frames[i].size = q_data->sizeimage;
-		if (fourcc == V4L2_PIX_FMT_H264 && dev->devtype->product != CODA_DX6)
+		size_t size;
+
+		size = q_data->sizeimage;
+		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
+		    dev->devtype->product != CODA_DX6)
 			ctx->internal_frames[i].size += ysize/4;
-		ctx->internal_frames[i].vaddr = dma_alloc_coherent(
-				&dev->plat_dev->dev, ctx->internal_frames[i].size,
-				&ctx->internal_frames[i].paddr, GFP_KERNEL);
-		if (!ctx->internal_frames[i].vaddr) {
+		ret = coda_alloc_context_buf(ctx, &ctx->internal_frames[i], size);
+		if (ret < 0) {
 			coda_free_framebuffers(ctx);
-			return -ENOMEM;
+			return ret;
 		}
 	}
 
@@ -1017,10 +1056,20 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_d
 		coda_parabuf_write(ctx, i * 3 + 1, paddr + ysize); /* Cb */
 		coda_parabuf_write(ctx, i * 3 + 2, paddr + ysize + ysize/4); /* Cr */
 
-		if (dev->devtype->product != CODA_DX6 && fourcc == V4L2_PIX_FMT_H264)
-			coda_parabuf_write(ctx, 96 + i, ctx->internal_frames[i].paddr + ysize + ysize/4 + ysize/4);
+		/* mvcol buffer for h.264 */
+		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
+		    dev->devtype->product != CODA_DX6)
+			coda_parabuf_write(ctx, 96 + i,
+					   ctx->internal_frames[i].paddr +
+					   ysize + ysize/4 + ysize/4);
 	}
 
+	/* mvcol buffer for mpeg4 */
+	if ((dev->devtype->product != CODA_DX6) &&
+	    (ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4))
+		coda_parabuf_write(ctx, 97, ctx->internal_frames[i].paddr +
+					    ysize + ysize/4 + ysize/4);
+
 	return 0;
 }
 
@@ -1146,6 +1195,49 @@ out:
 	}
 }
 
+static void coda_free_context_buffers(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+
+	if (dev->devtype->product != CODA_DX6)
+		coda_free_aux_buf(dev, &ctx->workbuf);
+}
+
+static int coda_alloc_context_buffers(struct coda_ctx *ctx,
+				      struct coda_q_data *q_data)
+{
+	struct coda_dev *dev = ctx->dev;
+	size_t size;
+	int ret;
+
+	switch (dev->devtype->product) {
+	case CODA_7541:
+		size = CODA7_WORK_BUF_SIZE;
+		break;
+	default:
+		return 0;
+	}
+
+	if (ctx->workbuf.vaddr) {
+		v4l2_err(&dev->v4l2_dev, "context buffer still allocated\n");
+		ret = -EBUSY;
+		return -ENOMEM;
+	}
+
+	ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte context buffer",
+			 ctx->workbuf.size);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	coda_free_context_buffers(ctx);
+	return ret;
+}
+
 static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
@@ -1161,7 +1253,7 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
 		return ret;
 	}
-	*size = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
+	*size = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx)) -
 		coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
 	memcpy(header, vb2_plane_vaddr(buf, 0), *size);
 
@@ -1214,6 +1306,11 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		return -EINVAL;
 	}
 
+	/* Allocate per-instance buffers */
+	ret = coda_alloc_context_buffers(ctx, q_data_src);
+	if (ret < 0)
+		return ret;
+
 	if (!coda_is_initialized(dev)) {
 		v4l2_err(v4l2_dev, "coda is not initialized.\n");
 		return -EFAULT;
@@ -1222,8 +1319,8 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	mutex_lock(&dev->coda_mutex);
 
 	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
-	coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->idx));
-	coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->idx));
+	coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->reg_idx));
+	coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
 	switch (dev->devtype->product) {
 	case CODA_DX6:
 		coda_write(dev, CODADX6_STREAM_BUF_DYNALLOC_EN |
@@ -1648,7 +1745,13 @@ static int coda_open(struct file *file)
 	v4l2_fh_add(&ctx->fh);
 	ctx->dev = dev;
 	ctx->idx = idx;
-
+	switch (dev->devtype->product) {
+	case CODA_7541:
+		ctx->reg_idx = 0;
+		break;
+	default:
+		ctx->reg_idx = idx;
+	}
 	set_default_params(ctx);
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
 					 &coda_queue_init);
@@ -1667,11 +1770,9 @@ static int coda_open(struct file *file)
 
 	ctx->fh.ctrl_handler = &ctx->ctrls;
 
-	ctx->parabuf.vaddr = dma_alloc_coherent(&dev->plat_dev->dev,
-			CODA_PARA_BUF_SIZE, &ctx->parabuf.paddr, GFP_KERNEL);
-	if (!ctx->parabuf.vaddr) {
+	ret = coda_alloc_context_buf(ctx, &ctx->parabuf, CODA_PARA_BUF_SIZE);
+	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
-		ret = -ENOMEM;
 		goto err;
 	}
 
@@ -1706,9 +1807,11 @@ static int coda_release(struct file *file)
 	list_del(&ctx->list);
 	coda_unlock(ctx);
 
-	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
-		ctx->parabuf.vaddr, ctx->parabuf.paddr);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	coda_free_context_buffers(ctx);
+	if (ctx->dev->devtype->product == CODA_DX6)
+		coda_free_aux_buf(dev, &ctx->workbuf);
+
+	coda_free_aux_buf(dev, &ctx->parabuf);
 	v4l2_ctrl_handler_free(&ctx->ctrls);
 	clk_disable_unprepare(dev->clk_per);
 	clk_disable_unprepare(dev->clk_ahb);
@@ -1788,7 +1891,8 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	/* Get results from the coda */
 	coda_read(dev, CODA_RET_ENC_PIC_TYPE);
 	start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
-	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx));
+	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
+
 	/* Calculate bytesused field */
 	if (dst_buf->v4l2_buf.sequence == 0) {
 		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr +
@@ -1858,7 +1962,7 @@ static void coda_timeout(struct work_struct *work)
 
 static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
-	CODA_FIRMWARE_VERNUM(CODA_7541, 13, 4, 29),
+	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
 };
 
 static bool coda_firmware_supported(u32 vernum)
@@ -1923,8 +2027,13 @@ static int coda_hw_init(struct coda_dev *dev)
 		coda_write(dev, 0, CODA_REG_BIT_CODE_BUF_ADDR + i * 4);
 
 	/* Tell the BIT where to find everything it needs */
-	coda_write(dev, dev->workbuf.paddr,
-		      CODA_REG_BIT_WORK_BUF_ADDR);
+	if (dev->devtype->product == CODA_7541) {
+		coda_write(dev, dev->tempbuf.paddr,
+				CODA_REG_BIT_TEMP_BUF_ADDR);
+	} else {
+		coda_write(dev, dev->workbuf.paddr,
+			      CODA_REG_BIT_WORK_BUF_ADDR);
+	}
 	coda_write(dev, dev->codebuf.paddr,
 		      CODA_REG_BIT_CODE_BUF_ADDR);
 	coda_write(dev, 0, CODA_REG_BIT_CODE_RUN);
@@ -2011,11 +2120,8 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	}
 
 	/* allocate auxiliary per-device code buffer for the BIT processor */
-	dev->codebuf.size = fw->size;
-	dev->codebuf.vaddr = dma_alloc_coherent(&pdev->dev, fw->size,
-						    &dev->codebuf.paddr,
-						    GFP_KERNEL);
-	if (!dev->codebuf.vaddr) {
+	ret = coda_alloc_aux_buf(dev, &dev->codebuf, fw->size);
+	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to allocate code buffer\n");
 		return;
 	}
@@ -2205,18 +2311,26 @@ static int coda_probe(struct platform_device *pdev)
 	/* allocate auxiliary per-device buffers for the BIT processor */
 	switch (dev->devtype->product) {
 	case CODA_DX6:
-		dev->workbuf.size = CODADX6_WORK_BUF_SIZE;
+		ret = coda_alloc_aux_buf(dev, &dev->workbuf,
+					 CODADX6_WORK_BUF_SIZE);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to allocate work buffer\n");
+			v4l2_device_unregister(&dev->v4l2_dev);
+			return ret;
+		}
+		break;
+	case CODA_7541:
+		dev->tempbuf.size = CODA7_TEMP_BUF_SIZE;
 		break;
-	default:
-		dev->workbuf.size = CODA7_WORK_BUF_SIZE;
 	}
-	dev->workbuf.vaddr = dma_alloc_coherent(&pdev->dev, dev->workbuf.size,
-						    &dev->workbuf.paddr,
-						    GFP_KERNEL);
-	if (!dev->workbuf.vaddr) {
-		dev_err(&pdev->dev, "failed to allocate work buffer\n");
-		v4l2_device_unregister(&dev->v4l2_dev);
-		return -ENOMEM;
+	if (dev->tempbuf.size) {
+		ret = coda_alloc_aux_buf(dev, &dev->tempbuf,
+					 dev->tempbuf.size);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "failed to allocate temp buffer\n");
+			v4l2_device_unregister(&dev->v4l2_dev);
+			return ret;
+		}
 	}
 
 	if (dev->devtype->product == CODA_DX6)
@@ -2248,12 +2362,9 @@ static int coda_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&dev->v4l2_dev);
 	if (dev->iram_vaddr)
 		gen_pool_free(dev->iram_pool, dev->iram_vaddr, dev->iram_size);
-	if (dev->codebuf.vaddr)
-		dma_free_coherent(&pdev->dev, dev->codebuf.size,
-				  &dev->codebuf.vaddr, dev->codebuf.paddr);
-	if (dev->workbuf.vaddr)
-		dma_free_coherent(&pdev->dev, dev->workbuf.size, &dev->workbuf.vaddr,
-			  dev->workbuf.paddr);
+	coda_free_aux_buf(dev, &dev->codebuf);
+	coda_free_aux_buf(dev, &dev->tempbuf);
+	coda_free_aux_buf(dev, &dev->workbuf);
 	return 0;
 }
 
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index 39c17c6..b2b5b1d 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -43,6 +43,7 @@
 #define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
 #define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
 #define		CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
+#define CODA_REG_BIT_TEMP_BUF_ADDR		0x118
 #define CODA_REG_BIT_RD_PTR(x)			(0x120 + 8 * (x))
 #define CODA_REG_BIT_WR_PTR(x)			(0x124 + 8 * (x))
 #define CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR	0x140
@@ -91,6 +92,14 @@
 #define 	CODA_MODE_INVALID		0xffff
 #define CODA_REG_BIT_INT_ENABLE		0x170
 #define		CODA_INT_INTERRUPT_ENABLE	(1 << 3)
+#define CODA7_REG_BIT_RUN_AUX_STD		0x178
+#define		CODA_MP4_AUX_MPEG4		0
+#define		CODA_MP4_AUX_DIVX3		1
+#define		CODA_VPX_AUX_THO		0
+#define		CODA_VPX_AUX_VP6		1
+#define		CODA_VPX_AUX_VP8		2
+#define		CODA_H264_AUX_AVC		0
+#define		CODA_H264_AUX_MVC		1
 
 /*
  * Commands' mailbox:
-- 
1.8.3.1

