Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66664C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3121D213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbtseVLX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfBYWUG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:20:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39618 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbfBYWUF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:20:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so11713588wrw.6
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ayEOXWVt6sti0jEKrJJnU5rJOmMEFp+b2iYryD4XyI=;
        b=RbtseVLXq6URdeqBjGg8SQ9TQwxb+MlW/8kdP9pJI1sjG0SeTp+Ro7CMHtYitQr1nu
         hUZiHmAqWmtqE0oY1NJwqFtk/76rK49cvAcfGVi0WF5mcUiRZPLwtyLdD6GsL4RH0kmV
         K/cEVSgP66RZ719ptBzAaDMmRiBQ09+hU83pe5stJHCLmR4YH5AlYnc0p0pCWpYeg6tI
         avoJ2E6QAmsyTYkISR38PnHHTmS1ujycNgphcD96ORYHYhsMvEavkLVsCe1NM87/MMlE
         VbC+3tYad3OzYEz8LuyK2p4WAQk17WM8KVxTqSjCtR8CrAAd1jENOQUw2zDJdb149vaj
         9V8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ayEOXWVt6sti0jEKrJJnU5rJOmMEFp+b2iYryD4XyI=;
        b=V0DucoeIBArat9eLYMz2FmL4vBIcNdlVpt4Gv051pxrg3ZTbDhh1QVHzsWbs61WDtc
         lwQz8OhU9T/I//braN/LSOop9uT2Em8476YWrLEc1r41RjIgots6swGq7DpLE+S6xJUQ
         W0OnOwNV0f81DWyVEYN1BAMUubfcCSY7K9l2CKon1xvjMfkCHbPheWQVP06KlAlamamh
         EEu8PhNkZ+1EE/ayZ55FAMWayoRxmlARuItVSeULQgYjQdLTrflTx2N7eQXHqYzoe191
         VfQLIbsc94tA6FQprqf6TmxhNCbIII2gOqk1u+P791hzQpIKkxvy2L3+Z8GC3pAscMBP
         huEw==
X-Gm-Message-State: AHQUAuYgnLGL3UK4+R4BSOKttyyKf8hpViGnMHwQpNdL+c9ENvyv5lqw
        eML4JR2eQsBtEVobeHaafIpdIGMLzhg=
X-Google-Smtp-Source: AHgI3IaI6mkbPoJvJA3AlNOumOiRhGe6gSEZ7K6adDp2flCM6KUPlhXXwQu/XGEpnZpUAPo6n9Rlxw==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr15211704wru.67.1551133203166;
        Mon, 25 Feb 2019 14:20:03 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.20.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:20:02 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 08/21] media: vicodec: bugfix - call v4l2_m2m_buf_copy_metadata also if decoding fails
Date:   Mon, 25 Feb 2019 14:19:32 -0800
Message-Id: <20190225221933.121653-9-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
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

