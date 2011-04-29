Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:46616 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab1D2HNL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 03:13:11 -0400
From: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
To: laurent.pinchart@ideasonboard.com, tony@atomide.com,
	mchebab@infradead.org
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: [PATCH 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Date: Fri, 29 Apr 2011 10:12:00 +0300
Message-Id: <1304061120-6383-3-git-send-email-kalle.jokiniemi@nokia.com>
In-Reply-To: <1304061120-6383-1-git-send-email-kalle.jokiniemi@nokia.com>
References: <1304061120-6383-1-git-send-email-kalle.jokiniemi@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The RX-51 uses the CSIb IO complex for camera operation. The
board file is missing definition for the regulator supplying
the CSIb complex, so this is added for better power
management.

Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index bbcb677..1324ba3 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -337,6 +337,13 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
 static struct regulator_consumer_supply rx51_vmmc1_supply =
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
 
+static struct regulator_consumer_supply rx51_vaux2_supplies[] = {
+	REGULATOR_SUPPLY("vdds_csib", "omap3isp"),
+	{
+		.supply = "vaux2",
+	},
+};
+
 static struct regulator_consumer_supply rx51_vaux3_supply =
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
 
@@ -400,6 +407,8 @@ static struct regulator_init_data rx51_vaux2 = {
 		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 					| REGULATOR_CHANGE_STATUS,
 	},
+	.num_consumer_supplies	= ARRAY_SIZE(rx51_vaux2_supplies),
+	.consumer_supplies	= rx51_vaux2_supplies,
 };
 
 /* VAUX3 - adds more power to VIO_18 rail */
-- 
1.7.1

