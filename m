Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:50038 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1BUK2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 05:28:25 -0500
Date: Mon, 21 Feb 2011 11:28:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera for 2.6.39
Message-ID: <Pine.LNX.4.64.1102211126510.26977@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

Here's the first soc-camera pull requestfor 2.6.39.

The following changes since commit 79333d1d062976f63eca420b67e1a5fc8f2b86ae:

  Add linux-next specific files for 20110202 (2011-02-02 15:28:30 +1100)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.39

Alberto Panizzo (2):
      V4L: soc_mediabus: add a method to obtain the number of samples per pixel
      V4L: mx3_camera: fix capture issues for non 8-bit per pixel formats

Anatolij Gustschin (2):
      V4L: soc-camera: start stream after queueing the buffers
      V4L: mx3_camera: correct 'sizeimage' value reporting

Andrew Chew (1):
      V4L: Initial submit of OV9740 driver.

Guennadi Liakhovetski (7):
      V4L: omap1_camera: join split format lines
      V4L: add missing EXPORT_SYMBOL* statements to vb2
      V4L: soc-camera: extend to also support videobuf2
      V4L: soc-camera: add helper functions for videobuf queue handling
      V4L: sh_mobile_ceu_camera: convert to videobuf2
      V4L: mx3_camera: convert to videobuf2
      V4l: sh_mobile_ceu_camera: fix cropping offset calculation

Mathias Krause (1):
      V4L: omap1_camera: fix use after free

Qing Xu (2):
      V4L: add enum_mbus_fsizes video operation
      V4L: soc-camera: add enum-frame-size ioctl

 drivers/media/video/Kconfig                |    9 +-
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/mx3_camera.c           |  415 ++++++------
 drivers/media/video/omap1_camera.c         |   66 +-
 drivers/media/video/ov9740.c               | 1009 ++++++++++++++++++++++++++++
 drivers/media/video/sh_mobile_ceu_camera.c |  276 ++++-----
 drivers/media/video/soc_camera.c           |  131 +++-
 drivers/media/video/soc_mediabus.c         |   14 +
 drivers/media/video/videobuf2-memops.c     |    3 +
 include/media/soc_camera.h                 |   22 +-
 include/media/soc_mediabus.h               |    1 +
 include/media/v4l2-chip-ident.h            |    1 +
 include/media/v4l2-subdev.h                |    2 +
 13 files changed, 1517 insertions(+), 433 deletions(-)
 create mode 100644 drivers/media/video/ov9740.c

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
