Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:41308 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2H0JOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 05:14:21 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9E00AGLPNRO3K0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Aug 2012 18:14:20 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9E008UBPLLV3D0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Aug 2012 18:14:19 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v5 2/4] [media] s5p-mfc: Add MFC variant data to device context
Date: Mon, 27 Aug 2012 17:28:01 +0530
Message-id: <1346068683-31610-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1346068683-31610-1-git-send-email-arun.kk@samsung.com>
References: <1346068683-31610-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeongtae Park <jtp.park@samsung.com>

MFC variant data replaces various macros used in the driver
which will change in a different version of MFC hardware.
Also does a cleanup of MFC context structure and common files.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Signed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
Signed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/video/s5p-mfc/regs-mfc.h       |   17 ++
 drivers/media/video/s5p-mfc/s5p_mfc.c        |   78 +++++-----
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |   72 ++++++---
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |    7 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |   44 +-----
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c |  213 +++++++++++++++++---------
 7 files changed, 258 insertions(+), 177 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/regs-mfc.h b/drivers/media/video/s5p-mfc/regs-mfc.h
index a19bece..3e2fce0 100644
--- a/drivers/media/video/s5p-mfc/regs-mfc.h
+++ b/drivers/media/video/s5p-mfc/regs-mfc.h
@@ -414,5 +414,22 @@
 #define S5P_FIMV_SHARED_EXTENDED_SAR		0x0078
 #define S5P_FIMV_SHARED_H264_I_PERIOD		0x009C
 #define S5P_FIMV_SHARED_RC_CONTROL_CONFIG	0x00A0
+#define S5P_FIMV_SHARED_DISP_FRAME_TYPE_SHIFT	2
+
+/* Offset used by the hardware to store addresses */
+#define MFC_OFFSET_SHIFT	11
+
+#define FIRMWARE_ALIGN		0x20000		/* 128KB */
+#define MFC_H264_CTX_BUF_SIZE	0x96000		/* 600KB per H264 instance */
+#define MFC_CTX_BUF_SIZE	0x2800		/* 10KB per instance */
+#define DESC_BUF_SIZE		0x20000		/* 128KB for DESC buffer */
+#define SHARED_BUF_SIZE		0x2000		/* 8KB for shared buffer */
+
+#define DEF_CPB_SIZE		0x40000		/* 512KB */
+#define MAX_CPB_SIZE		0x400000	/* 4MB */
+#define MAX_FW_SIZE		0x60000
+
+#define MFC_VERSION		0x51
+#define MFC_NUM_PORTS		2
 
 #endif /* _REGS_FIMV_H */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index ab66680..1ca377e 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -421,7 +421,6 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 				 unsigned int reason, unsigned int err)
 {
 	struct s5p_mfc_dev *dev;
-	unsigned int guard_width, guard_height;
 
 	if (ctx == NULL)
 		return;
@@ -433,40 +432,8 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 		ctx->img_width = s5p_mfc_get_img_width(dev);
 		ctx->img_height = s5p_mfc_get_img_height(dev);
 
-		ctx->buf_width = ALIGN(ctx->img_width,
-						S5P_FIMV_NV12MT_HALIGN);
-		ctx->buf_height = ALIGN(ctx->img_height,
-						S5P_FIMV_NV12MT_VALIGN);
-		mfc_debug(2, "SEQ Done: Movie dimensions %dx%d, "
-			"buffer dimensions: %dx%d\n", ctx->img_width,
-				ctx->img_height, ctx->buf_width,
-						ctx->buf_height);
-		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
-			ctx->luma_size = ALIGN(ctx->buf_width *
-				ctx->buf_height, S5P_FIMV_DEC_BUF_ALIGN);
-			ctx->chroma_size = ALIGN(ctx->buf_width *
-					 ALIGN((ctx->img_height >> 1),
-					       S5P_FIMV_NV12MT_VALIGN),
-					       S5P_FIMV_DEC_BUF_ALIGN);
-			ctx->mv_size = ALIGN(ctx->buf_width *
-					ALIGN((ctx->buf_height >> 2),
-					S5P_FIMV_NV12MT_VALIGN),
-					S5P_FIMV_DEC_BUF_ALIGN);
-		} else {
-			guard_width = ALIGN(ctx->img_width + 24,
-					S5P_FIMV_NV12MT_HALIGN);
-			guard_height = ALIGN(ctx->img_height + 16,
-						S5P_FIMV_NV12MT_VALIGN);
-			ctx->luma_size = ALIGN(guard_width *
-				guard_height, S5P_FIMV_DEC_BUF_ALIGN);
-			guard_width = ALIGN(ctx->img_width + 16,
-						S5P_FIMV_NV12MT_HALIGN);
-			guard_height = ALIGN((ctx->img_height >> 1) + 4,
-						S5P_FIMV_NV12MT_VALIGN);
-			ctx->chroma_size = ALIGN(guard_width *
-				guard_height, S5P_FIMV_DEC_BUF_ALIGN);
-			ctx->mv_size = 0;
-		}
+		s5p_mfc_dec_calc_dpb_size(ctx);
+
 		ctx->dpb_count = s5p_mfc_get_dpb_count(dev);
 		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
