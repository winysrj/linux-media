Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:55606 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1ECKmh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 06:42:37 -0400
From: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
To: maurochehab@gmail.com, tony@atomide.com
Cc: laurent.pinchart@ideasonboard.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org,
	Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: [PATCH v3 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Date: Tue,  3 May 2011 13:41:23 +0300
Message-Id: <1304419283-4177-3-git-send-email-kalle.jokiniemi@nokia.com>
In-Reply-To: <1304419283-4177-1-git-send-email-kalle.jokiniemi@nokia.com>
References: <1304419283-4177-1-git-send-email-kalle.jokiniemi@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The RX-51 uses the CSIb IO complex for camera operation. The
board file is missing definition for the regulator supplying
the CSIb complex, so this is added for better power
management.

Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index bbcb677..2f12425 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -337,6 +337,10 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
 static struct regulator_consumer_supply rx51_vmmc1_supply =
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
 
+static struct regulator_consumer_supply rx51_vaux2_supply[] = {
+	REGULATOR_SUPPLY("vdds_csib", "omap3isp"),
+};
+
 static struct regulator_consumer_supply rx51_vaux3_supply =
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
 
@@ -400,6 +404,8 @@ static struct regulator_init_data rx51_vaux2 = {
 		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 					| REGULATOR_CHANGE_STATUS,
 	},
+	.num_consumer_supplies	= 1,
+	.consumer_supplies	= rx51_vaux2_supply,
 };
 
 /* VAUX3 - adds more power to VIO_18 rail */
-- 
1.7.1

