Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1GURvU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2011 13:51:20 -0400
Date: Thu, 21 Jul 2011 19:51:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL v2] V4L, soc-camera: second pull for 3.1
In-Reply-To: <Pine.LNX.4.64.1107171905040.13485@axis700.grange>
Message-ID: <Pine.LNX.4.64.1107211948590.24569@axis700.grange>
References: <Pine.LNX.4.64.1107171905040.13485@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Hopefully, no more hick-ups this time:

The following changes since commit bec969c908bb22931fd5ab8ecdf99de8702a6a31:

  [media] v4l: s5p-tv: add TV Mixer driver for Samsung S5P platform (2011-07-14 13:09:48 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.1

Bastian Hecht (1):
      V4L: initial driver for ov5642 CMOS sensor

Guennadi Liakhovetski (8):
      V4L: pxa-camera: switch to using standard PM hooks
      V4L: soc-camera: remove now unused soc-camera specific PM hooks
      V4L: soc-camera: group struct field initialisations together
      V4L: add media bus configuration subdev operations
      V4L: sh_mobile_csi2: switch away from using the soc-camera bus notifier
      V4L: soc-camera: un-export the soc-camera bus
      V4L: soc-camera: remove soc-camera bus and devices on it
      V4L: sh_mobile_ceu_camera: fix Oops when USERPTR mapping fails

Michael Grzeschik (2):
      V4L: mt9m111: fix missing return value check mt9m111_reg_clear
      V4L: mt9m111: rewrite set_pixfmt

 arch/arm/mach-shmobile/board-ap4evb.c      |   12 +-
 arch/arm/mach-shmobile/board-mackerel.c    |   13 +-
 arch/sh/boards/mach-ap325rxa/setup.c       |   15 +-
 drivers/media/video/Kconfig                |    6 +
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/atmel-isi.c            |   64 +-
 drivers/media/video/mt9m001.c              |   14 +-
 drivers/media/video/mt9m111.c              |  189 ++----
 drivers/media/video/mt9t031.c              |    3 +-
 drivers/media/video/mt9t112.c              |   10 +-
 drivers/media/video/mt9v022.c              |   10 +-
 drivers/media/video/mx1_camera.c           |   42 +-
 drivers/media/video/mx2_camera.c           |   46 +-
 drivers/media/video/mx3_camera.c           |   56 +-
 drivers/media/video/omap1_camera.c         |   52 +-
 drivers/media/video/ov2640.c               |   13 +-
 drivers/media/video/ov5642.c               | 1011 ++++++++++++++++++++++++++++
 drivers/media/video/ov772x.c               |   10 +-
 drivers/media/video/ov9640.c               |   13 +-
 drivers/media/video/ov9740.c               |   13 +-
 drivers/media/video/pxa_camera.c           |   66 +-
 drivers/media/video/rj54n1cb0c.c           |    7 +-
 drivers/media/video/sh_mobile_ceu_camera.c |  199 ++++--
 drivers/media/video/sh_mobile_csi2.c       |  135 ++--
 drivers/media/video/soc_camera.c           |  264 +++-----
 drivers/media/video/soc_camera_platform.c  |   10 +-
 drivers/media/video/tw9910.c               |   10 +-
 include/media/sh_mobile_ceu.h              |   10 +-
 include/media/sh_mobile_csi2.h             |    8 +-
 include/media/soc_camera.h                 |   29 +-
 include/media/soc_camera_platform.h        |   15 +-
 include/media/v4l2-chip-ident.h            |    1 +
 include/media/v4l2-mediabus.h              |   63 ++
 include/media/v4l2-subdev.h                |   10 +
 34 files changed, 1703 insertions(+), 717 deletions(-)
 create mode 100644 drivers/media/video/ov5642.c

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
