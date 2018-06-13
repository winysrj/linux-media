Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52378 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935790AbeFMOHU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 10:07:20 -0400
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
Subject: [PATCH 6/9] media: cedrus: Add ops structure
Date: Wed, 13 Jun 2018 16:07:11 +0200
Message-Id: <20180613140714.1686-7-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to increase the number of codecs supported, we need to decouple
the MPEG2 only code that was there up until now and turn it into something
a bit more generic.

Do that by introducing an intermediate ops structure that would need to be
filled by each supported codec. Start by implementing in that structure the
setup and trigger hooks that are currently the only functions being
implemented by codecs support.

To do so, we need to store the current codec in use, which we do at
start_streaming time.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../platform/sunxi/cedrus/sunxi_cedrus.c      |  2 ++
 .../sunxi/cedrus/sunxi_cedrus_common.h        | 11 +++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_dec.c  | 10 +++---
 .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         | 11 +++++--
 .../sunxi/cedrus/sunxi_cedrus_mpeg2.h         | 33 -------------------
 .../sunxi/cedrus/sunxi_cedrus_video.c         | 17 +++++++++-
 6 files changed, 42 insertions(+), 42 deletions(-)
 delete mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h

diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
index ccd41d9a3e41..bc80480f5dfd 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus.c
@@ -244,6 +244,8 @@ static int sunxi_cedrus_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	dev->dec_ops[SUNXI_CEDRUS_CODEC_MPEG2] = &sunxi_cedrus_dec_ops_mpeg2;
+
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		goto unreg_media;
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
index a5f83c452006..c2e2c92d103b 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
@@ -75,6 +75,7 @@ struct sunxi_cedrus_ctx {
 	struct v4l2_pix_format_mplane src_fmt;
 	struct sunxi_cedrus_fmt *vpu_dst_fmt;
 	struct v4l2_pix_format_mplane dst_fmt;
+	enum sunxi_cedrus_codec current_codec;
 
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_ctrl *ctrls[SUNXI_CEDRUS_CTRL_MAX];
@@ -107,6 +108,14 @@ struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer(const struct vb2_buffer *p)
 	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
 }
 
+struct sunxi_cedrus_dec_ops {
+	void (*setup)(struct sunxi_cedrus_ctx *ctx,
+		      struct sunxi_cedrus_run *run);
+	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
+};
+
+extern struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_mpeg2;
+
 struct sunxi_cedrus_dev {
 	struct v4l2_device v4l2_dev;
 	struct video_device vfd;
@@ -130,6 +139,8 @@ struct sunxi_cedrus_dev {
 	struct reset_control *rstc;
 
 	struct regmap *syscon;
+
+	struct sunxi_cedrus_dec_ops	*dec_ops[SUNXI_CEDRUS_CODEC_LAST];
 };
 
 static inline void sunxi_cedrus_write(struct sunxi_cedrus_dev *dev,
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
index f274408ab5a7..5e552fa05274 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_dec.c
@@ -28,7 +28,6 @@
 #include <media/v4l2-mem2mem.h>
 
 #include "sunxi_cedrus_common.h"
-#include "sunxi_cedrus_mpeg2.h"
 #include "sunxi_cedrus_dec.h"
 #include "sunxi_cedrus_hw.h"
 
@@ -77,6 +76,7 @@ void sunxi_cedrus_device_work(struct work_struct *work)
 void sunxi_cedrus_device_run(void *priv)
 {
 	struct sunxi_cedrus_ctx *ctx = priv;
+	struct sunxi_cedrus_dev *dev = ctx->dev;
 	struct sunxi_cedrus_run run = { 0 };
 	struct media_request *src_req, *dst_req;
 	unsigned long flags;
@@ -120,8 +120,6 @@ void sunxi_cedrus_device_run(void *priv)
 	case V4L2_PIX_FMT_MPEG2_FRAME:
 		CHECK_CONTROL(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR);
 		run.mpeg2.hdr = get_ctrl_ptr(ctx, SUNXI_CEDRUS_CTRL_DEC_MPEG2_FRAME_HDR);
-		sunxi_cedrus_mpeg2_setup(ctx, &run);
-
 		break;
 
 	default:
@@ -129,6 +127,9 @@ void sunxi_cedrus_device_run(void *priv)
 	}
 #undef CHECK_CONTROL
 
+	if (!ctx->job_abort)
+		dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
+
 unlock_complete:
 	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
 
@@ -143,8 +144,7 @@ void sunxi_cedrus_device_run(void *priv)
 	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
 
 	if (!ctx->job_abort) {
-		if (ctx->vpu_src_fmt->fourcc == V4L2_PIX_FMT_MPEG2_FRAME)
-			sunxi_cedrus_mpeg2_trigger(ctx);
+		dev->dec_ops[ctx->current_codec]->trigger(ctx);
 	} else {
 		v4l2_m2m_buf_done(run.src, VB2_BUF_STATE_ERROR);
 		v4l2_m2m_buf_done(run.dst, VB2_BUF_STATE_ERROR);
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
index d1d7a3cfce0d..e25075bb5779 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
@@ -52,8 +52,8 @@ static const u8 mpeg_default_non_intra_quant[64] = {
 
 #define m_niq(i) ((i << 8) | mpeg_default_non_intra_quant[i])
 
-void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
-			      struct sunxi_cedrus_run *run)
+static void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
+				     struct sunxi_cedrus_run *run)
 {
 	struct sunxi_cedrus_dev *dev = ctx->dev;
 	const struct v4l2_ctrl_mpeg2_frame_hdr *frame_hdr = run->mpeg2.hdr;
@@ -148,9 +148,14 @@ void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
 	sunxi_cedrus_write(dev, src_buf_addr + VBV_SIZE - 1, VE_MPEG_VLD_END);
 }
 
-void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx)
+static void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx)
 {
 	struct sunxi_cedrus_dev *dev = ctx->dev;
 
 	sunxi_cedrus_write(dev, VE_TRIG_MPEG2, VE_MPEG_TRIGGER);
 }
