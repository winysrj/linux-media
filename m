Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37273 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2FZNpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 09:45:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 0/6] YUV input support for the OMAP3 ISP
Date: Tue, 26 Jun 2012 15:45:33 +0200
Message-Id: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are (long awaited) patches that implement support for YUV at the OMAP3 ISP
input.

Only progressive YUV in non-BT.656 mode is currently supported. The code has
been tested with an OV7725 sensor (I will push modifications to the ov772x
driver required to make it work with the OMAP3 ISP to mainline, but that
requires infrastructure work and will thus still take some time).

I've pushed the patches to the omap3isp-omap3isp-next branch of my git tree at
http://git.linuxtv.org/pinchartl/media.git, and rebased the
omap3isp-sensors-next and omap3isp-sensors-board branches.

My plan is to include this in the OMAP3 ISP v3.6 pull request (if no issue
found during review prevents this).

Ivaylo Petrov (1):
  omap3isp: csi2: Add V4L2_MBUS_FMT_YUYV8_2X8 support

Laurent Pinchart (5):
  omap3isp: video: Split format info bpp field into width and bpp
  omap3isp: video: Add YUYV8_2X8 and UYVY8_2X8 support
  omap3isp: ccdc: Remove support for interlaced data and master HS/VS
    mode
  omap3isp: ccdc: Remove ispccdc_syncif structure
  omap3isp: ccdc: Add YUV input formats support

 drivers/media/video/omap3isp/isp.c      |    4 +-
 drivers/media/video/omap3isp/isp.h      |    2 +-
 drivers/media/video/omap3isp/ispccdc.c  |  230 +++++++++++++++++++------------
 drivers/media/video/omap3isp/ispccdc.h  |   37 -----
 drivers/media/video/omap3isp/ispcsi2.c  |   27 ++++-
 drivers/media/video/omap3isp/ispvideo.c |   55 +++++---
 drivers/media/video/omap3isp/ispvideo.h |    6 +-
 include/media/omap3isp.h                |   14 +--
 8 files changed, 207 insertions(+), 168 deletions(-)

-- 
Regards,

Laurent Pinchart

