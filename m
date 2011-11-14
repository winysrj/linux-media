Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60325 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1KNPJg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 10:09:36 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2 4/5] davinci: create new common platform header for davinci
Date: Mon, 14 Nov 2011 20:39:16 +0530
Message-ID: <1321283357-27698-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
References: <1321283357-27698-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove the code from individual platform header files for
dm365, dm355, dm644x and dm646x and consolidate it into a
single and common header file davinci_common.h.
Include the new header file in individual platform header
files as a pre-cursor for deleting these headers in follow
up patches.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 .../arm/mach-davinci/include/mach/davinci_common.h |   88 ++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/dm355.h         |   18 +----
 arch/arm/mach-davinci/include/mach/dm365.h         |   20 +----
 arch/arm/mach-davinci/include/mach/dm644x.h        |   15 +---
 arch/arm/mach-davinci/include/mach/dm646x.h        |   20 +----
 5 files changed, 92 insertions(+), 69 deletions(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/davinci_common.h

diff --git a/arch/arm/mach-davinci/include/mach/davinci_common.h b/arch/arm/mach-davinci/include/mach/davinci_common.h
new file mode 100644
index 0000000..a859318
--- /dev/null
+++ b/arch/arm/mach-davinci/include/mach/davinci_common.h
@@ -0,0 +1,88 @@
+/*
+ * This file contains the processor specific definitions
+ * of the TI DM644x, DM355, DM365, and DM646X.
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __DAVINCI_COMMON_H
+#define __DAVINCI_COMMON_H
+
+#include <mach/asp.h>
+#include <linux/clk.h>
+#include <linux/i2c.h>
+#include <mach/keyscan.h>
+#include <linux/videodev2.h>
+#include <linux/davinci_emac.h>
+#include <linux/platform_device.h>
+#include <media/davinci/vpfe_capture.h>
+#include <media/davinci/vpif_types.h>
+
+/* DM355 base addresses */
+#define DM355_ASYNC_EMIF_CONTROL_BASE	0x01e10000
+#define DM355_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
+
+#define ASP1_TX_EVT_EN	1
+#define ASP1_RX_EVT_EN	2
+
+/* DM365 base addresses */
+#define DM365_ASYNC_EMIF_CONTROL_BASE	0x01d10000
+#define DM365_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
+#define DM365_ASYNC_EMIF_DATA_CE1_BASE	0x04000000
+
+/* DM644x base addresses */
+#define DM644X_ASYNC_EMIF_CONTROL_BASE	0x01e00000
+#define DM644X_ASYNC_EMIF_DATA_CE0_BASE 0x02000000
+#define DM644X_ASYNC_EMIF_DATA_CE1_BASE 0x04000000
+#define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
+#define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
+
+/* DM646x base addresses */
+#define DM646X_ASYNC_EMIF_CONTROL_BASE	0x20008000
+#define DM646X_ASYNC_EMIF_CS2_SPACE_BASE 0x42000000
+
+/* DM355 function declarations */
+struct spi_board_info;
+
+void __init dm355_init(void);
+void dm355_init_spi0(unsigned chipselect_mask,
+		struct spi_board_info *info, unsigned len);
+void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
+void dm355_set_vpfe_config(struct vpfe_config *cfg);
+
+/* DM365 function declarations */
+void __init dm365_init(void);
+void __init dm365_init_asp(struct snd_platform_data *pdata);
+void __init dm365_init_vc(struct snd_platform_data *pdata);
+void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
+void __init dm365_init_rtc(void);
+void dm365_init_spi0(unsigned chipselect_mask,
+			struct spi_board_info *info, unsigned len);
+
+void dm365_set_vpfe_config(struct vpfe_config *cfg);
+
+/* DM644X function declarations */
+void __init dm644x_init(void);
+void __init dm644x_init_asp(struct snd_platform_data *pdata);
+void dm644x_set_vpfe_config(struct vpfe_config *cfg);
+
+/* DM646X function declarations */
+void __init dm646x_init(void);
+void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
+void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
+void __init dm646x_board_setup_refclk(struct clk *clk);
+int __init dm646x_init_edma(struct edma_rsv_info *rsv);
+
+void dm646x_video_init(void);
+
+void dm646x_setup_vpif(struct vpif_display_config *,
+		       struct vpif_capture_config *);
+#endif /*__DAVINCI_COMMON_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm355.h b/arch/arm/mach-davinci/include/mach/dm355.h
index 36dff4a..40c298b 100644
--- a/arch/arm/mach-davinci/include/mach/dm355.h
+++ b/arch/arm/mach-davinci/include/mach/dm355.h
@@ -11,22 +11,6 @@
 #ifndef __ASM_ARCH_DM355_H
 #define __ASM_ARCH_DM355_H
 
-#include <mach/hardware.h>
-#include <mach/asp.h>
-#include <media/davinci/vpfe_capture.h>
-
-#define DM355_ASYNC_EMIF_CONTROL_BASE	0x01E10000
-#define DM355_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
-
-#define ASP1_TX_EVT_EN	1
-#define ASP1_RX_EVT_EN	2
-
-struct spi_board_info;
-
-void __init dm355_init(void);
-void dm355_init_spi0(unsigned chipselect_mask,
-		struct spi_board_info *info, unsigned len);
-void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
-void dm355_set_vpfe_config(struct vpfe_config *cfg);
+#include <mach/davinci_common.h>
 
 #endif /* __ASM_ARCH_DM355_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm365.h b/arch/arm/mach-davinci/include/mach/dm365.h
index 51924de..3c30934 100644
--- a/arch/arm/mach-davinci/include/mach/dm365.h
+++ b/arch/arm/mach-davinci/include/mach/dm365.h
@@ -13,24 +13,6 @@
 #ifndef __ASM_ARCH_DM365_H
 #define __ASM_ARCH_DM665_H
 
-#include <linux/platform_device.h>
-#include <linux/davinci_emac.h>
-#include <mach/hardware.h>
-#include <mach/asp.h>
-#include <mach/keyscan.h>
-#include <media/davinci/vpfe_capture.h>
+#include <mach/davinci_common.h>
 
-#define DM365_ASYNC_EMIF_CONTROL_BASE	0x01D10000
-#define DM365_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
-#define DM365_ASYNC_EMIF_DATA_CE1_BASE	0x04000000
-
-void __init dm365_init(void);
-void __init dm365_init_asp(struct snd_platform_data *pdata);
-void __init dm365_init_vc(struct snd_platform_data *pdata);
-void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
-void __init dm365_init_rtc(void);
-void dm365_init_spi0(unsigned chipselect_mask,
-			struct spi_board_info *info, unsigned len);
-
-void dm365_set_vpfe_config(struct vpfe_config *cfg);
 #endif /* __ASM_ARCH_DM365_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 724377f..186fabb 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -22,19 +22,6 @@
 #ifndef __ASM_ARCH_DM644X_H
 #define __ASM_ARCH_DM644X_H
 
-#include <linux/davinci_emac.h>
-#include <mach/hardware.h>
-#include <mach/asp.h>
-#include <media/davinci/vpfe_capture.h>
-
-#define DM644X_ASYNC_EMIF_CONTROL_BASE	0x01E00000
-#define DM644X_ASYNC_EMIF_DATA_CE0_BASE 0x02000000
-#define DM644X_ASYNC_EMIF_DATA_CE1_BASE 0x04000000
-#define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
-#define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
-
-void __init dm644x_init(void);
-void __init dm644x_init_asp(struct snd_platform_data *pdata);
-void dm644x_set_vpfe_config(struct vpfe_config *cfg);
+#include <mach/davinci_common.h>
 
 #endif /* __ASM_ARCH_DM644X_H */
diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
index eb95864..216e7c5 100644
--- a/arch/arm/mach-davinci/include/mach/dm646x.h
+++ b/arch/arm/mach-davinci/include/mach/dm646x.h
@@ -11,24 +11,6 @@
 #ifndef __ASM_ARCH_DM646X_H
 #define __ASM_ARCH_DM646X_H
 
-#include <mach/hardware.h>
-#include <mach/asp.h>
-#include <linux/i2c.h>
-#include <linux/videodev2.h>
-#include <linux/davinci_emac.h>
-#include <media/davinci/vpif_types.h>
-
-#define DM646X_ASYNC_EMIF_CONTROL_BASE	0x20008000
-#define DM646X_ASYNC_EMIF_CS2_SPACE_BASE 0x42000000
-
-void __init dm646x_init(void);
-void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
-void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
-int __init dm646x_init_edma(struct edma_rsv_info *rsv);
-
-void dm646x_video_init(void);
-
-void dm646x_setup_vpif(struct vpif_display_config *,
-		       struct vpif_capture_config *);
+#include <mach/davinci_common.h>
 
 #endif /* __ASM_ARCH_DM646X_H */
-- 
1.6.2.4

