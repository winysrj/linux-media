Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51212 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2EBLsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:48:07 -0400
Received: from avalon.localnet (unknown [91.178.164.248])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9254F7D11
	for <linux-media@vger.kernel.org>; Wed,  2 May 2012 13:48:06 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.5] OMAP3 ISP patches
Date: Wed, 02 May 2012 13:48:30 +0200
Message-ID: <1506938.RjvUgDDczY@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next

Laurent Pinchart (17):
      omap3isp: Prevent pipelines that contain a crashed entity from starting
      omap3isp: Fix frame number propagation
      omap3isp: preview: Skip brightness and contrast in configuration ioctl
      omap3isp: preview: Optimize parameters setup for the common case
      omap3isp: preview: Remove averager parameter update flag
      omap3isp: preview: Remove unused isptables_update structure definition
      omap3isp: preview: Merge configuration and feature bits
      omap3isp: preview: Remove update_attrs feature_bit field
      omap3isp: preview: Rename prev_params fields to match userspace API
      omap3isp: preview: Simplify configuration parameters access
      omap3isp: preview: Shorten shadow update delay
      omap3isp: preview: Rename last occurences of *_rgb_to_ycbcr to *_csc
      omap3isp: preview: Add support for greyscale input
      omap3isp: Mark probe and cleanup functions with __devinit and __devexit
      omap3isp: ccdc: Add selection support on output formatter source pad
      omap3isp: preview: Replace the crop API by the selection API
      omap3isp: resizer: Replace the crop API by the selection API

Sakari Ailus (2):
      omap3isp: Prevent crash at module unload
      omap3isp: Handle omap3isp_csi2_reset() errors

 drivers/media/video/omap3isp/isp.c        |   45 ++-
 drivers/media/video/omap3isp/isp.h        |    3 +-
 drivers/media/video/omap3isp/ispccdc.c    |  183 ++++++++-
 drivers/media/video/omap3isp/ispccdc.h    |    2 +
 drivers/media/video/omap3isp/ispccp2.c    |   23 -
 drivers/media/video/omap3isp/ispcsi2.c    |   20 +-
 drivers/media/video/omap3isp/ispcsi2.h    |    1 -
 drivers/media/video/omap3isp/ispcsiphy.c  |    4 +-
 drivers/media/video/omap3isp/isppreview.c |  633 ++++++++++++++++++-----------
 drivers/media/video/omap3isp/isppreview.h |   76 +---
 drivers/media/video/omap3isp/ispresizer.c |  138 ++++---
 drivers/media/video/omap3isp/ispvideo.c   |    4 +
 drivers/media/video/omap3isp/ispvideo.h   |    2 +
 13 files changed, 709 insertions(+), 425 deletions(-)

-- 
Regards,

Laurent Pinchart

