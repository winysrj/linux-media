Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51642 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729854AbeHCPMf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 11:12:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [GIT PULL FOR v4.19] VSP1 changes
Date: Fri, 03 Aug 2018 16:16:57 +0300
Message-ID: <5724570.03bHaum5s3@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2c3449fb95c318920ca8dc645d918d408db219ac:

  media: usb: hackrf: Replace GFP_ATOMIC with GFP_KERNEL (2018-08-02 19:16:17 -0400)

are available in the Git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/vsp1/interlace

for you to fetch changes up to 7e4432c469bda8dc09ff4f78b998bca22a131588:

  media: vsp1: Support Interlaced display pipelines (2018-08-03 16:12:07 +0300)

Please note that the last patch from the corresponding series, which enables
interlaced support on the display side, is missing from this pull request and
will be submitted for v4.20 through the DRM tree. As we're late in the release
cycle I thought it would be too difficult to coordinate with Dave in a timely
manner. This series will cause no harm whatsoever even without the change on
the DRM side, as the newly introduced interlaced flag in the VSP1 API exposed
to the DU driver is part of a structure that is initialized to 0.

----------------------------------------------------------------
Kieran Bingham (10):
      media: vsp1: drm: Fix minor grammar error
      media: vsp1: use kernel __packed for structures
      media: vsp1: Rename dl_child to dl_next
      media: vsp1: Remove unused display list structure field
      media: vsp1: Clean up DLM objects on error
      media: vsp1: Provide VSP1 feature helper macro
      media: vsp1: Use header display lists for all WPF outputs linked to the DU
      media: vsp1: Add support for extended display list headers
      media: vsp1: Provide support for extended command pools
      media: vsp1: Support Interlaced display pipelines

 drivers/media/platform/vsp1/vsp1.h      |   3 +
 drivers/media/platform/vsp1/vsp1_dl.c   | 432 +++++++++++++++++++++++-------
 drivers/media/platform/vsp1/vsp1_dl.h   |  28 +++
 drivers/media/platform/vsp1/vsp1_drm.c  |   8 +-
 drivers/media/platform/vsp1/vsp1_drv.c  |  20 +-
 drivers/media/platform/vsp1/vsp1_pipe.h |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h |   5 +-
 drivers/media/platform/vsp1/vsp1_rpf.c  |  72 ++++++-
 drivers/media/platform/vsp1/vsp1_wpf.c  |   6 +-
 include/media/vsp1.h                    |   2 +
 10 files changed, 468 insertions(+), 110 deletions(-)
-- 
Regards,

Laurent Pinchart
