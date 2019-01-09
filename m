Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB7DC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 09:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E49C20883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 09:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbfAIJei (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 04:34:38 -0500
Received: from mail.bootlin.com ([62.4.15.54]:37241 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbfAIJdl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 04:33:41 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 6E09620A16; Wed,  9 Jan 2019 10:33:39 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id 1194F209BD;
        Wed,  9 Jan 2019 10:33:29 +0100 (CET)
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
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v4 0/9] phy: Add configuration interface for MIPI D-PHY devices
Date:   Wed,  9 Jan 2019 10:33:17 +0100
Message-Id: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Here is a set of patches to allow the phy framework consumers to test and
apply runtime configurations.

This is needed to support more phy classes that require tuning based on
parameters depending on the current use case of the device, in addition to
the power state management already provided by the current functions.

A first test bed for that API are the MIPI D-PHY devices. There's a number
of solutions that have been used so far to support these phy, most of the
time being an ad-hoc driver in the consumer.

That approach has a big shortcoming though, which is that this is quite
difficult to deal with consumers integrated with multiple variants of phy,
of multiple consumers integrated with the same phy.

The latter case can be found in the Cadence DSI bridge, and the CSI
transceiver and receivers. All of them are integrated with the same phy, or
can be integrated with different phy, depending on the implementation.

I've looked at all the MIPI DSI drivers I could find, and gathered all the
parameters I could find. The interface should be complete, and most of the
drivers can be converted in the future. The current set converts two of
them: the above mentionned Cadence DSI driver so that the v4l2 drivers can
use them, and the Allwinner MIPI-DSI driver.

Let me know what you think,
Maxime

Changes from v3
  - Rebased on 5.0-rc1
  - Added the fixes suggested by Sakari

Changes from v2:
  - Rebased on next
  - Changed the interface to accomodate for the new submodes
  - Changed the timings units from nanoseconds to picoseconds
  - Added minimum and maximum boundaries to the documentation
  - Moved the clock enabling to phy_power_on in the Cadence DPHY driver
  - Exported the phy_configure and phy_validate symbols
  - Rework the phy pll divider computation in the cadence dphy driver

Changes from v1:
  - Rebased on top of 4.20-rc1
  - Removed the bus mode and timings parameters from the MIPI D-PHY
    parameters, since that shouldn't have any impact on the PHY itself.
  - Reworked the Cadence DSI and D-PHY drivers to take this into account.
  - Remove the mode parameter from phy_configure
  - Added phy_configure and phy_validate stubs
  - Return -EOPNOTSUPP in phy_configure and phy_validate when the operation
    is not implemented

Maxime Ripard (9):
  phy: dphy: Remove unused header
  phy: dphy: Change units of wakeup and init parameters
  phy: dphy: Clarify lanes parameter documentation
  sun6i: dsi: Convert to generic phy handling
  phy: Move Allwinner A31 D-PHY driver to drivers/phy/
  drm/bridge: cdns: Separate DSI and D-PHY configuration
  dt-bindings: phy: Move the Cadence D-PHY bindings
  phy: Add Cadence D-PHY support
  drm/bridge: cdns: Convert to phy framework

 Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt |  21 +-
 Documentation/devicetree/bindings/phy/cdns,dphy.txt           |  20 +-
 drivers/gpu/drm/bridge/Kconfig                                |   1 +-
 drivers/gpu/drm/bridge/cdns-dsi.c                             | 535 +------
 drivers/gpu/drm/sun4i/Kconfig                                 |   3 +-
 drivers/gpu/drm/sun4i/Makefile                                |   5 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c                       | 292 +----
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                        |  31 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h                        |  17 +-
 drivers/phy/allwinner/Kconfig                                 |  12 +-
 drivers/phy/allwinner/Makefile                                |   1 +-
 drivers/phy/allwinner/phy-sun6i-mipi-dphy.c                   | 318 ++++-
 drivers/phy/cadence/Kconfig                                   |  13 +-
 drivers/phy/cadence/Makefile                                  |   1 +-
 drivers/phy/cadence/cdns-dphy.c                               | 389 +++++-
 drivers/phy/phy-core-mipi-dphy.c                              |   8 +-
 include/linux/phy/phy-mipi-dphy.h                             |  13 +-
 17 files changed, 890 insertions(+), 790 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/cdns,dphy.txt
 delete mode 100644 drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
 create mode 100644 drivers/phy/allwinner/phy-sun6i-mipi-dphy.c
 create mode 100644 drivers/phy/cadence/cdns-dphy.c

base-commit: bfeffd155283772bbe78c6a05dec7c0128ee500c
-- 
git-series 0.9.1
