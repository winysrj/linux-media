Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44138 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751318AbdGQWBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:01:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: pavel@ucw.cz, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/7] Omap3isp CCP2 support
Date: Tue, 18 Jul 2017 01:01:09 +0300
Message-Id: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

I rebased the ccp2 branch and went through the patches. I didn't find
anything really alarming there; I changed one commit description of
"omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode" that had
some junk in it as well as in the last patch changed the condition in
omap3isp_csiphy_release() that was obviously wrong.

Let me know what you think.

If we merge these, is there anything still missing from plain ccp2 support?

I'd like to get Laurent's comment on these, too, plus a confirmation
nothing is broken by these on the OMAP 3 boards he uses.


Pavel Machek (3):
  omap3isp: Parse CSI1 configuration from the device tree
  omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode
  omap3isp: Return -EPROBE_DEFER if the required regulators can't be
    obtained

Sakari Ailus (4):
  omap3isp: Ignore endpoints with invalid configuration
  omap3isp: Always initialise isp and mutex for csiphy1
  omap3isp: Correctly put the last iterated endpoint fwnode always
  omap3isp: Skip CSI-2 receiver initialisation in CCP2 configuration

 drivers/media/platform/omap3isp/isp.c       | 128 ++++++++++++++++++++--------
 drivers/media/platform/omap3isp/ispccp2.c   |  12 ++-
 drivers/media/platform/omap3isp/ispcsiphy.c |  46 ++++++----
 drivers/media/platform/omap3isp/ispreg.h    |   4 +
 drivers/media/platform/omap3isp/omap3isp.h  |   1 +
 5 files changed, 140 insertions(+), 51 deletions(-)

-- 
Kind regards,
Sakari
