Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56057 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbcB2Jwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 04:52:32 -0500
Subject: Re: [PATCHv2] [media] rcar-vin: add Renesas R-Car VIN driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ulrich.hecht@gmail.com
References: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D414D9.4090303@xs4all.nl>
Date: Mon, 29 Feb 2016 10:52:25 +0100
MIME-Version: 1.0
In-Reply-To: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thanks for your patch! Much appreciated.

I have more comments for the v2, but nothing really big :-)

One high-level comment I have is that you should create an rcar-v4l2.c (or video.c)
source where all the v4l2 ioctls and file ops reside.

Most of what is in rcar-dma has nothing to do with dma. That's only the vb2
ops and the interrupt handler.

I think that should make the driver code a lot easier to navigate.

On 02/24/2016 03:58 AM, Niklas Söderlund wrote:
> A V4L2 driver for Renesas R-Car VIN driver that do not depend on
> soc_camera. The driver is heavily based on its predecessor and aims to
> replace it.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
> 
> The driver is tested on Koelsch and can do streaming using qv4l2 and
> grab frames using yavta. It passes a v4l2-compliance (git master) run
> without failures, see bellow for output. Some issues I know about but
> will have to wait for future work in other patches.
>  - The soc_camera driver provides some pixel formats that do not display
>    properly for me in qv4l2 or yavta. I have ported these formats as is
>    (not working correctly?) to the new driver.
>  - One can not bind/unbind the subdevice and continue using the driver.
> 
> As stated in commit message the driver is based on its soc_camera
> version but some features have been drooped (for now?).
>  - The driver no longer try to use the subdev for cropping (using
>    cropcrop/s_crop).

The vin driver now does the cropping, right? Which makes perfect sense
to me. The feature is still there, just done differently.

>  - Do not interrogate the subdev using g_mbus_config.

And that's because we can now rely on what the device tree gives us, right?

> 
> The goal is to replace the soc_camera driver completely to prepare for
> Gen3 enablement. I have therefor chosen to inherit the
> CONFIG_VIDEO_RCAR_VIN name for this new driver and renamed the
> soc_camera driver CONFIG_VIDEO_RCAR_VIN_OLD.
> 
> * Changes since RFC/PATCH
> - Fixed review comments from Hans Verkuil, thanks for reviewing.
> - Added vidioc_[gs]_selection crop and composition is supported. Thanks
>   Laurent for taking the time and explaining to me how to do
>   composition.
> - Reworked the DMA flow to better support single and continues frame
>   grabbing mode.
> - Dropped a lot of the formats that was ported from soc_camera, once I
>   looked at it in a working driver it was obvious that the rcar_vin
>   soc_camera driver did not support them.
> - Added better comments for the core structs
> - Fixed copyright in file headers
> - A lot more testing.
> 
> # ./v4l2-compliance -d 27 -s -f
> Driver Info:
> 	Driver name   : rcar_vin
> 	Card type     : R_Car_VIN
> 	Bus info      : platform:e6ef1000.video
> 	Driver version: 4.5.0
> 	Capabilities  : 0x85200001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps   : 0x05200001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 
> Compliance test for device /dev/video27 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> 	test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 	test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
> 	Control ioctls:
> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
> 		test VIDIOC_QUERYCTRL: OK
> 		test VIDIOC_G/S_CTRL: OK
> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 		Standard Controls: 5 Private Controls: 1
> 
> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		test VIDIOC_G/S_PARM: OK (Not Supported)
> 		test VIDIOC_G_FBUF: OK (Not Supported)
> 		test VIDIOC_G_FMT: OK
> 		test VIDIOC_TRY_FMT: OK
> 		test VIDIOC_S_FMT: OK
> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 		test Cropping: OK
> 		test Composing: OK
> 		test Scaling: OK
> 
> 	Codec ioctls:
> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> 	Buffer ioctls:
> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 		test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Streaming ioctls:
> 	test read/write: OK
> 	test MMAP: OK
> 	test USERPTR: OK (Not Supported)
> 	test DMABUF: Cannot test, specify --expbuf-device
> 
> Stream using all formats:
> 	test MMAP for Format NV16, Frame Size 2x4:
> 		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
> 		Crop 6x4@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced, SelTest: OK
> 		Crop 6x4@0x0, Compose 2x2@0x0, Stride 4, Field Interlaced, SelTest: OK
> 		Crop 720x576@0x0, Compose 2x2@0x0, Stride 4, Field Interlaced, SelTest: OK
> 	test MMAP for Format NV16, Frame Size 2048x2048:
> 		Crop 6x4@0x0, Compose 6x4@0x0, Stride 4096, Field Interlaced: OK
> 		Crop 6x4@0x0, Compose 6x2@0x0, Stride 4096, Field Interlaced, SelTest: OK
> 		Crop 720x576@0x0, Compose 6x4@0x0, Stride 4096, Field Interlaced, SelTest: OK
> 		Crop 720x576@0x0, Compose 6x2@0x0, Stride 4096, Field Interlaced, SelTest: OK
> 		Crop 6x4@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced, SelTest: OK
> 		Crop 720x576@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced, SelTest: OK
> 	test MMAP for Format NV16, Frame Size 720x576:
> 		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OK
> 		Crop 6x4@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced, SelTest: OK
> 		Crop 6x4@0x0, Compose 6x2@0x0, Stride 1440, Field Interlaced, SelTest: OK
> 		Crop 720x576@0x0, Compose 6x2@0x0, Stride 1440, Field Interlaced, SelTest: OK
> 	test MMAP for Format YUYV, Frame Size 2x4:
> 		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
> 	test MMAP for Format YUYV, Frame Size 2048x2048:
> 		Crop 6x4@0x0, Compose 6x4@0x0, Stride 4096, Field Interlaced: OK
> 	test MMAP for Format YUYV, Frame Size 720x576:
> 		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OK
> 	test MMAP for Format UYVY, Frame Size 2x4:
> 		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
> 	test MMAP for Format UYVY, Frame Size 2048x2048:
> 		Crop 6x4@0x0, Compose 6x4@0x0, Stride 4096, Field Interlaced: OK
> 	test MMAP for Format UYVY, Frame Size 720x576:
> 		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OK
> 	test MMAP for Format RGBP, Frame Size 2x4:
> 		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
> 	test MMAP for Format RGBP, Frame Size 2048x2048:
> 		Crop 6x4@0x0, Compose 6x4@0x0, Stride 4096, Field Interlaced: OK
> 	test MMAP for Format RGBP, Frame Size 720x576:
> 		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OK
> 	test MMAP for Format RGBQ, Frame Size 2x4:
> 		Crop 720x576@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK
> 	test MMAP for Format RGBQ, Frame Size 2048x2048:
> 		Crop 6x4@0x0, Compose 6x4@0x0, Stride 4096, Field Interlaced: OK
> 	test MMAP for Format RGBQ, Frame Size 720x576:
> 		Crop 720x576@0x0, Compose 720x576@0x0, Stride 1440, Field Interlaced: OK
> 	test MMAP for Format RGB4, Frame Size 2x4:
> 		Crop 720x576@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced: OK
> 	test MMAP for Format RGB4, Frame Size 2048x2048:
> 		Crop 6x4@0x0, Compose 6x4@0x0, Stride 8192, Field Interlaced: OK
> 	test MMAP for Format RGB4, Frame Size 720x576:
> 		Crop 720x576@0x0, Compose 720x576@0x0, Stride 2880, Field Interlaced: OK
> 
> Total: 74, Succeeded: 74, Failed: 0, Warnings: 0
> 
>  drivers/media/platform/Kconfig              |    1 +
>  drivers/media/platform/Makefile             |    2 +
>  drivers/media/platform/rcar-vin/Kconfig     |    7 +
>  drivers/media/platform/rcar-vin/Makefile    |    3 +
>  drivers/media/platform/rcar-vin/rcar-core.c | 1209 +++++++++++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 1073 ++++++++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  198 +++++
>  drivers/media/platform/soc_camera/Kconfig   |    4 +-
>  drivers/media/platform/soc_camera/Makefile  |    2 +-
>  9 files changed, 2496 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/media/platform/rcar-vin/Kconfig
>  create mode 100644 drivers/media/platform/rcar-vin/Makefile
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-core.c
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-dma.c
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-vin.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 8b89ebe1..6cb069a 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -119,6 +119,7 @@ source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/s5p-tv/Kconfig"
>  source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
> +source "drivers/media/platform/rcar-vin/Kconfig"
> 
>  endif # V4L_PLATFORM_DRIVERS
> 
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index efa0295..b6e6f91 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -54,4 +54,6 @@ obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
> 
>  obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
> 
> +obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
> +
>  ccflags-y += -I$(srctree)/drivers/media/i2c
> diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> new file mode 100644
> index 0000000..862585e
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -0,0 +1,7 @@
> +config VIDEO_RCAR_VIN
> +	tristate "R-Car Video Input (VIN) support"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
> +	depends on ARCH_RENESAS || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This is a v4l2 driver for the R-Car VIN Interface

This needs to be expanded a bit: is this valid for all R-Car SoCs?

Also add something like:

"To compile this driver as a module, choose M here: the
 module will be called tda7432."

I always find it useful to see the module name mentioned.

Look at drivers/media/i2c/Kconfig for proper examples of Kconfig descriptions.

