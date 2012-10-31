Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39209 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2JaJ3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 05:29:02 -0400
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
Subject: [PATCH v7 1/8] video: add display_timing struct and helpers
Date: Wed, 31 Oct 2012 10:28:01 +0100
Message-Id: <1351675689-26814-2-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add display_timing structure and the according helper functions. This allows
the description of a display via its supported timing parameters.

Every timing parameter can be specified as a single value or a range
<min typ max>.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/video/Kconfig          |    5 +++
 drivers/video/Makefile         |    1 +
 drivers/video/display_timing.c |   24 ++++++++++++++
 include/linux/display_timing.h |   69 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 99 insertions(+)
 create mode 100644 drivers/video/display_timing.c
 create mode 100644 include/linux/display_timing.h

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index d08d799..1421fc8 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -33,6 +33,11 @@ config VIDEO_OUTPUT_CONTROL
 	  This framework adds support for low-level control of the video 
 	  output switch.
 
+config DISPLAY_TIMING
+       bool "Enable display timings helpers"
+       help
+         Say Y here, to use the display timing helpers.
+
 menuconfig FB
 	tristate "Support for frame buffer devices"
 	---help---
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 23e948e..552c045 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -167,3 +167,4 @@ obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
 
 #video output switch sysfs driver
 obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
+obj-$(CONFIG_DISPLAY_TIMING) += display_timing.o
diff --git a/drivers/video/display_timing.c b/drivers/video/display_timing.c
new file mode 100644
index 0000000..9ccfdb3
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
+#include <linux/slab.h>
+#include <linux/display_timing.h>
+
+void timings_release(struct display_timings *disp)
+{
+	int i;
+
+	for (i = 0; i < disp->num_timings; i++)
+		kfree(disp->timings[i]);
+}
+
+void display_timings_release(struct display_timings *disp)
+{
+	timings_release(disp);
+	kfree(disp->timings);
+}
diff --git a/include/linux/display_timing.h b/include/linux/display_timing.h
new file mode 100644
index 0000000..aa02a12
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
+/* placeholder function until ranges are really needed */
+static inline u32 display_timing_get_value(struct timing_entry *te, int index)
+{
+	return te->typ;
+}
+
+static inline struct display_timing *display_timings_get(struct display_timings *disp,
+							 int index)
+{
+	struct display_timing *dt;
+
+	if (disp->num_timings > index) {
+		dt = disp->timings[index];
+		return dt;
+	} else
+		return NULL;
+}
+
+void timings_release(struct display_timings *disp);
+void display_timings_release(struct display_timings *disp);
+
+#endif
-- 
1.7.10.4

