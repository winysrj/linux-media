Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52869 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2GRNyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 09:54:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 0/9] Miscellaneous soc-camera patches
Date: Wed, 18 Jul 2012 15:53:55 +0200
Message-Id: <1342619644-5712-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's the third version of the miscellaneous soc-camera patches that try to
improve the interoperability between soc-camera clients and non soc-camera
hosts.

As with the previous version, all patches have been compile-tested but not
runtime-tested as I lack the necessary hardware.

Changes compared to v2:

- Properly log error conditions in soc_camera_power_off() and don't return
  success if an error occurs.
- Refactor ov9740_s_power() to make the code flow more explicit.
- Power off the MT9T031 in all error paths at probe time.

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
 drivers/media/video/ov9740.c              |   47 ++++++++----
 drivers/media/video/rj54n1cb0c.c          |   27 ++++++-
 drivers/media/video/soc_camera.c          |  111 +++++++++++++--------------
 drivers/media/video/soc_camera_platform.c |   11 +++-
 drivers/media/video/tw9910.c              |   29 ++++++--
 include/media/soc_camera.h                |   10 +++
 17 files changed, 437 insertions(+), 196 deletions(-)

-- 
Regards,

Laurent Pinchart

