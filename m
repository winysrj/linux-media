Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC122C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 787E420C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YttJkepA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfBZRFg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44138 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbfBZRFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id w2so14767047wrt.11
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zKajMQ8qbbs/vF9eB7W61cC95ASl/yiwMSYyCZNuyJA=;
        b=YttJkepALoskf+R1rx0ptw+C8NUogmAXMbLJ5HRs3b2wX/9UD1233PaOwh1WmYgnw9
         sn7/AfSzwmVB/VQgQHqJ1oTTllGYZ+A590Igym1m/K7CNVlmHO039u3vGWI8AEd3uURl
         96xv4J8eKT/LaZKSI+ei/bqWR83JVcjIHXQoUTMSTyQRe19lHPzz7VgKycEJuHFW5gFC
         04w00g/VS0paYJ0CWON7mQzwQMJMOZQIV0q69BdMzlQ30IRntGclSfYU0F65RPGHsQ0n
         f1039P/MuNl1TvyOEvbDqvf/ZXcus+JfSLrKtFo2RX+QFIB8WSncnkAEyWUw6s1FYfWZ
         398g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zKajMQ8qbbs/vF9eB7W61cC95ASl/yiwMSYyCZNuyJA=;
        b=DSQfG4YKXYRFIzXpyIr2kKa1C1TADAS6YdneO7D+Hl5jR/jtjIhMZBPg8PJ7B/rRe2
         /L5w0c2rG9FS8ZwML/OrrM/2BNH+fdJn6JUJYoIn8OkixV1GpoHCRtH6EMMUoShADtWF
         t9FvtUDz2zN4QzTdgltJToING6ArOR2VNxKKJmJJ5zluSh9kNuliJGa1Pvknn6XB55ez
         GE08KUheHW/Wnep5C16IbnBEOAmwrb51V0QMFzdYk+QBDPFTk84hNM/yw2msMMAVDYPi
         ImSfgaoTET8JWPJGWJCoAbdEemCqgjgGG0dNyzk69FOuSDD8AmI1vgoB6xXL2BAMzvwk
         38+A==
X-Gm-Message-State: AHQUAuZ8DOxhxt/p5zfBeUUrwpR408sgNv7lKypEpB42zrKJWJDsE4eU
        iyEa9iPzJADc6sDJ/KHUVjXvFPiK0AE=
X-Google-Smtp-Source: AHgI3IZGmK1cowJHNHIPzQIQRNmJvFmrTRlMkdvT9x7lAcwxBFOe+JOWnBwCumjqJZERDVrSHVrd+A==
X-Received: by 2002:adf:ecc6:: with SMTP id s6mr17520871wro.144.1551200734663;
        Tue, 26 Feb 2019 09:05:34 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:34 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 04/21] media: vicodec: selection api should only check single buffer types
Date:   Tue, 26 Feb 2019 09:04:57 -0800
Message-Id: <20190226170514.86127-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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

