Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB31C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4092620C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOBrA+90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbfBZRFq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39189 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbfBZRFq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so14791701wrw.6
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=jOBrA+90oUwc60HJWX6W2HGZVVtWlsJsGxpilmEbNRzMB5uhtaUpH0Xo8HmAiphKrT
         Y5/IobEb2HqQ6o6qweWskpwHu44qF4jkfYi9gCd72IsRFLCCqnHixOtMY+VZmp+KprOg
         ncGV3LksJqT5kFxnuk5+BEagGV7rUZMmXIa7Wsc5uSy7VupeSqGJTXZFMTF6KxGf33ZX
         izXwXZfXCM5URGSa8PK25Sp3evF3ZczlSkeIKdeApz/w2KlupSRwOq6UZvOsrT2xlyeA
         iqqEfWjSXD5va5I6bnkTScCeEQPFhBVXxLlcGop4BwvdNntLK/U8Zfgggo4Q9NCvyo4R
         y0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=b8ZqeqMY8X2OEssbSluFPtocg+hEULxQNRj27oi/KiRSVP9Q3ZuoEx5eH4yE3XWFX6
         KnOWQ97z37Qpul/gI2ArvK1OKGMTorLnvM2NhyDqBIXzM0wuQQ2x+MkoyZPKDe6Brk8r
         kr52o3TfyU56+yobp5c5/Hh5Oa3xlIuAWJlaIH2qvxjzQm7GYKA+fk2K3Te8Et0v/bcI
         NQ6KrVYqkRdNbMLbWPfKesNfMqwMe0D6GGv8OYpMS4llV0bsCqdytbbUJYVJg1V2qTXf
         eFrmDb6BXQzXgBOm3vIbQ+F6G3LaDLk4WBA1J4epFitDY19w34V6z//oLnFgSPK24R8h
         2TWQ==
X-Gm-Message-State: AHQUAuY6Au1NAPOrWh0iMnlAfK5y8sgwhgJT/BvoRtsYWHCqJBlWGfII
        +q5Z7FiqF1lhO6yyjnBpJaUyzPIFMzo=
X-Google-Smtp-Source: AHgI3IZaYdTzVxR2bfKlxYoHfGy08xqd9oHxJmqpe+1o8vVnpOjDxKImQ3CseWsO0NEyOk5+m3hPtQ==
X-Received: by 2002:adf:e3cb:: with SMTP id k11mr17618146wrm.263.1551200743709;
        Tue, 26 Feb 2019 09:05:43 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:43 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 10/21] media: vicodec: Move raw frame preparation code to a function
Date:   Tue, 26 Feb 2019 09:05:03 -0800
Message-Id: <20190226170514.86127-11-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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

