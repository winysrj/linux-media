Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48442 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab1HaQbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 12:31:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, gary@mlbassoc.com
Subject: [HACK v2 0/4] YUYV input support for the OMAP3 ISP
Date: Wed, 31 Aug 2011 18:31:58 +0200
Message-Id: <1314808322-30069-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's (already) a second version of this patch set. This first version was
missing a patch.

The set is based on
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-omap3isp-next

Laurent Pinchart (4):
  omap3isp: ccdc: Remove support for interlaced data and master HS/VS
    mode
  omap3isp: video: Split format info bpp field into width and bpp
  omap3isp: ccdc: Remove ispccdc_syncif structure
  omap3isp: ccdc: Add YUV input formats support

 drivers/media/video/omap3isp/ispccdc.c  |  105 ++++++++++++++-----------------
 drivers/media/video/omap3isp/ispccdc.h  |   36 -----------
 drivers/media/video/omap3isp/ispvideo.c |   44 +++++++------
 drivers/media/video/omap3isp/ispvideo.h |    4 +-
 include/media/omap3isp.h                |    6 ++
 5 files changed, 82 insertions(+), 113 deletions(-)

-- 
Regards,

Laurent Pinchart

