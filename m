Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33150 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2KLPiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 10:38:09 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	"Rob Herring" <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Guennady Liakhovetski" <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: =?UTF-8?q?=5BPATCH=20v8=202/6=5D=20video=3A=20add=20of=20helper=20for=20videomode?=
Date: Mon, 12 Nov 2012 16:37:02 +0100
Message-Id: <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for reading display timings from DT or/and convert one of those
timings to a videomode.
The of_display_timing implementation supports multiple children where each
property can have up to 3 values. All children are read into an array, that
can be queried.
of_get_videomode converts exactly one of that timings to a struct videomode.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../devicetree/bindings/video/display-timings.txt  |  107 +++++++++++
 drivers/video/Kconfig                              |   13 ++
 drivers/video/Makefile                             |    2 +
 drivers/video/of_display_timing.c                  |  186 ++++++++++++++++++++
 drivers/video/of_videomode.c                       |   47 +++++
 include/linux/of_display_timings.h                 |   19 ++
 include/linux/of_videomode.h                       |   15 ++
 7 files changed, 389 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
 create mode 100644 drivers/video/of_display_timing.c
 create mode 100644 drivers/video/of_videomode.c
 create mode 100644 include/linux/of_display_timings.h
 create mode 100644 include/linux/of_videomode.h

diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
new file mode 100644
index 0000000..e22e2fd
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/display-timings.txt
@@ -0,0 +1,107 @@
+display-timings bindings
+========================
+
+display-timings-node
+--------------------
+
+required properties:
+ - none
+
+optional properties:
+ - native-mode: the native mode for the display, in case multiple modes are
+		provided. When omitted, assume the first node is the native.
+
+timings-subnode
+---------------
+
+required properties:
+ - hactive, vactive: Display resolution
+ - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
+   in pixels
+   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
+   lines
+ - clock-frequency: displayclock in Hz
+
+optional properties:
+ - hsync-active : Hsync pulse is active low/high/ignored
+ - vsync-active : Vsync pulse is active low/high/ignored
+ - de-active : Data-Enable pulse is active low/high/ignored
+ - pixelclk-inverted : pixelclock is inverted/non-inverted/ignored
+ - interlaced (bool)
+ - doublescan (bool)
+
+All the optional properties that are not bool follow the following logic:
+    <1> : high active
+    <0> : low active
+    omitted : not used on hardware
+
+There are different ways of describing the capabilities of a display. The devicetree
+representation corresponds to the one commonly found in datasheets for displays.
+If a display supports multiple signal timings, the native-mode can be specified.
+
+The parameters are defined as
+
+struct display_timing
+=====================
+
+  +----------+---------------------------------------------+----------+-------+
+  |          |                ↑                            |          |       |
+  |          |                |vback_porch                 |          |       |
+  |          |                ↓                            |          |       |
+  +----------###############################################----------+-------+
+  |          #                ↑                            #          |       |
+  |          #                |                            #          |       |
+  |  hback   #                |                            #  hfront  | hsync |
+  |   porch  #                |       hactive              #  porch   |  len  |
+  |<-------->#<---------------+--------------------------->#<-------->|<----->|
+  |          #                |                            #          |       |
+  |          #                |vactive                     #          |       |
+  |          #                |                            #          |       |
+  |          #                ↓                            #          |       |
+  +----------###############################################----------+-------+
+  |          |                ↑                            |          |       |
+  |          |                |vfront_porch                |          |       |
+  |          |                ↓                            |          |       |
+  +----------+---------------------------------------------+----------+-------+
+  |          |                ↑                            |          |       |
+  |          |                |vsync_len                   |          |       |
+  |          |                ↓                            |          |       |
+  +----------+---------------------------------------------+----------+-------+
+
+
+Example:
+
+	display-timings {
+		native-mode = <&timing0>;
+		timing0: 1920p24 {
+			/* 1920x1080p24 */
+			clock-frequency = <52000000>;
+			hactive = <1920>;
+			vactive = <1080>;
+			hfront-porch = <25>;
+			hback-porch = <25>;
+			hsync-len = <25>;
+			vback-porch = <2>;
+			vfront-porch = <2>;
+			vsync-len = <2>;
+			hsync-active = <1>;
+		};
+	};
+
+Every required property also supports the use of ranges, so the commonly used
+datasheet description with <min typ max>-tuples can be used.
+
+Example:
+
+	timing1: timing {
+		/* 1920x1080p24 */
+		clock-frequency = <148500000>;
+		hactive = <1920>;
+		vactive = <1080>;
+		hsync-len = <0 44 60>;
+		hfront-porch = <80 88 95>;
+		hback-porch = <100 148 160>;
+		vfront-porch = <0 4 6>;
+		vback-porch = <0 36 50>;
+		vsync-len = <0 5 6>;
+	};
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 2a23b18..a324457 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -39,6 +39,19 @@ config DISPLAY_TIMING
 config VIDEOMODE
        bool
 