@@ -960,6 +927,9 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	dev->variant = (struct s5p_mfc_variant *)
+		platform_get_device_id(pdev)->driver_data;
+
 	ret = s5p_mfc_init_pm(dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to get mfc clock source\n");
@@ -1207,9 +1177,43 @@ static const struct dev_pm_ops s5p_mfc_pm_ops = {
 			   NULL)
 };
 
+struct s5p_mfc_buf_size_v5 mfc_buf_size_v5 = {
+	.h264_ctx	= MFC_H264_CTX_BUF_SIZE,
+	.non_h264_ctx	= MFC_CTX_BUF_SIZE,
+	.dsc		= DESC_BUF_SIZE,
+	.shm		= SHARED_BUF_SIZE,
+};
+
+struct s5p_mfc_buf_size buf_size_v5 = {
+	.fw	= MAX_FW_SIZE,
+	.cpb	= MAX_CPB_SIZE,
+	.priv	= &mfc_buf_size_v5,
+};
+
+struct s5p_mfc_buf_align mfc_buf_align_v5 = {
+	.base = MFC_BASE_ALIGN_ORDER,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v5 = {
+	.version	= MFC_VERSION,
+	.port_num	= MFC_NUM_PORTS,
+	.buf_size	= &buf_size_v5,
+	.buf_align	= &mfc_buf_align_v5,
+};
+
+static struct platform_device_id mfc_driver_ids[] = {
+	{
+		.name = "s5p-mfc",
+		.driver_data = (unsigned long)&mfc_drvdata_v5,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
+
 static struct platform_driver s5p_mfc_driver = {
-	.probe	= s5p_mfc_probe,
-	.remove	= __devexit_p(s5p_mfc_remove),
+	.probe		= s5p_mfc_probe,
+	.remove		= __devexit_p(s5p_mfc_remove),
+	.id_table	= mfc_driver_ids,
 	.driver	= {
 		.name	= S5P_MFC_NAME,
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
index e285dd3..a99d3eb 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
@@ -111,8 +111,8 @@ int s5p_mfc_open_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
 		h2r_args.arg[0] = S5P_FIMV_CODEC_NONE;
 	};
 	h2r_args.arg[1] = 0; /* no crc & no pixelcache */
-	h2r_args.arg[2] = ctx->ctx_ofs;
-	h2r_args.arg[3] = ctx->ctx_size;
+	h2r_args.arg[2] = ctx->ctx.ofs;
+	h2r_args.arg[3] = ctx->ctx.size;
 	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE,
 								&h2r_args);
 	if (ret) {
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
index 9834b4e..0c1618e 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -30,17 +30,6 @@
 *  while mmaping */
 #define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
 
-/* Offset used by the hardware to store addresses */
-#define MFC_OFFSET_SHIFT	11
-
-#define FIRMWARE_ALIGN		0x20000		/* 128KB */
-#define MFC_H264_CTX_BUF_SIZE	0x96000		/* 600KB per H264 instance */
-#define MFC_CTX_BUF_SIZE	0x2800		/* 10KB per instance */
-#define DESC_BUF_SIZE		0x20000		/* 128KB for DESC buffer */
-#define SHARED_BUF_SIZE		0x2000		/* 8KB for shared buffer */
-
-#define DEF_CPB_SIZE		0x40000		/* 512KB */
-
 #define MFC_BANK1_ALLOC_CTX	0
 #define MFC_BANK2_ALLOC_CTX	1
 
@@ -207,6 +196,47 @@ struct s5p_mfc_pm {
 	struct device	*device;
 };
 
+struct s5p_mfc_buf_size_v5 {
+	unsigned int h264_ctx;
+	unsigned int non_h264_ctx;
+	unsigned int dsc;
+	unsigned int shm;
+};
+
+struct s5p_mfc_buf_size {
+	unsigned int fw;
+	unsigned int cpb;
+	void *priv;
+};
+
+struct s5p_mfc_buf_align {
+	unsigned int base;
+};
+
+struct s5p_mfc_variant {
+	unsigned int version;
+	unsigned int port_num;
+	struct s5p_mfc_buf_size *buf_size;
+	struct s5p_mfc_buf_align *buf_align;
+};
+
+/**
+ * struct s5p_mfc_priv_buf - represents internal used buffer
+ * @alloc:		allocation-specific context for each buffer
+ *			(videobuf2 allocator)
+ * @ofs:		offset of each buffer, will be used for MFC
+ * @virt:		kernel virtual address, only valid when the
+ *			buffer accessed by driver
+ * @dma:		DMA address, only valid when kernel DMA API used
+ */
+struct s5p_mfc_priv_buf {
+	void		*alloc;
+	unsigned long	ofs;
+	void		*virt;
+	dma_addr_t	dma;
+	size_t		size;
+};
+
 /**
  * struct s5p_mfc_dev - The struct containing driver internal parameters.
  *
@@ -257,6 +287,7 @@ struct s5p_mfc_dev {
 	struct v4l2_ctrl_handler dec_ctrl_handler;
 	struct v4l2_ctrl_handler enc_ctrl_handler;
 	struct s5p_mfc_pm	pm;
+	struct s5p_mfc_variant	*variant;
 	int num_inst;
 	spinlock_t irqlock;	/* lock when operating on videobuf2 queues */
 	spinlock_t condlock;	/* lock when changing/checking if a context is
@@ -295,7 +326,6 @@ struct s5p_mfc_h264_enc_params {
 	u8 max_ref_pic;
 	u8 num_ref_pic_4p;
 	int _8x8_transform;
-	int rc_mb;
 	int rc_mb_dark;
 	int rc_mb_smooth;
 	int rc_mb_static;
@@ -314,6 +344,7 @@ struct s5p_mfc_h264_enc_params {
 	enum v4l2_mpeg_video_h264_level level_v4l2;
 	int level;
 	u16 cpb_size;
+	int interlace;
 };
 
 /**
@@ -352,6 +383,7 @@ struct s5p_mfc_enc_params {
 	u8 pad_cb;
 	u8 pad_cr;
 	int rc_frame;
+	int rc_mb;
 	u32 rc_bitrate;
 	u16 rc_reaction_coeff;
 	u16 vbv_size;
@@ -363,7 +395,6 @@ struct s5p_mfc_enc_params {
 	u8 num_b_frame;
 	u32 rc_framerate_num;
 	u32 rc_framerate_denom;
-	int interlace;
 
 	union {
 		struct s5p_mfc_h264_enc_params h264;
@@ -540,18 +571,9 @@ struct s5p_mfc_ctx {
 	int total_dpb_count;
 
 	/* Buffers */
-	void *ctx_buf;
-	size_t ctx_phys;
-	size_t ctx_ofs;
-	size_t ctx_size;
-
-	void *desc_buf;
-	size_t desc_phys;
-
-
-	void *shm_alloc;
-	void *shm;
-	size_t shm_ofs;
+	struct s5p_mfc_priv_buf ctx;
+	struct s5p_mfc_priv_buf dsc;
+	struct s5p_mfc_priv_buf shm;
 
 	struct s5p_mfc_enc_params enc_params;
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
index c9a5189..5bffc8b 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -43,7 +43,12 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
 		return -EINVAL;
 	}
-	dev->fw_size = ALIGN(fw_blob->size, FIRMWARE_ALIGN);
+	dev->fw_size = dev->variant->buf_size->fw;
+	if (fw_blob->size > dev->fw_size) {
+		mfc_err("MFC firmware is too big to be loaded\n");
+		release_firmware(fw_blob);
+		return -ENOMEM;
+	}
 	if (s5p_mfc_bitproc_buf) {
 		mfc_err("Attempting to allocate firmware when it seems that it is already loaded\n");
 		release_firmware(fw_blob);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 15e24df..2f0df00 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -980,45 +980,13 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		mfc_debug(2, "fmt - w: %d, h: %d, ctx - w: %d, h: %d\n",
 			pix_fmt_mp->width, pix_fmt_mp->height,
 			ctx->img_width, ctx->img_height);
-		if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
-			ctx->buf_width = ALIGN(ctx->img_width,
-							S5P_FIMV_NV12M_HALIGN);
-			ctx->luma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12M_HALIGN) * ALIGN(ctx->img_height,
-				S5P_FIMV_NV12M_LVALIGN);
-			ctx->chroma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12M_HALIGN) * ALIGN((ctx->img_height
-				>> 1), S5P_FIMV_NV12M_CVALIGN);
-
-			ctx->luma_size = ALIGN(ctx->luma_size,
-							S5P_FIMV_NV12M_SALIGN);
-			ctx->chroma_size = ALIGN(ctx->chroma_size,
-							S5P_FIMV_NV12M_SALIGN);
-
-			pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
-			pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
-			pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
-			pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
-
-		} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
-			ctx->buf_width = ALIGN(ctx->img_width,
-							S5P_FIMV_NV12MT_HALIGN);
-			ctx->luma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12MT_HALIGN)	* ALIGN(ctx->img_height,
-				S5P_FIMV_NV12MT_VALIGN);
-			ctx->chroma_size = ALIGN(ctx->img_width,
-				S5P_FIMV_NV12MT_HALIGN) * ALIGN((ctx->img_height
-				>> 1), S5P_FIMV_NV12MT_VALIGN);
-			ctx->luma_size = ALIGN(ctx->luma_size,
-							S5P_FIMV_NV12MT_SALIGN);
-			ctx->chroma_size = ALIGN(ctx->chroma_size,
-							S5P_FIMV_NV12MT_SALIGN);
-
-			pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
-			pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
-			pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
-			pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
-		}
+
+		s5p_mfc_enc_calc_src_size(ctx);
+		pix_fmt_mp->plane_fmt[0].sizeimage = ctx->luma_size;
+		pix_fmt_mp->plane_fmt[0].bytesperline = ctx->buf_width;
+		pix_fmt_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
+		pix_fmt_mp->plane_fmt[1].bytesperline = ctx->buf_width;
+
 		ctx->src_bufs_cnt = 0;
 		ctx->output_state = QUEUE_FREE;
 	} else {
@@ -1343,7 +1311,7 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 		p->codec.h264._8x8_transform = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
-		p->codec.h264.rc_mb = ctrl->val;
+		p->rc_mb = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
 		p->codec.h264.rc_frame_qp = ctrl->val;
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
index 1e019cc..12e171f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
@@ -36,28 +36,29 @@
 /* Allocate temporary buffers for decoding */
 int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
-	void *desc_virt;
 	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
 
-	ctx->desc_buf = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
-	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
-		ctx->desc_buf = NULL;
+	ctx->dsc.alloc = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX],
+			buf_size->dsc);
+	if (IS_ERR_VALUE((int)ctx->dsc.alloc)) {
+		ctx->dsc.alloc = NULL;
 		mfc_err("Allocating DESC buffer failed\n");
 		return -ENOMEM;
 	}
