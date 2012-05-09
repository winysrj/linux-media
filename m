Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55159 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab2EIM4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 08:56:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] V4L2_CID_PIXEL_RATE support in sensor drivers
Date: Wed,  9 May 2012 14:55:56 +0200
Message-Id: <1336568159-23378-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

This patch implements support for the V4L2_CID_PIXEL_RATE control in the
mt9t001, mt9p031 and mt9m032 sensor drivers.

Recent changes to the OMAP3 ISP driver (see the media-for-3.5 branch in the
http://git.linuxtv.org/sailus/media_tree.git repository) made support for that
control mandatory for sensor drivers that are to be used with the OMAP3 ISP.

Sakari, would you like to take these patches in your tree and push them for
v3.5 ? V4L2_CID_PIXEL_RATE support for the mt9v032 driver is also still
missing, the patch you've sent to the list two months ago needs to be rebased.
Will you do that or should I do it ? I'm also wondering whether that patch
shouldn't mark the V4L2_CID_PIXEL_RATE control as volatile, calling
v4l2_s_ext_ctrls() from inside the driver looks quite hackish to me. The
alternative would be to create a 64-bit version of v4l2_ctrl_s_ctrl().

Laurent Pinchart (3):
  mt9t001: Implement V4L2_CID_PIXEL_RATE control
  mt9p031: Implement V4L2_CID_PIXEL_RATE control
  mt9m032: Implement V4L2_CID_PIXEL_RATE control

 drivers/media/video/mt9m032.c |   13 +++++++++++--
 drivers/media/video/mt9p031.c |    5 ++++-
 drivers/media/video/mt9t001.c |   13 +++++++++++--
 include/media/mt9t001.h       |    1 +
 4 files changed, 27 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart

