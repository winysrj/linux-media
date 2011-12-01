Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37096 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab1LAAPR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 19:15:17 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@iki.fi>, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v2 05/11] OMAP4: Add base addresses for ISS
Date: Wed, 30 Nov 2011 18:14:54 -0600
Message-ID: <1322698500-29924-6-git-send-email-saaguirre@ti.com>
In-Reply-To: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NOTE: This isn't the whole list of features that the
ISS supports, but the only ones supported at the moment.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/devices.c              |   32 ++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/omap44xx.h |    9 +++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c15cfad..b48aeea 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -32,6 +32,7 @@
 #include <plat/omap_hwmod.h>
 #include <plat/omap_device.h>
 #include <plat/omap4-keypad.h>
+#include <plat/omap4-iss.h>
 
 #include "mux.h"
 #include "control.h"
@@ -217,6 +218,37 @@ int omap3_init_camera(struct isp_platform_data *pdata)
 	return platform_device_register(&omap3isp_device);
 }
 
+int omap4_init_camera(struct iss_platform_data *pdata, struct omap_board_data *bdata)
+{
+	struct platform_device *pdev;
+	struct omap_hwmod *oh;
+	struct iss_platform_data *omap4iss_pdata;
+	char *oh_name = "iss";
+	char *name = "omap4iss";
+	unsigned int id = -1;
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh) {
+		pr_err("Could not look up %s\n", oh_name);
+		return -ENODEV;
+	}
+
+	omap4iss_pdata = pdata;
+
+	pdev = omap_device_build(name, id, oh, omap4iss_pdata,
+			sizeof(struct iss_platform_data), NULL, 0, 0);
+
+	if (IS_ERR(pdev)) {
+		WARN(1, "Can't build omap_device for %s:%s.\n",
+						name, oh->name);
+		return PTR_ERR(pdev);
+	}
+
+	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
+
+	return 0;
+}
+
 static inline void omap_init_camera(void)
 {
 #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
diff --git a/arch/arm/plat-omap/include/plat/omap44xx.h b/arch/arm/plat-omap/include/plat/omap44xx.h
index ea2b8a6..31432aa 100644
--- a/arch/arm/plat-omap/include/plat/omap44xx.h
+++ b/arch/arm/plat-omap/include/plat/omap44xx.h
@@ -49,6 +49,15 @@
 #define OMAP44XX_MAILBOX_BASE		(L4_44XX_BASE + 0xF4000)
 #define OMAP44XX_HSUSB_OTG_BASE		(L4_44XX_BASE + 0xAB000)
 
+#define OMAP44XX_ISS_BASE			0x52000000
+#define OMAP44XX_ISS_TOP_BASE			(OMAP44XX_ISS_BASE + 0x0)
+#define OMAP44XX_ISS_CSI2_A_REGS1_BASE		(OMAP44XX_ISS_BASE + 0x1000)
+#define OMAP44XX_ISS_CAMERARX_CORE1_BASE	(OMAP44XX_ISS_BASE + 0x1170)
+
+#define OMAP44XX_ISS_TOP_END			(OMAP44XX_ISS_TOP_BASE + 256 - 1)
+#define OMAP44XX_ISS_CSI2_A_REGS1_END		(OMAP44XX_ISS_CSI2_A_REGS1_BASE + 368 - 1)
+#define OMAP44XX_ISS_CAMERARX_CORE1_END		(OMAP44XX_ISS_CAMERARX_CORE1_BASE + 32 - 1)
+
 #define OMAP4_MMU1_BASE			0x55082000
 #define OMAP4_MMU2_BASE			0x4A066000
 
-- 
1.7.7.4

