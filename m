Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1BNMVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 03/10] omap3: Add function to register omap3isp platform device structure
Date: Mon, 14 Feb 2011 13:21:30 +0100
Message-Id: <1297686097-9804-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The omap3isp platform device requires platform data. Instead of
registering the device in omap2_init_devices(), export an
omap3_init_camera() function to fill the device structure with the
platform data pointer and register the device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c |   20 +++++++++++---------
 arch/arm/mach-omap2/devices.h |   17 +++++++++++++++++
 2 files changed, 28 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/mach-omap2/devices.h

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index d389756..4cf48ea 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -34,6 +34,8 @@
 #include "mux.h"
 #include "control.h"
 
+#include "devices.h"
+
 #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
 
 static struct resource cam_resources[] = {
@@ -59,8 +61,11 @@ static inline void omap_init_camera(void)
 {
 	platform_device_register(&omap_cam_device);
 }
-
-#elif defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
+#else
+static inline void omap_init_camera(void)
+{
+}
+#endif
 
 static struct resource omap3isp_resources[] = {
 	{
@@ -146,15 +151,12 @@ static struct platform_device omap3isp_device = {
 	.resource	= omap3isp_resources,
 };
 
-static inline void omap_init_camera(void)
-{
-	platform_device_register(&omap3isp_device);
-}
-#else
-static inline void omap_init_camera(void)
+int omap3_init_camera(void *pdata)
 {
+	omap3isp_device.dev.platform_data = pdata;
+	return platform_device_register(&omap3isp_device);
 }
-#endif
+EXPORT_SYMBOL_GPL(omap3_init_camera);
 
 #if defined(CONFIG_OMAP_MBOX_FWK) || defined(CONFIG_OMAP_MBOX_FWK_MODULE)
 
diff --git a/arch/arm/mach-omap2/devices.h b/arch/arm/mach-omap2/devices.h
new file mode 100644
index 0000000..12ddb8a
--- /dev/null
+++ b/arch/arm/mach-omap2/devices.h
@@ -0,0 +1,17 @@
+/*
+ * arch/arm/mach-omap2/devices.h
+ *
+ * OMAP2 platform device setup/initialization
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ARCH_ARM_MACH_OMAP_DEVICES_H
+#define __ARCH_ARM_MACH_OMAP_DEVICES_H
+
+int omap3_init_camera(void *pdata);
+
+#endif
-- 
1.7.3.4

