Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51225 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab1KNPJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 10:09:32 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2 3/5] davinci: dm646x: remove the macros from the header to move to c file
Date: Mon, 14 Nov 2011 20:39:15 +0530
Message-ID: <1321283357-27698-4-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move the register base addresses and offsets used only by dm646x
platform file from platform header dm646x.h to dm646x.c as they
are used only in the c file.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/dm646x.c              |    7 +++++++
 arch/arm/mach-davinci/include/mach/dm646x.h |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 0b68ed5..0560e82 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -46,6 +46,13 @@
 #define DM646X_REF_FREQ		27000000
 #define DM646X_AUX_FREQ		24000000
 
+#define DM646X_EMAC_BASE		0x01c80000
+#define DM646X_EMAC_MDIO_BASE		(DM646X_EMAC_BASE + 0x4000)
+#define DM646X_EMAC_CNTRL_OFFSET	0x0000
+#define DM646X_EMAC_CNTRL_MOD_OFFSET	0x1000
+#define DM646X_EMAC_CNTRL_RAM_OFFSET	0x2000
+#define DM646X_EMAC_CNTRL_RAM_SIZE	0x2000
+
 static struct pll_data pll1_data = {
 	.num       = 1,
 	.phys_base = DAVINCI_PLL1_BASE,
diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
index a8ee6c9..eb95864 100644
--- a/arch/arm/mach-davinci/include/mach/dm646x.h
+++ b/arch/arm/mach-davinci/include/mach/dm646x.h
@@ -18,13 +18,6 @@
 #include <linux/davinci_emac.h>
 #include <media/davinci/vpif_types.h>
 
-#define DM646X_EMAC_BASE		(0x01C80000)
-#define DM646X_EMAC_MDIO_BASE		(DM646X_EMAC_BASE + 0x4000)
-#define DM646X_EMAC_CNTRL_OFFSET	(0x0000)
-#define DM646X_EMAC_CNTRL_MOD_OFFSET	(0x1000)
-#define DM646X_EMAC_CNTRL_RAM_OFFSET	(0x2000)
-#define DM646X_EMAC_CNTRL_RAM_SIZE	(0x2000)
-
 #define DM646X_ASYNC_EMIF_CONTROL_BASE	0x20008000
 #define DM646X_ASYNC_EMIF_CS2_SPACE_BASE 0x42000000
 
-- 
1.6.2.4

