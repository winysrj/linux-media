Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40279 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbcCXX1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:27:50 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 00/51] R-Car VSP improvements for v4.6
Date: Fri, 25 Mar 2016 01:26:56 +0200
Message-Id: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series contains all the pending vsp1 driver improvements for v4.6.
In particular, it enables display list usage in non-DRM pipelines (24/51) and
adds support for multi-body display lists (48/51) and the R-Car Gen3 RPF alpha
multiplier (50/51) and Z-order control (51/51).

The other patches are cleanups, bug fixes and refactoring to support the four
features listed above.

The code is based on top of the "[PATCH v6 0/2] media: Add entity types" patch
series. For convenience I've pushed a branch that contains all the necessary
patches on top of the latest Linux media master branch to

	git://linuxtv.org/pinchartl/media.git vsp1/next

Note that while patch 51/51 enables support for Z-order control in the vsp1
driver, enabling the feature for userspace requires an additional patch for
the rcar-du-drm driver. I have pushed a branch that includes the rcar-du-drm
changes and platform enablements to

	git://linuxtv.org/pinchartl/media.git drm/du/vsp1-kms/boards


Laurent Pinchart (51):
  media: Add video processing entity functions
  v4l: subdev: Add pad config allocator and init
  v4l: subdev: Call pad init_cfg operation when opening subdevs
  v4l: vsp1: Fix vsp1_du_atomic_(begin|flush) declarations
  v4l: vsp1: drm: Include correct header file
  v4l: vsp1: video: Fix coding style
  v4l: vsp1: Set entities functions
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
  v4l: vsp1: Enable display list support for the HS[IT], LUT, SRU and
    UDS
  v4l: vsp1: Don't configure RPF memory buffers before calculating
    offsets
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
  v4l: vsp1: Use __vsp1_video_try_format to initialize format at init
    time
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

 Documentation/DocBook/media/v4l/media-types.xml |  34 ++
 drivers/media/platform/vsp1/vsp1.h              |  14 +-
 drivers/media/platform/vsp1/vsp1_bru.c          | 360 +++++++--------
 drivers/media/platform/vsp1/vsp1_bru.h          |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c           | 568 ++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_dl.h           |  49 +-
 drivers/media/platform/vsp1/vsp1_drm.c          | 231 +++++-----
 drivers/media/platform/vsp1/vsp1_drm.h          |  27 +-
 drivers/media/platform/vsp1/vsp1_drv.c          |  35 +-
 drivers/media/platform/vsp1/vsp1_entity.c       | 289 ++++++++----
 drivers/media/platform/vsp1/vsp1_entity.h       |  63 ++-
 drivers/media/platform/vsp1/vsp1_hsit.c         | 130 ++----
 drivers/media/platform/vsp1/vsp1_lif.c          | 178 +++-----
 drivers/media/platform/vsp1/vsp1_lut.c          | 173 +++-----
 drivers/media/platform/vsp1/vsp1_lut.h          |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c         |  69 +--
 drivers/media/platform/vsp1/vsp1_pipe.h         |  19 +-
 drivers/media/platform/vsp1/vsp1_regs.h         |  10 +
 drivers/media/platform/vsp1/vsp1_rpf.c          | 276 ++++++------
 drivers/media/platform/vsp1/vsp1_rwpf.c         | 171 ++++---
 drivers/media/platform/vsp1/vsp1_rwpf.h         |  64 +--
 drivers/media/platform/vsp1/vsp1_sru.c          | 215 ++++-----
 drivers/media/platform/vsp1/vsp1_sru.h          |   2 +
 drivers/media/platform/vsp1/vsp1_uds.c          | 224 ++++------
 drivers/media/platform/vsp1/vsp1_uds.h          |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c        | 493 +++++++++++---------
 drivers/media/platform/vsp1/vsp1_video.h        |   2 -
 drivers/media/platform/vsp1/vsp1_wpf.c          | 265 +++++------
 drivers/media/v4l2-core/v4l2-subdev.c           |  37 +-
 include/media/v4l2-subdev.h                     |   8 +
 include/media/vsp1.h                            |  22 +-
 include/uapi/linux/media.h                      |   8 +
 32 files changed, 2167 insertions(+), 1881 deletions(-)

-- 
Regards,

Laurent Pinchart

