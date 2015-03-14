Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbCNPAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 11:00:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [GIT PULL FOR v4.1] OMAP3 ISP fixes
Date: Sat, 14 Mar 2015 17:00:58 +0200
Message-ID: <3472666.1mv3SyG49o@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 
13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to ba779f69a9af4e44117f6197d3f18812a5748631:

  media: omap3isp: hist: Move histogram DMA to DMA engine (2015-03-14 16:58:33 
+0200)

----------------------------------------------------------------
Lad, Prabhakar (1):
      media: omap3isp: video: drop setting of vb2 buffer state to 
VB2_BUF_STATE_ACTIVE

Laurent Pinchart (3):
      media: omap3isp: video: Don't call vb2 mmap with queue lock held
      media: omap3isp: video: Use v4l2_get_timestamp()
      media: omap3isp: hist: Move histogram DMA to DMA engine

 drivers/media/platform/omap3isp/isph3a_aewb.c |   1 -
 drivers/media/platform/omap3isp/isph3a_af.c   |   1 -
 drivers/media/platform/omap3isp/isphist.c     | 128 +++++++++++++++----------
 drivers/media/platform/omap3isp/ispstat.c     |   2 +-
 drivers/media/platform/omap3isp/ispstat.h     |   5 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  14 +---
 6 files changed, 82 insertions(+), 69 deletions(-)

-- 
Regards,

Laurent Pinchart

