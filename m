Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:50316 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752277Ab0JHHAd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 03:00:33 -0400
Date: Fri, 8 Oct 2010 09:00:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PULL] soc-camera: welcome a new host: OMAP1 and a couple of new
 sensor drivers
Message-ID: <Pine.LNX.4.64.1010080848550.21992@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

So, as promised, here goes part 2 of 2.6.37 patches for soc-camera and 
related. There's also going to be one issue with this one to take care of: 
the last patch will conflict with Laurent's pad-level ops patches, which 
also move mediabus pixel codes around. But since Laurent's patches are 
still at the RFC stage, AFAICS, they'll have to be extended slightly:)

The following changes since commit 81d64d12e11a3cca995e6c752e4bd2898959ed0a:

  V4L/DVB: cx231xx: remove some unused functions (2010-10-07 21:05:52 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.37

Guennadi Liakhovetski (3):
      V4L: add IMX074 sensor chip ID
      V4L: add an IMX074 sensor soc-camera / v4l2-subdev driver
      V4L: sh_mobile_ceu_camera: use default .get_parm() and .set_parm() operations

Janusz Krzysztofik (3):
      SoC Camera: add driver for OMAP1 camera interface
      SoC Camera: add driver for OV6650 sensor
      SoC Camera: add support for g_parm / s_parm operations

Michael Grzeschik (1):
      mt9m111: changed MIN_DARK_COLS to MT9M131 spec count

Sascha Hauer (1):
      v4l2-mediabus: Add pixelcodes for BGR565 formats

 drivers/media/video/Kconfig                |   20 +
 drivers/media/video/Makefile               |    3 +
 drivers/media/video/imx074.c               |  508 +++++++++
 drivers/media/video/mt9m111.c              |    2 +-
 drivers/media/video/omap1_camera.c         | 1702 ++++++++++++++++++++++++++++
 drivers/media/video/ov6650.c               | 1225 ++++++++++++++++++++
 drivers/media/video/sh_mobile_ceu_camera.c |   18 -
 drivers/media/video/soc_camera.c           |   18 +
 include/media/omap1_camera.h               |   35 +
 include/media/v4l2-chip-ident.h            |    4 +
 include/media/v4l2-mediabus.h              |    2 +
 11 files changed, 3518 insertions(+), 19 deletions(-)
 create mode 100644 drivers/media/video/imx074.c
 create mode 100644 drivers/media/video/omap1_camera.c
 create mode 100644 drivers/media/video/ov6650.c
 create mode 100644 include/media/omap1_camera.h

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
