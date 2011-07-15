Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33600 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1GOSYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 14:24:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Kalle Jokiniemi <kalle.jokiniemi@nokia.com>, tony@atomide.com
Subject: [PATCH 2/3] OMAP3: RX-51: define vdds_csib regulator supply
Date: Fri, 15 Jul 2011 20:24:09 +0200
Message-Id: <1310754250-28788-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>

The RX-51 uses the CSIb IO complex for camera operation. The
board file is missing definition for the regulator supplying
the CSIb complex, so this is added for better power
management.

Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tony@atomide.com
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

Tony, can I push this patch through the V4L/DVB tree, or would you like to
pick it yourself ?

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 88bd6f7..17e5685 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -361,6 +361,9 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
 static struct regulator_consumer_supply rx51_vmmc1_supply =
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
 
+static struct regulator_consumer_supply rx51_vaux2_supply =
+	REGULATOR_SUPPLY("vdds_csib", "omap3isp");
+
 static struct regulator_consumer_supply rx51_vaux3_supply =
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
 
@@ -424,6 +427,8 @@ static struct regulator_init_data rx51_vaux2 = {
 		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 					| REGULATOR_CHANGE_STATUS,
 	},
+	.num_consumer_supplies	= 1,
+	.consumer_supplies	= &rx51_vaux2_supply,
 };
 
 /* VAUX3 - adds more power to VIO_18 rail */
-- 
1.7.3.4

