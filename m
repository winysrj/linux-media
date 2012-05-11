Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab2EKIzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 04:55:55 -0400
Date: Fri, 11 May 2012 10:55:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera for 3.5
Message-ID: <Pine.LNX.4.64.1205110952190.27035@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Here go soc-camera patches for 3.5. This is mainly a series from Laurent, 
adding support for user-specified stride to soc-camera (thanks again) and 
a couple of minor improvements from myself. I'm not including the patch, 
that I recently posted:

http://patchwork.linuxtv.org/patch/11116/

in this pull request, since it is not soc-camera specific. Please, either 
apply it yourself after this pull, or feel free to ask me to push it via 
my tree.

The patch for marvell-ccic is also not for soc-camera, but I've got an ack 
from Jonathan, so, it should be ok.

The following changes since commit 121b3ddbe4ad17df77cb7284239be0a63d9a66bd:

  [media] media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer (2012-05-08 14:35:14 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.5

Guennadi Liakhovetski (5):
      V4L: soc-camera: (cosmetic) use a more explicit name for a host handler
      V4L: mx2-camera: avoid overflowing 32-bits
      V4L: soc-camera: switch to using the existing .enum_framesizes()
      V4L: sh_mobile_ceu_camera: don't fail TRY_FMT
      V4L: marvell-ccic: (cosmetic) remove redundant variable assignment

Kuninori Morimoto (1):
      V4L2: sh_mobile_ceu: manage lower 8bit bus

Laurent Pinchart (10):
      mx2_camera: Fix sizeimage computation in try_fmt()
      soc_camera: Use soc_camera_device::sizeimage to compute buffer sizes
      soc_camera: Use soc_camera_device::bytesperline to compute line sizes
      soc-camera: Add plane layout information to struct soc_mbus_pixelfmt
      soc-camera: Fix bytes per line computation for planar formats
      soc-camera: Add soc_mbus_image_size
      soc-camera: Honor user-requested bytesperline and sizeimage
      mx2_camera: Use soc_mbus_image_size() instead of manual computation
      soc-camera: Support user-configurable line stride
      sh_mobile_ceu_camera: Support user-configurable line stride

Masahiro Nakai (1):
      V4L2: mt9t112: fixup JPEG initialization workaround

 drivers/media/video/atmel-isi.c              |   18 +----
 drivers/media/video/marvell-ccic/mcam-core.c |    1 -
 drivers/media/video/mt9t112.c                |    1 +
 drivers/media/video/mx1_camera.c             |   14 +----
 drivers/media/video/mx2_camera.c             |   26 +++----
 drivers/media/video/mx3_camera.c             |   41 +++++++-----
 drivers/media/video/omap1_camera.c           |   22 +++----
 drivers/media/video/pxa_camera.c             |   15 +----
 drivers/media/video/sh_mobile_ceu_camera.c   |   92 +++++++++++++++-----------
 drivers/media/video/soc_camera.c             |   51 ++++++++-------
 drivers/media/video/soc_mediabus.c           |   54 +++++++++++++++
 include/media/sh_mobile_ceu.h                |    1 +
 include/media/soc_camera.h                   |    6 ++-
 include/media/soc_mediabus.h                 |   21 ++++++
 14 files changed, 214 insertions(+), 149 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
