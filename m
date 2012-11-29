Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K2LXW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 06:23:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 823B840B98
	for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 12:23:19 +0100 (CET)
Date: Thu, 29 Nov 2012 12:23:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera for 3.8 second lot
Message-ID: <Pine.LNX.4.64.1211291219220.11210@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Most these patches have been posted a while ago, they include the sh_veu 
mem2mem driver - unchanged from the previous pull request, but this time 
I'm also including the mem2mem core patch, that's needed to make sh_veu 
compile without warnings. Also including an update to MAINTAINERS and to 
soc-camera documentation.

The following changes since commit d8658bca2e5696df2b6c69bc5538f8fe54e4a01e:

  [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check (2012-11-28 10:54:46 -0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.8-set_2

Guennadi Liakhovetski (9):
      media: mem2mem: make reference to struct m2m_ops in the core const
      media: add a VEU MEM2MEM format conversion and scaling driver
      media: soc-camera: use managed devm_regulator_bulk_get()
      media: sh-mobile-ceu-camera: runtime PM suspending doesn't have to be synchronous
      media: soc-camera: update documentation
      media: soc-camera: remove superfluous JPEG checking
      media: sh_mobile_csi2: use managed memory and resource allocations
      media: sh_mobile_ceu_camera: use managed memory and resource allocations
      MAINTAINERS: add entries for sh_veu and sh_vou V4L2 drivers

Javier Martin (1):
      media: mx2_camera: Add image size HW limits.

 Documentation/video4linux/soc-camera.txt           |  146 ++--
 MAINTAINERS                                        |   14 +
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/sh_veu.c                    | 1264 ++++++++++++++++++++
 drivers/media/platform/soc_camera/mx2_camera.c     |    8 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   36 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   23 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    7 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |    6 -
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    4 +-
 include/media/v4l2-mem2mem.h                       |    2 +-
 12 files changed, 1390 insertions(+), 131 deletions(-)
 create mode 100644 drivers/media/platform/sh_veu.c

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
