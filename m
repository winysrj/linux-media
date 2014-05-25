Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:17287 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaEYNUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 09:20:54 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N64000I8T2S6250@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 25 May 2014 09:20:52 -0400 (EDT)
Date: Sun, 25 May 2014 10:20:47 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL v2 FOR v3.16] adv7604: ADV7611 and DT support
Message-id: <20140525102047.2b4f646f.m.chehab@samsung.com>
In-reply-to: <8637874.bCfaXJPXZf@avalon>
References: <8637874.bCfaXJPXZf@avalon>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Apr 2014 21:48:31 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:
> 
>   [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/pinchartl/media.git linuxtv/adv7611
> 
> for you to fetch changes up to 89d3226804151fb97049ecc2170ea46aaa6f7f60:
> 
>   adv7604: Set HPD GPIO direction to output (2014-04-28 21:03:58 +0200)
> 
> ----------------------------------------------------------------
> Lars-Peter Clausen (4):
>       adv7604: Add missing include to linux/types.h
>       adv7604: Add support for asynchronous probing

-ENODESCRIPTION. Please add a proper description to each patch.

>       adv7604: Don't put info string arrays on the stack
>       adv7604: Add adv7611 support
> 
> Laurent Pinchart (44):
>       v4l: Add UYVY10_2X10 and VYUY10_2X10 media bus pixel codes
>       v4l: Add UYVY10_1X20 and VYUY10_1X20 media bus pixel codes
>       v4l: Add 12-bit YUV 4:2:0 media bus pixel codes
>       v4l: Add 12-bit YUV 4:2:2 media bus pixel codes

The above 4 patches seem to be already applied. Btw, next time,
please add a patch description. Among other things, that would
save me some time to identify that this is duplicated stuff that
were merged previously via some other pull request.

>       v4l: Add pad-level DV timings subdev operations

What do you have against properly documenting a patch?
Please write some lines describing why this API change is needed,
and how it was implemented. 

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

-ENODESCRIPTION. Please add a proper description to each patch.

>       adv7604: Cache register contents when reading multiple bits
>       adv7604: Remove subdev control handlers
>       adv7604: Add sink pads
>       adv7604: Make output format configurable through pad format operations
>       adv7604: Add pad-level DV timings support
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
>       adv7604: Set HPD GPIO direction to output
> 
>  Documentation/DocBook/media/v4l/subdev-formats.xml      |  760 ++++++++++++
>  .../DocBook/media/v4l/vidioc-dv-timings-cap.xml         |   27 +-
>  .../DocBook/media/v4l/vidioc-enum-dv-timings.xml        |   30 +-
>  Documentation/devicetree/bindings/media/i2c/adv7604.txt |   70 ++
>  drivers/media/i2c/ad9389b.c                             |   64 +-
>  drivers/media/i2c/adv7511.c                             |   66 +-
>  drivers/media/i2c/adv7604.c                             | 1468 ++++++++++----
>  drivers/media/i2c/adv7842.c                             |   14 +-
>  drivers/media/i2c/ths8200.c                             |   10 +
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
>  23 files changed, 2188 insertions(+), 620 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt
> 

There are other patches in this series lacking a proper description.

Please document them.

While here, please remove the 4 already applied patches from this series.

Thanks!
Mauro.
