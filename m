Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFAAC282CC
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9039420818
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfBEUYx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:24:53 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41750 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfBEUYx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 15:24:53 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 8E6E32802E3
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 02/10] rockchip/vpu: Use pixel format helpers
Date:   Tue,  5 Feb 2019 17:24:09 -0300
Message-Id: <20190205202417.16555-3-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190205202417.16555-1-ezequiel@collabora.com>
References: <20190205202417.16555-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that we've introduced the pixel format helpers, use them
in vpu driver, and get rid of the internal helpers.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 91 +------------------
 1 file changed, 2 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
index ab0fb2053620..4451bb2dc3d7 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
@@ -30,93 +30,6 @@
 #include "rockchip_vpu_hw.h"
 #include "rockchip_vpu_common.h"
 
-/**
- * struct v4l2_format_info - information about a V4L2 format
- * @format: 4CC format identifier (V4L2_PIX_FMT_*)
- * @header_size: Size of header, optional and used by compressed formats
- * @num_planes: Number of planes (1 to 3)
- * @cpp: Number of bytes per pixel (per plane)
- * @hsub: Horizontal chroma subsampling factor
- * @vsub: Vertical chroma subsampling factor
- * @is_compressed: Is it a compressed format?
- * @multiplanar: Is it a multiplanar variant format? (e.g. NV12M)
- */
-struct v4l2_format_info {
-	u32 format;
-	u32 header_size;
-	u8 num_planes;
-	u8 cpp[3];
-	u8 hsub;
-	u8 vsub;
-	u8 is_compressed;
-	u8 multiplanar;
-};
-
-static const struct v4l2_format_info *
-v4l2_format_info(u32 format)
-{
-	static const struct v4l2_format_info formats[] = {
-		{ .format = V4L2_PIX_FMT_YUV420M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
-		{ .format = V4L2_PIX_FMT_NV12M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
-		{ .format = V4L2_PIX_FMT_YUYV,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
-		{ .format = V4L2_PIX_FMT_UYVY,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
-	};
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
-		if (formats[i].format == format)
-			return &formats[i];
-	}
-
-	vpu_err("Unsupported V4L 4CC format (%08x)\n", format);
-	return NULL;
-}
-
-static void
-fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt,
-	       int pixelformat, int width, int height)
-{
-	const struct v4l2_format_info *info;
-	struct v4l2_plane_pix_format *plane;
-	int i;
-
-	info = v4l2_format_info(pixelformat);
-	if (!info)
-		return;
-
-	pixfmt->width = width;
-	pixfmt->height = height;
-	pixfmt->pixelformat = pixelformat;
-
-	if (!info->multiplanar) {
-		pixfmt->num_planes = 1;
-		plane = &pixfmt->plane_fmt[0];
-		plane->bytesperline = info->is_compressed ?
-					0 : width * info->cpp[0];
-		plane->sizeimage = info->header_size;
-		for (i = 0; i < info->num_planes; i++) {
-			unsigned int hsub = (i == 0) ? 1 : info->hsub;
-			unsigned int vsub = (i == 0) ? 1 : info->vsub;
-
-			plane->sizeimage += info->cpp[i] *
-				DIV_ROUND_UP(width, hsub) *
-				DIV_ROUND_UP(height, vsub);
-		}
-	} else {
-		pixfmt->num_planes = info->num_planes;
-		for (i = 0; i < info->num_planes; i++) {
-			unsigned int hsub = (i == 0) ? 1 : info->hsub;
-			unsigned int vsub = (i == 0) ? 1 : info->vsub;
-
-			plane = &pixfmt->plane_fmt[i];
-			plane->bytesperline =
-				info->cpp[i] * DIV_ROUND_UP(width, hsub);
-			plane->sizeimage =
-				plane->bytesperline * DIV_ROUND_UP(height, vsub);
-		}
-	}
-}
-
 static const struct rockchip_vpu_fmt *
 rockchip_vpu_find_format(struct rockchip_vpu_ctx *ctx, u32 fourcc)
 {
@@ -339,7 +252,7 @@ vidioc_try_fmt_out_mplane(struct file *file, void *priv, struct v4l2_format *f)
 	height = round_up(height, JPEG_MB_DIM);
 
 	/* Fill remaining fields */
-	fill_pixfmt_mp(pix_mp, fmt->fourcc, width, height);
+	v4l2_fill_pixfmt_mp(pix_mp, fmt->fourcc, width, height);
 
 	for (i = 0; i < pix_mp->num_planes; i++) {
 		memset(pix_mp->plane_fmt[i].reserved, 0,
@@ -393,7 +306,7 @@ void rockchip_vpu_enc_reset_src_fmt(struct rockchip_vpu_dev *vpu,
 	fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
 	fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
 
-	fill_pixfmt_mp(fmt, ctx->vpu_src_fmt->fourcc, width, height);
+	v4l2_fill_pixfmt_mp(fmt, ctx->vpu_src_fmt->fourcc, width, height);
 }
 
 static int
-- 
2.20.1

