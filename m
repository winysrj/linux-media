Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64020 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab2JaK1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 06:27:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 7A60740BDA
	for <linux-media@vger.kernel.org>; Wed, 31 Oct 2012 11:27:29 +0100 (CET)
Date: Wed, 31 Oct 2012 11:27:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera fixes for 3.7
Message-ID: <Pine.LNX.4.64.1210311124350.9048@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

The following changes since commit 08f05c49749ee655bef921d12160960a273aad47:

  Return the right error value when dup[23]() newfd argument is too large (2012-10-30 21:27:28 -0700)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.7-rc3-fixes

for you to fetch changes up to 2819734c24a35207a896373aa055f0ee57c795b0:

  mt9v022: fix the V4L2_CID_EXPOSURE control (2012-10-31 11:14:05 +0100)

----------------------------------------------------------------
Anatolij Gustschin (1):
      mt9v022: fix the V4L2_CID_EXPOSURE control

Guennadi Liakhovetski (7):
      media: sh_vou: fix const cropping related warnings
      media: sh_mobile_ceu_camera: fix const cropping related warnings
      media: pxa_camera: fix const cropping related warnings
      media: mx3_camera: fix const cropping related warnings
      media: mx2_camera: fix const cropping related warnings
      media: mx1_camera: use the default .set_crop() implementation
      media: omap1_camera: fix const cropping related warnings

Wei Yongjun (1):
      mx2_camera: fix missing unlock on error in mx2_start_streaming()

 drivers/media/i2c/soc_camera/mt9v022.c             |   11 ++++++++---
 drivers/media/platform/sh_vou.c                    |    3 ++-
 drivers/media/platform/soc_camera/mx1_camera.c     |    9 ---------
 drivers/media/platform/soc_camera/mx2_camera.c     |   13 +++++++++----
 drivers/media/platform/soc_camera/mx3_camera.c     |    5 +++--
 drivers/media/platform/soc_camera/omap1_camera.c   |    4 ++--
 drivers/media/platform/soc_camera/pxa_camera.c     |    4 ++--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   13 +++++++------
 8 files changed, 33 insertions(+), 29 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
