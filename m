Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58076 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbbDUNcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:32:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 71AB32A0089
	for <linux-media@vger.kernel.org>; Tue, 21 Apr 2015 15:31:56 +0200 (CEST)
Message-ID: <5536514C.40501@xs4all.nl>
Date: Tue, 21 Apr 2015 15:31:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Replace most duplicate video ops by pad ops
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches replace most duplicate video ops by their pad ops counterparts.
The only remaining duplicate ops deal with cropping and selection, and I want
to be able to test that first. I have difficulty doing that, but I am
expecting hardware in the near future that should enable me to do this work.

These six patches replace the *_mbus_fmt video ops by their pad ops versions.

While not particularly complex, this does cause a lot of unavoidable churn,
so I would like to get this merged early in the 4.2 cycle to get the maximum
testing time.

This work just has to be done, since duplication of ops defeats the whole purpose
of reusability.

The patches in this pull request are identical to patches 1-6 of this post,
except that patch 1 has a trivial bug fix that Guennadi found:

http://www.spinics.net/lists/linux-media/msg88549.html

Regards,

	Hans

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2b

for you to fetch changes up to a3912adac27072237c62f479c581d00f41ef2a46:

  v4l2: replace s_mbus_fmt by set_fmt in bridge drivers (2015-04-21 15:23:33 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      v4l2: replace enum_mbus_fmt by enum_mbus_code
      v4l2: replace video op g_mbus_fmt by pad op get_fmt
      v4l2: replace try_mbus_fmt by set_fmt
      v4l2: replace s_mbus_fmt by set_fmt
      v4l2: replace try_mbus_fmt by set_fmt in bridge drivers
      v4l2: replace s_mbus_fmt by set_fmt in bridge drivers

 drivers/media/i2c/adv7170.c                              |  42 +++++++++++++++++--------
 drivers/media/i2c/adv7175.c                              |  42 +++++++++++++++++--------
 drivers/media/i2c/adv7183.c                              |  61 +++++++++++++++++++++---------------
 drivers/media/i2c/adv7842.c                              |  25 +++++++++------
 drivers/media/i2c/ak881x.c                               |  39 +++++++++++------------
 drivers/media/i2c/cx25840/cx25840-core.c                 |  15 +++++++--
 drivers/media/i2c/ml86v7667.c                            |  29 +++++++++++------
 drivers/media/i2c/mt9v011.c                              |  53 ++++++++++++++++---------------
 drivers/media/i2c/ov7670.c                               |  38 ++++++++++++----------
 drivers/media/i2c/saa6752hs.c                            |  42 ++++++++++++++++---------
 drivers/media/i2c/saa7115.c                              |  16 ++++++++--
 drivers/media/i2c/saa717x.c                              |  16 ++++++++--
 drivers/media/i2c/soc_camera/imx074.c                    |  66 ++++++++++++++++++++------------------
 drivers/media/i2c/soc_camera/mt9m001.c                   |  43 +++++++++++++++++--------
 drivers/media/i2c/soc_camera/mt9m111.c                   |  57 ++++++++++++++++++---------------
 drivers/media/i2c/soc_camera/mt9t031.c                   |  74 +++++++++++++++++++++++++------------------
 drivers/media/i2c/soc_camera/mt9t112.c                   |  41 +++++++++++++++++-------
 drivers/media/i2c/soc_camera/mt9v022.c                   |  43 +++++++++++++++++--------
 drivers/media/i2c/soc_camera/ov2640.c                    |  62 +++++++++++++++++-------------------
 drivers/media/i2c/soc_camera/ov5642.c                    |  60 ++++++++++++++++++-----------------
 drivers/media/i2c/soc_camera/ov6650.c                    |  43 +++++++++++++++++--------
 drivers/media/i2c/soc_camera/ov772x.c                    |  41 +++++++++++++++++-------
 drivers/media/i2c/soc_camera/ov9640.c                    |  32 +++++++++++++------
 drivers/media/i2c/soc_camera/ov9740.c                    |  35 ++++++++++++++-------
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                |  66 +++++++++++++++++++-------------------
 drivers/media/i2c/soc_camera/tw9910.c                    |  41 +++++++++++++++++-------
 drivers/media/i2c/sr030pc30.c                            |  62 ++++++++++++++++++++----------------
 drivers/media/i2c/tvp514x.c                              |  55 ++------------------------------
 drivers/media/i2c/tvp5150.c                              |  30 +++++++++++-------
 drivers/media/i2c/tvp7002.c                              |  48 ----------------------------
 drivers/media/i2c/vs6624.c                               |  55 ++++++++++++++++++--------------
 drivers/media/pci/cx18/cx18-av-core.c                    |  16 ++++++++--
 drivers/media/pci/cx18/cx18-controls.c                   |  13 +++++---
 drivers/media/pci/cx18/cx18-ioctl.c                      |  12 ++++---
 drivers/media/pci/cx23885/cx23885-video.c                |  12 ++++---
 drivers/media/pci/ivtv/ivtv-controls.c                   |  12 ++++---
 drivers/media/pci/ivtv/ivtv-ioctl.c                      |  12 ++++---
 drivers/media/pci/saa7134/saa7134-empress.c              |  32 ++++++++++++-------
 drivers/media/platform/am437x/am437x-vpfe.c              |  25 ++++-----------
 drivers/media/platform/blackfin/bfin_capture.c           |  40 ++++++++++++++---------
 drivers/media/platform/davinci/vpfe_capture.c            |  19 ++++++-----
 drivers/media/platform/marvell-ccic/mcam-core.c          |  19 ++++++-----
 drivers/media/platform/s5p-tv/hdmi_drv.c                 |  12 +++++--
 drivers/media/platform/s5p-tv/mixer_drv.c                |  15 ++++++---
 drivers/media/platform/s5p-tv/sdo_drv.c                  |  14 +++++++--
 drivers/media/platform/sh_vou.c                          |  61 +++++++++++++++++++-----------------
 drivers/media/platform/soc_camera/atmel-isi.c            |  74 ++++++++++++++++++++++++-------------------
 drivers/media/platform/soc_camera/mx2_camera.c           | 113 ++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/media/platform/soc_camera/mx3_camera.c           | 105 ++++++++++++++++++++++++++++++++++---------------------------
 drivers/media/platform/soc_camera/omap1_camera.c         | 106 ++++++++++++++++++++++++++++++++++---------------------------
 drivers/media/platform/soc_camera/pxa_camera.c           |  99 ++++++++++++++++++++++++++++++++-------------------------
 drivers/media/platform/soc_camera/rcar_vin.c             | 109 +++++++++++++++++++++++++++++++++++----------------------------
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 115 +++++++++++++++++++++++++++++++++++++------------------------------
 drivers/media/platform/soc_camera/sh_mobile_csi2.c       |  35 ++++++++++-----------
 drivers/media/platform/soc_camera/soc_camera.c           |  30 +++++++++++-------
 drivers/media/platform/soc_camera/soc_camera_platform.c  |  24 ++++++++------
 drivers/media/platform/soc_camera/soc_scale_crop.c       |  37 ++++++++++++----------
 drivers/media/platform/via-camera.c                      |  19 ++++++-----
 drivers/media/usb/cx231xx/cx231xx-417.c                  |  12 ++++---
 drivers/media/usb/cx231xx/cx231xx-video.c                |  23 ++++++++------
 drivers/media/usb/em28xx/em28xx-camera.c                 |  12 ++++---
 drivers/media/usb/go7007/go7007-v4l2.c                   |  12 ++++---
 drivers/media/usb/go7007/s2250-board.c                   |  18 +++++++++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                  |  17 +++++-----
 include/media/v4l2-subdev.h                              |  16 ----------
 65 files changed, 1511 insertions(+), 1151 deletions(-)
