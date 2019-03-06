Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EE9C10F00
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E26620661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ks6lSuvo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfCFVOq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:46 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33958 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfCFVOp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:45 -0500
Received: by mail-wm1-f65.google.com with SMTP id o10so5307505wmc.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4DrDBcZb4G0o0CPsc/3GlqtPQLEBH6yaVhdjnmtqz50=;
        b=ks6lSuvo1N7kRCctu2soEYrqmJyBlwPwn24h1eGGESPDz1tOmOL+YSjn5UOGGoLGAy
         F2y5jlrgIuz0tBKPNZzUjYuwhSs6e7YdZDVWa6L5ShQPsqN8D39JMK8I2iIgxQWydtk1
         CKzti89dUeFIUhIMwO/O9reOeOfYKQCesBpy3exuoOZ4OdAIZTSEGfiEwHk1S6Xez+Xe
         28xqoVJFYHRFMxILEGCXXe29N9PHd5mv3xM2s6CrxwoMflF7qFtYRRJyGwlWP38rEpz0
         7AYBjTEdIx6UVYuNQ8VuaaWW6dx8jf1Wkr/AO8b2seQJ6Or+hb0T7a14IFwSoiF2F7O9
         Rh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4DrDBcZb4G0o0CPsc/3GlqtPQLEBH6yaVhdjnmtqz50=;
        b=I6eEA48cdRqT8K6CNyxC3OAo6Zuz+Awa9LgkANQku64PH4xzvCqFaT8rb9lgnu/j4O
         JVOA/8DItdKt8cq06m1JRKJE5JC6zIMt/Tf2yFU6/nVdDvidhk6bwH0ac3uT56b58QPQ
         iqZJoIxWcMv7DjhOMao6YMKaN+1Yr9HT+poFXBgs4UHFTWdJ6EiF2EJRp4Xmv5VOXKtE
         577FRkAxvGfGt0gbGnmUCw9zSr1qgupwT3JsqjL5y7LOSCHSpLOP3Uj+iGmsq+zzcKM3
         zj6oDeoxYm1V16Z+cJM2ir3y1fESGbfw/Szenb6Pu4Xad7ThFL/lKC+nCh+qo3pc/AVR
         zJZw==
X-Gm-Message-State: APjAAAVwhriWbpogwhr/nWALCUW/m5Ais3aFOxJkE0rrVR6J4dj3SiOs
        BfNoFv1YjFG1+ATWAzJe7A0iODxQtVw=
X-Google-Smtp-Source: APXvYqweg+zpNVodvdEfFJXRbG2a2VkwSV3REEjTo2yIbnj2xGRhIGi9dTCBfeKobh62vrWNJ4GPQQ==
X-Received: by 2002:a1c:64c1:: with SMTP id y184mr3645825wmb.0.1551906882641;
        Wed, 06 Mar 2019 13:14:42 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:41 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 23/23] media: vicodec: set pixelformat to V4L2_PIX_FMT_FWHT_STATELESS for stateless decoder
Date:   Wed,  6 Mar 2019 13:13:43 -0800
Message-Id: <20190306211343.15302-24-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

for stateless decoder, set the output pixelformat
to V4L2_PIX_FMT_FWHT_STATELESS and the pix info to
pixfmt_stateless_fwht

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 47 ++++++++++++++-----
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index d2633a6135c8..2f7419b39452 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -728,7 +728,8 @@ static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx,
 	} else {
 		if (f->index)
 			return -EINVAL;
-		f->pixelformat = V4L2_PIX_FMT_FWHT;
+		f->pixelformat = ctx->is_stateless ?
+			V4L2_PIX_FMT_FWHT_STATELESS : V4L2_PIX_FMT_FWHT;
 	}
 	return 0;
 }
@@ -830,13 +831,15 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
 	struct v4l2_plane_pix_format *plane;
-	const struct v4l2_fwht_pixfmt_info *info = &pixfmt_fwht;
+	const struct v4l2_fwht_pixfmt_info *info = ctx->is_stateless ?
+		&pixfmt_stateless_fwht : &pixfmt_fwht;
 
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		pix = &f->fmt.pix;
-		if (pix->pixelformat != V4L2_PIX_FMT_FWHT)
+		if (pix->pixelformat != V4L2_PIX_FMT_FWHT &&
+		    pix->pixelformat != V4L2_PIX_FMT_FWHT_STATELESS)
 			info = find_fmt(pix->pixelformat);
 
 		pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH);
@@ -857,7 +860,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		pix_mp = &f->fmt.pix_mp;
 		plane = pix_mp->plane_fmt;
