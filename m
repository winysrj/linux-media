Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49811 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaEZTt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:49:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 00/11] OMAP3 ISP BT.656 support
Date: Mon, 26 May 2014 21:50:01 +0200
Message-Id: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch sets implements support for BT.656 and interlaced formats in the
OMAP3 ISP driver. Better late than never I suppose, although given how long
this has been on my to-do list there's probably no valid excuse.

As a prerequisite, the first patch extends the v4l subdev default link
validation function to cover field order when validating links. Patches 2 to
4 and then perform small OMAP3 ISP cleanups, patches 5 to 10 add support for
interlaced formats and patch 11 finally adds BT.656 support.

The code is based on top of a merge between Mauro's latest master and omap3isp
branches.

I've also extended the media-ctl and yavta utilities with field order support.
The media-ctl modifications have been pushed to the field branch, while the
yavta modifications are available in the master branch.

The code has been validated on a Gumstix Overo connected to a TVP5151-based
board (http://www.sleepyrobot.com/?s=tvp5151) and an NTSC camera. I've tested
all supported field orders, but given the lack of clarity (and I weight my
words) of the field order documentation in the OMAP3 ISP datasheet I certainly
can have made a mistake somewhere.

Laurent Pinchart (11):
  v4l: subdev: Extend default link validation to cover field order
  omap3isp: Don't ignore subdev streamoff failures
  omap3isp: Remove boilerplate disclaimer and FSF address
  omap3isp: Move non-critical code out of the mutex-protected section
  omap3isp: Default to progressive field order when setting the format
  omap3isp: video: Validate the video node field order
  omap3isp: ccdc: Simplify the configuration function
  omap3isp: ccdc: Simplify the ccdc_isr_buffer() function
  omap3isp: ccdc: Add basic support for interlaced video
  omap3isp: ccdc: Support the interlaced field orders at the CCDC output
  omap3isp: ccdc: Add support for BT.656 YUV format at the CCDC input

 drivers/media/platform/omap3isp/cfa_coef_table.h   |  10 -
 drivers/media/platform/omap3isp/gamma_table.h      |  10 -
 drivers/media/platform/omap3isp/isp.c              |  20 +-
 drivers/media/platform/omap3isp/isp.h              |  10 -
 drivers/media/platform/omap3isp/ispccdc.c          | 261 +++++++++++++++------
 drivers/media/platform/omap3isp/ispccdc.h          |  12 +-
 drivers/media/platform/omap3isp/ispccp2.c          |  10 -
 drivers/media/platform/omap3isp/ispccp2.h          |  10 -
 drivers/media/platform/omap3isp/ispcsi2.c          |  10 -
 drivers/media/platform/omap3isp/ispcsi2.h          |  10 -
 drivers/media/platform/omap3isp/ispcsiphy.c        |  10 -
 drivers/media/platform/omap3isp/ispcsiphy.h        |  10 -
 drivers/media/platform/omap3isp/isph3a.h           |  10 -
 drivers/media/platform/omap3isp/isph3a_aewb.c      |  10 -
 drivers/media/platform/omap3isp/isph3a_af.c        |  10 -
 drivers/media/platform/omap3isp/isphist.c          |  10 -
 drivers/media/platform/omap3isp/isphist.h          |  10 -
 drivers/media/platform/omap3isp/isppreview.c       |  10 -
 drivers/media/platform/omap3isp/isppreview.h       |  10 -
 drivers/media/platform/omap3isp/ispreg.h           |  20 +-
 drivers/media/platform/omap3isp/ispresizer.c       |  10 -
 drivers/media/platform/omap3isp/ispresizer.h       |  10 -
 drivers/media/platform/omap3isp/ispstat.c          |  10 -
 drivers/media/platform/omap3isp/ispstat.h          |  10 -
 drivers/media/platform/omap3isp/ispvideo.c         |  59 +++--
 drivers/media/platform/omap3isp/ispvideo.h         |  12 +-
 .../media/platform/omap3isp/luma_enhance_table.h   |  10 -
 .../media/platform/omap3isp/noise_filter_table.h   |  10 -
 drivers/media/v4l2-core/v4l2-subdev.c              |   9 +
 include/media/omap3isp.h                           |   3 +
 30 files changed, 251 insertions(+), 365 deletions(-)

-- 
Regards,

Laurent Pinchart

