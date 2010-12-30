Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.187]:59743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0L3TWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 14:22:47 -0500
Date: Thu, 30 Dec 2010 20:22:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera for 2.6.38
Message-ID: <Pine.LNX.4.64.1012302014420.13281@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro

Please, pull soc-camera updates for 2.6.38. Please, notice, that commit

v4l: soc-camera: fix multiple simultaneous user case

is already in 2.6.37, I pushed it now too to simplify the merge, git shall 
just recognise an identical patch, when you pull from your 2.6.37 or from 
Linus' tree next time.

The following changes since commit 75cd068e9322727a25ea9e3b91104290a920e39b:

  [media] timblogiw: fix compile warning (2010-12-30 07:53:30 -0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.38

Alberto Panizzo (2):
      V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV2640 sensor
      soc_camera: Add the ability to bind regulators to soc_camedra devices

David Cohen (2):
      ov9640: use macro to request OmniVision OV9640 sensor private data
      ov9640: fix OmniVision OV9640 sensor driver's priv data retrieving

Guennadi Liakhovetski (3):
      v4l: ov772x: simplify pointer dereference
      v4l: soc-camera: fix multiple simultaneous user case
      v4l: soc-camera: switch to .unlocked_ioctl

 drivers/media/video/Kconfig                |    6 +
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/mx1_camera.c           |    7 +-
 drivers/media/video/mx2_camera.c           |    3 +-
 drivers/media/video/mx3_camera.c           |    2 +-
 drivers/media/video/omap1_camera.c         |    4 +-
 drivers/media/video/ov2640.c               | 1205 ++++++++++++++++++++++++++++
 drivers/media/video/ov772x.c               |   17 +-
 drivers/media/video/ov9640.c               |   19 +-
 drivers/media/video/pxa_camera.c           |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 drivers/media/video/soc_camera.c           |  137 ++--
 include/media/soc_camera.h                 |    5 +
 include/media/v4l2-chip-ident.h            |    1 +
 14 files changed, 1320 insertions(+), 91 deletions(-)
 create mode 100644 drivers/media/video/ov2640.c

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
