Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2864 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab2GaHIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 03:08:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR v3.6] Remove V4L2_FL_LOCK_ALL_FOPS
Date: Tue, 31 Jul 2012 09:07:57 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207310907.57410.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I hope this can still be applied to 3.6. This patch series was pending a fix
for s5p-fimc which is now merged, so this can now be pulled in.

It removes the legacy V4L2_FL_LOCK_ALL_FOPS flag, simplifying the locking
code. It's rebased to the latest for_v3.6 branch but otherwise unchanged.

Regards,

	Hans

The following changes since commit 24ed693da0cefede7382d498dd5e9a83f0a21c38:

  [media] DVB: dib0700, remove double \n's from log (2012-07-31 00:36:03 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git removeflag3

for you to fetch changes up to 0bcee95388e4aaa1877a797880d485b083794945:

  v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS (2012-07-31 09:02:25 +0200)

----------------------------------------------------------------
Hans Verkuil (24):
      ivtv: remove V4L2_FL_LOCK_ALL_FOPS
      saa7146: remove V4L2_FL_LOCK_ALL_FOPS
      cpia2: remove V4L2_FL_LOCK_ALL_FOPS
      usbvision: remove V4L2_FL_LOCK_ALL_FOPS
      em28xx: remove V4L2_FL_LOCK_ALL_FOPS
      tm6000: remove V4L2_FL_LOCK_ALL_FOPS
      dt3155v4l: remove V4L2_FL_LOCK_ALL_FOPS
      wl128x: remove V4L2_FL_LOCK_ALL_FOPS
      fsl-viu: remove V4L2_FL_LOCK_ALL_FOPS
      s2255drv: remove V4L2_FL_LOCK_ALL_FOPS
      vpbe_display: remove V4L2_FL_LOCK_ALL_FOPS
      mx2_emmaprp: remove V4L2_FL_LOCK_ALL_FOPS
      sh_vou: remove V4L2_FL_LOCK_ALL_FOPS
      bfin_capture: remove V4L2_FL_LOCK_ALL_FOPS
      cx231xx: remove V4L2_FL_LOCK_ALL_FOPS
      soc_camera: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-jpeg: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-g2d: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-tv: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-mfc: remove V4L2_FL_LOCK_ALL_FOPS
      vpif_display: remove V4L2_FL_LOCK_ALL_FOPS
      vpif_capture: remove V4L2_FL_LOCK_ALL_FOPS
      mem2mem_testdev: remove V4L2_FL_LOCK_ALL_FOPS
      v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS

 drivers/media/common/saa7146_core.c             |    8 --------
 drivers/media/common/saa7146_fops.c             |   55 +++++++++++++++++++++++++++++++++++++++----------------
 drivers/media/radio/wl128x/fmdrv_v4l2.c         |   38 ++++++++++++++++++++++++++------------
 drivers/media/video/blackfin/bfin_capture.c     |   17 +++++++++++------
 drivers/media/video/cpia2/cpia2_v4l.c           |   39 ++++++++++++++++++++++++++++-----------
 drivers/media/video/cx231xx/cx231xx-video.c     |   47 ++++++++++++++++++++++++++++++++++++-----------
 drivers/media/video/davinci/vpbe_display.c      |   22 +++++++++++++++-------
 drivers/media/video/davinci/vpif_capture.c      |   28 ++++++++++++++++++++--------
 drivers/media/video/davinci/vpif_display.c      |   34 +++++++++++++++++++++++-----------
 drivers/media/video/em28xx/em28xx-video.c       |   52 +++++++++++++++++++++++++++++++++++-----------------
 drivers/media/video/fsl-viu.c                   |   27 ++++++++++++++++++++++-----
 drivers/media/video/ivtv/ivtv-fileops.c         |   52 ++++++++++++++++++++++++++++++++++++++++++----------
 drivers/media/video/ivtv/ivtv-streams.c         |    4 ----
 drivers/media/video/mem2mem_testdev.c           |   29 ++++++++++++++++++++---------
 drivers/media/video/mx2_emmaprp.c               |   28 ++++++++++++++++++++++------
 drivers/media/video/s2255drv.c                  |   42 +++++++++++++++++++++---------------------
 drivers/media/video/s5p-g2d/g2d.c               |   27 +++++++++++++++++++++------
 drivers/media/video/s5p-jpeg/jpeg-core.c        |   34 ++++++++++++++++++++++++----------
 drivers/media/video/s5p-mfc/s5p_mfc.c           |   19 +++++++++++++------
 drivers/media/video/s5p-tv/mixer_video.c        |   29 +++++++++++++++++++++--------
 drivers/media/video/sh_vou.c                    |   25 +++++++++++++++++++------
 drivers/media/video/soc_camera.c                |   31 ++++++++++++++++++++-----------
 drivers/media/video/tm6000/tm6000-video.c       |   52 +++++++++++++++++++++++++++++++++++++++++++---------
 drivers/media/video/usbvision/usbvision-video.c |   42 ++++++++++++++++++++++++++++++++++++------
 drivers/media/video/v4l2-dev.c                  |   51 ++++++++-------------------------------------------
 drivers/media/video/videobuf2-core.c            |   21 +++++++--------------
 drivers/staging/media/dt3155v4l/dt3155v4l.c     |   29 ++++++++++++++++++++++-------
 include/media/saa7146.h                         |    4 ----
 include/media/v4l2-dev.h                        |    3 ---
 29 files changed, 594 insertions(+), 295 deletions(-)
