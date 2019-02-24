Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CCCC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27A1D20652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RIW/YJlB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfBXJDC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55294 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbfBXJDB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id a62so5412206wmh.4
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pB/Ab7qvIqYZr26DufyFlAQ/pzyAzIDOZ2w3nfEv1mY=;
        b=RIW/YJlB8kkP/S1xcfZ2DZp2HfN3K/9pP1U2h2Cya2qDvogE2k7jOKsQ/VtYa+TAYa
         UeyCrZtp+ayxRhhf8aIusLMfyEk2vssPaQ3Q1BFCXBLcUuvnWwTWwVhIetFZg53yMxsQ
         E9edwuDnCjD9Sk6gAuIQD7ZQ9fSONdUFW2Gr63ifH0tzKY/WLURspPSaJ5XPIt8+WrCI
         7CyuqorycktiwxgykdiVz7ObI1A7V79eem2OgAKe9+7OdKtdryueKfExS9Cr4qj+PIqE
         nh4Are6MnwAKaa5mdIOQ6PC8RnGaPUmhBvBpgqYUNnNfS/mTCgLBIS87Gx52nbu/Lr6h
         bqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pB/Ab7qvIqYZr26DufyFlAQ/pzyAzIDOZ2w3nfEv1mY=;
        b=ndE5d69XtJFggZnkJiJvKCRWzxFP0FMhlLGix71Zk0oPOB2BcZ4fGMLGMhUHsjcGty
         LKTAsY1UxxVD+kKg4LkKl1BfzR3rbskMDpuTHJnmyOJXfZMFwB+pX7OL0uW5Rtshly5X
         EULFCDUeODuH4OWoYNBaXKh0aOxobw+4AVJ7DX6pS9mKTFUAKkV2ZY6jb52koUrBBf+a
         nCtOBvI2Qnt154O23rD826RID015ifNu2OZPsq1C65inwM55xVMMu5q9UyBWtitgs7ti
         8pqnqjGRAl/Y7OC/g42YQpxrANRbUq+IBrLpU2+XSbtZqErTnMPtYN+zjllHc+/ZA85Q
         JIqA==
X-Gm-Message-State: AHQUAuaX9Iffz6mr5q6chaf2yYtz0t+g//Aunl6G6rS0kY1CZ3EgtZzx
        JophBZtDzY+TnjA6dnDTMHUOifAk3wY=
X-Google-Smtp-Source: AHgI3IbvpSYIi15LkMd54gAd/g+TappHApFuQJmH2yzk/lgsl7R5iiJRq6jjGddO3aD/iW0yFkle7A==
X-Received: by 2002:a1c:dc85:: with SMTP id t127mr2838053wmg.136.1550998979419;
        Sun, 24 Feb 2019 01:02:59 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:02:58 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 07/18] media: vicodec: bugfix - call v4l2_m2m_buf_copy_metadata also if decoding fails
Date:   Sun, 24 Feb 2019 01:02:24 -0800
Message-Id: <20190224090234.19723-8-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The function 'v4l2_m2m_buf_copy_metadata' should
be called even if decoding/encoding ends with
status VB2_BUF_STATE_ERROR, so that the metadata
is copied from the source buffer to the dest buffer.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 778b974e9624..cd08f0cd4cf8 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -159,12 +159,10 @@ static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *dst_vb)
 {
 	struct vicodec_dev *dev = ctx->dev;
-	struct vicodec_q_data *q_dst;
 	struct v4l2_fwht_state *state = &ctx->state;
 	u8 *p_src, *p_dst;
 	int ret;
 
-	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (ctx->is_enc)
 		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
 	else
@@ -187,8 +185,10 @@ static int device_process(struct vicodec_ctx *ctx,
 			return comp_sz_or_errcode;
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, comp_sz_or_errcode);
 	} else {
+		struct vicodec_q_data *q_dst;
 		unsigned int comp_frame_size = ntohl(ctx->state.header.size);
 
+		q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 		if (comp_frame_size > ctx->comp_max_size)
 			return -EINVAL;
 		state->info = q_dst->info;
@@ -197,11 +197,6 @@ static int device_process(struct vicodec_ctx *ctx,
 			return ret;
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
 	}
-
-	dst_vb->sequence = q_dst->sequence++;
-	dst_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	v4l2_m2m_buf_copy_metadata(src_vb, dst_vb, !ctx->is_enc);
-
 	return 0;
 }
 
@@ -275,16 +270,22 @@ static void device_run(void *priv)
 	struct vicodec_ctx *ctx = priv;
 	struct vicodec_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *src_buf, *dst_buf;
-	struct vicodec_q_data *q_src;
+	struct vicodec_q_data *q_src, *q_dst;
 	u32 state;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
 	state = VB2_BUF_STATE_DONE;
 	if (device_process(ctx, src_buf, dst_buf))
 		state = VB2_BUF_STATE_ERROR;
+	else
+		dst_buf->sequence = q_dst->sequence++;
+	dst_buf->flags &= ~V4L2_BUF_FLAG_LAST;
+	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, !ctx->is_enc);
+
 	ctx->last_dst_buf = dst_buf;
 
 	spin_lock(ctx->lock);
-- 
2.17.1

