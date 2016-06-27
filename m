Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57764 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbcF0NSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 09:18:21 -0400
Received: from avalon.localnet (33.154-246-81.adsl-dyn.isp.belgacom.be [81.246.154.33])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 7318120010
	for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 15:15:48 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.8] R-Car VSP1 driver changes
Date: Mon, 27 Jun 2016 16:18:42 +0300
Message-ID: <1711847.sx4iRKJVU6@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit c3f34a4bdd596127000666c17bbf8ba1c3d2d332:

  [media] v4l: vsp1: Remove deprecated DRM API (2016-06-20 20:09:10 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/flip

for you to fetch changes up to 1ae8abb4289a1c71d3aeec90431f5a5d0e88ad72:

  v4l: vsp1: wpf: Add flipping support (2016-06-22 13:33:11 +0300)

The commits are based on top of the vsp1 branch of your tree.

----------------------------------------------------------------
Laurent Pinchart (23):
      v4l: vsp1: Fix typo in register field names
      v4l: vsp1: Fix descriptions of Gen2 VSP instances
      v4l: vsp1: Fix crash when resetting pipeline
      v4l: vsp1: pipe: Fix typo in comment
      v4l: vsp1: Constify operation structures
      v4l: vsp1: Stop the pipeline upon the first STREAMOFF
      v4l: vsp1: sru: Fix intensity control ID
      media: Add video processing entity functions
      media: Add video statistics computation functions
      v4l: vsp1: Base link creation on availability of entities
      v4l: vsp1: Don't register media device when userspace API is disabled
      v4l: vsp1: Don't create LIF entity when the userspace API is enabled
      v4l: vsp1: Set entities functions
      v4l: vsp1: dl: Don't free fragments with interrupts disabled
      v4l: vsp1: lut: Initialize the mutex
      v4l: vsp1: lut: Expose configuration through a control
      v4l: vsp1: Add Cubic Look Up Table (CLU) support
      v4l: vsp1: Support runtime modification of controls
      v4l: vsp1: lut: Support runtime modification of controls
      v4l: vsp1: clu: Support runtime modification of controls
      v4l: vsp1: Simplify alpha propagation
      v4l: vsp1: rwpf: Support runtime modification of controls
      v4l: vsp1: wpf: Add flipping support

 Documentation/DocBook/media/v4l/media-types.xml |  64 +++++++
 drivers/media/platform/vsp1/Makefile            |   3 +-
 drivers/media/platform/vsp1/vsp1.h              |   5 +
 drivers/media/platform/vsp1/vsp1_bru.c          |  12 +-
 drivers/media/platform/vsp1/vsp1_clu.c          | 292 +++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_clu.h          |  48 ++++++
 drivers/media/platform/vsp1/vsp1_dl.c           |  72 ++++++--
 drivers/media/platform/vsp1/vsp1_drm.c          |   6 +-
 drivers/media/platform/vsp1/vsp1_drv.c          |  69 +++++---
 drivers/media/platform/vsp1/vsp1_entity.c       |   4 +-
 drivers/media/platform/vsp1/vsp1_entity.h       |   5 +-
 drivers/media/platform/vsp1/vsp1_hsit.c         |  14 +-
 drivers/media/platform/vsp1/vsp1_lif.c          |  16 +-
 drivers/media/platform/vsp1/vsp1_lut.c          | 101 +++++++----
 drivers/media/platform/vsp1/vsp1_lut.h          |   7 +-
 drivers/media/platform/vsp1/vsp1_pipe.c         |  54 ++----
 drivers/media/platform/vsp1/vsp1_pipe.h         |   6 +-
 drivers/media/platform/vsp1/vsp1_regs.h         |  24 ++-
 drivers/media/platform/vsp1/vsp1_rpf.c          |  31 ++--
 drivers/media/platform/vsp1/vsp1_rwpf.c         |   6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h         |  14 +-
 drivers/media/platform/vsp1/vsp1_sru.c          |  14 +-
 drivers/media/platform/vsp1/vsp1_uds.c          |  16 +-
 drivers/media/platform/vsp1/vsp1_uds.h          |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c        |  14 +-
 drivers/media/platform/vsp1/vsp1_wpf.c          | 161 ++++++++++++++++--
 include/uapi/linux/media.h                      |  10 ++
 include/uapi/linux/vsp1.h                       |  34 ----
 28 files changed, 891 insertions(+), 213 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.h
 delete mode 100644 include/uapi/linux/vsp1.h

-- 
Regards,

Laurent Pinchart

