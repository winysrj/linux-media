Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39462 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab2IXPgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 11:36:55 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: =?UTF-8?q?=5BPATCH=201/2=5D=20of=3A=20add=20helper=20to=20parse=20display=20specs?=
Date: Mon, 24 Sep 2012 17:35:23 +0200
Message-Id: <1348500924-8551-2-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1348500924-8551-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1348500924-8551-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parse a display-node with timings and hardware-specs from devictree.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 Documentation/devicetree/bindings/video/display |  208 +++++++++++++++++++++++
 drivers/of/Kconfig                              |    5 +
 drivers/of/Makefile                             |    1 +
 drivers/of/of_display.c                         |  157 +++++++++++++++++
 include/linux/display.h                         |   85 +++++++++
 include/linux/of_display.h                      |   15 ++
 6 files changed, 471 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/display
 create mode 100644 drivers/of/of_display.c
 create mode 100644 include/linux/display.h
 create mode 100644 include/linux/of_display.h

diff --git a/Documentation/devicetree/bindings/video/display b/Documentation/devicetree/bindings/video/display
new file mode 100644
index 0000000..722766a
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/display
@@ -0,0 +1,208 @@
+display bindings
+==================
+
+display-node
+------------
+
+required properties:
+ - none
+
+optional properties:
+ - default-timing: the default timing value
+ - width-mm, height-mm: Display dimensions in mm
+ - hsync-active-high (bool): Hsync pulse is active high
+ - vsync-active-high (bool): Vsync pulse is active high
+ - de-active-high (bool): Data-Enable pulse is active high
+ - pixelclk-inverted (bool): pixelclock is inverted
+ - pixel-per-clk
+ - link-width: number of channels (e.g. LVDS)
+ - bpp: bits-per-pixel
+
+timings-subnode
+---------------
+
+required properties:
+subnodes that specify
+ - hactive, vactive: Display resolution
+ - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
+   in pixels
+   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
+   lines
+ - clock: displayclock in Hz
+
+There are different ways of describing a display and its capabilities. The devicetree
+representation corresponds to the one commonly found in datasheets for displays.
+The description of the display and its timing is split in two parts: first the display
+properties like size in mm and (optionally) multiple subnodes with the supported timings.
+If a display supports multiple signal timings, the default-timing can be specified.
+
+Example:
+
+	display@0 {
+		width-mm = <800>;
+		height-mm = <480>;
+		default-timing = <&timing0>;
+		timings {
+			timing0: timing@0 {
+				/* 1920x1080p24 */
+				clock = <52000000>;
+				hactive = <1920>;
+				vactive = <1080>;
+				hfront-porch = <25>;
+				hback-porch = <25>;
+				hsync-len = <25>;
+				vback-porch = <2>;
+				vfront-porch = <2>;
+				vsync-len = <2>;
+				hsync-active-high;
+			};
+		};
+	};
+
+Every property also supports the use of ranges, so the commonly used datasheet
+description with <min typ max>-tuples can be used.
+
+Example:
+
+	timing1: timing@1 {
+		/* 1920x1080p24 */
+		clock = <148500000>;
+		hactive = <1920>;
+		vactive = <1080>;
+		hsync-len = <0 44 60>;
+		hfront-porch = <80 88 95>;
+		hback-porch = <100 148 160>;
+		vfront-porch = <0 4 6>;
+		vback-porch = <0 36 50>;
+		vsync-len = <0 5 6>;
+	};
+
+The "display"-property in a connector-node (e.g. hdmi, ldb,...) is used to connect
+the display to that driver. 
+of_display expects a phandle, that specifies the display-node, in that property.
+
+Example:
+
+	hdmi@00120000 {
+		status = "okay";
+		display = <&acme>;
+	};
+
+Usage in backend
+================
+
+A backend driver may choose to use the display directly and convert the timing
+ranges to a suitable mode. Or it may just use the conversion of the display timings
+to the required mode via the generic videomode struct.
+
+					dtb
+					 |
+					 |  of_get_display
+					 ↓
+				   struct display
+					 |
+					 |  videomode_from_timings
+					 ↓
+			    ---  struct videomode ---
+			    |			    |
+ videomode_to_displaymode   |			    |   videomode_to_fb_videomode
+		            ↓			    ↓
+		     drm_display_mode         fb_videomode
+
+
+Conversion to videomode
+=======================
+
+As device drivers normally work with some kind of video mode, the timings can be
+converted (may be just a simple copying of the typical value) to a generic videomode
+structure which then can be converted to the according mode used by the backend.
+
+Supported modes
+===============
+
+The generic videomode read in by the driver can be converted to the following
+modes with the following parameters
+
+struct fb_videomode
+===================
+
+  +----------+---------------------------------------------+----------+-------+
+  |          |                ↑                            |          |       |
+  |          |                |upper_margin                |          |       |
+  |          |                ↓                            |          |       |
+  +----------###############################################----------+-------+
+  |          #                ↑                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |   left   #                |                            #  right   | hsync |
+  |  margin  #                |       xres                 #  margin  |  len  |
+  |<-------->#<---------------+--------------------------->#<-------->|<----->|
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |yres                        #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                |                            #          |       |
+  |          #                ↓                            #          |       |
+  +----------###############################################----------+-------+
+  |          |                ↑                            |          |       |
+  |          |                |lower_margin                |          |       |
+  |          |                ↓                            |          |       |
+  +----------+---------------------------------------------+----------+-------+
+  |          |                ↑                            |          |       |
+  |          |                |vsync_len                   |          |       |
+  |          |                ↓                            |          |       |
+  +----------+---------------------------------------------+----------+-------+
+
+clock in nanoseconds
+
+struct drm_display_mode
+=======================
+
+  +----------+---------------------------------------------+----------+-------+
+  |          |                                             |          |       |  ↑
+  |          |                                             |          |       |  |
+  |          |                                             |          |       |  |
+  +----------###############################################----------+-------+  |
+  |          #   ↑         ↑          ↑                    #          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |       hdisplay     #          |       |  |
+  |          #<--+--------------------+------------------->#          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |vsync_start         |                    #          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |vsync_end |                    #          |       |  |
+  |          #   |         |          |vdisplay            #          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |                    #          |       |  | vtotal
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |     hsync_start    #          |       |  |
+  |          #<--+---------+----------+------------------------------>|       |  |
+  |          #   |         |          |                    #          |       |  |
+  |          #   |         |          |     hsync_end      #          |       |  |
+  |          #<--+---------+----------+-------------------------------------->|  |
+  |          #   |         |          ↓                    #          |       |  |
+  +----------####|#########|################################----------+-------+  |
+  |          |   |         |                               |          |       |  |
+  |          |   |         |                               |          |       |  |
+  |          |   ↓         |                               |          |       |  |
+  +----------+-------------+-------------------------------+----------+-------+  |
+  |          |             |                               |          |       |  |
+  |          |             |                               |          |       |  |
+  |          |             ↓                               |          |       |  ↓
+  +----------+---------------------------------------------+----------+-------+
+                                   htotal
+   <------------------------------------------------------------------------->
+
+clock in kilohertz
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index dfba3e6..a4e3074 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -83,4 +83,9 @@ config OF_MTD
 	depends on MTD
 	def_bool y
 
