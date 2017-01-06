Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966900AbdAFMMC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:12:02 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 0/4] v4l: vsp1: Fix suspend/resume and race on M2M pipelines 
Date: Fri,  6 Jan 2017 12:11:21 +0000
Message-Id: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
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

Patch [1/4] fixes the multiple stream BRU race
Patch [2/4] is a code move only, with no functional change.
Patch [3/4] fixes the suspend/resume operations for video pipelines by marking
            the new pipe configured flag as false, and configuring the pipe
            during the vsp1_video_pipeline_run() call.
Patch [4/4] removes the context scoped 'pipe->dl' from vsp1_drm.c which is only
            used in a single function

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

Kieran Bingham (4):
  v4l: vsp1: Prevent multiple streamon race commencing pipeline early
  v4l: vsp1: Move vsp1_video_setup_pipeline()
  v4l: vsp1: Repair suspend resume operations for video pipelines
  v4l: vsp1: Remove redundant pipe->dl usage from drm

 drivers/media/platform/vsp1/vsp1_drm.c   |  20 ++--
 drivers/media/platform/vsp1/vsp1_drv.c   |   4 +-
 drivers/media/platform/vsp1/vsp1_pipe.c  |   1 +-
 drivers/media/platform/vsp1/vsp1_pipe.h  |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c | 133 ++++++++++++------------
 5 files changed, 86 insertions(+), 76 deletions(-)

base-commit: 16b6839d4e6f0c3fe6d5db2b4c90fb39dabc8640
-- 
git-series 0.9.1
