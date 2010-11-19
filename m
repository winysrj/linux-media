Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2127 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab0KSVFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 16:05:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37]
Date: Fri, 19 Nov 2010 22:05:23 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011192205.23244.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Here is the pull request for the patch series that:

1) Converts 29 drivers to unlocked_ioctl
2) Improves the v4l core by using mutex_lock_interruptible and fixes
   incorrect return codes for poll, write and read.
3) Improves the BKL-replacement code so that VIDIOC_DQBUF is no longer
   using the core locks (either the static lock or the new per-v4l2_device
   lock).

Three drivers may develop problems by not locking DQBUF: uvc (this must be
converted for 2.6.37 to unlocked_ioctl due to its popularity), stk-webcam.c
and usbvision. The stk-webcam driver has no locking whatsoever. I will see if
I can prepare a patch converting it to core-assisted locking.

usbvision has some sort of locking already and is likely to be OK, or at least
as likely as that driver ever was since it has many problems already.

Regarding point 2: poll didn't return POLLERR in case of an error, and read
and write returned -EIO for unregistered (i.e. disconnected) device nodes
whereas elsewhere in the kernel -ENODEV is used for that. That makes more sense
as well.

I have two possible trees for you to pull from. The first uses
mutex_lock_interruptible for mmap:

The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:
  Linus Torvalds (1):
        Linux 2.6.37-rc2

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git bkl-lock-int

Hans Verkuil (14):
      BKL: trivial BKL removal from V4L2 radio drivers
      cadet: use unlocked_ioctl
      tea5764: convert to unlocked_ioctl
      si4713: convert to unlocked_ioctl
      typhoon: convert to unlocked_ioctl.
      BKL: trivial ioctl -> unlocked_ioctl video driver conversions
      sn9c102: convert to unlocked_ioctl.
      et61x251_core: trivial conversion to unlocked_ioctl.
      cafe_ccic: replace ioctl by unlocked_ioctl.
      sh_vou: convert to unlocked_ioctl.
      radio-timb: convert to unlocked_ioctl.
      cx18: convert to unlocked_ioctl.
      v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
      V4L: improve the BKL replacement heuristic

 drivers/media/radio/radio-aimslab.c          |   16 +++---
 drivers/media/radio/radio-aztech.c           |    6 +-
 drivers/media/radio/radio-cadet.c            |   12 +++-
 drivers/media/radio/radio-gemtek-pci.c       |    6 +-
 drivers/media/radio/radio-gemtek.c           |   14 ++--
 drivers/media/radio/radio-maestro.c          |   14 ++---
 drivers/media/radio/radio-maxiradio.c        |    2 +-
 drivers/media/radio/radio-miropcm20.c        |    6 +-
 drivers/media/radio/radio-rtrack2.c          |   10 ++--
 drivers/media/radio/radio-sf16fmi.c          |    7 +-
 drivers/media/radio/radio-sf16fmr2.c         |   11 ++--
 drivers/media/radio/radio-si4713.c           |    3 +-
 drivers/media/radio/radio-tea5764.c          |   49 +++------------
 drivers/media/radio/radio-terratec.c         |    8 +-
 drivers/media/radio/radio-timb.c             |    5 +-
 drivers/media/radio/radio-trust.c            |   18 +++---
 drivers/media/radio/radio-typhoon.c          |   16 +++---
 drivers/media/radio/radio-zoltrix.c          |   30 +++++-----
 drivers/media/video/arv.c                    |    2 +-
 drivers/media/video/bw-qcam.c                |    2 +-
 drivers/media/video/c-qcam.c                 |    2 +-
 drivers/media/video/cafe_ccic.c              |    2 +-
 drivers/media/video/cx18/cx18-alsa-pcm.c     |    8 ++-
 drivers/media/video/cx18/cx18-streams.c      |    2 +-
 drivers/media/video/et61x251/et61x251_core.c |    2 +-
 drivers/media/video/meye.c                   |   14 ++--
 drivers/media/video/pms.c                    |    2 +-
 drivers/media/video/sh_vou.c                 |   13 +++--
 drivers/media/video/sn9c102/sn9c102_core.c   |    2 +-
 drivers/media/video/v4l2-dev.c               |   85 ++++++++++++++++++++------
 drivers/media/video/v4l2-device.c            |    1 +
 drivers/media/video/w9966.c                  |    2 +-
 include/media/v4l2-device.h                  |    2 +
 33 files changed, 207 insertions(+), 167 deletions(-)

