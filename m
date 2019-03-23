Return-Path: <SRS0=n2cC=R2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58826C43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 02:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CDFF2147A
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 02:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Ty0nLjfR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfCWCvO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 22:51:14 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:39854 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbfCWCvO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 22:51:14 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id DD1CBE10
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2019 02:51:12 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Svt52m7rCCpS for <linux-media@vger.kernel.org>;
        Fri, 22 Mar 2019 21:51:12 -0500 (CDT)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id B5D82E0D
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 21:51:12 -0500 (CDT)
Received: by mail-io1-f72.google.com with SMTP id e72so3310493iof.7
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 19:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Qh7dmP8OZe6fXOK5lM+GtdS0NVXFbN1ThxpLg0QIvCU=;
        b=Ty0nLjfRJ5w5mlY+Hs30RILsohSozZRZDBAhEEh3YZbE7R4FFEnC7RQ6nvcopCEP3+
         5Zl5LsGcfL0bgWxYuOwGs6lM9KmZ45dNcYwXCELwDP6WcE+5IErBuMyPvDyrm/tuqaqh
         g/McNeOCPMXYMGqaNyS+2IsHse6EqAz0X8jZ+to2QopKkJOESWVCH4X5EKxjxxE9PixB
         2AVvTv1OlRnfQm0TkvhWIU11fVDVJwOnNxgOGFcavjd1F/1yrytlH9hrVuwC1T5JzPnS
         a/WxeREjRbdyNc60Dw9GgvD+xq+E3iJvVpM/0IBv4SCS8MjRQEyLWTaarq2lzzDbfnNd
         LAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Qh7dmP8OZe6fXOK5lM+GtdS0NVXFbN1ThxpLg0QIvCU=;
        b=Wc/0IbT9s6oaxjDLP1wGL4eCN5sMkliG01fHd7rFs0dGpTUkNJj481M1sPB4Qtu+XT
         2kqN3G8MsqNVe4JF20bUyK820iDouC2Dz1GqJIBZOEECPLm9HwPGhD1rzTN6SHztpHJC
         JRg0Jximnzyhc2gZGY7MivnCd+fcUDUifBFL8qZvFqtiedPBw8gCyIuOVA0xtHszO4wJ
         Z0xnmJ+zqwAGW3PjqXt7ToIrN73cxH7DKEzBjoyQaM7TIujGpvqdajXDt1kU/ouatEzL
         UNLZv5OSiFXDy5K50qnmWUuO8zJuZZkCggt+BFAjarU27K6WhqnQbNx0J+d8b1g52Uk2
         f3Cw==
X-Gm-Message-State: APjAAAUna7Cs82v0bhyfZruWRfegrkkYTW4pwF1x3ppOCIa/45/7lPu6
        scLwnRlxXz3gF5CkCgqavz2mXk8pFe+fwUkcXSo1GRrWNZb5YxJgpEo5z/yBIWt8M37ztn/qugw
        YZDYMvzEdduoeEgaTWX1ifos+dGI=
X-Received: by 2002:a24:164d:: with SMTP id a74mr3523135ita.84.1553309472351;
        Fri, 22 Mar 2019 19:51:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzc/EYQ0baGyH0yicCkhgVkDiPnfeqMWqmRSPW64NAdblPHYhRTDvPAgAGZaXan/XbNVtdXHw==
X-Received: by 2002:a24:164d:: with SMTP id a74mr3523128ita.84.1553309472175;
        Fri, 22 Mar 2019 19:51:12 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id m69sm2324103itm.22.2019.03.22.19.51.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 19:51:11 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: vpss: fix a potential NULL pointer dereference
Date:   Fri, 22 Mar 2019 21:51:06 -0500
Message-Id: <20190323025106.15865-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case ioremap fails, the fix returns -ENOMEM to avoid NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/davinci/vpss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 19cf6853411e..89a86c19579b 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -518,6 +518,11 @@ static int __init vpss_init(void)
 		return -EBUSY;
 
 	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+	if (unlikely(!oper_cfg.vpss_regs_base2)) {
+		release_mem_region(VPSS_CLK_CTRL, 4);
+		return -ENOMEM;
+	}
+
 	writel(VPSS_CLK_CTRL_VENCCLKEN |
 		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
 
-- 
2.17.1

