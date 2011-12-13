Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45581 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1LMBnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 20:43:15 -0500
Received: from lancelot.localnet (unknown [91.178.163.176])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id F1B1D35995
	for <linux-media@vger.kernel.org>; Tue, 13 Dec 2011 01:43:13 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.3] Media, OMAP3 ISP & AS3645A
Date: Tue, 13 Dec 2011 02:43:27 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112130243.28196.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit bcc072756e4467dc30e502a311b1c3adec96a0e4:

  [media] STV0900: Query DVB frontend delivery capabilities (2011-12-12 
15:04:34 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next

Clemens Ladisch (1):
      media: fix truncated entity specification

Dmitry Artamonow (1):
      omap3isp: video: Fix compilation of ispvideo.c

Laurent Pinchart (8):
      omap3isp: preview: Rename max output sizes defines
      omap3isp: ccdc: Fix crash in HS/VS interrupt handler
      omap3isp: Fix crash caused by subdevs now having a pointer to devnodes
      omap3isp: Clarify the clk_pol field in platform data
      v4l: Add over-current and indicator flash fault bits
      as3645a: Add driver for LED flash controller
      omap3isp: video: Don't WARN() on unknown pixel formats
      omap3isp: Mark next captured frame as faulty when an SBL overflow occurs

 Documentation/DocBook/media/v4l/controls.xml |   10 +
 drivers/media/media-device.c                 |    3 +-
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/as3645a.c                |  904 +++++++++++++++++++++++++
 drivers/media/video/omap3isp/isp.c           |   53 +-
 drivers/media/video/omap3isp/ispccdc.c       |   12 +-
 drivers/media/video/omap3isp/ispccdc.h       |    2 -
 drivers/media/video/omap3isp/ispccp2.c       |   20 +-
 drivers/media/video/omap3isp/ispccp2.h       |    3 +-
 drivers/media/video/omap3isp/ispcsi2.c       |   18 +-
 drivers/media/video/omap3isp/ispcsi2.h       |    2 +-
 drivers/media/video/omap3isp/isppreview.c    |   25 +-
 drivers/media/video/omap3isp/isppreview.h    |    2 -
 drivers/media/video/omap3isp/ispresizer.c    |    7 +-
 drivers/media/video/omap3isp/ispresizer.h    |    1 -
 drivers/media/video/omap3isp/ispstat.c       |    2 +-
 drivers/media/video/omap3isp/ispvideo.c      |   22 +-
 drivers/media/video/omap3isp/ispvideo.h      |    8 +-
 drivers/media/video/v4l2-dev.c               |    4 +-
 drivers/media/video/v4l2-device.c            |    4 +-
 include/linux/videodev2.h                    |    2 +
 include/media/as3645a.h                      |   71 ++
 include/media/media-entity.h                 |    2 +-
 include/media/omap3isp.h                     |    2 +-
 25 files changed, 1086 insertions(+), 101 deletions(-)
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 include/media/as3645a.h

-- 
Regards,

Laurent Pinchart
