Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48718 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaCJXOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 00/48] ADV7611 support
Date: Tue, 11 Mar 2014 00:15:11 +0100
Message-Id: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set implements support for the ADV7611 in the adv7604 driver. It
also comes up with new features such as output format configuration through
pad format operations, hot-plug detect control through GPIO and DT support.

Patches 06/48 to 24/48 and 39/48 replace the subdev video DV timings query cap
and enum operations with pad-level equivalents. I've split driver changes in
one patch per driver to make review easier, but I can squash them together if
desired.

I believe I've addressed all comments received on v1, except the one related
to op_ch_sel in patch "adv7604: Make output format configurable through pad
format operations" which is still open for discussion.

Patches 02/48 to 05/48 have been acked in v1 already, I will send a pull
request for them separately if a v3 of this series ends up being needed. I'd
like to get patch 01/48 upstream soon as well.

Changes compared to v1:

- Check the edid and pad fields for various ioctls in the subdev core
- Switch to the descriptor-based GPIO API
- Leave enum adv7604_pad in header file
- Keep the hotplug notifier
- Fix compilation breakage when !CONFIG_OF due to directly dereferencing the
  return value of of_match_node()
- Move patch "v4l: subdev: Remove deprecated video-level DV timings
  operations" later in the series to avoid bisection breakages
- Document struct v4l2_enum_dv_timings reserved field as being set to 0 by
  both drivers and application
- Document pad field of struct v4l2_enum_dv_timings and struct
  v4l2_dv_timings_cap as being used for subdev nodes only
- Typo fixes in documentation

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Lars-Peter Clausen (4):
  adv7604: Add missing include to linux/types.h
  adv7604: Add support for asynchronous probing
  adv7604: Don't put info string arrays on the stack
  adv7604: Add adv7611 support

Laurent Pinchart (44):
  v4l: of: Support empty port nodes
  v4l: Add UYVY10_2X10 and VYUY10_2X10 media bus pixel codes
  v4l: Add UYVY10_1X20 and VYUY10_1X20 media bus pixel codes
  v4l: Add 12-bit YUV 4:2:0 media bus pixel codes
  v4l: Add 12-bit YUV 4:2:2 media bus pixel codes
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

 Documentation/DocBook/media/v4l/subdev-formats.xml |  760 +++++++++++
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |   27 +-
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |   30 +-
 .../devicetree/bindings/media/i2c/adv7604.txt      |   69 +
 drivers/media/i2c/ad9389b.c                        |   65 +-
 drivers/media/i2c/adv7511.c                        |   67 +-
 drivers/media/i2c/adv7604.c                        | 1440 ++++++++++++++------
 drivers/media/i2c/adv7842.c                        |   14 +-
 drivers/media/i2c/ths8200.c                        |   10 +
 drivers/media/i2c/tvp7002.c                        |    5 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    4 +-
 drivers/media/platform/davinci/vpif_capture.c      |    4 +-
 drivers/media/platform/davinci/vpif_display.c      |    4 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   14 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |    9 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    8 +-
 drivers/media/v4l2-core/v4l2-of.c                  |   52 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   51 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    4 +-
 include/media/adv7604.h                            |  113 +-
 include/media/v4l2-subdev.h                        |    8 +-
 include/uapi/linux/v4l2-mediabus.h                 |   14 +-
 include/uapi/linux/v4l2-subdev.h                   |   38 +-
 include/uapi/linux/videodev2.h                     |   10 +-
 24 files changed, 2174 insertions(+), 646 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt

-- 
Regards,

Laurent Pinchart

