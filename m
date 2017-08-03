Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55528 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbdHCNbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 09:31:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [GIT PUL FOR v4.14] R-Car DU changes
Date: Thu, 03 Aug 2017 16:31:52 +0300
Message-ID: <5217228.MDybz51Srh@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

The following changes since commit e6742e1021a5cec55fab50a0b115c65217488eda:

  drm: linux-next: build failure after merge of the drm-misc tree (2017-07-27 
08:27:11 +1000)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git tags/drm-next-du-20170803

for you to fetch changes up to a01ce6678bad548be4063286bfd12ccba3808a2e:

  drm: rcar-du: Use new iterator macros (2017-08-03 16:17:35 +0300)

The branch contains patches for the VSP driver which would normally go through 
the V4L2 subsystem. As some DU patches depend on them (and as one of the 
patches in the series touches the two drivers), it was agreed with Mauro to 
get the whole series merged through your tree (all the patches that touch V4L2 
carry his Acked-by).

I have based the series on top of the v4.13-rc2 backmerge in your tree (plus 
one compilation fix from -next), as it depends on "drm: Add 
drm_atomic_helper_wait_for_flip_done()" that you have merged after v4.13-rc1.

There is currently no patch in the linux-media, drm or drm-misc trees that 
conflict with the series. We have other VSP patches pending for v4.14 that 
will get merged through the V4L2 tree. If any conflict occurs, I'll make sure 
to base them on top of this tag, and tell Mauro to pull directly.

----------------------------------------------------------------
Dan Carpenter (1):
      drm: rcar-du: Remove an unneeded NULL check

Kieran Bingham (1):
      drm: rcar-du: Repair vblank for DRM page flips using the VSP

Kuninori Morimoto (1):
      drm: rcar-du: Use of_graph_get_remote_endpoint()

Laurent Pinchart (20):
      v4l: vsp1: Fill display list headers without holding dlm spinlock
      v4l: vsp1: Don't recycle active list at display start
      v4l: vsp1: Don't set WPF sink pointer
      v4l: vsp1: Store source and sink pointers as vsp1_entity
      v4l: vsp1: Don't create links for DRM pipeline
      v4l: vsp1: Add pipe index argument to the VSP-DU API
      v4l: vsp1: Add support for the BRS entity
      v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances
      v4l: vsp1: Add support for multiple LIF instances
      v4l: vsp1: Add support for multiple DRM pipelines
      v4l: vsp1: Add support for header display lists in continuous mode
      drm: rcar-du: Fix comments to comply with the kernel coding style
      drm: rcar-du: Support multiple sources from the same VSP
      drm: rcar-du: Restrict DPLL duty cycle workaround to H3 ES1.x
      drm: rcar-du: Configure DPAD0 routing through last group on Gen3
      drm: rcar-du: Setup planes before enabling CRTC to avoid flicker
      drm: rcar-du: Add HDMI outputs to R8A7796 device description
      drm: rcar-du: Use the VBK interrupt for vblank events
      drm: rcar-du: Wait for flip completion instead of vblank in commit tail
      drm: rcar-du: Fix race condition when disabling planes at CRTC stop

Maarten Lankhorst (1):
      drm: rcar-du: Use new iterator macros

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c    | 189 ++++++++++++++++++-------
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h    |  17 ++-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c     |  28 ++--
 drivers/gpu/drm/rcar-du/rcar_du_group.c   |  38 +++--
 drivers/gpu/drm/rcar-du/rcar_du_kms.c     | 113 ++++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c |  12 +-
 drivers/gpu/drm/rcar-du/rcar_du_plane.c   | 114 ++++++++-------
 drivers/gpu/drm/rcar-du/rcar_du_plane.h   |   3 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c     |  51 ++++---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h     |  10 +-
 drivers/gpu/drm/rcar-du/rcar_dw_hdmi.c    |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   7 +-
 drivers/media/platform/vsp1/vsp1_bru.c    |  45 ++++--
 drivers/media/platform/vsp1/vsp1_bru.h    |   4 +-
 drivers/media/platform/vsp1/vsp1_dl.c     | 205 ++++++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_dl.h     |   1 -
 drivers/media/platform/vsp1/vsp1_drm.c    | 286 +++++++++++++----------------
 drivers/media/platform/vsp1/vsp1_drm.h    |  38 ++---
 drivers/media/platform/vsp1/vsp1_drv.c    | 115 ++++++++++-----
 drivers/media/platform/vsp1/vsp1_entity.c |  40 ++++--
 drivers/media/platform/vsp1/vsp1_entity.h |   5 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |   5 +-
 drivers/media/platform/vsp1/vsp1_lif.h    |   2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  27 ++--
 drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |  46 ++++--
 drivers/media/platform/vsp1/vsp1_video.c  |  69 +++++----
 drivers/media/platform/vsp1/vsp1_wpf.c    |   4 +-
 include/media/vsp1.h                      |  12 +-
 29 files changed, 949 insertions(+), 541 deletions(-)
-- 
Regards,

Laurent Pinchart
