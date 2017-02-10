Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752790AbdBJU1o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 15:27:44 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/8] v4l: vsp1: Partition phase developments
Date: Fri, 10 Feb 2017 20:27:28 +0000
Message-Id: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series presents ongoing work with the scaler partition algorithm.

It is based upon the previous partition algorithm improvements submission [0]
This series has been pushed to a tag [1] for convenience in testing.

Patches 1-3, provide fixes and additions to the register definitions needed for
controlling the phases of the UDS.

Patches 4 and 5 rework the partition data configuration storage, opening the
path for Patch 6 to implement a new entity operation API. This new '.partition'
operation gives each entity an opportunity to adapt the partition data based on
its configuration.

A new helper function "vsp1_pipeline_propagate_partition()" is provided by the
vsp1_pipe to walk the pipeline in reverse, with each entity having the
opportunity to define it's input requirements to the predecessors.

Partition data is stored somewhat inefficiently in this series, whilst the
process is established and can be considered for improvement later.

Patch 7 begins the implementation of calculating the phase values in the UDS,
and applying them in the VI6_UDS_HPHASE register appropriately. Phase
calculations have been established from the partition algorithm pseudo code
provided by renesas, although the 'end phase' is always set as 0 in this code,
it is yet to be determined if this has an effect.

Finally Patch 8, begins to allow the UDS entity to perform extra overlap at the
partition borders to provide the filters with the required data to generate
clean transitions from one partition to the next.

[0] https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg08631.html
[1] https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git#vsp1/pa-phases-2017-02-10

Kieran Bingham (8):
  v4l: vsp1: Provide UDS register updates
  v4l: vsp1: Track the SRU entity in the pipeline
  v4l: vsp1: Correct image partition parameters
  v4l: vsp1: Move partition rectangles to struct
  v4l: vsp1: Operate on partition struct data directly
  v4l: vsp1: Allow entities to participate in the partition algorithm
  v4l: vsp1: Calculate UDS phase for partitions
  v4l: vsp1: Implement left edge partition algorithm overlap

 drivers/media/platform/vsp1/vsp1_entity.h |   8 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  22 ++++-
 drivers/media/platform/vsp1/vsp1_pipe.h   |  49 +++++++-
 drivers/media/platform/vsp1/vsp1_regs.h   |  14 ++-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  40 +++---
 drivers/media/platform/vsp1/vsp1_sru.c    |  29 +++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 144 ++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.c  |  82 ++++++++-----
 drivers/media/platform/vsp1/vsp1_wpf.c    |  34 +++--
 9 files changed, 364 insertions(+), 58 deletions(-)

base-commit: 0c3b6ad6a559391f367879fd4be6d2d85625bd5a
-- 
git-series 0.9.1
