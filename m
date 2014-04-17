Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38902 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDQONV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 00/49] ADV7611 support
Date: Thu, 17 Apr 2014 16:12:31 +0200
Message-Id: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set implements support for the ADV7611 in the adv7604 driver. It
also comes up with new features such as output format configuration through
pad format operations, hot-plug detect control through GPIO and DT support.

I believe I've addressed all comments received on v3 and picked all the
Acked-by, Reviewed-by and Tested-by tags from the mailing list.

Changes since v3:

- Dropped DT support for ADV7604
- Dropped the ADI-specific DT properties
- Document port nodes in the DT bindings
- Use the OF graph parsing code

Changes since v2:

- Use the same ioctls numbers for DV subdev and video ioctls
- Accept edid == NULL when the number of blocks is 0
- Support digital bus reordering

Changes since v1:

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

Lars-Peter Clausen (4):
  adv7604: Add missing include to linux/types.h
  adv7604: Add support for asynchronous probing
  adv7604: Don't put info string arrays on the stack
  adv7604: Add adv7611 support

Laurent Pinchart (45):
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
  adv7604: Set HPD GPIO direction to output
  adv7604: Mark adv7604_of_id table with __maybe_unused

 Documentation/DocBook/media/v4l/subdev-formats.xml |  760 ++++++++++
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |   27 +-
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |   30 +-
 .../devicetree/bindings/media/i2c/adv7604.txt      |   70 +
 drivers/media/i2c/ad9389b.c                        |   64 +-
 drivers/media/i2c/adv7511.c                        |   66 +-
 drivers/media/i2c/adv7604.c                        | 1468 ++++++++++++++------
 drivers/media/i2c/adv7842.c                        |   14 +-
 drivers/media/i2c/ths8200.c                        |   10 +
 drivers/media/i2c/tvp7002.c                        |    5 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    4 +-
 drivers/media/platform/davinci/vpif_capture.c      |    4 +-
 drivers/media/platform/davinci/vpif_display.c      |    4 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   14 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |    9 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |    8 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   51 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    4 +-
 include/media/adv7604.h                            |  124 +-
 include/media/v4l2-subdev.h                        |    8 +-
 include/uapi/linux/v4l2-mediabus.h                 |   14 +-
 include/uapi/linux/v4l2-subdev.h                   |   40 +-
 include/uapi/linux/videodev2.h                     |   10 +-
 23 files changed, 2188 insertions(+), 620 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt

-- 
Regards,

Laurent Pinchart

