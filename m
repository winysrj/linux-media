Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FC8C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3602147C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klUe9fKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfBYWWW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:22 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41670 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfBYWWV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:21 -0500
Received: by mail-wr1-f66.google.com with SMTP id n2so11703947wrw.8
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=klUe9fKl1cz/XpbqmyqNNPrLvgzo3Hjdj43RyC7waG58vah4xXqOd8DVO4U/SpN284
         8Woq6KH6Oua6cI+2vk8d9fJb8+HWOmwGxq3aoayK6rbr0E01gOpe4mMSfXEK1uEQsMMc
         Cq8qbIYfBA/523TWTH4hbTF2uXkf+tUTF52oxNnMJ0Mo6FX1cByvOebewNF3bEd1bNBH
         fa/JbqjSA9EI9QObNQbHReeOQUqLg4dpXfRf/wcwZnW+51nPIHFVi75UuKW6R3IDpErs
         0nMgR4JUBDwfqC/UuJmrvI0ZKgSoAgiAEDwdhg7btkDGWTNOksGMHfTIRsoPjRt4ikPY
         zQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N3iDG/yikMh8AExZiSWQRYKCi89Q3tUUiOmO5GOcbl0=;
        b=EYt0IW6sPQ7dOxommHnRqSHQmz/LB9OWGoUa/4Vk48TMMWX17Qf3I4i36xczjMOqv/
         TiyflIrPMhb3k8n4RCrWXt0imFcGTze1Q/blTwhamNdw3trSIIAVk/dgPwLEfNFijQ7h
         8BqlPFlmbUJqbN7nwgDrK0rbO/EMAy1RACzlzB8QKFlx4rsRDT7BA4zFDasBd5NLT2PZ
         gQF5B/EqZ6QxrKYwMu8UyseOtEViHYK8jURjBXB1zsKZ3gvNcftun89H43fFcdze1c0y
         w5X2NC6CftCwELsFEhZx/cVHB94Xfr+XKxdLjyPRZzGGD4hfRfgR3qJShvs0Q+AvcB38
         eokw==
X-Gm-Message-State: AHQUAub06dVaXnRirVIJMPIy8dCSl+60d1n0a4w+wLgyXUD+StaLJ3PT
        2BRlFlgAf0oOwn0VYuwsJju/asET72I=
X-Google-Smtp-Source: AHgI3IZ4+kdykQhh09ize+BoHIEO6C+VI0BGZeMcNWUujPJIyx5j6iHE0OAoSeX6T/LaApT2GkJvWw==
X-Received: by 2002:adf:df0d:: with SMTP id y13mr13662492wrl.69.1551133338909;
        Mon, 25 Feb 2019 14:22:18 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:18 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 10/21] media: vicodec: Move raw frame preparation code to a function
Date:   Mon, 25 Feb 2019 14:22:01 -0800
Message-Id: <20190225222210.121713-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
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