-		if (pix_mp->pixelformat != V4L2_PIX_FMT_FWHT)
+		if (pix_mp->pixelformat != V4L2_PIX_FMT_FWHT &&
+		    pix_mp->pixelformat != V4L2_PIX_FMT_FWHT_STATELESS)
 			info = find_fmt(pix_mp->pixelformat);
 		pix_mp->num_planes = 1;
 
@@ -934,8 +938,12 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 		if (multiplanar)
 			return -EINVAL;
 		pix = &f->fmt.pix;
-		pix->pixelformat = !ctx->is_enc ? V4L2_PIX_FMT_FWHT :
-				   find_fmt(pix->pixelformat)->id;
+		if (ctx->is_enc)
+			pix->pixelformat = find_fmt(pix->pixelformat)->id;
+		else if (ctx->is_stateless)
+			pix->pixelformat = V4L2_PIX_FMT_FWHT_STATELESS;
+		else
+			pix->pixelformat = V4L2_PIX_FMT_FWHT;
 		if (!pix->colorspace)
 			pix->colorspace = V4L2_COLORSPACE_REC709;
 		break;
@@ -943,8 +951,12 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 		if (!multiplanar)
 			return -EINVAL;
 		pix_mp = &f->fmt.pix_mp;
-		pix_mp->pixelformat = !ctx->is_enc ? V4L2_PIX_FMT_FWHT :
-				      find_fmt(pix_mp->pixelformat)->id;
+		if (ctx->is_enc)
+			pix_mp->pixelformat = find_fmt(pix_mp->pixelformat)->id;
+		else if (ctx->is_stateless)
+			pix_mp->pixelformat = V4L2_PIX_FMT_FWHT_STATELESS;
+		else
+			pix_mp->pixelformat = V4L2_PIX_FMT_FWHT;
 		if (!pix_mp->colorspace)
 			pix_mp->colorspace = V4L2_COLORSPACE_REC709;
 		break;
@@ -987,6 +999,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 
 		if (pix->pixelformat == V4L2_PIX_FMT_FWHT)
 			q_data->info = &pixfmt_fwht;
+		else if (pix->pixelformat == V4L2_PIX_FMT_FWHT_STATELESS)
+			q_data->info = &pixfmt_stateless_fwht;
 		else
 			q_data->info = find_fmt(pix->pixelformat);
 		q_data->coded_width = pix->width;
@@ -1008,6 +1022,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 
 		if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT)
 			q_data->info = &pixfmt_fwht;
+		else if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT_STATELESS)
+			q_data->info = &pixfmt_stateless_fwht;
 		else
 			q_data->info = find_fmt(pix_mp->pixelformat);
 		q_data->coded_width = pix_mp->width;
@@ -1220,6 +1236,8 @@ static int vicodec_enum_framesizes(struct file *file, void *fh,
 				   struct v4l2_frmsizeenum *fsize)
 {
 	switch (fsize->pixel_format) {
+	case V4L2_PIX_FMT_FWHT_STATELESS:
+		break;
 	case V4L2_PIX_FMT_FWHT:
 		break;
 	default:
@@ -1504,7 +1522,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	    (!V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc))
 		return 0;
 
-	if (info->id == V4L2_PIX_FMT_FWHT) {
+	if (info->id == V4L2_PIX_FMT_FWHT ||
+	    info->id == V4L2_PIX_FMT_FWHT_STATELESS) {
 		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
 		return -EINVAL;
 	}
@@ -1779,15 +1798,19 @@ static int vicodec_open(struct file *file)
 	ctx->fh.ctrl_handler = hdl;
 	v4l2_ctrl_handler_setup(hdl);
 
-	ctx->q_data[V4L2_M2M_SRC].info =
-		ctx->is_enc ? v4l2_fwht_get_pixfmt(0) : &pixfmt_fwht;
+	if (ctx->is_enc)
+		ctx->q_data[V4L2_M2M_SRC].info = v4l2_fwht_get_pixfmt(0);
+	else if (ctx->is_stateless)
+		ctx->q_data[V4L2_M2M_SRC].info = &pixfmt_stateless_fwht;
+	else
+		ctx->q_data[V4L2_M2M_SRC].info = &pixfmt_fwht;
 	ctx->q_data[V4L2_M2M_SRC].coded_width = 1280;
 	ctx->q_data[V4L2_M2M_SRC].coded_height = 720;
 	ctx->q_data[V4L2_M2M_SRC].visible_width = 1280;
 	ctx->q_data[V4L2_M2M_SRC].visible_height = 720;
 	size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
 		ctx->q_data[V4L2_M2M_SRC].info->sizeimage_div;
-	if (ctx->is_enc)
+	if (ctx->is_enc || ctx->is_stateless)
 		ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
 	else
 		ctx->q_data[V4L2_M2M_SRC].sizeimage =
-- 
2.17.1

