Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60309 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1KNPJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 10:09:30 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2 1/5] davinci: dm644x: remove the macros from the header to move to c file
Date: Mon, 14 Nov 2011 20:39:13 +0530
Message-ID: <1321283357-27698-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move the register base addresses and offsets used only by dm644x
platform file from platform header dm644x.h to dm644x.c as they
are used only in the c file.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/dm644x.c              |    6 ++++++
 arch/arm/mach-davinci/include/mach/dm644x.h |    7 -------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 3470983..1b4b911 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -34,6 +34,12 @@
  * Device specific clocks
  */
 #define DM644X_REF_FREQ		27000000
+#define DM644X_EMAC_BASE		0x01c80000
+#define DM644X_EMAC_MDIO_BASE		(DM644X_EMAC_BASE + 0x4000)
+#define DM644X_EMAC_CNTRL_OFFSET	0x0000
+#define DM644X_EMAC_CNTRL_MOD_OFFSET	0x1000
+#define DM644X_EMAC_CNTRL_RAM_OFFSET	0x2000
+#define DM644X_EMAC_CNTRL_RAM_SIZE	0x2000
 
 static struct pll_data pll1_data = {
 	.num       = 1,
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

