Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49931 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab1KQKTL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:19:11 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v3 1/5] ARM: davinci: dm644x: remove the macros from the header to move to c file
Date: Thu, 17 Nov 2011 15:48:54 +0530
Message-ID: <1321525138-3928-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
References: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move the register base addresses and offsets used only by dm644x
platform file from platform header dm644x.h to dm644x.c as they
are used only in the c file.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/dm644x.c              |    7 +++++++
 arch/arm/mach-davinci/include/mach/dm644x.h |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 3470983..27d1371 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -35,6 +35,13 @@
  */
 #define DM644X_REF_FREQ		27000000
 
+#define DM644X_EMAC_BASE		0x01c80000
+#define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
+#define DM644X_EMAC_CNTRL_OFFSET	0x0000
+#define DM644X_EMAC_CNTRL_MOD_OFFSET	0x1000
+#define DM644X_EMAC_CNTRL_RAM_OFFSET	0x2000
+#define DM644X_EMAC_CNTRL_RAM_SIZE	0x2000
+
 static struct pll_data pll1_data = {
 	.num       = 1,
 	.phys_base = DAVINCI_PLL1_BASE,
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 5a1b26d..724377f 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -27,13 +27,6 @@
 #include <mach/asp.h>
 #include <media/davinci/vpfe_capture.h>
 
-#define DM644X_EMAC_BASE		(0x01C80000)
-#define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
-#define DM644X_EMAC_CNTRL_OFFSET	(0x0000)
-#define DM644X_EMAC_CNTRL_MOD_OFFSET	(0x1000)
-#define DM644X_EMAC_CNTRL_RAM_OFFSET	(0x2000)
-#define DM644X_EMAC_CNTRL_RAM_SIZE	(0x2000)
-
 #define DM644X_ASYNC_EMIF_CONTROL_BASE	0x01E00000
 #define DM644X_ASYNC_EMIF_DATA_CE0_BASE 0x02000000
 #define DM644X_ASYNC_EMIF_DATA_CE1_BASE 0x04000000
-- 
1.6.2.4

