Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbdCAOIr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Mar 2017 09:08:47 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH 0/3] RCAR-DU, VSP1: Prevent pre-emptive frame flips on VSP1-DRM pipelines
Date: Wed,  1 Mar 2017 13:12:53 +0000
Message-Id: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
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

[PATCH 1/3] fixes the VSP DRM object to register it's pipeline correctly.
[PATCH 2/3] extends the VSP1 to allow a callback to be registered allowing the
            VSP1 to notify completion events, and extend the existing atomic
            flush API to allow private event data to be passed through.
[PATCH 3/3] Utilises this API extension to postpone page flips as required.

In current testing, with kmstest, and kmscube, it can be seen that our refresh
rate has halved. I believe this is due to the one frame latency imposed by the
VSPD and will need further investigation.

Kieran Bingham (3):
  v4l: vsp1: Register pipe with output WPF
  v4l: vsp1: extend VSP1 module API to allow DRM callback registration
  drm: rcar-du: Register a completion callback with VSP1

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  8 ++++-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  1 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 34 ++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_drm.c | 43 +++++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_drm.h | 12 ++++++++-
 include/media/vsp1.h                   |  6 +++-
 6 files changed, 99 insertions(+), 5 deletions(-)

base-commit: a194138cd82dff52d4c39895fd89dc6f26eafc97
-- 
git-series 0.9.1
