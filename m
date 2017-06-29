Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752787AbdF2ODK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 10:03:10 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v1 0/2] drm: rcar-du: Repair vblank event handling
Date: Thu, 29 Jun 2017 15:02:54 +0100
Message-Id: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The recent changes to the rcar-du driver to fix a race condition inadvertently
change the order of which vblanks are reported.

Correct this by handling vblank events in the same completion handler. This
removes the need for the IRQ handler on DU instances which are sourced by a
VSP1.

For other platforms (Gen2) the vblank handler was enabling the VBK interrupt,
but parsing on the FRM interrupt. Fix this by enabling the FRM interrupt using
the FRE bit in the DIER register

Kieran Bingham (2):
  drm: rcar-du: Enable the FRM interrupt for vblank
  drm: rcar-du: Repair vblank for DRM page flips using the VSP1

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c   | 25 ++++++++++++++++++++-----
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h   |  2 ++-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c    |  8 ++++++--
 drivers/media/platform/vsp1/vsp1_drm.c   |  5 +++--
 drivers/media/platform/vsp1/vsp1_drm.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  | 20 ++++++++++----------
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c |  6 +++++-
 include/media/vsp1.h                     |  2 +-
 9 files changed, 49 insertions(+), 23 deletions(-)

base-commit: fa5b4114202de0c1a7a64fd407af0b81ca529419
-- 
git-series 0.9.1
