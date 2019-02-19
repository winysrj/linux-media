Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30305C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED95B2146F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/qrFKQ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfBSJnS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:43:18 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34022 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfBSJnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 04:43:18 -0500
Received: by mail-wm1-f67.google.com with SMTP id y185so1733453wmd.1
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 01:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KKHs/ohtDmdRFMNsxB/FOZHw6LtDqH2mcm8GizaQgpE=;
        b=T/qrFKQ7aO9IEvPtAcRCES6cLi5kajeYI0rC8m8sWZA3dql5+F4Xs1aTImpM1rGxPB
         FHhXrJpvkpG7YoWRsqcmKq6uqSn8Zwo6tOjrUA3WxS8+8QYKPEnveJlAngVbuy8MffOW
         FNy7mRLrqTl6sXwW2j/Hbe7Q56WKxdWoeMvw+Frvv8g4T2gyD4n/3a34wShWqhiT9n1M
         YRWu2q4yvlPMvyUCaoJtmlBYVABYpTED8RSoDPd0zPoQcOj0KP2+1kjWJ5b5rFrWStSn
         93D57SC2W4oSVzf9oLLMWttE5tkdPn2A7eFBuddO7HfftduWkSDWVfyL7XepkApVTSAj
         SQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KKHs/ohtDmdRFMNsxB/FOZHw6LtDqH2mcm8GizaQgpE=;
        b=AQfq5sVo9ri7DlRV+NF5MykluFOcu9THq6XZoUQE59xN0Sza95QNdshOrF/Bn8/70x
         IQHG9UkRF3TJRgf9ng07iv7c8BxmtWKWgjOpqwtV9dvl6tZza5CoVKa+9Vg8N+MyB/6r
         tHZDtvgvnIc8YL3EhDRA0gXTX+25S3Cq1WFfmmF/Kj/+ZOkMrJbk17EuLEHXxa/SvBCC
         P4ik/8CwhTkxyI4l3MQT2VSQ0EFYGeWTu/4ai51XM1TbaXPAFPqYZWZeQEC0MkpxGSvk
         6c+9sAQYL0kdh0KfYYkJ6/CIjS9IgkQJoz+wodyWZ9SZ4Nz7IY8al62ziT7WaDHFISeM
         iJOg==
X-Gm-Message-State: AHQUAubmr8ewlfTJUgYaIejSbumqW8avQIy3BblsGWRS2PTFWuY7pRm+
        oqfdJj4JbMvU0kMhbxEj8T/JPPnzdU4=
X-Google-Smtp-Source: AHgI3IalkIMkQBU3cnJtuPJVEU/C78Iq9Wmlo+sM+f/0artu9wkWDQXyCMLdafrZUlgAa0u7B1CwUA==
X-Received: by 2002:a1c:c182:: with SMTP id r124mr2215917wmf.124.1550569395949;
        Tue, 19 Feb 2019 01:43:15 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e193sm3905752wmg.18.2019.02.19.01.43.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 01:43:15 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH] media: vicodec: selection api should not care about signal/multiplanar
Date:   Tue, 19 Feb 2019 01:43:00 -0800
Message-Id: <20190219094300.7471-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Change the selection api to always accept both signal and
multiplanar buffer types.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 25 +++++++------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index d7636fe9e174..12692aa101fe 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -945,16 +945,12 @@ static int vidioc_g_selection(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 	struct vicodec_q_data *q_data;
-	enum v4l2_buf_type valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	enum v4l2_buf_type valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	v4l2_buf_type sec_type = s->type;
 
-	if (multiplanar) {
-		valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-		valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	}
-
-	if (s->type != valid_cap_type && s->type != valid_out_type)
-		return -EINVAL;
+	if (sec_type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		sec_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	if (sec_type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		sec_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 
 	q_data = get_q_data(ctx, s->type);
 	if (!q_data)
@@ -963,8 +959,8 @@ static int vidioc_g_selection(struct file *file, void *priv,
 	 * encoder supports only cropping on the OUTPUT buffer
 	 * decoder supports only composing on the CAPTURE buffer
 	 */
-	if ((ctx->is_enc && s->type == valid_out_type) ||
-	    (!ctx->is_enc && s->type == valid_cap_type)) {
+	if ((ctx->is_enc && sec_type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
+	    (!ctx->is_enc && sec_type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
 		switch (s->target) {
 		case V4L2_SEL_TGT_COMPOSE:
 		case V4L2_SEL_TGT_CROP:
@@ -992,12 +988,9 @@ static int vidioc_s_selection(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 	struct vicodec_q_data *q_data;
-	enum v4l2_buf_type out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-
-	if (multiplanar)
-		out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 
-	if (s->type != out_type)
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		return -EINVAL;
 
 	q_data = get_q_data(ctx, s->type);
-- 
2.17.1

