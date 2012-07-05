Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60429 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2GEUio (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 16:38:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 0/9] Miscellaneous soc-camera patches
Date: Thu,  5 Jul 2012 22:38:39 +0200
Message-Id: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's the second version of the miscellaneous soc-camera patches that try to
improve the interoperability between soc-camera clients and non soc-camera
hosts.

As with the previous version, all patches have been compile-tested but not
runtime-tested as I lack the necessary hardware.

Changes compared to v1:

- Set priv->cfmt_code in ov2640 driver (3/9)
- Split the soc-camera power off sequence change to its own patch (7/9)
- Added an inline soc_camera_set_power() function (8/9)
- Make sure the mt9m111 gets powered off completely if power on fails (8/9)
- Simplify the s_power implementation in the ov5642 driver (8/9)
- Don't modify power handling in the sh_mobile_csi2 driver
- Don't pass a NULL device pointer to soc_camera_power_on() at probe time (8/9)
- Fix physical device retrieval in soc_camera_platform_s_power() (8/9)
- Don't loose return codes in mt9m111_video_probe() (9/9)
- Remove unneeded enable/idle/disable calls in mt9p031 probe (9/9)

Laurent Pinchart (9):
  soc-camera: Don't fail at module init time if no device is present
  soc-camera: Pass the physical device to the power operation
  ov2640: Don't access the device in the g_mbus_fmt operation
  ov772x: Don't access the device in the g_mbus_fmt operation
  tw9910: Don't access the device in the g_mbus_fmt operation
  soc_camera: Don't call .s_power() during probe
  soc-camera: Continue the power off sequence if one of the steps fails
  soc-camera: Add and use soc_camera_power_[on|off]() helper functions
  soc-camera: Push probe-time power management to drivers

 drivers/media/video/imx074.c              |   30 ++++++-
 drivers/media/video/mt9m001.c             |   26 ++++++-
 drivers/media/video/mt9m111.c             |  116 ++++++++++++++++++----------
 drivers/media/video/mt9t031.c             |   48 ++++++------
 drivers/media/video/mt9t112.c             |   21 +++++-
 drivers/media/video/mt9v022.c             |   14 ++++
 drivers/media/video/ov2640.c              |   26 +++++--
 drivers/media/video/ov5642.c              |   31 ++++++--
 drivers/media/video/ov6650.c              |   28 ++++++--
 drivers/media/video/ov772x.c              |   31 ++++++--
 drivers/media/video/ov9640.c              |   27 ++++++-
 drivers/media/video/ov9740.c              |   38 +++++++---
 drivers/media/video/rj54n1cb0c.c          |   27 ++++++-
 drivers/media/video/soc_camera.c          |  101 +++++++++++--------------
 drivers/media/video/soc_camera_platform.c |   11 +++-
 drivers/media/video/tw9910.c              |   29 ++++++--
 include/media/soc_camera.h                |   10 +++
 17 files changed, 423 insertions(+), 191 deletions(-)

-- 
Regards,

Laurent Pinchart

