Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2FFC00319
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74E98206B6
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZjZzwmFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfBXJC4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:02:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41098 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbfBXJC4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:02:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id n2so6649783wrw.8
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=ZjZzwmFFMpr3W3AWkPcxRI+WycAo10YkkKoj8s4+WQ0Ahpkpn5w4vuDaOJgp2M5Rc0
         vG17QKcM700ZYUJGQRZa+Y5AIBZw/oBlurzXoxEm2AFkU0W0fjTRhDNBtAttIw5HkAdZ
         2lhjZ1EQnHVzMh2OYD8ZwgTg9OANKwOS0czgWRDQ0aQLtt1DaGlxkumESTITVkpkCMAr
         gTNNEvuyQsaYfQmfHV5PLJgOCgHu15x94YyhFyLmir9O1secd4Y3JmLjcd/b54EkhUBg
         vJgTHextEKH0xvpGaBiPKC5yTDMZoHeIG9WNAtpRo64nR1de6gx/Bd+kY2CGEWgdNdc4
         hXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=Kx32PDzUZuDg+cvZbDcyQLQr21DqQvtCqObXGaGWPzmm12KJsxLLhrF6UOqPL6+nec
         M1+znG4fXuaLNksggxa8oN7v7YadH/r7+oifnEnM4mf15UlxvVc4/iE31vTpv1Y5ArsE
         8/UNZUXLh2lDdDOH/5K3wheGe/ZqxsuQstnL7Z8kUWgPRQ2ablFLlMeghJ2xhzAb1J59
         nDgTqnj3ieiST6Zy1HOySb2P1pAxEoqngv3TwSH8AE06Jm+D1sM9XIN33Jw3Kqy3G/4j
         Y5zRXuAz0/+qRmr3u2DRh3tMZNAZd8bB0p3VDqyA2TJdlUdeRNbQGVpApCsUHYLqkamR
         oUPg==
X-Gm-Message-State: AHQUAubcx30aZgu3rWeG3LfGEpOeLr7Zc4FNnKMFioH6ON8hodP3GY43
        WRujYvbB8bSMJ8cTRV6S7cOCUq6FCHc=
X-Google-Smtp-Source: AHgI3IaKFVn1r28a/7g+HKJAQlHCUAMf/38jZNXAELX9ks/7gXHCIHY/O4yP7X5okilZu7MYNWVyJA==
X-Received: by 2002:adf:c543:: with SMTP id s3mr6581361wrf.192.1550998973921;
        Sun, 24 Feb 2019 01:02:53 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:02:53 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v3 03/18] cedrus: set requires_requests
Date:   Sun, 24 Feb 2019 01:02:20 -0800
Message-Id: <20190224090234.19723-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The cedrus stateless decoder requires the use of request, so
indicate this by setting requires_requests to 1.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index b47854b3bce4..9673874ece10 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -536,6 +536,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->lock = &ctx->dev->dev_mutex;
 	src_vq->dev = ctx->dev->dev;
 	src_vq->supports_requests = true;
+	src_vq->requires_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
-- 
2.17.1

