Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36476 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab0G2QHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 12:07:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v3 10/12] omap3: Export omap3isp platform device structure
Date: Thu, 29 Jul 2010 18:06:54 +0200
Message-Id: <1280419616-7658-22-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stanimir Varbanov <svarbanov@mm-sol.com>

omap3isp platform device structure pointer is needed from camera board
files for subdevs registration and calls.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 arch/arm/mach-omap2/devices.c |    5 ++++-
 arch/arm/mach-omap2/devices.h |   17 +++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-omap2/devices.h

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 46b0b4b..ae465ce 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -32,6 +32,8 @@
 
 #include "mux.h"
 
+#include "devices.h"
+
 #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
 
 static struct resource cam_resources[] = {
@@ -142,12 +144,13 @@ static struct resource omap3isp_resources[] = {
 	}
 };
 
-static struct platform_device omap3isp_device = {
+struct platform_device omap3isp_device = {
 	.name		= "omap3isp",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(omap3isp_resources),
 	.resource	= omap3isp_resources,
 };
+EXPORT_SYMBOL_GPL(omap3isp_device);
 
 static inline void omap_init_camera(void)
 {
diff --git a/arch/arm/mach-omap2/devices.h b/arch/arm/mach-omap2/devices.h
new file mode 100644
index 0000000..f312d49
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
+extern struct platform_device omap3isp_device;
+
+#endif
-- 
1.7.1

