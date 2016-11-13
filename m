Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33546 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934338AbcKMULB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 15:11:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Alius <sakari.ailus@iki.fi>
Subject: [GIT PULL FOR v4.10] OMAP3 ISP fixes
Date: Sun, 13 Nov 2016 22:11:05 +0200
Message-ID: <2113569.4mYIn2GS3y@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit bd676c0c04ec94bd830b9192e2c33f2c4532278d:

  [media] v4l2-flash-led-class: remove a now unused var (2016-10-24 18:51:29 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 74d96c4486293502133ac4b1d2709d1eb7859e20:

  v4l: omap3isp: Use dma_request_chan_by_mask() to request the DMA channel 
(2016-11-13 22:09:16 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: omap3isp: Fix OF node double put when parsing OF graph

Peter Ujfalusi (1):
      v4l: omap3isp: Use dma_request_chan_by_mask() to request the DMA channel

 drivers/media/platform/omap3isp/isp.c     | 19 +++++++++----------
 drivers/media/platform/omap3isp/isphist.c | 28 +++++++++++++++-------------
 2 files changed, 24 insertions(+), 23 deletions(-)

-- 
Regards,

Laurent Pinchart

