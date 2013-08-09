Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54864 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031468Ab3HIXCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 16/19] ARM: shmobile: marzen: Port DU platform data to CDF
Date: Sat, 10 Aug 2013 01:03:15 +0200
Message-Id: <1376089398-13322-17-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/mach-shmobile/board-marzen.c | 77 ++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-marzen.c b/arch/arm/mach-shmobile/board-marzen.c
index 6499f1a..be1b7cb 100644
--- a/arch/arm/mach-shmobile/board-marzen.c
+++ b/arch/arm/mach-shmobile/board-marzen.c
@@ -39,6 +39,8 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sh_mobile_sdhi.h>
 #include <linux/mfd/tmio.h>
+#include <video/panel-dpi.h>
+#include <video/videomode.h>
 #include <mach/r8a7779.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
@@ -174,35 +176,56 @@ static struct platform_device hspi_device = {
  * The panel only specifies the [hv]display and [hv]total values. The position
  * and width of the sync pulses don't matter, they're copied from VESA timings.
  */
-static struct rcar_du_encoder_data du_encoders[] = {
+static const struct videomode marzen_panel_mode = {
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
+static const struct panel_dpi_platform_data marzen_panel_data = {
+	.width = 210,
+	.height = 158,
+	.mode = &marzen_panel_mode,
+};
+
+static const struct display_entity_graph_data marzen_du_entities[] = {
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
-		.type = RCAR_DU_ENCODER_LVDS,
-		.output = RCAR_DU_OUTPUT_DPAD1,
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
+				.port = 1,
+			},
+		},
+	}, {
 	},
 };
 
-static const struct rcar_du_platform_data du_pdata __initconst = {
-	.encoders = du_encoders,
-	.num_encoders = ARRAY_SIZE(du_encoders),
+static const struct rcar_du_platform_data marzen_du_pdata __initconst = {
+	.graph = marzen_du_entities,
 };
 
 static const struct resource du_resources[] __initconst = {
@@ -217,8 +240,8 @@ static void __init marzen_add_du_device(void)
 		.id = -1,
 		.res = du_resources,
 		.num_res = ARRAY_SIZE(du_resources),
-		.data = &du_pdata,
-		.size_data = sizeof(du_pdata),
+		.data = &marzen_du_pdata,
+		.size_data = sizeof(marzen_du_pdata),
 		.dma_mask = DMA_BIT_MASK(32),
 	};
 
@@ -327,6 +350,12 @@ static void __init marzen_init(void)
 	r8a7779_add_standard_devices();
 	platform_add_devices(marzen_devices, ARRAY_SIZE(marzen_devices));
 	marzen_add_du_device();
+
+	platform_device_register_simple("adv7123", -1, NULL, 0);
+	platform_device_register_simple("con-vga", -1, NULL, 0);
+	platform_device_register_data(&platform_bus, "panel-dpi", -1,
+				      &marzen_panel_data,
+				      sizeof(marzen_panel_data));
 }
 
 static const char *marzen_boards_compat_dt[] __initdata = {
-- 
1.8.1.5

