Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2LZRgC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:36:02 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id DE4B740BDE
	for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 18:35:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Tnuta-0001cH-Mt
	for linux-media@vger.kernel.org; Wed, 26 Dec 2012 18:35:58 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] soc-camera: improvements and fixes, prepare for async
Date: Wed, 26 Dec 2012 18:35:52 +0100
Message-Id: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix several issues in soc-camera drivers, preparing a 
cleaner base for v4l2-async patches.

Thanks
Guennadi

Guennadi Liakhovetski (6):
  media: sh_mobile_ceu_camera: fix CSI2 format negotiation
  media: soc-camera: properly fix camera probing races
  soc-camera: remove struct soc_camera_device::video_lock
  media: soc-camera: split struct soc_camera_link into host and
    subdevice parts
  media: soc-camera: use devm_kzalloc in subdevice drivers
  soc-camera: fix repeated regulator requesting

 drivers/media/i2c/soc_camera/imx074.c              |   27 +--
 drivers/media/i2c/soc_camera/mt9m001.c             |   52 +++----
 drivers/media/i2c/soc_camera/mt9m111.c             |   36 ++---
 drivers/media/i2c/soc_camera/mt9t031.c             |   36 ++---
 drivers/media/i2c/soc_camera/mt9t112.c             |   27 ++--
 drivers/media/i2c/soc_camera/mt9v022.c             |   44 +++---
 drivers/media/i2c/soc_camera/ov2640.c              |   29 ++--
 drivers/media/i2c/soc_camera/ov5642.c              |   31 ++---
 drivers/media/i2c/soc_camera/ov6650.c              |   30 ++--
 drivers/media/i2c/soc_camera/ov772x.c              |   36 ++---
 drivers/media/i2c/soc_camera/ov9640.c              |   27 ++--
 drivers/media/i2c/soc_camera/ov9740.c              |   29 ++--
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   39 ++---
 drivers/media/i2c/soc_camera/tw9910.c              |   30 ++---
 drivers/media/platform/soc_camera/atmel-isi.c      |    4 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |    3 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    1 -
 drivers/media/platform/soc_camera/mx3_camera.c     |    4 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |    4 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |    6 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    6 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  167 +++++++++++---------
 .../platform/soc_camera/soc_camera_platform.c      |    6 +-
 include/media/soc_camera.h                         |   98 +++++++++---
 include/media/soc_camera_platform.h                |   10 +-
 25 files changed, 379 insertions(+), 403 deletions(-)

-- 
1.7.2.5

