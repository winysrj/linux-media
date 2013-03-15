Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662Ab3COV2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 17:28:20 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v6 0/7] V4L2 clock and async patches and soc-camera example
Date: Fri, 15 Mar 2013 22:27:46 +0100
Message-Id: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update of V4l2 clock and asynchronous probing patches. Various review 
comments are addressed, as described in individual patches.

Guennadi Liakhovetski (7):
  media: V4L2: add temporary clock helpers
  media: V4L2: support asynchronous subdevice registration
  media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
  soc-camera: add V4L2-async support
  sh_mobile_ceu_camera: add asynchronous subdevice probing support
  imx074: support asynchronous probing
  ARM: shmobile: convert ap4evb to asynchronously register camera
    subdevices

 arch/arm/mach-shmobile/board-ap4evb.c              |  103 ++--
 arch/arm/mach-shmobile/clock-sh7372.c              |    1 +
 drivers/media/i2c/soc_camera/imx074.c              |   36 +-
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
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  136 +++--
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  162 +++---
 drivers/media/platform/soc_camera/soc_camera.c     |  642 ++++++++++++++++----
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/v4l2-core/Makefile                   |    3 +-
 drivers/media/v4l2-core/v4l2-async.c               |  272 +++++++++
 drivers/media/v4l2-core/v4l2-clk.c                 |  184 ++++++
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/sh_mobile_csi2.h                     |    2 +-
 include/media/soc_camera.h                         |   36 +-
 include/media/v4l2-async.h                         |  105 ++++
 include/media/v4l2-clk.h                           |   55 ++
 29 files changed, 1666 insertions(+), 309 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-async.c
 create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
 create mode 100644 include/media/v4l2-async.h
 create mode 100644 include/media/v4l2-clk.h

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
