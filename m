Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1899CC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7D6821A80
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZDqig7fS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394895AbfBONGV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:06:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34586 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394890AbfBONGV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:06:21 -0500
Received: by mail-wr1-f68.google.com with SMTP id f14so10324188wrg.1
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 05:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8HNEFm09fHJw68jRxGOgD6bYNXu9KdFAMQNqM5i/EcM=;
        b=ZDqig7fSGYmlsIk3x2LBxvPnMLBQfp8jBDgLs3qmb9FzYFHCLtmPjK3H8pSkmQe+Ti
         gjApdQB2tG44YKSvFfHSAlx1atrRGBzd//Ye92Cdi23mL56yk8CMi+m1l7p/4w1xts6e
         tWAoVDWbwQjnHM6BwZ10pHVVLvN/Hmv3IERzFpPU6ZsXCdbHOkypBxB/bcxPFC6ta0vp
         TOr/8rGXyK7yngJ8EOYHXaaBErsgdEblN+LVO5vXelhCD+nz8o994qpAi4ps3xG9TA9g
         U1DP4zXTWQ7+KUB4Zud0ApgYu0Xd+/MTZXhduIFmdLbveBH2Bqpp5ISrzK9JuC/oYzny
         dT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8HNEFm09fHJw68jRxGOgD6bYNXu9KdFAMQNqM5i/EcM=;
        b=H9Vxb8UGsdm76/5cuu8EgLFLC3DaQq3jCz98HDaZ35YdBRYKGAybCAVQrbFRtBNawY
         MpZ/dZAR76C4qCf5MJT0q3JeokE/SAoW/DIWU1P/RMMkrn8mSz2MlPxtHNMCEgAQ+U5Y
         uA9r6fBuFbhoPO12IIt/j1sS6xFiAwOyrUEA6rsudoioZosC8D3H9Z37pRhgynNCkpWf
         W6/7+ZFgR8l156/4NVA+9qIeZFxwD7WpgC2M3U+SrZCb1xIL+7cyfk5DLxMjeMc7JdyO
         XuiJvv4DgL3+wmUwdDgPDwoWaR3tMVZqF//ecEA78dWwWsOowu9jJV13XA5L1teqqn/l
         vGlg==
X-Gm-Message-State: AHQUAub9p7pNxgTzk+M9cZj9zZ9gBOAM09y7eS9ZyEqDzxrASfWZiItL
        PP1yFVblEUBhwMsHe7uZmPxbtuTjFTA=
X-Google-Smtp-Source: AHgI3IZN2AnykDcJliPqEJr4PtfZ59WLEzAfiUqq21RY/QPgeACONmxl+IRApqkZZe+9LyJrMW8jkw==
X-Received: by 2002:adf:e342:: with SMTP id n2mr6625293wrj.60.1550235978324;
        Fri, 15 Feb 2019 05:06:18 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id n6sm2091065wrt.23.2019.02.15.05.06.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 05:06:17 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 02/10] media: vicodec: Move raw frame preparation code to a function
Date:   Fri, 15 Feb 2019 05:05:02 -0800
Message-Id: <20190215130509.86290-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190215130509.86290-1-dafna3@gmail.com>
References: <20190215130509.86290-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Introduce 'prepare_raw_frame' function that fills the values
of a raw frame struct according to the format.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 140 ++++++++++--------
 1 file changed, 75 insertions(+), 65 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index c15034849133..728ed5012aed 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -75,117 +75,127 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
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
+	if (info->id == V4L2_PIX_FMT_YUV420 ||
+	    info->id == V4L2_PIX_FMT_YVU420 ||
+	    info->id == V4L2_PIX_FMT_YUV422P)
+		chroma_stride /= 2;
 
 	cf.i_frame_qp = state->i_frame_qp;
 	cf.p_frame_qp = state->p_frame_qp;
-- 
2.17.1

