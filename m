Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907C1C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5562620811
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhPcR6x0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5562620811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbeLKJsp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:48:45 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41744 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbeLKJsp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:48:45 -0500
Received: by mail-ed1-f67.google.com with SMTP id z28so11954966edi.8;
        Tue, 11 Dec 2018 01:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDh8YmffptclNLXBI9AeLNp5Bo4FT0o+LufL4ayBbfc=;
        b=nhPcR6x02O2qdP2aHOzw6hAjSMILfIe46PhJP194GTAQoxYm9cphcp8HFLyo5MlfPR
         3pfCagcP2BKRYzGAZhlZC15i4b3Bv9RoQFc5GiE8NOyJ1KQhddIHK2puoh0dw8tvsemQ
         YsDLAE15AsyZCUfmcFeFbzwwxD5l/dCedoYNHb/THmp9gmdpEzXSYc5CmUIkdgNeilkt
         c83TJb/1K8cNIDMUud3JfW90/uOF3hbdwarVD6KArFJBKdKrw2UUtiB04EMOWXW6ApH6
         tdavcgPa49pfrtpVarGyznNMnUTFIbtedPycYLzlp+T734ZrTaCtcgxeM97BM/vSQMqf
         98QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FDh8YmffptclNLXBI9AeLNp5Bo4FT0o+LufL4ayBbfc=;
        b=Y9ydb+Gup6Sja4DuL4wog1XMgAnoMJumSfJgbzyCf5LAFst6QeaLd2JvSz4dGyXKeI
         BelDaD2g5GCanxQT6OnHkhQAIh0SXXhyK1UCHT3A8xdLL05GM5YIoHoR+TfNPP3QhPlF
         erPkr0atyJ3kifQYm6xR9u4Z9TGE58c5bT5KRprb1TX+DwitYhtyGQjGSJShJiML2W32
         9XWLj7VS6trEBb6m86aEg5V2evqJ5LkXWqqp4WIrDDc/kH1bxDmslYx6dITuFA80QgbD
         0u3u2e/4LrOgPJ9gfb9kww3NJlPY6BzcY9af5zKIeo1K0jSnb2EmetMtVNE8gpwhl3w3
         5hLA==
X-Gm-Message-State: AA+aEWYWDOkhv5l0KOPcHFhpyx35boUCfPM49X2mqDYRuJGBZotDZnCh
        VgXZDdTqBZzJmgRkEO6sgdKLYFIg
X-Google-Smtp-Source: AFSGD/VnrvQsvmTE8tgihMwPAt4bz8YxYCQqehWxN2iKjjCJRppm2vimwtHbwomFtpOacw553Qd/rg==
X-Received: by 2002:a50:ae8f:: with SMTP id e15mr14755169edd.250.1544521723160;
        Tue, 11 Dec 2018 01:48:43 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id r7-v6sm2096883ejs.36.2018.12.11.01.48.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 01:48:42 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v2 1/3] dt-bindings: media: tegra-cec: Document Tegra186 and Tegra194
Date:   Tue, 11 Dec 2018 10:48:39 +0100
Message-Id: <20181211094841.16027-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The Tegra186 and Tegra194 contain a CEC controller that is identical to
that found in earlier generations. Document the compatible strings for
these newer chips.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- new patch adding missing compatible strings

 Documentation/devicetree/bindings/media/tegra-cec.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/tegra-cec.txt b/Documentation/devicetree/bindings/media/tegra-cec.txt
index c503f06f3b84..da3590f0b7a1 100644
--- a/Documentation/devicetree/bindings/media/tegra-cec.txt
+++ b/Documentation/devicetree/bindings/media/tegra-cec.txt
@@ -8,6 +8,8 @@ Required properties:
 	"nvidia,tegra114-cec"
 	"nvidia,tegra124-cec"
 	"nvidia,tegra210-cec"
+	"nvidia,tegra186-cec"
+	"nvidia,tegra194-cec"
   - reg : Physical base address of the IP registers and length of memory
 	  mapped region.
   - interrupts : HDMI CEC interrupt number to the CPU.
-- 
2.19.1

