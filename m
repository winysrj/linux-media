Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49403 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab2KWJFD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 04:05:03 -0500
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
Subject: [PATCHv14 2/7] video: add display_timing and videomode
Date: Fri, 23 Nov 2012 10:04:22 +0100
Message-Id: <1353661467-28545-3-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353661467-28545-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1353661467-28545-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add display_timing structure and the according helper functions. This allows
the description of a display via its supported timing parameters.

Also, add helper functions to convert from display timings to a generic videomode
structure.

The struct display_timing specifies all needed parameters to describe the signal
properties of a display in one mode. This includes
	- ranges for signals that may have min-, max- and typical values
	- single integers for signals that can be on, off or are ignored
	- booleans for signals that are either on or off

As a display may support multiple modes like this, a struct display_timings is
added, that holds all given struct display_timing pointers and declares the
native mode of the display.

Although a display may state that a signal can be in a range, it is driven with
fixed values that indicate a videomode. Therefore graphic drivers don't need all
the information of struct display_timing, but would generate a videomode from
the given set of supported signal timings and work with that.

The video subsystems all define their own structs that describe a mode and work
with that (e.g. fb_videomode or drm_display_mode). To slowly replace all those
various structures and allow code reuse across those subsystems, add struct
videomode as a generic description.

This patch only includes the most basic fields in struct videomode. All missing
fields that are needed to have a really generic video mode description can be
added at a later stage.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/Kconfig          |    6 +++
 drivers/video/Makefile         |    2 +
 drivers/video/display_timing.c |   24 ++++++++++
 drivers/video/videomode.c      |   45 +++++++++++++++++
 include/linux/display_timing.h |  104 ++++++++++++++++++++++++++++++++++++++++
 include/linux/videomode.h      |   52 ++++++++++++++++++++
 6 files changed, 233 insertions(+)
 create mode 100644 drivers/video/display_timing.c
 create mode 100644 drivers/video/videomode.c
 create mode 100644 include/linux/display_timing.h
 create mode 100644 include/linux/videomode.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index d08d799..2a23b18 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -33,6 +33,12 @@ config VIDEO_OUTPUT_CONTROL
 	  This framework adds support for low-level control of the video 
 	  output switch.
 
+config DISPLAY_TIMING
+       bool
+
+config VIDEOMODE
+       bool
+
 menuconfig FB
 	tristate "Support for frame buffer devices"
 	---help---
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 23e948e..fc30439 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -167,3 +167,5 @@ obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
 
 #video output switch sysfs driver
 obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
