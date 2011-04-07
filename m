Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:53917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab1DGQVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 12:21:17 -0400
Date: Thu, 7 Apr 2011 18:21:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] V4L and soc-camera fixes for 2.6.39
Message-ID: <Pine.LNX.4.64.1104071820140.28236@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

The following changes since commit 6221f222c0ebf1acdf7abcf927178f40e1a65e2a:

  Linux 2.6.39-rc2 (2011-04-05 18:30:43 -0700)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git 2.6.39-rc1-fixes

Guennadi Liakhovetski (8):
      V4L: fix videobuf2 to correctly identify allocation failures
      V4L: fix an error message
      V4L: fix a macro definition
      V4L: soc-camera: fix a recent multi-camera breakage on sh-mobile
      V4L: imx074: return a meaningful error code instead of -1
      V4L: soc-camera: don't dereference I2C client after it has been removed
      V4L: sh_mobile_csi2: fix module reloading
      V4L: sh_mobile_ceu_camera: fix typos in documentation

 Documentation/video4linux/sh_mobile_ceu_camera.txt |    6 +++---
 drivers/media/video/imx074.c                       |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   10 +++++-----
 drivers/media/video/sh_mobile_csi2.c               |   11 +++++++++--
 drivers/media/video/soc_camera.c                   |    7 +++++--
 drivers/media/video/videobuf2-core.c               |    2 +-
 drivers/media/video/videobuf2-dma-contig.c         |    2 +-
 include/media/v4l2-device.h                        |    2 +-
 8 files changed, 26 insertions(+), 16 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
