Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753013AbcLFJfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 04:35:37 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/4] v4l: vsp1: Fix suspend/resume and race on M2M pipelines
Date: Tue,  6 Dec 2016 09:35:09 +0000
Message-Id: <1481016913-30608-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This small patchset helps rework the VSP1 driver to repair an issue on
suspend/resume operations whereby the pipeline does not get reconfigured after
it has been re-initialised following a resume operation.

Along side this, there was an intrinsic race in the vsp1_video_start_streaming()
function whereby multiple streams operating through a BRU, could find themselves
commencing an operation before the pipeline has been configured, or worse -
commencing, just as the pipeline is being configured resulting in a null pointer
dereference on pipe->dl.

This series superceeds a previous effort to fix the BRU race.

Patch [1/4] is a code move only, with no functional change.
Patch [2/4] refactors the vsp1_video_start_streaming() function and fixes both
            suspend/resume, and the BRU race in a single change
Patch [3/4] removes the context scoped 'pipe->dl' which has been susceptible to
            races and isn't required to be in the context.
Patch [4/4] is an RFC patch really, that fixes a segfault on error paths  and I
            certainly expect feedback and brief discussion. Please drop Patch 4
            in the event of any further discussion, and don't consider it as
            blocking for the first three patches of this series.

Kieran Bingham (4):
  v4l: vsp1: Move vsp1_video_setup_pipeline()
  v4l: vsp1: Refactor video pipeline configuration
  v4l: vsp1: Use local display lists and remove global pipe->dl
  media: Catch null pipes on pipeline stop

 drivers/media/media-entity.c             |   2 +
 drivers/media/platform/vsp1/vsp1_drm.c   |  20 ++---
 drivers/media/platform/vsp1/vsp1_drv.c   |   3 +
 drivers/media/platform/vsp1/vsp1_pipe.c  |   1 +
 drivers/media/platform/vsp1/vsp1_pipe.h  |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c | 127 +++++++++++++++----------------
 6 files changed, 78 insertions(+), 79 deletions(-)

-- 
2.7.4

