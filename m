Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E563C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 21:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29AA320842
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 21:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfBYVEc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 16:04:32 -0500
Received: from rio.cs.utah.edu ([155.98.64.241]:38687 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfBYVEc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 16:04:32 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id B1C236500BD;
        Mon, 25 Feb 2019 14:04:28 -0700 (MST)
Received: from mail-svr1.cs.utah.edu ([127.0.0.1])
        by localhost (mail-svr1.cs.utah.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id o5yZK0jTgwzL; Mon, 25 Feb 2019 14:04:26 -0700 (MST)
Received: from bench1.smackbench.smack.emulab.net (pc614.emulab.net [155.98.38.234])
        by smtps.cs.utah.edu (Postfix) with ESMTPSA id DAF966500B5;
        Mon, 25 Feb 2019 14:04:25 -0700 (MST)
From:   Shaobo He <shaobo@cs.utah.edu>
To:     linux-media@vger.kernel.org
Cc:     laurent.pinchart@ideasonboard.com, shaobo@cs.utah.edu,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Anton Leontiev <scileont@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-renesas-soc@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS
        - FDP1),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC support)
Subject: [PATCH] Remove deductively redundant NULL pointer checks
Date:   Mon, 25 Feb 2019 14:03:37 -0700
Message-Id: <1551128631-19713-1-git-send-email-shaobo@cs.utah.edu>
X-Mailer: git-send-email 1.9.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The fixes included in this commit essentially removes NULL pointer
checks on the return values of function `get_queue_ctx` as well as
`v4l2_m2m_get_vq` defined in file v4l2-mem2mem.c.

Function `get_queue_ctx` is very unlikely to return a NULL pointer
because its return value is an address composed of the base address
pointed by `m2m_ctx` and an offset of field `out_q_ctx` or `cap_q_ctx`.
Since the offset of either field is not 0, for the return value to be
NULL, pointer `m2m_ctx` must be a very large unsigned value such that
its addition to the offset overflows to NULL which may be undefined
according to this post:
https://wdtz.org/catching-pointer-overflow-bugs.html. Moreover, even if
`m2m_ctx` is NULL, the return value cannot be NULL, either. Therefore, I
think it is reasonable to conclude that the return value of function
`get_queue_ctx` cannot be NULL.

Given the return values of `get_queue_ctx` not being NULL, we can follow
a similar reasoning to conclude that the return value of
`v4l2_mem_get_vq` cannot be NULL since its return value is the same
address as the return value of `get_queue_ctx`. Therefore, this patch
also removes NULL pointer checks on the return values of
`v4l2_mem_get_vq`.

Signed-off-by: Shaobo He <shaobo@cs.utah.edu>
---
 drivers/media/platform/coda/coda-common.c          |  4 ----
 drivers/media/platform/imx-pxp.c                   |  7 -------
 drivers/media/platform/m2m-deinterlace.c           |  7 -------
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |  7 -------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  7 -------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 13 -------------
 drivers/media/platform/mx2_emmaprp.c               |  7 -------
 drivers/media/platform/rcar_fdp1.c                 |  3 ---
 drivers/media/platform/rcar_jpu.c                  |  8 --------
 drivers/media/platform/rockchip/rga/rga.c          |  4 ----
 drivers/media/platform/s5p-g2d/g2d.c               |  4 ----
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  7 -------
 drivers/media/platform/sh_veu.c                    |  2 --
 drivers/media/platform/ti-vpe/vpe.c                |  7 -------
 drivers/media/platform/vicodec/vicodec-core.c      |  5 -----
 drivers/media/platform/vim2m.c                     |  9 ---------
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  4 ----
 17 files changed, 105 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 7518f01..ee1e05b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -696,8 +696,6 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	q_data = get_q_data(ctx, f->type);
 	if (!q_data)
@@ -817,8 +815,6 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 	ctx->quantization = f->fmt.pix.quantization;
 
 	dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	if (!dst_vq)
