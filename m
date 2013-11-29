Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42803 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3K2VzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 16:55:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [GIT PULL FOR v3.14] V4L/MC link validation simplification
Date: Fri, 29 Nov 2013 22:55:15 +0100
Message-ID: <25664680.z7NM0RO0lR@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit fa507e4d32bf6c35eb5fe7dbc0593ae3723c9575:

  [media] media: marvell-ccic: use devm to release clk (2013-11-29 14:46:47 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/must-connect

for you to fetch changes up to 5487b0e119d29c2e72e6694cf77f8cc74240ace6:

  omap3isp: Add resizer data rate configuration to resizer_link_validate 
(2013-11-29 22:45:01 +0100)

----------------------------------------------------------------
Sakari Ailus (4):
      media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
      media: Check for active links on pads with MEDIA_PAD_FL_MUST_CONNECT 
flag
      omap3isp: Mark which pads must connect
      omap3isp: Add resizer data rate configuration to resizer_link_validate

 .../DocBook/media/v4l/media-ioc-enum-links.xml          |  9 ++++
 drivers/media/media-entity.c                            | 41 +++++++++++++---
 drivers/media/platform/omap3isp/ispccdc.c               |  3 +-
 drivers/media/platform/omap3isp/ispccp2.c               |  3 +-
 drivers/media/platform/omap3isp/ispcsi2.c               |  3 +-
 drivers/media/platform/omap3isp/isppreview.c            |  3 +-
 drivers/media/platform/omap3isp/ispresizer.c            | 18 +++++++-
 drivers/media/platform/omap3isp/ispstat.c               |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c              | 60 ++--------------
 include/uapi/linux/media.h                              |  1 +
 10 files changed, 74 insertions(+), 69 deletions(-)

-- 
Regards,

Laurent Pinchart

