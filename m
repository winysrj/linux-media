Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452CBC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE58213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rbJts2OP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfBYWUB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:20:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50607 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfBYWUA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:20:00 -0500
Received: by mail-wm1-f67.google.com with SMTP id x7so511898wmj.0
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zKajMQ8qbbs/vF9eB7W61cC95ASl/yiwMSYyCZNuyJA=;
        b=rbJts2OPoO0sRnga0/YQjYxEdoMuWxrXv1FxFlq+xQUCfSdKawpIvYJkTRDALjcFLh
         L/7BVGtqt+UUAfvdPlh0WfHFWyqzwfC2ofCBm2JBbD9GHP6lstmiOaC/vp88iBvijryZ
         v6/ZepKiHHAZ4QrloAgbbQLiH3NhcEonsBozTxkptMAYwhklqNTM2DuXEY6oI27iQw3S
         EMTAqd3z9W9MVLQMoXnq/eZfwbJi9vvblInjEe/eMDXSDa6c0iBvYzDuhQuWgOy1+lHM
         ZwoDMnfUNLvevX4YyvybM8UdkSHAAc/CACQHlvv68OlYVj/4VASrf9ofkWVWVgNG1IEs
         hf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zKajMQ8qbbs/vF9eB7W61cC95ASl/yiwMSYyCZNuyJA=;
        b=Cn6kaeuQUzTaW9ISDnCKjsS0y69v25E5fd8nPngv/CV2Bu7OYZh9h53zv2QLr61Zhi
         wUw83to7k7/ixomBiUiFyKsqFKyO7UCyL/+KFhsz8jlzziROJYx+KyJEZr6x/QVpizF3
         8TedY/UGKwkpGkIIoYRR2LY9eg8gBakXrTiPTNH3+3oQomgWTKC1nx4xZwW18kpi+kwj
         T3M/kJ3YtMqOxQzHAmNRIawfabtVc2J/vsews0vbp7SH1l7VScb9wO70CE3mzMkIhzLL
         Om8CQnftmsFBddXAY9VtVgZnVmKk1bOW1rZAXhrrL0IrXsiNpj7oP2trzCX+41RqM2+X
         30Tw==
X-Gm-Message-State: AHQUAuYfcUO2P3tyWm8XCmFWn0QcM2fgqGFuFcT62gZ0ZRKFZcQDfBkq
        aWkkAzvKw/65JB4BBk3tUDWL+pSnM1c=
X-Google-Smtp-Source: AHgI3IbJyf7bJTlFyihaIzbXEVeOcP8H3PUHYN6cwbvS/kzCB3m6wW6B6aEgpWJhgqI7f3pL1U9SRQ==
X-Received: by 2002:a7b:c34c:: with SMTP id l12mr528356wmj.147.1551133197657;
        Mon, 25 Feb 2019 14:19:57 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.19.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:19:57 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 04/21] media: vicodec: selection api should only check single buffer types
Date:   Mon, 25 Feb 2019 14:19:28 -0800
Message-Id: <20190225221933.121653-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
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

