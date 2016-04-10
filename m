Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52786 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbcDJApd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2016 20:45:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [GIT PULL FOR v4.7] R-Car VSP driver changes
Date: Sun, 10 Apr 2016 03:45:25 +0300
Message-ID: <1616477.ZoNuy2sRM5@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
[
The following changes since commit bc5ccdbc990debbcae4602214dddc8d5fd38b01d:

  [media] au0828: Unregister notifiers (2016-04-06 05:44:38 -0700)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 519e36b22f9d1f93fa2f08456975210fe066f6d3:

  media: platform: rcar_jpu, vsp1: Use ARCH_RENESAS (2016-04-10 03:41:45 
+0300)

The changes include the pad config allocator patch that has been mentioned 
during the last media workshop.

----------------------------------------------------------------
Laurent Pinchart (53):
      media: Add obj_type field to struct media_entity
      media: Rename is_media_entity_v4l2_io to 
is_media_entity_v4l2_video_device
      v4l: subdev: Add pad config allocator and init
      v4l: vsp1: Fix vsp1_du_atomic_(begin|flush) declarations
      v4l: vsp1: drm: Include correct header file
      v4l: vsp1: video: Fix coding style
      v4l: vsp1: VSPD instances have no LUT on Gen3
      v4l: vsp1: Use pipeline display list to decide how to write to modules
      v4l: vsp1: Always setup the display list
      v4l: vsp1: Simplify frame end processing
      v4l: vsp1: Split display list manager from display list
      v4l: vsp1: Store the display list manager in the WPF
      v4l: vsp1: bru: Don't program background color in control set handler
      v4l: vsp1: rwpf: Don't program alpha value in control set handler
      v4l: vsp1: sru: Don't program intensity in control set handler
      v4l: vsp1: Don't setup control handler when starting streaming
      v4l: vsp1: Enable display list support for the HS[IT], LUT, SRU and UDS
      v4l: vsp1: Don't configure RPF memory buffers before calculating offsets
      v4l: vsp1: Remove unneeded entity streaming flag
      v4l: vsp1: Document calling context of vsp1_pipeline_propagate_alpha()
      v4l: vsp1: Fix 80 characters per line violations
      v4l: vsp1: Add header display list support
      v4l: vsp1: Use display lists with the userspace API
      v4l: vsp1: Move subdev initialization code to vsp1_entity_init()
      v4l: vsp1: Consolidate entity ops in a struct vsp1_entity_operations
      v4l: vsp1: Fix BRU try compose rectangle storage
      v4l: vsp1: Add race condition FIXME comment
      v4l: vsp1: Implement and use the subdev pad::init_cfg configuration
      v4l: vsp1: Store active formats in a pad config structure
      v4l: vsp1: Store active selection rectangles in a pad config structure
      v4l: vsp1: Create a new configure operation to setup modules
      v4l: vsp1: Merge RPF and WPF pad ops structures
      v4l: vsp1: Use __vsp1_video_try_format to initialize format at init time
      v4l: vsp1: Pass display list explicitly to configure functions
      v4l: vsp1: Rename pipeline validate functions to pipeline build
      v4l: vsp1: Pass pipe pointer to entity configure functions
      v4l: vsp1: Store pipeline pointer in rwpf
      v4l: vsp1: video: Reorder functions
      v4l: vsp1: Allocate pipelines on demand
      v4l: vsp1: RPF entities can't be target nodes
      v4l: vsp1: Factorize get pad format code
      v4l: vsp1: Factorize media bus codes enumeration code
      v4l: vsp1: Factorize frame size enumeration code
      v4l: vsp1: Fix LUT format setting
      v4l: vsp1: dl: Make reg_count field unsigned
      v4l: vsp1: dl: Fix race conditions
      v4l: vsp1: dl: Add support for multi-body display lists
      v4l: vsp1: lut: Use display list fragments to fill LUT
      v4l: vsp1: Add support for the RPF alpha multiplier on Gen3
      v4l: vsp1: Add Z-order support for DRM pipeline
      v4l: vsp1: Add global alpha support for DRM pipeline
      v4l: vsp1: Fix V4L2_PIX_FMT_XRGB444 format definition
      v4l: vsp1: Update WPF and LIF maximum sizes for Gen3

Simon Horman (1):
      media: platform: rcar_jpu, vsp1: Use ARCH_RENESAS

 drivers/media/platform/Kconfig                  |   4 +-
 drivers/media/platform/exynos4-is/media-dev.c   |   4 +-
 drivers/media/platform/omap3isp/ispvideo.c      |   2 +-
 drivers/media/platform/vsp1/vsp1.h              |  14 +-
 drivers/media/platform/vsp1/vsp1_bru.c          | 359 +++++++++-----------
 drivers/media/platform/vsp1/vsp1_bru.h          |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c           | 567 +++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_dl.h           |  49 +--
 drivers/media/platform/vsp1/vsp1_drm.c          | 234 +++++++------
 drivers/media/platform/vsp1/vsp1_drm.h          |  27 +-
 drivers/media/platform/vsp1/vsp1_drv.c          |  34 +-
 drivers/media/platform/vsp1/vsp1_entity.c       | 288 +++++++++++-----
 drivers/media/platform/vsp1/vsp1_entity.h       |  63 +++-
 drivers/media/platform/vsp1/vsp1_hsit.c         | 130 +++-----
 drivers/media/platform/vsp1/vsp1_lif.c          | 179 ++++------
 drivers/media/platform/vsp1/vsp1_lut.c          | 172 ++++------
 drivers/media/platform/vsp1/vsp1_lut.h          |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c         |  71 ++--
 drivers/media/platform/vsp1/vsp1_pipe.h         |  19 +-
 drivers/media/platform/vsp1/vsp1_regs.h         |  10 +
 drivers/media/platform/vsp1/vsp1_rpf.c          | 275 +++++++---------
 drivers/media/platform/vsp1/vsp1_rwpf.c         | 171 +++++-----
 drivers/media/platform/vsp1/vsp1_rwpf.h         |  64 ++--
 drivers/media/platform/vsp1/vsp1_sru.c          | 214 +++++-------
 drivers/media/platform/vsp1/vsp1_sru.h          |   2 +
 drivers/media/platform/vsp1/vsp1_uds.c          | 223 ++++++-------
 drivers/media/platform/vsp1/vsp1_uds.h          |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c        | 493 +++++++++++++----------
 drivers/media/platform/vsp1/vsp1_video.h        |   2 -
 drivers/media/platform/vsp1/vsp1_wpf.c          | 279 +++++++---------
 drivers/media/v4l2-core/v4l2-dev.c              |   1 +
 drivers/media/v4l2-core/v4l2-mc.c               |   2 +-
 drivers/media/v4l2-core/v4l2-subdev.c           |  40 ++-
 drivers/staging/media/davinci_vpfe/vpfe_video.c |   2 +-
 drivers/staging/media/omap4iss/iss_video.c      |   2 +-
 include/media/media-entity.h                    |  78 ++---
 include/media/v4l2-subdev.h                     |   8 +
 include/media/vsp1.h                            |  23 +-
 38 files changed, 2184 insertions(+), 1933 deletions(-)

-- 
Regards,

Laurent Pinchart

