Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37595 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2DWL3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:29:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/4] Miscellaneous OMAP3 ISP fixes and enhancements
Date: Mon, 23 Apr 2012 13:29:51 +0200
Message-Id: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are 4 miscellaneous patches for the OMAP3 ISP driver.

Laurent Pinchart (4):
  omap3isp: preview: Rename last occurences of *_rgb_to_ycbcr to *_csc
  omap3isp: preview: Add support for greyscale input
  omap3isp: ccdc: Add crop support on output formatter source pad
  omap3isp: Mark probe and cleanup functions with __devinit and
    __devexit

 drivers/media/video/omap3isp/isp.c        |    6 +-
 drivers/media/video/omap3isp/ispccdc.c    |  147 ++++++++++++++++++++++++++---
 drivers/media/video/omap3isp/ispccdc.h    |    2 +
 drivers/media/video/omap3isp/isppreview.c |   58 +++++++-----
 4 files changed, 172 insertions(+), 41 deletions(-)

-- 
Regards,

Laurent Pinchart

