Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031471Ab3HIXCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 17/19] ARM: shmobile: lager: Port DU platform data to CDF
Date: Sat, 10 Aug 2013 01:03:16 +0200
Message-Id: <1376089398-13322-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/mach-shmobile/board-lager.c | 76 +++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
index 75a01bc..d61b892 100644
--- a/arch/arm/mach-shmobile/board-lager.c
+++ b/arch/arm/mach-shmobile/board-lager.c
@@ -33,6 +33,8 @@
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
 #include <linux/sh_eth.h>
+#include <video/panel-dpi.h>
+#include <video/videomode.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/r8a7790.h>
@@ -40,35 +42,56 @@
 #include <asm/mach/arch.h>
 
 /* DU */
-static struct rcar_du_encoder_data lager_du_encoders[] = {
+static const struct videomode lager_panel_mode = {
+	.pixelclock = 65000000,
+	.hactive = 1024,
+	.hfront_porch = 24,
+	.hback_porch = 160,
+	.hsync_len = 136,
+	.vactive = 768,
+	.vfront_porch = 3,
+	.vback_porch = 29,
+	.vsync_len = 6,
+	.flags = DISPLAY_FLAGS_HSYNC_LOW | DISPLAY_FLAGS_VSYNC_LOW,
+};
+
+static const struct panel_dpi_platform_data lager_panel_data = {
+	.width = 210,
+	.height = 158,
+	.mode = &lager_panel_mode,
+};
+
+static const struct display_entity_graph_data lager_du_entities[] = {
 	{
-		.type = RCAR_DU_ENCODER_VGA,
-		.output = RCAR_DU_OUTPUT_DPAD0,
+		.name = "adv7123",
+		.sources = (const struct display_entity_source_data[]) {
+			{
+				.name = "rcar-du",
+				.port = 0,
+			},
+		},
 	}, {
-		.type = RCAR_DU_ENCODER_NONE,
-		.output = RCAR_DU_OUTPUT_LVDS1,
-		.connector.lvds.panel = {
-			.width_mm = 210,
-			.height_mm = 158,
-			.mode = {
-				.clock = 65000,
-				.hdisplay = 1024,
-				.hsync_start = 1048,
-				.hsync_end = 1184,
-				.htotal = 1344,
-				.vdisplay = 768,
-				.vsync_start = 771,
-				.vsync_end = 777,
-				.vtotal = 806,
-				.flags = 0,
+		.name = "con-vga",
+		.sources = (const struct display_entity_source_data[]) {
+			{
+				.name = "adv7123",
+				.port = 1,
 			},
 		},
+	}, {
+		.name = "panel-dpi",
+		.sources = (const struct display_entity_source_data[]) {
+			{
+				.name = "rcar-du",
+				.port = 2,
+			},
+		},
+	}, {
 	},
 };
 
 static const struct rcar_du_platform_data lager_du_pdata __initconst = {
-	.encoders = lager_du_encoders,
-	.num_encoders = ARRAY_SIZE(lager_du_encoders),
+	.graph = lager_du_entities,
 };
 
 static const struct resource du_resources[] __initconst = {
@@ -87,8 +110,8 @@ static void __init lager_add_du_device(void)
 		.id = -1,
 		.res = du_resources,
 		.num_res = ARRAY_SIZE(du_resources),
-		.data = &du_resources,
-		.size_data = sizeof(du_resources),
+		.data = &lager_du_pdata,
+		.size_data = sizeof(lager_du_pdata),
 		.dma_mask = DMA_BIT_MASK(32),
 	};
 
@@ -202,6 +225,7 @@ static void __init lager_add_standard_devices(void)
 	r8a7790_pinmux_init();
 
 	r8a7790_add_standard_devices();
+
 	platform_device_register_data(&platform_bus, "leds-gpio", -1,
 				      &lager_leds_pdata,
 				      sizeof(lager_leds_pdata));
@@ -220,6 +244,12 @@ static void __init lager_add_standard_devices(void)
 					  &ether_pdata, sizeof(ether_pdata));
 
 	lager_add_du_device();
+
+	platform_device_register_simple("adv7123", -1, NULL, 0);
+	platform_device_register_simple("con-vga", -1, NULL, 0);
+	platform_device_register_data(&platform_bus, "panel-dpi", -1,
+				      &lager_panel_data,
+				      sizeof(lager_panel_data));
 }
 
 static const char * const lager_boards_compat_dt[] __initconst = {
-- 
1.8.1.5

