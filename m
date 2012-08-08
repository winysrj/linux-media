Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51477 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2HHUfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 16:35:03 -0400
Received: from avalon.localnet (unknown [91.178.164.81])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C492E35A85
	for <linux-media@vger.kernel.org>; Wed,  8 Aug 2012 22:35:01 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.7] OMAP ISP patches
Date: Wed, 08 Aug 2012 22:35:13 +0200
Message-ID: <1526692.HcRvssx2Po@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit c3707357c6c651652a87a044445eabd7582f90a4:

  [media] az6007: Update copyright (2012-08-06 09:25:12 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next

Ivaylo Petrov (1):
      omap3isp: csi2: Add V4L2_MBUS_FMT_YUYV8_2X8 support

Laurent Pinchart (13):
      omap3isp: Don't access ISP_CTRL directly in the statistics modules
      omap3isp: Configure HS/VS interrupt source before enabling interrupts
      omap3isp: preview: Remove lens shading compensation support
      omap3isp: preview: Pass a prev_params pointer to configuration functions
      omap3isp: preview: Reorder configuration functions
      omap3isp: preview: Merge gamma correction and gamma bypass
      omap3isp: preview: Add support for non-GRBG Bayer patterns
      omap3isp: video: Split format info bpp field into width and bpp
      omap3isp: video: Add YUYV8_2X8 and UYVY8_2X8 support
      omap3isp: ccdc: Remove support for interlaced data and master HS/VS mode
      omap3isp: ccdc: Remove ispccdc_syncif structure
      omap3isp: ccdc: Add YUV input formats support
      omap3isp: Mark the resizer output video node as the default video node

Michael Jones (1):
      omap3isp: queue: Fix omap3isp_video_queue_dqbuf() description comment

Peter Meerwald (1):
      omap3isp: ccdc: No semicolon is needed after switch statement

 drivers/media/video/omap3isp/cfa_coef_table.h |   16 +-
 drivers/media/video/omap3isp/isp.c            |   51 ++-
 drivers/media/video/omap3isp/isp.h            |   11 +-
 drivers/media/video/omap3isp/ispccdc.c        |  234 +++++----
 drivers/media/video/omap3isp/ispccdc.h        |   37 --
 drivers/media/video/omap3isp/ispcsi2.c        |   27 +-
 drivers/media/video/omap3isp/isph3a_aewb.c    |   10 +-
 drivers/media/video/omap3isp/isph3a_af.c      |   10 +-
 drivers/media/video/omap3isp/isphist.c        |    6 +-
 drivers/media/video/omap3isp/isppreview.c     |  707 ++++++++++++------------
 drivers/media/video/omap3isp/isppreview.h     |    1 +
 drivers/media/video/omap3isp/ispqueue.c       |   13 +-
 drivers/media/video/omap3isp/ispresizer.c     |    2 +
 drivers/media/video/omap3isp/ispvideo.c       |   57 ++-
 drivers/media/video/omap3isp/ispvideo.h       |    6 +-
 include/linux/omap3isp.h                      |    5 +-
 include/media/omap3isp.h                      |   14 +-
 17 files changed, 614 insertions(+), 593 deletions(-)

-- 
Regards,

Laurent Pinchart

