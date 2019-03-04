Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1164DC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 19:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D28FC2070B
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 19:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfCDT05 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 14:26:57 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50342 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDT05 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 14:26:57 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id BBC60276DFA
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 06/11] rockchip/vpu: Cleanup JPEG bounce buffer management
Date:   Mon,  4 Mar 2019 16:25:24 -0300
Message-Id: <20190304192529.14200-7-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190304192529.14200-1-ezequiel@collabora.com>
References: <20190304192529.14200-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In order to make the code more generic, introduce a pair of start/stop
codec operations, and use them to allocate and release the JPEG bounce
buffer.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../media/rockchip/vpu/rk3288_vpu_hw.c        |  2 ++
 .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     |  4 +--
 .../media/rockchip/vpu/rk3399_vpu_hw.c        |  2 ++
 .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     |  4 +--
 .../staging/media/rockchip/vpu/rockchip_vpu.h | 12 ++++----
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 10 +++++--
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 23 +++++----------
 .../media/rockchip/vpu/rockchip_vpu_hw.h      | 28 +++++++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_jpeg.c    | 25 +++++++++++++++++
 9 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
index a5e9d183fffd..056ee017c798 100644
--- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
+++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
@@ -98,6 +98,8 @@ static const struct rockchip_vpu_codec_ops rk3288_vpu_codec_ops[] = {
 	[RK_VPU_MODE_JPEG_ENC] = {
 		.run = rk3288_vpu_jpeg_enc_run,
 		.reset = rk3288_vpu_enc_reset,
+		.start = rockchip_vpu_jpeg_enc_start,
+		.stop = rockchip_vpu_jpeg_enc_stop,
 	},
 };
 
diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
index 06daea66fb49..b05b1fdcff90 100644
--- a/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
@@ -37,9 +37,9 @@ static void rk3288_vpu_jpeg_enc_set_buffers(struct rockchip_vpu_dev *vpu,
 
 	WARN_ON(pix_fmt->num_planes > 3);
 
-	vepu_write_relaxed(vpu, ctx->bounce_dma_addr,
+	vepu_write_relaxed(vpu, ctx->jpeg_enc_ctx.bounce_buffer.dma,
 			   VEPU_REG_ADDR_OUTPUT_STREAM);
-	vepu_write_relaxed(vpu, ctx->bounce_size,
+	vepu_write_relaxed(vpu, ctx->jpeg_enc_ctx.bounce_buffer.size,
 			   VEPU_REG_STR_BUF_LIMIT);
 
 	if (pix_fmt->num_planes == 1) {
diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
index 6fdef61e2127..8469e474c975 100644
--- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
+++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
@@ -98,6 +98,8 @@ static const struct rockchip_vpu_codec_ops rk3399_vpu_codec_ops[] = {
 	[RK_VPU_MODE_JPEG_ENC] = {
 		.run = rk3399_vpu_jpeg_enc_run,
 		.reset = rk3399_vpu_enc_reset,
+		.start = rockchip_vpu_jpeg_enc_start,
+		.stop = rockchip_vpu_jpeg_enc_stop,
 	},
 };
 
diff --git a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
index 3d438797692e..fe92c40d0a84 100644
--- a/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
@@ -69,9 +69,9 @@ static void rk3399_vpu_jpeg_enc_set_buffers(struct rockchip_vpu_dev *vpu,
 
 	WARN_ON(pix_fmt->num_planes > 3);
 
-	vepu_write_relaxed(vpu, ctx->bounce_dma_addr,
+	vepu_write_relaxed(vpu, ctx->jpeg_enc_ctx.bounce_buffer.dma,
 			   VEPU_REG_ADDR_OUTPUT_STREAM);
-	vepu_write_relaxed(vpu, ctx->bounce_size,
+	vepu_write_relaxed(vpu, ctx->jpeg_enc_ctx.bounce_buffer.size,
 			   VEPU_REG_STR_BUF_LIMIT);
 
 	if (pix_fmt->num_planes == 1) {
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
index 1ec2be483e27..76ee24abc141 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
@@ -124,10 +124,7 @@ struct rockchip_vpu_dev {
  * @jpeg_quality:	User-specified JPEG compression quality.
  *
  * @codec_ops:		Set of operations related to codec mode.
- *
- * @bounce_dma_addr:	Bounce buffer bus address.
- * @bounce_buf:		Bounce buffer pointer.
- * @bounce_size:	Bounce buffer size.
+ * @jpeg_enc_ctx:	JPEG-encoding context.
  */
 struct rockchip_vpu_ctx {
 	struct rockchip_vpu_dev *dev;
@@ -146,9 +143,10 @@ struct rockchip_vpu_ctx {
 
 	const struct rockchip_vpu_codec_ops *codec_ops;
 
-	dma_addr_t bounce_dma_addr;
-	void *bounce_buf;
-	size_t bounce_size;
+	/* Specific for particular codec modes. */
+	union {
+		struct rockchip_vpu_jpeg_enc_hw_ctx jpeg_enc_ctx;
+	};
 };
 
 /**
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 5647b0bdac20..1a6dd36c71ab 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -64,10 +64,16 @@ static void rockchip_vpu_job_finish(struct rockchip_vpu_dev *vpu,
 	avail_size = vb2_plane_size(&dst->vb2_buf, 0) -
 		     ctx->vpu_dst_fmt->header_size;
 	if (bytesused <= avail_size) {
-		if (ctx->bounce_buf) {
+		/*
+		 * This works while JPEG is the only encoder this driver
+		 * supports. We will have to abstract this step, or get
+		 * rid of the bounce buffer before we can support
+		 * encoding other codecs.
+		 */
+		if (ctx->jpeg_enc_ctx.bounce_buffer.cpu) {
 			memcpy(vb2_plane_vaddr(&dst->vb2_buf, 0) +
 			       ctx->vpu_dst_fmt->header_size,
-			       ctx->bounce_buf, bytesused);
+			       ctx->jpeg_enc_ctx.bounce_buffer.cpu, bytesused);
 		}
 		dst->vb2_buf.planes[0].bytesused =
 			ctx->vpu_dst_fmt->header_size + bytesused;
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
index ae1ff3d9b9d2..2b28403314bc 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
@@ -514,6 +514,7 @@ static int rockchip_vpu_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
 	enum rockchip_vpu_codec_mode codec_mode;
+	int ret = 0;
 
 	if (V4L2_TYPE_IS_OUTPUT(q->type))
 		ctx->sequence_out = 0;
@@ -526,17 +527,10 @@ static int rockchip_vpu_start_streaming(struct vb2_queue *q, unsigned int count)
 	vpu_debug(4, "Codec mode = %d\n", codec_mode);
 	ctx->codec_ops = &ctx->dev->variant->codec_ops[codec_mode];
 
-	/* A bounce buffer is needed for the JPEG payload */
-	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
-		ctx->bounce_size = ctx->dst_fmt.plane_fmt[0].sizeimage -
-				  ctx->vpu_dst_fmt->header_size;
-		ctx->bounce_buf = dma_alloc_attrs(ctx->dev->dev,
-						  ctx->bounce_size,
-						  &ctx->bounce_dma_addr,
-						  GFP_KERNEL,
-						  DMA_ATTR_ALLOC_SINGLE_PAGES);
-	}
-	return 0;
+	if (!V4L2_TYPE_IS_OUTPUT(q->type))
+		if (ctx->codec_ops && ctx->codec_ops->start)
+			ret = ctx->codec_ops->start(ctx);
+	return ret;
 }
 
 static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
@@ -544,11 +538,8 @@ static void rockchip_vpu_stop_streaming(struct vb2_queue *q)
 	struct rockchip_vpu_ctx *ctx = vb2_get_drv_priv(q);
 
 	if (!V4L2_TYPE_IS_OUTPUT(q->type))
-		dma_free_attrs(ctx->dev->dev,
-			       ctx->bounce_size,
-			       ctx->bounce_buf,
-			       ctx->bounce_dma_addr,
-			       DMA_ATTR_ALLOC_SINGLE_PAGES);
+		if (ctx->codec_ops && ctx->codec_ops->stop)
+			ctx->codec_ops->stop(ctx);
 
 	/*
 	 * The mem2mem framework calls v4l2_m2m_cancel_job before
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
index 2b955da1be1a..e2e84526f263 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
@@ -18,9 +18,33 @@ struct rockchip_vpu_ctx;
 struct rockchip_vpu_buf;
 struct rockchip_vpu_variant;
 
+/**
+ * struct rockchip_vpu_aux_buf - auxiliary DMA buffer for hardware data
+ * @cpu:	CPU pointer to the buffer.
+ * @dma:	DMA address of the buffer.
+ * @size:	Size of the buffer.
+ */
+struct rockchip_vpu_aux_buf {
+	void *cpu;
+	dma_addr_t dma;
+	size_t size;
+};
+
+/**
+ * struct rockchip_vpu_jpeg_enc_hw_ctx
+ * @bounce_buffer:	Bounce buffer
+ */
+struct rockchip_vpu_jpeg_enc_hw_ctx {
+	struct rockchip_vpu_aux_buf bounce_buffer;
+};
+
 /**
  * struct rockchip_vpu_codec_ops - codec mode specific operations
  *
+ * @start:	If needed, can be used for initialization.
+ *		Optional and called from process context.
+ * @stop:	If needed, can be used to undo the .start phase.
+ *		Optional and called from process context.
  * @run:	Start single {en,de)coding job. Called from atomic context
  *		to indicate that a pair of buffers is ready and the hardware
  *		should be programmed and started.
@@ -28,6 +52,8 @@ struct rockchip_vpu_variant;
  * @reset:	Reset the hardware in case of a timeout.
  */
 struct rockchip_vpu_codec_ops {
+	int (*start)(struct rockchip_vpu_ctx *ctx);
+	void (*stop)(struct rockchip_vpu_ctx *ctx);
 	void (*run)(struct rockchip_vpu_ctx *ctx);
 	void (*done)(struct rockchip_vpu_ctx *ctx, enum vb2_buffer_state);
 	void (*reset)(struct rockchip_vpu_ctx *ctx);
@@ -54,5 +80,7 @@ void rockchip_vpu_irq_done(struct rockchip_vpu_dev *vpu,
 
 void rk3288_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx);
 void rk3399_vpu_jpeg_enc_run(struct rockchip_vpu_ctx *ctx);
+int rockchip_vpu_jpeg_enc_start(struct rockchip_vpu_ctx *ctx);
+void rockchip_vpu_jpeg_enc_stop(struct rockchip_vpu_ctx *ctx);
 
 #endif /* ROCKCHIP_VPU_HW_H_ */
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
index 0ff0badc1f7a..3244cca4e915 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
@@ -6,9 +6,11 @@
  * Copyright (C) Jean-Francois Moine (http://moinejf.free.fr)
  * Copyright (C) 2014 Philipp Zabel, Pengutronix
  */
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include "rockchip_vpu_jpeg.h"
+#include "rockchip_vpu.h"
 
 #define LUMA_QUANT_OFF		7
 #define CHROMA_QUANT_OFF	72
@@ -288,3 +290,26 @@ void rockchip_vpu_jpeg_header_assemble(struct rockchip_vpu_jpeg_ctx *ctx)
 
 	jpeg_set_quality(buf, ctx->quality);
 }
+
+int rockchip_vpu_jpeg_enc_start(struct rockchip_vpu_ctx *ctx)
+{
+	ctx->jpeg_enc_ctx.bounce_buffer.size = ctx->dst_fmt.plane_fmt[0].sizeimage -
+			  ctx->vpu_dst_fmt->header_size;
+	ctx->jpeg_enc_ctx.bounce_buffer.cpu = dma_alloc_attrs(ctx->dev->dev,
+					ctx->jpeg_enc_ctx.bounce_buffer.size,
+					&ctx->jpeg_enc_ctx.bounce_buffer.dma,
+					GFP_KERNEL,
+					DMA_ATTR_ALLOC_SINGLE_PAGES);
+	if (!ctx->jpeg_enc_ctx.bounce_buffer.cpu)
+		return -ENOMEM;
+	return 0;
+}
+
+void rockchip_vpu_jpeg_enc_stop(struct rockchip_vpu_ctx *ctx)
+{
+	dma_free_attrs(ctx->dev->dev,
+		       ctx->jpeg_enc_ctx.bounce_buffer.size,
+		       ctx->jpeg_enc_ctx.bounce_buffer.cpu,
+		       ctx->jpeg_enc_ctx.bounce_buffer.dma,
+		       DMA_ATTR_ALLOC_SINGLE_PAGES);
+}
-- 
2.20.1

