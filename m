Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52956 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbcFTTSe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:18:34 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 00/24] R-Car VSP1: Histogram, look-up table and flip support
Date: Mon, 20 Jun 2016 22:10:18 +0300
Message-Id: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's my current set of pending VSP1 patches, based on top of the
"[PATCH v2 00/13] R-Car VSP improvements for v4.7 - Round 2" series. For
convenience I've pushed the patches and their dependencies to

	git://linuxtv.org/pinchartl/media.git vsp1/flip

The series contains new features as well as several fixes. In particular the
driver now supports histogram generation through the HGO (01/24 to 04/24),
doesn't generate warnings to the kernel log due to uninitialized functions
(05/24 to 10/24), supports the LUT and CLU (12/24 to 19/24), supports
horizontal and vertical flipping (20/24 to 22/24) and doesn't attempt to
access freed buffers anymore (24/24).

I plan to send a pull request for v4.8 as soon as the previous pull request
gets merged.

Laurent Pinchart (24):
  v4l: Add metadata buffer type and format
  v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine
  v4l: vsp1: Add HGO support
  v4l: vsp1: Don't create HGO entity when the userspace API is disabled
  media: Add video processing entity functions
  media: Add video statistics computation functions
  v4l: vsp1: Base link creation on availability of entities
  v4l: vsp1: Don't register media device when userspace API is disabled
  v4l: vsp1: Don't create LIF entity when the userspace API is enabled
  v4l: vsp1: Set entities functions
  v4l: vsp1: pipe: Fix typo in comment
  v4l: vsp1: dl: Don't free fragments with interrupts disabled
  v4l: vsp1: lut: Initialize the mutex
  v4l: vsp1: lut: Expose configuration through a control
  v4l: vsp1: Add Cubic Look Up Table (CLU) support
  v4l: vsp1: sru: Fix intensity control ID
  v4l: vsp1: Support runtime modification of controls
  v4l: vsp1: lut: Support runtime modification of controls
  v4l: vsp1: clu: Support runtime modification of controls
  v4l: vsp1: Simplify alpha propagation
  v4l: vsp1: rwpf: Support runtime modification of controls
  v4l: vsp1: wpf: Add flipping support
  v4l: vsp1: Constify operation structures
  v4l: vsp1: Stop the pipeline upon the first STREAMOFF

 Documentation/DocBook/media/v4l/dev-meta.xml       |  93 ++++
 Documentation/DocBook/media/v4l/media-types.xml    |  64 +++
 .../DocBook/media/v4l/pixfmt-meta-vsp1-hgo.xml     | 307 +++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |   9 +
 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/vsp1/Makefile               |   4 +-
 drivers/media/platform/vsp1/vsp1.h                 |   8 +
 drivers/media/platform/vsp1/vsp1_bru.c             |  12 +-
 drivers/media/platform/vsp1/vsp1_clu.c             | 292 ++++++++++++
 drivers/media/platform/vsp1/vsp1_clu.h             |  48 ++
 drivers/media/platform/vsp1/vsp1_dl.c              |  72 ++-
 drivers/media/platform/vsp1/vsp1_drm.c             |   8 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  91 ++--
 drivers/media/platform/vsp1/vsp1_entity.c          | 140 +++++-
 drivers/media/platform/vsp1/vsp1_entity.h          |  12 +-
 drivers/media/platform/vsp1/vsp1_hgo.c             | 500 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h             |  50 +++
 drivers/media/platform/vsp1/vsp1_histo.c           | 307 +++++++++++++
 drivers/media/platform/vsp1/vsp1_histo.h           |  68 +++
 drivers/media/platform/vsp1/vsp1_hsit.c            |  14 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |  16 +-
 drivers/media/platform/vsp1/vsp1_lut.c             | 101 +++--
 drivers/media/platform/vsp1/vsp1_lut.h             |   7 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |  62 ++-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   8 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |  40 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |  31 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |  14 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |  14 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |  16 +-
 drivers/media/platform/vsp1/vsp1_uds.h             |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  36 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             | 159 ++++++-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  35 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   3 +
 include/media/v4l2-ioctl.h                         |   8 +
 include/uapi/linux/media.h                         |  10 +
 include/uapi/linux/videodev2.h                     |  17 +
 include/uapi/linux/vsp1.h                          |  34 --
 43 files changed, 2515 insertions(+), 240 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-meta-vsp1-hgo.xml
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h
 delete mode 100644 include/uapi/linux/vsp1.h

-- 
Regards,

Laurent Pinchart

