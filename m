Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936133AbcKDSTn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 14:19:43 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/4] vsp1 partition algorithm improvements
Date: Fri,  4 Nov 2016 18:19:26 +0000
Message-Id: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some updates and initial improvements for the VSP1 partition algorithm that
remove redundant processing and variables, reducing the processing done in
interrupt context slightly.

Patch 1 brings in some protection against invalid pipeline configurations that
are not supported by the partition algorithm on Gen3 hardware.

Patches 2,3 and 4 clean up the calculation of the partition sizes such that they
are only calculated once at streamon - and the partition windows are stored in
the vsp1_pipeline object.

Kieran Bingham (4):
  v4l: vsp1: Implement partition algorithm restrictions
  v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
  v4l: vsp1: Calculate partition sizes at stream start.
  v4l: vsp1: Remove redundant context variables

 drivers/media/platform/vsp1/vsp1_pipe.h  |  10 ++-
 drivers/media/platform/vsp1/vsp1_sru.c   |   7 +-
 drivers/media/platform/vsp1/vsp1_sru.h   |   1 +
 drivers/media/platform/vsp1/vsp1_video.c | 124 +++++++++++++++++++------------
 4 files changed, 89 insertions(+), 53 deletions(-)

-- 
2.7.4

