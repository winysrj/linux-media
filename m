Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC48C2F441
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A758F20879
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 15:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbfAUPqO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 10:46:14 -0500
Received: from mail.bootlin.com ([62.4.15.54]:32903 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730567AbfAUPqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 10:46:13 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id A9AA4209EF; Mon, 21 Jan 2019 16:46:11 +0100 (CET)
Received: from localhost (unknown [185.94.189.187])
        by mail.bootlin.com (Postfix) with ESMTPSA id AF4BC20C04;
        Mon, 21 Jan 2019 16:45:56 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
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
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v5 2/9] phy: dphy: Change units of wakeup and init parameters
Date:   Mon, 21 Jan 2019 16:45:47 +0100
Message-Id: <e79e5f775b092787e4f5dd660928d1b9f70470a5.1548085432.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The Init and wakeup D-PHY parameters are in the micro/milliseconds range,
putting the values real close to the types limits if they were in
picoseconds.

Move them to microseconds which should be better fit.

Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/phy/phy-core-mipi-dphy.c  | 8 ++++----
 include/linux/phy/phy-mipi-dphy.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
index 465fa1b91a5f..14e0551cd319 100644
--- a/drivers/phy/phy-core-mipi-dphy.c
+++ b/drivers/phy/phy-core-mipi-dphy.c
@@ -65,12 +65,12 @@ int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
 	 */
 	cfg->hs_trail = max(4 * 8 * ui, 60000 + 4 * 4 * ui);
 
-	cfg->init = 100000000;
+	cfg->init = 100;
 	cfg->lpx = 60000;
 	cfg->ta_get = 5 * cfg->lpx;
 	cfg->ta_go = 4 * cfg->lpx;
 	cfg->ta_sure = 2 * cfg->lpx;
-	cfg->wakeup = 1000000000;
+	cfg->wakeup = 1000;
 
 	cfg->hs_clk_rate = hs_clk_rate;
 	cfg->lanes = lanes;
@@ -143,7 +143,7 @@ int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg)
 	if (cfg->hs_trail < max(8 * ui, 60000 + 4 * ui))
 		return -EINVAL;
 
-	if (cfg->init < 100000000)
+	if (cfg->init < 100)
 		return -EINVAL;
 
 	if (cfg->lpx < 50000)
@@ -158,7 +158,7 @@ int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg)
 	if (cfg->ta_sure < cfg->lpx || cfg->ta_sure > (2 * cfg->lpx))
 		return -EINVAL;
 
-	if (cfg->wakeup < 1000000000)
+	if (cfg->wakeup < 1000)
 		return -EINVAL;
 
 	return 0;
diff --git a/include/linux/phy/phy-mipi-dphy.h b/include/linux/phy/phy-mipi-dphy.h
index 9cf97cd1d303..627d28080d3a 100644
--- a/include/linux/phy/phy-mipi-dphy.h
+++ b/include/linux/phy/phy-mipi-dphy.h
@@ -190,10 +190,10 @@ struct phy_configure_opts_mipi_dphy {
 	/**
 	 * @init:
 	 *
-	 * Time, in picoseconds for the initialization period to
+	 * Time, in microseconds for the initialization period to
 	 * complete.
 	 *
-	 * Minimum value: 100000000 ps
+	 * Minimum value: 100 us
 	 */
 	unsigned int		init;
 
@@ -244,11 +244,11 @@ struct phy_configure_opts_mipi_dphy {
 	/**
 	 * @wakeup:
 	 *
-	 * Time, in picoseconds, that a transmitter drives a Mark-1
+	 * Time, in microseconds, that a transmitter drives a Mark-1
 	 * state prior to a Stop state in order to initiate an exit
 	 * from ULPS.
 	 *
-	 * Minimum value: 1000000000 ps
+	 * Minimum value: 1000 us
 	 */
 	unsigned int		wakeup;
 
-- 
git-series 0.9.1
