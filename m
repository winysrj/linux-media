Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53528 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2GFNcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 09:32:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Jean-Philippe Francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 0/6] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Fri,  6 Jul 2012 15:32:43 +0200
Message-Id: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the second version of the non-GRBG Bayer patterns support for the OMAP3
ISP preview engine. Compared to v1, the CFA table can be reconfigured at
runtime, which resulted in several cleanup patches.

The first patch is a v3.5 regression fix, I'll send a separate pull request.

Jean-Philippe, could you please test this patch set on your hardware ? It's
based on top of the latest linuxtv/staging/for_v3.6 branch.

Laurent Pinchart (6):
  omap3isp: preview: Fix contrast and brightness handling
  omap3isp: preview: Remove lens shading compensation support
  omap3isp: preview: Pass a prev_params pointer to configuration
    functions
  omap3isp: preview: Reorder configuration functions
  omap3isp: preview: Merge gamma correction and gamma bypass
  omap3isp: preview: Add support for non-GRBG Bayer patterns

 drivers/media/video/omap3isp/isppreview.c |  706 ++++++++++++++---------------
 drivers/media/video/omap3isp/isppreview.h |    1 +
 2 files changed, 346 insertions(+), 361 deletions(-)

-- 
Regards,

Laurent Pinchart