And the second uses mutex_lock for mmap():

The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:
  Linus Torvalds (1):
        Linux 2.6.37-rc2

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git bkl-lock

Hans Verkuil (14):
      BKL: trivial BKL removal from V4L2 radio drivers
      cadet: use unlocked_ioctl
      tea5764: convert to unlocked_ioctl
      si4713: convert to unlocked_ioctl
      typhoon: convert to unlocked_ioctl.
      BKL: trivial ioctl -> unlocked_ioctl video driver conversions
      sn9c102: convert to unlocked_ioctl.
      et61x251_core: trivial conversion to unlocked_ioctl.
      cafe_ccic: replace ioctl by unlocked_ioctl.
      sh_vou: convert to unlocked_ioctl.
      radio-timb: convert to unlocked_ioctl.
      cx18: convert to unlocked_ioctl.
      v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
      V4L: improve the BKL replacement heuristic

 drivers/media/radio/radio-aimslab.c          |   16 +++---
 drivers/media/radio/radio-aztech.c           |    6 +-
 drivers/media/radio/radio-cadet.c            |   12 +++-
 drivers/media/radio/radio-gemtek-pci.c       |    6 +-
 drivers/media/radio/radio-gemtek.c           |   14 ++--
 drivers/media/radio/radio-maestro.c          |   14 ++---
 drivers/media/radio/radio-maxiradio.c        |    2 +-
 drivers/media/radio/radio-miropcm20.c        |    6 +-
 drivers/media/radio/radio-rtrack2.c          |   10 ++--
 drivers/media/radio/radio-sf16fmi.c          |    7 +-
 drivers/media/radio/radio-sf16fmr2.c         |   11 ++--
 drivers/media/radio/radio-si4713.c           |    3 +-
 drivers/media/radio/radio-tea5764.c          |   49 +++-------------
 drivers/media/radio/radio-terratec.c         |    8 +-
 drivers/media/radio/radio-timb.c             |    5 +-
 drivers/media/radio/radio-trust.c            |   18 +++---
 drivers/media/radio/radio-typhoon.c          |   16 +++---
 drivers/media/radio/radio-zoltrix.c          |   30 +++++-----
 drivers/media/video/arv.c                    |    2 +-
 drivers/media/video/bw-qcam.c                |    2 +-
 drivers/media/video/c-qcam.c                 |    2 +-
 drivers/media/video/cafe_ccic.c              |    2 +-
 drivers/media/video/cx18/cx18-alsa-pcm.c     |    8 ++-
 drivers/media/video/cx18/cx18-streams.c      |    2 +-
 drivers/media/video/et61x251/et61x251_core.c |    2 +-
 drivers/media/video/meye.c                   |   14 ++--
 drivers/media/video/pms.c                    |    2 +-
 drivers/media/video/sh_vou.c                 |   13 +++--
 drivers/media/video/sn9c102/sn9c102_core.c   |    2 +-
 drivers/media/video/v4l2-dev.c               |   77 ++++++++++++++++++++-----
 drivers/media/video/v4l2-device.c            |    1 +
 drivers/media/video/w9966.c                  |    2 +-
 include/media/v4l2-device.h                  |    2 +
 33 files changed, 201 insertions(+), 165 deletions(-)

They are otherwise identical. We didn't finish our irc discussion on mmap yesterday,
so I thought I'd let you choose :-)

Regards.

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
