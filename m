Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58933 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab3DHPGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:06:08 -0400
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
Subject: [PATCH v8 0/7] V4L2 clock and async patches and soc-camera example
Date: Mon,  8 Apr 2013 17:05:31 +0200
Message-Id: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mostly just a re-spin of v7 with minor modifications.

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
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  134 +++--
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  163 +++--
 drivers/media/platform/soc_camera/soc_camera.c     |  666 ++++++++++++++++----
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/v4l2-core/Makefile                   |    3 +-
 drivers/media/v4l2-core/v4l2-async.c               |  262 ++++++++
 drivers/media/v4l2-core/v4l2-clk.c                 |  177 ++++++
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/sh_mobile_csi2.h                     |    2 +-
 include/media/soc_camera.h                         |   36 +-
 include/media/v4l2-async.h                         |  104 +++
 include/media/v4l2-clk.h                           |   54 ++
 29 files changed, 1675 insertions(+), 304 deletions(-)
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
