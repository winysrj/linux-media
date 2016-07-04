Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57337 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbcGDIfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:15 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id AB20B1800BF
	for <linux-media@vger.kernel.org>; Mon,  4 Jul 2016 10:35:10 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/14] Remove old subdev control ops
Date: Mon,  4 Jul 2016 10:34:56 +0200
Message-Id: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There are still subdev drivers that need to support control ops
to allow bridge drivers to access the controls.

This series converts all the bridge drivers to access the controls
through the subdev's control handler. The final patch removes those
old control ops from v4l2-subdev.h.

Regards,

	Hans

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

 Documentation/video4linux/v4l2-controls.txt     |  15 ----
 drivers/media/i2c/cs53l32a.c                    |   7 --
 drivers/media/i2c/cx25840/cx25840-core.c        |   7 --
 drivers/media/i2c/msp3400-driver.c              |   7 --
 drivers/media/i2c/saa7115.c                     |   7 --
 drivers/media/i2c/tvaudio.c                     |   7 --
 drivers/media/i2c/wm8775.c                      |   7 --
 drivers/media/pci/cx18/cx18-alsa-mixer.c        |   6 +-
 drivers/media/pci/cx88/cx88-alsa.c              |   8 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c        |   6 +-
 drivers/media/pci/saa7164/saa7164.h             |   4 -
 drivers/media/platform/davinci/ccdc_hw_device.h |   7 --
 drivers/media/platform/marvell-ccic/mcam-core.c |   2 +-
 drivers/media/platform/omap/omap_vout.c         | 109 ++++++------------------
 drivers/media/platform/omap/omap_voutdef.h      |   5 +-
 drivers/media/platform/via-camera.c             |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c         |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c         |   6 +-
 drivers/media/usb/usbvision/usbvision-video.c   |  40 ++++-----
 drivers/media/v4l2-core/v4l2-ctrls.c            |  45 ----------
 drivers/media/v4l2-core/v4l2-flash-led-class.c  |   9 +-
 include/media/v4l2-ctrls.h                      |  10 ---
 include/media/v4l2-subdev.h                     |  21 -----
 23 files changed, 64 insertions(+), 277 deletions(-)

-- 
2.8.1