-	ctx->desc_phys = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->desc_buf);
-	BUG_ON(ctx->desc_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	desc_virt = vb2_dma_contig_memops.vaddr(ctx->desc_buf);
-	if (desc_virt == NULL) {
-		vb2_dma_contig_memops.put(ctx->desc_buf);
-		ctx->desc_phys = 0;
-		ctx->desc_buf = NULL;
+	ctx->dsc.dma = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->dsc.alloc);
+	BUG_ON(ctx->dsc.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	ctx->dsc.virt = vb2_dma_contig_memops.vaddr(ctx->dsc.alloc);
+	if (ctx->dsc.virt == NULL) {
+		vb2_dma_contig_memops.put(ctx->dsc.alloc);
+		ctx->dsc.dma = 0;
+		ctx->dsc.alloc = NULL;
 		mfc_err("Remapping DESC buffer failed\n");
 		return -ENOMEM;
 	}
-	memset(desc_virt, 0, DESC_BUF_SIZE);
+	memset(ctx->dsc.virt, 0, buf_size->dsc);
 	wmb();
 	return 0;
 }
@@ -65,10 +66,10 @@ int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 /* Release temporary buffers for decoding */
 void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->desc_phys) {
-		vb2_dma_contig_memops.put(ctx->desc_buf);
-		ctx->desc_phys = 0;
-		ctx->desc_buf = NULL;
+	if (ctx->dsc.dma) {
+		vb2_dma_contig_memops.put(ctx->dsc.alloc);
+		ctx->dsc.alloc = NULL;
+		ctx->dsc.dma = 0;
 	}
 }
 
