Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83F3C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACC58206BA
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHoerPUJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfBXJDG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43124 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfBXJDF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id d17so6639566wre.10
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=CHoerPUJFlIkH+30f4FqTlxEw87wGWrwOvqKrsd2bOQSW8zrQ6VnDiBfJBQrMDtN2Z
         AubiPA8ReFUfrUo8RcUqtZnK1IYyrqT9WFZTC1qzl0YMRi1jwLQPnoO0IwvBfbO/oAJu
         D1T6VCZvkPGJqmPEZ13km0oBGpNh7ai7yCLq767dVbS7+3+luOTY6GJn+mZD+T1WD4HA
         nmLAcW7mfciqvSn+LmtmME9BpXEc7dMBzTMIoPeNqIv4tdxR6+A9kLf9AtzWdDusOirz
         SW8lDdobJP6vBlkBf9WVNtb4jsidH8Bom/3b0NdZ5hFWBVQMd7Safyd0FIn0ChDZYrPr
         J4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=acs15v7iYQ7ag9m41NXfDaq/Sxc0ObzsYQ6DoZBTEmYI2Vwij/1pdP4KtDv4evn9Gk
         XMP1V/GtVSE1RORQ3zQ0BnDh79NBOLgegN5UitaY+t/GBBb9wQrPXZfHQKI7wYbbOaT3
         858KIFNZxidhH5gysNjwsAZj3S5gYRfW62kOWuT7c1xA5o6E6s8OAVshi2Uv6bYmy0C3
         zkOoYZlwNCl36tYOMt6KfBJ6DWsstHBd0nYkXTiwU+Cl22eqbG1qfGTF4bp1Nl9JHQ4W
         Uov0f2ujtRna/q8jy8tO8CJD/bP1v8IaP4R8Vl3rkrLqjy3+ygcM1d6BRbxQ6UbVi9Fj
         2dhA==
X-Gm-Message-State: AHQUAub/eylEuhS8nA2bDdbKPB45exbon1XqcwcZbncok0aAKvIH36kz
        90YPGZ7ingO7ipF2yn9DjBSAnP/G93A=
X-Google-Smtp-Source: AHgI3IZMidRFYhv9hREtW5erGHOwEczZnJaWx40eEgeW1dYoAPzpOYgIKLw8FTd90sBHO7T1/w43BA==
X-Received: by 2002:a5d:464b:: with SMTP id j11mr8503239wrs.307.1550998982212;
        Sun, 24 Feb 2019 01:03:02 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.03.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:03:01 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 09/18] media: vicodec: Move raw frame preparation code to a function
Date:   Sun, 24 Feb 2019 01:02:26 -0800
Message-Id: <20190224090234.19723-10-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Introduce 'prepare_raw_frame' function that fills the values
of a raw frame struct according to the format.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 143 ++++++++++--------
 1 file changed, 78 insertions(+), 65 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 6573a471c5ca..515b3115b3c6 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -75,117 +75,130 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
 	return v4l2_fwht_pixfmts + idx;
 }
 
