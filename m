Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:52478 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab1EBJSe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 05:18:34 -0400
From: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
To: maurochehab@gmail.com, tony@atomide.com
Cc: laurent.pinchart@ideasonboard.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org,
	Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: [PATCH v2 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Date: Mon,  2 May 2011 12:16:17 +0300
Message-Id: <1304327777-31231-3-git-send-email-kalle.jokiniemi@nokia.com>
In-Reply-To: <1304327777-31231-1-git-send-email-kalle.jokiniemi@nokia.com>
References: <1304327777-31231-1-git-send-email-kalle.jokiniemi@nokia.com>
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

