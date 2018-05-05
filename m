Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49810 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbeEEODt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 10:03:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>
Subject: [GIT PULL FOR v4.18] VSP1 & DU CRC calculation support
Date: Sat, 05 May 2018 17:04:03 +0300
Message-ID: <3356345.ZyMUuVzF36@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit f2bea20ec56234a8ca8ec4a3481b744b3e0e8813:

  media: cx231xx: remove a now unused var (2018-05-05 08:55:29 -0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/vsp1/discom

for you to fetch changes up to dcdd25c0d98f19fffc7099b3a09f7f47c2125296:

  drm: rcar-du: Add support for CRC computation (2018-05-05 16:56:55 +0300)

Please note that the series contains changes for the DRM tree in patch 8/8. I 
have checked that they don't conflict with anything queued in the drm or drm-
misc trees for v4.18. Given that the series depends on the VSP BRU-BRS series 
that you have merged recently for v4.18, the easiest course of action is to 
get this merged through your tree. Daniel Vetter and Dave Airlie (both CC'ed) 
have given their ack for this (see [1] and [2]).

[1] https://www.spinics.net/lists/dri-devel/msg175198.html
[2] https://www.spinics.net/lists/dri-devel/msg175259.html

----------------------------------------------------------------
Laurent Pinchart (8):
      v4l: vsp1: Use SPDX license headers
      v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation code
      v4l: vsp1: Reset the crop and compose rectangles in the set_fmt helper
      v4l: vsp1: Document the vsp1_du_atomic_config structure
      v4l: vsp1: Extend the DU API to support CRC computation
      v4l: vsp1: Add support for the DISCOM entity
      v4l: vsp1: Integrate DISCOM in display pipeline
      drm: rcar-du: Add support for CRC computation

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c    | 156 +++++++++++++++++++++-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h    |  15 +++
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c     |  12 +-
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |  10 +-
 drivers/media/platform/vsp1/vsp1_brx.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_brx.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_clu.c    |  71 ++--------
 drivers/media/platform/vsp1/vsp1_clu.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_dl.c     |   8 +-
 drivers/media/platform/vsp1/vsp1_dl.h     |   6 +-
 drivers/media/platform/vsp1/vsp1_drm.c    | 127 ++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_drm.h    |  15 ++-
 drivers/media/platform/vsp1/vsp1_drv.c    |  26 +++-
 drivers/media/platform/vsp1/vsp1_entity.c | 103 ++++++++++++++-
 drivers/media/platform/vsp1/vsp1_entity.h |  13 +-
 drivers/media/platform/vsp1/vsp1_hgo.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_hgo.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_hgt.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_hgt.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_histo.c  |  65 +--------
 drivers/media/platform/vsp1/vsp1_histo.h  |   6 +-
 drivers/media/platform/vsp1/vsp1_hsit.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_hsit.h   |   6 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  71 ++--------
 drivers/media/platform/vsp1/vsp1_lif.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |  71 ++--------
 drivers/media/platform/vsp1/vsp1_lut.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   6 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |  46 ++++++-
 drivers/media/platform/vsp1/vsp1_rpf.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h   |   6 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_sru.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |   6 +-
 drivers/media/platform/vsp1/vsp1_uds.h    |   6 +-
 drivers/media/platform/vsp1/vsp1_uif.c    | 271 +++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_uif.h    |  32 +++++
 drivers/media/platform/vsp1/vsp1_video.c  |   6 +-
 drivers/media/platform/vsp1/vsp1_video.h  |   6 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    |   6 +-
 include/media/vsp1.h                      |  45 ++++++-
 44 files changed, 892 insertions(+), 417 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.h

-- 
Regards,

Laurent Pinchart