-int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
+static int prepare_raw_frame(struct fwht_raw_frame *rf,
+			 const struct v4l2_fwht_pixfmt_info *info, u8 *buf,
+			 unsigned int size)
 {
-	unsigned int size = state->stride * state->coded_height;
-	unsigned int chroma_stride = state->stride;
-	const struct v4l2_fwht_pixfmt_info *info = state->info;
-	struct fwht_cframe_hdr *p_hdr;
-	struct fwht_cframe cf;
-	struct fwht_raw_frame rf;
-	u32 encoding;
-	u32 flags = 0;
-
-	if (!info)
-		return -EINVAL;
-
-	rf.luma = p_in;
-	rf.width_div = info->width_div;
-	rf.height_div = info->height_div;
-	rf.luma_alpha_step = info->luma_alpha_step;
-	rf.chroma_step = info->chroma_step;
-	rf.alpha = NULL;
-	rf.components_num = info->components_num;
+	rf->luma = buf;
+	rf->width_div = info->width_div;
+	rf->height_div = info->height_div;
+	rf->luma_alpha_step = info->luma_alpha_step;
+	rf->chroma_step = info->chroma_step;
+	rf->alpha = NULL;
+	rf->components_num = info->components_num;
 
 	switch (info->id) {
 	case V4L2_PIX_FMT_GREY:
-		rf.cb = NULL;
-		rf.cr = NULL;
+		rf->cb = NULL;
+		rf->cr = NULL;
 		break;
 	case V4L2_PIX_FMT_YUV420:
-		rf.cb = rf.luma + size;
-		rf.cr = rf.cb + size / 4;
-		chroma_stride /= 2;
+		rf->cb = rf->luma + size;
+		rf->cr = rf->cb + size / 4;
 		break;
 	case V4L2_PIX_FMT_YVU420:
-		rf.cr = rf.luma + size;
-		rf.cb = rf.cr + size / 4;
-		chroma_stride /= 2;
+		rf->cr = rf->luma + size;
+		rf->cb = rf->cr + size / 4;
 		break;
 	case V4L2_PIX_FMT_YUV422P:
-		rf.cb = rf.luma + size;
-		rf.cr = rf.cb + size / 2;
-		chroma_stride /= 2;
+		rf->cb = rf->luma + size;
+		rf->cr = rf->cb + size / 2;
 		break;
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV24:
-		rf.cb = rf.luma + size;
-		rf.cr = rf.cb + 1;
+		rf->cb = rf->luma + size;
+		rf->cr = rf->cb + 1;
 		break;
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_NV42:
-		rf.cr = rf.luma + size;
-		rf.cb = rf.cr + 1;
+		rf->cr = rf->luma + size;
+		rf->cb = rf->cr + 1;
 		break;
 	case V4L2_PIX_FMT_YUYV:
-		rf.cb = rf.luma + 1;
-		rf.cr = rf.cb + 2;
+		rf->cb = rf->luma + 1;
+		rf->cr = rf->cb + 2;
 		break;
 	case V4L2_PIX_FMT_YVYU:
-		rf.cr = rf.luma + 1;
-		rf.cb = rf.cr + 2;
+		rf->cr = rf->luma + 1;
+		rf->cb = rf->cr + 2;
 		break;
 	case V4L2_PIX_FMT_UYVY:
-		rf.cb = rf.luma;
-		rf.cr = rf.cb + 2;
-		rf.luma++;
+		rf->cb = rf->luma;
+		rf->cr = rf->cb + 2;
+		rf->luma++;
 		break;
 	case V4L2_PIX_FMT_VYUY:
-		rf.cr = rf.luma;
-		rf.cb = rf.cr + 2;
-		rf.luma++;
+		rf->cr = rf->luma;
+		rf->cb = rf->cr + 2;
+		rf->luma++;
 		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_HSV24:
-		rf.cr = rf.luma;
-		rf.cb = rf.cr + 2;
-		rf.luma++;
+		rf->cr = rf->luma;
+		rf->cb = rf->cr + 2;
+		rf->luma++;
 		break;
 	case V4L2_PIX_FMT_BGR24:
-		rf.cb = rf.luma;
-		rf.cr = rf.cb + 2;
-		rf.luma++;
+		rf->cb = rf->luma;
+		rf->cr = rf->cb + 2;
+		rf->luma++;
 		break;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
 	case V4L2_PIX_FMT_HSV32:
-		rf.cr = rf.luma + 1;
-		rf.cb = rf.cr + 2;
-		rf.luma += 2;
+		rf->cr = rf->luma + 1;
+		rf->cb = rf->cr + 2;
+		rf->luma += 2;
 		break;
 	case V4L2_PIX_FMT_BGR32:
 	case V4L2_PIX_FMT_XBGR32:
-		rf.cb = rf.luma;
-		rf.cr = rf.cb + 2;
-		rf.luma++;
+		rf->cb = rf->luma;
+		rf->cr = rf->cb + 2;
+		rf->luma++;
 		break;
 	case V4L2_PIX_FMT_ARGB32:
-		rf.alpha = rf.luma;
-		rf.cr = rf.luma + 1;
-		rf.cb = rf.cr + 2;
-		rf.luma += 2;
+		rf->alpha = rf->luma;
+		rf->cr = rf->luma + 1;
+		rf->cb = rf->cr + 2;
+		rf->luma += 2;
 		break;
 	case V4L2_PIX_FMT_ABGR32:
-		rf.cb = rf.luma;
-		rf.cr = rf.cb + 2;
-		rf.luma++;
-		rf.alpha = rf.cr + 1;
+		rf->cb = rf->luma;
+		rf->cr = rf->cb + 2;
+		rf->luma++;
+		rf->alpha = rf->cr + 1;
 		break;
 	default:
 		return -EINVAL;
 	}
+	return 0;
+}
+
+int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
+{
+	unsigned int size = state->stride * state->coded_height;
+	unsigned int chroma_stride = state->stride;
+	const struct v4l2_fwht_pixfmt_info *info = state->info;
+	struct fwht_cframe_hdr *p_hdr;
+	struct fwht_cframe cf;
+	struct fwht_raw_frame rf;
+	u32 encoding;
+	u32 flags = 0;
+
+	if (!info)
+		return -EINVAL;
+
+	if (prepare_raw_frame(&rf, info, p_in, size))
+		return -EINVAL;
+
+	if (info->planes_num == 3)
+		chroma_stride /= 2;
+
+	if (info->id == V4L2_PIX_FMT_NV24 ||
+	    info->id == V4L2_PIX_FMT_NV42)
+		chroma_stride *= 2;
 
 	cf.i_frame_qp = state->i_frame_qp;
 	cf.p_frame_qp = state->p_frame_qp;
-- 
2.17.1

