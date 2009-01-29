Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59495 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbZA2TWk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 14:22:40 -0500
From: hvaibhav@ti.com
To: linux-omap@vger.kernel.org
Cc: linux-media@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>,
	Brijesh Jadav <brijesh.j@ti.com>,
	Hardik Shah <hardik.shah@ti.com>
Subject: [PATCH 1/2] Pad configuration for OMAP3EVM Multi-Media Daughter Card Support
Date: Fri, 30 Jan 2009 00:52:29 +0530
Message-Id: <1233256950-26704-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

On OMAP3EVM Mass Market Daugher Card following GPIO pins are being
used -

GPIO134 --> Enable/Disable TVP5146 interface
GPIO54 --> Enable/Disable Expansion Camera interface
GPIO136 --> Enable/Disable Camera (Sensor) interface

Added entry for the above GPIO's in mux.c and mux.h file

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/mach-omap2/mux.c             |    6 ++++++
 arch/arm/plat-omap/include/mach/mux.h |    5 ++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 1556688..d226d81 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -471,6 +471,12 @@ MUX_CFG_34XX("AF5_34XX_GPIO142", 0x170,
 		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
 MUX_CFG_34XX("AE5_34XX_GPIO143", 0x172,
 		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
+MUX_CFG_34XX("AG4_34XX_GPIO134", 0x160,
+		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
+MUX_CFG_34XX("U8_34XX_GPIO54", 0x0b4,
+		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)
+MUX_CFG_34XX("AE4_34XX_GPIO136", 0x164,
+		OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)

 };

diff --git a/arch/arm/plat-omap/include/mach/mux.h b/arch/arm/plat-omap/include/mach/mux.h
index 67fddec..ace037f 100644
--- a/arch/arm/plat-omap/include/mach/mux.h
+++ b/arch/arm/plat-omap/include/mach/mux.h
@@ -795,7 +795,10 @@ enum omap34xx_index {
 	AF6_34XX_GPIO140_UP,
 	AE6_34XX_GPIO141,
 	AF5_34XX_GPIO142,
-	AE5_34XX_GPIO143
+	AE5_34XX_GPIO143,
+	AG4_34XX_GPIO134,
+	U8_34XX_GPIO54,
+	AE4_34XX_GPIO136,
 };

 struct omap_mux_cfg {
--
1.5.6

