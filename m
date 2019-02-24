Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39052C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04ED42083E
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qYjXq6yG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfBXJC6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:02:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55893 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfBXJC5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:02:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id q187so5418218wme.5
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FLIG733TZqwXyiRK3tlwd36KZmO4DfF0bZjlWoxcUHc=;
        b=qYjXq6yG78rFJX27aD7WDBeg7/mo41ayxxZ1qiys7m8g4E7P6/4GPstgwOsupg2jCO
         XkoIm3Jw2y4s3AE4hI/uYu5IB/9Z8iD+/r+6CGZUiWB65fc1LAe6B+YcyAaQ84aEK0nX
         CuNx3amsPVRH+TnY9udVEJstKt7EzN3Gfy86H5NVX6QwUwDoJkhoKWOx8V+E1C5UnDdy
         00f3JF2Ynm0Y4tbbMyg30TMqmht28sjCfXPVuaQ+SUPQyC9VFbndmje5e+KSKegXQGSO
         4qERcLQAcuLvqpBzoFVfwPWj2ax+t0QKxVGdqrjXGRlkYfwBYpmNC9cZJhUbH4ClFUL3
         DZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FLIG733TZqwXyiRK3tlwd36KZmO4DfF0bZjlWoxcUHc=;
        b=YsAtZACkPJf3OiRSMsMqrwxo80IdCVLcIdRf41jWZS+laKcQQwAlrIGhe3YltVeAZ6
         xRqLqzdmhK7bN3qmSz4HyiIOfrmHR4Dj3P7SpMq7Hu5aroh62wM3JPA4BFBwedHl76W3
         Rf1eeD8KTweU+qLHDxDQgkFlyIMIiU6wPddlXccNT8QN43ju6UcIwuUoybDsYtai8tVa
         1Kk8Xs5WWMxN9XG4dsRVV8eY9W0OyWHZbUEPOrk60Pbdsh9b5mL7CabgE8LqHVvaBiSJ
         tEZQpVieTFXLgAa94fbuZgkfeg/35NHCOzqiYUzfmrm39EshbacXg8r9fI/FE0Y8cIt1
         tBCg==
X-Gm-Message-State: AHQUAuaEbHpJdDJ09l3c6w4Egcs15ssAPQegJjWua7Q1sDr8nsY8KicQ
        jj0pztdbJlXbPAgY6magQsi/da45LgE=
X-Google-Smtp-Source: AHgI3IZ+Pfjq247qtxiw3wlvsiMzyrV6IrnxsbxEUEitoaDKodRUWY7uD8dbiiq/xFxGTbiqZaAaOA==
X-Received: by 2002:a1c:80c4:: with SMTP id b187mr6851942wmd.23.1550998975264;
        Sun, 24 Feb 2019 01:02:55 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:02:54 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 04/18] media: vicodec: selection api should only check signal buffer types
Date:   Sun, 24 Feb 2019 01:02:21 -0800
Message-Id: <20190224090234.19723-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The selection api should check only signal buffer types
because multiplanar types are converted to
signal in drivers/media/v4l2-core/v4l2-ioctl.c

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

