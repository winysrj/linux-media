Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45060 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030442Ab2CFMJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 07:09:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 3/5] v4l: Aptina-style sensor PLL support
Date: Tue,  6 Mar 2012 13:09:44 +0100
Message-Id: <1331035786-8938-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a generic helper function to compute PLL parameters for PLL found in
several Aptina sensors.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/Kconfig      |    3 +
 drivers/media/video/Makefile     |    4 +
 drivers/media/video/aptina-pll.c |  174 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/aptina-pll.h |   56 ++++++++++++
 4 files changed, 237 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/aptina-pll.c
 create mode 100644 drivers/media/video/aptina-pll.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9495b6a..7867b0b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -459,6 +459,9 @@ config VIDEO_AK881X
 
 comment "Camera sensor devices"
 
+config VIDEO_APTINA_PLL
+	tristate
+
 config VIDEO_OV7670
 	tristate "OmniVision OV7670 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 563443c..d1304e1 100644
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
index 0000000..0bd3813
--- /dev/null
+++ b/drivers/media/video/aptina-pll.c
@@ -0,0 +1,174 @@
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
+#include <linux/lcm.h>
+#include <linux/module.h>
+
+#include "aptina-pll.h"
+
+int aptina_pll_calculate(struct device *dev,
+			 const struct aptina_pll_limits *limits,
+			 struct aptina_pll *pll)
+{
+	unsigned int mf_min;
+	unsigned int mf_max;
+	unsigned int p1_min;
+	unsigned int p1_max;
+	unsigned int p1;
+	unsigned int div;
+
+	dev_dbg(dev, "PLL: ext clock %u pix clock %u\n",
+		pll->ext_clock, pll->pix_clock);
+
+	if (pll->ext_clock < limits->ext_clock_min ||
+	    pll->ext_clock > limits->ext_clock_max) {
+		dev_err(dev, "pll: invalid external clock frequency.\n");
+		return -EINVAL;
+	}
+
+	if (pll->pix_clock == 0 || pll->pix_clock > limits->pix_clock_max) {
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
+	/*
+	 * We're looking for the highest acceptable P1 value for which a
+	 * multiplier factor MF exists that fulfills the following conditions:
+	 *
+	 * 1. p1 is in the [p1_min, p1_max] range given by the limits and is
+	 *    even
+	 * 2. mf is in the [mf_min, mf_max] range computed above
+	 * 3. div * mf is a multiple of p1, in order to compute
+	 *	n = div * mf / p1
+	 *	m = pll->m * mf
+	 * 4. the internal clock frequency, given by ext_clock / n, is in the
+	 *    [int_clock_min, int_clock_max] range given by the limits
+	 * 5. the output clock frequency, given by ext_clock / n * m, is in the
+	 *    [out_clock_min, out_clock_max] range given by the limits
+	 *
+	 * The first naive approach is to iterate over all p1 values acceptable
+	 * according to (1) and all mf values acceptable according to (2), and
+	 * stop at the first combination that fulfills (3), (4) and (5). This
+	 * has a O(n^2) complexity.
+	 *
+	 * Instead of iterating over all mf values in the [mf_min, mf_max] range
+	 * we can compute the mf increment between two acceptable values
+	 * according to (3) with
+	 *
+	 *	mf_inc = p1 / gcd(div, p1)			(6)
+	 *
+	 * and round the minimum up to the nearest multiple of mf_inc. This will
+	 * restrict the number of mf values to be checked.
+	 *
+	 * Furthermore, conditions (4) and (5) only restrict the range of
+	 * acceptable p1 and mf values by modifying the minimum and maximum
+	 * limits. (5) can be expressed as
+	 *
+	 *	ext_clock / (div * mf / p1) * m * mf >= out_clock_min
+	 *	ext_clock / (div * mf / p1) * m * mf <= out_clock_max
+	 *
+	 * or
+	 *
+	 *	p1 >= out_clock_min * div / (ext_clock * m)	(7)
+	 *	p1 <= out_clock_max * div / (ext_clock * m)
+	 *
+	 * Similarly, (4) can be expressed as
+	 *
+	 *	mf >= ext_clock * p1 / (int_clock_max * div)	(8)
+	 *	mf <= ext_clock * p1 / (int_clock_min * div)
+	 *
+	 * We can thus iterate over the restricted p1 range defined by the
+	 * combination of (1) and (7), and then compute the restricted mf range
+	 * defined by the combination of (2), (6) and (8). If the resulting mf
+	 * range is not empty, any value in the mf range is acceptable. We thus
+	 * select the mf lwoer bound and the corresponding p1 value.
+	 */
+	if (limits->p1_min == 0) {
+		dev_err(dev, "pll: P1 minimum value must be >0.\n");
+		return -EINVAL;
+	}
+
+	p1_min = max(limits->p1_min, DIV_ROUND_UP(limits->out_clock_min * div,
+		     pll->ext_clock * pll->m));
+	p1_max = min(limits->p1_max, limits->out_clock_max * div /
+		     (pll->ext_clock * pll->m));
+
+	for (p1 = p1_max & ~1; p1 >= p1_min; p1 -= 2) {
+		unsigned int mf_inc = p1 / gcd(div, p1);
+		unsigned int mf_high;
+		unsigned int mf_low;
+
+		mf_low = max(roundup(mf_min, mf_inc),
+			     DIV_ROUND_UP(pll->ext_clock * p1,
+			       limits->int_clock_max * div));
+		mf_high = min(mf_max, pll->ext_clock * p1 /
+			      (limits->int_clock_min * div));
+
+		if (mf_low > mf_high)
+			continue;
+
+		pll->n = div * mf_low / p1;
+		pll->m *= mf_low;
+		pll->p1 = p1;
+		dev_dbg(dev, "PLL: N %u M %u P1 %u\n", pll->n, pll->m, pll->p1);
+		return 0;
+	}
+
+	dev_err(dev, "pll: no valid N and P1 divisors found.\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(aptina_pll_calculate);
+
+MODULE_DESCRIPTION("Aptina PLL Helpers");
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/video/aptina-pll.h b/drivers/media/video/aptina-pll.h
new file mode 100644
index 0000000..b370e34
--- /dev/null
+++ b/drivers/media/video/aptina-pll.h
@@ -0,0 +1,56 @@
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
+int aptina_pll_calculate(struct device *dev,
+			 const struct aptina_pll_limits *limits,
+			 struct aptina_pll *pll);
+
+#endif /* __APTINA_PLL_H */
-- 
1.7.3.4

