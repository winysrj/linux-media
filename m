Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28117C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9AEC21738
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awsYZ+lp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbfBTAFf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:05:35 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40909 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfBTAFe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 19:05:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id h1so10981373pfo.7;
        Tue, 19 Feb 2019 16:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sbop/e2Y1jW2dASCMBf3SX8kr8ytrYOuWO0KO4p5Y/M=;
        b=awsYZ+lpu8xpjZ0QqBcaD51aVK7F7YRTRHD1hYTvjjTDaVoo9zNrlXBNTIMQBbk8TG
         blCPC9Aykfl9Rkcs3rLq3xrqS3NpHlEiSOlhaDnfu+arZjwjiHaWwRQfaLSAIZcO7hPA
         RFrdM5EKrIBDZHUBdhDWEI11uvzAEhe3RlC5AH7NM25cTELpjIY8Avidr8T3UhhJNKKD
         bjVvw0/8T0x+bw0ZAFgtEM6PDf1Dp0oBfXQ2SipzYaPrPTvqezmpcPI8zF4NbL8gFcRn
         YdUljtjEhXfb4pobQbST58+0v0nPD+fjY8uHGsRWeOrNEbwilwewYOABDV6pn99dtOIJ
         PSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sbop/e2Y1jW2dASCMBf3SX8kr8ytrYOuWO0KO4p5Y/M=;
        b=JY7D4+MvYqIwRB+XJ5N79qjrQlYnyVycbVSMLIUPZ3LCN0Ox58k1RjrL7erQKW12Er
         BTiu16txxuAmu6Eutx9DgWB3mpgfhufeleqOQ0FL612NVKRb0pcKcyJJPGrBjcS9G3zC
         T6IodASfnGrJGRvLWUO7vrPCvwPs8pC/1hrco8DXcYTKLlXL7xHMonQwoIDLB7qybVyN
         4EnZkdxQElnOK5aJCS2VUKN+uqXGgWbNso22KXR6YC5FXYE+3bC60+oZvTR3btB+aBuq
         XRvBQUYK+GsEKU+fpapSjKmNM954cx8TF6gwI3qSBgnhqxfJWUcUXJa0Pnp8GdYOraqw
         Fv9g==
X-Gm-Message-State: AHQUAub6g8F38eTK1l194nXc+/udJmjDRcTR0lWXaJZu74NZK8pBxxsF
        qTR/9H+4mu1/KoB81vJDXImTopm6
X-Google-Smtp-Source: AHgI3IYXY9TZTFL2nYPclx5+lCtf3/cSq9cseTN9WoRBl4PPyxTm+J5ETyea/r7mqOE616DWZHljDQ==
X-Received: by 2002:a62:1706:: with SMTP id 6mr31503936pfx.28.1550621133399;
        Tue, 19 Feb 2019 16:05:33 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id f14sm19159083pgv.23.2019.02.19.16.05.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 16:05:32 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 1/7] gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM
Date:   Tue, 19 Feb 2019 16:05:15 -0800
Message-Id: <20190220000521.31130-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220000521.31130-1-slongerbeam@gmail.com>
References: <20190220000521.31130-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The saturation bit was being set at bit 9 in the second 32-bit word
of the TPMEM CSC. This isn't correct, the saturation bit is bit 42,
which is bit 10 of the second word.

Fixes: 1aa8ea0d2bd5d ("gpu: ipu-v3: Add Image Converter unit")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/ipu-v3/ipu-ic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 594c3cbc8291..18816ccf600e 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -257,7 +257,7 @@ static int init_csc(struct ipu_ic *ic,
 	writel(param, base++);
 
 	param = ((a[0] & 0x1fe0) >> 5) | (params->scale << 8) |
-		(params->sat << 9);
+		(params->sat << 10);
 	writel(param, base++);
 
 	param = ((a[1] & 0x1f) << 27) | ((c[0][1] & 0x1ff) << 18) |
-- 
2.17.1