> diff --git a/drivers/media/platform/rcar-vin/Makefile b/drivers/media/platform/rcar-vin/Makefile
> new file mode 100644
> index 0000000..0dcd855
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/Makefile
> @@ -0,0 +1,3 @@
> +rcar-vin-objs = rcar-core.o rcar-dma.o
> +
> +obj-$(CONFIG_VIDEO_RCAR_VIN) += rcar-vin.o
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> new file mode 100644
> index 0000000..69f3e1c
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -0,0 +1,1209 @@
> +/*
> + * Driver for Renesas R-Car VIN
> + *
> + * Copyright (C) 2016 Renesas Electronics Corp.
> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on the soc-camera rcar_vin driver
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#include "rcar-vin.h"
> +
> +#define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
> +
> +/* -----------------------------------------------------------------------------
> + * HW Functions
> + */
> +
> +/* Register offsets for R-Car VIN */
> +#define VNMC_REG	0x00	/* Video n Main Control Register */
> +#define VNMS_REG	0x04	/* Video n Module Status Register */
> +#define VNFC_REG	0x08	/* Video n Frame Capture Register */
> +#define VNSLPRC_REG	0x0C	/* Video n Start Line Pre-Clip Register */
> +#define VNELPRC_REG	0x10	/* Video n End Line Pre-Clip Register */
> +#define VNSPPRC_REG	0x14	/* Video n Start Pixel Pre-Clip Register */
> +#define VNEPPRC_REG	0x18	/* Video n End Pixel Pre-Clip Register */
> +#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
> +#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
> +#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
> +#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
> +#define VNIS_REG	0x2C	/* Video n Image Stride Register */
> +#define VNMB_REG(m)	(0x30 + ((m) << 2)) /* Video n Memory Base m Register */
> +#define VNIE_REG	0x40	/* Video n Interrupt Enable Register */
> +#define VNINTS_REG	0x44	/* Video n Interrupt Status Register */
> +#define VNSI_REG	0x48	/* Video n Scanline Interrupt Register */
> +#define VNMTC_REG	0x4C	/* Video n Memory Transfer Control Register */
> +#define VNYS_REG	0x50	/* Video n Y Scale Register */
> +#define VNXS_REG	0x54	/* Video n X Scale Register */
> +#define VNDMR_REG	0x58	/* Video n Data Mode Register */
> +#define VNDMR2_REG	0x5C	/* Video n Data Mode Register 2 */
> +#define VNUVAOF_REG	0x60	/* Video n UV Address Offset Register */
> +#define VNC1A_REG	0x80	/* Video n Coefficient Set C1A Register */
> +#define VNC1B_REG	0x84	/* Video n Coefficient Set C1B Register */
> +#define VNC1C_REG	0x88	/* Video n Coefficient Set C1C Register */
> +#define VNC2A_REG	0x90	/* Video n Coefficient Set C2A Register */
> +#define VNC2B_REG	0x94	/* Video n Coefficient Set C2B Register */
> +#define VNC2C_REG	0x98	/* Video n Coefficient Set C2C Register */
> +#define VNC3A_REG	0xA0	/* Video n Coefficient Set C3A Register */
> +#define VNC3B_REG	0xA4	/* Video n Coefficient Set C3B Register */
> +#define VNC3C_REG	0xA8	/* Video n Coefficient Set C3C Register */
> +#define VNC4A_REG	0xB0	/* Video n Coefficient Set C4A Register */
> +#define VNC4B_REG	0xB4	/* Video n Coefficient Set C4B Register */
> +#define VNC4C_REG	0xB8	/* Video n Coefficient Set C4C Register */
> +#define VNC5A_REG	0xC0	/* Video n Coefficient Set C5A Register */
> +#define VNC5B_REG	0xC4	/* Video n Coefficient Set C5B Register */
> +#define VNC5C_REG	0xC8	/* Video n Coefficient Set C5C Register */
> +#define VNC6A_REG	0xD0	/* Video n Coefficient Set C6A Register */
> +#define VNC6B_REG	0xD4	/* Video n Coefficient Set C6B Register */
> +#define VNC6C_REG	0xD8	/* Video n Coefficient Set C6C Register */
> +#define VNC7A_REG	0xE0	/* Video n Coefficient Set C7A Register */
> +#define VNC7B_REG	0xE4	/* Video n Coefficient Set C7B Register */
> +#define VNC7C_REG	0xE8	/* Video n Coefficient Set C7C Register */
> +#define VNC8A_REG	0xF0	/* Video n Coefficient Set C8A Register */
> +#define VNC8B_REG	0xF4	/* Video n Coefficient Set C8B Register */
> +#define VNC8C_REG	0xF8	/* Video n Coefficient Set C8C Register */
> +
> +/* Register bit fields for R-Car VIN */
> +/* Video n Main Control Register bits */
> +#define VNMC_FOC		(1 << 21)
> +#define VNMC_YCAL		(1 << 19)
> +#define VNMC_INF_YUV8_BT656	(0 << 16)
> +#define VNMC_INF_YUV8_BT601	(1 << 16)
> +#define VNMC_INF_YUV10_BT656	(2 << 16)
> +#define VNMC_INF_YUV10_BT601	(3 << 16)
> +#define VNMC_INF_YUV16		(5 << 16)
> +#define VNMC_INF_RGB888		(6 << 16)
> +#define VNMC_VUP		(1 << 10)
> +#define VNMC_IM_ODD		(0 << 3)
> +#define VNMC_IM_ODD_EVEN	(1 << 3)
> +#define VNMC_IM_EVEN		(2 << 3)
> +#define VNMC_IM_FULL		(3 << 3)
> +#define VNMC_BPS		(1 << 1)
> +#define VNMC_ME			(1 << 0)
> +
> +/* Video n Module Status Register bits */
> +#define VNMS_FBS_MASK		(3 << 3)
> +#define VNMS_FBS_SHIFT		3
> +#define VNMS_AV			(1 << 1)
> +#define VNMS_CA			(1 << 0)
> +
> +/* Video n Frame Capture Register bits */
> +#define VNFC_C_FRAME		(1 << 1)
> +#define VNFC_S_FRAME		(1 << 0)
> +
> +/* Video n Interrupt Enable Register bits */
> +#define VNIE_FIE		(1 << 4)
> +#define VNIE_EFE		(1 << 1)
> +
> +/* Video n Data Mode Register bits */
> +#define VNDMR_EXRGB		(1 << 8)
> +#define VNDMR_BPSM		(1 << 4)
> +#define VNDMR_DTMD_YCSEP	(1 << 1)
> +#define VNDMR_DTMD_ARGB1555	(1 << 0)
> +
> +/* Video n Data Mode Register 2 bits */
> +#define VNDMR2_VPS		(1 << 30)
> +#define VNDMR2_HPS		(1 << 29)
> +#define VNDMR2_FTEV		(1 << 17)
> +#define VNDMR2_VLV(n)		((n & 0xf) << 12)
> +
> +#define RVIN_HSYNC_ACTIVE_LOW       (1 << 0)
> +#define RVIN_VSYNC_ACTIVE_LOW       (1 << 1)
> +#define RVIN_BT601                  (1 << 2)
> +#define RVIN_BT656                  (1 << 3)
> +
> +static void rvin_write(struct rvin_dev *vin, u32 value, u32 offset)
> +{
> +	iowrite32(value, vin->base + offset);
> +}
> +
> +static u32 rvin_read(struct rvin_dev *vin, u32 offset)
> +{
> +	return ioread32(vin->base + offset);
> +}
> +
> +static void rvin_setup(struct rvin_dev *vin)
> +{
> +	u32 vnmc, dmr, dmr2, interrupts;
> +	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
> +
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_TOP:
> +		vnmc = VNMC_IM_ODD;
> +		break;
> +	case V4L2_FIELD_BOTTOM:
> +		vnmc = VNMC_IM_EVEN;
> +		break;

What is missing here is support for FIELD_ALTERNATE. That would be particularly
useful for HDMI input where interlaced formats are almost always captured
field-by-field. But for SDTV it can also be useful.

This can be implemented later though. Just thought I'd mention it.

> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +		vnmc = VNMC_IM_FULL;
> +		break;
> +	case V4L2_FIELD_INTERLACED_BT:
> +		vnmc = VNMC_IM_FULL | VNMC_FOC;
> +		break;
> +	case V4L2_FIELD_NONE:
> +		if (vin->continuous) {
> +			vnmc = VNMC_IM_ODD_EVEN;
> +			progressive = true;
> +		} else {
> +			vnmc = VNMC_IM_ODD;
> +		}
> +		break;
> +	default:
> +		vnmc = VNMC_IM_ODD;
> +		break;
> +	}
> +
> +	/*
> +	 * Input interface
> +	 */
> +	switch (vin->sensor.code) {
> +	case MEDIA_BUS_FMT_YUYV8_1X16:
> +		/* BT.601/BT.1358 16bit YCbCr422 */
> +		vnmc |= VNMC_INF_YUV16;
> +		input_is_yuv = true;
> +		break;
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> +		vnmc |= vin->pdata_flags & RVIN_BT656 ?
> +			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> +		input_is_yuv = true;
> +		break;
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +		vnmc |= VNMC_INF_RGB888;
> +		break;
> +	case MEDIA_BUS_FMT_YUYV10_2X10:
> +		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> +		vnmc |= vin->pdata_flags & RVIN_BT656 ?
> +			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
> +		input_is_yuv = true;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* Enable VSYNC Field Toogle mode after one VSYNC input */
> +	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
> +
> +	/* Hsync Signal Polarity Select */
> +	if (!(vin->pdata_flags & RVIN_HSYNC_ACTIVE_LOW))
> +		dmr2 |= VNDMR2_HPS;
> +
> +	/* Vsync Signal Polarity Select */
> +	if (!(vin->pdata_flags & RVIN_VSYNC_ACTIVE_LOW))
> +		dmr2 |= VNDMR2_VPS;
> +
> +	rvin_write(vin, dmr2, VNDMR2_REG);
> +
> +	/*
> +	 * Output format
> +	 */
> +	switch (vin->format.pixelformat) {
> +	case V4L2_PIX_FMT_NV16:
> +		rvin_write(vin,
> +			   ALIGN(vin->format.width * vin->format.height, 0x80),
> +			   VNUVAOF_REG);
> +		dmr = VNDMR_DTMD_YCSEP;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		dmr = VNDMR_BPSM;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		dmr = 0;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_RGB555X:
> +		dmr = VNDMR_DTMD_ARGB1555;
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		dmr = 0;
> +		break;
> +	case V4L2_PIX_FMT_RGB32:
> +		if (vin->chip == RCAR_GEN2 || vin->chip == RCAR_H1 ||
> +		    vin->chip == RCAR_E1) {
> +			dmr = VNDMR_EXRGB;
> +			break;
> +		}

Please add /* fall through */ here to indicate that this is intended.

> +	default:
> +		vin_err(vin, "Invalid pixelformat (0x%x)\n",
> +			vin->format.pixelformat);

Please add a break here.

Also, shouldn't this function return an error if there is no valid pixelformat?

> +	}
> +
> +	/* Always update on field change */
> +	vnmc |= VNMC_VUP;
> +
> +	/* If input and output use the same colorspace, use bypass mode */
> +	if (input_is_yuv == output_is_yuv)
> +		vnmc |= VNMC_BPS;
> +
> +	/* Progressive or interlaced mode */
> +	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
> +
> +	/* Ack interrupts */
> +	rvin_write(vin, interrupts, VNINTS_REG);
> +	/* Enable interrupts */
> +	rvin_write(vin, interrupts, VNIE_REG);
> +	/* Start capturing */
> +	rvin_write(vin, dmr, VNDMR_REG);
> +
> +	/* Enable module */
> +	rvin_write(vin, vnmc | VNMC_ME, VNMC_REG);
> +}
> +
> +void rvin_capture_on(struct rvin_dev *vin)
> +{
> +	vin_dbg(vin, "Capture on in %s mode\n",
> +		vin->continuous ? "continuous" : "single");
> +
> +	if (vin->continuous)
> +		/* Continuous Frame Capture Mode */
> +		rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
> +	else
> +		/* Single Frame Capture Mode */
> +		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
> +}
> +
> +void rvin_capture_off(struct rvin_dev *vin)
> +{
> +	/* Set continuous & single transfer off */
> +	rvin_write(vin, 0, VNFC_REG);
> +}
> +
> +void rvin_capture_start(struct rvin_dev *vin)
> +{
> +	rvin_crop_scale_comp(vin);
> +	rvin_setup(vin);
> +	rvin_capture_on(vin);
> +}
> +
> +void rvin_capture_stop(struct rvin_dev *vin)
> +{
> +	rvin_capture_off(vin);
> +
> +	/* Disable module */
> +	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
> +}
> +
> +void rvin_disable_interrupts(struct rvin_dev *vin)
> +{
> +	rvin_write(vin, 0, VNIE_REG);
> +}
> +
> +u32 rvin_get_interrupt_status(struct rvin_dev *vin)
> +{
> +	return rvin_read(vin, VNINTS_REG);
> +}
> +
> +void rvin_ack_interrupt(struct rvin_dev *vin)
> +{
> +	rvin_write(vin, rvin_read(vin, VNINTS_REG), VNINTS_REG);
> +}
> +
> +bool rvin_capture_active(struct rvin_dev *vin)
> +{
> +	return rvin_read(vin, VNMS_REG) & VNMS_CA;
> +}
> +
> +int rvin_get_active_slot(struct rvin_dev *vin)
> +{
> +	if (vin->continuous)
> +		return (rvin_read(vin, VNMS_REG) & VNMS_FBS_MASK)
> +			>> VNMS_FBS_SHIFT;
> +
> +	return 0;
> +}
> +
> +void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
> +{
> +	const struct rvin_video_format *fmt;
> +	int offsetx, offsety;
> +	dma_addr_t offset;
> +
> +	fmt = rvin_format_from_pixel(vin->format.pixelformat);
> +
> +	/*
> +	 * There is no HW support for composition do the beast we can
> +	 * by modifying the buffer offset
> +	 */
> +	offsetx = vin->compose.left * fmt->bpp;
> +	offsety = vin->compose.top * vin->format.bytesperline;

Does this work for a planar format like NV16? Just wondering.

> +	offset = addr + offsetx + offsety;
> +
> +	/*
> +	 * The address needs to be 128 bytes aligned. Driver should never accept
> +	 * settings that do not satisfy this in the first place...
> +	 */
> +	if (WARN_ON((offsetx | offsety | offset) & HW_BUFFER_MASK))
> +		return;
> +
> +	rvin_write(vin, offset, VNMB_REG(slot));
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Format Conversions
> + */
> +
> +static const struct rvin_video_format rvin_formats[] = {
> +
> +	{
> +		.fourcc			= V4L2_PIX_FMT_NV16,
> +		.bpp			= 1,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_UYVY,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB565,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB555X,
> +		.bpp			= 2,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB32,
> +		.bpp			= 4,
> +	},
> +};
> +
> +static int rvin_mbus_supported(struct rvin_dev *vin)
> +{
> +	struct v4l2_subdev *sd;
> +	struct v4l2_subdev_mbus_code_enum code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	sd = vin_to_sd(vin);
> +
> +	code.index = 0;
> +	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
> +		code.index++;
> +		switch (code.code) {
> +		case MEDIA_BUS_FMT_YUYV8_1X16:
> +		case MEDIA_BUS_FMT_YUYV8_2X8:
> +		case MEDIA_BUS_FMT_YUYV10_2X10:
> +		case MEDIA_BUS_FMT_RGB888_1X24:
> +			vin->sensor.code = code.code;
> +			vin_dbg(vin, "Found supported media bus format: %d\n",
> +				vin->sensor.code);
> +			return true;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +const struct rvin_video_format *rvin_format_from_num(int num)
> +{
> +	if (num >= ARRAY_SIZE(rvin_formats))
> +		return NULL;
> +
> +	return rvin_formats + num;
> +}
> +
> +const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(rvin_formats); i++) {
> +		if (rvin_formats[i].fourcc == pixelformat)
> +			return rvin_formats + i;
> +	}
> +	return NULL;
> +}
> +
> +u32 rvin_format_bytesperline(struct v4l2_pix_format *pix)
> +{
> +	const struct rvin_video_format *fmt;
> +
> +	fmt = rvin_format_from_pixel(pix->pixelformat);
> +
> +	if (WARN_ON(!fmt))
> +		return -EINVAL;
> +
> +	if (pix->pixelformat == V4L2_PIX_FMT_NV16)
> +		return pix->width * 2;

This isn't right. For a planar format like NV16 the bytesperline is that
of the first plane. So this condition can be removed since the return
below already does the right thing.

> +
> +	return pix->width * fmt->bpp;
> +}
> +
> +u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
> +{
> +	if (pix->pixelformat == V4L2_PIX_FMT_NV16)
> +		return pix->bytesperline * pix->height * 2;

This is actually OK since there are two planes, each with the same bytesperline
value.

With the current code I would expect sizeimage to be too large by a factor of 2.

> +
> +	return pix->bytesperline * pix->height;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Crop and Scaling Gen2
> + */
> +
> +struct vin_coeff {
> +	unsigned short xs_value;
> +	u32 coeff_set[24];
> +};
> +
> +static const struct vin_coeff vin_coeff_set[] = {
> +	{ 0x0000, {
> +			  0x00000000, 0x00000000, 0x00000000,
> +			  0x00000000, 0x00000000, 0x00000000,
> +			  0x00000000, 0x00000000, 0x00000000,
> +			  0x00000000, 0x00000000, 0x00000000,
> +			  0x00000000, 0x00000000, 0x00000000,
> +			  0x00000000, 0x00000000, 0x00000000,
> +			  0x00000000, 0x00000000, 0x00000000,
> +			  0x00000000, 0x00000000, 0x00000000 },
> +	},
> +	{ 0x1000, {
> +			  0x000fa400, 0x000fa400, 0x09625902,
> +			  0x000003f8, 0x00000403, 0x3de0d9f0,
> +			  0x001fffed, 0x00000804, 0x3cc1f9c3,
> +			  0x001003de, 0x00000c01, 0x3cb34d7f,
> +			  0x002003d2, 0x00000c00, 0x3d24a92d,
> +			  0x00200bca, 0x00000bff, 0x3df600d2,
> +			  0x002013cc, 0x000007ff, 0x3ed70c7e,
> +			  0x00100fde, 0x00000000, 0x3f87c036 },
> +	},
> +	{ 0x1200, {
> +			  0x002ffff1, 0x002ffff1, 0x02a0a9c8,
> +			  0x002003e7, 0x001ffffa, 0x000185bc,
> +			  0x002007dc, 0x000003ff, 0x3e52859c,
> +			  0x00200bd4, 0x00000002, 0x3d53996b,
> +			  0x00100fd0, 0x00000403, 0x3d04ad2d,
> +			  0x00000bd5, 0x00000403, 0x3d35ace7,
> +			  0x3ff003e4, 0x00000801, 0x3dc674a1,
> +			  0x3fffe800, 0x00000800, 0x3e76f461 },
> +	},
> +	{ 0x1400, {
> +			  0x00100be3, 0x00100be3, 0x04d1359a,
> +			  0x00000fdb, 0x002003ed, 0x0211fd93,
> +			  0x00000fd6, 0x002003f4, 0x0002d97b,
> +			  0x000007d6, 0x002ffffb, 0x3e93b956,
> +			  0x3ff003da, 0x001003ff, 0x3db49926,
> +			  0x3fffefe9, 0x00100001, 0x3d655cee,
> +			  0x3fffd400, 0x00000003, 0x3d65f4b6,
> +			  0x000fb421, 0x00000402, 0x3dc6547e },
> +	},
> +	{ 0x1600, {
> +			  0x00000bdd, 0x00000bdd, 0x06519578,
> +			  0x3ff007da, 0x00000be3, 0x03c24973,
> +			  0x3ff003d9, 0x00000be9, 0x01b30d5f,
> +			  0x3ffff7df, 0x001003f1, 0x0003c542,
> +			  0x000fdfec, 0x001003f7, 0x3ec4711d,
> +			  0x000fc400, 0x002ffffd, 0x3df504f1,
> +			  0x001fa81a, 0x002ffc00, 0x3d957cc2,
> +			  0x002f8c3c, 0x00100000, 0x3db5c891 },
> +	},
> +	{ 0x1800, {
> +			  0x3ff003dc, 0x3ff003dc, 0x0791e558,
> +			  0x000ff7dd, 0x3ff007de, 0x05328554,
> +			  0x000fe7e3, 0x3ff00be2, 0x03232546,
> +			  0x000fd7ee, 0x000007e9, 0x0143bd30,
> +			  0x001fb800, 0x000007ee, 0x00044511,
> +			  0x002fa015, 0x000007f4, 0x3ef4bcee,
> +			  0x002f8832, 0x001003f9, 0x3e4514c7,
> +			  0x001f7853, 0x001003fd, 0x3de54c9f },
> +	},
> +	{ 0x1a00, {
> +			  0x000fefe0, 0x000fefe0, 0x08721d3c,
> +			  0x001fdbe7, 0x000ffbde, 0x0652a139,
> +			  0x001fcbf0, 0x000003df, 0x0463292e,
> +			  0x002fb3ff, 0x3ff007e3, 0x0293a91d,
> +			  0x002f9c12, 0x3ff00be7, 0x01241905,
> +			  0x001f8c29, 0x000007ed, 0x3fe470eb,
> +			  0x000f7c46, 0x000007f2, 0x3f04b8ca,
> +			  0x3fef7865, 0x000007f6, 0x3e74e4a8 },
> +	},
> +	{ 0x1c00, {
> +			  0x001fd3e9, 0x001fd3e9, 0x08f23d26,
> +			  0x002fbff3, 0x001fe3e4, 0x0712ad23,
> +			  0x002fa800, 0x000ff3e0, 0x05631d1b,
> +			  0x001f9810, 0x000ffbe1, 0x03b3890d,
> +			  0x000f8c23, 0x000003e3, 0x0233e8fa,
> +			  0x3fef843b, 0x000003e7, 0x00f430e4,
> +			  0x3fbf8456, 0x3ff00bea, 0x00046cc8,
> +			  0x3f8f8c72, 0x3ff00bef, 0x3f3490ac },
> +	},
> +	{ 0x1e00, {
> +			  0x001fbbf4, 0x001fbbf4, 0x09425112,
> +			  0x001fa800, 0x002fc7ed, 0x0792b110,
> +			  0x000f980e, 0x001fdbe6, 0x0613110a,
> +			  0x3fff8c20, 0x001fe7e3, 0x04a368fd,
> +			  0x3fcf8c33, 0x000ff7e2, 0x0343b8ed,
> +			  0x3f9f8c4a, 0x000fffe3, 0x0203f8da,
> +			  0x3f5f9c61, 0x000003e6, 0x00e428c5,
> +			  0x3f1fb07b, 0x000003eb, 0x3fe440af },
> +	},
> +	{ 0x2000, {
> +			  0x000fa400, 0x000fa400, 0x09625902,
> +			  0x3fff980c, 0x001fb7f5, 0x0812b0ff,
> +			  0x3fdf901c, 0x001fc7ed, 0x06b2fcfa,
> +			  0x3faf902d, 0x001fd3e8, 0x055348f1,
> +			  0x3f7f983f, 0x001fe3e5, 0x04038ce3,
> +			  0x3f3fa454, 0x001fefe3, 0x02e3c8d1,
> +			  0x3f0fb86a, 0x001ff7e4, 0x01c3e8c0,
> +			  0x3ecfd880, 0x000fffe6, 0x00c404ac },
> +	},
> +	{ 0x2200, {
> +			  0x3fdf9c0b, 0x3fdf9c0b, 0x09725cf4,
> +			  0x3fbf9818, 0x3fffa400, 0x0842a8f1,
> +			  0x3f8f9827, 0x000fb3f7, 0x0702f0ec,
> +			  0x3f5fa037, 0x000fc3ef, 0x05d330e4,
> +			  0x3f2fac49, 0x001fcfea, 0x04a364d9,
> +			  0x3effc05c, 0x001fdbe7, 0x038394ca,
> +			  0x3ecfdc6f, 0x001fe7e6, 0x0273b0bb,
> +			  0x3ea00083, 0x001fefe6, 0x0183c0a9 },
> +	},
> +	{ 0x2400, {
> +			  0x3f9fa014, 0x3f9fa014, 0x098260e6,
> +			  0x3f7f9c23, 0x3fcf9c0a, 0x08629ce5,
> +			  0x3f4fa431, 0x3fefa400, 0x0742d8e1,
> +			  0x3f1fb440, 0x3fffb3f8, 0x062310d9,
> +			  0x3eefc850, 0x000fbbf2, 0x050340d0,
> +			  0x3ecfe062, 0x000fcbec, 0x041364c2,
> +			  0x3ea00073, 0x001fd3ea, 0x03037cb5,
> +			  0x3e902086, 0x001fdfe8, 0x022388a5 },
> +	},
> +	{ 0x2600, {
> +			  0x3f5fa81e, 0x3f5fa81e, 0x096258da,
> +			  0x3f3fac2b, 0x3f8fa412, 0x088290d8,
> +			  0x3f0fbc38, 0x3fafa408, 0x0772c8d5,
> +			  0x3eefcc47, 0x3fcfa800, 0x0672f4ce,
> +			  0x3ecfe456, 0x3fefaffa, 0x05531cc6,
> +			  0x3eb00066, 0x3fffbbf3, 0x047334bb,
> +			  0x3ea01c77, 0x000fc7ee, 0x039348ae,
> +			  0x3ea04486, 0x000fd3eb, 0x02b350a1 },
> +	},
> +	{ 0x2800, {
> +			  0x3f2fb426, 0x3f2fb426, 0x094250ce,
> +			  0x3f0fc032, 0x3f4fac1b, 0x086284cd,
> +			  0x3eefd040, 0x3f7fa811, 0x0782acc9,
> +			  0x3ecfe84c, 0x3f9fa807, 0x06a2d8c4,
> +			  0x3eb0005b, 0x3fbfac00, 0x05b2f4bc,
> +			  0x3eb0186a, 0x3fdfb3fa, 0x04c308b4,
> +			  0x3eb04077, 0x3fefbbf4, 0x03f31ca8,
> +			  0x3ec06884, 0x000fbff2, 0x03031c9e },
> +	},
> +	{ 0x2a00, {
> +			  0x3f0fc42d, 0x3f0fc42d, 0x090240c4,
> +			  0x3eefd439, 0x3f2fb822, 0x08526cc2,
> +			  0x3edfe845, 0x3f4fb018, 0x078294bf,
> +			  0x3ec00051, 0x3f6fac0f, 0x06b2b4bb,
> +			  0x3ec0185f, 0x3f8fac07, 0x05e2ccb4,
> +			  0x3ec0386b, 0x3fafac00, 0x0502e8ac,
> +			  0x3ed05c77, 0x3fcfb3fb, 0x0432f0a3,
> +			  0x3ef08482, 0x3fdfbbf6, 0x0372f898 },
> +	},
> +	{ 0x2c00, {
> +			  0x3eefdc31, 0x3eefdc31, 0x08e238b8,
> +			  0x3edfec3d, 0x3f0fc828, 0x082258b9,
> +			  0x3ed00049, 0x3f1fc01e, 0x077278b6,
> +			  0x3ed01455, 0x3f3fb815, 0x06c294b2,
> +			  0x3ed03460, 0x3f5fb40d, 0x0602acac,
> +			  0x3ef0506c, 0x3f7fb006, 0x0542c0a4,
> +			  0x3f107476, 0x3f9fb400, 0x0472c89d,
> +			  0x3f309c80, 0x3fbfb7fc, 0x03b2cc94 },
> +	},
> +	{ 0x2e00, {
> +			  0x3eefec37, 0x3eefec37, 0x088220b0,
> +			  0x3ee00041, 0x3effdc2d, 0x07f244ae,
> +			  0x3ee0144c, 0x3f0fd023, 0x07625cad,
> +			  0x3ef02c57, 0x3f1fc81a, 0x06c274a9,
> +			  0x3f004861, 0x3f3fbc13, 0x060288a6,
> +			  0x3f20686b, 0x3f5fb80c, 0x05529c9e,
> +			  0x3f408c74, 0x3f6fb805, 0x04b2ac96,
> +			  0x3f80ac7e, 0x3f8fb800, 0x0402ac8e },
> +	},
> +	{ 0x3000, {
> +			  0x3ef0003a, 0x3ef0003a, 0x084210a6,
> +			  0x3ef01045, 0x3effec32, 0x07b228a7,
> +			  0x3f00284e, 0x3f0fdc29, 0x073244a4,
> +			  0x3f104058, 0x3f0fd420, 0x06a258a2,
> +			  0x3f305c62, 0x3f2fc818, 0x0612689d,
> +			  0x3f508069, 0x3f3fc011, 0x05728496,
> +			  0x3f80a072, 0x3f4fc00a, 0x04d28c90,
> +			  0x3fc0c07b, 0x3f6fbc04, 0x04429088 },
> +	},
> +	{ 0x3200, {
> +			  0x3f00103e, 0x3f00103e, 0x07f1fc9e,
> +			  0x3f102447, 0x3f000035, 0x0782149d,
> +			  0x3f203c4f, 0x3f0ff02c, 0x07122c9c,
> +			  0x3f405458, 0x3f0fe424, 0x06924099,
> +			  0x3f607061, 0x3f1fd41d, 0x06024c97,
> +			  0x3f909068, 0x3f2fcc16, 0x05726490,
> +			  0x3fc0b070, 0x3f3fc80f, 0x04f26c8a,
> +			  0x0000d077, 0x3f4fc409, 0x04627484 },
> +	},
> +	{ 0x3400, {
> +			  0x3f202040, 0x3f202040, 0x07a1e898,
> +			  0x3f303449, 0x3f100c38, 0x0741fc98,
> +			  0x3f504c50, 0x3f10002f, 0x06e21495,
> +			  0x3f706459, 0x3f1ff028, 0x06722492,
> +			  0x3fa08060, 0x3f1fe421, 0x05f2348f,
> +			  0x3fd09c67, 0x3f1fdc19, 0x05824c89,
> +			  0x0000bc6e, 0x3f2fd014, 0x04f25086,
> +			  0x0040dc74, 0x3f3fcc0d, 0x04825c7f },
> +	},
> +	{ 0x3600, {
> +			  0x3f403042, 0x3f403042, 0x0761d890,
> +			  0x3f504848, 0x3f301c3b, 0x0701f090,
> +			  0x3f805c50, 0x3f200c33, 0x06a2008f,
> +			  0x3fa07458, 0x3f10002b, 0x06520c8d,
> +			  0x3fd0905e, 0x3f1ff424, 0x05e22089,
> +			  0x0000ac65, 0x3f1fe81d, 0x05823483,
> +			  0x0030cc6a, 0x3f2fdc18, 0x04f23c81,
> +			  0x0080e871, 0x3f2fd412, 0x0482407c },
> +	},
> +	{ 0x3800, {
> +			  0x3f604043, 0x3f604043, 0x0721c88a,
> +			  0x3f80544a, 0x3f502c3c, 0x06d1d88a,
> +			  0x3fb06851, 0x3f301c35, 0x0681e889,
> +			  0x3fd08456, 0x3f30082f, 0x0611fc88,
> +			  0x00009c5d, 0x3f200027, 0x05d20884,
> +			  0x0030b863, 0x3f2ff421, 0x05621880,
> +			  0x0070d468, 0x3f2fe81b, 0x0502247c,
> +			  0x00c0ec6f, 0x3f2fe015, 0x04a22877 },
> +	},
> +	{ 0x3a00, {
> +			  0x3f904c44, 0x3f904c44, 0x06e1b884,
> +			  0x3fb0604a, 0x3f70383e, 0x0691c885,
> +			  0x3fe07451, 0x3f502c36, 0x0661d483,
> +			  0x00009055, 0x3f401831, 0x0601ec81,
> +			  0x0030a85b, 0x3f300c2a, 0x05b1f480,
> +			  0x0070c061, 0x3f300024, 0x0562047a,
> +			  0x00b0d867, 0x3f3ff41e, 0x05020c77,
> +			  0x00f0f46b, 0x3f2fec19, 0x04a21474 },
> +	},
> +	{ 0x3c00, {
> +			  0x3fb05c43, 0x3fb05c43, 0x06c1b07e,
> +			  0x3fe06c4b, 0x3f902c3f, 0x0681c081,
> +			  0x0000844f, 0x3f703838, 0x0631cc7d,
> +			  0x00309855, 0x3f602433, 0x05d1d47e,
> +			  0x0060b459, 0x3f50142e, 0x0581e47b,
> +			  0x00a0c85f, 0x3f400828, 0x0531f078,
> +			  0x00e0e064, 0x3f300021, 0x0501fc73,
> +			  0x00b0fc6a, 0x3f3ff41d, 0x04a20873 },
> +	},
> +	{ 0x3e00, {
> +			  0x3fe06444, 0x3fe06444, 0x0681a07a,
> +			  0x00007849, 0x3fc0503f, 0x0641b07a,
> +			  0x0020904d, 0x3fa0403a, 0x05f1c07a,
> +			  0x0060a453, 0x3f803034, 0x05c1c878,
> +			  0x0090b858, 0x3f70202f, 0x0571d477,
> +			  0x00d0d05d, 0x3f501829, 0x0531e073,
> +			  0x0110e462, 0x3f500825, 0x04e1e471,
> +			  0x01510065, 0x3f40001f, 0x04a1f06d },
> +	},
> +	{ 0x4000, {
> +			  0x00007044, 0x00007044, 0x06519476,
> +			  0x00208448, 0x3fe05c3f, 0x0621a476,
> +			  0x0050984d, 0x3fc04c3a, 0x05e1b075,
> +			  0x0080ac52, 0x3fa03c35, 0x05a1b875,
> +			  0x00c0c056, 0x3f803030, 0x0561c473,
> +			  0x0100d45b, 0x3f70202b, 0x0521d46f,
> +			  0x0140e860, 0x3f601427, 0x04d1d46e,
> +			  0x01810064, 0x3f500822, 0x0491dc6b },
> +	},
> +	{ 0x5000, {
> +			  0x0110a442, 0x0110a442, 0x0551545e,
> +			  0x0140b045, 0x00e0983f, 0x0531585f,
> +			  0x0160c047, 0x00c08c3c, 0x0511645e,
> +			  0x0190cc4a, 0x00908039, 0x04f1685f,
> +			  0x01c0dc4c, 0x00707436, 0x04d1705e,
> +			  0x0200e850, 0x00506833, 0x04b1785b,
> +			  0x0230f453, 0x00305c30, 0x0491805a,
> +			  0x02710056, 0x0010542d, 0x04718059 },
> +	},
> +	{ 0x6000, {
> +			  0x01c0bc40, 0x01c0bc40, 0x04c13052,
> +			  0x01e0c841, 0x01a0b43d, 0x04c13851,
> +			  0x0210cc44, 0x0180a83c, 0x04a13453,
> +			  0x0230d845, 0x0160a03a, 0x04913c52,
> +			  0x0260e047, 0x01409838, 0x04714052,
> +			  0x0280ec49, 0x01208c37, 0x04514c50,
> +			  0x02b0f44b, 0x01008435, 0x04414c50,
> +			  0x02d1004c, 0x00e07c33, 0x0431544f },
> +	},
> +	{ 0x7000, {
> +			  0x0230c83e, 0x0230c83e, 0x04711c4c,
> +			  0x0250d03f, 0x0210c43c, 0x0471204b,
> +			  0x0270d840, 0x0200b83c, 0x0451244b,
> +			  0x0290dc42, 0x01e0b43a, 0x0441244c,
> +			  0x02b0e443, 0x01c0b038, 0x0441284b,
> +			  0x02d0ec44, 0x01b0a438, 0x0421304a,
> +			  0x02f0f445, 0x0190a036, 0x04213449,
> +			  0x0310f847, 0x01709c34, 0x04213848 },
> +	},
> +	{ 0x8000, {
> +			  0x0280d03d, 0x0280d03d, 0x04310c48,
> +			  0x02a0d43e, 0x0270c83c, 0x04311047,
> +			  0x02b0dc3e, 0x0250c83a, 0x04311447,
> +			  0x02d0e040, 0x0240c03a, 0x04211446,
> +			  0x02e0e840, 0x0220bc39, 0x04111847,
> +			  0x0300e842, 0x0210b438, 0x04012445,
> +			  0x0310f043, 0x0200b037, 0x04012045,
> +			  0x0330f444, 0x01e0ac36, 0x03f12445 },
> +	},
> +	{ 0xefff, {
> +			  0x0340dc3a, 0x0340dc3a, 0x03b0ec40,
> +			  0x0340e03a, 0x0330e039, 0x03c0f03e,
> +			  0x0350e03b, 0x0330dc39, 0x03c0ec3e,
> +			  0x0350e43a, 0x0320dc38, 0x03c0f43e,
> +			  0x0360e43b, 0x0320d839, 0x03b0f03e,
> +			  0x0360e83b, 0x0310d838, 0x03c0fc3b,
> +			  0x0370e83b, 0x0310d439, 0x03a0f83d,
> +			  0x0370e83c, 0x0300d438, 0x03b0fc3c },
> +	}
> +};
> +
> +static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
> +{
> +	int i;
> +	const struct vin_coeff *p_prev_set = NULL;
> +	const struct vin_coeff *p_set = NULL;
> +
> +	/* Look for suitable coefficient values */
> +	for (i = 0; i < ARRAY_SIZE(vin_coeff_set); i++) {
> +		p_prev_set = p_set;
> +		p_set = &vin_coeff_set[i];
> +
> +		if (xs < p_set->xs_value)
> +			break;
> +	}
> +
> +	/* Use previous value if its XS value is closer */
> +	if (p_prev_set && p_set &&
> +	    xs - p_prev_set->xs_value < p_set->xs_value - xs)
> +		p_set = p_prev_set;
> +
> +	/* Set coefficient registers */
> +	rvin_write(vin, p_set->coeff_set[0], VNC1A_REG);
> +	rvin_write(vin, p_set->coeff_set[1], VNC1B_REG);
> +	rvin_write(vin, p_set->coeff_set[2], VNC1C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[3], VNC2A_REG);
> +	rvin_write(vin, p_set->coeff_set[4], VNC2B_REG);
> +	rvin_write(vin, p_set->coeff_set[5], VNC2C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[6], VNC3A_REG);
> +	rvin_write(vin, p_set->coeff_set[7], VNC3B_REG);
> +	rvin_write(vin, p_set->coeff_set[8], VNC3C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[9], VNC4A_REG);
> +	rvin_write(vin, p_set->coeff_set[10], VNC4B_REG);
> +	rvin_write(vin, p_set->coeff_set[11], VNC4C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[12], VNC5A_REG);
> +	rvin_write(vin, p_set->coeff_set[13], VNC5B_REG);
> +	rvin_write(vin, p_set->coeff_set[14], VNC5C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[15], VNC6A_REG);
> +	rvin_write(vin, p_set->coeff_set[16], VNC6B_REG);
> +	rvin_write(vin, p_set->coeff_set[17], VNC6C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[18], VNC7A_REG);
> +	rvin_write(vin, p_set->coeff_set[19], VNC7B_REG);
> +	rvin_write(vin, p_set->coeff_set[20], VNC7C_REG);
> +
> +	rvin_write(vin, p_set->coeff_set[21], VNC8A_REG);
> +	rvin_write(vin, p_set->coeff_set[22], VNC8B_REG);
> +	rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
> +}
> +
> +void rvin_crop_scale_comp(struct rvin_dev *vin)
> +{
> +	unsigned char dsize = 0;
> +	u32 xs, ys;
> +
> +	if (vin->format.pixelformat == V4L2_PIX_FMT_RGB32 &&
> +	    vin->chip == RCAR_E1)
> +		dsize = 1;
> +
> +	/* Set Start/End Pixel/Line Pre-Clip */
> +	rvin_write(vin, vin->crop.left << dsize, VNSPPRC_REG);
> +	rvin_write(vin, (vin->crop.left + vin->crop.width - 1) << dsize,
> +		   VNEPPRC_REG);
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		rvin_write(vin, vin->crop.top / 2, VNSLPRC_REG);
> +		rvin_write(vin, (vin->crop.top + vin->crop.height) / 2 - 1,
> +			   VNELPRC_REG);
> +		break;
> +	default:
> +		rvin_write(vin, vin->crop.top, VNSLPRC_REG);
> +		rvin_write(vin, vin->crop.top + vin->crop.height - 1,
> +			   VNELPRC_REG);
> +		break;
> +	}
> +
> +	/* Set scaling coefficient */
> +	ys = 0;
> +	if (vin->crop.height != vin->compose.height)
> +		ys = (4096 * vin->crop.height) / vin->compose.height;
> +	rvin_write(vin, ys, VNYS_REG);
> +
> +	xs = 0;
> +	if (vin->crop.width != vin->compose.width)
> +		xs = (4096 * vin->crop.width) / vin->compose.width;
> +
> +	/* Horizontal upscaling is up to double size */
> +	if (xs > 0 && xs < 2048)
> +		xs = 2048;
> +
> +	rvin_write(vin, xs, VNXS_REG);
> +
> +	/* Horizontal upscaling is done out by scaling down from double size */
> +	if (xs < 4096)
> +		xs *= 2;
> +
> +	rvin_set_coeff(vin, xs);
> +
> +	/* Set Start/End Pixel/Line Post-Clip */
> +	rvin_write(vin, 0, VNSPPOC_REG);
> +	rvin_write(vin, 0, VNSLPOC_REG);
> +	rvin_write(vin, (vin->format.width - 1) << dsize, VNEPPOC_REG);
> +	switch (vin->format.field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		rvin_write(vin, vin->format.height / 2 - 1, VNELPOC_REG);
> +		break;
> +	default:
> +		rvin_write(vin, vin->format.height - 1, VNELPOC_REG);
> +		break;
> +	}
> +
> +	rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
> +
> +	vin_dbg(vin,
> +		"Pre-Clip: %ux%u@%u:%u YS: %d XS: %d Post-Clip: %ux%u@%u:%u\n",
> +		vin->crop.width, vin->crop.height, vin->crop.left,
> +		vin->crop.top, ys, xs, vin->format.width, vin->format.height,
> +		0, 0);
> +}
> +
> +void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
> +		    u32 width, u32 height)
> +{
> +	/* All VIN channels on Gen2 have scalers */
> +	pix->width = width;
> +	pix->height = height;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Async notifier
> + */
> +
> +static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_subdev *sd;
> +	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	int ret;
> +
> +	sd = vin_to_sd(vin);
> +
> +	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
> +	if (ret < 0) {
> +		vin_err(vin, "Failed to register subdev nodes\n");
> +		return ret;
> +	}
> +
> +	if (!rvin_mbus_supported(vin)) {
> +		vin_err(vin, "No supported mediabus format found\n");
> +		return -EINVAL;
> +	}
> +
> +	return rvin_dma_on(vin);
> +}
> +
> +static int rvin_graph_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct rvin_dev *vin = notifier_to_vin(notifier);
> +
> +	vin_dbg(vin, "subdev %s bound\n", subdev->name);
> +
> +	vin->entity.entity = &subdev->entity;
> +	vin->entity.subdev = subdev;
> +
> +	return 0;
> +}
> +
> +static int rvin_graph_parse(struct rvin_dev *vin,
> +			    struct device_node *node)
> +{
> +	struct device_node *remote;
> +	struct device_node *ep = NULL;
> +	struct device_node *next;
> +	int ret = 0;
> +
> +	while (1) {
> +		next = of_graph_get_next_endpoint(node, ep);
> +		if (!next)
> +			break;
> +
> +		of_node_put(ep);
> +		ep = next;
> +
> +		remote = of_graph_get_remote_port_parent(ep);
> +		if (!remote) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		/* Skip entities that we have already processed. */
> +		if (remote == vin->dev->of_node) {
> +			of_node_put(remote);
> +			continue;
> +		}
> +
> +		/* Remote node to connect */
> +		if (!vin->entity.node) {
> +			vin->entity.node = remote;
> +			vin->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
> +			vin->entity.asd.match.of.node = remote;
> +			ret++;
> +		}
> +	}
> +
> +	of_node_put(ep);
> +
> +	return ret;
> +}
> +
> +static int rvin_graph_init(struct rvin_dev *vin)
> +{
> +	struct v4l2_async_subdev **subdevs = NULL;
> +	int ret;
> +
> +	/* Parse the graph to extract a list of subdevice DT nodes. */
> +	ret = rvin_graph_parse(vin, vin->dev->of_node);
> +	if (ret < 0) {
> +		vin_err(vin, "Graph parsing failed\n");
> +		goto done;
> +	}
> +
> +	if (!ret) {
> +		vin_err(vin, "No subdev found in graph\n");
> +		goto done;
> +	}
> +
> +	if (ret != 1) {
> +		vin_err(vin, "More then one subdev found in graph\n");
> +		goto done;
> +	}
> +
> +	/* Register the subdevices notifier. */
> +	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
> +	if (subdevs == NULL) {
> +		ret = -ENOMEM;
> +		goto done;
> +	}
> +
> +	subdevs[0] = &vin->entity.asd;
> +
> +	vin->notifier.subdevs = subdevs;
> +	vin->notifier.num_subdevs = 1;
> +	vin->notifier.bound = rvin_graph_notify_bound;
> +	vin->notifier.complete = rvin_graph_notify_complete;
> +
> +	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> +	if (ret < 0) {
> +		vin_err(vin, "Notifier registration failed\n");
> +		goto done;
> +	}
> +
> +	ret = 0;
> +
> +done:
> +	if (ret < 0) {
> +		v4l2_async_notifier_unregister(&vin->notifier);
> +		of_node_put(vin->entity.node);
> +	}
> +
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Platform Device Driver
> + */
> +
> +static const struct of_device_id rvin_of_id_table[] = {
> +	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
> +	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> +
> +static int rvin_get_pdata_flags(struct device *dev, unsigned int *pdata_flags)
> +{
> +	struct v4l2_of_endpoint ep;
> +	struct device_node *np;
> +	unsigned int flags;
> +	int ret;
> +
> +	np = of_graph_get_next_endpoint(dev->of_node, NULL);
> +	if (!np) {
> +		dev_err(dev, "Could not find endpoint\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = v4l2_of_parse_endpoint(np, &ep);
> +	if (ret) {
> +		dev_err(dev, "Could not parse endpoint\n");
> +		return ret;
> +	}
> +
> +	if (ep.bus_type == V4L2_MBUS_BT656)
> +		flags = RVIN_BT656;
> +	else {
> +		flags = 0;
> +		if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +			flags |= RVIN_HSYNC_ACTIVE_LOW;
> +		if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +			flags |= RVIN_VSYNC_ACTIVE_LOW;
> +	}
> +
> +	of_node_put(np);
> +
> +	*pdata_flags = flags;
> +
> +	return 0;
> +}
> +
> +static int rvin_init(struct rvin_dev *vin, struct platform_device *pdev)
> +{
> +	const struct of_device_id *match = NULL;
> +	struct resource *mem;
> +	int ret;
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (mem == NULL)
> +		return -EINVAL;
> +
> +	vin->dev = &pdev->dev;
> +
> +	match = of_match_device(of_match_ptr(rvin_of_id_table), vin->dev);
> +	if (!match)
> +		return -ENODEV;
> +	vin->chip = (enum chip_id)match->data;
> +
> +	ret = rvin_get_pdata_flags(vin->dev, &vin->pdata_flags);
> +	if (ret)
> +		return ret;
> +
> +	vin->base = devm_ioremap_resource(vin->dev, mem);
> +	if (IS_ERR(vin->base))
> +		return PTR_ERR(vin->base);
> +
> +	/* Initialize the top-level structure */
> +	return v4l2_device_register(vin->dev, &vin->v4l2_dev);
> +}
> +
> +static int rcar_vin_probe(struct platform_device *pdev)
> +{
> +	struct rvin_dev *vin;
> +	int irq, ret;
> +
> +	vin = devm_kzalloc(&pdev->dev, sizeof(*vin), GFP_KERNEL);
> +	if (!vin)
> +		return -ENOMEM;
> +
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0)
> +		return -EINVAL;
> +
> +
> +	ret = rvin_init(vin, pdev);
> +	if (ret)
> +		goto error;
> +
> +	ret = rvin_dma_init(vin, irq);
> +	if (ret)
> +		goto free_dev;

This isn't right: dma_init creates the video node before everything it set up.
Once the video node is creates, applications can start accessing it. It is
best to do this as the very last thing from rvin_graph_notify_complete().

> +
> +	ret = rvin_graph_init(vin);
> +	if (ret < 0)
> +		goto free_dma;
> +
> +	pm_suspend_ignore_children(&pdev->dev, true);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	platform_set_drvdata(pdev, vin);
> +
> +	return 0;
> +
> +free_dma:
> +	rvin_dma_cleanup(vin);
> +free_dev:
> +	v4l2_device_unregister(&vin->v4l2_dev);
> +error:
> +
> +	return ret;
> +}
> +
> +static int rcar_vin_remove(struct platform_device *pdev)
> +{
> +	struct rvin_dev *vin = platform_get_drvdata(pdev);
> +
> +	v4l2_async_notifier_unregister(&vin->notifier);
> +
> +	rvin_dma_cleanup(vin);
> +
> +	pm_runtime_disable(&pdev->dev);
> +
> +	v4l2_device_unregister(&vin->v4l2_dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver rcar_vin_driver = {
> +	.driver = {
> +		.name = "rcar-vin",
> +		.of_match_table = rvin_of_id_table,
> +	},
> +	.probe = rcar_vin_probe,
> +	.remove = rcar_vin_remove,
> +};
> +
> +module_platform_driver(rcar_vin_driver);
> +
> +MODULE_AUTHOR("Niklas Söderlund <niklas.soderlund@ragnatech.se>");
> +MODULE_DESCRIPTION("Renesas R-Car VIN camera host driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> new file mode 100644
> index 0000000..c267309
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -0,0 +1,1073 @@
> +/*
> + * Driver for Renesas R-Car VIN
> + *
> + * Copyright (C) 2016 Renesas Electronics Corp.
> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on the soc-camera rcar_vin driver
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/pm_runtime.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "rcar-vin.h"
> +
> +#define RVIN_DEFAULT_FORMAT		V4L2_PIX_FMT_YUYV
> +#define RVIN_MAX_WIDTH		2048
> +#define RVIN_MAX_HEIGHT		2048
> +#define RVIN_TIMEOUT_MS		100
> +
> +struct rvin_buffer {
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head list;
> +};
> +
> +#define to_buf_list(vb2_buffer) (&container_of(vb2_buffer, \
> +					       struct rvin_buffer, \
> +					       vb)->list)
> +
> +/* -----------------------------------------------------------------------------
> + * DMA Functions
> + */
> +
> +/* Moves a buffer from the queue to the HW slots */
> +static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
> +{
> +	struct rvin_buffer *buf;
> +	struct vb2_v4l2_buffer *vbuf;
> +	dma_addr_t phys_addr_top;
> +
> +	if (vin->queue_buf[slot] != NULL)
> +		return true;
> +
> +	if (list_empty(&vin->buf_list))
> +		return false;
> +
> +	vin_dbg(vin, "Filling HW slot: %d\n", slot);
> +
> +	/* Keep track of buffer we give to HW */
> +	buf = list_entry(vin->buf_list.next, struct rvin_buffer, list);
> +	vbuf = &buf->vb;
> +	list_del_init(to_buf_list(vbuf));
> +	vin->queue_buf[slot] = vbuf;
> +
> +	/* Setup DMA */
> +	phys_addr_top = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
> +	rvin_set_slot_addr(vin, slot, phys_addr_top);
> +
> +	return true;
> +}
> +
> +static bool rvin_fill_hw(struct rvin_dev *vin)
> +{
> +	int slot, limit;
> +
> +	limit = vin->continuous ? HW_BUFFER_NUM : 1;
> +
> +	for (slot = 0; slot < limit; slot++)
> +		if (!rvin_fill_hw_slot(vin, slot))
> +			return false;
> +	return true;
> +}
> +
> +static irqreturn_t rvin_irq(int irq, void *data)
> +{
> +	struct rvin_dev *vin = data;
> +	u32 int_status;
> +	int slot;
> +	unsigned int handled = 0;
> +	unsigned long flags;
> +	unsigned sequence;
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +
> +	int_status = rvin_get_interrupt_status(vin);
> +	if (!int_status)
> +		goto done;
> +
> +	rvin_ack_interrupt(vin);
> +	handled = 1;
> +
> +	/* Nothing to do if capture status is 'STOPPED' */
> +	if (vin->state == STOPPED) {
> +		vin_dbg(vin, "IRQ state stopped\n");
> +		goto done;
> +	}
> +
> +	/* Wait for HW to shutdown */
> +	if (vin->state == STOPPING) {
> +		if (!rvin_capture_active(vin)) {
> +			vin_dbg(vin, "IRQ hw stopped and we are stopping\n");
> +			complete(&vin->capture_stop);
> +		}
> +		goto done;
> +	}
> +
> +	/* Prepare for capture and update state */
> +	slot = rvin_get_active_slot(vin);
> +	sequence = vin->sequence++;
> +
> +	vin_dbg(vin, "IRQ %02d: %d\tbuf0: %c buf1: %c buf2: %c\tmore: %d\n",
> +		sequence, slot,
> +		slot == 0 ? 'x' : vin->queue_buf[0] != NULL ? '1' : '0',
> +		slot == 1 ? 'x' : vin->queue_buf[1] != NULL ? '1' : '0',
> +		slot == 2 ? 'x' : vin->queue_buf[2] != NULL ? '1' : '0',
> +		!list_empty(&vin->buf_list));
> +
> +	/* HW have written to a slot that is not prepared we are in trouble */
> +	if (WARN_ON((vin->queue_buf[slot] == NULL)))
> +		goto done;
> +
> +	/* Capture frame */
> +	vin->queue_buf[slot]->field = vin->format.field;
> +	vin->queue_buf[slot]->sequence = sequence;
> +	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
> +	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
> +	vin->queue_buf[slot] = NULL;
> +
> +	/* Prepare for next frame */
> +	if (!rvin_fill_hw(vin)) {
> +
> +		/*
> +		 * Can't supply HW with new buffers fast enough. Halt
> +		 * capture until more buffers are available.
> +		 */
> +		vin->state = STALLED;
> +
> +		/*
> +		 * The continuous capturing requires an explicit stop
> +		 * operation when there is no buffer to be set into
> +		 * the VnMBm registers.
> +		 */
> +		if (vin->continuous) {
> +			rvin_capture_off(vin);
> +			vin_dbg(vin, "IRQ %02d: hw not ready stop\n", sequence);
> +		}
> +	} else {
> +		/*
> +		 * The single capturing requires an explicit capture
> +		 * operation to fetch the next frame.
> +		 */
> +		if (!vin->continuous)
> +			rvin_capture_on(vin);
> +	}
> +done:
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
> +/* Need to hold qlock before calling */
> +static void return_all_buffers(struct rvin_dev *vin,
> +			       enum vb2_buffer_state state)
> +{
> +	struct rvin_buffer *buf, *node;
> +
> +	list_for_each_entry_safe(buf, node, &vin->buf_list, list) {
> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
> +		list_del(&buf->list);
> +	}
> +}
> +
> +static int rvin_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +			    unsigned int *nplanes, unsigned int sizes[],
> +			    void *alloc_ctxs[])
> +
> +{
> +	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> +
> +	alloc_ctxs[0] = vin->alloc_ctx;
> +	/* Make sure the image size is large enough. */
> +	if (*nplanes)
> +		return sizes[0] < vin->format.sizeimage ? -EINVAL : 0;
> +
> +	*nplanes = 1;
> +	sizes[0] = vin->format.sizeimage;
> +
> +	return 0;
> +};
> +
> +static int rvin_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct rvin_dev *vin = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size = vin->format.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		vin_err(vin, "buffer too small (%lu < %lu)\n",
> +			vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);
> +
> +	return 0;
> +}
> +
> +static void rvin_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct rvin_dev *vin = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +
> +	list_add_tail(to_buf_list(vbuf), &vin->buf_list);
> +
> +	/*
> +	 * If capture is stalled add buffer to HW and restart
> +	 * capturing if HW is ready to continue.
> +	 */
> +	if (vin->state == STALLED)
> +		if (rvin_fill_hw(vin))
> +			rvin_capture_on(vin);
> +
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +}
> +
> +static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *sd;
> +	unsigned long flags;
> +
> +	sd = vin_to_sd(vin);
> +	v4l2_subdev_call(sd, video, s_stream, 1);
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +
> +	vin->state = RUNNING;
> +	vin->sequence = 0;
> +	init_completion(&vin->capture_stop);
> +
> +	/* Continuous capture requires more buffers then there is HW slots */
> +	vin->continuous = count > HW_BUFFER_NUM;
> +
> +	/* Wait until HW is ready to start capturing */
> +	while (!rvin_fill_hw(vin))
> +		msleep(20);

I would recommend a timeout or at the very least make this interruptible.
Otherwise this could potentially loop forever.

Actually, you can't do this here anyway since you are in a critical section
with interrupts disabled. No sleep allowed.

> +
> +	rvin_capture_start(vin);
> +
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +
> +	return 0;
> +}
> +
> +static void rvin_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct rvin_dev *vin = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *sd;
> +	unsigned long flags;
> +	int i;
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +
> +	/* Wait for streaming to stop */
> +	while (vin->state != STOPPED) {
> +
> +		vin->state = STOPPING;
> +
> +		rvin_capture_stop(vin);
> +
> +		/* Wait until capturing has been stopped */
> +		spin_unlock_irqrestore(&vin->qlock, flags);
> +		if (!wait_for_completion_timeout(&vin->capture_stop,
> +					msecs_to_jiffies(RVIN_TIMEOUT_MS)))
> +			vin->state = STOPPED;
> +		spin_lock_irqsave(&vin->qlock, flags);
> +	}
> +
> +	for (i = 0; i < HW_BUFFER_NUM; i++) {
> +		if (vin->queue_buf[i]) {
> +			vb2_buffer_done(&vin->queue_buf[i]->vb2_buf,
> +					VB2_BUF_STATE_ERROR);
> +			vin->queue_buf[i] = NULL;
> +		}
> +	}
> +
> +	/* Release all active buffers */
> +	return_all_buffers(vin, VB2_BUF_STATE_ERROR);
> +
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +
> +	sd = vin_to_sd(vin);
> +	v4l2_subdev_call(sd, video, s_stream, 0);
> +}
> +
> +static struct vb2_ops rvin_qops = {
> +	.queue_setup		= rvin_queue_setup,
> +	.buf_prepare		= rvin_buffer_prepare,
> +	.buf_queue		= rvin_buffer_queue,
> +	.start_streaming	= rvin_start_streaming,
> +	.stop_streaming		= rvin_stop_streaming,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
> +
> +static int __rvin_dma_try_format_sensor(struct rvin_dev *vin,
> +					u32 which,
> +					struct v4l2_pix_format *pix,
> +					struct rvin_sensor *sensor)
> +{
> +	struct v4l2_subdev *sd;
> +	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_format format = {
> +		.which = which,
> +	};
> +	int ret;
> +
> +	sd = vin_to_sd(vin);
> +
> +	v4l2_fill_mbus_format(&format.format, pix, vin->sensor.code);
> +
> +	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
> +					 &pad_cfg, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	v4l2_fill_pix_format(pix, &format.format);
> +
> +	sensor->width = pix->width;
> +	sensor->height = pix->height;
> +
> +	vin_dbg(vin, "Sensor format: %ux%u\n", sensor->width, sensor->height);
> +
> +	return 0;
> +}
> +
> +static int __rvin_dma_try_format(struct rvin_dev *vin,
> +				 u32 which,
> +				 struct v4l2_pix_format *pix,
> +				 struct rvin_sensor *sensor)
> +{
> +	const struct rvin_video_format *info;
> +	u32 rwidth, rheight;
> +
> +	/* Requested */
> +	rwidth = pix->width;
> +	rheight = pix->height;
> +
> +	/*
> +	 * Retrieve format information and select the current format if the
> +	 * requested format isn't supported.
> +	 */
> +	info = rvin_format_from_pixel(pix->pixelformat);
> +	if (!info) {
> +		vin_dbg(vin, "Format %x not found, keeping %x\n",
> +			pix->pixelformat, vin->format.pixelformat);
> +		pix->pixelformat = vin->format.pixelformat;
> +		pix->colorspace = vin->format.colorspace;

Please also copy the ycbcr_enc, xfer_func and quantization fields.

> +		pix->field = vin->format.field;
> +	}
> +
> +	/* Always recalculate */
> +	pix->bytesperline = 0;
> +	pix->sizeimage = 0;
> +
> +	/* Limit to sensor capabilities */
> +	__rvin_dma_try_format_sensor(vin, which, pix, sensor);
> +
> +	/* If sensor can't match format try if VIN can scale */
> +	if (sensor->width != rwidth || sensor->height != rheight)
> +		rvin_scale_try(vin, pix, rwidth, rheight);
> +
> +	/* Limit to VIN capabilities */
> +	v4l_bound_align_image(&pix->width, 2, RVIN_MAX_WIDTH, 1,
> +			      &pix->height, 4, RVIN_MAX_HEIGHT, 2, 0);
> +
> +	switch (pix->field) {
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	default:
> +		pix->field = V4L2_FIELD_NONE;
> +		break;
> +	}
> +
> +	pix->bytesperline = max_t(u32, pix->bytesperline,
> +				  rvin_format_bytesperline(pix));
> +	pix->sizeimage = max_t(u32, pix->sizeimage,
> +			       rvin_format_sizeimage(pix));
> +
> +	vin_dbg(vin, "Requested %ux%u Got %ux%u bpl: %d size: %d\n",
> +		rwidth, rheight, pix->width, pix->height,
> +		pix->bytesperline, pix->sizeimage);
> +
> +	return 0;
> +}
> +
> +static int rvin_querycap(struct file *file, void *priv,
> +			 struct v4l2_capability *cap)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(vin->dev));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +		V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct rvin_sensor sensor;
> +
> +	return __rvin_dma_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
> +				     &sensor);
> +}
> +
> +static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct rvin_sensor sensor;
> +	int ret;
> +
> +	if (vb2_is_busy(&vin->queue))
> +		return -EBUSY;
> +
> +	ret = __rvin_dma_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> +				    &sensor);
> +	if (ret)
> +		return ret;
> +
> +	vin->sensor.width = sensor.width;
> +	vin->sensor.height = sensor.height;
> +
> +	vin->format = f->fmt.pix;
> +
> +	return 0;
> +}
> +
> +static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
> +			      struct v4l2_format *f)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	f->fmt.pix = vin->format;
> +
> +	return 0;
> +}
> +
> +static int rvin_enum_fmt_vid_cap(struct file *file, void *priv,
> +				 struct v4l2_fmtdesc *f)
> +{
> +	const struct rvin_video_format *fmt = rvin_format_from_num(f->index);
> +
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +
> +static int rvin_g_selection(struct file *file, void *fh,
> +			    struct v4l2_selection *s)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		s->r.left = s->r.top = 0;
> +		s->r.width = vin->sensor.width;
> +		s->r.height = vin->sensor.height;
> +		break;
> +	case V4L2_SEL_TGT_CROP:
> +		s->r = vin->crop;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		s->r.left = s->r.top = 0;
> +		s->r.width = vin->format.width;
> +		s->r.height = vin->format.height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		s->r = vin->compose;
> +		/*
> +		 * FIXME: Is this correct? v4l2-compliance test fails
> +		 * if top and left are not 0.
> +		 */
> +		s->r.top = 0;
> +		s->r.left = 0;

You are right, that's a v4l2-compliance bug. I've fixed this in the master branch,
so you can remove this comment and the assignments.

Or (even better) remove support for this completely since you don't have any
padding issues, so why implement it at all?

> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		s->r = vin->compose;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rect_set_min_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *min_size)
> +{
> +	if (r->width < min_size->width)
> +		r->width = min_size->width;
> +	if (r->height < min_size->height)
> +		r->height = min_size->height;
> +}
> +
> +static void rect_set_max_size(struct v4l2_rect *r,
> +			      const struct v4l2_rect *max_size)
> +{
> +	if (r->width > max_size->width)
> +		r->width = max_size->width;
> +	if (r->height > max_size->height)
> +		r->height = max_size->height;
> +}
> +
> +static void rect_map_inside(struct v4l2_rect *r,
> +			    const struct v4l2_rect *boundary)
> +{
> +	rect_set_max_size(r, boundary);
> +
> +	if (r->left < boundary->left)
> +		r->left = boundary->left;
> +	if (r->top < boundary->top)
> +		r->top = boundary->top;
> +	if (r->left + r->width > boundary->width)
> +		r->left = boundary->width - r->width;
> +	if (r->top + r->height > boundary->height)
> +		r->top = boundary->height - r->height;
> +}
> +
> +static int rvin_s_selection(struct file *file, void *fh,
> +			    struct v4l2_selection *s)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	const struct rvin_video_format *fmt;
> +	struct v4l2_rect r = s->r;
> +	struct v4l2_rect max_rect;
> +	struct v4l2_rect min_rect = {
> +		.width = 6,
> +		.height = 2,
> +	};
> +
> +	rect_set_min_size(&r, &min_rect);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		/* Can't crop outside of sensor input */
> +		max_rect.top = max_rect.left = 0;
> +		max_rect.width = vin->sensor.width;
> +		max_rect.height = vin->sensor.height;
> +		rect_map_inside(&r, &max_rect);
> +
> +		v4l_bound_align_image(&r.width, 2, vin->sensor.width, 1,
> +				      &r.height, 4, vin->sensor.height, 2, 0);
> +
> +		r.top  = clamp_t(s32, r.top, 0, vin->sensor.height - r.height);
> +		r.left = clamp_t(s32, r.left, 0, vin->sensor.width - r.width);
> +
> +		vin->crop = s->r = r;
> +
> +		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
> +			 r.width, r.height, r.left, r.top,
> +			 vin->sensor.width, vin->sensor.height);
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		/* Make sure compose rect fits inside output format */
> +		max_rect.top = max_rect.left = 0;
> +		max_rect.width = vin->format.width;
> +		max_rect.height = vin->format.height;
> +		rect_map_inside(&r, &max_rect);
> +
> +		/*
> +		 * Composing is done by adding a offset to the buffer address,
> +		 * the HW wants this address to be aligned to HW_BUFFER_MASK.
> +		 * Make sure the top and left values meets this requirement.
> +		 */
> +		while ((r.top * vin->format.bytesperline) & HW_BUFFER_MASK)
> +			r.top--;
> +
> +		fmt = rvin_format_from_pixel(vin->format.pixelformat);
> +		while ((r.left * fmt->bpp) & HW_BUFFER_MASK)
> +			r.left--;
> +
> +		vin->compose = s->r = r;
> +
> +		vin_dbg(vin, "Compose %dx%d@%d:%d in %dx%d\n",
> +			 r.width, r.height, r.left, r.top,
> +			 vin->format.width, vin->format.height);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* HW supports modifying configuration while running */
> +	rvin_crop_scale_comp(vin);
> +
> +	return 0;
> +}
> +
> +static int rvin_enum_input(struct file *file, void *priv,
> +			   struct v4l2_input *i)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	if (i->index != 0)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	i->std = vin->vdev.tvnorms;
> +	strlcpy(i->name, "Camera", sizeof(i->name));
> +
> +	return 0;
> +}
> +
> +static int rvin_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int rvin_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	if (i > 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int rvin_querystd(struct file *file, void *priv, v4l2_std_id *a)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	return v4l2_subdev_call(sd, video, querystd, a);
> +}
> +
> +static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	return v4l2_subdev_call(sd, video, s_std, a);
> +}
> +
> +static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	return v4l2_subdev_call(sd, video, g_std, a);

