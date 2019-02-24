Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59170C00319
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28E9B206B6
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KeYpzxKR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfBXJDG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36389 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbfBXJDF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id o17so6687041wrw.3
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t3Bbel0tDP+Hz8HzwXM9Pd3AeGXzB3E2BZKAp2vpK/Y=;
        b=KeYpzxKRY9/8BZmoIiEBfrQJC/IWuSxjyzs/ca0dkjH3RhQGx6WArt/1Qksitvngkf
         Q2THAPxzUU6DB4zwdK92EKDJQZr5KUhWmTGycs1BCeh22uvHVjzFfqgHkzgksvG0NwQD
         O6ONwDeWPA5VcwyKyiSqHNsqOQAYR/aQzxZOz2nSyQ3zxLMWpxvKt/nMhlTySGGhL7EO
         67+20SDCZzL1eL/zkLgDTV8dvb8XS4JDb7ryBykVEb5eCPK2LStwHbKroQi7dqIBUOZZ
         lena63ZM/kykGCzQ9zsrMngwi4P6xUCQTCO4P4R81VVDQemdOERX+1fkadTmvjCBVd6m
         s8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t3Bbel0tDP+Hz8HzwXM9Pd3AeGXzB3E2BZKAp2vpK/Y=;
        b=uiUbvgeHV3/deLXQiNVF8/ef+11z4InGHOs4CV26cpX7h7k8LRlME2Hq8BueCexZLs
         +gKz6RH3jVuLl6/ej8ZAsMZ/KwyE3a1kt8B7R5l08aGA/u441j179i2Q5x4LCpp0rZqm
         H9/15YJ+6KrSS3QVqG6ApnGLp/sUEzrebFZk7bN/aVZs1jVBanaowjwpl84RcNqnC79K
         tBw4QjjDsgL94uaiDubbrk4xISYwQDqzpfozMeIzY12RW4f+U/1dW/9T1VfUD7/Wbzfq
         iLzWeKgmPShLYNZk1Aac+wMjmcmByKOG9ocffkYFMX2xo+/6T3j+AV5Cc5pbWo0zE63E
         7kQQ==
X-Gm-Message-State: AHQUAuaWyg3wFpafvABQ8Y0sXzfxKvRU1DGrXTdJefKdwUxMaM01bDGz
        IoBuAtWJ75+QKdWs8oTvu7JJpCmaP6A=
X-Google-Smtp-Source: AHgI3IayPR/L900XKHsCXpj/zHPzYsgp+ZJNm7fG5ygSOBaodh6klJROkAZeedt0hrSLIgV7H7VHjw==
X-Received: by 2002:adf:f691:: with SMTP id v17mr9034454wrp.66.1550998983636;
        Sun, 24 Feb 2019 01:03:03 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.03.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:03:03 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 10/18] media: vicodec: add field 'buf' to fwht_raw_frame
Date:   Sun, 24 Feb 2019 01:02:27 -0800
Message-Id: <20190224090234.19723-11-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the field 'buf' to fwht_raw_frame to indicate
the start of the raw frame buffer.
This field will be used to copy the capture buffer
to the reference buffer in the next patch.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h   | 1 +
 drivers/media/platform/vicodec/vicodec-core.c | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index c410512d47c5..8f0b790839f8 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -124,6 +124,7 @@ struct fwht_raw_frame {
 	unsigned int luma_alpha_step;
 	unsigned int chroma_step;
 	unsigned int components_num;
+	u8 *buf;
 	u8 *luma, *cb, *cr, *alpha;
 };
 
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index d1f7b7304364..f6b6464f08ca 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1352,7 +1352,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->stride = q_data->coded_width *
 				info->bytesperline_mult;
 
-	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.luma = state->ref_frame.buf;
 	ctx->comp_max_size = total_planes_size;
 	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 
@@ -1401,7 +1402,9 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
 	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
 	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
-		kvfree(ctx->state.ref_frame.luma);
+		kvfree(ctx->state.ref_frame.buf);
+		ctx->state.ref_frame.buf = NULL;
+		ctx->state.ref_frame.luma = NULL;
 		ctx->comp_max_size = 0;
 		ctx->source_changed = false;
 	}
-- 
2.17.1

