Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133FAC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C732B20837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C732B20837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbeLGN4A (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:56:00 -0500
Received: from mail.bootlin.com ([62.4.15.54]:58711 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbeLGNzz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 08:55:55 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 0FF1020DBC; Fri,  7 Dec 2018 14:55:53 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id C01A320CC3;
        Fri,  7 Dec 2018 14:55:42 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
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
Subject: [PATCH v3 03/10] phy: Add MIPI D-PHY configuration options
Date:   Fri,  7 Dec 2018 14:55:30 +0100
Message-Id: <96a74b72be8db491dea720fdd7394bcd09880c84.1544190837.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
References: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that we have some infrastructure for it, allow the MIPI D-PHY phy's to
be configured through the generic functions through a custom structure
added to the generic union.

The parameters added here are the ones defined in the MIPI D-PHY spec, plus
the number of lanes in use. The current set of parameters should cover all
the potential users.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 include/linux/phy/phy-mipi-dphy.h | 279 +++++++++++++++++++++++++++++++-
 include/linux/phy/phy.h           |   6 +-
 2 files changed, 285 insertions(+)
 create mode 100644 include/linux/phy/phy-mipi-dphy.h

diff --git a/include/linux/phy/phy-mipi-dphy.h b/include/linux/phy/phy-mipi-dphy.h
new file mode 100644
index 000000000000..29bf94db88ad
--- /dev/null
+++ b/include/linux/phy/phy-mipi-dphy.h
@@ -0,0 +1,279 @@
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
+	 * Timeout, in picoseconds, for receiver to detect absence of
+	 * Clock transitions and disable the Clock Lane HS-RX.
+	 *
+	 * Maximum value: 60000 ps
+	 */
+	unsigned int		clk_miss;
+
+	/**
+	 * @clk_post:
+	 *
+	 * Time, in picoseconds, that the transmitter continues to
+	 * send HS clock after the last associated Data Lane has
+	 * transitioned to LP Mode. Interval is defined as the period
+	 * from the end of @hs_trail to the beginning of @clk_trail.
+	 *
+	 * Minimum value: 60000 ps + 52 * @hs_clk_rate period in ps
+	 */
+	unsigned int		clk_post;
+
+	/**
+	 * @clk_pre:
+	 *
+	 * Time, in UI, that the HS clock shall be driven by
+	 * the transmitter prior to any associated Data Lane beginning
+	 * the transition from LP to HS mode.
+	 *
+	 * Minimum value: 8 UI
+	 */
+	unsigned int		clk_pre;
+
+	/**
+	 * @clk_prepare:
+	 *
+	 * Time, in picoseconds, that the transmitter drives the Clock
+	 * Lane LP-00 Line state immediately before the HS-0 Line
+	 * state starting the HS transmission.
+	 *
+	 * Minimum value: 38000 ps
+	 * Maximum value: 95000 ps
+	 */
+	unsigned int		clk_prepare;
+
+	/**
+	 * @clk_settle:
+	 *
+	 * Time interval, in picoseconds, during which the HS receiver
+	 * should ignore any Clock Lane HS transitions, starting from
+	 * the beginning of @clk_prepare.
+	 *
+	 * Minimum value: 95000 ps
+	 * Maximum value: 300000 ps
+	 */
+	unsigned int		clk_settle;
+
+	/**
+	 * @clk_term_en:
+	 *
+	 * Time, in picoseconds, for the Clock Lane receiver to enable
+	 * the HS line termination.
+	 *
+	 * Maximum value: 38000 ps
+	 */
+	unsigned int		clk_term_en;
+
+	/**
+	 * @clk_trail:
+	 *
+	 * Time, in picoseconds, that the transmitter drives the HS-0
+	 * state after the last payload clock bit of a HS transmission
+	 * burst.
+	 *
+	 * Minimum value: 60000 ps
+	 */
+	unsigned int		clk_trail;
+
+	/**
+	 * @clk_zero:
+	 *
+	 * Time, in picoseconds, that the transmitter drives the HS-0
+	 * state prior to starting the Clock.
+	 */
+	unsigned int		clk_zero;
+
+	/**
+	 * @d_term_en:
+	 *
+	 * Time, in picoseconds, for the Data Lane receiver to enable
+	 * the HS line termination.
+	 *
+	 * Maximum value: 35000 ps + 4 * @hs_clk_rate period in ps
+	 */
+	unsigned int		d_term_en;
+
+	/**
+	 * @eot:
+	 *
+	 * Transmitted time interval, in picoseconds, from the start
+	 * of @hs_trail or @clk_trail, to the start of the LP- 11
+	 * state following a HS burst.
+	 *
+	 * Maximum value: 105000 ps + 12 * @hs_clk_rate period in ps
+	 */
+	unsigned int		eot;
+
+	/**
+	 * @hs_exit:
+	 *
+	 * Time, in picoseconds, that the transmitter drives LP-11
+	 * following a HS burst.
+	 *
+	 * Minimum value: 100000 ps
+	 */
+	unsigned int		hs_exit;
+
+	/**
+	 * @hs_prepare:
+	 *
+	 * Time, in picoseconds, that the transmitter drives the Data
+	 * Lane LP-00 Line state immediately before the HS-0 Line
+	 * state starting the HS transmission.
+	 *
+	 * Minimum value: 40000 ps + 4 * @hs_clk_rate period in ps
+	 * Maximum value: 85000 ps + 6 * @hs_clk_rate period in ps
+	 */
+	unsigned int		hs_prepare;
+
+	/**
+	 * @hs_settle:
+	 *
+	 * Time interval, in picoseconds, during which the HS receiver
+	 * shall ignore any Data Lane HS transitions, starting from
+	 * the beginning of @hs_prepare.
+	 *
+	 * Minimum value: 85000 ps + 6 * @hs_clk_rate period in ps
+	 * Maximum value: 145000 ps + 10 * @hs_clk_rate period in ps
+	 */
+	unsigned int		hs_settle;
+
+	/**
+	 * @hs_skip:
+	 *
+	 * Time interval, in picoseconds, during which the HS-RX
+	 * should ignore any transitions on the Data Lane, following a
+	 * HS burst. The end point of the interval is defined as the
+	 * beginning of the LP-11 state following the HS burst.
+	 *
+	 * Minimum value: 40000 ps
+	 * Maximum value: 55000 ps + 4 * @hs_clk_rate period in ps
+	 */
+	unsigned int		hs_skip;
+
+	/**
+	 * @hs_trail:
+	 *
+	 * Time, in picoseconds, that the transmitter drives the
+	 * flipped differential state after last payload data bit of a
+	 * HS transmission burst
+	 *
+	 * Minimum value: max(8 * @hs_clk_rate period in ps,
+	 *		      60000 ps + 4 * @hs_clk_rate period in ps)
+	 */
+	unsigned int		hs_trail;
+
+	/**
+	 * @hs_zero:
+	 *
+	 * Time, in picoseconds, that the transmitter drives the HS-0
+	 * state prior to transmitting the Sync sequence.
+	 */
+	unsigned int		hs_zero;
+
+	/**
+	 * @init:
+	 *
+	 * Time, in picoseconds for the initialization period to
+	 * complete.
+	 *
+	 * Minimum value: 100000000 ps
+	 */
+	unsigned int		init;
+
+	/**
+	 * @lpx:
+	 *
+	 * Transmitted length, in picoseconds, of any Low-Power state
+	 * period.
+	 *
+	 * Minimum value: 50000 ps
+	 */
+	unsigned int		lpx;
+
+	/**
+	 * @ta_get:
+	 *
+	 * Time, in picoseconds, that the new transmitter drives the
+	 * Bridge state (LP-00) after accepting control during a Link
+	 * Turnaround.
+	 *
+	 * Value: 5 * @lpx
+	 */
+	unsigned int		ta_get;
+
+	/**
+	 * @ta_go:
+	 *
+	 * Time, in picoseconds, that the transmitter drives the
+	 * Bridge state (LP-00) before releasing control during a Link
+	 * Turnaround.
+	 *
+	 * Value: 4 * @lpx
+	 */
+	unsigned int		ta_go;
+
+	/**
+	 * @ta_sure:
+	 *
+	 * Time, in picoseconds, that the new transmitter waits after
+	 * the LP-10 state before transmitting the Bridge state
+	 * (LP-00) during a Link Turnaround.
+	 *
+	 * Minimum value: @lpx
+	 * Maximum value: 2 * @lpx
+	 */
+	unsigned int		ta_sure;
+
+	/**
+	 * @wakeup:
+	 *
+	 * Time, in picoseconds, that a transmitter drives a Mark-1
+	 * state prior to a Stop state in order to initiate an exit
+	 * from ULPS.
+	 *
+	 * Minimum value: 1000000000 ps
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
+	 * Number of active data lanes used for the transmissions.
+	 */
+	unsigned char		lanes;
+};
+
+#endif /* __PHY_MIPI_DPHY_H_ */
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 04476c026b5a..1fdefadf150a 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -20,6 +20,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 
+#include <linux/phy/phy-mipi-dphy.h>
+
 struct phy;
 
 enum phy_mode {
@@ -44,8 +46,12 @@ enum phy_mode {
 
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
