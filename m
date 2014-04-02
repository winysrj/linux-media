Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3403 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123AbaDBKid (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 06:38:33 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id s32AcTjw004951
	for <linux-media@vger.kernel.org>; Wed, 2 Apr 2014 12:38:32 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 08CE92A03F4
	for <linux-media@vger.kernel.org>; Wed,  2 Apr 2014 12:38:21 +0200 (CEST)
Message-ID: <533BE85D.3060007@xs4all.nl>
Date: Wed, 02 Apr 2014 12:37:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This supersedes my previous 3.16 pull request of a March 28: it contained one
v4l2-pci-skeleton.c patch that was incorrect, that's now dropped.

Regards,

	Hans

The following changes since commit 8432164ddf7bfe40748ac49995356ab4dfda43b7:

  [media] Sensoray 2255 uses videobuf2 (2014-03-24 17:23:43 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16a

for you to fetch changes up to 74687c197496b2e1fe690e9d9bafbf7c9235cf60:

  staging: media: davinci: vpfe: release buffers in case start_streaming call back fails (2014-04-02 12:35:16 +0200)

----------------------------------------------------------------
Daniel Glöckner (1):
      bttv: Add support for PCI-8604PW

Hans Verkuil (4):
      v4l2-subdev.h: fix sparse error with v4l2_subdev_notify
      videobuf2-core: fix sparse errors.
      v4l2-common.h: remove __user annotation in struct v4l2_edid
      v4l2-ioctl.c: fix sparse __user-related warnings

Ismael Luceno (1):
      gspca_gl860: Clean up idxdata structs

Lad, Prabhakar (4):
      media: davinci: vpbe: use v4l2_fh for priority handling
      media: davinci: vpfe: use v4l2_fh for priority handling
      staging: media: davinci: vpfe: use v4l2_fh for priority handling
      staging: media: davinci: vpfe: release buffers in case start_streaming call back fails

Martin Bugge (2):
      adv7842: update RGB quantization range on HDMI/DVI-D mode irq.
      adv7842: Disable access to EDID DDC lines before chip power up.

Mike Sampson (1):
      next-20140324 drivers/staging/media/sn9c102/sn9c102_hv7131r.c fix style warnings flagged by checkpatch.pl.

ileana@telecom-paristech.fr (1):
      staging: omap24xx: fix coding style

 drivers/media/i2c/adv7842.c                          |  10 +-
 drivers/media/pci/bt8xx/bttv-cards.c                 | 110 +++++++++++++++
 drivers/media/pci/bt8xx/bttv.h                       |   1 +
 drivers/media/platform/davinci/vpbe_display.c        |  39 +-----
 drivers/media/platform/davinci/vpfe_capture.c        |  13 +-
 drivers/media/usb/gspca/gl860/gl860-mi2020.c         | 464 +++++++++++++++++++++++++++++++++++--------------------------
 drivers/media/v4l2-core/v4l2-ioctl.c                 |  10 +-
 drivers/media/v4l2-core/videobuf2-core.c             | 211 +++++++++++++++++-----------
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h |   2 -
 drivers/staging/media/davinci_vpfe/vpfe_video.c      |  18 ++-
 drivers/staging/media/davinci_vpfe/vpfe_video.h      |   2 -
 drivers/staging/media/omap24xx/tcm825x.h             |   4 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c      |  23 +--
 include/media/davinci/vpbe_display.h                 |   6 +-
 include/media/davinci/vpfe_capture.h                 |   6 +-
 include/media/v4l2-device.h                          |   8 ++
 include/media/v4l2-subdev.h                          |   5 -
 include/uapi/linux/v4l2-common.h                     |   2 +-
 18 files changed, 573 insertions(+), 361 deletions(-)
