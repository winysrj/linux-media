Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34216 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934050AbaCTOxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Mar 2014 10:53:05 -0400
Received: from avalon.localnet (121.146-246-81.adsl-dyn.isp.belgacom.be [81.246.146.121])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8768B35A46
	for <linux-media@vger.kernel.org>; Thu, 20 Mar 2014 15:51:41 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.16] adv7604: ADV7611 and DT support
Date: Thu, 20 Mar 2014 15:54:52 +0100
Message-ID: <3388754.gTFlgI0OQb@avalon>
In-Reply-To: <1705609.TZWuxThU0g@avalon>
References: <1705609.TZWuxThU0g@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pull request was missing a proper subject, here it is. Sorry.

On Thursday 20 March 2014 15:36:40 Laurent Pinchart wrote:
> Hi Mauro,
> 
> The following changes since commit ed97a6fe5308e5982d118a25f0697b791af5ec50:
> 
>   [media] af9033: Don't export functions for the hardware filter (2014-03-14
> 20:26:59 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/pinchartl/media.git adv7611
> 
> for you to fetch changes up to 240801bf4f2ca98bd41b45a186330797048529af:
> 
>   adv7604: Add endpoint properties to DT bindings (2014-03-20 15:33:50
> +0100)
> 
> ----------------------------------------------------------------
> Lars-Peter Clausen (4):
>       adv7604: Add missing include to linux/types.h
>       adv7604: Add support for asynchronous probing
>       adv7604: Don't put info string arrays on the stack
>       adv7604: Add adv7611 support
> 
> Laurent Pinchart (43):
>       v4l: Add UYVY10_2X10 and VYUY10_2X10 media bus pixel codes
>       v4l: Add UYVY10_1X20 and VYUY10_1X20 media bus pixel codes
>       v4l: Add 12-bit YUV 4:2:0 media bus pixel codes
>       v4l: Add 12-bit YUV 4:2:2 media bus pixel codes
>       v4l: Add pad-level DV timings subdev operations
>       ad9389b: Add pad-level DV timings operations
>       adv7511: Add pad-level DV timings operations
>       adv7842: Add pad-level DV timings operations
>       s5p-tv: hdmi: Add pad-level DV timings operations
>       s5p-tv: hdmiphy: Add pad-level DV timings operations
>       ths8200: Add pad-level DV timings operations
>       tvp7002: Add pad-level DV timings operations
>       media: bfin_capture: Switch to pad-level DV operations
>       media: davinci: vpif: Switch to pad-level DV operations
>       media: staging: davinci: vpfe: Switch to pad-level DV operations
>       s5p-tv: mixer: Switch to pad-level DV operations
>       ad9389b: Remove deprecated video-level DV timings operations
>       adv7511: Remove deprecated video-level DV timings operations
>       adv7842: Remove deprecated video-level DV timings operations
>       s5p-tv: hdmi: Remove deprecated video-level DV timings operations
>       s5p-tv: hdmiphy: Remove deprecated video-level DV timings operation
>       ths8200: Remove deprecated video-level DV timings operations
>       tvp7002: Remove deprecated video-level DV timings operations
>       v4l: Improve readability by not wrapping ioctl number #define's
>       v4l: Add support for DV timings ioctls on subdev nodes
>       v4l: Validate fields in the core code for subdev EDID ioctls
>       adv7604: Add 16-bit read functions for CP and HDMI
>       adv7604: Cache register contents when reading multiple bits
>       adv7604: Remove subdev control handlers
>       adv7604: Add sink pads
>       adv7604: Make output format configurable through pad format operations
> adv7604: Add pad-level DV timings support
>       adv7604: Remove deprecated video-level DV timings operations
>       v4l: subdev: Remove deprecated video-level DV timings operations
>       adv7604: Inline the to_sd function
>       adv7604: Store I2C addresses and clients in arrays
>       adv7604: Replace *_and_or() functions with *_clr_set()
>       adv7604: Sort headers alphabetically
>       adv7604: Support hot-plug detect control through a GPIO
>       adv7604: Specify the default input through platform data
>       adv7604: Add DT support
>       adv7604: Add LLC polarity configuration
>       adv7604: Add endpoint properties to DT bindings
> 
>  Documentation/DocBook/media/v4l/subdev-formats.xml      |  760 ++++++++++++
> .../DocBook/media/v4l/vidioc-dv-timings-cap.xml         |   27 +-
> .../DocBook/media/v4l/vidioc-enum-dv-timings.xml        |   30 +-
> Documentation/devicetree/bindings/media/i2c/adv7604.txt |   69 ++
> drivers/media/i2c/ad9389b.c                             |   64 +-
> drivers/media/i2c/adv7511.c                             |   66 +-
> drivers/media/i2c/adv7604.c                             | 1478
> +++++++++----- drivers/media/i2c/adv7842.c                             |  
> 14 +- drivers/media/i2c/ths8200.c                             |   10 +
>  drivers/media/i2c/tvp7002.c                             |    5 +-
>  drivers/media/platform/blackfin/bfin_capture.c          |    4 +-
>  drivers/media/platform/davinci/vpif_capture.c           |    4 +-
>  drivers/media/platform/davinci/vpif_display.c           |    4 +-
>  drivers/media/platform/s5p-tv/hdmi_drv.c                |   14 +-
>  drivers/media/platform/s5p-tv/hdmiphy_drv.c             |    9 +-
>  drivers/media/platform/s5p-tv/mixer_video.c             |    8 +-
>  drivers/media/v4l2-core/v4l2-subdev.c                   |   51 +-
>  drivers/staging/media/davinci_vpfe/vpfe_video.c         |    4 +-
>  include/media/adv7604.h                                 |  124 +-
>  include/media/v4l2-subdev.h                             |    8 +-
>  include/uapi/linux/v4l2-mediabus.h                      |   14 +-
>  include/uapi/linux/v4l2-subdev.h                        |   40 +-
>  include/uapi/linux/videodev2.h                          |   10 +-
>  23 files changed, 2197 insertions(+), 620 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt

-- 
Regards,

Laurent Pinchart

