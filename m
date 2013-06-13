Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2967 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab3FMGb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 02:31:27 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5D6VGAl055236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:31:18 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id AF50735E0054
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:31:14 +0200 (CEST)
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates Part 3
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 13 Jun 2013 08:31:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306130831.15687.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro prefers to have the original large pull request split up in smaller pieces.

So this is the third patch set.

This patch set merges these patch series:

Control framework conversions:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg62772.html

Removal of current_norm:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg62914.html

Note: patch 5 was dropped. It was 1) broken, and 2) not related to current_norm
anyway. A fixed version will be posted separately.

Note that the pull requests need to be done in order since there are dependencies
between them.

Regards,

	Hans

The following changes since commit 4cb7bf1ce4051911ae658f55e0d480246de9b727:

  v4l2-framework: replace g_chip_ident by g_std in the examples. (2013-06-13 08:15:20 +0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11c

for you to fetch changes up to 992df036e18da2333d10be0d8451592502f4d3cd:

  v4l2: remove deprecated current_norm support completely. (2013-06-13 08:16:51 +0200)

----------------------------------------------------------------
Hans Verkuil (33):
      saa7706h: convert to the control framework.
      sr030pc30: convert to the control framework.
      saa6752hs: convert to the control framework.
      radio-tea5764: add support for struct v4l2_device.
      radio-tea5764: embed struct video_device.
      radio-tea5764: convert to the control framework.
      radio-tea5764: audio and input ioctls do not apply to radio devices.
      radio-tea5764: add device_caps support.
      radio-tea5764: add prio and control event support.
      radio-tea5764: some cleanups and clamp frequency when out-of-range
      radio-timb: add device_caps support, remove input/audio ioctls.
      radio-timb: convert to the control framework.
      radio-timb: actually load the requested subdevs
      radio-timb: add control events and prio support.
      tef6862: clamp frequency.
      timblogiw: fix querycap.
      radio-sf16fmi: remove audio/input ioctls.
      radio-sf16fmi: add device_caps support to querycap.
      radio-sf16fmi: clamp frequency.
      radio-sf16fmi: convert to the control framework.
      radio-sf16fmi: add control event and prio support.
      mcam-core: replace current_norm by g_std.
      via-camera: replace current_norm by g_std.
      sh_vou: remove current_norm
      soc_camera: remove use of current_norm.
      fsl-viu: remove current_norm.
      tm6000: remove deprecated current_norm
      saa7164: replace current_norm by g_std
      cx23885: remove use of deprecated current_norm
      usbvision: replace current_norm by g_std.
      saa7134: drop deprecated current_norm.
      dt3155v4l: remove deprecated current_norm
      v4l2: remove deprecated current_norm support completely.

 drivers/media/i2c/sr030pc30.c                   |  276 ++++++++++++++++++-------------------------------------
 drivers/media/pci/cx23885/cx23885-417.c         |    5 +-
 drivers/media/pci/cx23885/cx23885-video.c       |    7 +-
 drivers/media/pci/saa7134/saa6752hs.c           |  457 +++++++++++++++++++++++++-------------------------------------------------------------------
 drivers/media/pci/saa7134/saa7134-empress.c     |    1 -
 drivers/media/pci/saa7134/saa7134-video.c       |    1 -
 drivers/media/pci/saa7164/saa7164-encoder.c     |   13 ++-
 drivers/media/pci/saa7164/saa7164-vbi.c         |   13 ++-
 drivers/media/pci/saa7164/saa7164.h             |    1 +
 drivers/media/platform/fsl-viu.c                |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c |    8 +-
 drivers/media/platform/sh_vou.c                 |    3 +-
 drivers/media/platform/soc_camera/soc_camera.c  |    3 -
 drivers/media/platform/timblogiw.c              |    7 +-
 drivers/media/platform/via-camera.c             |    8 +-
 drivers/media/radio/radio-sf16fmi.c             |  106 ++++++++--------------
 drivers/media/radio/radio-tea5764.c             |  190 +++++++++++++++-----------------------
 drivers/media/radio/radio-timb.c                |   81 ++++-------------
 drivers/media/radio/saa7706h.c                  |   56 ++++++------
 drivers/media/radio/tef6862.c                   |   10 +-
 drivers/media/usb/tm6000/tm6000-cards.c         |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c         |   13 ++-
 drivers/media/usb/usbvision/usbvision-video.c   |   13 ++-
 drivers/media/v4l2-core/v4l2-dev.c              |    5 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            |   34 +------
 drivers/staging/media/dt3155v4l/dt3155v4l.c     |    1 -
 include/media/v4l2-dev.h                        |    1 -
 27 files changed, 449 insertions(+), 868 deletions(-)
