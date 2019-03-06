Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5056EC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 208AF206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qLPH1NNg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfCFVOK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:10 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44953 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfCFVOK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:10 -0500
Received: by mail-wr1-f65.google.com with SMTP id w2so15023361wrt.11
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zKajMQ8qbbs/vF9eB7W61cC95ASl/yiwMSYyCZNuyJA=;
        b=qLPH1NNg3uwZUIBj34+3kITypY3HCfa1jKGmM4jM4b3QnBmXGcW0kHjP9YJbueP8ba
         qxXefdfBvthrktukoZ3PxJ21kCseEy2e/4rMnmrS2YnLFIJXrRn1sacj9Y0lHDMhojqA
         xv+xwCCkSXVRTInH8zcWw6N929LCgmojujNaJ6cA2K6eW8Jwt8Nn8SXT5eENtK8FTXx8
         /rcCJSTIOwygLSCbPk37d1ymwMgjgvQ6Hv4C4FMPUvL9T9lq8Xzfz4Gk3qTvSmBDwjK2
         EHGeI6dt/myITakvZFJt3iOEl+XVBH/DrDHl3lJcQ6ZYc4Np4hMdMORuXBGgc5AY+XXC
         8WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zKajMQ8qbbs/vF9eB7W61cC95ASl/yiwMSYyCZNuyJA=;
        b=FN4NXydI5lxCGvuivGru4sXzaDbUVacwVXqPI//y+d96A0KuTx7GFFLBeAQkjHL9Hi
         f4MkKf6HvE519WzvuGs17181wQA5Hs5h1zg8QVRnFZsEsgIaAyfPaw1/X0cMPqMaT/F8
         yz6u77AuTFUuCO88n3i3v55K9kvzRTpImLSON5eJ+89FkqMSb1a1NjBIXOD1e4hGbHPA
         MDDFpjHdOkg7S7BVth3TpVhBnbmkW2ZWKSINjpolKmYgXCrs3Bm002MAw9DVG4PMJ6fi
         HW3YL0Ctwd83Je7g0mEQOUFtBGDsYbbl+eE/pzFb6MNwAR8ULYb3zd5Vfs1vU5SpsG/5
         uShg==
X-Gm-Message-State: APjAAAXN9VgXbf6CQ7JDjSitVRNC6XyTakuxHtjVzKBzOSSj5gkvn9xR
        0fVjY9FG/zrhqDOLbkTn05B9rmlenPo=
X-Google-Smtp-Source: APXvYqwmYXGx2IZD04tOYnMlJAOpcoTKHUOJchzUbqB9hatVpBp6FevBFmHRLQSm964cjGn58HSDpA==
X-Received: by 2002:a5d:500e:: with SMTP id e14mr4220711wrt.219.1551906847807;
        Wed, 06 Mar 2019 13:14:07 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:06 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 04/23] media: vicodec: selection api should only check single buffer types
Date:   Wed,  6 Mar 2019 13:13:24 -0800
Message-Id: <20190306211343.15302-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The selection api should check only single buffer types
because multiplanar types are converted to
single in drivers/media/v4l2-core/v4l2-ioctl.c

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 20 +++----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index d7636fe9e174..b92a91e06e18 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -945,16 +945,6 @@ static int vidioc_g_selection(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 	struct vicodec_q_data *q_data;
-	enum v4l2_buf_type valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	enum v4l2_buf_type valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-
-	if (multiplanar) {
-		valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-		valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	}
-
-	if (s->type != valid_cap_type && s->type != valid_out_type)
-		return -EINVAL;
 
 	q_data = get_q_data(ctx, s->type);
 	if (!q_data)
@@ -963,8 +953,8 @@ static int vidioc_g_selection(struct file *file, void *priv,
 	 * encoder supports only cropping on the OUTPUT buffer
 	 * decoder supports only composing on the CAPTURE buffer
 	 */
-	if ((ctx->is_enc && s->type == valid_out_type) ||
-	    (!ctx->is_enc && s->type == valid_cap_type)) {
+	if ((ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
+	    (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
 		switch (s->target) {
 		case V4L2_SEL_TGT_COMPOSE:
 		case V4L2_SEL_TGT_CROP:
@@ -992,12 +982,8 @@ static int vidioc_s_selection(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 	struct vicodec_q_data *q_data;
-	enum v4l2_buf_type out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-
-	if (multiplanar)
-		out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 
-	if (s->type != out_type)
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 
 	q_data = get_q_data(ctx, s->type);
-- 
2.17.1

