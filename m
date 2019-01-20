Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F180C636A2
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 13:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F13512133F
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 13:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZyVoJeNy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbfATN3X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 08:29:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43694 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbfATN3X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 08:29:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so20223494wrs.10
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 05:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CRKPeEVvwbwPyW8PlCLSf72e4jMeIVWoAQn62FQ1RKs=;
        b=ZyVoJeNyJetrFj9GKm4tEvsErOqAlo7GshkB+vQRUSDqO8NpwiohoIkydfOdbFskd9
         zTgpA8XUH9G3/ezT9O4LRhWp2KrFNGlBsgcfdXzBKhMoGNStrqqEbfI/Op04VNAF8xtK
         9hArNN4T5U+wf51BpY6P0DFldF2s1d5jDneb+AZKSY2wkf/bqKUs6CSZ9qXLrd2PNY1n
         NuLYt5++xakh6VjztJhTsfMS0CatLnnBEC9GcWtCqrMei+5ehH75lIpWiQsvYo6DhhoY
         RILMuF6lcLWAYy/DLAHVhO4v0/qSgHLJoYLpMvV5RTjC38qkjvTzId11SSwrN0RhuYKU
         A3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CRKPeEVvwbwPyW8PlCLSf72e4jMeIVWoAQn62FQ1RKs=;
        b=Y4PWHsRR59Txiv9fxbwI6qbgYQLL/IPlgKVshwCkhEMq0gcdiOhyztRQSjVXblBMFB
         kwBr6IbyLhZGRL5JOPL3pVYZPmezx7wBwu+RbPc4KKpfm69/NKpO1BLsnGehe9kls0mn
         0ef4jBhq2XqxutyXZ7Hy/50cJhCuzLwvOsplycoh6zYTkePvwksaH8Bv8t1tL4VARAdU
         anC6kZDFMAUKv9YSELXja/4MAqpHnYj8on2jdm3uDdfF1S39bzTM1L+2WklKMCe4Z+1Q
         0w//yqU9xNjKv8cdFJtvLPf7ICcRUKGkXQYHwiMFZKqcu25FATgD4FjS1XC9K5NVEHjb
         /apA==
X-Gm-Message-State: AJcUukdPNfpp73/2wlPLiypabiWdQy5hw/gdp/xPCLZDeTkh7eoEOZ9q
        fuk7SJU1fEnFS74u9LZtXWrUYRJVxvU=
X-Google-Smtp-Source: ALg8bN7VeU268WbPGaVoZcl1SXcU91uYgdbMIunZa+7DNOwnzsxRilDu1dsFaTQScQbs1DWOQjztow==
X-Received: by 2002:adf:9d08:: with SMTP id k8mr25492628wre.203.1547990961278;
        Sun, 20 Jan 2019 05:29:21 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id e16sm148601036wrn.72.2019.01.20.05.29.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 05:29:20 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 3/6] media: vicodec: use 3 bits for the number of components
Date:   Sun, 20 Jan 2019 05:29:04 -0800
Message-Id: <20190120132907.30812-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190120132907.30812-1-dafna3@gmail.com>
References: <20190120132907.30812-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use 3 bits for the number of components mask in the fwht
header flags

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 6d230f5e9d60..2984dc772515 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -78,7 +78,7 @@
 #define FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
 
 /* A 4-values flag - the number of components - 1 */
-#define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
+#define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(18, 16)
 #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
 
 /*
-- 
2.17.1