+config OF_DISPLAY_TIMING
+	def_bool y
+	select DISPLAY_TIMING
+	help
+	  helper to parse display timings from the devicetree
+
+config OF_VIDEOMODE
+	def_bool y
+	select VIDEOMODE
+	select OF_DISPLAY_TIMING
+	help
+	  helper to get videomodes from the devicetree
+
 menuconfig FB
 	tristate "Support for frame buffer devices"
 	---help---
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index fc30439..b936b00 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -168,4 +168,6 @@ obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
 #video output switch sysfs driver
 obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
 obj-$(CONFIG_DISPLAY_TIMING) += display_timing.o
+obj-$(CONFIG_OF_DISPLAY_TIMING) += of_display_timing.o
 obj-$(CONFIG_VIDEOMODE) += videomode.o
+obj-$(CONFIG_OF_VIDEOMODE) += of_videomode.o
diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_display_timing.c
new file mode 100644
index 0000000..0bd30cc
--- /dev/null
+++ b/drivers/video/of_display_timing.c
@@ -0,0 +1,186 @@
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
+#include <linux/export.h>
+#include <linux/of_display_timings.h>
+
+/**
+ * parse_property - parse timing_entry from device_node
+ * @np: device_node with the property
+ * @name: name of the property
+ * @result: will be set to the return value
+ *
+ * DESCRIPTION:
+ * Every display_timing can be specified with either just the typical value or
+ * a range consisting of min/typ/max. This function helps handling this
+ **/
+static int parse_property(struct device_node *np, char *name,
+				struct timing_entry *result)
+{
+	struct property *prop;
+	int length, cells, ret;
+
+	prop = of_find_property(np, name, &length);
+	if (!prop) {
+		pr_err("%s: could not find property %s\n", __func__, name);
+		return -EINVAL;
+	}
+
+	cells = length / sizeof(u32);
+	if (cells == 1) {
+		ret = of_property_read_u32(np, name, &result->typ);
+		result->min = result->typ;
+		result->max = result->typ;
+	} else if (cells == 3) {
+		ret = of_property_read_u32_array(np, name, &result->min, cells);
+	} else {
+		pr_err("%s: illegal timing specification in %s\n", __func__, name);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+/**
+ * of_get_display_timing - parse display_timing entry from device_node
+ * @np: device_node with the properties
+ **/
+static struct display_timing *of_get_display_timing(struct device_node *np)
+{
+	struct display_timing *dt;
+	int ret = 0;
+
+	dt = kzalloc(sizeof(*dt), GFP_KERNEL);
+	if (!dt) {
+		pr_err("%s: could not allocate display_timing struct\n", __func__);
+		return NULL;
+	}
+
+	ret |= parse_property(np, "hback-porch", &dt->hback_porch);
+	ret |= parse_property(np, "hfront-porch", &dt->hfront_porch);
+	ret |= parse_property(np, "hactive", &dt->hactive);
+	ret |= parse_property(np, "hsync-len", &dt->hsync_len);
+	ret |= parse_property(np, "vback-porch", &dt->vback_porch);
+	ret |= parse_property(np, "vfront-porch", &dt->vfront_porch);
+	ret |= parse_property(np, "vactive", &dt->vactive);
+	ret |= parse_property(np, "vsync-len", &dt->vsync_len);
+	ret |= parse_property(np, "clock-frequency", &dt->pixelclock);
+
+	of_property_read_u32(np, "vsync-active", &dt->vsync_pol_active);
+	of_property_read_u32(np, "hsync-active", &dt->hsync_pol_active);
+	of_property_read_u32(np, "de-active", &dt->de_pol_active);
+	of_property_read_u32(np, "pixelclk-inverted", &dt->pixelclk_pol);
+	dt->interlaced = of_property_read_bool(np, "interlaced");
+	dt->doublescan = of_property_read_bool(np, "doublescan");
+
+	if (ret) {
+		pr_err("%s: error reading timing properties\n", __func__);
+		return NULL;
+	}
+
+	return dt;
+}
+
+/**
+ * of_get_display_timings - parse all display_timing entries from a device_node
+ * @np: device_node with the subnodes
+ **/
+struct display_timings *of_get_display_timings(struct device_node *np)
+{
+	struct device_node *timings_np;
+	struct device_node *entry;
+	struct device_node *native_mode;
+	struct display_timings *disp;
+
+	if (!np) {
+		pr_err("%s: no devicenode given\n", __func__);
+		return NULL;
+	}
+
+	timings_np = of_find_node_by_name(np, "display-timings");
+	if (!timings_np) {
+		pr_err("%s: could not find display-timings node\n", __func__);
+		return NULL;
+	}
+
+	disp = kzalloc(sizeof(*disp), GFP_KERNEL);
+	if (!disp)
+		return -ENOMEM;
+
+	entry = of_parse_phandle(timings_np, "native-mode", 0);
+	/* assume first child as native mode if none provided */
+	if (!entry)
+		entry = of_get_next_child(np, NULL);
+	if (!entry) {
+		pr_err("%s: no timing specifications given\n", __func__);
+		return NULL;
+	}
+
+	pr_info("%s: using %s as default timing\n", __func__, entry->name);
+
+	native_mode = entry;
+
+	disp->num_timings = of_get_child_count(timings_np);
+	disp->timings = kzalloc(sizeof(struct display_timing *)*disp->num_timings,
+				GFP_KERNEL);
+	if (!disp->timings)
+		return -ENOMEM;
+
+	disp->num_timings = 0;
+	disp->native_mode = 0;
+
+	for_each_child_of_node(timings_np, entry) {
+		struct display_timing *dt;
+
+		dt = of_get_display_timing(entry);
+		if (!dt) {
+			/* to not encourage wrong devicetrees, fail in case of an error */
+			pr_err("%s: error in timing %d\n", __func__, disp->num_timings+1);
+			return NULL;
+		}
+
+		if (native_mode == entry)
+			disp->native_mode = disp->num_timings;
+
+		disp->timings[disp->num_timings] = dt;
+		disp->num_timings++;
+	}
+	of_node_put(timings_np);
+
+	if (disp->num_timings > 0)
+		pr_info("%s: got %d timings. Using timing #%d as default\n", __func__,
+			disp->num_timings , disp->native_mode + 1);
+	else {
+		pr_err("%s: no valid timings specified\n", __func__);
+		return NULL;
+	}
+	return disp;
+}
+EXPORT_SYMBOL_GPL(of_get_display_timings);
+
+/**
+ * of_display_timings_exists - check if a display-timings node is provided
+ * @np: device_node with the timing
+ **/
+int of_display_timings_exists(struct device_node *np)
+{
+	struct device_node *timings_np;
+
+	if (!np)
+		return -EINVAL;
+
+	timings_np = of_parse_phandle(np, "display-timings", 0);
+	if (!timings_np)
+		return -EINVAL;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(of_display_timings_exists);
diff --git a/drivers/video/of_videomode.c b/drivers/video/of_videomode.c
new file mode 100644
index 0000000..7051701
--- /dev/null
+++ b/drivers/video/of_videomode.c
@@ -0,0 +1,47 @@
+/*
+ * generic videomode helper
+ *
+ * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
+ *
+ * This file is released under the GPLv2
+ */
+#include <linux/of.h>
+#include <linux/of_display_timings.h>
+#include <linux/of_videomode.h>
+#include <linux/export.h>
+
+/**
+ * of_get_videomode - get the videomode #<index> from devicetree
+ * @np - devicenode with the display_timings
+ * @vm - set to return value
+ * @index - index into list of display_timings
+ * DESCRIPTION:
+ * Get a list of all display timings and put the one
+ * specified by index into *vm. This function should only be used, if
+ * only one videomode is to be retrieved. A driver that needs to work
+ * with multiple/all videomodes should work with
+ * of_get_display_timings instead.
+ **/
+int of_get_videomode(struct device_node *np, struct videomode *vm, int index)
+{
+	struct display_timings *disp;
+	int ret;
+
+	disp = of_get_display_timings(np);
+	if (!disp) {
+		pr_err("%s: no timings specified\n", __func__);
+		return -EINVAL;
+	}
+
+	if (index == OF_USE_NATIVE_MODE)
+		index = disp->native_mode;
+
+	ret = videomode_from_timing(disp, vm, index);
+	if (ret)
+		return ret;
+
+	display_timings_release(disp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_videomode);
diff --git a/include/linux/of_display_timings.h b/include/linux/of_display_timings.h
new file mode 100644
index 0000000..ccf6814
--- /dev/null
+++ b/include/linux/of_display_timings.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * display timings of helpers
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __LINUX_OF_DISPLAY_TIMINGS_H
+#define __LINUX_OF_DISPLAY_TIMINGS_H
+
+#include <linux/display_timing.h>
+
+#define OF_USE_NATIVE_MODE -1
+
+struct display_timings *of_get_display_timings(struct device_node *np);
+int of_display_timings_exists(struct device_node *np);
+
+#endif
diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
new file mode 100644
index 0000000..01518e6
--- /dev/null
+++ b/include/linux/of_videomode.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * videomode of-helpers
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __LINUX_OF_VIDEOMODE_H
+#define __LINUX_OF_VIDEOMODE_H
+
+#include <linux/videomode.h>
+
+int of_get_videomode(struct device_node *np, struct videomode *vm, int index);
+#endif /* __LINUX_OF_VIDEOMODE_H */
-- 
1.7.10.4

