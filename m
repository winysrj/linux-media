Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CBDC43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D69BF218D3
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:55:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="guAKJy0O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732712AbeLTMzB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:55:01 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36831 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732651AbeLTMyz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 07:54:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id p6so2061844wmc.1
        for <linux-media@vger.kernel.org>; Thu, 20 Dec 2018 04:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XK1+ImY4LqT3mqPXOgRcotLaegAmI6oUTAhBqe9t1Sw=;
        b=guAKJy0OL6nXtpHu5GU/d99DuxpR0mmuIZemRdWaOszAnuyybtR/sssbywfDKRrNrf
         DqL8yOLBev+gKWvFdn94peWiE144jfkW0jdSegShXzl3vVX8Veitr4Aov8ON1Mna/ZKG
         ltr8NR+r0nrJ12xaj2GAHmF2tKLYzb0BjWWpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XK1+ImY4LqT3mqPXOgRcotLaegAmI6oUTAhBqe9t1Sw=;
        b=c1zbF7tnyAQAQE3P4cFzFcDHr4EKOK/v2/v4JYPa8HyoxB5Mh3LBm8hqtoSFpQ8C0f
         KN6JJi6JefW+NgAWGxzgVQIHGecveEuMYsCSnMDiORSdN7wiem5ws/ihncJIoCiZ/N+G
         aSnLClmpoSdNlCAZY5vM6fzEV2YKOVh+yVN+P5aN3nvOy7uTESSoyh49n6eQcA+8hN89
         S5cT2+bUko+4qB9Yb6W0L0D6geNtg9oZqTIbL6t2+fTnQWJvhsVSxU5umwYg9LVGTx7V
         UUgSP5M618730UJMTWyjijQ6M7OgjoC8CWYZMmpFRFceZv7I32OuVXKNQni9J2A8y/CK
         jDag==
X-Gm-Message-State: AA+aEWa7KobrKiaZ2ce5BwKsqXUijQqGHuWOkaNgmqDzN4dDlKPoOC9B
        pc2BA/ZoBXbA7teqXxMF51dOpw==
X-Google-Smtp-Source: AFSGD/VaVhsdOJ+GQeoQ3YRRzS8H1oCRVWa/ZckdcR5C+R9heqHrTZBUjY6lcOQvr2R2zurM9FcrHw==
X-Received: by 2002:a1c:a895:: with SMTP id r143mr10839869wme.95.1545310493002;
        Thu, 20 Dec 2018 04:54:53 -0800 (PST)
Received: from localhost.localdomain (ip-163-240.sn-213-198.clouditalia.com. [213.198.163.240])
        by smtp.gmail.com with ESMTPSA id o4sm8732756wrq.66.2018.12.20.04.54.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Dec 2018 04:54:52 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Cc:     Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v5 3/6] media: sun6i: Add A64 CSI block support
Date:   Thu, 20 Dec 2018 18:24:35 +0530
Message-Id: <20181220125438.11700-4-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181220125438.11700-1-jagan@amarulasolutions.com>
References: <20181220125438.11700-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

CSI block in Allwinner A64 has similar features as like in H3,
but default mod clock rate in BSP along with latest mainline testing
require to operate it at 300MHz.

So, add A64 CSI compatibe along with mod_rate quirk.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index fe002beae09c..48919aabefdb 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -913,10 +913,15 @@ static int sun6i_csi_remove(struct platform_device *pdev)
 static const struct sun6i_csi_variant sun6i_a31_csi = {
 };
 
+static const struct sun6i_csi_variant sun50i_a64_csi = {
+	.mod_rate	= 300000000,
+};
+
 static const struct of_device_id sun6i_csi_of_match[] = {
 	{ .compatible = "allwinner,sun6i-a31-csi", .data = &sun6i_a31_csi, },
 	{ .compatible = "allwinner,sun8i-h3-csi", .data = &sun6i_a31_csi, },
 	{ .compatible = "allwinner,sun8i-v3s-csi", .data = &sun6i_a31_csi, },
+	{ .compatible = "allwinner,sun50i-a64-csi", .data = &sun50i_a64_csi, },
 	{},
 };
 MODULE_DEVICE_TABLE(of, sun6i_csi_of_match);
-- 
2.18.0.321.gffc6fa0e3

