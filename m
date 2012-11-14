Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55254 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161146Ab2KNLoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 06:44:12 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"Rob Herring" <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Guennady Liakhovetski" <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: [PATCH v9 1/6] video: add display_timing and videomode
Date: Wed, 14 Nov 2012 12:43:18 +0100
Message-Id: <1352893403-21168-2-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add display_timing structure and the according helper functions. This allows
the description of a display via its supported timing parameters.

Every timing parameter can be specified as a single value or a range
<min typ max>.

Also, add helper functions to convert from display timings to a generic videomode
structure. This videomode can then be converted to the corresponding subsystem
mode representation (e.g. fb_videomode).

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/video/Kconfig          |    6 ++++
 drivers/video/Makefile         |    2 ++
 drivers/video/display_timing.c |   24 ++++++++++++++
 drivers/video/videomode.c      |   45 ++++++++++++++++++++++++++
 include/linux/display_timing.h |   69 ++++++++++++++++++++++++++++++++++++++++
 include/linux/videomode.h      |   39 +++++++++++++++++++++++
 6 files changed, 185 insertions(+)
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
index 0000000..087374a
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
+int videomode_from_timing(struct display_timings *disp, struct videomode *vm,
+			  unsigned int index)
+{
+	struct display_timing *dt;
+
+	dt = display_timings_get(disp, index);
+	if (!dt)
+		return -EINVAL;
+
+	vm->pixelclock = display_timing_get_value(&dt->pixelclock, 0);
+	vm->hactive = display_timing_get_value(&dt->hactive, 0);
+	vm->hfront_porch = display_timing_get_value(&dt->hfront_porch, 0);
+	vm->hback_porch = display_timing_get_value(&dt->hback_porch, 0);
+	vm->hsync_len = display_timing_get_value(&dt->hsync_len, 0);
+
+	vm->vactive = display_timing_get_value(&dt->vactive, 0);
+	vm->vfront_porch = display_timing_get_value(&dt->vfront_porch, 0);
+	vm->vback_porch = display_timing_get_value(&dt->vback_porch, 0);
+	vm->vsync_len = display_timing_get_value(&dt->vsync_len, 0);
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
index 0000000..caee2a8
--- /dev/null
+++ b/include/linux/display_timing.h
@@ -0,0 +1,69 @@
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
+struct timing_entry {
+	u32 min;
+	u32 typ;
+	u32 max;
+};
+
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
+struct display_timings {
+	unsigned int num_timings;
+	unsigned int native_mode;
+
+	struct display_timing **timings;
+};
+
+/*
+ * placeholder function until ranges are really needed
+ * the index parameter should then be used to select one of [min typ max]
+ */
+static inline u32 display_timing_get_value(struct timing_entry *te,
+					   unsigned int index)
+{
+	return te->typ;
+}
+
+static inline struct display_timing *display_timings_get(struct display_timings *disp,
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
index 0000000..0b87fbb
--- /dev/null
+++ b/include/linux/videomode.h
@@ -0,0 +1,39 @@
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
+#include <linux/display_timing.h>
+
+struct videomode {
+	u32 pixelclock;
+	u32 refreshrate;
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
+	u32 hah;
+	u32 vah;
+	u32 de;
+	u32 pixelclk_pol;
+
+	bool interlaced;
+	bool doublescan;
+};
+
+int videomode_from_timing(struct display_timings *disp, struct videomode *vm,
+			  unsigned int index);
+#endif
-- 
1.7.10.4

