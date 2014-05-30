Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:52153 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933923AbaE3Qss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 12:48:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 3C64640BD9
	for <linux-media@vger.kernel.org>; Fri, 30 May 2014 18:48:46 +0200 (CEST)
Date: Fri, 30 May 2014 18:48:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.16 v2] soc-camera for 3.16: one driver removal, a fix
 and more
Message-ID: <Pine.LNX.4.64.1405301847120.14311@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This time based on your media-next tree. Also using git 1.9.3 instead of 
2.0.0 solved my pull-request problem.

The following changes since commit 656111f4b9cbc5a9b86cc2d6ac54dea0855209f0:

  Merge branch 'topic/omap3isp' into to_next (2014-05-25 18:38:38 -0300)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.16-1

for you to fetch changes up to 3ad8677298049933a1a76648645bd50e295ee0e5:

  V4L2: soc_camera: Add run-time dependencies to sh_mobile drivers (2014-05-30 18:45:07 +0200)

----------------------------------------------------------------
Alexander Shiyan (2):
      media: mx1_camera: Remove driver
      media: mx2_camera: Change Kconfig dependency

Ben Dooks (1):
      rcar_vin: copy flags from pdata

Guennadi Liakhovetski (1):
      V4L: soc-camera: explicitly free allocated managed memory on error

Jean Delvare (2):
      V4L2: soc_camera: add run-time dependencies to R-Car VIN driver
      V4L2: soc_camera: Add run-time dependencies to sh_mobile drivers

 drivers/media/platform/soc_camera/Kconfig      |  18 +-
 drivers/media/platform/soc_camera/Makefile     |   1 -
 drivers/media/platform/soc_camera/mx1_camera.c | 866 -------------------------
 drivers/media/platform/soc_camera/rcar_vin.c   |  12 +-
 drivers/media/platform/soc_camera/soc_camera.c |  12 +-
 5 files changed, 18 insertions(+), 891 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c

Thanks
Guennadi
