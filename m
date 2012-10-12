Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54542 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820Ab2JLS0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 14:26:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] Miscellaneous OMAP3 ISP fixes
Date: Fri, 12 Oct 2012 20:27:27 +0200
Message-Id: <1350066450-17370-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

The subject line says it all, there's not much to add. I'll push those patches
for v3.8.

Laurent Pinchart (3):
  omap3isp: Remove unneeded module memory address definitions
  omap3isp: video: Fix warning caused by bad vidioc_s_crop prototype
  omap3isp: Fix warning caused by bad subdev events operations
    prototypes

 drivers/media/platform/omap3isp/ispccdc.c  |    4 +-
 drivers/media/platform/omap3isp/isphist.c  |    5 ++-
 drivers/media/platform/omap3isp/ispreg.h   |   77 ----------------------------
 drivers/media/platform/omap3isp/ispstat.c  |    4 +-
 drivers/media/platform/omap3isp/ispstat.h  |    4 +-
 drivers/media/platform/omap3isp/ispvideo.c |    2 +-
 6 files changed, 11 insertions(+), 85 deletions(-)

-- 
Regards,

Laurent Pinchart