@@ -229,60 +230,60 @@ void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 /* Allocate memory for instance data buffer */
 int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	void *context_virt;
 	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
 
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
-		ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
-		ctx->ctx_size = MFC_H264_CTX_BUF_SIZE;
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
+		ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
+		ctx->ctx.size = buf_size->h264_ctx;
 	else
-		ctx->ctx_size = MFC_CTX_BUF_SIZE;
-	ctx->ctx_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_size);
-	if (IS_ERR(ctx->ctx_buf)) {
+		ctx->ctx.size = buf_size->non_h264_ctx;
+	ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.size);
+	if (IS_ERR(ctx->ctx.alloc)) {
 		mfc_err("Allocating context buffer failed\n");
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = NULL;
+		ctx->ctx.alloc = NULL;
 		return -ENOMEM;
 	}
-	ctx->ctx_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_buf);
-	BUG_ON(ctx->ctx_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	ctx->ctx_ofs = OFFSETA(ctx->ctx_phys);
-	context_virt = vb2_dma_contig_memops.vaddr(ctx->ctx_buf);
-	if (context_virt == NULL) {
+	ctx->ctx.dma = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
+	BUG_ON(ctx->ctx.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	ctx->ctx.ofs = OFFSETA(ctx->ctx.dma);
+	ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
+	if (!ctx->ctx.virt) {
 		mfc_err("Remapping instance buffer failed\n");
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = NULL;
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.ofs = 0;
+		ctx->ctx.dma = 0;
 		return -ENOMEM;
 	}
 	/* Zero content of the allocated memory */
-	memset(context_virt, 0, ctx->ctx_size);
+	memset(ctx->ctx.virt, 0, ctx->ctx.size);
 	wmb();
 
 	/* Initialize shared memory */
-	ctx->shm_alloc = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], SHARED_BUF_SIZE);
-	if (IS_ERR(ctx->shm_alloc)) {
+	ctx->shm.alloc = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], buf_size->shm);
+	if (IS_ERR(ctx->shm.alloc)) {
 		mfc_err("failed to allocate shared memory\n");
-		return PTR_ERR(ctx->shm_alloc);
+		return PTR_ERR(ctx->shm.alloc);
 	}
 	/* shared memory offset only keeps the offset from base (port a) */
