Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab2LZRt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:49:27 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 0/6] V4L2 asynchronous probing + soc-camera example
Date: Wed, 26 Dec 2012 18:49:05 +0100
Message-Id: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is v3 (roughly) of the V4L2 asynchronous probing patch plus an 
example soc-camera framework and 1 host, 1 sensor and 1 board conversion 
patch set. Logically, this is based on top of my recent patch series

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/58524

and the last version of the v4l2-clock patch. If desired, a git branch can 
be provided.

Thanks
Guennadi

Guennadi Liakhovetski (6):
  media: V4L2: support asynchronous subdevice registration
  media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
  soc-camera: add V4L2-async support
  sh_mobile_ceu_camera: add asynchronous subdevice probing support
  imx074: support asynchronous probing
  ARM: shmobile: convert ap4evb to asynchronously register camera
    subdevices

 arch/arm/mach-shmobile/board-ap4evb.c              |  103 ++--
 arch/arm/mach-shmobile/clock-sh7372.c              |    1 +
 drivers/media/i2c/soc_camera/imx074.c              |   35 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   17 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   20 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   19 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   19 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   17 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   19 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   20 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   17 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   15 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   17 +-
 drivers/media/i2c/soc_camera/ov9640.h              |    1 +
 drivers/media/i2c/soc_camera/ov9740.c              |   18 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   17 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   18 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  135 +++-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  164 +++--
 drivers/media/platform/soc_camera/soc_camera.c     |  681 ++++++++++++++++----
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/v4l2-core/Makefile                   |    3 +-
 drivers/media/v4l2-core/v4l2-async.c               |  284 ++++++++
 drivers/media/v4l2-core/v4l2-device.c              |    2 +
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/sh_mobile_csi2.h                     |    2 +-
 include/media/soc_camera.h                         |   35 +-
 include/media/v4l2-async.h                         |  113 ++++
 28 files changed, 1489 insertions(+), 307 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-async.c
 create mode 100644 include/media/v4l2-async.h

-- 
1.7.2.5

