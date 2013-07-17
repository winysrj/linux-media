Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60321 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3GQKJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 06:09:39 -0400
Received: by mail-pd0-f173.google.com with SMTP id v14so1672905pde.32
        for <linux-media@vger.kernel.org>; Wed, 17 Jul 2013 03:09:39 -0700 (PDT)
From: Show Liu <show.liu@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, tom.gall@linaro.org,
	pawel.moll@arm.com, t.katayama@jp.fujitsu.com,
	vikas.sajjan@linaro.org, linaro-kernel@lists.linaro.org,
	Show Liu <show.liu@linaro.org>
Subject: [PATCH 2/2] CDFv2 for VExpress HDLCD DVI output support
Date: Wed, 17 Jul 2013 18:08:57 +0800
Message-Id: <1374055737-6643-3-git-send-email-show.liu@linaro.org>
In-Reply-To: <1374055737-6643-1-git-send-email-show.liu@linaro.org>
References: <1374055737-6643-1-git-send-email-show.liu@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts |    6 +-
 drivers/video/arm-hdlcd.c                  |  116 +++++++++++++++++++++++++---
 drivers/video/vexpress-dvimode.c           |   11 +++
 drivers/video/vexpress-muxfpga.c           |    8 +-
 include/linux/arm-hdlcd.h                  |    6 ++
 5 files changed, 135 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index f1dc620..aeef32d 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -145,10 +145,14 @@
 		compatible = "arm,hdlcd";
 		reg = <0 0x2b000000 0 0x1000>;
 		interrupts = <0 85 4>;
-		mode = "1024x768-16@60";
 		framebuffer = <0 0xff000000 0 0x01000000>;
 		clocks = <&oscclk5>;
 		clock-names = "pxlclk";
