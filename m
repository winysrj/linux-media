Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56918 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2KVSjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:39:48 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: "Rob Herring" <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Guennady Liakhovetski" <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	"Florian Tobias Schandinat" <FlorianSchandinat@gmx.de>,
	"David Airlie" <airlied@linux.ie>
Subject: [PATCHv13 1/7] viafb: rename display_timing to via_display_timing
Date: Thu, 22 Nov 2012 17:00:09 +0100
Message-Id: <1353600015-6974-2-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353600015-6974-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1353600015-6974-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct display_timing is specific to the via subsystem. The naming leads to
collisions with the new struct display_timing, that is supposed to be a shared
struct between different subsystems.
To clean this up, prepend the existing struct with the subsystem it is specific
to.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/video/via/hw.c              |    6 +++---
 drivers/video/via/hw.h              |    2 +-
 drivers/video/via/lcd.c             |    2 +-
 drivers/video/via/share.h           |    2 +-
 drivers/video/via/via_modesetting.c |    8 ++++----
 drivers/video/via/via_modesetting.h |    6 +++---
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 898590d..5563c67 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1467,10 +1467,10 @@ void viafb_set_vclock(u32 clk, int set_iga)
 	via_write_misc_reg_mask(0x0C, 0x0C); /* select external clock */
 }
 
-struct display_timing var_to_timing(const struct fb_var_screeninfo *var,
+struct via_display_timing var_to_timing(const struct fb_var_screeninfo *var,
 	u16 cxres, u16 cyres)
 {
-	struct display_timing timing;
+	struct via_display_timing timing;
 	u16 dx = (var->xres - cxres) / 2, dy = (var->yres - cyres) / 2;
 
 	timing.hor_addr = cxres;
@@ -1491,7 +1491,7 @@ struct display_timing var_to_timing(const struct fb_var_screeninfo *var,
 void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var,
 	u16 cxres, u16 cyres, int iga)
 {
-	struct display_timing crt_reg = var_to_timing(var,
+	struct via_display_timing crt_reg = var_to_timing(var,
 		cxres ? cxres : var->xres, cyres ? cyres : var->yres);
 
 	if (iga == IGA1)
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 6be243c..c3f2572 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -637,7 +637,7 @@ extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
 
-struct display_timing var_to_timing(const struct fb_var_screeninfo *var,
+struct via_display_timing var_to_timing(const struct fb_var_screeninfo *var,
 	u16 cxres, u16 cyres);
 void viafb_fill_crtc_timing(const struct fb_var_screeninfo *var,
 	u16 cxres, u16 cyres, int iga);
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 1650379..022b0df 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -549,7 +549,7 @@ void viafb_lcd_set_mode(const struct fb_var_screeninfo *var, u16 cxres,
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
 	u32 clock;
-	struct display_timing timing;
+	struct via_display_timing timing;
 	struct fb_var_screeninfo panel_var;
 	const struct fb_videomode *mode_crt_table, *panel_crt_table;
 
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 3158dfc..65c65c6 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -319,7 +319,7 @@ struct crt_mode_table {
 	int refresh_rate;
 	int h_sync_polarity;
 	int v_sync_polarity;
-	struct display_timing crtc;
+	struct via_display_timing crtc;
 };
 
 struct io_reg {
diff --git a/drivers/video/via/via_modesetting.c b/drivers/video/via/via_modesetting.c
index 0e431ae..0b414b0 100644
--- a/drivers/video/via/via_modesetting.c
+++ b/drivers/video/via/via_modesetting.c
@@ -30,9 +30,9 @@
 #include "debug.h"
 
 
-void via_set_primary_timing(const struct display_timing *timing)
+void via_set_primary_timing(const struct via_display_timing *timing)
 {
-	struct display_timing raw;
+	struct via_display_timing raw;
 
 	raw.hor_total = timing->hor_total / 8 - 5;
 	raw.hor_addr = timing->hor_addr / 8 - 1;
@@ -88,9 +88,9 @@ void via_set_primary_timing(const struct display_timing *timing)
 	via_write_reg_mask(VIACR, 0x17, 0x80, 0x80);
 }
 
-void via_set_secondary_timing(const struct display_timing *timing)
+void via_set_secondary_timing(const struct via_display_timing *timing)
 {
-	struct display_timing raw;
+	struct via_display_timing raw;
 
 	raw.hor_total = timing->hor_total - 1;
 	raw.hor_addr = timing->hor_addr - 1;
diff --git a/drivers/video/via/via_modesetting.h b/drivers/video/via/via_modesetting.h
index 06e09fe..f6a6503 100644
--- a/drivers/video/via/via_modesetting.h
+++ b/drivers/video/via/via_modesetting.h
@@ -33,7 +33,7 @@
 #define VIA_PITCH_MAX	0x3FF8
 
 
-struct display_timing {
+struct via_display_timing {
 	u16 hor_total;
 	u16 hor_addr;
 	u16 hor_blank_start;
@@ -49,8 +49,8 @@ struct display_timing {
 };
 
 
-void via_set_primary_timing(const struct display_timing *timing);
-void via_set_secondary_timing(const struct display_timing *timing);
+void via_set_primary_timing(const struct via_display_timing *timing);
+void via_set_secondary_timing(const struct via_display_timing *timing);
 void via_set_primary_address(u32 addr);
 void via_set_secondary_address(u32 addr);
 void via_set_primary_pitch(u32 pitch);
-- 
1.7.10.4

