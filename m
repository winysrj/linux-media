Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753124AbdGNQIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:08:46 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 0/6] vsp1 partition algorithm improvements
Date: Fri, 14 Jul 2017 17:08:31 +0100
Message-Id: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some updates and initial improvements for the VSP1 partition algorithm that
remove redundant processing and variables, reducing the processing done in
interrupt context slightly.

Patches 1, 2 and 3 clean up the calculation of the partition windows such that
they are only calculated once at streamon.

Patch 4 improves the allocations with a new vsp1_partition object to track each
window state.

Patches 5, and 6 then go on to enhance the partition algorithm by allowing each
entity to calculate the requirements for it's pipeline predecessor to
successfully generate the requested output window. This system allows the
entity objects to specify what they need to fulfil the output for the next
entity in the pipeline.

v2:
 - Rebased to v4.12-rc1
 - Partition tables dynamically allocated
 - review fixups

Kieran Bingham (6):
  v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
  v4l: vsp1: Calculate partition sizes at stream start.
  v4l: vsp1: Remove redundant context variables
  v4l: vsp1: Move partition rectangles to struct and operate directly
  v4l: vsp1: Provide UDS register updates
  v4l: vsp1: Allow entities to participate in the partition algorithm

 drivers/media/platform/vsp1/vsp1_entity.h |   8 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  22 +++-
 drivers/media/platform/vsp1/vsp1_pipe.h   |  48 ++++++-
 drivers/media/platform/vsp1/vsp1_regs.h   |  14 ++-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  31 ++--
 drivers/media/platform/vsp1/vsp1_sru.c    |  30 ++++-
 drivers/media/platform/vsp1/vsp1_uds.c    |  43 +++++-
 drivers/media/platform/vsp1/vsp1_video.c  | 163 ++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_wpf.c    |  33 +++--
 9 files changed, 289 insertions(+), 103 deletions(-)

base-commit: 70e60837e669f6fbc8bba30db9a2244d347643bc
-- 
git-series 0.9.1
