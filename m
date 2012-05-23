Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51775 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596Ab2EWP1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 11:27:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/8] Miscellaneous soc-camera patches
Date: Wed, 23 May 2012 17:27:27 +0200
Message-Id: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Here's a set of miscellaneous soc-camera patches that I wrote as part of an
effort to improve the interoperability between soc-camera clients and non
soc-camera hosts (namely the ov772x and the OMAP3 ISP in this case).

All patches have been compile-tested but not runtime-tested as I lack the
necessary hardware. I'd like to first validate the approach, I can then of
course fix any small (or not-so-small) issue you will point out.

Laurent Pinchart (8):
  soc-camera: Don't fail at module init time if no device is present
  soc-camera: Pass the physical device to the power operation
  ov2640: Don't access the device in the g_mbus_fmt operation
  ov772x: Don't access the device in the g_mbus_fmt operation
  tw9910: Don't access the device in the g_mbus_fmt operation
  soc_camera: Don't call .s_power() during probe
  soc-camera: Add and use soc_camera_power_[on|off]() helper functions
  soc-camera: Push probe-time power management to drivers

 drivers/media/video/imx074.c              |   33 +++++++-
 drivers/media/video/mt9m001.c             |   29 +++++++-
 drivers/media/video/mt9m111.c             |  116 ++++++++++++++++++-----------
 drivers/media/video/mt9t031.c             |   29 +++++--
 drivers/media/video/mt9t112.c             |   24 ++++++-
 drivers/media/video/mt9v022.c             |   17 ++++
 drivers/media/video/ov2640.c              |   28 +++++--
 drivers/media/video/ov5642.c              |   32 ++++++--
 drivers/media/video/ov6650.c              |   31 ++++++--
 drivers/media/video/ov772x.c              |   34 +++++++--
 drivers/media/video/ov9640.c              |   30 ++++++-
 drivers/media/video/ov9740.c              |   38 +++++++---
 drivers/media/video/rj54n1cb0c.c          |   30 ++++++-
 drivers/media/video/sh_mobile_csi2.c      |   10 ++-
 drivers/media/video/soc_camera.c          |  107 ++++++++++++---------------
 drivers/media/video/soc_camera_platform.c |   15 ++++-
 drivers/media/video/tw9910.c              |   32 ++++++--
 include/media/soc_camera.h                |    2 +
 18 files changed, 459 insertions(+), 178 deletions(-)

-- 
Regards,

Laurent Pinchart

