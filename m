Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3FZHYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 03:24:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id CCE9240BB3
	for <linux-media@vger.kernel.org>; Wed, 26 Jun 2013 09:24:39 +0200 (CEST)
Date: Wed, 26 Jun 2013 09:24:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] #3 for 3.11 - clk / async API documentation, fixes
Message-ID: <Pine.LNX.4.64.1306260921320.8856@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

A couple of fixes on top of my clock / async work plus the so much desired 
documentation :-)

The following changes since commit 05959be7b646e8755a9339ad13e3b87849249f90:

  [media] uvc: Depend on VIDEO_V4L2 (2013-06-24 22:54:40 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.11-3

Guennadi Liakhovetski (7):
      V4L2: sh_vou: add I2C build dependency
      V4L2: fix compilation if CONFIG_I2C is undefined
      V4L2: soc-camera: fix uninitialised use compiler warning
      V4L2: add documentation for V4L2 clock helpers and asynchronous probing
      V4L2: sh_mobile_ceu_camera: remove CEU specific data from generic functions
      V4L2: soc-camera: move generic functions into a separate file
      V4L2: soc-camera: remove several CEU references in the generic scaler

 Documentation/video4linux/v4l2-framework.txt       |   73 ++++-
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/soc_camera/Kconfig          |    4 +
 drivers/media/platform/soc_camera/Makefile         |    4 +
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  399 +-------------------
 drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |  402 ++++++++++++++++++++
 drivers/media/platform/soc_camera/soc_scale_crop.h |   47 +++
 drivers/media/v4l2-core/v4l2-async.c               |    4 +
 include/media/sh_mobile_ceu.h                      |    2 +-
 include/media/soc_camera.h                         |    2 +-
 11 files changed, 549 insertions(+), 392 deletions(-)
 create mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.c
 create mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.h

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
