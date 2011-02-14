Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1BNMVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 04/10] omap2: Fix camera resources for multiomap
Date: Mon, 14 Feb 2011 13:21:31 +0100
Message-Id: <1297686097-9804-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sergio Aguirre <saaguirre@ti.com>

Make sure the kernel can be compiled with both OMAP2 and OMAP3 camera
support linked in, and give public symbols proper omap2/omap3 prefixes.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 4cf48ea..5d844bd 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -38,7 +38,7 @@
 
 #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
 
-static struct resource cam_resources[] = {
+static struct resource omap2cam_resources[] = {
 	{
 		.start		= OMAP24XX_CAMERA_BASE,
 		.end		= OMAP24XX_CAMERA_BASE + 0xfff,
@@ -50,21 +50,12 @@ static struct resource cam_resources[] = {
 	}
 };
 
-static struct platform_device omap_cam_device = {
+static struct platform_device omap2cam_device = {
 	.name		= "omap24xxcam",
 	.id		= -1,
-	.num_resources	= ARRAY_SIZE(cam_resources),
-	.resource	= cam_resources,
+	.num_resources	= ARRAY_SIZE(omap2cam_resources),
+	.resource	= omap2cam_resources,
 };
-
-static inline void omap_init_camera(void)
-{
-	platform_device_register(&omap_cam_device);
-}
-#else
-static inline void omap_init_camera(void)
-{
-}
 #endif
 
 static struct resource omap3isp_resources[] = {
@@ -158,6 +149,14 @@ int omap3_init_camera(void *pdata)
 }
 EXPORT_SYMBOL_GPL(omap3_init_camera);
 
+static inline void omap_init_camera(void)
+{
+#if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
+	if (cpu_is_omap24xx())
+		platform_device_register(&omap2cam_device);
+#endif
+}
+
 #if defined(CONFIG_OMAP_MBOX_FWK) || defined(CONFIG_OMAP_MBOX_FWK_MODULE)
 
 #define MBOX_REG_SIZE   0x120
-- 
1.7.3.4

