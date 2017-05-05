Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752758AbdEEPVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 11:21:22 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, mchehab@kernel.org
Cc: kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 0/4] RCAR-DU, VSP1: Prevent pre-emptive frame flips on VSP1-DRM pipelines
Date: Fri,  5 May 2017 16:21:06 +0100
Message-Id: <cover.7bcdc495e53f6c50c4c68df9ac0b57361b88d2f8.1493995408.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RCAR-DU utilises a running VSPD pipeline to perform processing for the
display pipeline. This presents the opportunity for some race conditions to
affect the quality of the display output.

To prevent reporting page flips early, we must track this timing through the
VSP1, and only allow the rcar-du object to report the page-flip completion
event after the VSP1 has processed.

This series ensures that tearing and flicker is prevented, without introducing
any (substantial) performance impact.

These patches have been tested by introducing artificial delays in the commit
code paths and verifying that no visual tearing or flickering occurs.

Extensive testing around the race window has been performed by dynamically
adapting the artificial delay between 15, and 17 seconds in 100uS increments
for periods of 5 seconds on each delay test. These tests have successfully run
for 3 hours.

Manual start/stop testing has also been performed.

Mauro: As this patchset covers two subsystems, and the DRM/DU side is dependant
upon the media/VSP side, If you are happy with these patches, Would it be
possible to get acks from you for integration through the DRM tree please?

Regards

Kieran

Kieran Bingham (3):
  v4l: vsp1: Postpone frame end handling in event of display list race
  v4l: vsp1: Extend VSP1 module API to allow DRM callbacks
  drm: rcar-du: Register a completion callback with VSP1

Laurent Pinchart (1):
  drm: rcar-du: Arm the page flip event after queuing the page flip

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c  | 30 ++++++++++++++------------
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h  |  1 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c   |  9 ++++++++-
 drivers/media/platform/vsp1/vsp1_dl.c   | 19 ++++++++++++++--
 drivers/media/platform/vsp1/vsp1_dl.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c  | 17 +++++++++++++++-
 drivers/media/platform/vsp1/vsp1_drm.h  | 11 ++++++++++-
 drivers/media/platform/vsp1/vsp1_pipe.c | 13 ++++++++++-
 include/media/vsp1.h                    |  7 ++++++-
 9 files changed, 92 insertions(+), 17 deletions(-)

base-commit: 4df0f635a142c7498d20de9356851fb989c7f653
-- 
git-series 0.9.1
