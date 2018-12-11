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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A28CC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2157B20851
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1sv/jU6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2157B20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbeLKJsq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:48:46 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44845 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeLKJsq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:48:46 -0500
Received: by mail-ed1-f67.google.com with SMTP id y56so11933588edd.11;
        Tue, 11 Dec 2018 01:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m980YmhP0KQl4VH29WyoK2q33zwGHl+CViSflvEjE2Y=;
        b=l1sv/jU63eo2nevwVK0H0NhKdZO/kqkLgRlWW73QuWtzSws980PZG3NPSD1vJVtIW/
         ajtXHEnIdNaC4YtX60Bur2B2wX3ocReQGHruktkGpyj/145JiLboMdy5PbI9WaaNEazL
         +ix8Y8R4zSAOximlx1eBAq4vaGSUG3iEyRRbUMytSHhrB9EcTq8MbYzB5FqAZLg2+x/t
         Ar+O0vkp1+5Fy+POZWbhHA4p5KAM9SY3Z3+/0mBq1HWbm2pXm/fCMwjccPdedkODi+lr
         HljYD3wgibz5AgW+kAcJ2Jz4kL+OKIICqhec/lEQ0bBV5pysX8pRwbspOJxf88yWchmm
         H+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m980YmhP0KQl4VH29WyoK2q33zwGHl+CViSflvEjE2Y=;
        b=PnobD4z+kcZ62MsAPCoNTY9rJBWOFsZnYjGaEIEb4CzO2QKaROmy7s7c1MIAQ4nR2B
         WycUlwbf6D+XFun6fSC6H52xdvJjt2uyLBtD86e1lxUjT68ykH2YsX1ZIrQWHzvXgRJI
         +VON02KEfXN4yAVW85q0UuOrV7Vq9R6mrHUPk+FZhvKquFckAVvNP6r0/AZ8idGm4vu6
         GQ9EDJLrLIkfPK/0ul2/p5NHsJ7nnjqL0FVywj4u8reUyg1Mlu8hLsx9NH+t/bR7tqNl
         IZ3OAic2etbB+pBdUQOygpFqEB/ADOcIQsc36x+U2a5n2ASzHVhtp5W7cthtbMGLfITe
         WhXA==
X-Gm-Message-State: AA+aEWbN1/gqR/8kJrbfz2nzBRtwYrKued82CFV3ddhcdlg0YNmoDKb8
        E+OfpLCB2AOUNpNI1KQ0b9J5GWpc
X-Google-Smtp-Source: AFSGD/UczIe6aZK7M85KtWnAOqEvSPjetAoQ3Pg63rqQZnDKfF6kKxvlRDtjB4gd/E0J8cvmUh+DrQ==
X-Received: by 2002:a17:906:60b:: with SMTP id s11-v6mr12264062ejb.25.1544521724538;
        Tue, 11 Dec 2018 01:48:44 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id 24sm3922829eds.97.2018.12.11.01.48.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 01:48:43 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v2 2/3] media: tegra-cec: Support Tegra186 and Tegra194
Date:   Tue, 11 Dec 2018 10:48:40 +0100
Message-Id: <20181211094841.16027-2-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181211094841.16027-1-thierry.reding@gmail.com>
References: <20181211094841.16027-1-thierry.reding@gmail.com>
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

