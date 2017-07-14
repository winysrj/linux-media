Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753510AbdGNQOU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:14:20 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/6] vsp1: TLB optimisation
Date: Fri, 14 Jul 2017 17:14:09 +0100
Message-Id: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each display list currently allocates an area of DMA memory to store register
settings for the VSP1 to process. Each of these allocations adds pressure to
the IPMMU TLB entries.

We can reduce the pressure by pre-allocating larger areas and dividing the area
across multiple bodies represented as a pool.

Patch 1 adds protection to ensure that the display list body does not overflow
and will allow us to reduce the size of the body allocations in the future (it
has already helped me catch an overflow during the development of this series,
so I thought it was a worth while addition)

Patch 2 implements the fragment pool object and provides function helpers to
interact with the pool

Patches 3 to 6 convert the existing allocations to use the new fragment pool.
These are separated for clarity, but I have no objections to squashing those
into a single commit if it is preferred.

This series has been tested and based on top of Laurent's recent ES2.0 patch
set at git://linuxtv.org/pinchartl/media.git drm/next/h3-es2/merged

Kieran Bingham (6):
  v4l: vsp1: Protect fragments against overflow
  v4l: vsp1: Provide a fragment pool
  v4l: vsp1: Convert display lists to use new fragment pool
  v4l: vsp1: Convert CLU to use a fragment pool
  v4l: vsp1: Convert LUT to use a fragment pool
  v4l: vsp1: Remove old fragment management

 drivers/media/platform/vsp1/vsp1_clu.c |  18 +-
 drivers/media/platform/vsp1/vsp1_clu.h |   1 +-
 drivers/media/platform/vsp1/vsp1_dl.c  | 294 +++++++++++++-------------
 drivers/media/platform/vsp1/vsp1_dl.h  |   8 +-
 drivers/media/platform/vsp1/vsp1_lut.c |  23 +-
 drivers/media/platform/vsp1/vsp1_lut.h |   1 +-
 6 files changed, 199 insertions(+), 146 deletions(-)

base-commit: 5fee73960b9a0ceb0ccf746dfeb06bdb07199670
-- 
git-series 0.9.1
