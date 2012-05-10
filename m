Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1066 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2EJHFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 03:05:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [RFCv1 PATCH 0/5] Improvements to the core ioctl/fops handling
Date: Thu, 10 May 2012 09:05:09 +0200
Message-Id: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series makes improvements to the way the v4l2 core handles
locking and how it handles the ioctls.

This is driven by some requirements from the work on the gspca driver,
but it is also a good starting point to clean up the v4l2-ioctl.c source.

The gspca requirement was to have better control over locking. This affects
primarily USB drivers as they want to avoid having to take a core lock when
(de)queuing buffers and polling for new frames since some of the operations
over the USB bus can take a fair amount of time and having to wait for the
lock can increase latency. Besides, for those operations it is usually not
needed to lock.

The same is true for file operations like poll, read and write.

So patch 1 makes it possible to skip locking for selected ioctls, while patch 5
inverts the default behavior of the core: it will only take the core lock for the
ioctl fop, not for the others unless a flag is set explicitly in the driver.

I've set that flag in all drivers that use the core lock, unless it was immediately
obvious that they didn't need it. Those drivers need to be audited so that we
can eventually remove the flag.

While I could have gone for the one-flag-per-fop approach, I thought this made more
sense. There are only a few fops as opposed to the zillion ioctls.

Since I used a table-driven approach in the first patch I decided to extend it to
other parts of v4l2-ioctl as well. So the determination which ioctls are
actually implemented in a driver is now done upfront, and whether an ioctl needs
to do priority handling is now done by table lookup as well.

Eventually I want to replace all the switches by table lookup, which is O(1) and
will hopefully be a lot more readable. Some work doing that is available here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/ioctl2

This patch series is also available here:

  git://linuxtv.org/hverkuil/media_tree.git ioctl

Comments?

Regards,

	Hans

----------------------------------------------------------------
Hans Verkuil (5):
      v4l2-dev: make it possible to skip locking for selected ioctls.
      v4l2-dev/ioctl: determine the valid ioctls upfront.
      tea575x-tuner: mark VIDIOC_S_HW_FREQ_SEEK as an invalid ioctl.
      v4l2-ioctl: handle priority handling based on a table lookup.
      v4l2-dev: add flag to have the core lock all file operations.

 Documentation/video4linux/v4l2-framework.txt    |   27 ++++-
 drivers/media/common/saa7146_fops.c             |    4 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c         |    4 +
 drivers/media/video/blackfin/bfin_capture.c     |    4 +
 drivers/media/video/cpia2/cpia2_v4l.c           |    4 +
 drivers/media/video/cx231xx/cx231xx-video.c     |    4 +
 drivers/media/video/davinci/vpbe_display.c      |    4 +
 drivers/media/video/davinci/vpif_capture.c      |    4 +
 drivers/media/video/davinci/vpif_display.c      |    4 +
 drivers/media/video/em28xx/em28xx-video.c       |    4 +
 drivers/media/video/fsl-viu.c                   |    4 +
 drivers/media/video/ivtv/ivtv-streams.c         |    4 +
 drivers/media/video/mem2mem_testdev.c           |    4 +
 drivers/media/video/mx2_emmaprp.c               |    4 +
 drivers/media/video/s2255drv.c                  |    4 +
 drivers/media/video/s5p-fimc/fimc-capture.c     |    4 +
 drivers/media/video/s5p-fimc/fimc-core.c        |    4 +
 drivers/media/video/s5p-g2d/g2d.c               |    4 +
 drivers/media/video/s5p-jpeg/jpeg-core.c        |    8 ++
 drivers/media/video/s5p-mfc/s5p_mfc.c           |    6 +
 drivers/media/video/s5p-tv/mixer_video.c        |    4 +
 drivers/media/video/sh_vou.c                    |    4 +
 drivers/media/video/soc_camera.c                |    4 +
 drivers/media/video/tm6000/tm6000-video.c       |    4 +
 drivers/media/video/usbvision/usbvision-video.c |    4 +
 drivers/media/video/v4l2-dev.c                  |  217 ++++++++++++++++++++++++++++++---
 drivers/media/video/v4l2-ioctl.c                |  539 ++++++++++++++++++++++------------------------------------------------------------
 drivers/staging/media/dt3155v4l/dt3155v4l.c     |    4 +
 include/media/v4l2-dev.h                        |   25 ++++
 sound/i2c/other/tea575x-tuner.c                 |    3 +
 30 files changed, 506 insertions(+), 411 deletions(-)

