Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3468 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaC1LFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 07:05:47 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2SB5iEJ022650
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 12:05:46 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6574F2A03F2
	for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 12:05:43 +0100 (CET)
Message-ID: <53355787.10700@xs4all.nl>
Date: Fri, 28 Mar 2014 12:05:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8432164ddf7bfe40748ac49995356ab4dfda43b7:

  [media] Sensoray 2255 uses videobuf2 (2014-03-24 17:23:43 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16a

for you to fetch changes up to ea8abd9566c81b496c49cdf2f91165231ded5a2c:

  v4l2-pci-skeleton: fix typo while retrieving the skel_buffer (2014-03-28 11:57:40 +0100)

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

Lad, Prabhakar (3):
      media: davinci: vpbe: use v4l2_fh for priority handling
      media: davinci: vpfe: use v4l2_fh for priority handling
      v4l2-pci-skeleton: fix typo while retrieving the skel_buffer

Martin Bugge (2):
      adv7842: update RGB quantization range on HDMI/DVI-D mode irq.
      adv7842: Disable access to EDID DDC lines before chip power up.

Mike Sampson (1):
      next-20140324 drivers/staging/media/sn9c102/sn9c102_hv7131r.c fix style warnings flagged by checkpatch.pl.

ileana@telecom-paristech.fr (1):
      staging: omap24xx: fix coding style

 Documentation/video4linux/v4l2-pci-skeleton.c   |   2 +-
 drivers/media/i2c/adv7842.c                     |  10 +-
 drivers/media/pci/bt8xx/bttv-cards.c            | 110 ++++++++++++++++++
 drivers/media/pci/bt8xx/bttv.h                  |   1 +
 drivers/media/platform/davinci/vpbe_display.c   |  39 ++-----
 drivers/media/platform/davinci/vpfe_capture.c   |  13 +--
 drivers/media/usb/gspca/gl860/gl860-mi2020.c    | 464 ++++++++++++++++++++++++++++++++++++++++++++--------------------------------
 drivers/media/v4l2-core/v4l2-ioctl.c            |  10 +-
 drivers/media/v4l2-core/videobuf2-core.c        | 211 +++++++++++++++++++++--------------
 drivers/staging/media/omap24xx/tcm825x.h        |   4 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c |  23 ++--
 include/media/davinci/vpbe_display.h            |   6 +-
 include/media/davinci/vpfe_capture.h            |   6 +-
 include/media/v4l2-device.h                     |   8 ++
 include/media/v4l2-subdev.h                     |   5 -
 include/uapi/linux/v4l2-common.h                |   2 +-
 16 files changed, 562 insertions(+), 352 deletions(-)
