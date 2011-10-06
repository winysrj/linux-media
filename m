Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40828 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935837Ab1JFNab (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 09:30:31 -0400
Received: from lancelot.localnet (unknown [91.178.166.155])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0ECAE359E9
	for <linux-media@vger.kernel.org>; Thu,  6 Oct 2011 13:30:30 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.2] OMAP3 ISP fixes
Date: Thu, 6 Oct 2011 15:30:28 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110061530.29396.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2f4cf2c3a971c4d5154def8ef9ce4811d702852d:

  [media] dib9000: release a lock on error (2011-09-30 13:32:56 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next

Guennadi Liakhovetski (1):
      omap3isp: ccdc: remove redundant operation

Laurent Pinchart (4):
      omap3isp: Move media_entity_cleanup() from unregister() to cleanup()
      omap3isp: Move *_init_entities() functions to the init/cleanup section
      omap3isp: Add missing mutex_destroy() calls
      omap3isp: Fix memory leaks in initialization error paths

 drivers/media/video/omap3isp/isp.c         |    2 +
 drivers/media/video/omap3isp/ispccdc.c     |   86 +++++++++++--------
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
 13 files changed, 318 insertions(+), 270 deletions(-)

-- 
Regards,

Laurent Pinchart
