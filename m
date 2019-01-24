Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6BEC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AA17218AF
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="NDnnVVg9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbfAXSIa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:08:30 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35764 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbfAXSI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 13:08:28 -0500
Received: by mail-pl1-f196.google.com with SMTP id p8so3253857plo.2
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 10:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UF0ie0AFcUOJKnp5dQnoc9GbuzcXmNAC6ctNdvT/vFI=;
        b=NDnnVVg9N0w5j1eh1QJCTCPhT7lwbq9Ao11qqMbunE5BM5940dxN0lbptZCCdXzKU5
         Z+Fkc6FcGLYcT/+cPt7sbICMX5UtfFR5j+Ie4Sdx+0YKgPE4+2fyzU8QTKl9ZDNFYbZZ
         wNgxqaNhvZdfWWIGu16fr+eEZkIyMttuBGx+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UF0ie0AFcUOJKnp5dQnoc9GbuzcXmNAC6ctNdvT/vFI=;
        b=eyszLWokv0D4Uoz20ehqp698Vl7kF8S27ZMGKgiVLaxnROsu1dER7bdwPZ20MhJaRI
         JCMYES/H796tpc6O5+xkPZAk8mnTX1h/HVcRVmCKML5/eiBVoyMcP25pCEc8alqm1cpe
         afRFVyJ2r6hO4paZaWNQN8lXbsuXIR+v6QVUYE9nvkMZHbd7puqJh+wkB/NlVIv2/ccm
         p9t3sAPqKSZlIr35UFRVDrRF/7yrb8gu+hQzlGBjhAAhyhoztdy/CGy68eD5dDlsqIMV
         2mIw8fJrgZo02fAnB+CZjcEgzkPvrjNXR5mkAC0fVJi1KkXH3pk8non+6oPQoWnDvEI8
         qOSA==
X-Gm-Message-State: AJcUukdNX7bsPnFpQj0bx12hrlDq52Uu57nxq+yDz338BI8sA0SBBlwO
        V3q6mWwkc35Dy8RaqNHwJQj3MQ==
X-Google-Smtp-Source: ALg8bN6gvz0ooTP/Bgag/ZsaxzHTDVYxLlAJYp+VPyEO8INABlTb5oDJjjG601prTqUveq9BY1KhUA==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr2332887plp.247.1548353308049;
        Thu, 24 Jan 2019 10:08:28 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id k15sm36141551pfb.147.2019.01.24.10.08.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 10:08:27 -0800 (PST)
From:   Jagan Teki <jagan@amarulasolutions.com>
To:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH v7 2/5] media: sun6i: Add A64 CSI block support
Date:   Thu, 24 Jan 2019 23:37:33 +0530
Message-Id: <20190124180736.28408-3-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190124180736.28408-1-jagan@amarulasolutions.com>
References: <20190124180736.28408-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

CSI block in Allwinner A64 has similar features as like in H3,
but the default CSI_SCLK rate cannot work properly to drive the
connected sensor interface.

The tested mod cock rate is 300 MHz and BSP vfe media driver is also
using the same rate. Unfortunately there is no valid information about
clock rate in manual or any other sources except the BSP driver. so more
faith on BSP code, because same has tested in mainline.

So, add support for A64 CSI block by setting updated mod clock rate.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index ee882b66a5ea..cd2d33242c17 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -15,6 +15,7 @@
 #include <linux/ioctl.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
@@ -154,6 +155,7 @@ bool sun6i_csi_is_format_supported(struct sun6i_csi *csi,
 int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 {
 	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
+	struct device *dev = sdev->dev;
 	struct regmap *regmap = sdev->regmap;
 	int ret;
 
@@ -161,15 +163,20 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
 
 		clk_disable_unprepare(sdev->clk_ram);
+		if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
+			clk_rate_exclusive_put(sdev->clk_mod);
 		clk_disable_unprepare(sdev->clk_mod);
 		reset_control_assert(sdev->rstc_bus);
 		return 0;
 	}
 
+	if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
+		clk_set_rate_exclusive(sdev->clk_mod, 300000000);
+
 	ret = clk_prepare_enable(sdev->clk_mod);
 	if (ret) {
 		dev_err(sdev->dev, "Enable csi clk err %d\n", ret);
-		return ret;
+		goto clk_mod_put;
 	}
 
 	ret = clk_prepare_enable(sdev->clk_ram);
@@ -192,6 +199,9 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 	clk_disable_unprepare(sdev->clk_ram);
 clk_mod_disable:
 	clk_disable_unprepare(sdev->clk_mod);
+clk_mod_put:
+	if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
+		clk_rate_exclusive_put(sdev->clk_mod);
 	return ret;
 }
 
@@ -895,6 +905,7 @@ static const struct of_device_id sun6i_csi_of_match[] = {
 	{ .compatible = "allwinner,sun6i-a31-csi", },
 	{ .compatible = "allwinner,sun8i-h3-csi", },
 	{ .compatible = "allwinner,sun8i-v3s-csi", },
+	{ .compatible = "allwinner,sun50i-a64-csi", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, sun6i_csi_of_match);
-- 
2.18.0.321.gffc6fa0e3

