Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34705 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaHEWFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 18:05:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [GIT PULL FOR v3.18] OMAP3 ISP BT.656 support and other fixes
Date: Wed, 06 Aug 2014 00:05:48 +0200
Message-ID: <1448171.CAZps10qQ7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:

  [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to e001d2bd076be98a691fa9641e15f3a96966061b:

  omap3isp: resizer: Protect against races when updating crop (2014-08-05 
23:54:27 +0200)

----------------------------------------------------------------
Laurent Pinchart (22):
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
      omap3isp: ccdc: Disable the video port when unused
      omap3isp: ccdc: Only complete buffer when all fields are captured
      omap3isp: ccdc: Rename __ccdc_handle_stopping to ccdc_handle_stopping
      omap3isp: ccdc: Simplify ccdc_lsc_is_configured()
      omap3isp: ccdc: Increment the frame number at VD0 time for BT.656
      omap3isp: ccdc: Fix freeze when a short frame is received
      omap3isp: ccdc: Don't timeout on stream off when the CCDC is stopped
      omap3isp: ccdc: Restart the CCDC immediately after an underrun in BT.656
      omap3isp: resizer: Remove needless variable initializations
      omap3isp: resizer: Remove slow debugging message from interrupt handler
      omap3isp: resizer: Protect against races when updating crop

 drivers/media/platform/omap3isp/cfa_coef_table.h     |  10 -
 drivers/media/platform/omap3isp/gamma_table.h        |  10 -
 drivers/media/platform/omap3isp/isp.c                |  20 +-
 drivers/media/platform/omap3isp/isp.h                |  10 -
 drivers/media/platform/omap3isp/ispccdc.c            | 424 ++++++++++++------
 drivers/media/platform/omap3isp/ispccdc.h            |  21 +-
 drivers/media/platform/omap3isp/ispccp2.c            |  10 -
 drivers/media/platform/omap3isp/ispccp2.h            |  10 -
 drivers/media/platform/omap3isp/ispcsi2.c            |  10 -
 drivers/media/platform/omap3isp/ispcsi2.h            |  10 -
 drivers/media/platform/omap3isp/ispcsiphy.c          |  10 -
 drivers/media/platform/omap3isp/ispcsiphy.h          |  10 -
 drivers/media/platform/omap3isp/isph3a.h             |  10 -
 drivers/media/platform/omap3isp/isph3a_aewb.c        |  10 -
 drivers/media/platform/omap3isp/isph3a_af.c          |  10 -
 drivers/media/platform/omap3isp/isphist.c            |  10 -
 drivers/media/platform/omap3isp/isphist.h            |  10 -
 drivers/media/platform/omap3isp/isppreview.c         |  10 -
 drivers/media/platform/omap3isp/isppreview.h         |  10 -
 drivers/media/platform/omap3isp/ispreg.h             |  20 +-
 drivers/media/platform/omap3isp/ispresizer.c         |  80 ++---
 drivers/media/platform/omap3isp/ispresizer.h         |  13 +-
 drivers/media/platform/omap3isp/ispstat.c            |  10 -
 drivers/media/platform/omap3isp/ispstat.h            |  10 -
 drivers/media/platform/omap3isp/ispvideo.c           |  59 +++-
 drivers/media/platform/omap3isp/ispvideo.h           |  12 +-
 drivers/media/platform/omap3isp/luma_enhance_table.h |  10 -
 drivers/media/platform/omap3isp/noise_filter_table.h |  10 -
 drivers/media/v4l2-core/v4l2-subdev.c                |   9 +
 include/media/omap3isp.h                             |   3 +
 30 files changed, 418 insertions(+), 443 deletions(-)

-- 
Regards,

Laurent Pinchart

