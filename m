Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51840 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388908AbeKGAUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 19:20:22 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 3/9] phy: Add MIPI D-PHY configuration options
Date: Tue,  6 Nov 2018 15:54:15 +0100
Message-Id: <b1f6e4c1c3487e1f048cce699a86bcf50f7fed69.1541516029.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have some infrastructure for it, allow the MIPI D-PHY phy's to
be configured through the generic functions through a custom structure
added to the generic union.

The parameters added here are the ones defined in the MIPI D-PHY spec, plus
the number of lanes in use. The current set of parameters should cover all
the potential users.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 include/linux/phy/phy-mipi-dphy.h | 232 +++++++++++++++++++++++++++++++-
 include/linux/phy/phy.h           |   6 +-
 2 files changed, 238 insertions(+)
 create mode 100644 include/linux/phy/phy-mipi-dphy.h

diff --git a/include/linux/phy/phy-mipi-dphy.h b/include/linux/phy/phy-mipi-dphy.h
new file mode 100644
index 000000000000..0b05932916af
--- /dev/null
+++ b/include/linux/phy/phy-mipi-dphy.h
@@ -0,0 +1,232 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 Cadence Design Systems Inc.
+ */
+
+#ifndef __PHY_MIPI_DPHY_H_
+#define __PHY_MIPI_DPHY_H_
+
+#include <video/videomode.h>
+
+/**
+ * struct phy_configure_opts_mipi_dphy - MIPI D-PHY configuration set
+ *
+ * This structure is used to represent the configuration state of a
+ * MIPI D-PHY phy.
+ */
+struct phy_configure_opts_mipi_dphy {
+	/**
+	 * @clk_miss:
+	 *
+	 * Timeout, in nanoseconds, for receiver to detect absence of
+	 * Clock transitions and disable the Clock Lane HS-RX.
+	 */
+	unsigned int		clk_miss;
+
+	/**
+	 * @clk_post:
+	 *
+	 * Time, in nanoseconds, that the transmitter continues to
+	 * send HS clock after the last associated Data Lane has
+	 * transitioned to LP Mode. Interval is defined as the period
+	 * from the end of @hs_trail to the beginning of @clk_trail.
+	 */
+	unsigned int		clk_post;
+
+	/**
+	 * @clk_pre:
+	 *
+	 * Time, in nanoseconds, that the HS clock shall be driven by
+	 * the transmitter prior to any associated Data Lane beginning
+	 * the transition from LP to HS mode.
+	 */
+	unsigned int		clk_pre;
+
+	/**
+	 * @clk_prepare:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives the Clock
+	 * Lane LP-00 Line state immediately before the HS-0 Line
+	 * state starting the HS transmission.
+	 */
+	unsigned int		clk_prepare;
+
+	/**
+	 * @clk_settle:
+	 *
+	 * Time interval, in nanoseconds, during which the HS receiver
+	 * should ignore any Clock Lane HS transitions, starting from
+	 * the beginning of @clk_prepare.
+	 */
+	unsigned int		clk_settle;
+
+	/**
+	 * @clk_term_en:
+	 *
+	 * Time, in nanoseconds, for the Clock Lane receiver to enable
+	 * the HS line termination.
+	 */
+	unsigned int		clk_term_en;
+
+	/**
+	 * @clk_trail:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives the HS-0
+	 * state after the last payload clock bit of a HS transmission
+	 * burst.
+	 */
+	unsigned int		clk_trail;
+
+	/**
+	 * @clk_zero:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives the HS-0
+	 * state prior to starting the Clock.
+	 */
+	unsigned int		clk_zero;
+
+	/**
+	 * @d_term_en:
+	 *
+	 * Time, in nanoseconds, for the Data Lane receiver to enable
+	 * the HS line termination.
+	 */
+	unsigned int		d_term_en;
+
+	/**
+	 * @eot:
+	 *
+	 * Transmitted time interval, in nanoseconds, from the start
+	 * of @hs_trail or @clk_trail, to the start of the LP- 11
+	 * state following a HS burst.
+	 */
+	unsigned int		eot;
+
+	/**
+	 * @hs_exit:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives LP-11
+	 * following a HS burst.
+	 */
+	unsigned int		hs_exit;
+
+	/**
+	 * @hs_prepare:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives the Data
+	 * Lane LP-00 Line state immediately before the HS-0 Line
+	 * state starting the HS transmission
+	 */
+	unsigned int		hs_prepare;
+
+	/**
+	 * @hs_settle:
+	 *
+	 * Time interval, in nanoseconds, during which the HS receiver
+	 * shall ignore any Data Lane HS transitions, starting from
+	 * the beginning of @hs_prepare.
+	 */
+	unsigned int		hs_settle;
+
+	/**
+	 * @hs_skip:
+	 *
+	 * Time interval, in nanoseconds, during which the HS-RX
+	 * should ignore any transitions on the Data Lane, following a
+	 * HS burst. The end point of the interval is defined as the
+	 * beginning of the LP-11 state following the HS burst.
+	 */
+	unsigned int		hs_skip;
+
+	/**
+	 * @hs_trail:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives the
+	 * flipped differential state after last payload data bit of a
+	 * HS transmission burst
+	 */
+	unsigned int		hs_trail;
+
+	/**
+	 * @hs_zero:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives the HS-0
+	 * state prior to transmitting the Sync sequence.
+	 */
+	unsigned int		hs_zero;
+
+	/**
+	 * @init:
+	 *
+	 * Time, in nanoseconds for the initialization period to
+	 * complete.
+	 */
+	unsigned int		init;
+
+	/**
+	 * @lpx:
+	 *
+	 * Transmitted length, in nanoseconds, of any Low-Power state
+	 * period.
+	 */
+	unsigned int		lpx;
+
+	/**
+	 * @ta_get:
+	 *
+	 * Time, in nanoseconds, that the new transmitter drives the
+	 * Bridge state (LP-00) after accepting control during a Link
+	 * Turnaround.
+	 */
+	unsigned int		ta_get;
+
+	/**
+	 * @ta_go:
+	 *
+	 * Time, in nanoseconds, that the transmitter drives the
+	 * Bridge state (LP-00) before releasing control during a Link
+	 * Turnaround.
+	 */
+	unsigned int		ta_go;
+
+	/**
+	 * @ta_sure:
+	 *
+	 * Time, in nanoseconds, that the new transmitter waits after
+	 * the LP-10 state before transmitting the Bridge state
+	 * (LP-00) during a Link Turnaround.
+	 */
+	unsigned int		ta_sure;
+
+	/**
+	 * @wakeup:
+	 *
+	 * Time, in nanoseconds, that a transmitter drives a Mark-1
+	 * state prior to a Stop state in order to initiate an exit
+	 * from ULPS.
+	 */
+	unsigned int		wakeup;
+
+	/**
+	 * @hs_clk_rate:
+	 *
+	 * Clock rate, in Hertz, of the high-speed clock.
+	 */
+	unsigned long		hs_clk_rate;
+
+	/**
+	 * @lp_clk_rate:
+	 *
+	 * Clock rate, in Hertz, of the low-power clock.
+	 */
+	unsigned long		lp_clk_rate;
+
+	/**
+	 * @lanes:
+	 *
+	 * Number of lanes used for the transmissions.
+	 */
+	unsigned char		lanes;
+};
+
+#endif /* __PHY_MIPI_DPHY_H_ */
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 89cf8b685546..d7ea2dc4e2be 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -20,6 +20,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 
+#include <linux/phy/phy-mipi-dphy.h>
+
 struct phy;
 
 enum phy_mode {
@@ -47,8 +49,12 @@ enum phy_mode {
 
 /**
  * union phy_configure_opts - Opaque generic phy configuration
+ *
+ * @mipi_dphy:	Configuration set applicable for phys supporting
+ *		the MIPI_DPHY phy mode.
  */
 union phy_configure_opts {
+	struct phy_configure_opts_mipi_dphy	mipi_dphy;
 };
 
 /**
-- 
git-series 0.9.1