+
+struct sunxi_cedrus_dec_ops sunxi_cedrus_dec_ops_mpeg2 = {
+	.setup		= sunxi_cedrus_mpeg2_setup,
+	.trigger	= sunxi_cedrus_mpeg2_trigger,
+};
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h
deleted file mode 100644
index 4c380becfa1a..000000000000
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Sunxi-Cedrus VPU driver
- *
- * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com>
- * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.com>
- *
- * Based on the vim2m driver, that is:
- *
- * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
- * Pawel Osciak, <pawel@osciak.com>
- * Marek Szyprowski, <m.szyprowski@samsung.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef _SUNXI_CEDRUS_MPEG2_H_
-#define _SUNXI_CEDRUS_MPEG2_H_
-
-struct sunxi_cedrus_ctx;
-struct sunxi_cedrus_run;
-
-void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *ctx,
-			      struct sunxi_cedrus_run *run);
-void sunxi_cedrus_mpeg2_trigger(struct sunxi_cedrus_ctx *ctx);
-
-#endif
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
index 089abfe6bfeb..fb7b081a5bb7 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
@@ -28,7 +28,6 @@
 #include <media/v4l2-mem2mem.h>
 
 #include "sunxi_cedrus_common.h"
-#include "sunxi_cedrus_mpeg2.h"
 #include "sunxi_cedrus_dec.h"
 #include "sunxi_cedrus_hw.h"
 
@@ -414,6 +413,21 @@ static int sunxi_cedrus_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static int sunxi_cedrus_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct sunxi_cedrus_ctx *ctx = vb2_get_drv_priv(q);
+
+	switch (ctx->vpu_src_fmt->fourcc) {
+	case V4L2_PIX_FMT_MPEG2_FRAME:
+		ctx->current_codec = SUNXI_CEDRUS_CODEC_MPEG2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void sunxi_cedrus_stop_streaming(struct vb2_queue *q)
 {
 	struct sunxi_cedrus_ctx *ctx = vb2_get_drv_priv(q);
@@ -462,6 +476,7 @@ static struct vb2_ops sunxi_cedrus_qops = {
 	.buf_cleanup		= sunxi_cedrus_buf_cleanup,
 	.buf_queue		= sunxi_cedrus_buf_queue,
 	.buf_request_complete	= sunxi_cedrus_buf_request_complete,
+	.start_streaming	= sunxi_cedrus_start_streaming,
 	.stop_streaming		= sunxi_cedrus_stop_streaming,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
-- 
2.17.0