+obj-$(CONFIG_DISPLAY_TIMING) += display_timing.o
+obj-$(CONFIG_VIDEOMODE) += videomode.o
diff --git a/drivers/video/display_timing.c b/drivers/video/display_timing.c
new file mode 100644
index 0000000..ac9bbbc
--- /dev/null
+++ b/drivers/video/display_timing.c
@@ -0,0 +1,24 @@
+/*
+ * generic display timing functions
+ *
+ * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/display_timing.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+
+void display_timings_release(struct display_timings *disp)
+{
+	if (disp->timings) {
+		unsigned int i;
+
+		for (i = 0; i < disp->num_timings; i++)
+			kfree(disp->timings[i]);
+		kfree(disp->timings);
+	}
+	kfree(disp);
+}
+EXPORT_SYMBOL_GPL(display_timings_release);
diff --git a/drivers/video/videomode.c b/drivers/video/videomode.c
new file mode 100644
index 0000000..86a8558
--- /dev/null
+++ b/drivers/video/videomode.c
@@ -0,0 +1,45 @@
+/*
+ * generic display timing functions
+ *
+ * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/export.h>
+#include <linux/errno.h>
+#include <linux/display_timing.h>
+#include <linux/kernel.h>
+#include <linux/videomode.h>
+
+int videomode_from_timing(const struct display_timings *disp,
+			  struct videomode *vm, unsigned int index)
+{
+	struct display_timing *dt;
+
+	dt = display_timings_get(disp, index);
+	if (!dt)
+		return -EINVAL;
+
+	vm->pixelclock = display_timing_get_value(&dt->pixelclock, TE_TYP);
+	vm->hactive = display_timing_get_value(&dt->hactive, TE_TYP);
+	vm->hfront_porch = display_timing_get_value(&dt->hfront_porch, TE_TYP);
+	vm->hback_porch = display_timing_get_value(&dt->hback_porch, TE_TYP);
+	vm->hsync_len = display_timing_get_value(&dt->hsync_len, TE_TYP);
+
+	vm->vactive = display_timing_get_value(&dt->vactive, TE_TYP);
+	vm->vfront_porch = display_timing_get_value(&dt->vfront_porch, TE_TYP);
+	vm->vback_porch = display_timing_get_value(&dt->vback_porch, TE_TYP);
+	vm->vsync_len = display_timing_get_value(&dt->vsync_len, TE_TYP);
+
+	vm->vah = dt->vsync_pol_active;
+	vm->hah = dt->hsync_pol_active;
+	vm->de = dt->de_pol_active;
+	vm->pixelclk_pol = dt->pixelclk_pol;
+
+	vm->interlaced = dt->interlaced;
+	vm->doublescan = dt->doublescan;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(videomode_from_timing);
diff --git a/include/linux/display_timing.h b/include/linux/display_timing.h
new file mode 100644
index 0000000..b8922ea
--- /dev/null
+++ b/include/linux/display_timing.h
@@ -0,0 +1,104 @@
+/*
+ * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * description of display timings
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __LINUX_DISPLAY_TIMINGS_H
+#define __LINUX_DISPLAY_TIMINGS_H
+
+#include <linux/types.h>
+
+/*
+ * A single signal can be specified via a range with a typical value, that lies
+ * somewhere inbetween. Do not use an array, to prevent any confusion about the
+ * meaning of every entry.
+ */
+struct timing_entry {
+	u32 min;
+	u32 typ;
+	u32 max;
+};
+
+enum timing_entry_index {
+	TE_MIN = 0,
+	TE_TYP = 1,
+	TE_MAX = 2,
+};
+
+/*
+ * Single "mode" entry. This describes one set of signal timings a display can
+ * have in one setting. This struct can later be converted to struct videomode
+ * (see include/linux/videomode.h). As each timing_entry can be defined as a
+ * range, one struct display_timing may become multiple struct videomodes.
+ */
+struct display_timing {
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
+
+	unsigned int vsync_pol_active;
+	unsigned int hsync_pol_active;
+	unsigned int de_pol_active;
+	unsigned int pixelclk_pol;
+	bool interlaced;
+	bool doublescan;
+};
+
+/*
+ * This describes all timing settings a display provides.
+ * The native_mode is the default setting for this display. It can be specified
+ * in the devicetree or will be the first that is provided. Drivers that can
+ * handle multiple videomode should work with this struct and convert each entry
+ * to the desired end result.
+ */
+struct display_timings {
+	unsigned int num_timings;
+	unsigned int native_mode;
+
+	struct display_timing **timings;
+};
+
+/* get value specified by index from struct timing_entry */
+static inline u32 display_timing_get_value(const struct timing_entry *te,
+					   enum timing_entry_index index)
+{
+	switch (index) {
+	case TE_MIN:
+		return te->min;
+		break;
+	case TE_TYP:
+		return te->typ;
+		break;
+	case TE_MAX:
+		return te->max;
+		break;
+	default:
+		return te->typ;
+	}
+}
+
+/* get one entry from struct display_timings */
+static inline struct display_timing *display_timings_get(const struct
+							 display_timings *disp,
+							 unsigned int index)
+{
+	if (disp->num_timings > index)
+		return disp->timings[index];
+	else
+		return NULL;
+}
+
+void display_timings_release(struct display_timings *disp);
+
+#endif
diff --git a/include/linux/videomode.h b/include/linux/videomode.h
new file mode 100644
index 0000000..41749f2
--- /dev/null
+++ b/include/linux/videomode.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * generic videomode description
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __LINUX_VIDEOMODE_H
+#define __LINUX_VIDEOMODE_H
+
+struct display_timings;
+
+/*
+ * Subsystem independent description of a videomode.
+ * Can be generated from struct display_timing.
+ */
+struct videomode {
+	u32 pixelclock;		/* pixelclock in Hz */
+
+	u32 hactive;
+	u32 hfront_porch;
+	u32 hback_porch;
+	u32 hsync_len;
+
+	u32 vactive;
+	u32 vfront_porch;
+	u32 vback_porch;
+	u32 vsync_len;
+
+	u32 hah;		/* hsync active high */
+	u32 vah;		/* vsync active high */
+	u32 de;			/* data enable */
+	u32 pixelclk_pol;
+
+	bool interlaced;
+	bool doublescan;
+};
+
+/**
+ * videomode_from_timing - convert display timing to videomode
+ * @disp: structure with all possible timing entries
+ * @vm: return value
+ * @index: index into the list of display timings in devicetree
+ *
+ * DESCRIPTION:
+ * This function converts a struct display_timing to a struct videomode.
+ */
+int videomode_from_timing(const struct display_timings *disp,
+			  struct videomode *vm, unsigned int index);
+
+#endif
-- 
1.7.10.4

