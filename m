Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:38684 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2EJMAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 08:00:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] Update v4l2-dev/ioctl.c to add gspca locking requirements
Date: Thu, 10 May 2012 13:59:34 +0200
Cc: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205101359.34819.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is the pull request for this. HdG's gspca work depends on this and he likes to get this
in for 3.5. I think these are pretty good improvements and for 3.6 I intend to build on it,
basically getting rid of the whole huge switch statement in v4l2-ioctl.c and replace it with
table look-ups and callbacks.

But for now this is primarily to support the gspca work.

Regards,

	Hans

The following changes since commit 121b3ddbe4ad17df77cb7284239be0a63d9a66bd:

  [media] media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer (2012-05-08 14:35:14 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ioctlv2

for you to fetch changes up to 758385a2210cb60a0a1bf46bf9a8e1fce837c67b:

  v4l2-framework.txt: document v4l2_dont_use_cmd (2012-05-10 10:41:08 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      v4l2-dev: make it possible to skip locking for selected ioctls.
      v4l2-dev/ioctl: determine the valid ioctls upfront.
      tea575x-tuner: mark VIDIOC_S_HW_FREQ_SEEK as an invalid ioctl.
      v4l2-ioctl: handle priority handling based on a table lookup.
      v4l2-dev: add flag to have the core lock all file operations.
      v4l2-framework.txt: document v4l2_dont_use_cmd

 Documentation/video4linux/v4l2-framework.txt    |   37 ++++-
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
 drivers/media/video/s5p-jpeg/jpeg-core.c        |    8 +
 drivers/media/video/s5p-mfc/s5p_mfc.c           |    6 +
 drivers/media/video/s5p-tv/mixer_video.c        |    4 +
 drivers/media/video/sh_vou.c                    |    4 +
 drivers/media/video/soc_camera.c                |    4 +
 drivers/media/video/tm6000/tm6000-video.c       |    4 +
 drivers/media/video/usbvision/usbvision-video.c |    4 +
 drivers/media/video/v4l2-dev.c                  |  218 ++++++++++++++++++++++++--
 drivers/media/video/v4l2-ioctl.c                |  538 +++++++++++++++++----------------------------------------------
 drivers/staging/media/dt3155v4l/dt3155v4l.c     |    4 +
 include/media/v4l2-dev.h                        |   25 +++
 sound/i2c/other/tea575x-tuner.c                 |    3 +
 30 files changed, 516 insertions(+), 411 deletions(-)
