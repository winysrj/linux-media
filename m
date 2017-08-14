Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751576AbdHNPNj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 11:13:39 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 0/8] vsp1: TLB optimisation and DL caching
Date: Mon, 14 Aug 2017 16:13:23 +0100
Message-Id: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each display list currently allocates an area of DMA memory to store register
settings for the VSP1 to process. Each of these allocations adds pressure to
the IPMMU TLB entries.

We can reduce the pressure by pre-allocating larger areas and dividing the area
across multiple bodies represented as a pool.

With this reconfiguration of bodies, we can adapt the configuration code to
separate out constant hardware configuration and cache it for re-use.

Patch 1 adds protection to ensure that the display list body does not overflow
and will allow us to reduce the size of the body allocations in the future (it
has already helped me catch an overflow during the development of this series,
so I thought it was a worth while addition)

Patch 2 implements the fragment pool object and provides function helpers to
interact with the pool

Patch 3 converts the existing allocations to use the new fragment pool.

>From patch 4 to 7, we then refactor the display list handling code to separate
out the two stages of stream setup and frame configuration and then configure
directly into display list bodies. This allows us to cache the constant stream
configuration in a reusable display list body which also repairs suspend/resume
cycles for the video pipelines.

Finally in patch 8, the size of the internal display list body is reduced down
to 64 entries, as the maximum used is now 41 slots. The cached video pipeline
stream configuration appears to use a maximum of 64 entries, but to allow for
expansion this is set to 128 for now to prevent unexpected overflows.

Kieran Bingham (8):
  v4l: vsp1: Protect fragments against overflow
  v4l: vsp1: Provide a fragment pool
  v4l: vsp1: Convert display lists to use new fragment pool
  v4l: vsp1: Use reference counting for fragments
  v4l: vsp1: Refactor display list configure operations
  v4l: vsp1: Adapt entities to configure into a body
  v4l: vsp1: Move video configuration to a cached dlb
  v4l: vsp1: Reduce display list body size

 drivers/media/platform/vsp1/vsp1_bru.c    |  32 +--
 drivers/media/platform/vsp1/vsp1_clu.c    |  86 +++---
 drivers/media/platform/vsp1/vsp1_clu.h    |   1 +-
 drivers/media/platform/vsp1/vsp1_dl.c     | 331 ++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_dl.h     |  13 +-
 drivers/media/platform/vsp1/vsp1_drm.c    |  21 +-
 drivers/media/platform/vsp1/vsp1_entity.c |  23 +-
 drivers/media/platform/vsp1/vsp1_entity.h |  31 +--
 drivers/media/platform/vsp1/vsp1_hgo.c    |  26 +--
 drivers/media/platform/vsp1/vsp1_hgt.c    |  28 +--
 drivers/media/platform/vsp1/vsp1_hsit.c   |  20 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  23 +--
 drivers/media/platform/vsp1/vsp1_lut.c    |  65 +++--
 drivers/media/platform/vsp1/vsp1_lut.h    |   1 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |   8 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   7 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 179 ++++++------
 drivers/media/platform/vsp1/vsp1_sru.c    |  24 +--
 drivers/media/platform/vsp1/vsp1_uds.c    |  73 ++---
 drivers/media/platform/vsp1/vsp1_uds.h    |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c  |  82 +++---
 drivers/media/platform/vsp1/vsp1_video.h  |   2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 325 ++++++++++++-----------
 23 files changed, 753 insertions(+), 650 deletions(-)

base-commit: f44bd631453bf7dcbe57f79b924db3a6dd038bff
-- 
git-series 0.9.1
