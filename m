Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52476 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935730AbeFMOHc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 10:07:32 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 7/9] media: cedrus: Move IRQ maintainance to cedrus_dec_ops
Date: Wed, 13 Jun 2018 16:07:12 +0200
Message-Id: <20180613140714.1686-8-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IRQ handler up until now was hardcoding the use of the MPEG engine to
read the interrupt status, clear it and disable the interrupts.

Obviously, that won't work really well with the introduction of new codecs
that use a separate engine with a separate register set.

In order to make this more future proof, introduce new decodec operations
to deal with the interrupt management. The only one missing is the one to
enable the interrupts in the first place, but that's taken care of by the
trigger hook for now.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../sunxi/cedrus/sunxi_cedrus_common.h        |  9 +++++
 .../platform/sunxi/cedrus/sunxi_cedrus_hw.c   | 21 ++++++------
 .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 33 +++++++++++++++++++
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
index c2e2c92d103b..a2a507eb9fc9 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
@@ -108,7 +108,16 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer(const struct vb2_buffer *p)
 	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
 }
 
+enum sunxi_cedrus_irq_status {
+	SUNXI_CEDRUS_IRQ_NONE,
+	SUNXI_CEDRUS_IRQ_ERROR,
+	SUNXI_CEDRUS_IRQ_OK,
+};
+
 struct sunxi_cedrus_dec_ops {
+	void (*irq_clear)(struct sunxi_cedrus_ctx *ctx);
+	void (*irq_disable)(struct sunxi_cedrus_ctx *ctx);
+	enum sunxi_cedrus_irq_status (*irq_status)(struct sunxi_cedrus_ctx *ctx);
 	void (*setup)(struct sunxi_cedrus_ctx *ctx,
 		      struct sunxi_cedrus_run *run);
 	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
index bb46a01214e0..6b97cbd2834e 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
@@ -77,27 +77,28 @@ static irqreturn_t sunxi_cedrus_ve_irq(int irq, void *dev_id)
 	struct sunxi_cedrus_ctx *ctx;
 	struct sunxi_cedrus_buffer *src_buffer, *dst_buffer;
 	struct vb2_v4l2_buffer *src_vb, *dst_vb;
+	enum sunxi_cedrus_irq_status status;
 	unsigned long flags;
-	unsigned int value, status;
 
 	spin_lock_irqsave(&dev->irq_lock, flags);
 
-	/* Disable MPEG interrupts and stop the MPEG engine */
-	value = sunxi_cedrus_read(dev, VE_MPEG_CTRL);
-	sunxi_cedrus_write(dev, value & (~0xf), VE_MPEG_CTRL);
-
-	status = sunxi_cedrus_read(dev, VE_MPEG_STATUS);
-	sunxi_cedrus_write(dev, 0x0000c00f, VE_MPEG_STATUS);
-	sunxi_cedrus_engine_disable(dev);
-
 	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
 	if (!ctx) {
 		pr_err("Instance released before the end of transaction\n");
 		spin_unlock_irqrestore(&dev->irq_lock, flags);
 
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 	}
 
+	status = dev->dec_ops[ctx->current_codec]->irq_status(ctx);
+	if (status == SUNXI_CEDRUS_IRQ_NONE) {
+		spin_unlock_irqrestore(&dev->irq_lock, flags);
+		return IRQ_NONE;
+	}
+
+	dev->dec_ops[ctx->current_codec]->irq_disable(ctx);
+	dev->dec_ops[ctx->current_codec]->irq_clear(ctx);
+
 	src_vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
index e25075bb5779..51fa0c0f9bf2 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
@@ -52,6 +52,36 @@ static const u8 mpeg_default_non_intra_quant[64] = {
 
 #define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
 
+static enum sunxi_cedrus_irq_status
+sunxi_cedrus_mpeg2_irq_status(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	u32 reg = sunxi_cedrus_read(dev, VE_MPEG_STATUS) & 0x7;
+
+	if (!reg)
+		return SUNXI_CEDRUS_IRQ_NONE;
+
+	if (reg & (BIT(1) | BIT(2)))
+		return SUNXI_CEDRUS_IRQ_ERROR;
+
+	return SUNXI_CEDRUS_IRQ_OK;
+}
+
+static void sunxi_cedrus_mpeg2_irq_clear(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+
+	sunxi_cedrus_write(dev, GENMASK(2, 0), VE_MPEG_STATUS);
+}
+
+static void sunxi_cedrus_mpeg2_irq_disable(struct sunxi_cedrus_ctx *ctx)
+{
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	u32 reg = sunxi_cedrus_read(dev, VE_MPEG_CTRL) & ~BIT(3);
+
+	sunxi_cedrus_write(dev, reg, VE_MPEG_CTRL);
+}
+
 static void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
 				     struct sunxi_cedrus_run *run)
 {
@@ -156,6 +186,9 @@ static void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx)
 }
 
 struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_mpeg2 = {
+	.irq_clear	= sunxi_cedrus_mpeg2_irq_clear,
+	.irq_disable	= sunxi_cedrus_mpeg2_irq_disable,
+	.irq_status	= sunxi_cedrus_mpeg2_irq_status,
 	.setup		= sunxi_cedrus_mpeg2_setup,
 	.trigger	= sunxi_cedrus_mpeg2_trigger,
 };
-- 
2.17.0
