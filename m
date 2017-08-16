Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48992 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751287AbdHPMvw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:51:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 0/5] Omap3isp CCP2 support
Date: Wed, 16 Aug 2017 15:51:45 +0300
Message-Id: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here's a respin of the omap3isp ccp2 support patches.

since v1:

- Root out patches already merged or not needed (omapisp: Ignore endpoints
  with invalid configuration).

- Rework the patch skipping CSI-2 receiver configuration for CCP2
  ("omap3isp: Skip CSI-2 receiver initialisation in CCP2 configuration").
  Instead of trying to figure out which receiver (CSI-2 or CCP2) is used,
  store the information to the isp_csiphy struct instead.

- Added a patch to correctly release a CSI-2 phy --- the PHY configuration
  coming from DT was previously ignored.

Pavel Machek (2):
  omap3isp: Parse CSI1 configuration from the device tree
  omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode

Sakari Ailus (3):
  omap3isp: Always initialise isp and mutex for csiphy1
  omap3isp: csiphy: Don't assume the CSI receiver is a CSI2 module
  omap3isp: Correctly configure routing in PHY release

 drivers/media/platform/omap3isp/isp.c       | 105 +++++++++++++++++++++-------
 drivers/media/platform/omap3isp/ispccp2.c   |   9 ++-
 drivers/media/platform/omap3isp/ispcsi2.c   |   4 +-
 drivers/media/platform/omap3isp/ispcsiphy.c |  59 ++++++++--------
 drivers/media/platform/omap3isp/ispcsiphy.h |   6 +-
 drivers/media/platform/omap3isp/ispreg.h    |   4 ++
 drivers/media/platform/omap3isp/omap3isp.h  |   1 +
 7 files changed, 126 insertions(+), 62 deletions(-)

-- 
2.11.0
