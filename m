Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41037 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaEYPUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 11:20:44 -0400
Received: from avalon.localnet (unknown [91.178.188.60])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id F10F535A40
	for <linux-media@vger.kernel.org>; Sun, 25 May 2014 17:20:33 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v3 FOR v3.16] adv7604: ADV7611 and DT support
Date: Sun, 25 May 2014 17:20:59 +0200
Message-ID: <1679986.yM2mPfH6om@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 85ac1a1772bb41da895bad83a81f6a62c8f293f6:

  [media] media: stk1160: Avoid stack-allocated buffer for control URBs 
(2014-05-24 17:12:11 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git linuxtv/adv7611

for you to fetch changes up to 3fee381b76a6e350efa376f092440ffe2ecea3a3:

  adv7604: Set HPD GPIO direction to output (2014-05-25 16:37:28 +0200)

Compared to v2, the series has been rebased on top of your latest master 
branch (four patches already merged have thus been dropped) and all commits 
now have a commit message body.

----------------------------------------------------------------
Lars-Peter Clausen (4):
      adv7604: Add missing include to linux/types.h
      adv7604: Add support for asynchronous probing
      adv7604: Don't put info string arrays on the stack
      adv7604: Add adv7611 support

Laurent Pinchart (40):
      v4l: Add pad-level DV timings subdev operations
      ad9389b: Add pad-level DV timings operations
      adv7511: Add pad-level DV timings operations
      adv7842: Add pad-level DV timings operations
      s5p-tv: hdmi: Add pad-level DV timings operations
      s5p-tv: hdmiphy: Add pad-level DV timings operations
      ths8200: Add pad-level DV timings operations
      tvp7002: Add pad-level DV timings operations
      media: bfin_capture: Switch to pad-level DV operations
      media: davinci: vpif: Switch to pad-level DV operations
      media: staging: davinci: vpfe: Switch to pad-level DV operations
      s5p-tv: mixer: Switch to pad-level DV operations
      ad9389b: Remove deprecated video-level DV timings operations
      adv7511: Remove deprecated video-level DV timings operations
      adv7842: Remove deprecated video-level DV timings operations
      s5p-tv: hdmi: Remove deprecated video-level DV timings operations
      s5p-tv: hdmiphy: Remove deprecated video-level DV timings operation
      ths8200: Remove deprecated video-level DV timings operations
      tvp7002: Remove deprecated video-level DV timings operations
      v4l: Improve readability by not wrapping ioctl number #define's
      v4l: Add support for DV timings ioctls on subdev nodes
      v4l: Validate fields in the core code for subdev EDID ioctls
      adv7604: Add 16-bit read functions for CP and HDMI
      adv7604: Cache register contents when reading multiple bits
      adv7604: Remove subdev control handlers
      adv7604: Add sink pads
      adv7604: Make output format configurable through pad format operations
      adv7604: Add pad-level DV timings support
      adv7604: Remove deprecated video-level DV timings operations
      v4l: subdev: Remove deprecated video-level DV timings operations
      adv7604: Inline the to_sd function
      adv7604: Store I2C addresses and clients in arrays
      adv7604: Replace *_and_or() functions with *_clr_set()
      adv7604: Sort headers alphabetically
      adv7604: Support hot-plug detect control through a GPIO
      adv7604: Specify the default input through platform data
      adv7604: Add DT support
      adv7604: Add LLC polarity configuration
      adv7604: Add endpoint properties to DT bindings
      adv7604: Set HPD GPIO direction to output

 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml         |   27 +-
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml        |   30 +-
 Documentation/devicetree/bindings/media/i2c/adv7604.txt |   70 ++
 drivers/media/i2c/ad9389b.c                             |   64 +-
 drivers/media/i2c/adv7511.c                             |   66 +-
 drivers/media/i2c/adv7604.c                             | 1468 +++++++++-----
 drivers/media/i2c/adv7842.c                             |   14 +-
 drivers/media/i2c/ths8200.c                             |   10 +
 drivers/media/i2c/tvp7002.c                             |    5 +-
 drivers/media/platform/blackfin/bfin_capture.c          |    4 +-
 drivers/media/platform/davinci/vpif_capture.c           |    4 +-
 drivers/media/platform/davinci/vpif_display.c           |    4 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c                |   14 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c             |    9 +-
 drivers/media/platform/s5p-tv/mixer_video.c             |    8 +-
 drivers/media/v4l2-core/v4l2-subdev.c                   |   51 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c         |    4 +-
 include/media/adv7604.h                                 |  124 +-
 include/media/v4l2-subdev.h                             |    8 +-
 include/uapi/linux/v4l2-subdev.h                        |   40 +-
 include/uapi/linux/videodev2.h                          |   10 +-
 21 files changed, 1415 insertions(+), 619 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt

-- 
Regards,

Laurent Pinchart

