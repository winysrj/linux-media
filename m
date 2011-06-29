Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:56545 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1F2NPj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 09:15:39 -0400
Date: Wed, 29 Jun 2011 15:15:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] first soc-camera pull for 3.1
Message-ID: <Pine.LNX.4.64.1106291511280.12577@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

I expect at least one more soc-camera pull request for 3.1, so far a bunch 
of patches, that have been lying around since a while already.

The following changes since commit 7023c7dbc3944f42aa1d6910a6098c5f9e23d3f1:

  [media] DVB: dvb-net, make the kconfig text helpful (2011-06-21 15:55:15 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.1

Andrew Chew (6):
      V4L: ov9740: Cleanup hex casing inconsistencies
      V4L: ov9740: Correct print in ov9740_reg_rmw()
      V4L: ov9740: Fixed some settings
      V4L: ov9740: Remove hardcoded resolution regs
      V4L: ov9740: Reorder video and core ops
      V4L: ov9740: Add suspend/resume

Guennadi Liakhovetski (11):
      V4L: mx3_camera: remove redundant calculations
      V4L: pxa_camera: remove redundant calculations
      V4L: pxa-camera: try to force progressive video format
      V4L: pxa-camera: switch to using subdev .s_power() core operation
      V4L: mx2_camera: .try_fmt shouldn't fail
      V4L: sh_mobile_ceu_camera: remove redundant calculations
      V4L: tw9910: remove bogus ENUMINPUT implementation
      V4L: soc-camera: MIPI flags are not sensor flags
      V4L: mt9m111: propagate higher level abstraction down in functions
      V4L: mt9m111: switch to v4l2-subdev .s_power() method
      V4L: soc-camera: remove several now unused soc-camera client operations

Josh Wu (1):
      V4L: at91: add Atmel Image Sensor Interface (ISI) support

 drivers/media/video/Kconfig                |    8 +
 drivers/media/video/Makefile               |    1 +
 drivers/media/video/atmel-isi.c            | 1048 ++++++++++++++++++++++++++++
 drivers/media/video/mt9m111.c              |  218 ++++---
 drivers/media/video/mx2_camera.c           |   15 +-
 drivers/media/video/mx3_camera.c           |   12 -
 drivers/media/video/ov9740.c               |  543 ++++++++-------
 drivers/media/video/pxa_camera.c           |   25 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    5 -
 drivers/media/video/soc_camera.c           |   17 +-
 drivers/media/video/tw9910.c               |   11 -
 include/media/atmel-isi.h                  |  119 ++++
 include/media/soc_camera.h                 |   15 +-
 13 files changed, 1631 insertions(+), 406 deletions(-)
 create mode 100644 drivers/media/video/atmel-isi.c
 create mode 100644 include/media/atmel-isi.h

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
