Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49927 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab1KQKTK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:19:10 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v3 2/5] ARM: davinci: dm365: remove the macros from the header to move to c file
Date: Thu, 17 Nov 2011 15:48:55 +0530
Message-ID: <1321525138-3928-3-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
References: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move the register base addresses and offsets used only by dm365
platform file from platform header dm365.h to dm365.c as they
are used only in the c file.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/dm365.c              |   16 ++++++++++++++++
 arch/arm/mach-davinci/include/mach/dm365.h |   16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 679e168..77edee8 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -40,6 +40,22 @@
 
 #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
 
+/* Base of key scan register bank */
+#define DM365_KEYSCAN_BASE		0x01c69400
+
+#define DM365_RTC_BASE			0x01c69000
+
+#define DAVINCI_DM365_VC_BASE		0x01d0c000
+#define DAVINCI_DMA_VC_TX		2
+#define DAVINCI_DMA_VC_RX		3
+
+#define DM365_EMAC_BASE			0x01d07000
+#define DM365_EMAC_MDIO_BASE		(DM365_EMAC_BASE + 0x4000)
+#define DM365_EMAC_CNTRL_OFFSET		0x0000
+#define DM365_EMAC_CNTRL_MOD_OFFSET	0x3000
+#define DM365_EMAC_CNTRL_RAM_OFFSET	0x1000
+#define DM365_EMAC_CNTRL_RAM_SIZE	0x2000
+
 static struct pll_data pll1_data = {
 	.num		= 1,
 	.phys_base	= DAVINCI_PLL1_BASE,
diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-davinci/include/mach/dm365.h
index 2563bf4..51924de 100644
--- a/arch/arm/mach-davinci/include/mach/dm365.h
+++ b/arch/arm/mach-davinci/include/mach/dm365.h
@@ -20,22 +20,6 @@
 #include <mach/keyscan.h>
 #include <media/davinci/vpfe_capture.h>
 
-#define DM365_EMAC_BASE			(0x01D07000)
-#define DM365_EMAC_MDIO_BASE		(DM365_EMAC_BASE + 0x4000)
-#define DM365_EMAC_CNTRL_OFFSET		(0x0000)
-#define DM365_EMAC_CNTRL_MOD_OFFSET	(0x3000)
-#define DM365_EMAC_CNTRL_RAM_OFFSET	(0x1000)
-#define DM365_EMAC_CNTRL_RAM_SIZE	(0x2000)
-
-/* Base of key scan register bank */
-#define DM365_KEYSCAN_BASE		(0x01C69400)
-
-#define DM365_RTC_BASE			(0x01C69000)
-
-#define DAVINCI_DM365_VC_BASE		(0x01D0C000)
-#define DAVINCI_DMA_VC_TX		2
-#define DAVINCI_DMA_VC_RX		3
-
 #define DM365_ASYNC_EMIF_CONTROL_BASE	0x01D10000
 #define DM365_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
 #define DM365_ASYNC_EMIF_DATA_CE1_BASE	0x04000000
-- 
1.6.2.4

