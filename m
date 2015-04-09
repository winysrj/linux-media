Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57486 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932786AbbDIKVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 06:21:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kamil Debski <k.debski@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/7] v4l2: convert video ops to pad ops
Date: Thu,  9 Apr 2015 12:21:21 +0200
Message-Id: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts duplicate video ops to pad ops.

Patches 1-6 convert enum/g/try/s_mbus_fmt and patch 7 converts
g/s_crop and cropcap.

Patch 7 has been posted before:

http://www.spinics.net/lists/linux-media/msg84776.html

Patch 7 remains an RFC since I still have not been able to test this
on actual hardware.

Note that the calls to set_fmt(V4L2_SUBDEV_FORMAT_TRY) in bridge drivers
all assume that pad is 0. Which is actually true for these specific
drivers, but may not be true in the future. In that case the
struct v4l2_subdev_pad_config pad_cfg local variable should become an
array of at least (pad + 1) elements.

But we'll handle that when we need it.

My intention is to get patches 1-6 in for 4.2, preferably asap to get
as much testing time as possible. These patches touch on many drivers
so the sooner they are merged, the easier it is for developers to work
on top of them.

The moral of the story: never accept patches that add duplicate ops
without removing the old ones as well. It seems that every time I end
up being the sucker that does the work, and it is a really boring and
unpleasant job. Next time I'll Nack such patches.

Regards,

	Hans

Hans Verkuil (7):
  v4l2: replace enum_mbus_fmt by enum_mbus_code
  v4l2: replace video op g_mbus_fmt by pad op get_fmt
  v4l2: replace try_mbus_fmt by set_fmt
  v4l2: replace s_mbus_fmt by set_fmt
  v4l2: replace try_mbus_fmt by set_fmt in bridge drivers
  v4l2: replace s_mbus_fmt by set_fmt in bridge drivers
  v4l2: remove g/s_crop and cropcap from video ops

 drivers/media/i2c/adv7170.c                        |  42 ++++--
 drivers/media/i2c/adv7175.c                        |  42 ++++--
 drivers/media/i2c/adv7183.c                        |  61 ++++----
 drivers/media/i2c/adv7842.c                        |  25 ++--
 drivers/media/i2c/ak881x.c                         |  67 +++++----
 drivers/media/i2c/cx25840/cx25840-core.c           |  15 +-
 drivers/media/i2c/ml86v7667.c                      |  29 ++--
 drivers/media/i2c/mt9v011.c                        |  53 +++----
 drivers/media/i2c/ov7670.c                         |  38 ++---
 drivers/media/i2c/saa6752hs.c                      |  42 ++++--
 drivers/media/i2c/saa7115.c                        |  16 ++-
 drivers/media/i2c/saa717x.c                        |  16 ++-
 drivers/media/i2c/soc_camera/imx074.c              | 108 +++++++-------
 drivers/media/i2c/soc_camera/mt9m001.c             | 113 +++++++++------
 drivers/media/i2c/soc_camera/mt9m111.c             | 114 ++++++++-------
 drivers/media/i2c/soc_camera/mt9t031.c             | 126 +++++++++-------
 drivers/media/i2c/soc_camera/mt9t112.c             | 101 ++++++++-----
 drivers/media/i2c/soc_camera/mt9v022.c             | 111 ++++++++------
 drivers/media/i2c/soc_camera/ov2640.c              | 103 ++++++-------
 drivers/media/i2c/soc_camera/ov5642.c              | 113 ++++++++-------
 drivers/media/i2c/soc_camera/ov6650.c              | 117 ++++++++-------
 drivers/media/i2c/soc_camera/ov772x.c              |  85 ++++++-----
 drivers/media/i2c/soc_camera/ov9640.c              |  73 +++++-----
 drivers/media/i2c/soc_camera/ov9740.c              |  76 +++++-----
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          | 118 +++++++--------
 drivers/media/i2c/soc_camera/tw9910.c              |  88 ++++++------
 drivers/media/i2c/sr030pc30.c                      |  62 ++++----
 drivers/media/i2c/tvp514x.c                        |  55 +------
 drivers/media/i2c/tvp5150.c                        | 111 +++++++-------
 drivers/media/i2c/tvp7002.c                        |  48 -------
 drivers/media/i2c/vs6624.c                         |  55 +++----
 drivers/media/pci/cx18/cx18-av-core.c              |  16 ++-
 drivers/media/pci/cx18/cx18-controls.c             |  13 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |  12 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  12 +-
 drivers/media/pci/ivtv/ivtv-controls.c             |  12 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  12 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |  32 +++--
 drivers/media/platform/am437x/am437x-vpfe.c        |  25 +---
 drivers/media/platform/blackfin/bfin_capture.c     |  40 ++++--
 drivers/media/platform/davinci/vpfe_capture.c      |  19 +--
 drivers/media/platform/marvell-ccic/mcam-core.c    |  19 ++-
 drivers/media/platform/omap3isp/ispvideo.c         |  88 ++++++++----
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  12 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |  15 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |  14 +-
 drivers/media/platform/sh_vou.c                    |  74 +++++-----
 drivers/media/platform/soc_camera/atmel-isi.c      |  74 +++++-----
 drivers/media/platform/soc_camera/mx2_camera.c     | 131 +++++++++--------
 drivers/media/platform/soc_camera/mx3_camera.c     | 123 +++++++++-------
 drivers/media/platform/soc_camera/omap1_camera.c   | 119 ++++++++-------
 drivers/media/platform/soc_camera/pxa_camera.c     | 116 ++++++++-------
 drivers/media/platform/soc_camera/rcar_vin.c       | 135 +++++++++--------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 147 ++++++++++---------
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  35 +++--
 drivers/media/platform/soc_camera/soc_camera.c     | 160 ++++++++-------------
 .../platform/soc_camera/soc_camera_platform.c      |  69 +++++----
 drivers/media/platform/soc_camera/soc_scale_crop.c | 122 +++++++++-------
 drivers/media/platform/soc_camera/soc_scale_crop.h |   6 +-
 drivers/media/platform/via-camera.c                |  19 ++-
 drivers/media/usb/cx231xx/cx231xx-417.c            |  12 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |  23 +--
 drivers/media/usb/em28xx/em28xx-camera.c           |  12 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |  12 +-
 drivers/media/usb/go7007/s2250-board.c             |  18 ++-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  17 ++-
 drivers/staging/media/omap4iss/iss_video.c         |  88 ++++++++----
 include/media/soc_camera.h                         |   7 +-
 include/media/v4l2-subdev.h                        |  19 ---
 69 files changed, 2241 insertions(+), 1861 deletions(-)

-- 
2.1.4

