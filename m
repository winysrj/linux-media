Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41592 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757728AbcGKG4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 02:56:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2CD5418013E
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2016 08:56:15 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Cleanup control handling
Message-ID: <6ded20b1-fa57-0a76-ac2a-e730c761c986@xs4all.nl>
Date: Mon, 11 Jul 2016 08:56:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series finally gets rid of the old v4l2_subdev control helpers ops.

Instead use the ctrl_handler of the v4l2_subdev struct directly.

Regards,

	Hans

The following changes since commit a4d020e97d8e65d57061677c15c89e99609d0b37:

  [media] Convert Wideview WT220 DVB USB driver to rc-core (2016-07-09 12:10:33 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rmctrl

for you to fetch changes up to 2a29fbb846b5c850cb6bf1b747cec8c0ed3106dc:

  v4l2-subdev.h: remove the control subdev ops (2016-07-11 08:43:15 +0200)

----------------------------------------------------------------
Hans Verkuil (14):
      omap_vout: use control framework
      saa7164: drop unused saa7164_ctrl struct.
      davinci: drop unused control callbacks
      pvrusb2: use v4l2_s_ctrl instead of the s_ctrl op.
      usbvision: use v4l2_ctrl_g_ctrl instead of the g_ctrl op.
      mcam-core: use v4l2_s_ctrl instead of the s_ctrl op
      via-camera: use v4l2_s_ctrl instead of the s_ctrl op.
      cx231xx: use v4l2_s_ctrl instead of the s_ctrl op.
      cx88: use wm8775_s_ctrl instead of the s_ctrl op.
      v4l2-flash-led: remove unused ops
      cx18: use v4l2_g/s_ctrl instead of the g/s_ctrl ops.
      ivtv: use v4l2_g/s_ctrl instead of the g/s_ctrl ops.
      media/i2c: drop the last users of the ctrl core ops.
      v4l2-subdev.h: remove the control subdev ops

 Documentation/video4linux/v4l2-controls.txt     |  15 --------
 drivers/media/i2c/cs53l32a.c                    |   7 ----
 drivers/media/i2c/cx25840/cx25840-core.c        |   7 ----
 drivers/media/i2c/msp3400-driver.c              |   7 ----
 drivers/media/i2c/saa7115.c                     |   7 ----
 drivers/media/i2c/tvaudio.c                     |   7 ----
 drivers/media/i2c/wm8775.c                      |   7 ----
 drivers/media/pci/cx18/cx18-alsa-mixer.c        |   6 +--
 drivers/media/pci/cx88/cx88-alsa.c              |   8 +---
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c        |   6 +--
 drivers/media/pci/saa7164/saa7164.h             |   4 --
 drivers/media/platform/davinci/ccdc_hw_device.h |   7 ----
 drivers/media/platform/marvell-ccic/mcam-core.c |   2 +-
 drivers/media/platform/omap/omap_vout.c         | 109 +++++++++++++---------------------------------------
 drivers/media/platform/omap/omap_voutdef.h      |   5 +--
 drivers/media/platform/via-camera.c             |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c         |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c         |   6 ++-
 drivers/media/usb/usbvision/usbvision-video.c   |  40 ++++++++-----------
 drivers/media/v4l2-core/v4l2-ctrls.c            |  45 ----------------------
 drivers/media/v4l2-core/v4l2-flash-led-class.c  |   9 +----
 include/media/v4l2-ctrls.h                      |  10 -----
 include/media/v4l2-subdev.h                     |  21 ----------
 23 files changed, 64 insertions(+), 277 deletions(-)
