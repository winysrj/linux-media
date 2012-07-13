Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58828 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2GMLhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:37:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 0/6] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Fri, 13 Jul 2012 13:37:32 +0200
Message-Id: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the third version of the non-GRBG Bayer patterns support for the OMAP3
ISP preview engine. Compared to v2, the OMAP3ISP_PREV_GAMMABYPASS has been
removed and the CFA table is now stored in a multi-dimensional array.

Laurent Pinchart (6):
  omap3isp: preview: Fix contrast and brightness handling
  omap3isp: preview: Remove lens shading compensation support
  omap3isp: preview: Pass a prev_params pointer to configuration
    functions
  omap3isp: preview: Reorder configuration functions
  omap3isp: preview: Merge gamma correction and gamma bypass
  omap3isp: preview: Add support for non-GRBG Bayer patterns

 drivers/media/video/omap3isp/cfa_coef_table.h |   16 +-
 drivers/media/video/omap3isp/isppreview.c     |  707 ++++++++++++-------------
 drivers/media/video/omap3isp/isppreview.h     |    1 +
 include/linux/omap3isp.h                      |    5 +-
 4 files changed, 355 insertions(+), 374 deletions(-)

-- 
Regards,

Laurent Pinchart

