Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdCDCCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 21:02:15 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 0/3] RCAR-DU, VSP1: Prevent pre-emptive frame flips on VSP1-DRM pipelines
Date: Sat,  4 Mar 2017 02:01:16 +0000
Message-Id: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RCAR-DU utilises a running VSPD pipeline to perform processing
for the display pipeline.

Changes to this pipeline are performed with an atomic flush operation which
updates the state in the VSPD. Due to the way the running pipeline is
operated, any flush operation has an implicit latency of one frame interval.

This comes about as the display list is committed, but not updated until the
next VSP1 interrupt. At this point the frame is being processed, but is not
complete until the following VSP1 frame end interrupt.

To prevent reporting page flips early, we must track this timing through the
VSP1, and only allow the rcar-du object to report the page-flip completion
event after the VSP1 has processed.

This series ensures that tearing and flicker is prevented, without introducing the
performance impact mentioned in the previous series.

[PATCH 1/3] extends the VSP1 to allow a callback to be registered giving the
            VSP1 the ability to notify completion events
[PATCH 2/3] checks for race conditions in the commits of the display list, and
            in such event postpones the sending of the completion event
[PATCH 3/3] Utilises the callback extension to send page flips at the end of
            VSP processing.

These patches have been tested by introducing artificial delays in the commit
code paths and verifying that no visual tearing or flickering occurs.

Manual start/stop testing has also been performed

Kieran Bingham (3):
  v4l: vsp1: extend VSP1 module API to allow DRM callbacks
  v4l: vsp1: Postpone page flip in event of display list race
  drm: rcar-du: Register a completion callback with VSP1

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c  | 10 +++++++--
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h  |  2 ++-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   | 29 ++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_dl.c   |  9 ++++++--
 drivers/media/platform/vsp1/vsp1_dl.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c  | 22 ++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_drm.h  | 10 +++++++++-
 drivers/media/platform/vsp1/vsp1_pipe.c |  6 ++++-
 drivers/media/platform/vsp1/vsp1_pipe.h |  2 ++-
 include/media/vsp1.h                    |  3 +++-
 10 files changed, 89 insertions(+), 6 deletions(-)

base-commit: 55e78dfc82988a79773ccca67e121f9a88df81c2
-- 
git-series 0.9.1
