Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42556 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1IVUPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 16:15:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, g.liakhovetski@gmx.de
Subject: [PATCH 0/4] OMAP3 ISP memory leaks fix in error paths
Date: Thu, 22 Sep 2011 22:15:35 +0200
Message-Id: <1316722539-7372-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Guennadi reported that the OMAP3 ISP driver was missing clean up in init
functions error paths. These 4 patches attempt to address the issue. Guennadi,
as you reported the problem, could you be so kind to check whether the patches
fix it ? :-)

Laurent Pinchart (4):
  omap3isp: Move media_entity_cleanup() from unregister() to cleanup()
  omap3isp: Move *_init_entities() functions to the init/cleanup
    section
  omap3isp: Add missing mutex_destroy() calls
  omap3isp: Fix memory leaks in initialization error paths

 drivers/media/video/omap3isp/isp.c         |    2 +
 drivers/media/video/omap3isp/ispccdc.c     |   84 +++++++++++--------
 drivers/media/video/omap3isp/ispccp2.c     |  125 ++++++++++++++-------------
 drivers/media/video/omap3isp/ispcsi2.c     |   91 +++++++++++----------
 drivers/media/video/omap3isp/isph3a_aewb.c |    2 +-
 drivers/media/video/omap3isp/isph3a_af.c   |    2 +-
 drivers/media/video/omap3isp/isphist.c     |    2 +-
 drivers/media/video/omap3isp/isppreview.c  |  108 ++++++++++++------------
 drivers/media/video/omap3isp/ispresizer.c  |  104 ++++++++++++-----------
 drivers/media/video/omap3isp/ispstat.c     |   52 +++++++-----
 drivers/media/video/omap3isp/ispstat.h     |    2 +-
 drivers/media/video/omap3isp/ispvideo.c    |   11 ++-
 drivers/media/video/omap3isp/ispvideo.h    |    1 +
 13 files changed, 317 insertions(+), 269 deletions(-)

-- 
Regards

Laurent Pinchart