-	ctx->shm_ofs = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->shm_alloc)
+	ctx->shm.ofs = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->shm.alloc)
 								- dev->bank1;
-	BUG_ON(ctx->shm_ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	BUG_ON(ctx->shm.ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 
-	ctx->shm = vb2_dma_contig_memops.vaddr(ctx->shm_alloc);
-	if (!ctx->shm) {
-		vb2_dma_contig_memops.put(ctx->shm_alloc);
-		ctx->shm_ofs = 0;
-		ctx->shm_alloc = NULL;
+	ctx->shm.virt = vb2_dma_contig_memops.vaddr(ctx->shm.alloc);
+	if (!ctx->shm.virt) {
+		vb2_dma_contig_memops.put(ctx->shm.alloc);
+		ctx->shm.alloc = NULL;
+		ctx->shm.ofs = 0;
 		mfc_err("failed to virt addr of shared memory\n");
 		return -ENOMEM;
 	}
-	memset((void *)ctx->shm, 0, SHARED_BUF_SIZE);
+	memset((void *)ctx->shm.virt, 0, buf_size->shm);
 	wmb();
 	return 0;
 }
@@ -290,15 +291,18 @@ int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->ctx_buf) {
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = NULL;
+	if (ctx->ctx.alloc) {
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.ofs = 0;
+		ctx->ctx.virt = NULL;
+		ctx->ctx.dma = 0;
 	}
-	if (ctx->shm_alloc) {
-		vb2_dma_contig_memops.put(ctx->shm_alloc);
-		ctx->shm_alloc = NULL;
-		ctx->shm = NULL;
+	if (ctx->shm.alloc) {
+		vb2_dma_contig_memops.put(ctx->shm.alloc);
+		ctx->shm.alloc = NULL;
+		ctx->shm.ofs = 0;
+		ctx->shm.virt = NULL;
 	}
 }
 
@@ -317,7 +321,7 @@ void s5p_mfc_release_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
 static void s5p_mfc_write_info_v5(struct s5p_mfc_ctx *ctx, unsigned int data,
 			unsigned int ofs)
 {
-	writel(data, (ctx->shm + ofs));
+	writel(data, (ctx->shm.virt + ofs));
 	wmb();
 }
 
@@ -325,33 +329,94 @@ static unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
 				unsigned int ofs)
 {
 	rmb();
-	return readl(ctx->shm + ofs);
+	return readl(ctx->shm.virt + ofs);
 }
 
 void s5p_mfc_dec_calc_dpb_size_v5(struct s5p_mfc_ctx *ctx)
 {
-	/* NOP */
+	unsigned int guard_width, guard_height;
+
+	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN);
+	ctx->buf_height = ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+	mfc_debug(2,
+		"SEQ Done: Movie dimensions %dx%d, buffer dimensions: %dx%d\n",
+		ctx->img_width,	ctx->img_height, ctx->buf_width,
+		ctx->buf_height);
+
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC) {
+		ctx->luma_size = ALIGN(ctx->buf_width * ctx->buf_height,
+				S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->chroma_size = ALIGN(ctx->buf_width *
+				ALIGN((ctx->img_height >> 1),
+					S5P_FIMV_NV12MT_VALIGN),
+				S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->mv_size = ALIGN(ctx->buf_width *
+				ALIGN((ctx->buf_height >> 2),
+					S5P_FIMV_NV12MT_VALIGN),
+				S5P_FIMV_DEC_BUF_ALIGN);
+	} else {
+		guard_width =
+			ALIGN(ctx->img_width + 24, S5P_FIMV_NV12MT_HALIGN);
+		guard_height =
+			ALIGN(ctx->img_height + 16, S5P_FIMV_NV12MT_VALIGN);
+		ctx->luma_size = ALIGN(guard_width * guard_height,
+				S5P_FIMV_DEC_BUF_ALIGN);
+
+		guard_width =
+			ALIGN(ctx->img_width + 16, S5P_FIMV_NV12MT_HALIGN);
+		guard_height =
+			ALIGN((ctx->img_height >> 1) + 4,
+					S5P_FIMV_NV12MT_VALIGN);
+		ctx->chroma_size = ALIGN(guard_width * guard_height,
+				S5P_FIMV_DEC_BUF_ALIGN);
+
+		ctx->mv_size = 0;
+	}
 }
 
 void s5p_mfc_enc_calc_src_size_v5(struct s5p_mfc_ctx *ctx)
 {
-	/* NOP */
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
+		ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN);
+
+		ctx->luma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN)
+			* ALIGN(ctx->img_height, S5P_FIMV_NV12M_LVALIGN);
+		ctx->chroma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN)
+			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12M_CVALIGN);
+
+		ctx->luma_size = ALIGN(ctx->luma_size, S5P_FIMV_NV12M_SALIGN);
+		ctx->chroma_size =
+			ALIGN(ctx->chroma_size, S5P_FIMV_NV12M_SALIGN);
+	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
+		ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN);
+
+		ctx->luma_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+		ctx->chroma_size =
+			ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12MT_VALIGN);
+
+		ctx->luma_size = ALIGN(ctx->luma_size, S5P_FIMV_NV12MT_SALIGN);
+		ctx->chroma_size =
+			ALIGN(ctx->chroma_size, S5P_FIMV_NV12MT_SALIGN);
+	}
 }
 
 /* Set registers for decoding temporary buffers */
 static void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
 
