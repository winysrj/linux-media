Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87427C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C6D213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HwsjWL/J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfBYWT6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:19:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43503 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbfBYWT6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:19:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id d17so11674943wre.10
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=HwsjWL/JVyFSgbyaeCIr9kkeoSyrY8cJPJgoO3FYF1qUZFi/fLiIM7CcKcYxwa2SxF
         88CsmKssie9Hg2woDIhOIMmycyM5ulfm5ipd9xXm2hu7FWub01+j5Ay2TUGwsWNirHqo
         LJ4e6HzwJN6K+WMDVz+wyj7+8laOGheElvqPmIiodmMzVUrrDTjIVxwYkVz6zlFkEvEQ
         qyGBXGo8LAzwFBUcvzwbD64DEEMHAHxu7sZZBaXZtIkQTCDM2KM/CZVEQrsWcCOD7Rat
         skVAyesllx9cwPw0+K6McoJ1aBl1/kebW+dXbNJNz5iNPSz7hTmt8KUSQ1H1ltsuyZss
         A79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=RzMW1gPS9QMsWQQaJQKm4jtqic2Hdvs4IXf0mdIOgFSq4CprAArRohgSPb/9dhwgn5
         AaXkl8MHzBJdZ/L6jgo3V5Ws6tBdkabgkBEW3smpd622f3OUet1h9fvU16VUsbaBArMN
         dRcUZibFGiGDVB3GHiduDgilWaPfIneMS2rFep8WYDCdEbotl04GPqz530FokVudZs78
         9NZXhhfAZUZ1SbXWVrY3PYK+N42DSgzvFITXfrbBWlfNbRZqEcSKdkSbUlKJW1Ae6BkV
         q4iLcUqK+o7ZwW/jkjCevfghlUFUxZ9twBbcDNlm+X8hF9iii0R2wF5+0uNiBCbeF7pP
         2hsg==
X-Gm-Message-State: AHQUAuZhKdeSHNKd+8zs3DKc9pfXfzlGMx9Hvjkc8LIYmAgad3fTpZpK
        EEt5rJdQB9pt7oKo7rNckSITFT3KEyk=
X-Google-Smtp-Source: AHgI3IbeZk/VPxJDHLoNx+3g8oipVEMnTj5j5wB5i4/rHYw+7M4wu2QDmXvlunSRySN4u0IjkylQxg==
X-Received: by 2002:a5d:6810:: with SMTP id w16mr13864586wru.62.1551133196295;
        Mon, 25 Feb 2019 14:19:56 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.19.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:19:55 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v4 03/21] cedrus: set requires_requests
Date:   Mon, 25 Feb 2019 14:19:27 -0800
Message-Id: <20190225221933.121653-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
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