+		label = "V2P-CA15_A7 HDLCD";
+		display = <&v2m_muxfpga 0xf>;
+        max-hactive = <1280>;
+        max-vactive = <1024>;
+        max-bpp = <16>;
 	};
 
 	memory-controller@2b0a0000 {
diff --git a/drivers/video/arm-hdlcd.c b/drivers/video/arm-hdlcd.c
index cfd631e..528239f 100644
--- a/drivers/video/arm-hdlcd.c
+++ b/drivers/video/arm-hdlcd.c
@@ -31,7 +31,8 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #endif
-
+#include <video/display.h>
+#include <video/videomode.h>
 #include "edid.h"
 
 #ifdef CONFIG_SERIAL_AMBA_PCU_UART
@@ -41,6 +42,8 @@ int get_edid(u8 *msgbuf);
 
 #define to_hdlcd_device(info)	container_of(info, struct hdlcd_device, fb)
 
+#define MAX_FB_MODE_NAME 128
+
 static struct of_device_id  hdlcd_of_matches[] = {
 	{ .compatible	= "arm,hdlcd" },
 	{},
@@ -129,12 +132,20 @@ static inline void hdlcd_enable(struct hdlcd_device *hdlcd)
 {
 	dev_dbg(hdlcd->dev, "HDLCD: output enabled\n");
 	writel(1, hdlcd->base + HDLCD_REG_COMMAND);
+
+	if (hdlcd->display)
+    display_entity_set_state( hdlcd->display,
+                              DISPLAY_ENTITY_STATE_ON);
 }
 
 static inline void hdlcd_disable(struct hdlcd_device *hdlcd)
 {
 	dev_dbg(hdlcd->dev, "HDLCD: output disabled\n");
 	writel(0, hdlcd->base + HDLCD_REG_COMMAND);
+
+	if (hdlcd->display)
+    display_entity_set_state(hdlcd->display,
+                             DISPLAY_ENTITY_STATE_OFF);
 }
 
 static int hdlcd_set_bitfields(struct hdlcd_device *hdlcd,
@@ -267,6 +278,13 @@ static int hdlcd_set_par(struct fb_info *info)
 
 	hdlcd_disable(hdlcd);
 
+	if(hdlcd->display) {
+        struct  videomode mode;
+
+        videomode_from_fb_var_screeninfo(&hdlcd->fb.var, &mode);
+        display_entity_update(hdlcd->display, &mode);
+    }
+
 	WRITE_HDLCD_REG(HDLCD_REG_FB_LINE_LENGTH, hdlcd->fb.var.xres * bytes_per_pixel);
 	WRITE_HDLCD_REG(HDLCD_REG_FB_LINE_PITCH, hdlcd->fb.var.xres * bytes_per_pixel);
 	WRITE_HDLCD_REG(HDLCD_REG_FB_LINE_COUNT, hdlcd->fb.var.yres - 1);
@@ -520,8 +538,8 @@ static int hdlcd_setup(struct hdlcd_device *hdlcd)
 
 	hdlcd->fb.var.nonstd		= 0;
 	hdlcd->fb.var.activate		= FB_ACTIVATE_NOW;
-	hdlcd->fb.var.height		= -1;
-	hdlcd->fb.var.width		= -1;
+	hdlcd->fb.var.height		= hdlcd->height;
+	hdlcd->fb.var.width		= hdlcd->width;
 	hdlcd->fb.var.accel_flags	= 0;
 
 	init_completion(&hdlcd->vsync_completion);
@@ -542,7 +560,7 @@ static int hdlcd_setup(struct hdlcd_device *hdlcd)
 		hdlcd->fb.monspecs.vfmin	= 0;
 		hdlcd->fb.monspecs.vfmax	= 400;
 		hdlcd->fb.monspecs.dclkmin	= 1000000;
-		hdlcd->fb.monspecs.dclkmax	= 100000000;
+		hdlcd->fb.monspecs.dclkmax	= 140000000;
 		fb_find_mode(&hdlcd->fb.var, &hdlcd->fb, fb_mode, NULL, 0, &hdlcd_default_mode, 32);
 	}
 
@@ -633,6 +651,75 @@ static int parse_edid_data(struct hdlcd_device *hdlcd, const u8 *edid_data, int
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static int hdlcd_of_init_display(struct hdlcd_device *hdlcd, struct device_node *of_node)
+{
+    int err, i;
+    int modes_num, best_mode = -1;
+    char    *mode_name;
+    const struct videomode *modes;
+
+    u32 max_bpp = 32;
+    u32 max_hactive = (u32)~0UL;
+    u32 max_vactive = (u32)~0UL;
+    unsigned int width, height;
+
+    /* get the display entity */
+    hdlcd->display = of_display_entity_get(of_node, 0);
+    if (hdlcd->display == NULL) {
+       dev_err( hdlcd->dev, "HDLCD: cannot get display entity\n");
+        return -EPROBE_DEFER;
+    }
+
+    /* get videomodes from display entity */
+    modes_num = display_entity_get_modes(hdlcd->display, &modes);
+    if (modes_num < 0) {
+        dev_err( hdlcd->dev, "HDLCD: cannot get videomode from display entity\n");
+        return modes_num;
+    }
+
+     /* Pick the "best" (the widest, then the highest) mode from the list */
+    of_property_read_u32(of_node, "max-hactive", &max_hactive);
+    of_property_read_u32(of_node, "max-vactive", &max_vactive);
+
+    for (i = 0; i < modes_num; i++) {
+        if (modes[i].hactive > max_hactive ||
+            modes[i].vactive > max_vactive)
+                continue;
+        if (best_mode < 0 ||(modes[i].hactive >= modes[best_mode].hactive &&
+            modes[i].vactive > modes[best_mode].vactive))
+                best_mode = i;
+    }
+
+    if (best_mode < 0)
+        return -ENODEV;
+
+    err = fb_videomode_from_videomode(&modes[best_mode], &hdlcd->mode);
+    if (err)
+        return err;
+
+    of_property_read_u32(of_node, "max-bpp", &max_bpp);
+
+
+    i = snprintf(NULL, 0, "%ux%u-%u@%u", hdlcd->mode.xres,
+                     hdlcd->mode.yres, max_bpp, hdlcd->mode.refresh);
+
+    mode_name = devm_kzalloc( hdlcd->dev, i + 1, GFP_KERNEL);
+    snprintf( mode_name, i + 1, "%ux%u-%u@%u", hdlcd->mode.xres,
+                     hdlcd->mode.yres, max_bpp, hdlcd->mode.refresh);
+
+    hdlcd->mode.name = mode_name;
+
+    if(display_entity_get_size(hdlcd->display, &width, &height) != 0)
+		width = height = 0;
+
+	hdlcd->width = width;
+	hdlcd->height = height;
+
+	return 0;
+}
+#endif
+
 static int hdlcd_probe(struct platform_device *pdev)
 {
 	int err = 0, i;
@@ -652,13 +739,22 @@ static int hdlcd_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_OF
 	of_node = pdev->dev.of_node;
-	if (of_node) {
-		int len;
+	hdlcd->dev = &pdev->dev;
+
+    /*initial display entity*/
+    err = hdlcd_of_init_display( hdlcd, of_node);
+    if(err < 0)
+		return err;
+
+    if (of_node) {
+		int len = strnlen(hdlcd->mode.name, MAX_FB_MODE_NAME);
 		const u8 *edid;
-		const __be32 *prop = of_get_property(of_node, "mode", &len);
-		if (prop)
+
+		const __be32 *prop = (__be32 *)hdlcd->mode.name;
+        if (prop)
 			strncpy(fb_mode, (char *)prop, len);
-		prop = of_get_property(of_node, "framebuffer", &len);
+
+		prop = of_get_property( of_node, "framebuffer", &len);
 		if (prop) {
 			hdlcd->fb.fix.smem_start = of_read_ulong(prop,
 					of_n_addr_cells(of_node));
@@ -669,7 +765,7 @@ static int hdlcd_probe(struct platform_device *pdev)
 				framebuffer_size = HDLCD_MAX_FRAMEBUFFER_SIZE;
 			dev_dbg(&pdev->dev, "HDLCD: phys_addr = 0x%lx, size = 0x%lx\n",
 				hdlcd->fb.fix.smem_start, framebuffer_size);
-		}
+        }
 		edid = of_get_property(of_node, "edid", &len);
 		if (edid) {
 			err = parse_edid_data(hdlcd, edid, len);
diff --git a/drivers/video/vexpress-dvimode.c b/drivers/video/vexpress-dvimode.c
index 85d5608..4b38765 100644
--- a/drivers/video/vexpress-dvimode.c
+++ b/drivers/video/vexpress-dvimode.c
@@ -115,10 +115,21 @@ static int vexpress_dvimode_display_get_params(struct display_entity *display,
 	return 0;
 }
 
+int vexpress_dvimode_display_get_size(struct display_entity *entity,
+		unsigned int *width, unsigned int *height)
+{
+
+  *width = -1;
+  *height = -1;
+
+  return 0;
+}
+
 static const struct display_entity_control_ops vexpress_dvimode_display_ops = {
 	.update = vexpress_dvimode_display_update,
 	.get_modes = vexpress_dvimode_display_get_modes,
 	.get_params = vexpress_dvimode_display_get_params,
+	.get_size = vexpress_dvimode_display_get_size,
 };
 
 static struct display_entity vexpress_dvimode_display = {
diff --git a/drivers/video/vexpress-muxfpga.c b/drivers/video/vexpress-muxfpga.c
index 1731ad0..c54e54d 100644
--- a/drivers/video/vexpress-muxfpga.c
+++ b/drivers/video/vexpress-muxfpga.c
@@ -121,17 +121,23 @@ static int vexpress_muxfpga_display_get_params(struct display_entity *display,
 	return display_entity_get_params(vexpress_muxfpga_output, params);
 }
 
+int vexpress_muxfpga_display_get_size(struct display_entity *entity,
+		unsigned int *width, unsigned int *height)
+{
+	return display_entity_get_size(vexpress_muxfpga_output, width, height);
+}
+
 static const struct display_entity_control_ops vexpress_muxfpga_display_ops = {
 	.update = vexpress_muxfpga_display_update,
 	.get_modes = vexpress_muxfpga_display_get_modes,
 	.get_params = vexpress_muxfpga_display_get_params,
+	.get_size = vexpress_muxfpga_display_get_size,
 };
 
 
 static ssize_t vexpress_muxfpga_show_source(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-
 	return sprintf(buf, "%u\n", vexpress_muxfpga_source_site);
 }
 
diff --git a/include/linux/arm-hdlcd.h b/include/linux/arm-hdlcd.h
index 939f3a8..79b6285 100644
--- a/include/linux/arm-hdlcd.h
+++ b/include/linux/arm-hdlcd.h
@@ -12,6 +12,7 @@
 
 #include <linux/fb.h>
 #include <linux/completion.h>
+#include <video/display.h>
 
 /* register offsets */
 #define HDLCD_REG_VERSION		0x0000	/* ro */
@@ -119,4 +120,9 @@ struct hdlcd_device {
 	int			irq;
 	struct completion	vsync_completion;
 	unsigned char		*edid;
+
+	unsigned int width;
+	unsigned int height;
+	struct display_entity   *display;
+	struct fb_videomode     mode;
 };
-- 
1.7.9.5

