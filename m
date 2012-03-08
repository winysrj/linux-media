Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:50396 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab2CHOtY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Mar 2012 09:49:24 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5.2 34/35] smiapp: Generic SMIA++/SMIA PLL calculator
Date: Thu,  8 Mar 2012 16:49:14 +0200
Message-Id: <1331218154-22001-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <2338182.m4p3vRkuCF@avalon>
References: <2338182.m4p3vRkuCF@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Calculate PLL configuration based on input data: sensor configuration, board
properties and sensor-specific limits.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Kconfig      |    3 +
 drivers/media/video/Makefile     |    2 +
 drivers/media/video/smiapp-pll.c |  417 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/smiapp-pll.h |  103 ++++++++++
 4 files changed, 525 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/smiapp-pll.c
 create mode 100644 drivers/media/video/smiapp-pll.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9495b6a..7eac873 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -459,6 +459,9 @@ config VIDEO_AK881X
 
 comment "Camera sensor devices"
 
+config VIDEO_SMIAPP_PLL
+	tristate
+
 config VIDEO_OV7670
 	tristate "OmniVision OV7670 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 563443c..2fed63d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -76,6 +76,8 @@ obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
 
+obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
+
 obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
diff --git a/drivers/media/video/smiapp-pll.c b/drivers/media/video/smiapp-pll.c
new file mode 100644
index 0000000..2e059c4
--- /dev/null
+++ b/drivers/media/video/smiapp-pll.c
@@ -0,0 +1,417 @@
+/*
+ * drivers/media/video/smiapp-pll.c
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
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
+ *
+ */
+
+#include <linux/gcd.h>
+#include <linux/lcm.h>
+#include <linux/module.h>
+
+#include "smiapp-pll.h"
+
+/* Return an even number or one. */
+static inline uint32_t clk_div_even(uint32_t a)
+{
+	return max_t(uint32_t, 1, a & ~1);
+}
+
+/* Return an even number or one. */
+static inline uint32_t clk_div_even_up(uint32_t a)
+{
+	if (a == 1)
+		return 1;
+	return (a + 1) & ~1;
+}
+
+static inline uint32_t is_one_or_even(uint32_t a)
+{
+	if (a == 1)
+		return 1;
+	if (a & 1)
+		return 0;
+
+	return 1;
+}
+
+static int bounds_check(struct device *dev, uint32_t val,
+			uint32_t min, uint32_t max, char *str)
+{
+	if (val >= min && val <= max)
+		return 0;
+
+	dev_warn(dev, "%s out of bounds: %d (%d--%d)\n", str, val, min, max);
+
+	return -EINVAL;
+}
+
+static void print_pll(struct device *dev, struct smiapp_pll *pll)
+{
+	dev_dbg(dev, "pre_pll_clk_div\t%d\n",  pll->pre_pll_clk_div);
+	dev_dbg(dev, "pll_multiplier \t%d\n",  pll->pll_multiplier);
+	if (pll->flags != SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+		dev_dbg(dev, "op_sys_clk_div \t%d\n", pll->op_sys_clk_div);
+		dev_dbg(dev, "op_pix_clk_div \t%d\n", pll->op_pix_clk_div);
+	}
+	dev_dbg(dev, "vt_sys_clk_div \t%d\n",  pll->vt_sys_clk_div);
+	dev_dbg(dev, "vt_pix_clk_div \t%d\n",  pll->vt_pix_clk_div);
+
+	dev_dbg(dev, "ext_clk_freq_hz \t%d\n", pll->ext_clk_freq_hz);
+	dev_dbg(dev, "pll_ip_clk_freq_hz \t%d\n", pll->pll_ip_clk_freq_hz);
+	dev_dbg(dev, "pll_op_clk_freq_hz \t%d\n", pll->pll_op_clk_freq_hz);
+	if (pll->flags & SMIAPP_PLL_FLAG_NO_OP_CLOCKS) {
+		dev_dbg(dev, "op_sys_clk_freq_hz \t%d\n",
+			pll->op_sys_clk_freq_hz);
+		dev_dbg(dev, "op_pix_clk_freq_hz \t%d\n",
+			pll->op_pix_clk_freq_hz);
+	}
+	dev_dbg(dev, "vt_sys_clk_freq_hz \t%d\n", pll->vt_sys_clk_freq_hz);
+	dev_dbg(dev, "vt_pix_clk_freq_hz \t%d\n", pll->vt_pix_clk_freq_hz);
+}
+
+int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
+			 struct smiapp_pll *pll)
+{
+	uint32_t sys_div;
+	uint32_t best_pix_div = INT_MAX >> 1;
+	uint32_t vt_op_binning_div;
+	uint32_t lane_op_clock_ratio;
+	uint32_t mul, div;
+	uint32_t more_mul_min, more_mul_max;
+	uint32_t more_mul_factor;
+	uint32_t min_vt_div, max_vt_div, vt_div;
+	uint32_t min_sys_div, max_sys_div;
+	unsigned i;
+	int rval;
+
+	if (pll->flags & SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE)
+		lane_op_clock_ratio = pll->lanes;
+	else
+		lane_op_clock_ratio = 1;
+	dev_dbg(dev, "lane_op_clock_ratio: %d\n", lane_op_clock_ratio);
+
+	dev_dbg(dev, "binning: %dx%d\n", pll->binning_horizontal,
+		pll->binning_vertical);
+
+	/* CSI transfers 2 bits per clock per lane; thus times 2 */
+	pll->pll_op_clk_freq_hz = pll->link_freq * 2
+		* (pll->lanes / lane_op_clock_ratio);
+
+	/* Figure out limits for pre-pll divider based on extclk */
+	dev_dbg(dev, "min / max pre_pll_clk_div: %d / %d\n",
+		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+	limits->max_pre_pll_clk_div =
+		min_t(uint16_t, limits->max_pre_pll_clk_div,
+		      clk_div_even(pll->ext_clk_freq_hz /
+				   limits->min_pll_ip_freq_hz));
+	limits->min_pre_pll_clk_div =
+		max_t(uint16_t, limits->min_pre_pll_clk_div,
+		      clk_div_even(pll->ext_clk_freq_hz /
+				   limits->max_pll_ip_freq_hz));
+	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %d / %d\n",
+		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+
+	i = gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
+	mul = div_u64(pll->pll_op_clk_freq_hz, i);
+	div = pll->ext_clk_freq_hz / i;
+	dev_dbg(dev, "mul %d / div %d\n", mul, div);
+
+	limits->min_pre_pll_clk_div =
+		max_t(uint16_t, limits->min_pre_pll_clk_div,
+		      clk_div_even_up(
+			      DIV_ROUND_UP(mul * pll->ext_clk_freq_hz,
+					   limits->max_pll_op_freq_hz)));
+	dev_dbg(dev, "pll_op check: min / max pre_pll_clk_div: %d / %d\n",
+		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
+
+	if (limits->min_pre_pll_clk_div > limits->max_pre_pll_clk_div) {
+		dev_err(dev, "unable to compute pre_pll divisor\n");
+		return -EINVAL;
+	}
+
+	pll->pre_pll_clk_div = limits->min_pre_pll_clk_div;
+
+	/*
+	 * Get pre_pll_clk_div so that our pll_op_clk_freq_hz won't be
+	 * too high.
+	 */
+	dev_dbg(dev, "pre_pll_clk_div %d\n", pll->pre_pll_clk_div);
+
+	/* Don't go above max pll multiplier. */
+	more_mul_max = limits->max_pll_multiplier / mul;
+	dev_dbg(dev, "more_mul_max: max_pll_multiplier check: %d\n",
+		more_mul_max);
+	/* Don't go above max pll op frequency. */
+	more_mul_max =
+		min_t(int,
+		      more_mul_max,
+		      limits->max_pll_op_freq_hz
+		      / (pll->ext_clk_freq_hz / pll->pre_pll_clk_div * mul));
+	dev_dbg(dev, "more_mul_max: max_pll_op_freq_hz check: %d\n",
+		more_mul_max);
+	/* Don't go above the division capability of op sys clock divider. */
+	more_mul_max = min(more_mul_max,
+			   limits->max_op_sys_clk_div * pll->pre_pll_clk_div
+			   / div);
+	dev_dbg(dev, "more_mul_max: max_op_sys_clk_div check: %d\n",
+		more_mul_max);
+	/* Ensure we won't go above min_pll_multiplier. */
+	more_mul_max = min(more_mul_max,
+			   DIV_ROUND_UP(limits->max_pll_multiplier, mul));
+	dev_dbg(dev, "more_mul_max: min_pll_multiplier check: %d\n",
+		more_mul_max);
+
+	/* Ensure we won't go below min_pll_op_freq_hz. */
+	more_mul_min = DIV_ROUND_UP(limits->min_pll_op_freq_hz,
+				    pll->ext_clk_freq_hz / pll->pre_pll_clk_div
+				    * mul);
+	dev_dbg(dev, "more_mul_min: min_pll_op_freq_hz check: %d\n",
+		more_mul_min);
+	/* Ensure we won't go below min_pll_multiplier. */
+	more_mul_min = max(more_mul_min,
+			   DIV_ROUND_UP(limits->min_pll_multiplier, mul));
+	dev_dbg(dev, "more_mul_min: min_pll_multiplier check: %d\n",
+		more_mul_min);
+
+	if (more_mul_min > more_mul_max) {
+		dev_warn(dev,
+			 "unable to compute more_mul_min and more_mul_max");
+		return -EINVAL;
+	}
+
+	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
+	dev_dbg(dev, "more_mul_factor: %d\n", more_mul_factor);
+	more_mul_factor = lcm(more_mul_factor, limits->min_op_sys_clk_div);
+	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
+		more_mul_factor);
+	i = ALIGN(more_mul_min, more_mul_factor);
+	if (!is_one_or_even(i))
+		i <<= 1;
+
+	dev_dbg(dev, "final more_mul: %d\n", i);
+	if (i > more_mul_max) {
+		dev_warn(dev, "final more_mul is bad, max %d", more_mul_max);
+		return -EINVAL;
+	}
+
+	pll->pll_multiplier = mul * i;
+	pll->op_sys_clk_div = div * i / pll->pre_pll_clk_div;
+	dev_dbg(dev, "op_sys_clk_div: %d\n", pll->op_sys_clk_div);
+
+	pll->pll_ip_clk_freq_hz = pll->ext_clk_freq_hz
+		/ pll->pre_pll_clk_div;
+
+	pll->pll_op_clk_freq_hz = pll->pll_ip_clk_freq_hz
+		* pll->pll_multiplier;
+
+	/* Derive pll_op_clk_freq_hz. */
+	pll->op_sys_clk_freq_hz =
+		pll->pll_op_clk_freq_hz / pll->op_sys_clk_div;
+
+	pll->op_pix_clk_div = pll->bits_per_pixel;
+	dev_dbg(dev, "op_pix_clk_div: %d\n", pll->op_pix_clk_div);
+
+	pll->op_pix_clk_freq_hz =
+		pll->op_sys_clk_freq_hz / pll->op_pix_clk_div;
+
+	/*
+	 * Some sensors perform analogue binning and some do this
+	 * digitally. The ones doing this digitally can be roughly be
+	 * found out using this formula. The ones doing this digitally
+	 * should run at higher clock rate, so smaller divisor is used
+	 * on video timing side.
+	 */
+	if (limits->min_line_length_pck_bin > limits->min_line_length_pck
+	    / pll->binning_horizontal)
+		vt_op_binning_div = pll->binning_horizontal;
+	else
+		vt_op_binning_div = 1;
+	dev_dbg(dev, "vt_op_binning_div: %d\n", vt_op_binning_div);
+
+	/*
+	 * Profile 2 supports vt_pix_clk_div E [4, 10]
+	 *
+	 * Horizontal binning can be used as a base for difference in
+	 * divisors. One must make sure that horizontal blanking is
+	 * enough to accommodate the CSI-2 sync codes.
+	 *
+	 * Take scaling factor into account as well.
+	 *
+	 * Find absolute limits for the factor of vt divider.
+	 */
+	dev_dbg(dev, "scale_m: %d\n", pll->scale_m);
+	min_vt_div = DIV_ROUND_UP(pll->op_pix_clk_div * pll->op_sys_clk_div
+				  * pll->scale_n,
+				  lane_op_clock_ratio * vt_op_binning_div
+				  * pll->scale_m);
+
+	/* Find smallest and biggest allowed vt divisor. */
+	dev_dbg(dev, "min_vt_div: %d\n", min_vt_div);
+	min_vt_div = max(min_vt_div,
+			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
+				      limits->max_vt_pix_clk_freq_hz));
+	dev_dbg(dev, "min_vt_div: max_vt_pix_clk_freq_hz: %d\n",
+		min_vt_div);
+	min_vt_div = max_t(uint32_t, min_vt_div,
+			   limits->min_vt_pix_clk_div
+			   * limits->min_vt_sys_clk_div);
+	dev_dbg(dev, "min_vt_div: min_vt_clk_div: %d\n", min_vt_div);
+
+	max_vt_div = limits->max_vt_sys_clk_div * limits->max_vt_pix_clk_div;
+	dev_dbg(dev, "max_vt_div: %d\n", max_vt_div);
+	max_vt_div = min(max_vt_div,
+			 DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
+				      limits->min_vt_pix_clk_freq_hz));
+	dev_dbg(dev, "max_vt_div: min_vt_pix_clk_freq_hz: %d\n",
+		max_vt_div);
+
+	/*
+	 * Find limitsits for sys_clk_div. Not all values are possible
+	 * with all values of pix_clk_div.
+	 */
+	min_sys_div = limits->min_vt_sys_clk_div;
+	dev_dbg(dev, "min_sys_div: %d\n", min_sys_div);
+	min_sys_div = max(min_sys_div,
+			  DIV_ROUND_UP(min_vt_div,
+				       limits->max_vt_pix_clk_div));
+	dev_dbg(dev, "min_sys_div: max_vt_pix_clk_div: %d\n", min_sys_div);
+	min_sys_div = max(min_sys_div,
+			  pll->pll_op_clk_freq_hz
+			  / limits->max_vt_sys_clk_freq_hz);
+	dev_dbg(dev, "min_sys_div: max_pll_op_clk_freq_hz: %d\n", min_sys_div);
+	min_sys_div = clk_div_even_up(min_sys_div);
+	dev_dbg(dev, "min_sys_div: one or even: %d\n", min_sys_div);
+
+	max_sys_div = limits->max_vt_sys_clk_div;
+	dev_dbg(dev, "max_sys_div: %d\n", max_sys_div);
+	max_sys_div = min(max_sys_div,
+			  DIV_ROUND_UP(max_vt_div,
+				       limits->min_vt_pix_clk_div));
+	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_div: %d\n", max_sys_div);
+	max_sys_div = min(max_sys_div,
+			  DIV_ROUND_UP(pll->pll_op_clk_freq_hz,
+				       limits->min_vt_pix_clk_freq_hz));
+	dev_dbg(dev, "max_sys_div: min_vt_pix_clk_freq_hz: %d\n", max_sys_div);
+
+	/*
+	 * Find pix_div such that a legal pix_div * sys_div results
+	 * into a value which is not smaller than div, the desired
+	 * divisor.
+	 */
+	for (vt_div = min_vt_div; vt_div <= max_vt_div;
+	     vt_div += 2 - (vt_div & 1)) {
+		for (sys_div = min_sys_div;
+		     sys_div <= max_sys_div;
+		     sys_div += 2 - (sys_div & 1)) {
+			int pix_div = DIV_ROUND_UP(vt_div, sys_div);
+
+			if (pix_div < limits->min_vt_pix_clk_div
+			    || pix_div > limits->max_vt_pix_clk_div) {
+				dev_dbg(dev,
+					"pix_div %d too small or too big (%d--%d)\n",
+					pix_div,
+					limits->min_vt_pix_clk_div,
+					limits->max_vt_pix_clk_div);
+				continue;
+			}
+
+			/* Check if this one is better. */
+			if (pix_div * sys_div
+			    <= ALIGN(min_vt_div, best_pix_div))
+				best_pix_div = pix_div;
+		}
+		if (best_pix_div < INT_MAX >> 1)
+			break;
+	}
+
+	pll->vt_sys_clk_div = DIV_ROUND_UP(min_vt_div, best_pix_div);
+	pll->vt_pix_clk_div = best_pix_div;
+
+	pll->vt_sys_clk_freq_hz =
+		pll->pll_op_clk_freq_hz / pll->vt_sys_clk_div;
+	pll->vt_pix_clk_freq_hz =
+		pll->vt_sys_clk_freq_hz / pll->vt_pix_clk_div;
+
+	pll->pixel_rate_csi =
+		pll->op_pix_clk_freq_hz * lane_op_clock_ratio;
+
+	print_pll(dev, pll);
+
+	rval = bounds_check(dev, pll->pre_pll_clk_div,
+			    limits->min_pre_pll_clk_div,
+			    limits->max_pre_pll_clk_div, "pre_pll_clk_div");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->pll_ip_clk_freq_hz,
+			limits->min_pll_ip_freq_hz, limits->max_pll_ip_freq_hz,
+			"pll_ip_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->pll_multiplier,
+			limits->min_pll_multiplier, limits->max_pll_multiplier,
+			"pll_multiplier");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->pll_op_clk_freq_hz,
+			limits->min_pll_op_freq_hz, limits->max_pll_op_freq_hz,
+			"pll_op_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_sys_clk_div,
+			limits->min_op_sys_clk_div, limits->max_op_sys_clk_div,
+			"op_sys_clk_div");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_pix_clk_div,
+			limits->min_op_pix_clk_div, limits->max_op_pix_clk_div,
+			"op_pix_clk_div");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_sys_clk_freq_hz,
+			limits->min_op_sys_clk_freq_hz,
+			limits->max_op_sys_clk_freq_hz,
+			"op_sys_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->op_pix_clk_freq_hz,
+			limits->min_op_pix_clk_freq_hz,
+			limits->max_op_pix_clk_freq_hz,
+			"op_pix_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->vt_sys_clk_freq_hz,
+			limits->min_vt_sys_clk_freq_hz,
+			limits->max_vt_sys_clk_freq_hz,
+			"vt_sys_clk_freq_hz");
+	if (!rval)
+		rval = bounds_check(
+			dev, pll->vt_pix_clk_freq_hz,
+			limits->min_vt_pix_clk_freq_hz,
+			limits->max_vt_pix_clk_freq_hz,
+			"vt_pix_clk_freq_hz");
+
+	return rval;
+}
+EXPORT_SYMBOL_GPL(smiapp_pll_calculate);
+
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>");
+MODULE_DESCRIPTION("Generic SMIA/SMIA++ PLL calculator");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/smiapp-pll.h b/drivers/media/video/smiapp-pll.h
new file mode 100644
index 0000000..9eab63f
--- /dev/null
+++ b/drivers/media/video/smiapp-pll.h
@@ -0,0 +1,103 @@
+/*
+ * drivers/media/video/smiapp-pll.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
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
+ *
+ */
+
+#ifndef SMIAPP_PLL_H
+#define SMIAPP_PLL_H
+
+#include <linux/device.h>
+
+struct smiapp_pll {
+	uint8_t lanes;
+	uint8_t binning_horizontal;
+	uint8_t binning_vertical;
+	uint8_t scale_m;
+	uint8_t scale_n;
+	uint8_t bits_per_pixel;
+	uint16_t flags;
+	uint32_t link_freq;
+
+	uint16_t pre_pll_clk_div;
+	uint16_t pll_multiplier;
+	uint16_t op_sys_clk_div;
+	uint16_t op_pix_clk_div;
+	uint16_t vt_sys_clk_div;
+	uint16_t vt_pix_clk_div;
+
+	uint32_t ext_clk_freq_hz;
+	uint32_t pll_ip_clk_freq_hz;
+	uint32_t pll_op_clk_freq_hz;
+	uint32_t op_sys_clk_freq_hz;
+	uint32_t op_pix_clk_freq_hz;
+	uint32_t vt_sys_clk_freq_hz;
+	uint32_t vt_pix_clk_freq_hz;
+
+	uint32_t pixel_rate_csi;
+};
+
+struct smiapp_pll_limits {
+	/* Strict PLL limits */
+	uint32_t min_ext_clk_freq_hz;
+	uint32_t max_ext_clk_freq_hz;
+	uint16_t min_pre_pll_clk_div;
+	uint16_t max_pre_pll_clk_div;
+	uint32_t min_pll_ip_freq_hz;
+	uint32_t max_pll_ip_freq_hz;
+	uint16_t min_pll_multiplier;
+	uint16_t max_pll_multiplier;
+	uint32_t min_pll_op_freq_hz;
+	uint32_t max_pll_op_freq_hz;
+
+	uint16_t min_vt_sys_clk_div;
+	uint16_t max_vt_sys_clk_div;
+	uint32_t min_vt_sys_clk_freq_hz;
+	uint32_t max_vt_sys_clk_freq_hz;
+	uint16_t min_vt_pix_clk_div;
+	uint16_t max_vt_pix_clk_div;
+	uint32_t min_vt_pix_clk_freq_hz;
+	uint32_t max_vt_pix_clk_freq_hz;
+
+	uint16_t min_op_sys_clk_div;
+	uint16_t max_op_sys_clk_div;
+	uint32_t min_op_sys_clk_freq_hz;
+	uint32_t max_op_sys_clk_freq_hz;
+	uint16_t min_op_pix_clk_div;
+	uint16_t max_op_pix_clk_div;
+	uint32_t min_op_pix_clk_freq_hz;
+	uint32_t max_op_pix_clk_freq_hz;
+
+	/* Other relevant limits */
+	uint32_t min_line_length_pck_bin;
+	uint32_t min_line_length_pck;
+};
+
+/* op pix clock is for all lanes in total normally */
+#define SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
+#define SMIAPP_PLL_FLAG_NO_OP_CLOCKS				(1 << 1)
+
+struct device;
+
+int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
+			 struct smiapp_pll *pll);
+
+#endif /* SMIAPP_PLL_H */
-- 
1.7.2.5

