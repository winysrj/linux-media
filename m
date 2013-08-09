Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab3HIQC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 12:02:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id C616540BB3
	for <linux-media@vger.kernel.org>; Fri,  9 Aug 2013 18:02:54 +0200 (CEST)
Date: Fri, 9 Aug 2013 18:02:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera for 3.12 #1
Message-ID: <Pine.LNX.4.64.1308091801350.6194@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Please, push to 3.12:

The following changes since commit 20bf249c2d909c8530615c46d0f9aaa90c73498f:

  Add linux-next specific files for 20130808 (2013-08-08 16:49:48 +1000)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.12-1

Guennadi Liakhovetski (6):
      V4L2: soc-camera: fix requesting regulators in synchronous case
      V4L2: mx3_camera: convert to managed resource allocation
      V4L2: mx3_camera: print V4L2_MBUS_FMT_* codes in hexadecimal format
      V4L2: mx3_camera: add support for asynchronous subdevice registration
      V4L2: mt9t031: don't Oops if asynchronous probing is attempted
      V4L2: mt9m111: switch to asynchronous subdevice probing

Hans Verkuil (1):
      soc_camera: fix compiler warning

Vladimir Barinov (1):
      V4L2: soc_camera: Renesas R-Car VIN driver

 drivers/media/i2c/soc_camera/mt9m111.c         |   38 +-
 drivers/media/i2c/soc_camera/mt9t031.c         |    7 +-
 drivers/media/platform/soc_camera/Kconfig      |    8 +
 drivers/media/platform/soc_camera/Makefile     |    1 +
 drivers/media/platform/soc_camera/mx3_camera.c |   67 +-
 drivers/media/platform/soc_camera/rcar_vin.c   | 1486 ++++++++++++++++++++++++
 drivers/media/platform/soc_camera/soc_camera.c |   38 +-
 include/linux/platform_data/camera-mx3.h       |    4 +
 include/linux/platform_data/camera-rcar.h      |   25 +
 9 files changed, 1610 insertions(+), 64 deletions(-)
 create mode 100644 drivers/media/platform/soc_camera/rcar_vin.c
 create mode 100644 include/linux/platform_data/camera-rcar.h

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