+config OF_DISPLAY
+	def_bool y
+	help
+	  helper to parse displays from the devicetree
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index e027f44..0756bee 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
+obj-$(CONFIG_OF_DISPLAY) += of_display.o
diff --git a/drivers/of/of_display.c b/drivers/of/of_display.c
new file mode 100644
index 0000000..632a351
--- /dev/null
+++ b/drivers/of/of_display.c
@@ -0,0 +1,157 @@
+/*
+ * OF helpers for parsing display timings
+ * 
+ * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
+ * 
+ * based on of_videomode.c by Sascha Hauer <s.hauer@pengutronix.de>
+ *
+ * This file is released under the GPLv2
+ */
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/display.h>
+#include <linux/of_display.h>
+#include <linux/fb.h>
+
+/* every signal_timing can be specified with either
+ * just the typical value or a range consisting of
+ * min/typ/max.
+ * This function helps handling this
+ */
+static int of_display_parse_property(struct device_node *np, char *name,
+				struct timing_entry *result)
+{
+	struct property *prop;
+	int length;
+	int cells;
+	int ret;
+
+	prop = of_find_property(np, name, &length);
+	if (!prop) {
+		pr_err("%s: could not find property %s\n", __func__,
+			name);
+		return -EINVAL;
+	}
+
+	cells = length / sizeof(u32);
+
+	if (cells == 1)
+		ret = of_property_read_u32_array(np, name, &result->typ, cells);
+	else if (cells == 3)
+		ret = of_property_read_u32_array(np, name, &result->min, cells);
+	else {
+		pr_err("%s: illegal timing specification in %s\n", __func__,
+			name);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+struct display *of_get_display(struct device_node *np)
+{
+	struct device_node *display_np;
+	struct device_node *timing_np;
+	struct device_node *timings;
+	struct display *disp;
+	char *default_timing;
+
+	if (!np) {
+		pr_err("%s: no devicenode given\n", __func__);
+		return NULL;
+	}
+
+	display_np = of_parse_phandle(np, "display", 0);
+
+	if (!display_np) {
+		pr_err("%s: could not find display node\n", __func__);
+		return NULL;
+	}
+
+	disp = kmalloc(sizeof(struct display *), GFP_KERNEL);
+
+	memset(disp, 0, sizeof(struct display *));
+
+	of_property_read_u32(display_np, "width-mm", &disp->width_mm);
+	of_property_read_u32(display_np, "height-mm", &disp->height_mm);
+
+	timing_np = of_parse_phandle(display_np, "default-timing", 0);
+
+	if (!timing_np) {
+		pr_info("%s: no default-timing specified\n", __func__);
+		timing_np = of_find_node_by_name(np, "timing");
+	}
+
+	if (!timing_np) {
+		pr_info("%s: no timing specifications given\n", __func__);
+		return disp;
+	}
+
+	default_timing = (char *)timing_np->full_name;
+
+	timings = of_find_node_by_name(np, "timings");
+
+	disp->num_timings = 0;
+
+	disp->timings = kmalloc(sizeof(struct signal_timing *), GFP_KERNEL);
+
+	for_each_child_of_node(timings, timing_np) {
+		struct signal_timing *st;
+		int ret;
+
+		st = kmalloc(sizeof(struct signal_timing *), GFP_KERNEL);
+		disp->timings[disp->num_timings] = kmalloc(sizeof(struct signal_timing *), GFP_KERNEL);
+
+		ret |= of_display_parse_property(timing_np, "hback-porch", &st->hback_porch);
+		ret |= of_display_parse_property(timing_np, "hfront-porch", &st->hfront_porch);
+		ret |= of_display_parse_property(timing_np, "hactive", &st->hactive);
+		ret |= of_display_parse_property(timing_np, "hsync-len", &st->hsync_len);
+		ret |= of_display_parse_property(timing_np, "vback-porch", &st->vback_porch);
+		ret |= of_display_parse_property(timing_np, "vfront-porch", &st->vfront_porch);
+		ret |= of_display_parse_property(timing_np, "vactive", &st->vactive);
+		ret |= of_display_parse_property(timing_np, "vsync-len", &st->vsync_len);
+		ret |= of_display_parse_property(timing_np, "clock", &st->pixelclock);
+
+		if (strcmp(default_timing, timing_np->full_name) == 0)
+			disp->default_timing = disp->num_timings;
+
+		disp->timings[disp->num_timings] = st;
+		disp->num_timings++;
+	}
+
+	disp->vsync_pol_active_high = of_property_read_bool(display_np, "vsync-active-high");
+	disp->hsync_pol_active_high = of_property_read_bool(display_np, "hsync-active-high");
+	disp->de_pol_active_high = of_property_read_bool(display_np, "de-active-high");
+	disp->pixelclk_pol_inverted = of_property_read_bool(display_np, "pixelclk-inverted");
+	of_property_read_u32(display_np, "pixel-per-clk", &disp->if_pixel_per_clk);
+	of_property_read_u32(display_np, "link-width", &disp->if_link_width);
+	of_property_read_u32(display_np, "bpp", &disp->if_bpp);
+
+
+	pr_info("%s: got %d timings. Using #%d as default\n", __func__, disp->num_timings, disp->default_timing + 1);
+
+	return disp;
+}
+EXPORT_SYMBOL(of_get_display);
+
+int of_display_exists(struct device_node *np)
+{
+	struct device_node *display_np;
+	struct device_node *timing_np;
+
+	if (!np)
+		return -EINVAL;
+
+	display_np = of_parse_phandle(np, "display", 0);
+
+	if (!display_np)
+		return -EINVAL;
+
+	timing_np = of_parse_phandle(np, "default-timing", 0);
+
+	if (timing_np)
+		return 0;
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(of_display_exists);
diff --git a/include/linux/display.h b/include/linux/display.h
new file mode 100644
index 0000000..bb84ed9
--- /dev/null
+++ b/include/linux/display.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * Hardware-description of a display
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __LINUX_DISPLAY_H
+#define __LINUX_DISPLAY_H
+
+#include <linux/list.h>
+
+#define OF_DEFAULT_TIMING -1
+
+struct display {
+	u32 width_mm;
+	u32 height_mm;
+	unsigned int num_timings;
+	unsigned int default_timing;
+
+	struct signal_timing **timings;
+
+	bool vsync_pol_active_high;
+	bool hsync_pol_active_high;
+	bool de_pol_active_high;
+	bool pixelclk_pol_inverted;
+
+	u32 if_bpp;
+	u32 if_link_width;
+	u32 if_pixel_per_clk;
+};
+
+struct timing_entry {
+	u32 min;
+	u32 typ;
+	u32 max;
+};
+
+struct signal_timing {
+	struct timing_entry pixelclock;
+
+	struct timing_entry hactive;
+	struct timing_entry hfront_porch;
+	struct timing_entry hback_porch;
+	struct timing_entry hsync_len;
+
+	struct timing_entry vactive;
+	struct timing_entry vfront_porch;
+	struct timing_entry vback_porch;
+	struct timing_entry vsync_len;
+};
+
+/* placeholder function until ranges are really needed */
+static inline u32 signal_timing_get_value(struct timing_entry *te, int index)
+{
+	return te->typ;
+}
+
+static inline void timings_release(struct display *disp)
+{
+	int i;
+	for (i = 0; i < disp->num_timings; i++)
+		kfree(disp->timings[i]);
+}
+
+static inline void display_release(struct display *disp)
+{
+	timings_release(disp);
+	kfree(disp->timings);
+}
+
+static inline struct signal_timing *display_get_timing(struct display *disp, int index)
+{
+	if (disp->num_timings >= index)
+		return disp->timings[index];
+	else
+		return NULL;
+}
+
+
+int of_display_exists(struct device_node *np);
+struct display *of_get_display(struct device_node *np);
+
+#endif /* __LINUX_DISPLAY_H */
diff --git a/include/linux/of_display.h b/include/linux/of_display.h
new file mode 100644
index 0000000..500ff94
--- /dev/null
+++ b/include/linux/of_display.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __LINUX_OF_DISPLAY_H
+#define __LINUX_OF_DISPALY_H
+
+#include <linux/fb.h>
+
+struct display *of_get_display(struct device_node *np);
+int of_display_exists(struct device_node *np);
+
+#endif
-- 
1.7.10.4

