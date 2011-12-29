Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1L2Iib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 03:38:31 -0500
Date: Thu, 29 Dec 2011 09:38:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera for 3.3
Message-ID: <Pine.LNX.4.64.1112290934500.15735@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Please pull a couple of soc-camera patches for 3.3. This is going to be a 
_much_ quieter pull, than the previous one:-) I didn't have time to 
continue the work on the soc-camera Media Controller conversion, so, that 
will have to wait at least until 3.4.

Interestingly, Javier Martin has fixed field_count handling in mx2_camera, 
but, apparently, it also has to be fixed in other soc-camera drivers. So, 
a patch for that might follow later in the 3.3 cycle.

The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:

  [media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.3

Guennadi Liakhovetski (4):
      V4L: soc-camera: remove redundant parameter from the .set_bus_param() method
      V4L: mt9m111: cleanly separate register contexts
      V4L: mt9m111: power down most circuits when suspended
      V4L: mt9m111: properly implement .s_crop and .s_fmt(), reset on STREAMON

Javier Martin (2):
      media i.MX27 camera: add support for YUV420 format.
      media i.MX27 camera: Fix field_count handling.

Josh Wu (1):
      V4L: atmel-isi: add code to enable/disable ISI_MCK clock

Lei Wen (1):
      V4L: soc-camera: change order of removing device

 drivers/media/video/atmel-isi.c            |   33 +++-
 drivers/media/video/mt9m111.c              |  373 +++++++++++++++-------------
 drivers/media/video/mx1_camera.c           |    2 +-
 drivers/media/video/mx2_camera.c           |  299 ++++++++++++++++++----
 drivers/media/video/mx3_camera.c           |    3 +-
 drivers/media/video/omap1_camera.c         |    4 +-
 drivers/media/video/pxa_camera.c           |    3 +-
 drivers/media/video/sh_mobile_ceu_camera.c |   11 +-
 drivers/media/video/soc_camera.c           |    4 +-
 include/media/atmel-isi.h                  |    4 +-
 include/media/soc_camera.h                 |    2 +-
 11 files changed, 486 insertions(+), 252 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
