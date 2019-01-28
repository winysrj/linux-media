Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC58C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D2F1207E0
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 08:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="err1Fgtm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfA1I7R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 03:59:17 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:47038 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfA1I7R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 03:59:17 -0500
Received: by mail-pf1-f193.google.com with SMTP id c73so7691164pfe.13
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 00:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z8VDizYWcDBY1PcHiFT6xo+JsUGwxuPfGjOUI9TV1l4=;
        b=err1FgtmG1fBSLcHxlRaz6SGJImdA51wKAt1OJwEKtO4t9tJyt0upcC1WHVW/0MHzy
         mHU7hdZ3+mNzWr3RKSL1E+xQrlxnDak4NU7bXWH2Rlf7iMBOEpQhb/rApAYPwILeQWhQ
         4XYjp7tei45k0byTsx7cmsb/iOyUqALF3t/Nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z8VDizYWcDBY1PcHiFT6xo+JsUGwxuPfGjOUI9TV1l4=;
        b=Kvj5ZPnX8tmkkvda704NiaqrGH9LWTCMVu3exLMpTTILCy/v6K9SyUAq0Me4lwNNQe
         uqhjcnwv+TjOlQiyD8a6Uq95BCaoi40f+m90lB1uUfRKb0Uz/nyGnxQhRFX7XPzAL40T
         hu215FW3u5sf8IY9NtKgqTjvA0Prgxl2YSfLL0+15uNsDLAFXjinucgNF2q+XH2WcRM+
         Zmgtb45DNC00VcO0GQQ5WuUAJGnFSzrxzn7BFwS5n3X48J3XUMkWIPEgTFoxKOQc1ncS
         U6lhOd1/k8xn9HN89nuGFzOAd/ciqgaXlZbnXlP1wjJ1mEIBuOtFsECFJrtp/I5hAar4
         FOIQ==
X-Gm-Message-State: AJcUukca05W/8RyQGa3ux42RCSk0T/u8fBtREs1lL9Gqd/okefK9gqAZ
        KBJ2MWisb5iWw53shd6q05WAGw==
X-Google-Smtp-Source: ALg8bN5X3V3qfLnvHQjRDN0ccoS2WDEODgCbo7QWrN8XrPBc4OHQ95aJY3DFGiUhN8TOhOhbdkJ41g==
X-Received: by 2002:a62:5658:: with SMTP id k85mr20878597pfb.231.1548665956205;
        Mon, 28 Jan 2019 00:59:16 -0800 (PST)
Received: from localhost.localdomain ([115.97.179.75])
        by smtp.gmail.com with ESMTPSA id o189sm60746245pfg.117.2019.01.28.00.59.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 00:59:15 -0800 (PST)
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
Subject: [PATCH v8 2/5] media: sun6i: Add A64 CSI block support
Date:   Mon, 28 Jan 2019 14:28:44 +0530
Message-Id: <20190128085847.7217-3-jagan@amarulasolutions.com>
X-Mailer: git-send-email 2.18.0.321.gffc6fa0e3
In-Reply-To: <20190128085847.7217-1-jagan@amarulasolutions.com>
References: <20190128085847.7217-1-jagan@amarulasolutions.com>
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
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index ee882b66a5ea..5ecdfbf9f6ae 100644
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
 
@@ -161,6 +163,9 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
 
 		clk_disable_unprepare(sdev->clk_ram);
+		if (of_device_is_compatible(dev->of_node,
+					    "allwinner,sun50i-a64-csi"))
+			clk_rate_exclusive_put(sdev->clk_mod);
 		clk_disable_unprepare(sdev->clk_mod);
 		reset_control_assert(sdev->rstc_bus);
 		return 0;
@@ -172,6 +177,9 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 		return ret;
 	}
 
+	if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
+		clk_set_rate_exclusive(sdev->clk_mod, 300000000);
+
 	ret = clk_prepare_enable(sdev->clk_ram);
 	if (ret) {
 		dev_err(sdev->dev, "Enable clk_dram_csi clk err %d\n", ret);
@@ -191,6 +199,8 @@ int sun6i_csi_set_power(struct sun6i_csi *csi, bool enable)
 clk_ram_disable:
 	clk_disable_unprepare(sdev->clk_ram);
 clk_mod_disable:
+	if (of_device_is_compatible(dev->of_node, "allwinner,sun50i-a64-csi"))
+		clk_rate_exclusive_put(sdev->clk_mod);
 	clk_disable_unprepare(sdev->clk_mod);
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