-	mfc_write(dev, OFFSETA(ctx->desc_phys), S5P_FIMV_SI_CH0_DESC_ADR);
-	mfc_write(dev, DESC_BUF_SIZE, S5P_FIMV_SI_CH0_DESC_SIZE);
+	mfc_write(dev, OFFSETA(ctx->dsc.dma), S5P_FIMV_SI_CH0_DESC_ADR);
+	mfc_write(dev, buf_size->dsc, S5P_FIMV_SI_CH0_DESC_SIZE);
 }
 
 /* Set registers for shared buffer */
 static void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	mfc_write(dev, ctx->shm_ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
+	mfc_write(dev, ctx->shm.ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
 }
 
 /* Set registers for decoding stream buffer */
@@ -775,9 +840,9 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= p_264->profile;
 	mfc_write(dev, reg, S5P_FIMV_ENC_PROFILE);
 	/* interlace  */
-	mfc_write(dev, p->interlace, S5P_FIMV_ENC_PIC_STRUCT);
+	mfc_write(dev, p_264->interlace, S5P_FIMV_ENC_PIC_STRUCT);
 	/* height */
-	if (p->interlace)
+	if (p_264->interlace)
 		mfc_write(dev, ctx->img_height >> 1, S5P_FIMV_ENC_VSIZE_PX);
 	/* loopfilter ctrl */
 	mfc_write(dev, p_264->loop_filter_mode, S5P_FIMV_ENC_LF_CTRL);
@@ -819,7 +884,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
 	/* macroblock level rate control */
 	reg &= ~(0x1 << 8);
-	reg |= (p_264->rc_mb << 8);
+	reg |= (p->rc_mb << 8);
 	/* frame QP */
 	reg &= ~(0x3F);
 	reg |= p_264->rc_frame_qp;
@@ -840,7 +905,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	reg |= p_264->rc_min_qp;
 	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
 	/* macroblock adaptive scaling features */
-	if (p_264->rc_mb) {
+	if (p->rc_mb) {
 		reg = mfc_read(dev, S5P_FIMV_ENC_RC_MB_CTRL);
 		/* dark region */
 		reg &= ~(0x1 << 3);
@@ -856,8 +921,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 		reg |= p_264->rc_mb_activity;
 		mfc_write(dev, reg, S5P_FIMV_ENC_RC_MB_CTRL);
 	}
-	if (!p->rc_frame &&
-	    !p_264->rc_mb) {
+	if (!p->rc_frame && !p->rc_mb) {
 		shm = s5p_mfc_read_info_v5(ctx, P_B_FRAME_QP);
 		shm &= ~(0xFFF);
 		shm |= ((p_264->rc_b_frame_qp & 0x3F) << 6);
@@ -1483,8 +1547,9 @@ int s5p_mfc_get_dec_frame_type_v5(struct s5p_mfc_dev *dev)
 
 int s5p_mfc_get_disp_frame_type_v5(struct s5p_mfc_ctx *ctx)
 {
-	/* NOP */
-	return -1;
+	return (s5p_mfc_read_info_v5(ctx, DISP_PIC_FRAME_TYPE) >>
+			S5P_FIMV_SHARED_DISP_FRAME_TYPE_SHIFT) &
+			S5P_FIMV_DECODE_FRAME_MASK;
 }
 
 int s5p_mfc_get_consumed_stream_v5(struct s5p_mfc_dev *dev)
-- 
1.7.0.4

