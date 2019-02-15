Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5F5C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4375921A80
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gany/PNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfBONGd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:06:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45088 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfBONGd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:06:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id w17so10238046wrn.12
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 05:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rJdQVJLZIdSyqNEEd1x5Ny5bSOsQu+PKSeW1MMGhEbs=;
        b=Gany/PNr0lr4mHkAf5d2GoC1sxzfmyBUCieGKgWQpVaEB6b172k68P+2HkSAr63xPH
         u6IEseMfqDGMvZadhR1pQnaggVW7shsCfVsOa4Fe/JQgmQtTD2CdVeYe/fkSAui6x93V
         U6cmzNateLCg1jzuYptmXxiIZow2Lzhullf1fTzuAZ9QqV+dyGZ50eJ/JGLBSFiIrql+
         XHkSCBxRoRDuq+bllVs90ofcYQSiVTY4wM25gW4SeCOPd6y+k7BEmNkMbyf+gUaOzXpd
         sRagBVne6RYWXIl9IT/mCIZN8bEBiHNcuwy4YBAMm+zpyfGiKQzxlWsEjjSBgYIhcB0b
         DnWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rJdQVJLZIdSyqNEEd1x5Ny5bSOsQu+PKSeW1MMGhEbs=;
        b=FPVohTgcid4PeIvYHiCe76eHYE1aJ1DP7ZE1G3Y59ShEMyEo6CWGfjY0MvMXUVzdov
         GpiD89WD7geJTQKqcLzck5QTzN3OjWsIk69/gnqJ/UcEaBlUG6g9l30nkbP6pfAIBmHp
         j7vEVLZrBsUM3h3ai+WgnR/LcFMhQx4bJMcJQso8zmToDL4qP9sBC15fxNJFIYpzpDST
         OV7PWL4GAJSuzU1afw+SK8GqLhULk7GKMKulc8PMOU1SgMc1eNZ8WKRb2FtZWJeNZ7HV
         5IlYlUld6hBP7SBBfZlckX+tC7nDeq+Ax6xFHMTatRXUDeYKZ1dQ1IYc3ez+1EetGMa9
         lB+w==
X-Gm-Message-State: AHQUAubo1kgphiqtZJpN4HWWQp8GKgsHRTxROIALtkfqvO9q+QQIAtxf
        LaKpK00UBOOQvsP7Ny3faVsS7DLNXRM=
X-Google-Smtp-Source: AHgI3IYUiCVWva8glBpO2RcoUI4gBz1vR7kL7J4jzqScAEXVfkao3b5dZva2FrQv4qhqZK2kWsxwJQ==
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr7019472wrr.218.1550235991050;
        Fri, 15 Feb 2019 05:06:31 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id n6sm2091065wrt.23.2019.02.15.05.06.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 05:06:30 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 08/10] media: vicodec: call v4l2_m2m_buf_copy_metadata also upon error
Date:   Fri, 15 Feb 2019 05:05:08 -0800
Message-Id: <20190215130509.86290-9-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190215130509.86290-1-dafna3@gmail.com>
References: <20190215130509.86290-1-dafna3@gmail.com>
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
index e4139f6b0348..031aaf83839c 100644
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

