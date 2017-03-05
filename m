Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdCEQAM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Mar 2017 11:00:12 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 0/3] RCAR-DU, VSP1: Prevent pre-emptive frame flips on VSP1-DRM pipelines
Date: Sun,  5 Mar 2017 16:00:01 +0000
Message-Id: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RCAR-DU utilises a running VSPD pipeline to perform processing for the
display pipeline. This presents the opportunity for some race conditions to
affect the quality of the display output.

To prevent reporting page flips early, we must track this timing through the
VSP1, and only allow the rcar-du object to report the page-flip completion
event after the VSP1 has processed.

This series ensures that tearing and flicker is prevented, without introducing the
performance impact mentioned in the previous series.

[PATCH 1/3] handles potential race conditions in vsp1_dlm_irq_frame_end() and
            prevents signalling the frame end in this event.
[PATCH 2/3] extends the VSP1 to allow a callback to be registered giving the
            VSP1 the ability to notify completion events.
[PATCH 3/3] utilises the callback extension to send page flips at the end of
            VSP processing for Gen3 platforms.

These patches have been tested by introducing artificial delays in the commit
code paths and verifying that no visual tearing or flickering occurs.

Extensive testing around the race window has been performed by dynamically
adapting the artificial delay between 10, and 17 seconds in 100uS increments
for periods of 5 seconds on each delay test. These tests have successfully run
for 3 hours.

Manual start/stop testing has also been performed.

Kieran Bingham (3):
  v4l: vsp1: Postpone frame end handling in event of display list race
  v4l: vsp1: Extend VSP1 module API to allow DRM callbacks
  drm: rcar-du: Register a completion callback with VSP1

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c  |  8 ++++++--
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h  |  1 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |  9 +++++++++
 drivers/media/platform/vsp1/vsp1_dl.c   | 19 +++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_dl.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c  | 17 +++++++++++++++++
 drivers/media/platform/vsp1/vsp1_drm.h  | 11 +++++++++++
 drivers/media/platform/vsp1/vsp1_pipe.c | 13 ++++++++++++-
 include/media/vsp1.h                    | 13 +++++++++++++
 9 files changed, 87 insertions(+), 6 deletions(-)

base-commit: cdb5795cbc4ddbe5082c25c52ebc1d811ac3849e
-- 
git-series 0.9.1
