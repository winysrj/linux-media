Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:53892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136Ab1ETIeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 04:34:50 -0400
Date: Fri, 20 May 2011 10:34:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera for 2.6.40
Message-ID: <Pine.LNX.4.64.1105201022070.17254@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Sorry, a bit late again... Here go patches for 2.6.40:

The following changes since commit f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:

  [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.40

Guennadi Liakhovetski (9):
      V4L: sh_mobile_ceu_camera: implement .stop_streaming()
      V4L: mx3_camera: implement .stop_streaming()
      V4L: soc-camera: add a livecrop host operation
      V4L: sh_mobile_ceu_camera: implement live cropping
      V4L: soc-camera: avoid huge arrays, caused by changed format codes
      V4L: omap1-camera: fix huge lookup array
      V4L: soc-camera: add a new packing for YUV 4:2:0 type formats
      V4L: soc-camera: add more format look-up entries
      V4L: soc-camera: a missing mediabus code -> fourcc translation is not critical

Kassey Li (2):
      V4L: soc-camera: add JPEG support
      V4L: soc-camera: add MIPI bus flags

Sergio Aguirre (1):
      V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c

Sylwester Nawrocki (1):
      V4L: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format

Teresa Gámez (2):
      V4L: mt9v022: fix pixel clock
      V4L: mt9m111: fix pixel clock

 Documentation/DocBook/v4l/subdev-formats.xml |   46 +++++
 drivers/media/video/mt9m111.c                |   14 ++-
 drivers/media/video/mt9v022.c                |    2 +-
 drivers/media/video/mx3_camera.c             |   60 +++++--
 drivers/media/video/omap1_camera.c           |   43 +++--
 drivers/media/video/pxa_camera.c             |    8 +-
 drivers/media/video/sh_mobile_ceu_camera.c   |  148 +++++++++++++--
 drivers/media/video/soc_camera.c             |   77 ++++++--
 drivers/media/video/soc_mediabus.c           |  265 +++++++++++++++++++++++---
 include/linux/v4l2-mediabus.h                |    3 +
 include/media/soc_camera.h                   |   15 ++-
 include/media/soc_mediabus.h                 |   25 +++-
 12 files changed, 608 insertions(+), 98 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
