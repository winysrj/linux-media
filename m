Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47212 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab3AHNmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 08:42:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 0/2] OMAP3 ISP: Simplify clock usage
Date: Tue,  8 Jan 2013 14:43:52 +0100
Message-Id: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Now that the OMAP3 supports the common clock framework, clock rate
back-propagation is available for the ISP clocks. Instead of setting the
cam_mclk parent clock rate to control the cam_mclk clock rate, we can mark the
dpll4_m5x2_ck_3630 and cam_mclk clocks as supporting back-propagation, and set
the cam_mclk rate directly. This simplifies the ISP clocks configuration.

Laurent Pinchart (2):
  ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to
    dpll4_m5
  omap3isp: Set cam_mclk rate directly

 arch/arm/mach-omap2/cclock3xxx_data.c |   10 +++++++++-
 drivers/media/platform/omap3isp/isp.c |   18 ++----------------
 drivers/media/platform/omap3isp/isp.h |    8 +++-----
 3 files changed, 14 insertions(+), 22 deletions(-)

-- 
Regards,

Laurent Pinchart

