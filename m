Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36493 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab1HaPOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 11:14:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, gary@mlbassoc.com
Subject: [HACK 0/3] YUYV input support for the OMAP3 ISP
Date: Wed, 31 Aug 2011 17:14:45 +0200
Message-Id: <1314803688-29566-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

As there seems to be a recent interest in connecting a YUYV source (namely a
tvp5140) to the OMAP3 ISP input, here are three preliminary patches that add
YUYV support to the OMAP3 ISP CCDC.

The patches have been compile-tested only as I lack hardware to test them.
They're missing bridge configuration for YUYV8_2X8 in non-ITU mode (I'm not
sure if the driver should configure the bridge automatically in that case or
leave that to platform data). Pipeline validation will also need to be fixed
if the driver configures the bridge automatically.

I hope this will be useful as a starting point. Comments, testing and
additional patches will be appreciated.

Laurent Pinchart (3):
  omap3isp: video: Split format info bpp field into width and bpp
  omap3isp: ccdc: Remove ispccdc_syncif structure
  omap3isp: ccdc: Add YUV input formats support

 drivers/media/video/omap3isp/ispccdc.c  |   67 +++++++++++++++++++++----------
 drivers/media/video/omap3isp/ispccdc.h  |   18 --------
 drivers/media/video/omap3isp/ispvideo.c |   44 +++++++++++---------
 drivers/media/video/omap3isp/ispvideo.h |    4 +-
 include/media/omap3isp.h                |    6 +++
 5 files changed, 80 insertions(+), 59 deletions(-)

-- 
Regards,

Laurent Pinchart

