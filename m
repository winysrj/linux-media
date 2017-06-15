Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35685 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdFOIXs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:23:48 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/6] Renesas R-Car VSP: Add H3 ES2.0 support
Date: Thu, 15 Jun 2017 11:24:03 +0300
Message-Id: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series implements support for the R-Car H3 ES2.0 SoC in the VSP
driver.

Compared to the H3 ES1.1, the H3 ES2.0 has a new VSP2-DL instance that
includes two blending units, a BRU and a BRS. The BRS is similar to the BRU
but has two inputs only, and is used to service a second DU channel from the
same VSP through a second LIF instances connected to WPF.1.

The patch series starts with a small bug fix in patch 1/6. Patch 2/6 then
implements support for the BRS, and patch 3/6 for the new VSP instances found
in the H3 ES2.0 SoC. Patch 4/6 prepares the VSP driver for multiple DU
channels support by extending the DU-VSP API with an additional argument.

So far the VSP driver always used headerless display lists when operating in
connection with the DU. This mode of operation is only available on WPF.0, so
support for regular display lists with headers when operating with the DU is
added in patches 5/6 and 6/6.

Laurent Pinchart (6):
  v4l: vsp1: Remove WPF vertical flip support on VSP2-B[CD] and VSP2-D
  v4l: vsp1: Add support for the BRS entity
  v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances
  v4l: vsp1: Add pipe index argument to the VSP-DU API
  v4l: vsp1: Fill display list headers without holding dlm spinlock
  v4l: vsp1: Add support for header display lists in continuous mode

 drivers/gpu/drm/rcar-du/rcar_du_vsp.c     |   9 +-
 drivers/media/platform/vsp1/vsp1.h        |   2 +
 drivers/media/platform/vsp1/vsp1_bru.c    |  45 ++++---
 drivers/media/platform/vsp1/vsp1_bru.h    |   4 +-
 drivers/media/platform/vsp1/vsp1_dl.c     | 202 ++++++++++++++++++++----------
 drivers/media/platform/vsp1/vsp1_drm.c    |  28 +++--
 drivers/media/platform/vsp1/vsp1_drv.c    |  49 +++++++-
 drivers/media/platform/vsp1/vsp1_entity.c |  13 +-
 drivers/media/platform/vsp1/vsp1_entity.h |   1 +
 drivers/media/platform/vsp1/vsp1_pipe.c   |   7 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |  41 ++++--
 drivers/media/platform/vsp1/vsp1_video.c  |  63 ++++++----
 drivers/media/platform/vsp1/vsp1_wpf.c    |   4 +-
 include/media/vsp1.h                      |   8 +-
 14 files changed, 334 insertions(+), 142 deletions(-)

-- 
Regards,

Laurent Pinchart
