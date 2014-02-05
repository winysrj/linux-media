Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4369 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaBERNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 12:13:09 -0500
Message-ID: <52F27105.6020901@xs4all.nl>
Date: Wed, 05 Feb 2014 18:12:37 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 00/47] ADV7611 support
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent!

On 02/05/2014 05:41 PM, Laurent Pinchart wrote:
> Hello,
> 
> This patch set implements support for the ADV7611 in the adv7604 driver. It
> also comes up with new features such as output format configuration through
> pad format operations, hot-plug detect control through GPIO and DT support.
> 
> Patches 06/47 to 27/47 replace the subdev video DV timings query cap and enum
> operations with pad-level equivalents. I've split driver changes in one patch
> per driver to make review easier, but I can squash them together if desired.

For patches 2-5 and 7-26:

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

I have some upcoming comments for patches 6 and 27 and I don't feel qualified
enough to judge patch 1 (unless you ask explicitly).

I will look at the remaining adv7604 patches later. I need to test those on
our hardware, so this will probably going to be next week before I get to them.

Nothing jumped out at me when I quickly read through them, but I didn't
look all that closely.

Regards,

	Hans


> 
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> 
> Lars-Peter Clausen (4):
>   adv7604: Add missing include to linux/types.h
>   adv7604: Add support for asynchronous probing
>   adv7604: Don't put info string arrays on the stack
>   adv7604: Add adv7611 support
> 
> Laurent Pinchart (43):
>   v4l: of: Support empty port nodes
>   v4l: Add UYVY10_2X10 and VYUY10_2X10 media bus pixel codes
>   v4l: Add UYVY10_1X20 and VYUY10_1X20 media bus pixel codes
>   v4l: Add 12-bit YUV 4:2:0 media bus pixel codes
>   v4l: Add 12-bit YUV 4:2:2 media bus pixel codes
>   v4l: Add pad-level DV timings subdev operations
>   ad9389b: Add pad-level DV timings operations
>   adv7511: Add pad-level DV timings operations
>   adv7842: Add pad-level DV timings operations
>   s5p-tv: hdmi: Add pad-level DV timings operations
>   s5p-tv: hdmiphy: Add pad-level DV timings operations
>   ths8200: Add pad-level DV timings operations
>   tvp7002: Add pad-level DV timings operations
>   media: bfin_capture: Switch to pad-level DV operations
>   media: davinci: vpif: Switch to pad-level DV operations
>   media: staging: davinci: vpfe: Switch to pad-level DV operations
>   s5p-tv: mixer: Switch to pad-level DV operations
>   ad9389b: Remove deprecated video-level DV timings operations
>   adv7511: Remove deprecated video-level DV timings operations
>   adv7842: Remove deprecated video-level DV timings operations
>   s5p-tv: hdmi: Remove deprecated video-level DV timings operations
>   s5p-tv: hdmiphy: Remove deprecated video-level DV timings operation
>   ths8200: Remove deprecated video-level DV timings operations
>   tvp7002: Remove deprecated video-level DV timings operations
>   v4l: subdev: Remove deprecated video-level DV timings operations
>   v4l: Improve readability by not wrapping ioctl number #define's
>   v4l: Add support for DV timings ioctls on subdev nodes
>   adv7604: Add 16-bit read functions for CP and HDMI
>   adv7604: Cache register contents when reading multiple bits
>   adv7604: Remove subdev control handlers
>   adv7604: Add sink pads
>   adv7604: Make output format configurable through pad format operations
>   adv7604: Add pad-level DV timings support
>   adv7604: Remove deprecated video-level DV timings operations
>   adv7604: Inline the to_sd function
>   adv7604: Store I2C addresses and clients in arrays
>   adv7604: Replace *_and_or() functions with *_clr_set()
>   adv7604: Sort headers alphabetically
>   adv7604: Control hot-plug detect through a GPIO
>   adv7604: Specify the default input through platform data
>   adv7604: Add DT support
>   adv7604: Add LLC polarity configuration
>   adv7604: Add endpoint properties to DT bindings
> 
>  Documentation/DocBook/media/v4l/subdev-formats.xml |  760 ++++++++++
>  .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |   27 +-
>  .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |   27 +-
>  .../devicetree/bindings/media/i2c/adv7604.txt      |   69 +
>  drivers/media/i2c/ad9389b.c                        |   67 +-
>  drivers/media/i2c/adv7511.c                        |   69 +-
>  drivers/media/i2c/adv7604.c                        | 1465 ++++++++++++++------
>  drivers/media/i2c/adv7842.c                        |   10 +-
>  drivers/media/i2c/ths8200.c                        |   10 +
>  drivers/media/i2c/tvp7002.c                        |    5 +-
>  drivers/media/platform/blackfin/bfin_capture.c     |    4 +-
>  drivers/media/platform/davinci/vpif_capture.c      |    4 +-
>  drivers/media/platform/davinci/vpif_display.c      |    4 +-
>  drivers/media/platform/s5p-tv/hdmi_drv.c           |   14 +-
>  drivers/media/platform/s5p-tv/hdmiphy_drv.c        |    9 +-
>  drivers/media/platform/s5p-tv/mixer_video.c        |    8 +-
>  drivers/media/v4l2-core/v4l2-of.c                  |   52 +-
>  drivers/media/v4l2-core/v4l2-subdev.c              |   15 +
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    |    4 +-
>  include/media/adv7604.h                            |  109 +-
>  include/media/v4l2-subdev.h                        |    8 +-
>  include/uapi/linux/v4l2-mediabus.h                 |   14 +-
>  include/uapi/linux/v4l2-subdev.h                   |   38 +-
>  include/uapi/linux/videodev2.h                     |    8 +-
>  24 files changed, 2164 insertions(+), 636 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt
> 

