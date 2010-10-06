Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60281 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0JFIov (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:44:51 -0400
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [GIT PATCHES FOR 2.6.37] Use modaliases to load I2C modules
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Wed, 6 Oct 2010 10:45:01 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010061045.02832.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit c8dd732fd119ce6d562d5fa82a10bbe75a376575:

  V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of sn9c102
  (2010-10-01 18:14:35 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git i2c-module-name

The patches have been posted to the list, and acked for pvrusb2, soc-camera
and sh_vou.

Laurent Pinchart (16):
      v4l: Load I2C modules based on modalias
      v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev*
      go7007: Add MODULE_DEVICE_TABLE to the go7007 I2C modules
      go7007: Fix the TW2804 I2C type name
      go7007: Don't use module names to load I2C modules
      zoran: Don't use module names to load I2C modules
      pvrusb2: Don't use module names to load I2C modules
      sh_vou: Don't use module names to load I2C modules
      radio-si4713: Don't use module names to load I2C modules
      soc_camera: Don't use module names to load I2C modules
      vpfe_capture: Don't use module names to load I2C modules
      vpif_display: Don't use module names to load I2C modules
      vpif_capture: Don't use module names to load I2C modules
      ivtv: Don't use module names to load I2C modules
      cx18: Don't use module names to load I2C modules
      v4l: Remove module_name argument to the v4l2_i2c_new_subdev* functions

 arch/arm/mach-mx3/mach-pcm037.c               |    2 -
 arch/arm/mach-mx3/mx31moboard-marxbot.c       |    1 -
 arch/arm/mach-mx3/mx31moboard-smartbot.c      |    1 -
 arch/arm/mach-pxa/em-x270.c                   |    1 -
 arch/arm/mach-pxa/ezx.c                       |    2 -
 arch/arm/mach-pxa/mioa701.c                   |    1 -
 arch/arm/mach-pxa/pcm990-baseboard.c          |    2 -
 arch/sh/boards/mach-ap325rxa/setup.c          |    1 -
 arch/sh/boards/mach-ecovec24/setup.c          |    4 --
 arch/sh/boards/mach-kfr2r09/setup.c           |    1 -
 arch/sh/boards/mach-migor/setup.c             |    2 -
 arch/sh/boards/mach-se/7724/setup.c           |    1 -
 drivers/media/radio/radio-si4713.c            |    2 +-
 drivers/media/video/au0828/au0828-cards.c     |    4 +-
 drivers/media/video/bt8xx/bttv-cards.c        |   22 +++++-----
 drivers/media/video/cafe_ccic.c               |    2 +-
 drivers/media/video/cx18/cx18-i2c.c           |   23 ++---------
 drivers/media/video/cx231xx/cx231xx-cards.c   |    4 +-
 drivers/media/video/cx23885/cx23885-cards.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c   |    4 +-
 drivers/media/video/cx88/cx88-cards.c         |    9 ++--
 drivers/media/video/cx88/cx88-video.c         |    7 +--
 drivers/media/video/davinci/vpfe_capture.c    |    1 -
 drivers/media/video/davinci/vpif_capture.c    |    1 -
 drivers/media/video/davinci/vpif_display.c    |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c     |   18 ++++----
 drivers/media/video/fsl-viu.c                 |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c           |   50 +++++--------------------
 drivers/media/video/mxb.c                     |   12 +++---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |   13 +-----
 drivers/media/video/saa7134/saa7134-cards.c   |    8 ++--
 drivers/media/video/saa7134/saa7134-core.c    |    4 +-
 drivers/media/video/sh_vou.c                  |    2 +-
 drivers/media/video/soc_camera.c              |    2 +-
 drivers/media/video/usbvision/usbvision-i2c.c |    6 +-
 drivers/media/video/v4l2-common.c             |   13 ++----
 drivers/media/video/vino.c                    |    4 +-
 drivers/media/video/zoran/zoran.h             |    2 -
 drivers/media/video/zoran/zoran_card.c        |   24 +----------
 drivers/staging/go7007/go7007-driver.c        |   43 +--------------------
 drivers/staging/go7007/go7007-usb.c           |    2 +-
 drivers/staging/go7007/wis-ov7640.c           |    1 +
 drivers/staging/go7007/wis-saa7113.c          |    1 +
 drivers/staging/go7007/wis-saa7115.c          |    1 +
 drivers/staging/go7007/wis-sony-tuner.c       |    1 +
 drivers/staging/go7007/wis-tw2804.c           |    1 +
 drivers/staging/go7007/wis-tw9903.c           |    1 +
 drivers/staging/go7007/wis-uda1342.c          |    1 +
 drivers/staging/tm6000/tm6000-cards.c         |    4 +-
 include/media/sh_vou.h                        |    1 -
 include/media/v4l2-common.h                   |   16 +++-----
 51 files changed, 101 insertions(+), 234 deletions(-)

-- 
Regards,

Laurent Pinchart
