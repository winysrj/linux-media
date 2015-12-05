Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55016 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbbLECM7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:12:59 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 00/32] VSP: Add R-Car Gen3 support
Date: Sat,  5 Dec 2015 04:12:34 +0200
Message-Id: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set adds support for the Renesas R-Car Gen3 SoC family to the VSP1
driver. The large number of patches is caused by a change in the display
controller architecture that makes usage of the VSP mandatory as the display
controller has lost the ability to read data from memory.

Patch 01/32 to 27/32 prepare for the implementation of an API exported to the
DRM driver in patch 28/32. Patches 31/32 enables support for the R-Car Gen3
family, and patch 32/32 finally enhances perfomances by implementing support
for display lists.

The major change compared to v1 is the usage of the IP version register
instead of DT properties to configure device parameters such as the number of
BRU inputs or the availability of the BRU.

Laurent Pinchart (31):
  v4l: vsp1: Change the type of the rwpf field in struct vsp1_video
  v4l: vsp1: Store the memory format in struct vsp1_rwpf
  v4l: vsp1: Move video operations to vsp1_rwpf
  v4l: vsp1: Rename vsp1_video_buffer to vsp1_vb2_buffer
  v4l: vsp1: Move video device out of struct vsp1_rwpf
  v4l: vsp1: Make rwpf operations independent of video device
  v4l: vsp1: Support VSP1 instances without any UDS
  v4l: vsp1: Move vsp1_video pointer from vsp1_entity to vsp1_rwpf
  v4l: vsp1: Remove struct vsp1_pipeline num_video field
  v4l: vsp1: Decouple pipeline end of frame processing from vsp1_video
  v4l: vsp1: Split pipeline management code from vsp1_video.c
  v4l: vsp1: Rename video pipeline functions to use vsp1_video prefix
  v4l: vsp1: Extract pipeline initialization code into a function
  v4l: vsp1: Reuse local variable instead of recomputing it
  v4l: vsp1: Extract link creation to separate function
  v4l: vsp1: Document the vsp1_pipeline structure
  v4l: vsp1: Fix typo in VI6_DISP_IRQ_STA_DST register name
  v4l: vsp1: Set the SRU CTRL0 register when starting the stream
  v4l: vsp1: Remove unused module read functions
  v4l: vsp1: Move entity route setup function to vsp1_entity.c
  v4l: vsp1: Make number of BRU inputs configurable
  v4l: vsp1: Make the BRU optional
  v4l: vsp1: Move format info to vsp1_pipe.c
  v4l: vsp1: Make the userspace API optional
  v4l: vsp1: Make pipeline inputs array index by RPF index
  v4l: vsp1: Set the alpha value manually in RPF and WPF s_stream
    handlers
  v4l: vsp1: Don't validate links when the userspace API is disabled
  v4l: vsp1: Add VSP+DU support
  v4l: vsp1: Disconnect unused RPFs from the DRM pipeline
  v4l: vsp1: Implement atomic update for the DRM driver
  v4l: vsp1: Add support for the R-Car Gen3 VSP2

Takashi Saito (1):
  v4l: vsp1: Add display list support

 .../devicetree/bindings/media/renesas,vsp1.txt     |  21 +-
 drivers/media/platform/vsp1/Makefile               |   3 +-
 drivers/media/platform/vsp1/vsp1.h                 |  24 +
 drivers/media/platform/vsp1/vsp1_bru.c             |  33 +-
 drivers/media/platform/vsp1/vsp1_bru.h             |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c              | 304 +++++++++++
 drivers/media/platform/vsp1/vsp1_dl.h              |  42 ++
 drivers/media/platform/vsp1/vsp1_drm.c             | 595 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_drm.h             |  38 ++
 drivers/media/platform/vsp1/vsp1_drv.c             | 254 +++++++--
 drivers/media/platform/vsp1/vsp1_entity.c          |  31 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |  14 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |   2 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |  11 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |   7 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            | 405 ++++++++++++++
 drivers/media/platform/vsp1/vsp1_pipe.h            | 134 +++++
 drivers/media/platform/vsp1/vsp1_regs.h            |  32 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |  77 ++-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |  24 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |   9 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |   8 +-
 drivers/media/platform/vsp1/vsp1_video.c           | 516 ++++--------------
 drivers/media/platform/vsp1/vsp1_video.h           | 111 +---
 drivers/media/platform/vsp1/vsp1_wpf.c             |  88 ++-
 include/media/vsp1.h                               |  33 ++
 26 files changed, 2069 insertions(+), 750 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_drm.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_drm.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.h
 create mode 100644 include/media/vsp1.h

-- 
Regards,

Laurent Pinchart

