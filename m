Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39057 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbcGDIc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:32:27 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E17301800BF
	for <linux-media@vger.kernel.org>; Mon,  4 Jul 2016 10:32:22 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/9] Convert g/s_crop to g/s_selection
Date: Mon,  4 Jul 2016 10:32:13 +0200
Message-Id: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts g/s_crop to g/s_selection in subdev and bridge
drivers.

The first patch is an old one that I have posted before. It's unchanged,
except for dropping patches for drivers that have been removed (omap1,
mx2/3).

The others are new.

After this series only the samsung drivers still use g/s_crop.

Regards,

	Hans

Hans Verkuil (9):
  v4l2: remove g/s_crop from video ops
  bttv: convert g/s_crop to g/s_selection.
  omap_vout: convert g/s_crop to g/s_selection.
  saa7134: convert g/s_crop to g/s_selection.
  zoran: convert g/s_crop to g/s_selection.
  vpfe_capture: convert g/s_crop to g/s_selection.
  vpbe_display: convert g/s_crop to g/s_selection.
  pvrusb2: convert g/s_crop to g/s_selection.
  v4l2-subdev: rename cropcap to g_pixelaspect

 drivers/media/i2c/adv7180.c                        |  12 +-
 drivers/media/i2c/ak881x.c                         |  28 +++--
 drivers/media/i2c/soc_camera/imx074.c              |  42 +++----
 drivers/media/i2c/soc_camera/mt9m001.c             |  70 ++++++-----
 drivers/media/i2c/soc_camera/mt9m111.c             |  57 ++++-----
 drivers/media/i2c/soc_camera/mt9t031.c             |  54 +++++----
 drivers/media/i2c/soc_camera/mt9t112.c             |  60 +++++-----
 drivers/media/i2c/soc_camera/mt9v022.c             |  68 ++++++-----
 drivers/media/i2c/soc_camera/ov2640.c              |  41 +++----
 drivers/media/i2c/soc_camera/ov5642.c              |  53 +++++----
 drivers/media/i2c/soc_camera/ov6650.c              |  74 ++++++------
 drivers/media/i2c/soc_camera/ov772x.c              |  44 ++++---
 drivers/media/i2c/soc_camera/ov9640.c              |  41 +++----
 drivers/media/i2c/soc_camera/ov9740.c              |  41 +++----
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  52 +++++----
 drivers/media/i2c/soc_camera/tw9910.c              |  47 +++-----
 drivers/media/i2c/tvp5150.c                        |  81 +++++++------
 drivers/media/pci/bt8xx/bttv-driver.c              |  59 ++++++----
 drivers/media/pci/bt8xx/bttvp.h                    |   2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  39 +++++--
 drivers/media/pci/zoran/zoran_driver.c             | 113 ++++++++----------
 drivers/media/platform/davinci/vpbe_display.c      |  65 ++++++-----
 drivers/media/platform/davinci/vpfe_capture.c      |  52 ++++++---
 drivers/media/platform/omap/omap_vout.c            |  54 ++++-----
 drivers/media/platform/omap3isp/ispvideo.c         |  88 +++++++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   2 +-
 drivers/media/platform/sh_vou.c                    |  15 ++-
 drivers/media/platform/soc_camera/pxa_camera.c     |  17 ++-
 drivers/media/platform/soc_camera/rcar_vin.c       |  30 +++--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  38 +++---
 drivers/media/platform/soc_camera/soc_camera.c     | 130 ++++++---------------
 .../platform/soc_camera/soc_camera_platform.c      |  45 +++----
 drivers/media/platform/soc_camera/soc_scale_crop.c |  97 ++++++++-------
 drivers/media/platform/soc_camera/soc_scale_crop.h |   6 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |  81 ++++++++-----
 drivers/staging/media/omap4iss/iss_video.c         |  99 ++++++++++++++++
 include/media/soc_camera.h                         |   7 +-
 include/media/v4l2-subdev.h                        |  10 +-
 38 files changed, 1026 insertions(+), 888 deletions(-)

-- 
2.8.1

