Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1041EC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D051C20C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vNmKXgfg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbfBZRFs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:48 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42773 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfBZRFr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id r5so14776447wrg.9
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZvTkVhC004g66pVAoaWQCbnS0Q4Lnh5O0JAznaE+x18=;
        b=vNmKXgfg+Fp2oWigjCerrodfOdqanmG+y1tFVjJFtZk/erzvLMjQuq5XylupJhA7qe
         T7Gsfw1+Utnk2o76Gr1zFObeH2sxO7FsPP1Lx9qRf5xr2C0Fkux3KsJx2V5hGm4ng4tR
         7X+RsENwmwI1/lk6KmHQDPBGeFLtwFW2Je5RBk98vFdEsJBY9KB+GH3BHfa7XvTBAr1G
         2PGuGJjFOkxG8nKrfmcJmI0bjXhlxIlry4emJP2JcXOfqBPzM0SfUiU4NOClHTs+L+N7
         S85vHldDw9WuYFuoGf/rS1WApnHhVbPjvyRXi2BNjxSYFDmi54eA6yLQVQTVCH66o5+5
         h9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZvTkVhC004g66pVAoaWQCbnS0Q4Lnh5O0JAznaE+x18=;
        b=QceF2itohB/kd3w0KyieZxfAMW//GArCS3qptSclrne1MlgmrGJ4PweRe2hRb5TrmG
         DZr6NZIzKR0uo8pqUo51JJy6hfE4lxeC2yi0muJtkIwC0tX+Jewp5ezkLmb38Qu5JXqV
         3vRwkO0g7LeFNJ+7pS00vdkwz5yyEzUct7FuPSS3Gate69wVTy1qNQlqTUgCOx7shWet
         r+NN3ggpkpPrkqXAB2CvSxe5qkvjwcB8XQ2uZJtO3I5tBwiHsCXM0C5PG3Xo0RsaVCGm
         6L7N3wm6bw6XyQhNVKm/xrqDtvp9BYGCRZcdMKDIxyLVYTsij5QfkM/Kc+MSKXh9Kqho
         2Orw==
X-Gm-Message-State: AHQUAuaGTHLKvd8NBTt9/m7YKkf/Gwzv786XdsikfCSMesMlB9oZXLEZ
        aE+a1utKQrpgrZKri7acNfMGXj1a10Y=
X-Google-Smtp-Source: AHgI3Ia4dYn41XbnfkwsTXU5fRbvtPjidw2ZYnboEVD/CVXanYzObmV1iWInakMChcat/KPGpECP6A==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr18234804wrt.27.1551200745559;
        Tue, 26 Feb 2019 09:05:45 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:44 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 11/21] media: vicodec: add field 'buf' to fwht_raw_frame
Date:   Tue, 26 Feb 2019 09:05:04 -0800
Message-Id: <20190226170514.86127-12-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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
index 8128ea6d1948..42af0e922249 100644
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

