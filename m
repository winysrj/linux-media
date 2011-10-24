Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52277 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab1JXMaT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 08:30:19 -0400
Received: from lancelot.localnet (unknown [85.13.70.251])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2882B35999
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 12:30:18 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.2] OMAP3 ISP and OMAP VOUT fixes
Date: Mon, 24 Oct 2011 14:30:47 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110241430.48230.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 35a912455ff5640dc410e91279b03e04045265b2:

  Merge branch 'v4l_for_linus' into staging/for_v3.2 (2011-10-19 12:41:18 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next

Guennadi Liakhovetski (1):
      omap3isp: ccdc: remove redundant operation

Laurent Pinchart (9):
      omap3isp: Move media_entity_cleanup() from unregister() to cleanup()
      omap3isp: Move *_init_entities() functions to the init/cleanup section
      omap3isp: Add missing mutex_destroy() calls
      omap3isp: Fix memory leaks in initialization error paths
      omap3isp: Report the ISP revision through the media controller API
      omap3isp: preview: Remove horizontal averager support
      omap3isp: preview: Rename min/max input/output sizes defines
      omap3isp: preview: Add crop support on the sink pad
      omap_vout: Add poll() support

 drivers/media/video/omap/omap_vout.c       |   10 +
 drivers/media/video/omap3isp/isp.c         |    3 +
 drivers/media/video/omap3isp/ispccdc.c     |   86 ++++---
 drivers/media/video/omap3isp/ispccp2.c     |  125 +++++----
 drivers/media/video/omap3isp/ispcsi2.c     |   91 ++++---
 drivers/media/video/omap3isp/isph3a_aewb.c |    2 +-
 drivers/media/video/omap3isp/isph3a_af.c   |    2 +-
 drivers/media/video/omap3isp/isphist.c     |    2 +-
 drivers/media/video/omap3isp/isppreview.c  |  419 +++++++++++++++++----------
 drivers/media/video/omap3isp/isppreview.h  |    9 +-
 drivers/media/video/omap3isp/ispreg.h      |    3 -
 drivers/media/video/omap3isp/ispresizer.c  |  104 ++++----
 drivers/media/video/omap3isp/ispstat.c     |   52 ++--
 drivers/media/video/omap3isp/ispstat.h     |    2 +-
 drivers/media/video/omap3isp/ispvideo.c    |   11 +-
 drivers/media/video/omap3isp/ispvideo.h    |    1 +
 16 files changed, 545 insertions(+), 377 deletions(-)

-- 
Regards,

Laurent Pinchart
