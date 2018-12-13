Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20774C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D844F20870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CdQFtxnl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D844F20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbeLMPjS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:18 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44206 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbeLMPjS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:18 -0500
Received: by mail-lf1-f67.google.com with SMTP id z13so1874073lfe.11
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9IIyQI0wUmhvhuuFybJykMM+fU6XPVoIyyGawZL0NBI=;
        b=CdQFtxnlMM/IgDO9iHT7dQx5Xxekt1d3OcbEDyzN57EN11hajzCffmZ+b5HRR0y9pl
         bef1/qPoMFJCRZNS3M9cTSV2qSHu5I3uwgiYPQNigP38FTigQrOMaWNHnFmMT+pJoS2u
         s0n/pB+1Yz+5XwjaaEQ9QlShGm2iUiLJPds7DSX/EvDXBPrk1QY8VtbyJBvke2Kwe23Z
         k1tG60dq8yFeQG+lSD8zdlCbE+tYJQz/OSCl8FUdUAwyCdj/Q0oabFvibEAEOJA1xXUJ
         TmfKLlu+PTThxURYYNCjnngz61mnWsLSw/GYxU5SEpNLvnEEQ9saxy0BxiM1sfvkxmh2
         qSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9IIyQI0wUmhvhuuFybJykMM+fU6XPVoIyyGawZL0NBI=;
        b=GnM/RvRlr368YSC6SIUE92Jxh5djsOx0fb7DyWkK3edyf+xzgTHZNZ9dCJAYTWOjzd
         kNQF5LdbJgCShYCViwzf+g3KV8fjTX1Ix4mYa6EkZ+42FCJxjDFgrBW0RviVTahQK3ma
         WAo+0KFd15PxieMsinlds1Nfueogqk/k+L9XdE0RHcM1xDSqbsa+/+fcR3XbxaUTaU67
         7R77dwnVRiI5buJZC1f3uI6KYVzGu3dQ7HDBv9MkwbOy7HxDd/OjDi3kR/YcziTlV3Dn
         SKjso9y9O8FoN8A9bLGb8MuvVhyhHStS1Y2a+gQRuPumHsDNUzT0AEgK8Xj8bxDalYKb
         VIgw==
X-Gm-Message-State: AA+aEWZghoVv9z33sSbJQqfG4ikaHxFTJXrdy5s3m7vmW4yqdXryd5/H
        Apd7zBTNC3MCOfEuGSdfuEwC81yv
X-Google-Smtp-Source: AFSGD/WfT8TETuGuCY23pvCSdtLWgIR3qSfNsXa2j5QAhQzR7rjSYHfjXsocSITLVQdHYk831mUlaQ==
X-Received: by 2002:a19:ced3:: with SMTP id e202mr14393029lfg.13.1544715555820;
        Thu, 13 Dec 2018 07:39:15 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.39.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:39:14 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 7/8] media: i2c: ov9640: make array of supported formats constant
Date:   Thu, 13 Dec 2018 16:39:18 +0100
Message-Id: <c3601ca413fa7c015de0021312ee70d1f537c735.1544713575.git.petrcvekcz@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <cover.1544713575.git.petrcvekcz@gmail.com>
References: <cover.1544713575.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

An array which defines sensor's supported formats is not written anywhere,
so it can be constant.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index 2839aa3b4fb4..9739fa8d433a 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -161,7 +161,7 @@ static const struct ov9640_reg ov9640_regs_rgb[] = {
 	{ OV9640_MTXS,	0x65 },
 };
 
-static u32 ov9640_codes[] = {
+static const u32 ov9640_codes[] = {
 	MEDIA_BUS_FMT_UYVY8_2X8,
 	MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
 	MEDIA_BUS_FMT_RGB565_2X8_LE,
-- 
2.20.0

