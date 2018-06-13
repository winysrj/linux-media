Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52480 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935750AbeFMOHc (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 8/9] media: cedrus: Add start and stop decoder operations
Date: Wed, 13 Jun 2018 16:07:13 +0200
Message-Id: <20180613140714.1686-9-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some codec needs to perform some additional task when a decoding is started
and stopped, and not only at every frame.

For example, the H264 decoding support needs to allocate buffers that will
be used in the decoding process, but do not need to change over time, or at
each frame.

In order to allow that for codecs, introduce a start and stop hook that
will be called if present at start_streaming and stop_streaming time.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../platform/sunxi/cedrus/sunxi_cedrus_common.h    |  2 ++
 .../platform/sunxi/cedrus/sunxi_cedrus_video.c     | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
index a2a507eb9fc9..20c78ec1f037 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
@@ -120,6 +120,8 @@ struct sunxi_cedrus_dec_ops {
 	enum sunxi_cedrus_irq_status (*irq_status)(struct sunxi_cedrus_ctx *ctx);
 	void (*setup)(struct sunxi_cedrus_ctx *ctx,
 		      struct sunxi_cedrus_run *run);
+	int (*start)(struct sunxi_cedrus_ctx *ctx);
+	void (*stop)(struct sunxi_cedrus_ctx *ctx);
 	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
 };
 
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
index fb7b081a5bb7..d93461178857 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
@@ -416,6 +416,8 @@ static int sunxi_cedrus_buf_prepare(struct vb2_buffer *vb)
 static int sunxi_cedrus_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct sunxi_cedrus_ctx *ctx = vb2_get_drv_priv(q);
+	struct sunxi_cedrus_dev *dev = ctx->dev;
+	int ret = 0;
 
 	switch (ctx->vpu_src_fmt->fourcc) {
 	case V4L2_PIX_FMT_MPEG2_FRAME:
@@ -425,16 +427,26 @@ static int sunxi_cedrus_start_streaming(struct vb2_queue *q, unsigned int count)
 		return -EINVAL;
 	}
 
-	return 0;
+	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
+	    dev->dec_ops[ctx->current_codec]->start)
+		ret = dev->dec_ops[ctx->current_codec]->start(ctx);
+
+	return ret;
 }
 
 static void sunxi_cedrus_stop_streaming(struct vb2_queue *q)
 {
 	struct sunxi_cedrus_ctx *ctx = vb2_get_drv_priv(q);
+	struct sunxi_cedrus_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
 	flush_scheduled_work();
+
+	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
+	    dev->dec_ops[ctx->current_codec]->stop)
+		dev->dec_ops[ctx->current_codec]->stop(ctx);
+
 	for (;;) {
 		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
 
-- 
2.17.0
