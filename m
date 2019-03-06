Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E38C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B013720684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cmJm2VzE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfCFVOX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34964 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfCFVOW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id t18so15050020wrx.2
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZvTkVhC004g66pVAoaWQCbnS0Q4Lnh5O0JAznaE+x18=;
        b=cmJm2VzENLyc0MXX6JTxtXHCWnWbWSCuA7epodV779ketgHZrdhL6/oh/Hk2LuQzDG
         CSXXFNV4uRn4J0hKzOHas/CbgsDGTYJE0rZ0ROh9gtE+3LPPof720/oIZEaINQSJTuUb
         RQnz6M394ZePa5coNhnYQPhbygbD4qg7a+py1wvyu/4MgHG0lNbFqJWlEPmQgPr5+xHY
         rwoOuXKv2oexugWL+GcA99hl3j21Q2DTYHetQpc5pi26kyligZ7kZRLowu6BaIiiGIIL
         XqmMnb8q9xkBYpH91uyHh9vS0UXNEQRu8BvFP+GXxk7Cp7hqwl7e+FjkbdZYXspexsxd
         SNBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZvTkVhC004g66pVAoaWQCbnS0Q4Lnh5O0JAznaE+x18=;
        b=g67HH3VK/929YwPCheBKDsYr3dBOAsmE1tWFnknp9TBmIcTjxk1WcjEoBEX0mFtN9p
         aOIGimBsx0W3N+XMfbKJoogbagmYy1/sm1bI1pVqOy51csnY/MnsyyoBgKVv9q1keTTH
         BPgURAUlYVYOMtjyzDqJt8/vbiDuK/DSeMQGQf0BoEAZYR0TCHtOIjV/oY4nVNcCYwDq
         ytbMwV1imoEIZ2faZT6EHpKy1lChC60X8kbbg4sY8NxpQM868T74vOwhX4WaKYRBfN6R
         QPP1gSbWtCh1LXS9a+urifmWoq2ZHHYMGigY0zu9JXifwOSYlUS8Ox1M6G12NmHhYW0t
         K2xA==
X-Gm-Message-State: APjAAAVVp7VlxecUJBgEova9qEZJKuey3zRLNKfDGb9PypikVg+QAuX6
        6IVxihpfTGN1PbwUS7D8YJJcCfwJyjQ=
X-Google-Smtp-Source: APXvYqz8SergtpxT0essJ9Sytk/8OSUmKvchSfq+D24I4OL17upe2X/tZl/AA4MbRQBUN98RZS2BRg==
X-Received: by 2002:adf:a10b:: with SMTP id o11mr4129751wro.91.1551906860636;
        Wed, 06 Mar 2019 13:14:20 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:20 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 11/23] media: vicodec: add field 'buf' to fwht_raw_frame
Date:   Wed,  6 Mar 2019 13:13:31 -0800
Message-Id: <20190306211343.15302-12-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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

