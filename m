Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35734 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KIPa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 10:30:28 -0500
Received: from localhost.localdomain (unknown [91.178.204.79])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5EF4F35CB2
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 15:30:27 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] Use modaliases to load I2C modules
Date: Tue,  9 Nov 2010 16:30:26 +0100
Message-Id: <1289316628-9394-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here are the last two patches that complete the removal of the module_name
argument from the v4l2_i2c_new_subdev* functions. All the other patches have
already been merged in 2.6.37-rc1, and the goal was to merge one last patch
after the end of the merge window to avoid conflicts.

Unfortunately a few new drivers started using the v4l2_i2c_new_subdev*
functions (s5p-fimc and via-camera) and part of one previous patch got
reverted during a merge conflict resolution. I've thus included a patch that
fixes those drivers.

I will post a pull request against Mauro's linux-next tree as soon as the bad
cafe-ccic merge conflict resolution gets there.

Laurent Pinchart (2):
  v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev* (2)
  v4l: Remove module_name argument to the v4l2_i2c_new_subdev*
    functions

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

