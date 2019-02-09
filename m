Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0ACC282CB
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03E0721919
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t+UodaWu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfBINyw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:54:52 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40655 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfBINyv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 08:54:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id q21so8291202wmc.5
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 05:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3tDbMu00l/OX/eimX2URfmFeLkdkLbFDJD8Mm587E6k=;
        b=t+UodaWuELj7GQdRtirp6DeCX1GeWaroN6Ng4ad5PO1JToNu/UQnOyD+qJOI33w2Mq
         xwFH3ok1uLhNwxd1FF6OOUghVMLWM8mo82GPogLBPDA5OAhpxKhdrqZ3bdcnY/zV9VP1
         qC1ba6VnkgO50k04eOC4hqP4ZRajSo8T9x9uvcnnoUNOqxgeQj/8B3AJXHNnH9vcfaBd
         VOA1nUH8ahKwU8W/wQJCqSJ3iJRkNwppIhLkVU0pKp1EkLWW3yrJpMaBrx9N3X+uOOCR
         JIYK1Hyb9Pf4I018TSCPBp/y/ToY5VyBUb1sftPZOUXtc8GImxgI93InxMP2GEAv0nJu
         vIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3tDbMu00l/OX/eimX2URfmFeLkdkLbFDJD8Mm587E6k=;
        b=rEdHQXk9Lh27xcOzQt99zVcU5XYxrBsjSGi0yXlDifa2WcabV1NN7si9md9MPrn+W1
         NIRAv6vqU/GbCHAkSpEJ89eyfSbHVmzZkPtxwE/3zOv+EVy9FOUMHMshX0pBpD19rmM1
         NzIq68+hYSAL0HMS7TpWjazfjBUjzVURrzTypEjEk+5uopsHC6j/nfR9COckJawhWiXQ
         Lb3bLuya0xt6yIaUyzZ7pQOgFWIFybj/5afUfRM2hXh32lsKdxyUrlOAtbuqUgs0GGnw
         xnb6G6yIjRGQ5vDVgaimMVpXHjQinSVYMbEnylRX4tpk+9A/w6A/Mkyh9a2c695fVINK
         0KsQ==
X-Gm-Message-State: AHQUAuao5f4gvtpAUPmKpC8xKEH3gVKLj+i/BpyyrQYGwoM5fFCV1otX
        BUNUZOoN6B1zMjp7lp+xDknWLs8z9M4=
X-Google-Smtp-Source: AHgI3IZplPHfvoUl+SsEPJGipRXWvjiggUG7FlZnJVQHYBB9XmhhiE1jNoMEiRyAOMX8AfGtSvksmw==
X-Received: by 2002:a1c:968a:: with SMTP id y132mr2821208wmd.107.1549720488921;
        Sat, 09 Feb 2019 05:54:48 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id a15sm2864081wrx.58.2019.02.09.05.54.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:54:48 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 8/9] media: vicodec: call v4l2_m2m_buf_copy_metadata also upon error
Date:   Sat,  9 Feb 2019 05:54:26 -0800
Message-Id: <20190209135427.20630-9-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209135427.20630-1-dafna3@gmail.com>
References: <20190209135427.20630-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

call v4l2_m2m_buf_copy_metadata also if decoding/encoding
ends with status VB2_BUF_STATE_ERROR.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 324ce566478e..9a6ee593ae19 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -165,12 +165,10 @@ static int device_process(struct vicodec_ctx *ctx,
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
@@ -192,8 +190,10 @@ static int device_process(struct vicodec_ctx *ctx,
 			return ret;
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
 	} else {
+		struct vicodec_q_data *q_dst;
 		unsigned int comp_frame_size = ntohl(ctx->state.header.size);
 
+		q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 		if (comp_frame_size > ctx->comp_max_size)
 			return -EINVAL;
 		state->info = q_dst->info;
@@ -204,11 +204,6 @@ static int device_process(struct vicodec_ctx *ctx,
 
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
 	}
-
-	dst_vb->sequence = q_dst->sequence++;
-	dst_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	v4l2_m2m_buf_copy_metadata(src_vb, dst_vb, !ctx->is_enc);
-
 	return 0;
 }
 
@@ -282,16 +277,22 @@ static void device_run(void *priv)
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

