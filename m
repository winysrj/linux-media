Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3955 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaC1LXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 07:23:14 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2SBNBj6073963
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 12:23:13 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B5DFE2A03F2
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 12:23:09 +0100 (CET)
Message-ID: <53355B9D.4090002@xs4all.nl>
Date: Fri, 28 Mar 2014 12:23:09 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This supersedes my previous 3.16 pull request of a 15 minutes ago: I had missed
two more relevant davinci patches from Prabhakar. Those are added here.

Regards,

	Hans

The following changes since commit 8432164ddf7bfe40748ac49995356ab4dfda43b7:

  [media] Sensoray 2255 uses videobuf2 (2014-03-24 17:23:43 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16a

for you to fetch changes up to f40cba75b6f341348c1baab0f7c91c868279394d:

  staging: media: davinci: vpfe: release buffers in case start_streaming call back fails (2014-03-28 12:14:17 +0100)

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

Lad, Prabhakar (5):
      media: davinci: vpbe: use v4l2_fh for priority handling
      media: davinci: vpfe: use v4l2_fh for priority handling
      v4l2-pci-skeleton: fix typo while retrieving the skel_buffer
      staging: media: davinci: vpfe: use v4l2_fh for priority handling
      staging: media: davinci: vpfe: release buffers in case start_streaming call back fails

Martin Bugge (2):
      adv7842: update RGB quantization range on HDMI/DVI-D mode irq.
      adv7842: Disable access to EDID DDC lines before chip power up.

Mike Sampson (1):
      next-20140324 drivers/staging/media/sn9c102/sn9c102_hv7131r.c fix style warnings flagged by checkpatch.pl.

ileana@telecom-paristech.fr (1):
      staging: omap24xx: fix coding style

 Documentation/video4linux/v4l2-pci-skeleton.c        |   2 +-
 drivers/media/i2c/adv7842.c                          |  10 +-
 drivers/media/pci/bt8xx/bttv-cards.c                 | 110 +++++++++++++++++
 drivers/media/pci/bt8xx/bttv.h                       |   1 +
 drivers/media/platform/davinci/vpbe_display.c        |  39 ++----
 drivers/media/platform/davinci/vpfe_capture.c        |  13 +-
 drivers/media/usb/gspca/gl860/gl860-mi2020.c         | 464 +++++++++++++++++++++++++++++++++++++++++------------------------------
 drivers/media/v4l2-core/v4l2-ioctl.c                 |  10 +-
 drivers/media/v4l2-core/videobuf2-core.c             | 211 +++++++++++++++++++-------------
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h |   2 -
 drivers/staging/media/davinci_vpfe/vpfe_video.c      |  18 ++-
 drivers/staging/media/davinci_vpfe/vpfe_video.h      |   2 -
 drivers/staging/media/omap24xx/tcm825x.h             |   4 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c      |  23 ++--
 include/media/davinci/vpbe_display.h                 |   6 +-
 include/media/davinci/vpfe_capture.h                 |   6 +-
 include/media/v4l2-device.h                          |   8 ++
 include/media/v4l2-subdev.h                          |   5 -
 include/uapi/linux/v4l2-common.h                     |   2 +-
 19 files changed, 574 insertions(+), 362 deletions(-)
