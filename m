Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B100BC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8171A20851
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q5F3dga4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfCGXeL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:34:11 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38462 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfCGXeK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 18:34:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id m2so12514094pgl.5;
        Thu, 07 Mar 2019 15:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sbop/e2Y1jW2dASCMBf3SX8kr8ytrYOuWO0KO4p5Y/M=;
        b=q5F3dga44lMvyyaZjlNhKfwCJGgku+TpGuBkqgL8gfpQRgqiO+Goq06MGRQ5ymzVgi
         OUzaWAbEFK1w1dc67AeQ6XSeNgLpKboACUplYePpEnZ9AQvYTbXwbQsHN+9WVKL568Ai
         e6Mi7XTRMXRCgvNW39KV6n76SG8wxx/8wfgg05QL88wagE9Gb5WHq8NJdtyyFMOF3lJx
         ilMt1BA3MHpixx+7L64tyOzksZtZsgQvBCCk8cYQ28GMA0k4O6RFLBd8J7rQ7JdR0Jy6
         /q0/a3L7sc1GCff2H2ImMGp4FmGUQsPWTVNgoP1FqkJXJQ8PuRGf8oIy3IvPrWrMwEbm
         uH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sbop/e2Y1jW2dASCMBf3SX8kr8ytrYOuWO0KO4p5Y/M=;
        b=KPydGcZWFcQmttcIQZ/Sdqv7Hjzg98VIA3mCpd6Zmz9FSOFSDlgwURNOTJ+b1BSHbk
         Mm8KmK5+HE5nWrYT4RdN929ho1rjndw4fw1GzY/R84gQeh+HuqjXvPtMJJNSwT7bPNvn
         jULI2Z2Be72sBRfOzFHdBvk8BeAIdPZOBGXzASuE0SXvLbhrbclgX9jbJjwRhxlZdRKW
         WyRghWdosKu38gkfwU+bCs1g/SwWbNptRwwHWI7+9y19FA+EQML/6MVooG9e3E5s9FwL
         hhU+JzQripdaJrZwIo+ff8azpK+yYRs6TuZ6BL0z5yiNXfEp35ZBDHtN+ngiUeALyefG
         XP9g==
X-Gm-Message-State: APjAAAX4MtNDZsBvVhEHC285/yXebdulXFM5ohgqZXK6EIqYOEs85CCc
        s6zPXBQGt9V2dlLzV39A9Avsf+gM
X-Google-Smtp-Source: APXvYqwdTlVR+znPVPBmHCV3xMyEjLTCFtPdqEV0jm+NIqi8IqPnyaqXe9lNssIBPd/RrYXyJfq2ZA==
X-Received: by 2002:a17:902:7b90:: with SMTP id w16mr15899508pll.228.1552001649430;
        Thu, 07 Mar 2019 15:34:09 -0800 (PST)
Received: from localhost.localdomain ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id m21sm8684866pfa.14.2019.03.07.15.34.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 15:34:08 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 1/7] gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM
Date:   Thu,  7 Mar 2019 15:33:50 -0800
Message-Id: <20190307233356.23748-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190307233356.23748-1-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
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

