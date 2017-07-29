Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49536 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdG2VIt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 17:08:49 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 0/4] drm: rcar-du: Repair vblank event handling
Date: Sun, 30 Jul 2017 00:08:51 +0300
Message-Id: <20170729210855.9187-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The recent changes to the rcar-du driver to fix a page flip handling race
condition changed the order of which vblanks and page flips are handled,
resulting in incorrect timestamps being reported in the vblan events. Correct
this by handling vblank events in the same completion handler as page flips.

Compared to v2 patch 3/4 is completely rewritten with a new approach, as the
previous one caused flip timeouts for a currently unknown reason. This version
now uses the vertical blanking interrupt to handle the CRTC stop race
regardless of the generation of the SoC.

As a result drm_atomic_helper_wait_for_vblanks() can't be used anymore to wait
for completion of a page flip or CRTC disable. I've thus included the
previously posted patch "drm: rcar-du: Wait for flip completion instead of
vblank in commit tail" in this series.

I still plan to investigate why the original version caused issues, as I
believe it went in the right direction. For now this series should do, as it
doesn't introduce any hack and passes all tests properly.

Kieran Bingham (1):
  drm: rcar-du: Repair vblank for DRM page flips using the VSP

Laurent Pinchart (3):
  drm: rcar-du: Use the VBK interrupt for vblank events
  drm: rcar-du: Wait for flip completion instead of vblank in commit
    tail
  drm: rcar-du: Fix race condition when disabling planes at CRTC stop

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c   | 66 +++++++++++++++++++++++++++-----
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h   | 10 +++++
 drivers/gpu/drm/rcar-du/rcar_du_kms.c    |  2 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c    |  8 +++-
 drivers/media/platform/vsp1/vsp1_drm.c   |  5 ++-
 drivers/media/platform/vsp1/vsp1_drm.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  | 20 +++++-----
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c |  6 ++-
 include/media/vsp1.h                     |  2 +-
 10 files changed, 95 insertions(+), 28 deletions(-)

-- 
Regards,

Laurent Pinchart
