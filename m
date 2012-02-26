Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58443 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2BZD1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 22:27:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 10/11] v4l: Aptina-style sensor PLL support
Date: Sun, 26 Feb 2012 04:27:36 +0100
Message-Id: <1330226857-8651-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330226857-8651-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a generic helper function to compute PLL parameters for PLL found in
several Aptina sensors.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/Kconfig      |    4 +
 drivers/media/video/Makefile     |    4 +
 drivers/media/video/aptina-pll.c |  120 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/aptina-pll.h |   55 +++++++++++++++++
 4 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 02afc02..b255c29 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -133,6 +133,9 @@ menu "Encoders, decoders, sensors and other helper chips"
 
 comment "Audio decoders, processors and mixers"
 
+config VIDEO_APTINA_PLL
+	tristate
+
 config VIDEO_TVAUDIO
 	tristate "Simple audio decoder chips"
 	depends on VIDEO_V4L2 && I2C
@@ -946,6 +949,7 @@ config SOC_CAMERA_MT9M001
 config VIDEO_MT9M032
 	tristate "MT9M032 camera sensor support"
 	depends on I2C && VIDEO_V4L2
+	select VIDEO_APTINA_PLL
 	help
 	  This driver supports MT9M032 cameras from Micron, monochrome
 	  models only.
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2fa78d6..06d33ed 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -22,6 +22,10 @@ endif
 
 obj-$(CONFIG_VIDEO_V4L2_COMMON) += v4l2-common.o
 
+# Helper modules
+
+obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
+
 # All i2c modules must come first:
 
 obj-$(CONFIG_VIDEO_TUNER) += tuner.o
diff --git a/drivers/media/video/aptina-pll.c b/drivers/media/video/aptina-pll.c
new file mode 100644
index 0000000..e4df9ec
--- /dev/null
+++ b/drivers/media/video/aptina-pll.c
@@ -0,0 +1,120 @@
+/*
+ * Aptina Sensor PLL Configuration
+ *
+ * Copyright (C) 2012 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/device.h>
+#include <linux/gcd.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "aptina-pll.h"
+
+int aptina_pll_configure(struct device *dev, struct aptina_pll *pll,
+			 const struct aptina_pll_limits *limits)
+{
+	unsigned int mf_min;
+	unsigned int mf_max;
+	unsigned int mf;
+	unsigned int clock;
+	unsigned int div;
+	unsigned int p1;
+	unsigned int n;
+	unsigned int m;
+
+	if (pll->ext_clock < limits->ext_clock_min ||
+	    pll->ext_clock > limits->ext_clock_max) {
+		dev_err(dev, "pll: invalid external clock frequency.\n");
+		return -EINVAL;
+	}
+
+	if (pll->pix_clock > limits->pix_clock_max) {
+		dev_err(dev, "pll: invalid pixel clock frequency.\n");
+		return -EINVAL;
+	}
+
+	/* Compute the multiplier M and combined N*P1 divisor. */
+	div = gcd(pll->pix_clock, pll->ext_clock);
+	pll->m = pll->pix_clock / div;
+	div = pll->ext_clock / div;
+
+	/* We now have the smallest M and N*P1 values that will result in the
+	 * desired pixel clock frequency, but they might be out of the valid
+	 * range. Compute the factor by which we should multiply them given the
+	 * following constraints:
+	 *
+	 * - minimum/maximum multiplier
+	 * - minimum/maximum multiplier output clock frequency assuming the
+	 *   minimum/maximum N value
+	 * - minimum/maximum combined N*P1 divisor
+	 */
+	mf_min = DIV_ROUND_UP(limits->m_min, pll->m);
+	mf_min = max(mf_min, limits->out_clock_min /
+		     (pll->ext_clock / limits->n_min * pll->m));
+	mf_min = max(mf_min, limits->n_min * limits->p1_min / div);
+	mf_max = limits->m_max / pll->m;
+	mf_max = min(mf_max, limits->out_clock_max /
+		    (pll->ext_clock / limits->n_max * pll->m));
+	mf_max = min(mf_max, DIV_ROUND_UP(limits->n_max * limits->p1_max, div));
+
+	dev_dbg(dev, "pll: mf min %u max %u\n", mf_min, mf_max);
+	if (mf_min > mf_max) {
+		dev_err(dev, "pll: no valid combined N*P1 divisor.\n");
+		return -EINVAL;
+	}
+
+	/* Find the highest acceptable P1 value and compute the corresponding N
+	 * divisor. Make sure the P1 value is even.
+	 */
+	for (mf = mf_min; mf <= mf_max; ++mf) {
+		m = pll->m * mf;
+
+		for (p1 = limits->p1_max & ~1; p1 > limits->p1_min; p1 -= 2) {
+			if ((div * mf) % p1)
+				continue;
+
+			n = div * mf / p1;
+
+			clock = pll->ext_clock / n;
+			if (clock < limits->int_clock_min ||
+			    clock > limits->int_clock_max)
+				continue;
+
+			clock *= m;
+			if (clock < limits->out_clock_min ||
+			    clock > limits->out_clock_max)
+				continue;
+
+			goto found;
+		}
+	}
+
+	dev_err(dev, "pll: no valid N and P1 divisors found.\n");
+	return -EINVAL;
+
+found:
+	pll->n = n;
+	pll->m = m;
+	pll->p1 = p1;
+
+	dev_dbg(dev, "PLL: ext clock %u N %u M %u P1 %u pix clock %u\n",
+		 pll->ext_clock, pll->n, pll->m, pll->p1, pll->pix_clock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aptina_pll_configure);
diff --git a/drivers/media/video/aptina-pll.h b/drivers/media/video/aptina-pll.h
new file mode 100644
index 0000000..36a9363
--- /dev/null
+++ b/drivers/media/video/aptina-pll.h
@@ -0,0 +1,55 @@
+/*
+ * Aptina Sensor PLL Configuration
+ *
+ * Copyright (C) 2012 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __APTINA_PLL_H
+#define __APTINA_PLL_H
+
+struct aptina_pll {
+	unsigned int ext_clock;
+	unsigned int pix_clock;
+
+	unsigned int n;
+	unsigned int m;
+	unsigned int p1;
+};
+
+struct aptina_pll_limits {
+	unsigned int ext_clock_min;
+	unsigned int ext_clock_max;
+	unsigned int int_clock_min;
+	unsigned int int_clock_max;
+	unsigned int out_clock_min;
+	unsigned int out_clock_max;
+	unsigned int pix_clock_max;
+
+	unsigned int n_min;
+	unsigned int n_max;
+	unsigned int m_min;
+	unsigned int m_max;
+	unsigned int p1_min;
+	unsigned int p1_max;
+};
+
+struct device;
+
+int aptina_pll_configure(struct device *dev, struct aptina_pll *pll,
+			 const struct aptina_pll_limits *limits);
+
+#endif /* __APTINA_PLL_H */
-- 
1.7.3.4

