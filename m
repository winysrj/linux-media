Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3FKJ1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 05:27:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v10 00/21] V4L2 clock and asynchronous probing
Date: Tue, 11 Jun 2013 10:23:27 +0200
Message-Id: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

3.11 is approaching... Here comes v10 of the V4L2 clock helper and 
asynchronous probing patch set. In this series I included 3 groups of 
patches, that actually aren't that strongly related.

1. patches 1-11 split soc-camera subdevice linking procedure into two 
steps: (a) turning on the master clock and (b) actually linking a (client) 
subdevice to a host. This is necessary to keep the V4L2 clock API free 
from any device context.
2. patches 12-13 are adding device tree support to the 
sh_mobile_ceu_camera soc-camera host driver. They aren't really related, 
but following V4L2 async support for this driver has been developed on top 
of this code, so, I would prefer to keep the order.
3. patches 14-21 are the actual clock and async probing code. They contain 
core support and an example conversion of the soc-camera framework and one 
its platform (an AP4EVB board) to the new APIs.

Thanks for all the reviews and suggestions.

Guennadi Liakhovetski (21):
  soc-camera: move common code to soc_camera.c
  soc-camera: add host clock callbacks to start and stop the master
    clock
  pxa-camera: move interface activation and deactivation to clock
    callbacks
  omap1-camera: move interface activation and deactivation to clock
    callbacks
  atmel-isi: move interface activation and deactivation to clock
    callbacks
  mx3-camera: move interface activation and deactivation to clock
    callbacks
  mx2-camera: move interface activation and deactivation to clock
    callbacks
  mx1-camera: move interface activation and deactivation to clock
    callbacks
  sh-mobile-ceu-camera: move interface activation and deactivation to
    clock callbacks
  soc-camera: make .clock_{start,stop} compulsory, .add / .remove
    optional
  soc-camera: don't attach the client to the host during probing
  sh-mobile-ceu-camera: add primitive OF support
  sh-mobile-ceu-driver: support max width and height in DT
  V4L2: add temporary clock helpers
  V4L2: add a device pointer to struct v4l2_subdev
  V4L2: support asynchronous subdevice registration
  soc-camera: switch I2C subdevice drivers to use v4l2-clk
  soc-camera: add V4L2-async support
  sh_mobile_ceu_camera: add asynchronous subdevice probing support
  imx074: support asynchronous probing
  ARM: shmobile: convert ap4evb to asynchronously register camera
    subdevices

 .../devicetree/bindings/media/sh_mobile_ceu.txt    |   18 +
 arch/arm/mach-shmobile/board-ap4evb.c              |  103 ++--
 arch/arm/mach-shmobile/clock-sh7372.c              |    1 +
 drivers/media/i2c/soc_camera/imx074.c              |   32 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   17 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   20 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   19 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   25 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   17 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   19 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   20 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   17 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   15 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   17 +-
 drivers/media/i2c/soc_camera/ov9640.h              |    1 +
 drivers/media/i2c/soc_camera/ov9740.c              |   18 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   17 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   24 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   38 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |   48 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |   41 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   44 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |   41 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |   46 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  243 +++++--
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  153 +++--
 drivers/media/platform/soc_camera/soc_camera.c     |  707 +++++++++++++++++---
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/v4l2-core/Makefile                   |    3 +-
 drivers/media/v4l2-core/v4l2-async.c               |  280 ++++++++
 drivers/media/v4l2-core/v4l2-clk.c                 |  242 +++++++
 drivers/media/v4l2-core/v4l2-common.c              |    2 +
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/sh_mobile_csi2.h                     |    2 +-
 include/media/soc_camera.h                         |   39 +-
 include/media/v4l2-async.h                         |  105 +++
 include/media/v4l2-clk.h                           |   54 ++
 include/media/v4l2-subdev.h                        |   10 +
 38 files changed, 2035 insertions(+), 467 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
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
