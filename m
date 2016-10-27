Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964947AbcJ0OBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:01:38 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC 0/3] vsp1 writeback prototype
Date: Thu, 27 Oct 2016 15:01:22 +0100
Message-Id: <1477576885-21978-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series presents an initial version of a write back video node for the VSP
DRM pipeline, utilising the existing vsp1_video base where possible.

The current version limits the output of the video node to match the frames
presented by updates from the CRTC atomic flush events. Matching the output rate
against the vsync/display rate has proven more difficult and I wanted to get
this out for review early.

This series is based on renesas-drivers-2016-10-25-v4.9-rc2, and has been
tested on a Salvator-H3. An updated/recent firmware is essential on this target
otherwise WPF underruns will occur.

This output can be tested with kmstest to generate frames and yavta to capture:

Terminal 1:
 # kmstest --flip --sync

Terminal 2:
 # yavta -c60 -n8 -f RGB24 -s1024x768 \
	--file=frame-rgb24-1024x768-#.bin /dev/$VIDEO

$VIDEO must be determined for your platform and represents the WPF Video node
from the VSP-D. On Salvator-H3, on renesas-drivers-2016-10-25-v4.9-rc2 this is
active at /dev/video28

Kieran Bingham (3):
  Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
  v4l: vsp1: allow entities to have multiple source pads
  v4l: vsp1: Provide a writeback video device

 drivers/media/platform/vsp1/vsp1.h        |   1 +
 drivers/media/platform/vsp1/vsp1_bru.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_clu.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_drm.c    |  20 ++++
 drivers/media/platform/vsp1/vsp1_drv.c    |   5 +-
 drivers/media/platform/vsp1/vsp1_entity.c |  15 +--
 drivers/media/platform/vsp1/vsp1_entity.h |   3 +-
 drivers/media/platform/vsp1/vsp1_histo.c  |   2 +-
 drivers/media/platform/vsp1/vsp1_hsit.c   |   2 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  15 ++-
 drivers/media/platform/vsp1/vsp1_rwpf.h   |   2 +
 drivers/media/platform/vsp1/vsp1_sru.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c  | 172 +++++++++++++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_video.h  |   5 +
 drivers/media/platform/vsp1/vsp1_wpf.c    |  23 +++-
 19 files changed, 238 insertions(+), 41 deletions(-)

-- 
2.7.4

