Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4968 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2GDRmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 13:42:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [GIT PULL FOR v3.6] mostly remove V4L2_FL_LOCK_ALL_FOPS
Date: Wed, 4 Jul 2012 19:42:04 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207041942.04606.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request builds on (and includes) this core patch series:

http://patchwork.linuxtv.org/patch/13180/

It is identical to the RFC patch series I posted before:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg48184.html

...except that I dropped the patches touching s5p-fimc and fimc-lite and the
final patch removing the flag altogether.

Sylwester posted patches for those two drivers, but they won't apply. Sylwester,
can you rebase those patches? Once I have those, then I can make another pull
request that fixes those two drivers and removes the flag completely.

Regards,

	Hans


The following changes since commit 704a28e88ab6c9cfe393ae626b612cab8b46028e:

  [media] drxk: prevent doing something wrong when init is not ok (2012-06-29 19:04:32 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git removeflag3

for you to fetch changes up to 3456068130243f2391ad3c763a28a7137efcf0a2:

  s5p-mfc: remove V4L2_FL_LOCK_ALL_FOPS (2012-07-04 19:35:22 +0200)

----------------------------------------------------------------
Hans Verkuil (57):
      v4l2-ioctl.c: move a block of code down, no other changes.
      v4l2-ioctl.c: introduce INFO_FL_CLEAR to replace switch.
      v4l2-ioctl.c: v4l2-ioctl: add debug and callback/offset functionality.
      v4l2-ioctl.c: remove an unnecessary #ifdef.
      v4l2-ioctl.c: use the new table for querycap and i/o ioctls.
      v4l2-ioctl.c: use the new table for priority ioctls.
      v4l2-ioctl.c: use the new table for format/framebuffer ioctls.
      v4l2-ioctl.c: use the new table for overlay/streamon/off ioctls.
      v4l2-ioctl.c: use the new table for std/tuner/modulator ioctls.
      v4l2-ioctl.c: use the new table for queuing/parm ioctls.
      v4l2-ioctl.c: use the new table for control ioctls.
      v4l2-ioctl.c: use the new table for selection ioctls.
      v4l2-ioctl.c: use the new table for compression ioctls.
      v4l2-ioctl.c: use the new table for debug ioctls.
      v4l2-ioctl.c: use the new table for preset/timings ioctls.
      v4l2-ioctl.c: use the new table for the remaining ioctls.
      v4l2-ioctl.c: finalize table conversion.
      v4l2-dev.c: add debug sysfs entry.
      v4l2-ioctl: remove v4l_(i2c_)print_ioctl
      ivtv: don't mess with vfd->debug.
      cx18: don't mess with vfd->debug.
      vb2-core: refactor reqbufs/create_bufs.
      vb2-core: add support for count == 0 in create_bufs.
      Spec: document CREATE_BUFS behavior if count == 0.
      v4l2-dev/ioctl.c: add vb2_queue support to video_device.
      videobuf2-core: add helper functions.
      vivi: remove pointless g/s_std support
      vivi: embed struct video_device instead of allocating it.
      vivi: use vb2 helper functions.
      vivi: add create_bufs/preparebuf support.
      v4l2-dev.c: also add debug support for the fops.
      pwc: use the new vb2 helpers.
      pwc: v4l2-compliance fixes.
      v4l2-framework.txt: Update the locking documentation.
      ivtv: remove V4L2_FL_LOCK_ALL_FOPS
      saa7146: remove V4L2_FL_LOCK_ALL_FOPS
      cpia2: remove V4L2_FL_LOCK_ALL_FOPS
      usbvision: remove V4L2_FL_LOCK_ALL_FOPS
      em28xx: remove V4L2_FL_LOCK_ALL_FOPS
      tm6000: remove V4L2_FL_LOCK_ALL_FOPS
      mem2mem_testdev: remove V4L2_FL_LOCK_ALL_FOPS
      dt3155v4l: remove V4L2_FL_LOCK_ALL_FOPS
      wl128x: remove V4L2_FL_LOCK_ALL_FOPS
      fsl-viu: remove V4L2_FL_LOCK_ALL_FOPS
      s2255drv: remove V4L2_FL_LOCK_ALL_FOPS
      vpbe_display: remove V4L2_FL_LOCK_ALL_FOPS
      vpif_capture: remove V4L2_FL_LOCK_ALL_FOPS
      vpif_display: remove V4L2_FL_LOCK_ALL_FOPS
      mx2_emmaprp: remove V4L2_FL_LOCK_ALL_FOPS
      sh_vou: remove V4L2_FL_LOCK_ALL_FOPS
      bfin_capture: remove V4L2_FL_LOCK_ALL_FOPS
      cx231xx: remove V4L2_FL_LOCK_ALL_FOPS
      soc_camera: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-jpeg: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-g2d: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-tv: remove V4L2_FL_LOCK_ALL_FOPS
      s5p-mfc: remove V4L2_FL_LOCK_ALL_FOPS

 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +-
 Documentation/video4linux/v4l2-framework.txt           |   73 +-
 drivers/media/common/saa7146_core.c                    |    8 -
 drivers/media/common/saa7146_fops.c                    |   55 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c                |   38 +-
 drivers/media/video/blackfin/bfin_capture.c            |   17 +-
 drivers/media/video/cpia2/cpia2_v4l.c                  |   39 +-
 drivers/media/video/cx18/cx18-ioctl.c                  |   18 -
 drivers/media/video/cx18/cx18-ioctl.h                  |    2 -
 drivers/media/video/cx18/cx18-streams.c                |    4 +-
 drivers/media/video/cx231xx/cx231xx-video.c            |   47 +-
 drivers/media/video/davinci/vpbe_display.c             |   22 +-
 drivers/media/video/davinci/vpif_capture.c             |   28 +-
 drivers/media/video/davinci/vpif_display.c             |   34 +-
 drivers/media/video/em28xx/em28xx-video.c              |   52 +-
 drivers/media/video/fsl-viu.c                          |   27 +-
 drivers/media/video/ivtv/ivtv-fileops.c                |   52 +-
 drivers/media/video/ivtv/ivtv-ioctl.c                  |   12 -
 drivers/media/video/ivtv/ivtv-ioctl.h                  |    1 -
 drivers/media/video/ivtv/ivtv-streams.c                |    8 +-
 drivers/media/video/mem2mem_testdev.c                  |   29 +-
 drivers/media/video/mx2_emmaprp.c                      |   28 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c             |    4 +-
 drivers/media/video/pwc/pwc-if.c                       |  171 +---
 drivers/media/video/pwc/pwc-v4l.c                      |  165 +---
 drivers/media/video/pwc/pwc.h                          |    3 -
 drivers/media/video/s2255drv.c                         |   42 +-
 drivers/media/video/s5p-g2d/g2d.c                      |   27 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c               |   34 +-
 drivers/media/video/s5p-mfc/s5p_mfc.c                  |   19 +-
 drivers/media/video/s5p-tv/mixer_video.c               |   29 +-
 drivers/media/video/sh_vou.c                           |   25 +-
 drivers/media/video/sn9c102/sn9c102.h                  |    2 +-
 drivers/media/video/soc_camera.c                       |   31 +-
 drivers/media/video/tm6000/tm6000-video.c              |   52 +-
 drivers/media/video/usbvision/usbvision-video.c        |   42 +-
 drivers/media/video/uvc/uvc_v4l2.c                     |    2 +-
 drivers/media/video/v4l2-dev.c                         |   65 +-
 drivers/media/video/v4l2-ioctl.c                       | 3285 +++++++++++++++++++++++++++++++++++++---------------------------------------
 drivers/media/video/videobuf2-core.c                   |  412 ++++++++--
 drivers/media/video/vivi.c                             |  194 +----
 drivers/staging/media/dt3155v4l/dt3155v4l.c            |   29 +-
 include/media/saa7146.h                                |    4 -
 include/media/v4l2-dev.h                               |    3 +
 include/media/v4l2-ioctl.h                             |   25 +-
 include/media/videobuf2-core.h                         |   54 ++
 46 files changed, 2775 insertions(+), 2546 deletions(-)
