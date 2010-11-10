Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57570 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0KJTdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 14:33:09 -0500
Received: from lancelot.localnet (unknown [91.178.33.128])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9DC1035CA4
	for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 19:33:08 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.37] Use modaliases to load I2C modules (part 2)
Date: Wed, 10 Nov 2010 20:33:05 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011102033.05568.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Here are the last two patches that complete the removal of the module_name
argument from the v4l2_i2c_new_subdev* functions. They are identical to the 
patches I've posted to the list yesterday with the exception of a typo fix in 
one of the commit comments.

I've based the patches on top of your linux-next master branch.

The following changes since commit 6b101926f98b54549128db4d34f4a73b5f03fecc:

  [media] soc-camera: Compile fixes for mx2-camera (2010-11-09 15:16:31 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git i2c-module-name

Laurent Pinchart (2):
      v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev* (2)
      v4l: Remove module_name argument to the v4l2_i2c_new_subdev* functions

 drivers/media/radio/radio-si4713.c            |    2 +-
 drivers/media/video/au0828/au0828-cards.c     |    4 ++--
 drivers/media/video/bt8xx/bttv-cards.c        |   22 +++++++++++-----------
 drivers/media/video/cafe_ccic.c               |    3 +--
 drivers/media/video/cx18/cx18-i2c.c           |    8 ++++----
 drivers/media/video/cx231xx/cx231xx-cards.c   |    4 ++--
 drivers/media/video/cx23885/cx23885-cards.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c   |    4 ++--
 drivers/media/video/cx88/cx88-cards.c         |    9 ++++-----
 drivers/media/video/cx88/cx88-video.c         |    7 +++----
 drivers/media/video/davinci/vpfe_capture.c    |    1 -
 drivers/media/video/davinci/vpif_capture.c    |    1 -
 drivers/media/video/davinci/vpif_display.c    |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c     |   18 +++++++++---------
 drivers/media/video/fsl-viu.c                 |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c           |   22 +++++++++-------------
 drivers/media/video/mxb.c                     |   12 ++++++------
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    6 ++----
 drivers/media/video/s5p-fimc/fimc-capture.c   |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c   |    8 ++++----
 drivers/media/video/saa7134/saa7134-core.c    |    4 ++--
 drivers/media/video/sh_vou.c                  |    2 +-
 drivers/media/video/soc_camera.c              |    2 +-
 drivers/media/video/usbvision/usbvision-i2c.c |    6 +++---
 drivers/media/video/v4l2-common.c             |   15 +++++----------
 drivers/media/video/via-camera.c              |    2 +-
 drivers/media/video/vino.c                    |    4 ++--
 drivers/media/video/zoran/zoran_card.c        |    5 ++---
 drivers/staging/go7007/go7007-driver.c        |    2 +-
 drivers/staging/tm6000/tm6000-cards.c         |    4 ++--
 include/media/v4l2-common.h                   |   16 ++++++----------
 31 files changed, 90 insertions(+), 111 deletions(-)

-- 
Regards,

Laurent Pinchart
