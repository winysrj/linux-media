Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BD9C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 19:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25392070B
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 19:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfCDT0x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 14:26:53 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50328 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDT0x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 14:26:53 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 3DF87277A3B
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 05/11] rockchip/vpu: Cleanup macroblock alignment
Date:   Mon,  4 Mar 2019 16:25:23 -0300
Message-Id: <20190304192529.14200-6-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190304192529.14200-1-ezequiel@collabora.com>
References: <20190304192529.14200-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

We need to make the macrobock alignment generic, in order
to support multiple codecs.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
index 4451bb2dc3d7..ae1ff3d9b9d2 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
@@ -203,8 +203,8 @@ vidioc_try_fmt_cap_mplane(struct file *file, void *priv, struct v4l2_format *f)
 			       fmt->frmsize.min_height,
 			       fmt->frmsize.max_height);
 	/* Round up to macroblocks. */
-	pix_mp->width = round_up(pix_mp->width, JPEG_MB_DIM);
-	pix_mp->height = round_up(pix_mp->height, JPEG_MB_DIM);
+	pix_mp->width = round_up(pix_mp->width, fmt->frmsize.step_width);
+	pix_mp->height = round_up(pix_mp->height, fmt->frmsize.step_height);
 
 	/*
 	 * For compressed formats the application can specify
@@ -248,8 +248,8 @@ vidioc_try_fmt_out_mplane(struct file *file, void *priv, struct v4l2_format *f)
 		       ctx->vpu_dst_fmt->frmsize.min_height,
 		       ctx->vpu_dst_fmt->frmsize.max_height);
 	/* Round up to macroblocks. */
-	width = round_up(width, JPEG_MB_DIM);
-	height = round_up(height, JPEG_MB_DIM);
+	width = round_up(width, ctx->vpu_dst_fmt->frmsize.step_width);
+	height = round_up(height, ctx->vpu_dst_fmt->frmsize.step_height);
 
 	/* Fill remaining fields */
 	v4l2_fill_pixfmt_mp(pix_mp, fmt->fourcc, width, height);
@@ -338,10 +338,8 @@ vidioc_s_fmt_out_mplane(struct file *file, void *priv, struct v4l2_format *f)
 	ctx->dst_fmt.height = pix_mp->height;
 
 	vpu_debug(0, "OUTPUT codec mode: %d\n", ctx->vpu_src_fmt->codec_mode);
-	vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
-		  pix_mp->width, pix_mp->height,
-		  JPEG_MB_WIDTH(pix_mp->width),
-		  JPEG_MB_HEIGHT(pix_mp->height));
+	vpu_debug(0, "fmt - w: %d, h: %d\n",
+		  pix_mp->width, pix_mp->height);
 	return 0;
 }
 
@@ -380,10 +378,8 @@ vidioc_s_fmt_cap_mplane(struct file *file, void *priv, struct v4l2_format *f)
 	ctx->dst_fmt = *pix_mp;
 
 	vpu_debug(0, "CAPTURE codec mode: %d\n", ctx->vpu_dst_fmt->codec_mode);
-	vpu_debug(0, "fmt - w: %d, h: %d, mb - w: %d, h: %d\n",
-		  pix_mp->width, pix_mp->height,
-		  JPEG_MB_WIDTH(pix_mp->width),
-		  JPEG_MB_HEIGHT(pix_mp->height));
+	vpu_debug(0, "fmt - w: %d, h: %d\n",
+		  pix_mp->width, pix_mp->height);
 
 	/*
 	 * Current raw format might have become invalid with newly
-- 
2.20.1

