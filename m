Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56C0C43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 06:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A56FF207E0
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 06:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="DzuXXNOv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfCIGz0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 01:55:26 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:43442 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfCIGz0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 01:55:26 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id CB1B2C33
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 06:55:24 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qi29L0QaQfGk for <linux-media@vger.kernel.org>;
        Sat,  9 Mar 2019 00:55:24 -0600 (CST)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 98E8CC2C
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 00:55:24 -0600 (CST)
Received: by mail-it1-f200.google.com with SMTP id x9so13753617ite.1
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 22:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=aAv+hI3CTtwulK+l6wXTIO0OnOf4JZJ3xxrlW8iLX+I=;
        b=DzuXXNOvH4UJyDPnXJbiDRg6j4+qjVDgDEfeb0xGF7u6MWdGtJo1WH9jRZaWTbDC/b
         HEj2J4jiOFD+sOIforVG9A6ycz/ZwCTuXFKL+V/397KhokAxJU0CCbKOzTerNFqlkOAf
         EyU+wdkJmkz/0rYcw3u0ma3Dp6yYNA2fb1h4xd009md2T8rBrLxCD5swuOZyjsEhcRMT
         kRF3cxe7A3KEGshdau/Ik8VhKSgLYQcXcnIOrI1HYyhi4QXjNfr24k2L8LGOmITOFXRW
         3Kuw8ZquhOdBxLS9rKAbVkh2wJ1N+BkDev2RhO6BdS5+84oHweh64Qv0C75T35u4Ll/m
         Esyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aAv+hI3CTtwulK+l6wXTIO0OnOf4JZJ3xxrlW8iLX+I=;
        b=XxmmdDtA2DX46RxagCewKXVqib8rt07LyT7f/y3qlFyzNZtNBf6Yp5igEdlbmdvS0r
         zFmrIYNnpGoXPxPZMBpGavOipqyZW/BIuanzM3lwyZcwINoSCIkOojZIJCWhQujcuo7U
         2zAIOfsc9LYS1NWc9AIIxwLO9LaGrYbi+60urd36TKA737pGmFofaEngGIjpdrI9wb5j
         /SjkrB4MhPDlQcOPN6qf8KwkqmAc4ZhhsIoaIm+1xJYOoEi7keVlZOcBzKhMkwNPvf7K
         uFCNaKOIVLBAEMfHWrD+SF9an0IEzPp48GLQoLZmS3ymj5wPA6DWsypFjrKh90chwBQm
         OacA==
X-Gm-Message-State: APjAAAVy1TUVAchgzOlIzgjgdoY8HFrh7FETR9pCLAH1gzBN0rXBMz8x
        DGDh24wRkDviu1XrfeWwuZHDERBZxJ2w7jGmFd8HdRs03skfCxj+RDPcOQUAr1cm6s5+8ircURm
        rSMn/U0VcnJUrQX9X4e4zRlkZdgY=
X-Received: by 2002:a02:3d1:: with SMTP id e78mr13326087jae.6.1552114524215;
        Fri, 08 Mar 2019 22:55:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqx4sPNIv/wGS0rsOmIFUtf54Jgf7GQ2s94v3Aj+xYr//4P6b3hH1Vr6TF4Rzn5kfw5si9TPbw==
X-Received: by 2002:a02:3d1:: with SMTP id e78mr13326075jae.6.1552114523946;
        Fri, 08 Mar 2019 22:55:23 -0800 (PST)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id 127sm5058724itl.25.2019.03.08.22.55.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 22:55:23 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: vpss: fix a potential NULL pointer dereference
Date:   Sat,  9 Mar 2019 00:53:51 -0600
Message-Id: <20190309065351.1184-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case ioremap fails, the fix returns -ENOMEM to avoid NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/davinci/vpss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 19cf6853411e..f7beed2de9cb 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -518,6 +518,9 @@ static int __init vpss_init(void)
 		return -EBUSY;
 
 	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+	if (unlikely(!oper_cfg.vpss_regs_base2))
+		return -ENOMEM;
+
 	writel(VPSS_CLK_CTRL_VENCCLKEN |
 		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
 
-- 
2.17.1

