Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752268AbdIMLSy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 07:18:54 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 0/9] vsp1: TLB optimisation and DL caching
Date: Wed, 13 Sep 2017 12:18:39 +0100
Message-Id: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each display list currently allocates an area of DMA memory to store register
settings for the VSP1 to process. Each of these allocations adds pressure to
the IPMMU TLB entries.

We can reduce the pressure by pre-allocating larger areas and dividing the area
across multiple bodies represented as a pool.

With this reconfiguration of bodies, we can adapt the configuration code to
separate out constant hardware configuration and cache it for re-use.

This posting is only really a status update following the previous review after
quite a bit of work has been done. However this series is not yet complete, and
I do not expect a full review - or integration of this series in its current
form.

In particular:
  Patch 1 : Reword uses of 'fragment' as 'body'
          - Is new and can be reviewed if desired.

Otherwise, most other issues have been addressed, and the series is rebased to
utilise the term 'bodies' instead of 'fragments'. A few 'larger' topics came up
in review, and will be considered in a follow up series. (v4+)

  Patch 3 : Provide a body pool
          - Allocates more memory than is required for 'extra_size'

  Patch 5 : Use reference counting for bodies
          - Minor comment to be fixed up. (I should have done this already)

  Patch 7 : Adapt entities to configure into a body
          - To be reworked, quite substantially.

  Patch 8 : Move video configuration to a cached dlb
          - Previous review comments still to be addressed

The patches provided in this series can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git  tags/vsp1/tlb-optimise/v3

Kieran Bingham (9):
  v4l: vsp1: Reword uses of 'fragment' as 'body'
  v4l: vsp1: Protect bodies against overflow
  v4l: vsp1: Provide a body pool
  v4l: vsp1: Convert display lists to use new body pool
  v4l: vsp1: Use reference counting for bodies
  v4l: vsp1: Refactor display list configure operations
  v4l: vsp1: Adapt entities to configure into a body
  v4l: vsp1: Move video configuration to a cached dlb
  v4l: vsp1: Reduce display list body size

 drivers/media/platform/vsp1/vsp1_bru.c    |  32 +--
 drivers/media/platform/vsp1/vsp1_clu.c    |  94 +++---
 drivers/media/platform/vsp1/vsp1_clu.h    |   1 +-
 drivers/media/platform/vsp1/vsp1_dl.c     | 387 +++++++++++++----------
 drivers/media/platform/vsp1/vsp1_dl.h     |  21 +-
 drivers/media/platform/vsp1/vsp1_drm.c    |  21 +-
 drivers/media/platform/vsp1/vsp1_entity.c |  23 +-
 drivers/media/platform/vsp1/vsp1_entity.h |  31 +--
 drivers/media/platform/vsp1/vsp1_hgo.c    |  26 +--
 drivers/media/platform/vsp1/vsp1_hgt.c    |  28 +--
 drivers/media/platform/vsp1/vsp1_hsit.c   |  20 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  23 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |  71 ++--
 drivers/media/platform/vsp1/vsp1_lut.h    |   1 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |   8 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   7 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 179 +++++------
 drivers/media/platform/vsp1/vsp1_sru.c    |  24 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |  73 ++--
 drivers/media/platform/vsp1/vsp1_uds.h    |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c  |  82 ++---
 drivers/media/platform/vsp1/vsp1_video.h  |   2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 325 +++++++++----------
 23 files changed, 811 insertions(+), 670 deletions(-)

base-commit: f44bd631453bf7dcbe57f79b924db3a6dd038bff
-- 
git-series 0.9.1
