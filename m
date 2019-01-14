Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DAFC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CA9C206B7
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfANNjP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:39:15 -0500
Received: from mail.bootlin.com ([62.4.15.54]:51475 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbfANNjE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:39:04 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id A9B9D20A0F; Mon, 14 Jan 2019 14:39:01 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id 3D02E20728;
        Mon, 14 Jan 2019 14:39:01 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Cc:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC 3/4] media: cedrus: Request access to reference buffers when decoding
Date:   Mon, 14 Jan 2019 14:38:38 +0100
Message-Id: <20190114133839.29967-4-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
References: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Because we need to request and release access to reference buffers
that are backed by a dma-buf import, keep track of the buffers used
as reference and add the appropriate calls in the device_run and
job_done m2m callbacks. The latter is introduced for this purpose.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c    |  1 +
 drivers/staging/media/sunxi/cedrus/cedrus.h    |  1 +
 .../staging/media/sunxi/cedrus/cedrus_dec.c    | 18 ++++++++++++++++++
 .../staging/media/sunxi/cedrus/cedrus_dec.h    |  1 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c  |  8 ++++++++
 5 files changed, 29 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index ff11cbeba205..a2c75eb01c2c 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -250,6 +250,7 @@ static const struct video_device cedrus_video_device = {
 
 static const struct v4l2_m2m_ops cedrus_m2m_ops = {
 	.device_run	= cedrus_device_run,
+	.job_done	= cedrus_job_done,
 };
 
 static const struct media_device_ops cedrus_m2m_media_ops = {
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
index 4aedd24a9848..c1ce3c4ae2a1 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -77,6 +77,7 @@ struct cedrus_ctx {
 	struct v4l2_ctrl		**ctrls;
 
 	struct vb2_buffer		*dst_bufs[VIDEO_MAX_FRAME];
+	bool				reference_bufs[VIDEO_MAX_FRAME];
 };
 
 struct cedrus_dec_ops {
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index 2c295286766c..90bf51e71f4f 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -41,6 +41,7 @@ void cedrus_device_run(void *priv)
 	struct cedrus_dev *dev = ctx->dev;
 	struct cedrus_run run = {};
 	struct media_request *src_req;
+	unsigned int i;
 
 	run.src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	run.dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -63,10 +64,17 @@ void cedrus_device_run(void *priv)
 		break;
 	}
 
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		ctx->reference_bufs[i] = false;
+
 	v4l2_m2m_buf_copy_data(run.src, run.dst, true);
 
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		if (ctx->reference_bufs[i] && ctx->dst_bufs[i])
+			vb2_buffer_access_request(ctx->dst_bufs[i]);
+
 	/* Complete request(s) controls if needed. */
 
 	if (src_req)
@@ -74,3 +82,13 @@ void cedrus_device_run(void *priv)
 
 	dev->dec_ops[ctx->current_codec]->trigger(ctx);
 }
+
+void cedrus_job_done(void *priv)
+{
+	struct cedrus_ctx *ctx = priv;
+	unsigned int i;
+
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		if (ctx->reference_bufs[i] && ctx->dst_bufs[i])
+			vb2_buffer_access_release(ctx->dst_bufs[i]);
+}
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
index 8d0fc248220f..9265f28e6dbe 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
@@ -19,5 +19,6 @@
 int cedrus_reference_index_find(struct vb2_queue *queue,
 				struct vb2_buffer *vb2_buf, u64 timestamp);
 void cedrus_device_run(void *priv);
+void cedrus_job_done(void *priv);
 
 #endif
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index 81c66a8aa1ac..2e7deded17aa 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
@@ -162,6 +162,10 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	/* Forward and backward prediction reference buffers. */
 	forward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
 						  slice_params->forward_ref_ts);
+	if (forward_idx < 0)
+		return;
+
+	ctx->reference_bufs[forward_idx] = true;
 
 	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
 	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
@@ -171,6 +175,10 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 
 	backward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
 						   slice_params->backward_ref_ts);
+	if (forward_idx < 0)
+		return;
+
+	ctx->reference_bufs[backward_idx] = true;
 
 	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
 	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
-- 
2.20.1

