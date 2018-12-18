Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE23C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F176821852
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 11:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="Dyp9G4/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbeLRLeL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 06:34:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37650 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbeLRLde (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 06:33:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id s12so15112301wrt.4
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 03:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tp2qTP6b0v5Vb54Ya9denLrSJ0P23sY7OEhQ5x0BuQw=;
        b=Dyp9G4/ekeYXIOjOjpiWgVd9vebimJb9fRIf1Xc3jcoJabiZtusXwthfSgo4oTLy+u
         X/LwvbVkkRx7XUDOUKqkbUANBdGpW00sWSJNIbT51PuJrYH/FHbgWIffTh815hutWXnt
         dtdOmBUs/595yPrQbizgIqEF5OeH7PeoYHPDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tp2qTP6b0v5Vb54Ya9denLrSJ0P23sY7OEhQ5x0BuQw=;
        b=SE392i+4C5dyyFS91W3nXbERhDVYR+EGJXnfGPS2aBnaeDb6toBcuzYSVjBHoGb164
         dHmLxuTj5ZHmyOkPl/52hUXWLzRolyFTdchfgR4Q/JCUl3x0a995pex64bE1eG9evgcR
         RYl/GoThCQI1/DKgko+12Vv/7D8sEhmqZ/i0kKbENxwv3VjibUVdVyZfo8t47w5Bk748
         rgw3wUGIfehsWc3wBAEO0ehl5N22SH7ISeIA0ICmKa6UFKq53nEFQ/T4hYjm/0UqX+BH
         34mo6vm/jUXkfj3ZlH4gmg0/GKIRMK3NuR4GZaWcuaTfXMXZh0g1kbG0gjTT6ipOk6VZ
         PkCA==
X-Gm-Message-State: AA+aEWY4HhreUQb3yv7omAjUOktOPtqMgdMq7sWjPSUl2e3kpS+nKhh7
        2BvBS8kOgWuqJ9IO3OzTfccGSw==
X-Google-Smtp-Source: AFSGD/UBnj2Lpi4jkn0o6yWcZcSfQE5ucR9VFQkE9SDOdqSMiaik7KRdoJ3yAEltcutn/NWo0vNsTw==
X-Received: by 2002:adf:e149:: with SMTP id f9mr15577466wri.42.1545132812924;
        Tue, 18 Dec 2018 03:33:32 -0800 (PST)
Received: from jagan-XPS-13-9350.homenet.telecomitalia.it (host230-181-static.228-95-b.business.telecomitalia.it. [95.228.181.230])
        by smtp.gmail.com with ESMTPSA id h2sm4276184wrv.87.2018.12.18.03.33.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 03:33:32 -0800 (PST)
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
Subject: [PATCH v4 2/6] media: sun6i: Add A64 compatible support
Date:   Tue, 18 Dec 2018 17:03:16 +0530
Message-Id: <20181218113320.4856-3-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20181218113320.4856-1-jagan@amarulasolutions.com>
References: <20181218113320.4856-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add compatible string for Allwinner A64 CSI.

A64 CSI has similar features as like in H3, but the CSI_SCLK
need to update it to 300MHz than default clock rate.

A64 BSP is also operating same rate as default csi clock.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index ee882b66a5ea..9ff61896e4bb 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -895,6 +895,7 @@ static const struct of_device_id sun6i_csi_of_match[] = {
 	{ .compatible = "allwinner,sun6i-a31-csi", },
 	{ .compatible = "allwinner,sun8i-h3-csi", },
 	{ .compatible = "allwinner,sun8i-v3s-csi", },
+	{ .compatible = "allwinner,sun50i-a64-csi", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, sun6i_csi_of_match);
-- 
2.18.0.321.gffc6fa0e3

