Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753449AbdEIMhj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 08:37:39 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v5 0/2] v4l: vsp1: Fix suspend/resume and race on M2M pipelines
Date: Tue,  9 May 2017 13:37:29 +0100
Message-Id: <cover.7da7d07a321ae8bff8445a8dd714d9a61a3ee71b.1494328856.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This small patchset helps rework the VSP1 driver to repair an issue on
suspend/resume operations whereby the pipeline does not get reconfigured after
it has been re-initialised following a resume operation.

Patch [1/2] is a code move only, with no functional change.
Patch [2/2] fixes the suspend/resume operations for video pipelines by marking
            the new pipe configured flag as false, and configuring the pipe
            during the vsp1_video_pipeline_run() call.

v5:
 - Rebased for v4.12-rc1
 - Dropped two patches from v4 as they are integrated already:
    - BRU streamon race
    - DRM scoped pipe->dl removal

v4:
 - Rework and separate out the BRU race back to v1 style implementation
 - Split BRU race and Suspend Resume fixes into separate commits.

v3:
 - Move configured=false from vsp1_device_init to vsp1_reset_wpf()
 - Clean up flag dereferencing with a local struct *

v2:
 - Refactor video pipeline configuration implementation to solve both suspend
   resume and the VSP BRU race in a single change

v1:
 - Original pipeline configuration rework

Kieran Bingham (2):
  v4l: vsp1: Move vsp1_video_setup_pipeline()
  v4l: vsp1: Repair suspend resume operations for video pipelines

 drivers/media/platform/vsp1/vsp1_drv.c   |   4 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  |   1 +-
 drivers/media/platform/vsp1/vsp1_pipe.h  |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c | 123 +++++++++++-------------
 4 files changed, 64 insertions(+), 68 deletions(-)

base-commit: 13e0988140374123bead1dd27c287354cb95108e
-- 
git-series 0.9.1
