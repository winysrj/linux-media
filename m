Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044D3C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0A920684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7OHsO0M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfCFVOS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43706 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfCFVOR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id d17so15024701wre.10
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ayEOXWVt6sti0jEKrJJnU5rJOmMEFp+b2iYryD4XyI=;
        b=P7OHsO0Mv8zxCSWw5yS62L3egLKl0lW8UbK2bn8zzHe1/aNZtvOgfXfCWgK35LWUso
         w3a7/TvCB9Pmz51AevUol4qnrIQHZ5+nvRre52QfsZrjLAyEXClZ/IRDealyxDBW4crz
         MpWqUhVE5mHz1ccsYYRJTZ9c7bog4iuco97mLHMsXBCTKgAtIU9ZXCO9NcVbwpReV+I5
         PFxZZTaedpMwx3ToBHSe4ldf78CS45Ld8Y1elQGQhadQDBu1WJIjsEl+OEkRqHRh7kOI
         0A1DHmBxP0fXr709IxclgcqiV+UQKdlVUt2djg1ibxbLLAPawTCdCffCSOZfsBgnWSn3
         vpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ayEOXWVt6sti0jEKrJJnU5rJOmMEFp+b2iYryD4XyI=;
        b=D4TI9eN1AubIX0wsKs5F8+3eqEtxORx66HrPVvrnt7f89VsBS7arAwbxNtKDj8GZbV
         Kk5WMCguei68muPj0mJYD14PmV9xLodQon9TYyDZaVvak7/ZL3W4SmMtHhvzz4tzckYo
         0mIydTnuBWySKBO0hW756aN4YqoPDfD6QgNtRyVYk35Pk9529Wt717Z1uyvteI9V1Go5
         ezIy6kuc7x4l69/LB3AWQLju1QYWF7GEq7J8RurlV/FInkHc8ihIayD4AkQ40KY/7w8G
         RKI8aXCb2ik+Eeb17UINna1rV8hJoY+2zXS8iAwQeVyU8tDzrMy7cgTuZrVOZNyjiE7E
         yt9w==
X-Gm-Message-State: APjAAAU94wHdhUeeQxfNclhEYOmZAjhhb2G6VAUQYjXWTNnZ3E05m+Np
        v+m7FgLE5bAYufh6E6fhEbdM3eU2/cs=
X-Google-Smtp-Source: APXvYqxq9YzVqxICHFgNC/3U6O3qAexYHJVZZlb+oM3jdCGA+EsF88bb7yLu/3XHsks2bvmDGbrGBg==
X-Received: by 2002:adf:c54d:: with SMTP id s13mr4228388wrf.169.1551906855448;
        Wed, 06 Mar 2019 13:14:15 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:14 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 08/23] media: vicodec: bugfix - call v4l2_m2m_buf_copy_metadata also if decoding fails
Date:   Wed,  6 Mar 2019 13:13:28 -0800
Message-Id: <20190306211343.15302-9-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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
index eec31b144d56..8205a602bb38 100644
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