Note that adv7180.c doesn't implement g_std. Which explains why the compliance test
says:

test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)

Adding g_std to adv7180.c should fix this.

There is one other thing that needs to be added to adv7180.c: support for the
cropcap video op. The adv7180 driver should fill in the pixel aspect ratio depending
on the current standard (50 vs 60 Hz).

This driver should implement vidioc_cropcap and call the subdev to fill in this struct.

The adv7180 should *only* fill in the pixelaspect, nothing else.

Take a look at v4l_cropcap in v4l2-ioctl.c: the one thing that CROPCAP does that no
one else does is reporting the pixelaspect ratio. If the driver supports the selection
API, then v4l_cropcap will call the selection ops to fill in most of the fields, but
drivers can still implement cropcap to fill in the pixelaspect.

Yeah, it's ugly but it's the only way it can be done today.

Note that I found a bug in v4l_cropcap: if the subdev doesn't support cropcap, then
v4l2_subdev_call returns -ENOIOCTLCMD and v4l_cropcap should ignore that error.

I'll make a patch for that and CC you on it.

This is one of those very dusty V4L2 corners that at some point we really need to
clean up.

> +}
> +
> +static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
> +	.vidioc_querycap		= rvin_querycap,
> +	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= rvin_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= rvin_s_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap	= rvin_enum_fmt_vid_cap,
> +
> +	.vidioc_g_selection		= rvin_g_selection,
> +	.vidioc_s_selection		= rvin_s_selection,
> +
> +	.vidioc_enum_input		= rvin_enum_input,
> +	.vidioc_g_input			= rvin_g_input,
> +	.vidioc_s_input			= rvin_s_input,
> +
> +	.vidioc_querystd		= rvin_querystd,
> +	.vidioc_g_std			= rvin_g_std,
> +	.vidioc_s_std			= rvin_s_std,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +
> +	.vidioc_log_status		= v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * File Operations
> + */
> +
> +static int __rvin_power_on(struct rvin_dev *vin)
> +{
> +	int ret;
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +	return 0;
> +}
> +
> +static int __rvin_power_off(struct rvin_dev *vin)
> +{
> +	int ret;
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 0);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +	return 0;
> +}
> +static int rvin_add_device(struct rvin_dev *vin)
> +{
> +	int i;
> +
> +	for (i = 0; i < HW_BUFFER_NUM; i++)
> +		vin->queue_buf[i] = NULL;
> +
> +	pm_runtime_get_sync(vin->v4l2_dev.dev);
> +
> +	return 0;
> +}
> +
> +static int rvin_remove_device(struct rvin_dev *vin)
> +{
> +	struct vb2_v4l2_buffer *vbuf;
> +	unsigned long flags;
> +	int i;
> +
> +	/* disable capture, disable interrupts */
> +	rvin_capture_stop(vin);
> +	rvin_disable_interrupts(vin);
> +
> +	vin->state = STOPPED;
> +
> +	spin_lock_irqsave(&vin->qlock, flags);
> +	for (i = 0; i < HW_BUFFER_NUM; i++) {
> +		vbuf = vin->queue_buf[i];
> +		if (vbuf) {
> +			list_del_init(to_buf_list(vbuf));
> +			vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_ERROR);
> +		}
> +	}
> +	spin_unlock_irqrestore(&vin->qlock, flags);
> +
> +	pm_runtime_put(vin->v4l2_dev.dev);
> +
> +	return 0;
> +}
> +
> +static int rvin_initialize_device(struct file *file)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	int ret;
> +
> +	struct v4l2_format f = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +		.fmt.pix = {
> +			.width		= vin->format.width,
> +			.height		= vin->format.height,
> +			.field		= vin->format.field,
> +			.colorspace	= vin->format.colorspace,
> +			.pixelformat	= vin->format.pixelformat,
> +		},
> +	};
> +
> +	rvin_add_device(vin);
> +
> +	/* Power on subdevice */
> +	ret = __rvin_power_on(vin);
> +	if (ret < 0)
> +		goto epower;
> +
> +	pm_runtime_enable(&vin->vdev.dev);
> +	ret = pm_runtime_resume(&vin->vdev.dev);
> +	if (ret < 0 && ret != -ENOSYS)
> +		goto eresume;
> +
> +	/*
> +	 * Try to configure with default parameters. Notice: this is the
> +	 * very first open, so, we cannot race against other calls,
> +	 * apart from someone else calling open() simultaneously, but
> +	 * .host_lock is protecting us against it.
> +	 */
> +	ret = rvin_s_fmt_vid_cap(file, NULL, &f);
> +	if (ret < 0)
> +		goto esfmt;
> +
> +	v4l2_ctrl_handler_setup(&vin->ctrl_handler);
> +
> +	return 0;
> +esfmt:
> +	pm_runtime_disable(&vin->vdev.dev);
> +eresume:
> +	__rvin_power_off(vin);
> +epower:
> +	rvin_remove_device(vin);
> +
> +	return ret;
> +}
> +
> +static int rvin_open(struct file *file)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&vin->lock);
> +
> +	file->private_data = vin;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret)
> +		goto unlock;
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	if (rvin_initialize_device(file)) {
> +		v4l2_fh_release(file);
> +		ret = -ENODEV;
> +	}
> +
> +unlock:
> +	mutex_unlock(&vin->lock);
> +	return ret;
> +}
> +
> +static int rvin_release(struct file *file)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	bool fh_singular;
> +	int ret;
> +
> +	mutex_lock(&vin->lock);
> +
> +	/* Save the singular status before we call the clean-up helper */
> +	fh_singular = v4l2_fh_is_singular_file(file);
> +
> +	/* the release helper will cleanup any on-going streaming */
> +	ret = _vb2_fop_release(file, NULL);
> +
> +	/*
> +	 * If this was the last open file.
> +	 * Then de-initialize hw module.
> +	 */
> +	if (fh_singular) {
> +		pm_runtime_suspend(&vin->vdev.dev);
> +		pm_runtime_disable(&vin->vdev.dev);
> +
> +		__rvin_power_off(vin);
> +
> +		rvin_remove_device(vin);
> +	}
> +
> +	mutex_unlock(&vin->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_file_operations rvin_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.open		= rvin_open,
> +	.release	= rvin_release,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,
> +	.read		= vb2_fop_read,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * DMA Core
> + */
> +
> +void rvin_dma_cleanup(struct rvin_dev *vin)
> +{
> +	if (video_is_registered(&vin->vdev)) {

No need to test, video_unregister_device() tests for this already.

> +		v4l2_info(&vin->v4l2_dev, "Removing /dev/video%d\n",
> +			  vin->vdev.num);

Use video_device_node_name() to get the video name.

> +		video_unregister_device(&vin->vdev);
> +	}
> +
> +	if (!IS_ERR_OR_NULL(vin->alloc_ctx))
> +		vb2_dma_contig_cleanup_ctx(vin->alloc_ctx);
> +
> +	/* Checks internaly if handlers have been init or not */
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +
> +	mutex_destroy(&vin->lock);
> +}
> +
> +int rvin_dma_init(struct rvin_dev *vin, int irq)
> +{
> +	struct video_device *vdev = &vin->vdev;
> +	struct vb2_queue *q = &vin->queue;
> +	int ret;
> +
> +	mutex_init(&vin->lock);
> +	INIT_LIST_HEAD(&vin->buf_list);
> +
> +	spin_lock_init(&vin->qlock);
> +
> +	vin->state = STOPPED;
> +
> +	/* Add the controls */
> +	/*
> +	 * Currently the subdev with the largest number of controls (13) is
> +	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> +	 * that this is a hint only: too large and you waste some memory, too
> +	 * small and there is a (very) small performance hit when looking up
> +	 * controls in the internal hash.
> +	 */
> +	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> +	if (ret < 0)
> +		goto error;
> +
> +	/* video node */
> +	vdev->fops = &rvin_fops;
> +	vdev->v4l2_dev = &vin->v4l2_dev;
> +	vdev->queue = &vin->queue;
> +	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	vdev->release = video_device_release_empty;
> +	vdev->ioctl_ops = &rvin_ioctl_ops;
> +	vdev->lock = &vin->lock;
> +	vdev->ctrl_handler = &vin->ctrl_handler;
> +
> +	/* buffer queue */
> +	vin->alloc_ctx = vb2_dma_contig_init_ctx(vin->dev);
> +	if (IS_ERR(vin->alloc_ctx)) {
> +		ret = PTR_ERR(vin->alloc_ctx);
> +		goto error;
> +	}
> +
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
> +	q->lock = &vin->lock;
> +	q->drv_priv = vin;
> +	q->buf_struct_size = sizeof(struct rvin_buffer);
> +	q->ops = &rvin_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->min_buffers_needed = 2;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret < 0) {
> +		vin_err(vin, "failed to initialize VB2 queue\n");
> +		goto error;
> +	}
> +
> +	/* irq */
> +	ret = devm_request_irq(vin->dev, irq, rvin_irq, IRQF_SHARED,
> +			       KBUILD_MODNAME, vin);
> +	if (ret) {
> +		vin_err(vin, "failed to request irq\n");
> +		goto error;
> +	}
> +
> +	return 0;
> +error:
> +	rvin_dma_cleanup(vin);
> +	return ret;
> +}
> +
> +int rvin_dma_on(struct rvin_dev *vin)
> +{
> +	struct v4l2_subdev *sd;
> +	struct v4l2_subdev_format fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct v4l2_mbus_framefmt *mf = &fmt.format;
> +	int ret;
> +
> +	sd = vin_to_sd(vin);
> +
> +	/* Set default format */
> +	vin->format.pixelformat = RVIN_DEFAULT_FORMAT;
> +
> +	sd->grp_id = 0;

Unused, left-over from soc-camera. Just drop this line.

> +	v4l2_set_subdev_hostdata(sd, vin);
> +
> +	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	if (vin->vdev.tvnorms == 0) {
> +		/* Disable the STD API if there are no tvnorms defined */
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> +	}
> +
> +	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = rvin_add_device(vin);
> +	if (ret < 0) {
> +		vin_err(vin, "Couldn't activate the camera: %d\n", ret);
> +		return ret;
> +	}
> +
> +	vin->format.field = V4L2_FIELD_ANY;
> +
> +	/* Try to improve our guess of a reasonable window format */
> +	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
> +	if (ret) {
> +		vin_err(vin, "Failed to get initial format\n");
> +		goto remove_device;
> +	}
> +
> +	vin->format.width	= mf->width;
> +	vin->format.height	= mf->height;
> +	vin->format.colorspace	= mf->colorspace;
> +	vin->format.field	= mf->field;
> +
> +	/* Set initial crop and compose */
> +	vin->crop.top = vin->crop.left = 0;
> +	vin->crop.width = mf->width;
> +	vin->crop.height = mf->height;
> +
> +	vin->compose.top = vin->compose.left = 0;
> +	vin->compose.width = mf->width;
> +	vin->compose.height = mf->height;
> +
> +	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		vin_err(vin, "Failed to register video device\n");
> +		goto remove_device;
> +	}
> +
> +	video_set_drvdata(&vin->vdev, vin);
> +
> +	v4l2_info(&vin->v4l2_dev, "Device registered as /dev/video%d\n",
> +		  vin->vdev.num);
> +
> +remove_device:
> +	rvin_remove_device(vin);
> +
> +	return ret;
> +}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> new file mode 100644
> index 0000000..f07cd7c
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -0,0 +1,198 @@
> +/*
> + * Driver for Renesas R-Car VIN
> + *
> + * Copyright (C) 2016 Renesas Electronics Corp.
> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on the soc-camera rcar_vin driver
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __RCAR_VIN__
> +#define __RCAR_VIN__
> +
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +/* Number of HW buffers */
> +#define HW_BUFFER_NUM 3
> +
> +/* Address aliment mask for HW buffers */
> +#define HW_BUFFER_MASK 0x7f
> +
> +enum chip_id {
> +	RCAR_GEN2,
> +	RCAR_H1,
> +	RCAR_M1,
> +	RCAR_E1,
> +};
> +
> +/**
> + * STOPPED  - No operation in progress
> + * RUNNING  - Operation in progress have buffers
> + * STALLED  - No operation in progress have no buffers
> + * STOPPING - Stopping operation
> + */
> +enum rvin_dma_state {
> +	STOPPED = 0,
> +	RUNNING,
> +	STALLED,
> +	STOPPING,
> +};
> +
> +/**
> + * struct rvin_sensor - Sensor information
> + * @code:		Media bus format from sensor
> + * @width:		Width of sensor output
> + * @height:		Height of sensor output
> + */
> +struct rvin_sensor {
> +	u32 code;
> +	u32 width;
> +	u32 height;
> +};
> +
> +/**
> + * struct rvin_video_format - Data format stored in memory
> + * @fourcc:	Pixelformat
> + * @bpp:	Bytes per pixel
> + */
> +struct rvin_video_format {
> +	u32			fourcc;
> +	u8			bpp;
> +};
> +
> +struct rvin_graph_entity {
> +	struct device_node *node;
> +	struct media_entity *entity;
> +
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_subdev *subdev;
> +};
> +
> +/**
> + * struct rvin_dev - Renesas VIN device structure
> + * @dev:		(OF) device
> + * @base:		device I/O register space remapped to virtual memory
> + * @chip:		type of VIN chip
> + * @pdata_flags:	information from platform data
> + *			TODO: ported from soc-camera driver maybe something
> + *			more intelligent can be done here.
> + *
> + * @vdev:		V4L2 video device associated with VIN
> + * @v4l2_dev:		V4L2 device
> + * @ctrl_handler:	V4L2 control handler
> + * @notifier:		V4L2 asynchronous subdevs notifier
> + * @entity:		entity in the DT for subdevice
> + *
> + * @lock:		protects @queue
> + * @queue:		vb2 buffers queue
> + * @alloc_ctx:		allocation context for the vb2 @queue
> + *
> + * @qlock:		protects @queue_buf, @buf_list, @continuous, @sequence
> + *			@state, @capture_stop
> + * @queue_buf:		Keeps track of buffers given to HW slot
> + * @buf_list:		list of queued buffers
> + * @continuous:		tracks if active operation is continuous or single mode
> + * @sequence:		V4L2 buffers sequence number
> + * @state:		keeps track of operation state
> + * @capture_stop:	signals if operations stopped
> + *
> + * @sensor:		active sensor format
> + * @format:		active V4L2 pixel format
> + *
> + * @crop:		active cropping
> + * @compose:		active composing
> + */
> +struct rvin_dev {
> +	struct device *dev;
> +	void __iomem *base;
> +	enum chip_id chip;
> +	unsigned int pdata_flags;
> +
> +	struct video_device vdev;
> +	struct v4l2_device v4l2_dev;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	struct v4l2_async_notifier notifier;
> +	struct rvin_graph_entity entity;
> +
> +	struct mutex lock;
> +	struct vb2_queue queue;
> +	struct vb2_alloc_ctx *alloc_ctx;
> +
> +	spinlock_t qlock;
> +	struct vb2_v4l2_buffer *queue_buf[HW_BUFFER_NUM];
> +	struct list_head buf_list;
> +	bool continuous;
> +	unsigned sequence;
> +	enum rvin_dma_state state;
> +	struct completion capture_stop;
> +
> +	struct rvin_sensor sensor;
> +	struct v4l2_pix_format format;
> +
> +	struct v4l2_rect crop;
> +	struct v4l2_rect compose;
> +};
> +
> +#define vin_to_sd(vin)			vin->entity.subdev
> +
> +/* Debug */
> +#define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
> +#define vin_info(d, fmt, arg...)	dev_info(d->dev, fmt, ##arg)
> +#define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
> +#define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
> +
> +/*
> + * Format
> + */
> +const struct rvin_video_format *rvin_format_from_num(int num);
> +const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
> +
> +u32 rvin_format_bytesperline(struct v4l2_pix_format *pix);
> +u32 rvin_format_sizeimage(struct v4l2_pix_format *pix);
> +
> +/*
> + * HW Control functions
> + */
> +int rvin_get_active_slot(struct rvin_dev *vin);
> +void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr);
> +
> +void rvin_disable_interrupts(struct rvin_dev *vin);
> +u32 rvin_get_interrupt_status(struct rvin_dev *vin);
> +void rvin_ack_interrupt(struct rvin_dev *vin);
> +
> +void rvin_capture_start(struct rvin_dev *vin);
> +void rvin_capture_stop(struct rvin_dev *vin);
> +bool rvin_capture_active(struct rvin_dev *vin);
> +
> +void rvin_capture_on(struct rvin_dev *vin);
> +void rvin_capture_off(struct rvin_dev *vin);
> +
> +/*
> + * Cropping, composing and scaling
> + */
> +/* Try to use VIN scaler to get requested resolution */
> +void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
> +		    u32 width, u32 height);
> +
> +/* Program the HW for cropping, composing and scaling requested in @vin */
> +void rvin_crop_scale_comp(struct rvin_dev *vin);
> +
> +/*
> + * DMA Core
> + */
> +int rvin_dma_init(struct rvin_dev *vin, int irq);
> +void rvin_dma_cleanup(struct rvin_dev *vin);
> +int rvin_dma_on(struct rvin_dev *vin);
> +
> +#endif
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index f2776cd..37e90f7 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -33,8 +33,8 @@ config VIDEO_PXA27x
>  	---help---
>  	  This is a v4l2 driver for the PXA27x Quick Capture Interface
> 
> -config VIDEO_RCAR_VIN
> -	tristate "R-Car Video Input (VIN) support"
> +config VIDEO_RCAR_VIN_OLD
> +	tristate "R-Car Video Input (VIN) support (DEPRECATED)"
>  	depends on VIDEO_DEV && SOC_CAMERA
>  	depends on ARCH_SHMOBILE || COMPILE_TEST
>  	depends on HAS_DMA
> diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
> index 2826382..f5f6246 100644
> --- a/drivers/media/platform/soc_camera/Makefile
> +++ b/drivers/media/platform/soc_camera/Makefile
> @@ -13,4 +13,4 @@ obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
>  obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
> -obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar_vin.o
> +obj-$(CONFIG_VIDEO_RCAR_VIN_OLD)	+= rcar_vin.o

Regards,

	Hans

