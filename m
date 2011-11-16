Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55308 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1KPUGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 15:06:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/4] Miscellaneous omap3-isp patches
Date: Wed, 16 Nov 2011 21:06:42 +0100
Message-Id: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

The subject says it all. Two of the patches fix crashes, while the other two
are minor modifications with no impact on the compiled code. I'll push them
for v3.3.

Laurent Pinchart (4):
  omap3isp: preview: Rename max output sizes defines
  omap3isp: ccdc: Fix crash in HS/VS interrupt handler
  omap3isp: Fix crash caused by subdevs now having a pointer to
    devnodes
  omap3isp: Clarify the clk_pol field in platform data

 drivers/media/video/omap3isp/ispccdc.c    |    5 ++---
 drivers/media/video/omap3isp/isppreview.c |   16 ++++++++--------
 drivers/media/video/omap3isp/ispstat.c    |    2 +-
 include/media/omap3isp.h                  |    2 +-
 4 files changed, 12 insertions(+), 13 deletions(-)

-- 
Regards,

Laurent Pinchart

