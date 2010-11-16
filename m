Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4215 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab0KPVzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:55:36 -0500
Message-Id: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:55:25 +0100
Subject: [RFCv2 PATCH 00/15] BKL removal
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is my second patch series for the BKL removal project.

While this series is against the v2.6.38 staging tree I think it would be
good to target 2.6.37 instead. A lot of files are changed, but the changes
are all trivial. And this will hopefully take care of most of the BKL
removal problems, except for uvc.

This patch also contains the improved core locking patch which doesn't lock
the VIDIOC_DQBUF ioctl.

Regards,

	Hans

Hans Verkuil (15):
  v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
  BKL: trivial BKL removal from V4L2 radio drivers
  cadet: use unlocked_ioctl
  tea5764: convert to unlocked_ioctl
  si4713: convert to unlocked_ioctl
  typhoon: convert to unlocked_ioctl.
  dsbr100: convert to unlocked_ioctl.
  BKL: trivial ioctl -> unlocked_ioctl video driver conversions
  sn9c102: convert to unlocked_ioctl.
  et61x251_core: trivial conversion to unlocked_ioctl.
  cafe_ccic: replace ioctl by unlocked_ioctl.
  sh_vou: convert to unlocked_ioctl.
  radio-timb: convert to unlocked_ioctl.
  V4L: improve the BKL replacement heuristic
  cx18: convert to unlocked_ioctl.

 drivers/media/radio/dsbr100.c                |    2 +-
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
 drivers/media/video/cx18/cx18-streams.c      |    2 +-
 drivers/media/video/et61x251/et61x251_core.c |    2 +-
 drivers/media/video/meye.c                   |   14 ++--
 drivers/media/video/pms.c                    |    2 +-
 drivers/media/video/sh_vou.c                 |   13 +++--
 drivers/media/video/sn9c102/sn9c102_core.c   |    2 +-
 drivers/media/video/v4l2-dev.c               |   81 +++++++++++++++++++++-----
 drivers/media/video/v4l2-device.c            |    1 +
 drivers/media/video/w9966.c                  |    2 +-
 include/media/v4l2-dev.h                     |    2 +-
 include/media/v4l2-device.h                  |    2 +
 34 files changed, 201 insertions(+), 165 deletions(-)

