Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03458C67839
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C02204FD
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nCuM0OT1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3C02204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbeLJQAn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 11:00:43 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37267 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbeLJQAm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 11:00:42 -0500
Received: by mail-ed1-f65.google.com with SMTP id h15so9925453edb.4;
        Mon, 10 Dec 2018 08:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m980YmhP0KQl4VH29WyoK2q33zwGHl+CViSflvEjE2Y=;
        b=nCuM0OT1w7iw7h7gtrw+kGpjdzUnfbbOfkUbqrL0FWYwtWOzw0d9C6GKyHVLVqnXT7
         TOeo5Hc0MdZJuFKpL3db3h/zvVJMyZpWukvqggNAXyksCwmjVWsarXPKg7o3jsLDUv9f
         FdFsOvRfGYfAKmxThkI3SCaSiM7j2MP7UA0uxz9P1z8wKcb2/4H1mv3gQHMQggHvpKSx
         D+AVkndIdl84TYOpoj7FrcUSNbVkclPL/bYIBrRj4m8+6z/Sg7P1vBEdIYyoFZ8gNWT+
         SgwlqiJ0iy0wHfPoYsdihjpMyjcJmbCCGM+ISj4TPqUBsTT52HKcM5i+7UwZ+atPBbRR
         zbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m980YmhP0KQl4VH29WyoK2q33zwGHl+CViSflvEjE2Y=;
        b=o3Rb5s7+TJ2DftgqgCNYtMLScailf7U66B61ut//Wu6OM4ESSJEaRxLDg3x70n/AlM
         Tu61JXonpxnj/tc4c++xNOWKKwfR8QmES4h2YaLBvNGp55GqhtgvcHH3zbyMjD7yOFRJ
         iBObLp0UPq88aWlm93OS5aZtcTA1DaORSN0n2fD7uQso6YQUSXUcc22UGubip4z6A/WN
         2au51cGRYj5LBv9bUxFjjRByl91VdRw+4++dL3l1vAFLmptIJIKVwF0ZLStToRD/oIJl
         1cUcrgibTo1tJIOmDQnPjvUzFaxU5wPv7Zig7EAbVhUINsoDbInpqqC6XMEXV4ljUtJg
         vuEA==
X-Gm-Message-State: AA+aEWaa5x7UporjOIIwHVpQKLyRYmoIHnoZvApTnqc4pn1z7Xh3OqLE
        0FwTx4gJ6ffx0yMno/6VROgTcT8S
X-Google-Smtp-Source: AFSGD/WFJuWC5ygI99k8kg2Gicl/hnoqDlO6xj+5WHX7sq/l16WwT+95v05+GgFjeQleTZRmmeAvJQ==
X-Received: by 2002:a50:8e95:: with SMTP id w21mr11587455edw.198.1544457640783;
        Mon, 10 Dec 2018 08:00:40 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id k11sm3233700edq.51.2018.12.10.08.00.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 08:00:40 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
Date:   Mon, 10 Dec 2018 17:00:37 +0100
Message-Id: <20181210160038.16122-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The CEC controller found on Tegra186 and Tegra194 is the same as on
earlier generations.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/media/platform/tegra-cec/tegra_cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index aba488cd0e64..8a1e10d008d0 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -472,6 +472,8 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra114-cec", },
 	{ .compatible = "nvidia,tegra124-cec", },
 	{ .compatible = "nvidia,tegra210-cec", },
+	{ .compatible = "nvidia,tegra186-cec", },
+	{ .compatible = "nvidia,tegra194-cec", },
 	{},
 };
 
-- 
2.19.1

