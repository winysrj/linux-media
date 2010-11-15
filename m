Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:38534 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab0KOOaB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:30:01 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp][PATCH v2 2/9] omap3: Fix camera resources for multiomap
Date: Mon, 15 Nov 2010 08:29:54 -0600
Message-Id: <1289831401-593-3-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289831401-593-1-git-send-email-saaguirre@ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/devices.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c2275d3..c9fc732 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -38,7 +38,7 @@
 
 #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
 
-static struct resource cam_resources[] = {
+static struct resource omap2cam_resources[] = {
 	{
 		.start		= OMAP24XX_CAMERA_BASE,
 		.end		= OMAP24XX_CAMERA_BASE + 0xfff,
@@ -50,19 +50,15 @@ static struct resource cam_resources[] = {
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
+#endif
 
-static inline void omap_init_camera(void)
-{
-	platform_device_register(&omap_cam_device);
-}
-
-#elif defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
+#if defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
 
 static struct resource omap3isp_resources[] = {
 	{
@@ -165,15 +161,16 @@ struct platform_device omap3isp_device = {
 	},
 };
 EXPORT_SYMBOL_GPL(omap3isp_device);
+#endif
 
 static inline void omap_init_camera(void)
 {
-}
-#else
-static inline void omap_init_camera(void)
-{
-}
+#if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
+	if (cpu_is_omap24xx())
+		platform_device_register(&omap2cam_device);
 #endif
+}
+
 
 #if defined(CONFIG_OMAP_MBOX_FWK) || defined(CONFIG_OMAP_MBOX_FWK_MODULE)
 
-- 
1.7.0.4

