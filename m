Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58379 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932658AbdGKW3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 18:29:52 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 0/2] drm: rcar-du: Repair vblank event handling
Date: Wed, 12 Jul 2017 01:29:39 +0300
Message-Id: <20170711222942.27735-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The recent changes to the rcar-du driver to fix a page flip handling race
condition changed the order of which vblanks and page flips are handled,
resulting in incorrect timestamps being reported in the vblan events.

Correct this by handling vblank events in the same completion handler as page
flips. This removes the need for the IRQ handler on DU instances which are
sourced by a VSP.

Compared to v1,

- Patch 1/3 replaces patch 1/2 to use the VBK interrupt instead of the FRM
  interrupt when not using the VSP
- The new patch 2/3 simplifies plane to CRTC assignment when using the VSP to
  prepare for patch 3/3
- Patch 3/3 doesn't enable the VBK interrupt when using the VSP

Kieran Bingham (1):
  drm: rcar-du: Repair vblank for DRM page flips using the VSP

Laurent Pinchart (2):
  drm: rcar-du: Use the VBK interrupt for vblank events
  drm: rcar-du: Fix planes to CRTC assignment when using the VSP

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c   | 58 +++++++++++++++++++-------------
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h   |  2 ++
 drivers/gpu/drm/rcar-du/rcar_du_group.c  | 12 +++++++
 drivers/gpu/drm/rcar-du/rcar_du_kms.c    | 28 +++++++++------
 drivers/gpu/drm/rcar-du/rcar_du_plane.c  | 10 +-----
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c    | 17 ++++------
 drivers/media/platform/vsp1/vsp1_drm.c   |  5 +--
 drivers/media/platform/vsp1/vsp1_drm.h   |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  | 20 +++++------
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c |  6 +++-
 include/media/vsp1.h                     |  2 +-
 12 files changed, 94 insertions(+), 70 deletions(-)

-- 
Regards,

Laurent Pinchart
