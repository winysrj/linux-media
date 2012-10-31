Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab2JaJ3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 05:29:10 -0400
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
Subject: [PATCH v7 3/8] of: add generic videomode description
Date: Wed, 31 Oct 2012 10:28:03 +0100
Message-Id: <1351675689-26814-4-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get videomode from devicetree in a format appropriate for the
backend. drm_display_mode and fb_videomode are supported atm.
Uses the display signal timings from of_display_timings

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/of/Kconfig           |    6 ++++++
 drivers/of/Makefile          |    1 +
 drivers/of/of_videomode.c    |   47 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_videomode.h |   15 ++++++++++++++
 4 files changed, 69 insertions(+)
 create mode 100644 drivers/of/of_videomode.c
 create mode 100644 include/linux/of_videomode.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 781e773..0575ffe 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -89,4 +89,10 @@ config OF_DISPLAY_TIMINGS
 	help
 	  helper to parse display timings from the devicetree
 
+config OF_VIDEOMODE
+	def_bool y
+	depends on VIDEOMODE
+	help
+	  helper to get videomodes from the devicetree
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index c8e9603..09d556f 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_DISPLAY_TIMINGS) += of_display_timings.o
+obj-$(CONFIG_OF_VIDEOMODE) += of_videomode.o
diff --git a/drivers/of/of_videomode.c b/drivers/of/of_videomode.c
new file mode 100644
index 0000000..91a26fc
--- /dev/null
+++ b/drivers/of/of_videomode.c
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
+ * of_get_display_timing_list instead.
+ **/
+int of_get_videomode(struct device_node *np, struct videomode *vm, int index)
+{
+	struct display_timings *disp;
+	int ret;
+
+	disp = of_get_display_timing_list(np);
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

