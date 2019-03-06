Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E6AC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E10D020684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMeWdW6Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfCFVOV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38696 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfCFVOU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id g12so15036222wrm.5
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=iMeWdW6ZmVNjltepjaGYMwtsGcQKUjAVJi2ZoGRz5NzX1XmaP88iiIdDqEYy6W2sr6
         vGgEJKhAeNT8/vdR8bwlLgh/ihm1+wK+fJhmG+Q25TBQMkh8g2Pk4eZR8DAQ7gr8woxL
         7yC345BtoPIea0f7Yz7pzIfKK15tcoGch0PCPOxkri0xOmRwPsB7jTyzVVjOB7ClkIzv
         V9+K2vtOO9n2GKAh4QARljgHEJAU0ZB2ANUeZeW1bZMIRPuuIrgxadAWLg8QFfp4L+WQ
         KaeFu3jAi14W6jrVNuNN9OeMtW7WsPuH932yVTWRrj4s4TFaaohlKwvLOOot+4unaLZ9
         UPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=YMabVZQB2WXwZk/wJTcb1xu8CpI9C4BB+v0lO0+VfUvqPdwyw1mB/fIfjBM25GRvCP
         bAyQUgMhFdnsi26WKr6PvfpwfWqVuLzaH5PNgH3Ru8VfyPSvOXURt/ND1AThJMVZcFkV
         QNvlcdwi0BvsLvTo7XpTb0vI/b7vRzQD8j91KCBZhpnjOPn5N3o0bxqs+E3chLVsJ9NV
         LU/5g3WMSytj507jXUfbdgQS6mPxLlNuthl5f78Oq4dA1o3oF/qFNqmP006+3iJIVpp+
         IemlvaZxgW9wySwNdrsHDS6NTgP1929G8IOtIud0VQnlp3lSK0jr3oONnj7Zc50Qt+2J
         x0zg==
X-Gm-Message-State: APjAAAXeb4jlepM7N7BhhMVPs4xYiNgZrIKFl2jNXi/I/Q7AqL1x2BpL
        1GfaKesKkoNyimEMEzYTAD+E2URICuU=
X-Google-Smtp-Source: APXvYqzvfFtgoDypRLivrl77e6Vz+ZqzksKw1uz4sZlVDBFfZ0JBjfRX5Ds5NnbU4c+3UZO20zh4jg==
X-Received: by 2002:a5d:6682:: with SMTP id l2mr4209975wru.271.1551906859006;
        Wed, 06 Mar 2019 13:14:19 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:18 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 10/23] media: vicodec: Move raw frame preparation code to a function
Date:   Wed,  6 Mar 2019 13:13:30 -0800
Message-Id: <20190306211343.15302-11-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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

