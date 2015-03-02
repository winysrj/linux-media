Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45402 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbbCBRG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:06:56 -0500
In-Reply-To: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 09/10] ARM: omap2: use clkdev_create()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1YSTnr-0001K1-Do@rmk-PC.arm.linux.org.uk>
Date: Mon, 02 Mar 2015 17:06:47 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rather than open coding the clkdev allocation, initialisation and
addition, use the clkdev_create() helper.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
index 85e0b0c06718..b64d717bfab6 100644
--- a/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
+++ b/arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c
@@ -232,14 +232,12 @@ void omap2xxx_clkt_vps_init(void)
 	struct clk_hw_omap *hw = NULL;
 	struct clk *clk;
 	const char *parent_name = "mpu_ck";
-	struct clk_lookup *lookup = NULL;
 
 	omap2xxx_clkt_vps_late_init();
 	omap2xxx_clkt_vps_check_bootloader_rates();
 
 	hw = kzalloc(sizeof(*hw), GFP_KERNEL);
-	lookup = kzalloc(sizeof(*lookup), GFP_KERNEL);
-	if (!hw || !lookup)
+	if (!hw)
 		goto cleanup;
 	init.name = "virt_prcm_set";
 	init.ops = &virt_prcm_set_ops;
@@ -249,15 +247,9 @@ void omap2xxx_clkt_vps_init(void)
 	hw->hw.init = &init;
 
 	clk = clk_register(NULL, &hw->hw);
-
-	lookup->dev_id = NULL;
-	lookup->con_id = "cpufreq_ck";
-	lookup->clk = clk;
-
-	clkdev_add(lookup);
+	clkdev_create(clk, "cpufreq_ck", NULL);
 	return;
 cleanup:
 	kfree(hw);
-	kfree(lookup);
 }
 #endif
-- 
1.8.3.1

