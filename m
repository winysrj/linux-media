Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2467 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0KNNWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:22:12 -0500
Message-Id: <cover.1289740431.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 14 Nov 2010 14:21:57 +0100
Subject: [RFC PATCH 0/8] V4L BKL removal: first round
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series converts 24 v4l drivers to unlocked_ioctl. These are low
hanging fruit but you have to start somewhere :-)

The first patch replaces mutex_lock in the V4L2 core by mutex_lock_interruptible
for most fops.

Hans Verkuil (8):
  v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
  BKL: trivial BKL removal from V4L2 radio drivers
  cadet: use unlocked_ioctl
  tea5764: convert to unlocked_ioctl
  si4713: convert to unlocked_ioctl
  typhoon: convert to unlocked_ioctl.
  dsbr100: convert to unlocked_ioctl.
  BKL: trivial ioctl -> unlocked_ioctl video driver conversions

 drivers/media/radio/dsbr100.c          |    2 +-
 drivers/media/radio/radio-aimslab.c    |   16 +++++-----
 drivers/media/radio/radio-aztech.c     |    6 ++--
 drivers/media/radio/radio-cadet.c      |   12 ++++++--
 drivers/media/radio/radio-gemtek-pci.c |    6 ++--
 drivers/media/radio/radio-gemtek.c     |   14 ++++----
 drivers/media/radio/radio-maestro.c    |   14 ++++-----
 drivers/media/radio/radio-maxiradio.c  |    2 +-
 drivers/media/radio/radio-miropcm20.c  |    6 ++-
 drivers/media/radio/radio-rtrack2.c    |   10 +++---
 drivers/media/radio/radio-sf16fmi.c    |    7 ++--
 drivers/media/radio/radio-sf16fmr2.c   |   11 +++----
 drivers/media/radio/radio-si4713.c     |    3 +-
 drivers/media/radio/radio-tea5764.c    |   49 ++++++--------------------------
 drivers/media/radio/radio-terratec.c   |    8 ++--
 drivers/media/radio/radio-trust.c      |   18 ++++++------
 drivers/media/radio/radio-typhoon.c    |   16 +++++-----
 drivers/media/radio/radio-zoltrix.c    |   30 ++++++++++----------
 drivers/media/video/arv.c              |    2 +-
 drivers/media/video/bw-qcam.c          |    2 +-
 drivers/media/video/c-qcam.c           |    2 +-
 drivers/media/video/meye.c             |   14 ++++----
 drivers/media/video/pms.c              |    2 +-
 drivers/media/video/v4l2-dev.c         |   44 +++++++++++++++++++++--------
 drivers/media/video/w9966.c            |    2 +-
 25 files changed, 147 insertions(+), 151 deletions(-)

