Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F557C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE8221904
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355214;
	bh=2Xm8Agh6iR6Aviv+khszZ2EMzWfoouXmg4JjdE/GOio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0J0aFp58UduCO8XqHMQRaI3oERWw2iS2ge35jMg4Z2OtSDVXzk5tFbeq64sToYMx5
	 W+lYYPEzNtLUH2XbXyURJHdCdxuf39LOcDR53otd99TZCqM/BE7oIfXk2IP2jrwsAj
	 YVy2SVwwqZo0n0yM1Mb1kOEOdHOIgO6GLwWK+f7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbeLUBSR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388604AbeLUBSP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:15 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B753F21904;
        Fri, 21 Dec 2018 01:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355094;
        bh=2Xm8Agh6iR6Aviv+khszZ2EMzWfoouXmg4JjdE/GOio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKztesz9+EZd9iisGHnVBW3TDeD/Dm77SeP1Gd//quLBqQFKtv4C2XfMvZVxs3hRm
         M7E4NpnDAEZSzM1bFVGaicBkrNAqCIqNavMVQNQR3rguGyDw8exJOR+H0ZoSyD/ZeS
         GdQJnhvC8G4Cw8nUj/VdqbWzo7Es1hv69KzZm4pQ=
From:   Sebastian Reichel <sre@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 03/14] ARM: OMAP2+: pdata-quirks: drop TI_ST/KIM support
Date:   Fri, 21 Dec 2018 02:17:41 +0100
Message-Id: <20181221011752.25627-4-sre@kernel.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

All TI_ST users have been migrated to the new serdev based HCILL
bluetooth driver. That driver is initialized from DT and does not
need any platform quirks.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 arch/arm/mach-omap2/pdata-quirks.c | 52 ------------------------------
 1 file changed, 52 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 9fec5f84bf77..2bd83ac74b7a 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
-#include <linux/ti_wilink_st.h>
 #include <linux/wl12xx.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -141,53 +140,6 @@ static void __init omap3_sbc_t3530_legacy_init(void)
 	omap3_sbc_t3x_usb_hub_init(167, "sb-t35 usb hub");
 }
 
-static struct ti_st_plat_data wilink_pdata = {
-	.nshutdown_gpio = 137,
-	.dev_name = "/dev/ttyO1",
-	.flow_cntrl = 1,
-	.baud_rate = 300000,
-};
-
-static struct platform_device wl18xx_device = {
-	.name	= "kim",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &wilink_pdata,
-	}
-};
-
-static struct ti_st_plat_data wilink7_pdata = {
-	.nshutdown_gpio = 162,
-	.dev_name = "/dev/ttyO1",
-	.flow_cntrl = 1,
-	.baud_rate = 3000000,
-};
-
-static struct platform_device wl128x_device = {
-	.name	= "kim",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &wilink7_pdata,
-	}
-};
-
-static struct platform_device btwilink_device = {
-	.name	= "btwilink",
-	.id	= -1,
-};
-
-static void __init omap3_igep0020_rev_f_legacy_init(void)
-{
-	platform_device_register(&wl18xx_device);
-	platform_device_register(&btwilink_device);
-}
-
-static void __init omap3_igep0030_rev_g_legacy_init(void)
-{
-	platform_device_register(&wl18xx_device);
-	platform_device_register(&btwilink_device);
-}
-
 static void __init omap3_evm_legacy_init(void)
 {
 	hsmmc2_internal_input_clk();
@@ -301,8 +253,6 @@ static void __init omap3_tao3530_legacy_init(void)
 static void __init omap3_logicpd_torpedo_init(void)
 {
 	omap3_gpio126_127_129();
-	platform_device_register(&wl128x_device);
-	platform_device_register(&btwilink_device);
 }
 
 /* omap3pandora legacy devices */
@@ -623,8 +573,6 @@ static struct pdata_init pdata_quirks[] __initdata = {
 	{ "nokia,omap3-n900", nokia_n900_legacy_init, },
 	{ "nokia,omap3-n9", hsmmc2_internal_input_clk, },
 	{ "nokia,omap3-n950", hsmmc2_internal_input_clk, },
-	{ "isee,omap3-igep0020-rev-f", omap3_igep0020_rev_f_legacy_init, },
-	{ "isee,omap3-igep0030-rev-g", omap3_igep0030_rev_g_legacy_init, },
 	{ "logicpd,dm3730-torpedo-devkit", omap3_logicpd_torpedo_init, },
 	{ "ti,omap3-evm-37xx", omap3_evm_legacy_init, },
 	{ "ti,am3517-evm", am3517_evm_legacy_init, },
-- 
2.19.2

