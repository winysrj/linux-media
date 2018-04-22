Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54804 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbeDVMn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 08:43:29 -0400
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 611E51513
        for <linux-media@vger.kernel.org>; Sun, 22 Apr 2018 14:43:27 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.18] R-Car VSP1 changes
Date: Sun, 22 Apr 2018 15:43:40 +0300
Message-ID: <2212695.T3LGG1uxco@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 1d338b86e17d87215cf57b1ad1d13b2afe582d33:

  media: v4l2-compat-ioctl32: better document the code (2018-04-20 08:24:13 
-0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/vsp1/bru-brs

for you to fetch changes up to 5c0a8b4dfadee010a68b88d82b28f09f373faf86:

  v4l: vsp1: Rename BRU to BRx (2018-04-22 14:11:06 +0300)

----------------------------------------------------------------
Laurent Pinchart (15):
      v4l: vsp1: Don't start/stop media pipeline for DRM
      v4l: vsp1: Remove unused field from vsp1_drm_pipeline structure
      v4l: vsp1: Store pipeline pointer in vsp1_entity
      v4l: vsp1: Use vsp1_entity.pipe to check if entity belongs to a pipeline
      v4l: vsp1: Share duplicated DRM pipeline configuration code
      v4l: vsp1: Move DRM atomic commit pipeline setup to separate function
      v4l: vsp1: Setup BRU at atomic commit time
      v4l: vsp1: Replace manual DRM pipeline input setup in vsp1_du_setup_lif
      v4l: vsp1: Move DRM pipeline output setup code to a function
      v4l: vsp1: Turn frame end completion status into a bitfield
      v4l: vsp1: Add per-display list internal completion notification support
      v4l: vsp1: Generalize detection of entity removal from DRM pipeline
      v4l: vsp1: Assign BRU and BRS to pipelines dynamically
      v4l: vsp1: Add BRx dynamic assignment debugging messages
      v4l: vsp1: Rename BRU to BRx

 drivers/media/platform/vsp1/Makefile                   |   2 +-
 drivers/media/platform/vsp1/vsp1.h                     |   6 +-
 drivers/media/platform/vsp1/{vsp1_bru.c => vsp1_brx.c} | 202 +++---
 drivers/media/platform/vsp1/{vsp1_bru.h => vsp1_brx.h} |  18 +-
 drivers/media/platform/vsp1/vsp1_dl.c                  |  45 +-
 drivers/media/platform/vsp1/vsp1_dl.h                  |   7 +-
 drivers/media/platform/vsp1/vsp1_drm.c                 | 828 +++++++++------
 drivers/media/platform/vsp1/vsp1_drm.h                 |  16 +-
 drivers/media/platform/vsp1/vsp1_drv.c                 |   8 +-
 drivers/media/platform/vsp1/vsp1_entity.h              |   2 +
 drivers/media/platform/vsp1/vsp1_histo.c               |   2 +-
 drivers/media/platform/vsp1/vsp1_histo.h               |   3 -
 drivers/media/platform/vsp1/vsp1_pipe.c                |  53 +-
 drivers/media/platform/vsp1/vsp1_pipe.h                |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c                 |  12 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h                |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c               |  39 +-
 drivers/media/platform/vsp1/vsp1_wpf.c                 |   8 +-
 18 files changed, 718 insertions(+), 543 deletions(-)
 rename drivers/media/platform/vsp1/{vsp1_bru.c => vsp1_brx.c} (63%)
 rename drivers/media/platform/vsp1/{vsp1_bru.h => vsp1_brx.h} (66%)

-- 
Regards,

Laurent Pinchart
