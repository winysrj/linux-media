Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdIOQmN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:42:13 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v1 0/3] drm/media: Implement DU Suspend and Resume on VSP pipelines
Date: Fri, 15 Sep 2017 17:42:04 +0100
Message-Id: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This short series covers two subsystems and implements support for suspend and
resume operations on the DU pipelines on Gen3 Rcar platforms.

Patch 1: Prevent resuming DRM pipelines,
  - Ensures that the VSP does not incorrectly start DU pipelines.

Patch 2: Add suspend resume helpers
  - Makes use of the atomic helper functions to control the CRTCs
    and fbdev emulation.

Patch 3: Remove unused CRTC suspend/resume functions
  - Cleans up some old, related but unused functions that are not
    necessary to keep in the code base.

Whilst this is posted as a single series, there are no hard dependencies
between any of the three patches. They can be picked up independently as
and when they are successfully reviewed.

This series can be fetched from the following:

 git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git tags/vsp-du/du-suspend-resume/v1
  
It is based upon a merge of both the current linux-media master branch and the DRM drm-next tree.

Kieran Bingham (3):
  media: vsp1: Prevent resuming DRM pipelines
  drm: rcar-du: Add suspend resume helpers
  drm: rcar-du: Remove unused CRTC suspend/resume functions

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 35 +---------------------------
 drivers/gpu/drm/rcar-du/rcar_du_drv.c  | 18 +++++++++++---
 drivers/gpu/drm/rcar-du/rcar_du_drv.h  |  1 +-
 drivers/media/platform/vsp1/vsp1_drv.c |  8 +++++-
 4 files changed, 23 insertions(+), 39 deletions(-)

base-commit: 8d2ec9ae96657bbd539d88dbc9d01088f2c9ee63
-- 
git-series 0.9.1
