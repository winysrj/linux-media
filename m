Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762845Ab3DCUgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 16:36:23 -0400
Date: Wed, 3 Apr 2013 22:36:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera for 3.10 second lot
Message-ID: <Pine.LNX.4.64.1304032230410.10531@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

All looks quiet, clock and async will have to wait for another round (or 
more) :-) So, just minor updates here. I'm not sure whether I already can 
update patch status at patchwork and whether any patches have been 
delegated to me yet (perhaps not, I'd get a notification, right?) As soon 
as that begins to work, I'll try to update patchwork too. In any case I'm 
not listing patch IDs here, right?

The following changes since commit f9f11dfe4831adb1531e1face9dcd9fc57665d2e:

  Merge tag 'v3.9-rc5' into patchwork (2013-04-01 09:54:14 -0300)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.10-2

Fabio Porcedda (2):
      drivers: media: use module_platform_driver_probe()
      mx2_camera: use module_platform_driver_probe()

Guennadi Liakhovetski (1):
      soc-camera: protect against racing open(2) and rmmod

Phil Edworthy (1):
      soc_camera: Add RGB666 & RGB888 formats

Sachin Kamat (7):
      soc_camera/mx1_camera: Fix warnings related to spacing
      soc_camera/mx2_camera: Fix warnings related to spacing
      soc_camera/mx3_camera: Fix warning related to spacing
      soc_camera/pxa_camera: Fix warning related to spacing
      soc_camera/pxa_camera: Constify struct dev_pm_ops
      soc_camera/sh_mobile_ceu_camera: Fix warning related to spacing
      soc_camera/soc_camera_platform: Fix warning related to spacing

Tushar Behera (1):
      atmel-isi: Update error check for unsigned variables

 Documentation/DocBook/media/v4l/subdev-formats.xml |  206 +++++++++++++++++++-
 Documentation/DocBook/media_api.tmpl               |    1 +
 drivers/media/platform/soc_camera/atmel-isi.c      |   15 +--
 drivers/media/platform/soc_camera/mx1_camera.c     |    4 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    7 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    2 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |    4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   42 +++--
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   42 ++++
 include/media/soc_camera.h                         |    7 +-
 include/media/soc_mediabus.h                       |    3 +
 include/uapi/linux/v4l2-mediabus.h                 |    6 +-
 14 files changed, 293 insertions(+), 50 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
