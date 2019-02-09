Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013A2C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1ACA218D2
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OcnZIa6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfBINyn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:54:43 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55321 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfBINym (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 08:54:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id r17so8446527wmh.5
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 05:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7bC/P9l8kovwO03XgdMHc6Ed9Tt0+DuapeIPpqcOpJU=;
        b=OcnZIa6PVYvRZGmnd3aJ1m/BrXKcJSBII422cfduBVxEnWkySDVZqdBXH7YIcj+Xl1
         Eo0x7VZAFbJG+e3vvvahX5qJ2Os7KRRU6ZpUVCBg6mQrxJMIJYVzqGWPChMNK7NrRDtI
         nU5WJk0GpAzmhvcbZIfIHgublz0vdTqITcwTXZO/TRDVSSBeNtzMfgvxkXi65grueKsb
         kqEWsn1HfTsTtxE9AuPUkh2xSXunG8VOJ8sCZutFQoE6sdK+NRT8ZuY2tj7/VVIHK/nH
         /TBZNImW/TMvxMSMaGmQI2LUpO1TG9pcnc1A2NAUYwqF3or6uTeTYdNi3q06xIPb+yz0
         W1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7bC/P9l8kovwO03XgdMHc6Ed9Tt0+DuapeIPpqcOpJU=;
        b=ggfVZlNQhsPcQwbNVFoz2M5viuLD+InfjDU58LWEl5C0jDU8PXg/ACMe+d1fF31bNQ
         2R7FA7e73wDbjifLsFBgKvyyU0F3RNtYhedkouy8OtLVXn99HUb5HCV1MPxfBZFosSVV
         3NP9C5KIQtudEC6ZPF3crsIvxL7OzyFjJoo2HxraeHzr6J+8giLUsBr5Trlmhl/ZiGwb
         mHBuA2hs6xYA24ihor9fGzlqlr/rVcYs/4G8vGbpITi4i9uEgQsujTQouJyaP8ztkc8U
         6AKQFXGp8vVZFCDIMts5k2Q0e3EuiFN50aK1reEBxGBOrBxGAJXVrtv4mT6xrJSHQC+g
         4mgA==
X-Gm-Message-State: AHQUAuZ0LFsbJOlIqYvnx/oq2tE2vPF9mLbkxXbpkd+ig5a+Brvi1wFF
        YOAkO853sCu+kCnw9ui7lnYRYqp7zGc=
X-Google-Smtp-Source: AHgI3IYTds6lHhD60xvP/kh1wnvyFis76mGCjG6OVo9HRxyQzq7SkppU/gAl1Y4X5g4+ZFnMsm3S9w==
X-Received: by 2002:adf:e342:: with SMTP id n2mr19990037wrj.60.1549720480427;
        Sat, 09 Feb 2019 05:54:40 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id a15sm2864081wrx.58.2019.02.09.05.54.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:54:39 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 2/9] media: vicodec: add field 'buf' to fwht_raw_frame
Date:   Sat,  9 Feb 2019 05:54:20 -0800
Message-Id: <20190209135427.20630-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209135427.20630-1-dafna3@gmail.com>
References: <20190209135427.20630-1-dafna3@gmail.com>
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
index 60d71d9dacb3..8a4f07d466cb 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -123,6 +123,7 @@ struct fwht_raw_frame {
 	unsigned int luma_alpha_step;
 	unsigned int chroma_step;
 	unsigned int components_num;
+	u8 *buf;
 	u8 *luma, *cb, *cr, *alpha;
 };
 
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 9d739ea5542d..8d38bc1ef079 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1364,7 +1364,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->stride = q_data->coded_width *
 				info->bytesperline_mult;
 
-	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.luma = state->ref_frame.buf;
 	ctx->comp_max_size = total_planes_size;
 	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 
@@ -1413,7 +1414,9 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
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

