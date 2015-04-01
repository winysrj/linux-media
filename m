Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33934 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbDAXxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2015 19:53:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [GIT PULL FOR v4.1] [v3] OMAP3 ISP DT support & other fixes
Date: Thu, 02 Apr 2015 02:53:38 +0300
Message-ID: <1974578.Pp6GtfjauX@avalon>
In-Reply-To: <2471603.f3UFYjkmSW@avalon>
References: <3472666.1mv3SyG49o@avalon> <2471603.f3UFYjkmSW@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request supersedes "[GIT PULL FOR v4.1] [v2] OMAP3 ISP DT support & 
other fixes". Compared to the previous version it merges the "[PATCH 1/1] 
omap3isp: Don't pass uninitialised arguments to of_graph_get_next_endpoint()" 
bug fix into patch "omap3isp: Add support for the Device Tree".

Board code and platform changes have been acked by the appropriate maintainers 
to the best of my knowledge.

The following changes since commit bf104c238dc1c7172460853882a545141eaa8222:

  [media] mn88472: One function call less in mn88472_init() after error 
detection (2015-04-01 06:22:27 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to fb6ff895435abdc92fd7ddd92e7c8f4630b4e127:

  omap3isp: Deprecate platform data support (2015-04-02 02:46:29 +0300)

----------------------------------------------------------------
Lad, Prabhakar (1):
      media: omap3isp: video: drop setting of vb2 buffer state to 
VB2_BUF_STATE_ACTIVE

Laurent Pinchart (4):
      media: omap3isp: video: Don't call vb2 mmap with queue lock held
      media: omap3isp: video: Use v4l2_get_timestamp()
      media: omap3isp: hist: Move histogram DMA to DMA engine
      omap3isp: DT support for clocks

Sakari Ailus (14):
      omap3isp: Fix error handling in probe
      omap3isp: Avoid a BUG_ON() in media_entity_create_link()
      omap3isp: Separate external link creation from platform data parsing
      omap3isp: Platform data could be NULL
      omap3isp: Refactor device configuration structs for Device Tree
      omap3isp: Rename regulators to better suit the Device Tree
      omap3isp: Calculate vpclk_div for CSI-2
      omap3isp: Replace mmio_base_phys array with the histogram block base
      omap3isp: Move the syscon register out of the ISP register maps
      omap3isp: Replace many MMIO regions by two
      dt: bindings: Add lane-polarity property to endpoint nodes
      v4l: of: Read lane-polarities endpoint property
      omap3isp: Add support for the Device Tree
      omap3isp: Deprecate platform data support

 .../devicetree/bindings/media/video-interfaces.txt      |   6 +
 arch/arm/mach-omap2/board-cm-t35.c                      |  57 +--
 arch/arm/mach-omap2/devices.c                           |  76 +---
 arch/arm/mach-omap2/omap34xx.h                          |  36 +-
 drivers/media/platform/Kconfig                          |   1 +
 drivers/media/platform/omap3isp/isp.c                   | 555 ++++++++++-----
 drivers/media/platform/omap3isp/isp.h                   |  42 +-
 drivers/media/platform/omap3isp/ispccdc.c               |  26 +-
 drivers/media/platform/omap3isp/ispccp2.c               |  22 +-
 drivers/media/platform/omap3isp/ispcsi2.c               |  14 +-
 drivers/media/platform/omap3isp/ispcsiphy.c             |  48 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c           |   1 -
 drivers/media/platform/omap3isp/isph3a_af.c             |   1 -
 drivers/media/platform/omap3isp/isphist.c               | 127 +++---
 drivers/media/platform/omap3isp/ispstat.c               |   2 +-
 drivers/media/platform/omap3isp/ispstat.h               |   5 +-
 drivers/media/platform/omap3isp/ispvideo.c              |  20 +-
 drivers/media/v4l2-core/v4l2-of.c                       |  41 +-
 include/media/omap3isp.h                                |  36 +-
 include/media/v4l2-of.h                                 |   3 +
 20 files changed, 665 insertions(+), 454 deletions(-)

-- 
Regards,

Laurent Pinchart

