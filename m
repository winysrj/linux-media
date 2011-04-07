Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:57326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1DGQms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 12:42:48 -0400
Date: Thu, 7 Apr 2011 18:42:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] V4L and soc-camera fixes for 2.6.39
In-Reply-To: <Pine.LNX.4.64.1104071820140.28236@axis700.grange>
Message-ID: <Pine.LNX.4.64.1104071841040.28236@axis700.grange>
References: <Pine.LNX.4.64.1104071820140.28236@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

ehem, let's try again (forgot one more patch):

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

Uwe Kleine-König (1):
      V4L: mx3_camera: select VIDEOBUF2_DMA_CONTIG instead of VIDEOBUF_DMA_CONTIG

 Documentation/video4linux/sh_mobile_ceu_camera.txt |    6 +++---
 drivers/media/video/Kconfig                        |    2 +-
 drivers/media/video/imx074.c                       |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   10 +++++-----
 drivers/media/video/sh_mobile_csi2.c               |   11 +++++++++--
 drivers/media/video/soc_camera.c                   |    7 +++++--
 drivers/media/video/videobuf2-core.c               |    2 +-
 drivers/media/video/videobuf2-dma-contig.c         |    2 +-
 include/media/v4l2-device.h                        |    2 +-
 9 files changed, 27 insertions(+), 17 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