-		return -EINVAL;
 
 	/*
 	 * Setting the capture queue format is not possible while the capture
diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index c1c2554..d079b3c 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -1071,13 +1071,8 @@ static int pxp_enum_fmt_vid_out(struct file *file, void *priv,
 
 static int pxp_g_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct pxp_q_data *q_data;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
 
 	f->fmt.pix.width	= q_data->width;
@@ -1220,8 +1215,6 @@ static int pxp_s_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
 	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	q_data = get_q_data(ctx, f->type);
 	if (!q_data)
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index c62e598..df03ffd 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -497,13 +497,8 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 
 static int vidioc_g_fmt(struct deinterlace_ctx *ctx, struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct deinterlace_q_data *q_data;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(f->type);
 
 	f->fmt.pix.width	= q_data->width;
@@ -598,8 +593,6 @@ static int vidioc_s_fmt(struct deinterlace_ctx *ctx, struct v4l2_format *f)
 	struct vb2_queue *vq;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	q_data = get_q_data(f->type);
 	if (!q_data)
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 2a5d500..2da90ae 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -271,17 +271,12 @@ static int mtk_jpeg_try_fmt_mplane(struct v4l2_format *f,
 static int mtk_jpeg_g_fmt_vid_mplane(struct file *file, void *priv,
 				     struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct mtk_jpeg_q_data *q_data = NULL;
 	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	struct mtk_jpeg_ctx *ctx = mtk_jpeg_fh_to_ctx(priv);
 	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
 	int i;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = mtk_jpeg_get_q_data(ctx, f->type);
 
 	memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
@@ -372,8 +367,6 @@ static int mtk_jpeg_s_fmt_mplane(struct mtk_jpeg_ctx *ctx,
 	int i;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	q_data = mtk_jpeg_get_q_data(ctx, f->type);
 
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index ba61964..d4006e5 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -955,15 +955,8 @@ static int vidioc_vdec_g_fmt(struct file *file, void *priv,
 {
 	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
 	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
-	struct vb2_queue *vq;
 	struct mtk_q_data *q_data;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq) {
-		mtk_v4l2_err("no vb2 queue for type=%d", f->type);
-		return -EINVAL;
-	}
-
 	q_data = mtk_vdec_get_q_data(ctx, f->type);
 
 	pix_mp->field = V4L2_FIELD_NONE;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index d1f1225..7c54690 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -430,10 +430,6 @@ static int vidioc_venc_s_fmt_cap(struct file *file, void *priv,
 	struct mtk_video_fmt *fmt;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq) {
-		mtk_v4l2_err("fail to get vq");
-		return -EINVAL;
-	}
 
 	if (vb2_is_busy(vq)) {
 		mtk_v4l2_err("queue busy");
@@ -493,10 +489,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq) {
-		mtk_v4l2_err("fail to get vq");
-		return -EINVAL;
-	}
 
 	if (vb2_is_busy(vq)) {
 		mtk_v4l2_err("queue busy");
@@ -554,14 +546,9 @@ static int vidioc_venc_g_fmt(struct file *file, void *priv,
 {
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
-	struct vb2_queue *vq;
 	struct mtk_q_data *q_data;
 	int i;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = mtk_venc_get_q_data(ctx, f->type);
 
 	pix->width = q_data->coded_width;
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 27b078c..1366fde 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -436,13 +436,8 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 
 static int vidioc_g_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct emmaprp_q_data *q_data;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
 
 	f->fmt.pix.width	= q_data->width;
@@ -545,8 +540,6 @@ static int vidioc_s_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
 	int ret;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	q_data = get_q_data(ctx, f->type);
 	if (!q_data)
diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 6bda1ee..ef747d3 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -1407,9 +1407,6 @@ static int fdp1_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct fdp1_q_data *q_data;
 	struct fdp1_ctx *ctx = fh_to_ctx(priv);
 
-	if (!v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type))
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
 	f->fmt.pix_mp = q_data->format;
 
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 1dfd2eb..a91664c 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -839,9 +839,6 @@ static int jpu_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct jpu_ctx *ctx = fh_to_ctx(priv);
 
-	if (!v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type))
-		return -EINVAL;
-
 	return __jpu_try_fmt(ctx, NULL, &f->fmt.pix_mp, f->type);
 }
 
@@ -855,8 +852,6 @@ static int jpu_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	if (vb2_is_busy(vq)) {
 		v4l2_err(&ctx->jpu->v4l2_dev, "%s queue busy\n", __func__);
@@ -880,9 +875,6 @@ static int jpu_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct jpu_q_data *q_data;
 	struct jpu_ctx *ctx = fh_to_ctx(priv);
 
-	if (!v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type))
-		return -EINVAL;
-
 	q_data = jpu_get_q_data(ctx, f->type);
 	f->fmt.pix_mp = q_data->format;
 
diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 5c65328..74b8e9d 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -470,12 +470,8 @@ static int vidioc_enum_fmt(struct file *file, void *prv, struct v4l2_fmtdesc *f)
 static int vidioc_g_fmt(struct file *file, void *prv, struct v4l2_format *f)
 {
 	struct rga_ctx *ctx = prv;
-	struct vb2_queue *vq;
 	struct rga_frame *frm;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 	frm = rga_get_frame(ctx, f->type);
 	if (IS_ERR(frm))
 		return PTR_ERR(frm);
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 57ab1d1..dda4159 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -319,12 +319,8 @@ static int vidioc_enum_fmt(struct file *file, void *prv, struct v4l2_fmtdesc *f)
 static int vidioc_g_fmt(struct file *file, void *prv, struct v4l2_format *f)
 {
 	struct g2d_ctx *ctx = prv;
-	struct vb2_queue *vq;
 	struct g2d_frame *frm;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 	frm = get_frame(ctx, f->type);
 	if (IS_ERR(frm))
 		return PTR_ERR(frm);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 3f9000b..4884725 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1359,15 +1359,10 @@ static struct s5p_jpeg_q_data *get_q_data(struct s5p_jpeg_ctx *ctx,
 
 static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct s5p_jpeg_q_data *q_data = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct s5p_jpeg_ctx *ct = fh_to_ctx(priv);
 
-	vq = v4l2_m2m_get_vq(ct->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    ct->mode == S5P_JPEG_DECODE && !ct->hdr_parsed)
 		return -EINVAL;
@@ -1620,8 +1615,6 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 	unsigned int f_type;
 
 	vq = v4l2_m2m_get_vq(ct->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	q_data = get_q_data(ct, f->type);
 	BUG_ON(q_data == NULL);
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 09ae64a..6d59e16 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -554,8 +554,6 @@ static int sh_veu_s_fmt(struct sh_veu_file *veu_file, struct v4l2_format *f)
 		return ret;
 
 	vq = v4l2_m2m_get_vq(veu->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	if (vb2_is_busy(vq)) {
 		v4l2_err(&veu_file->veu_dev->v4l2_dev, "%s queue busy\n", __func__);
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d70871d0..1620168 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1537,14 +1537,9 @@ static int vpe_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct vpe_ctx *ctx = file2ctx(file);
-	struct vb2_queue *vq;
 	struct vpe_q_data *q_data;
 	int i;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
 
 	pix->width = q_data->width;
@@ -1714,8 +1709,6 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
 	int i;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
 
 	if (vb2_is_busy(vq)) {
 		vpe_err(ctx->dev, "queue busy\n");
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 0d7876f..9a2ab8b 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -445,16 +445,11 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 
 static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct vicodec_q_data *q_data;
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
 	const struct v4l2_fwht_pixfmt_info *info;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
 	info = q_data->info;
 
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 89d9c4c..dae8af5 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -484,13 +484,8 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 
 static int vidioc_g_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 {
-	struct vb2_queue *vq;
 	struct vim2m_q_data *q_data;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
 
 	f->fmt.pix.width	= q_data->width;
@@ -594,10 +589,6 @@ static int vidioc_s_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 	struct vim2m_q_data *q_data;
 	struct vb2_queue *vq;
 
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
 	q_data = get_q_data(ctx, f->type);
 	if (!q_data)
 		return -EINVAL;
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 5bbdec5..1bbf4b0 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -124,8 +124,6 @@ struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
 	struct v4l2_m2m_queue_ctx *q_ctx;
 
 	q_ctx = get_queue_ctx(m2m_ctx, type);
-	if (!q_ctx)
-		return NULL;
 
 	return &q_ctx->q;
 }
@@ -965,8 +963,6 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 	unsigned long flags;
 
 	q_ctx = get_queue_ctx(m2m_ctx, vbuf->vb2_buf.vb2_queue->type);
-	if (!q_ctx)
-		return;
 
 	spin_lock_irqsave(&q_ctx->rdy_spinlock, flags);
 	list_add_tail(&b->list, &q_ctx->rdy_queue);
-- 
1.9.1

