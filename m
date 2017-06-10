Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48881 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbdFJIaa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 04:30:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.13] Renesas R-Car DU driver changes
Date: Sat, 10 Jun 2017 11:30:53 +0300
Message-ID: <3610138.aMAhgRn3Pg@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

The following changes since commit 2ea659a9ef488125eb46da6eb571de5eae5c43f6:

  Linux 4.12-rc1 (2017-05-13 13:19:49 -0700)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git drm/next/du

for you to fetch changes up to fa5b4114202de0c1a7a64fd407af0b81ca529419:

  drm: rcar-du: Map memory through the VSP device (2017-06-09 12:25:38 +0100)

The series interleaves DRM and V4L2 patches due to dependencies between the R-
Car DU and VSP drivers. Mauro has acked all the V4L2 patches to go through 
your tree, and they don't conflict with anything queued for v4.13 in his tree. 
If I need to send any conflicting patches through Mauro's tree for v4.13, I'll 
make sure to base them on this branch.

----------------------------------------------------------------
Kieran Bingham (3):
      v4l: vsp1: Postpone frame end handling in event of display list race
      v4l: vsp1: Extend VSP1 module API to allow DRM callbacks
      drm: rcar-du: Register a completion callback with VSP1

Laurent Pinchart (5):
      drm: rcar-du: Arm the page flip event after queuing the page flip
      v4l: rcar-fcp: Don't get/put module reference
      v4l: rcar-fcp: Add an API to retrieve the FCP device
      v4l: vsp1: Add API to map and unmap DRM buffers through the VSP
      drm: rcar-du: Map memory through the VSP device

Magnus Damm (1):
      v4l: vsp1: Map the DL and video buffers through the proper bus master

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c   | 30 ++++++++-------
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h   |  1 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c    | 83 ++++++++++++++++++++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h    |  2 +
 drivers/media/platform/rcar-fcp.c        | 17 ++++----
 drivers/media/platform/vsp1/vsp1.h       |  1 +
 drivers/media/platform/vsp1/vsp1_dl.c    | 23 +++++++++--
 drivers/media/platform/vsp1/vsp1_dl.h    |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c   | 41 ++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_drm.h   | 11 ++++++
 drivers/media/platform/vsp1/vsp1_drv.c   |  9 +++++
 drivers/media/platform/vsp1/vsp1_pipe.c  | 13 ++++++-
 drivers/media/platform/vsp1/vsp1_video.c |  2 +-
 include/media/rcar-fcp.h                 |  5 +++
 include/media/vsp1.h                     | 10 +++++
 15 files changed, 215 insertions(+), 35 deletions(-)

-- 
Regards,

Laurent Pinchart
