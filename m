Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48829 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2GKWjv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 18:39:51 -0400
Received: by weyx8 with SMTP id x8so1266330wey.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 15:39:50 -0700 (PDT)
Message-ID: <4FFE00B2.2040906@gmail.com>
Date: Thu, 12 Jul 2012 00:39:46 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com, ameersk@gmail.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v2 01/01] media: gscaler: Add new driver for generic scaler
References: <1341484061-10914-1-git-send-email-shaik.ameer@samsung.com> <1341484061-10914-2-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1341484061-10914-2-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 07/05/2012 12:27 PM, Shaik Ameer Basha wrote:
> This patch add support for gscaler (generic scaler) device which is a

nit: s/add/adds

> new device for scaling and color space conversion on EXYNOS5 SoCs.
>
> This device supports the followings as key feature.
>   1) Input image format
>     - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, TILE
>   2) Output image format
>     - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, YUV444
>   3) Input rotation
>     - 0/90/180/270 degree, X/Y Flip
>   4) Scale ratio
>     - 1/16 scale down to 8 scale up
>   5) CSC
>     - RGB to YUV / YUV to RGB
>   6) Size
>     - 2048 x 2048 for tile or rotation
>     - 4800 x 3344 other case
>
> Signed-off-by: Hynwoong Kim<khw0178.kim@samsung.com>
> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>

Overall this looks quite good to me. There seems just to be a few issues
that need more polishing. Please see below...

> ---
>   drivers/media/video/Kconfig               |   10 +
>   drivers/media/video/Makefile              |    1 +
>   drivers/media/video/exynos/Kconfig        |   11 +
>   drivers/media/video/exynos/Makefile       |    1 +
>   drivers/media/video/exynos/gsc/Kconfig    |    7 +
>   drivers/media/video/exynos/gsc/Makefile   |    3 +
>   drivers/media/video/exynos/gsc/gsc-core.c | 1304 +++++++++++++++++++++++++++++
>   drivers/media/video/exynos/gsc/gsc-core.h |  652 ++++++++++++++
>   drivers/media/video/exynos/gsc/gsc-m2m.c  |  751 +++++++++++++++++
>   drivers/media/video/exynos/gsc/gsc-regs.c |  579 +++++++++++++
>   drivers/media/video/exynos/gsc/gsc-regs.h |  211 +++++
>   include/linux/videodev2.h                 |    2 +
>   12 files changed, 3532 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/exynos/Kconfig
>   create mode 100644 drivers/media/video/exynos/Makefile
>   create mode 100644 drivers/media/video/exynos/gsc/Kconfig
>   create mode 100644 drivers/media/video/exynos/gsc/Makefile
>   create mode 100644 drivers/media/video/exynos/gsc/gsc-core.c
>   create mode 100644 drivers/media/video/exynos/gsc/gsc-core.h
>   create mode 100644 drivers/media/video/exynos/gsc/gsc-m2m.c
>   create mode 100644 drivers/media/video/exynos/gsc/gsc-regs.c
>   create mode 100644 drivers/media/video/exynos/gsc/gsc-regs.h

How about just placing this driver in drivers/media/video/exynos-gsc/
directory ? We could avoid this way unnecessary number of nested 
directories, plus it would better reflect current situation, as some
media/video/s5p-* drivers also cover Exynos SoCs.

>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 99937c9..0ff1abf 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1153,6 +1153,7 @@ config VIDEO_ATMEL_ISI
>
>   source "drivers/media/video/s5p-fimc/Kconfig"
>   source "drivers/media/video/s5p-tv/Kconfig"
> +source "drivers/media/video/exynos/Kconfig"
>
>   endif # V4L_PLATFORM_DRIVERS
>   endif # VIDEO_CAPTURE_DRIVERS
> @@ -1215,4 +1216,13 @@ config VIDEO_MX2_EMMAPRP
>   	    memory to memory. Operations include resizing and format
>   	    conversion.
>
> +config VIDEO_SAMSUNG_GSCALER
> +        tristate "Samsung Exynos GSC driver"
> +        depends on VIDEO_DEV&&  VIDEO_V4L2&&  PLAT_S5P
> +        select VIDEOBUF2_DMA_CONTIG
> +        select V4L2_MEM2MEM_DEV
> +        select DMA_SHARED_BUFFER

Is this line really needed ? Support for dma_buf could be added 
in a separate patch, after Tomasz's work on dma_buf support in 
V4L2 hits mainline.

> +        help
> +            This is v4l2 based g-scaler driver for EXYNOS5
> +
>   endif # V4L_MEM2MEM_DRIVERS
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index d209de0..4389f3e 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -192,6 +192,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
> +obj-$(CONFIG_VIDEO_EXYNOS)              += exynos/
>
>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
>
> diff --git a/drivers/media/video/exynos/Kconfig b/drivers/media/video/exynos/Kconfig
> new file mode 100644
> index 0000000..f5836a2
> --- /dev/null
> +++ b/drivers/media/video/exynos/Kconfig
> @@ -0,0 +1,11 @@
> +config VIDEO_EXYNOS
> +	bool "Exynos Multimedia Devices"
> +	depends on ARCH_EXYNOS5
> +	select VIDEO_FIXED_MINOR_RANGES
> +	select VIDEOBUF2_DMA_CONTIG
> +	help
> +	  This is a representative exynos multimedia device.
> +
> +if VIDEO_EXYNOS
> +	source "drivers/media/video/exynos/gsc/Kconfig"
> +endif
> diff --git a/drivers/media/video/exynos/Makefile b/drivers/media/video/exynos/Makefile
> new file mode 100644
> index 0000000..1666724
> --- /dev/null
> +++ b/drivers/media/video/exynos/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_EXYNOS_GSCALER)      += gsc/
> diff --git a/drivers/media/video/exynos/gsc/Kconfig b/drivers/media/video/exynos/gsc/Kconfig
> new file mode 100644
> index 0000000..9036078
> --- /dev/null
> +++ b/drivers/media/video/exynos/gsc/Kconfig
> @@ -0,0 +1,7 @@
> +config VIDEO_EXYNOS_GSCALER
> +	bool "Exynos G-Scaler driver"
> +	depends on VIDEO_EXYNOS
> +	select MEDIA_EXYNOS
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	  This is a v4l2 driver for exynos G-Scaler device.
> diff --git a/drivers/media/video/exynos/gsc/Makefile b/drivers/media/video/exynos/gsc/Makefile
> new file mode 100644
> index 0000000..d3f66e4
> --- /dev/null
> +++ b/drivers/media/video/exynos/gsc/Makefile
> @@ -0,0 +1,3 @@
> +gsc-objs := gsc-core.o gsc-m2m.o gsc-regs.o
> +
> +obj-$(CONFIG_VIDEO_SAMSUNG_GSCALER)	+= gsc.o
> diff --git a/drivers/media/video/exynos/gsc/gsc-core.c b/drivers/media/video/exynos/gsc/gsc-core.c
> new file mode 100644
> index 0000000..06bd24f
> --- /dev/null
> +++ b/drivers/media/video/exynos/gsc/gsc-core.c
> @@ -0,0 +1,1304 @@
> +/* linux/drivers/media/video/exynos/gsc/gsc-core.c
> + *
> + * Copyright (c) 2011 - 2012 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Samsung EXYNOS5 SoC series G-scaler driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include<linux/module.h>
> +#include<linux/kernel.h>
> +#include<linux/version.h>
> +#include<linux/types.h>
> +#include<linux/errno.h>
> +#include<linux/bug.h>
> +#include<linux/interrupt.h>
> +#include<linux/workqueue.h>
> +#include<linux/device.h>
> +#include<linux/platform_device.h>
> +#include<linux/list.h>
> +#include<linux/io.h>
> +#include<linux/slab.h>
> +#include<linux/clk.h>
> +#include<media/v4l2-ioctl.h>
> +#include<linux/of.h>
> +#include "gsc-core.h"

How about sorting these alphabetically ? This also applies to
other files.

> +#define GSC_CLOCK_GATE_NAME	"gscl"
> +
> +int gsc_dbg;
> +module_param(gsc_dbg, int, 0644);
> +
> +
> +static struct gsc_fmt gsc_formats[] = {
> +	{
> +		.name		= "RGB565",
> +		.pixelformat	= V4L2_PIX_FMT_RGB565X,
> +		.depth		= { 16 },
> +		.color		= GSC_RGB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +	}, {
> +		.name		= "XRGB-8-8-8-8, 32 bpp",
> +		.pixelformat	= V4L2_PIX_FMT_RGB32,
> +		.depth		= { 32 },
> +		.color		= GSC_RGB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +	}, {
> +		.name		= "YUV 4:2:2 packed, YCbYCr",
> +		.pixelformat	= V4L2_PIX_FMT_YUYV,
> +		.depth		= { 16 },
> +		.color		= GSC_YUV422,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
> +	}, {
> +		.name		= "YUV 4:2:2 packed, CbYCrY",
> +		.pixelformat	= V4L2_PIX_FMT_UYVY,
> +		.depth		= { 16 },
> +		.color		= GSC_YUV422,
> +		.yorder		= GSC_LSB_C,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
> +	}, {
> +		.name		= "YUV 4:2:2 packed, CrYCbY",
> +		.pixelformat	= V4L2_PIX_FMT_VYUY,
> +		.depth		= { 16 },
> +		.color		= GSC_YUV422,
> +		.yorder		= GSC_LSB_C,
> +		.corder		= GSC_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
> +	}, {
> +		.name		= "YUV 4:2:2 packed, YCrYCb",
> +		.pixelformat	= V4L2_PIX_FMT_YVYU,
> +		.depth		= { 16 },
> +		.color		= GSC_YUV422,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
> +	}, {
> +		.name		= "YUV 4:4:4 planar, YCbYCr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV32,
> +		.depth		= { 32 },
> +		.color		= GSC_YUV444,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +	}, {
> +		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV422P,
> +		.depth		= { 16 },
> +		.color		= GSC_YUV422,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 3,
> +	}, {
> +		.name		= "YUV 4:2:2 planar, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV16,
> +		.depth		= { 16 },
> +		.color		= GSC_YUV422,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +	}, {
> +		.name		= "YUV 4:2:2 planar, Y/CrCb",
> +		.pixelformat	= V4L2_PIX_FMT_NV61,
> +		.depth		= { 16 },
> +		.color		= GSC_YUV422,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +	}, {
> +		.name		= "YUV 4:2:0 planar, YCbCr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV420,
> +		.depth		= { 12 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 3,
> +	}, {
> +		.name		= "YUV 4:2:0 planar, YCbCr",
> +		.pixelformat	= V4L2_PIX_FMT_YVU420,
> +		.depth		= { 12 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 3,
> +
> +	}, {
> +		.name		= "YUV 4:2:0 planar, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV12,
> +		.depth		= { 12 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +	}, {
> +		.name		= "YUV 4:2:0 planar, Y/CrCb",
> +		.pixelformat	= V4L2_PIX_FMT_NV21,
> +		.depth		= { 12 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CRCB,
> +		.num_planes	= 1,
> +		.num_comp	= 2,
> +	}, {
> +		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV12M,
> +		.depth		= { 8, 4 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
> +	}, {
> +		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV420M,
> +		.depth		= { 8, 2, 2 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 3,
> +		.num_comp	= 3,
> +	}, {
> +		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cr/Cb",
> +		.pixelformat	= V4L2_PIX_FMT_YVU420M,
> +		.depth		= { 8, 2, 2 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CRCB,
> +		.num_planes	= 3,
> +		.num_comp	= 3,
> +	}, {
> +		.name		=
> +			"YUV 4:2:0 non-contiguous 2-planar, Y/CbCr, tiled",

The maximum length of these character strings should not exceed 32 
(including null terminator, IIRC). So please make these descriptions
shorter. You may want to have a look at:
http://git.infradead.org/users/kmpark/linux-samsung/commitdiff/0350f3f1a407a2d0e6fd6935f8433408ef9d5681

> +		.pixelformat	= V4L2_PIX_FMT_NV12MT_16X16,
> +		.depth		= { 8, 4 },
> +		.color		= GSC_YUV420,
> +		.yorder		= GSC_LSB_Y,
> +		.corder		= GSC_CBCR,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
> +	},
> +};
> +
> +struct gsc_fmt *get_format(int index)
> +{
> +	return&gsc_formats[index];
> +}
> +
> +struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, int index)
> +{
> +	struct gsc_fmt *fmt, *def_fmt = NULL;
> +	unsigned int i;
> +
> +	if (index>= ARRAY_SIZE(gsc_formats))
> +		return NULL;
> +
> +	for (i = 0; i<  ARRAY_SIZE(gsc_formats); ++i) {
> +		fmt = get_format(i);
> +		if (pixelformat&&  fmt->pixelformat == *pixelformat)
> +			return fmt;
> +		if (mbus_code&&  fmt->mbus_code == *mbus_code)
> +			return fmt;
> +		if (index == i)
> +			def_fmt = fmt;
> +	}
> +	return def_fmt;
> +
> +}
> +
> +void gsc_set_frame_size(struct gsc_frame *frame, int width, int height)
> +{
> +	frame->f_width	= width;
> +	frame->f_height	= height;
> +	frame->crop.width = width;
> +	frame->crop.height = height;
> +	frame->crop.left = 0;
> +	frame->crop.top = 0;
> +}
> +
> +int gsc_cal_prescaler_ratio(struct gsc_variant *var, u32 src, u32 dst,
> +								u32 *ratio)
> +{
> +	if ((dst>  src) || (dst>= src / var->poly_sc_down_max)) {
> +		*ratio = 1;
> +		return 0;
> +	}
> +
> +	if ((src / var->poly_sc_down_max / var->pre_sc_down_max)>  dst) {
> +		gsc_err("scale ratio exceeded maximun scale down ratio(1/16)");

typo: maximun -> maximum, I would suggest to make it:

"Exceeded maximum downscaling ratio (1/16)"

> +		return -EINVAL;
> +	}
> +
> +	*ratio = (dst>  (src / 8)) ? 2 : 4;
> +
> +	return 0;
> +}
> +
> +void gsc_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh)
> +{
> +	if (hratio == 4&&  vratio == 4)
> +		*sh = 4;
> +	else if ((hratio == 4&&  vratio == 2) ||
> +		 (hratio == 2&&  vratio == 4))
> +		*sh = 3;
> +	else if ((hratio == 4&&  vratio == 1) ||
> +		 (hratio == 1&&  vratio == 4) ||
> +		 (hratio == 2&&  vratio == 2))
> +		*sh = 2;
> +	else if (hratio == 1&&  vratio == 1)
> +		*sh = 0;
> +	else
> +		*sh = 1;
> +}
> +
> +void gsc_check_src_scale_info(struct gsc_variant *var,
> +				struct gsc_frame *s_frame, u32 *wratio,
> +				 u32 tx, u32 ty, u32 *hratio)
> +{
> +	int remainder = 0, walign, halign;
> +
> +	if (is_yuv420(s_frame->fmt->color)) {
> +		walign = GSC_SC_ALIGN_4;
> +		halign = GSC_SC_ALIGN_4;
> +	} else if (is_yuv422(s_frame->fmt->color)) {
> +		walign = GSC_SC_ALIGN_4;
> +		halign = GSC_SC_ALIGN_2;
> +	} else {
> +		walign = GSC_SC_ALIGN_2;
> +		halign = GSC_SC_ALIGN_2;
> +	}
> +
> +	remainder = s_frame->crop.width % (*wratio * walign);
> +	if (remainder) {
> +		s_frame->crop.width -= remainder;
> +		gsc_cal_prescaler_ratio(var, s_frame->crop.width, tx, wratio);
> +		gsc_info("cropped src width size is recalculated from %d to %d",
> +			s_frame->crop.width + remainder, s_frame->crop.width);
> +	}
> +
> +	remainder = s_frame->crop.height % (*hratio * halign);
> +	if (remainder) {
> +		s_frame->crop.height -= remainder;
> +		gsc_cal_prescaler_ratio(var, s_frame->crop.height, ty, hratio);
> +		gsc_info("cropped src height size is recalculated from %d to %d",
> +			s_frame->crop.height + remainder, s_frame->crop.height);
> +	}
> +}
> +
> +int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f)
> +{
> +	struct gsc_fmt *fmt;
> +
> +	fmt = find_fmt(NULL, NULL, f->index);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
> +	f->pixelformat = fmt->pixelformat;
> +
> +	return 0;
> +}
> +
> +u32 get_plane_size(struct gsc_frame *frame, unsigned int plane)
> +{
> +	if (!frame || plane>= frame->fmt->num_planes) {
> +		gsc_err("Invalid argument");
> +		return 0;
> +	}
> +
> +	return frame->payload[plane];
> +}

Hint: this is only used once. Would perhaps be much better to open
code this within the caller function.

> +
> +u32 get_plane_info(struct gsc_frame frm, u32 addr, u32 *index)
> +{
> +	if (frm.addr.y == addr) {
> +		*index = 0;
> +		return frm.addr.y;
> +	} else if (frm.addr.cb == addr) {
> +		*index = 1;
> +		return frm.addr.cb;
> +	} else if (frm.addr.cr == addr) {
> +		*index = 2;
> +		return frm.addr.cr;
> +	} else {
> +		gsc_err("Plane address is wrong");
> +		return -EINVAL;
> +	}
> +}
> +
> +void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame frm)
> +{
> +	u32 f_chk_addr, f_chk_len, s_chk_addr, s_chk_len;
> +	f_chk_addr = f_chk_len = s_chk_addr = s_chk_len = 0;
> +
> +	f_chk_addr = frm.addr.y;
> +	f_chk_len = frm.payload[0];
> +	if (frm.fmt->num_planes == 2) {
> +		s_chk_addr = frm.addr.cb;
> +		s_chk_len = frm.payload[1];
> +	} else if (frm.fmt->num_planes == 3) {
> +		u32 low_addr, low_plane, mid_addr, mid_plane;
> +		u32 high_addr, high_plane;
> +		u32 t_min, t_max;
> +
> +		t_min = min3(frm.addr.y, frm.addr.cb, frm.addr.cr);
> +		low_addr = get_plane_info(frm, t_min,&low_plane);
> +		t_max = max3(frm.addr.y, frm.addr.cb, frm.addr.cr);
> +		high_addr = get_plane_info(frm, t_max,&high_plane);
> +
> +		mid_plane = 3 - (low_plane + high_plane);
> +		if (mid_plane == 0)
> +			mid_addr = frm.addr.y;
> +		else if (mid_plane == 1)
> +			mid_addr = frm.addr.cb;
> +		else if (mid_plane == 2)
> +			mid_addr = frm.addr.cr;
> +		else
> +			return;
> +
> +		f_chk_addr = low_addr;
> +		if (mid_addr + frm.payload[mid_plane] - low_addr>
> +		    high_addr + frm.payload[high_plane] - mid_addr) {
> +			f_chk_len = frm.payload[low_plane];
> +			s_chk_addr = mid_addr;
> +			s_chk_len = high_addr +
> +					frm.payload[high_plane] - mid_addr;
> +		} else {
> +			f_chk_len = mid_addr +
> +					frm.payload[mid_plane] - low_addr;
> +			s_chk_addr = high_addr;
> +			s_chk_len = frm.payload[high_plane];
> +		}
> +	}
> +	gsc_dbg("f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
> +		f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
> +}
> +
> +int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +	struct gsc_variant *variant = gsc->variant;
> +	struct v4l2_pix_format_mplane *pix_mp =&f->fmt.pix_mp;
> +	struct gsc_fmt *fmt;
> +	u32 max_w, max_h, mod_x, mod_y;
> +	u32 min_w, min_h, tmp_w, tmp_h;
> +	int i;
> +
> +	gsc_dbg("user put w: %d, h: %d", pix_mp->width, pix_mp->height);

Would be nice to get rid of all gsc_dbg/err/... macros and use dev_dbg/err/...,
v4l2_dbg/err or just plain pr_debug + "#define pr_fmt(fmt) ...".

It's up to yo though. I think it's preferred to use common debugging
utilities across the kernel, rather than having each driver inventing
their own.

> +
> +	fmt = find_fmt(&pix_mp->pixelformat, NULL, 0);
> +	if (!fmt) {
> +		gsc_err("pixelformat format (0x%X) invalid\n",
> +						pix_mp->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	if (pix_mp->field == V4L2_FIELD_ANY)
> +		pix_mp->field = V4L2_FIELD_NONE;
> +	else if (pix_mp->field != V4L2_FIELD_NONE) {
> +		gsc_err("Not supported field order(%d)\n", pix_mp->field);
> +		return -EINVAL;
> +	}
> +
> +	max_w = variant->pix_max->target_rot_dis_w;
> +	max_h = variant->pix_max->target_rot_dis_h;
> +	if (V4L2_TYPE_IS_OUTPUT(f->type)) {
> +		mod_x = ffs(variant->pix_align->org_w) - 1;
> +		if (is_yuv420(fmt->color))
> +			mod_y = ffs(variant->pix_align->org_h) - 1;
> +		else
> +			mod_y = ffs(variant->pix_align->org_h) - 2;
> +		min_w = variant->pix_min->org_w;
> +		min_h = variant->pix_min->org_h;
> +	} else {
> +		mod_x = ffs(variant->pix_align->org_w) - 1;
> +		if (is_yuv420(fmt->color))
> +			mod_y = ffs(variant->pix_align->org_h) - 1;
> +		else
> +			mod_y = ffs(variant->pix_align->org_h) - 2;
> +		min_w = variant->pix_min->target_rot_dis_w;
> +		min_h = variant->pix_min->target_rot_dis_h;
> +	}
> +	gsc_dbg("mod_x: %d, mod_y: %d, max_w: %d, max_h = %d",
> +	     mod_x, mod_y, max_w, max_h);
> +	/* To check if image size is modified to adjust parameter against
> +	   hardware abilities */
> +	tmp_w = pix_mp->width;
> +	tmp_h = pix_mp->height;
> +
> +	v4l_bound_align_image(&pix_mp->width, min_w, max_w, mod_x,
> +		&pix_mp->height, min_h, max_h, mod_y, 0);
> +	if (tmp_w != pix_mp->width || tmp_h != pix_mp->height)
> +		gsc_info("Image size has been modified from %dx%d to %dx%d",
> +			 tmp_w, tmp_h, pix_mp->width, pix_mp->height);
> +
> +	pix_mp->num_planes = fmt->num_planes;
> +
> +	if (ctx->gsc_ctrls.csc_eq_mode->val)
> +		ctx->gsc_ctrls.csc_eq->val =
> +			(pix_mp->width>= 1280) ? 1 : 0;
> +	if (ctx->gsc_ctrls.csc_eq->val) /* HD */
> +		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +	else	/* SD */
> +		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +
> +	for (i = 0; i<  pix_mp->num_planes; ++i) {
> +		int bpl = (pix_mp->width * fmt->depth[i])>>  3;
> +		pix_mp->plane_fmt[i].bytesperline = bpl;
> +		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
> +
> +		gsc_dbg("[%d]: bpl: %d, sizeimage: %d",
> +		    i, bpl, pix_mp->plane_fmt[i].sizeimage);
> +	}
> +
> +	return 0;
> +}
> +
> +int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct gsc_frame *frame;
> +	struct v4l2_pix_format_mplane *pix_mp;
> +	int i;
> +
> +	frame = ctx_get_frame(ctx, f->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	pix_mp =&f->fmt.pix_mp;
> +
> +	pix_mp->width		= frame->f_width;
> +	pix_mp->height		= frame->f_height;
> +	pix_mp->field		= V4L2_FIELD_NONE;
> +	pix_mp->pixelformat	= frame->fmt->pixelformat;
> +	pix_mp->colorspace	= V4L2_COLORSPACE_JPEG;
> +	pix_mp->num_planes	= frame->fmt->num_planes;
> +
> +	for (i = 0; i<  pix_mp->num_planes; ++i) {
> +		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
> +			frame->fmt->depth[i]) / 8;
> +		pix_mp->plane_fmt[i].sizeimage =
> +			 pix_mp->plane_fmt[i].bytesperline * frame->f_height;
> +	}
> +
> +	return 0;
> +}
> +
> +void gsc_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
> +{
> +	if (tmp_w != *w || tmp_h != *h) {
> +		gsc_info("Cropped size has been modified from %dx%d to %dx%d",
> +							*w, *h, tmp_w, tmp_h);
> +		*w = tmp_w;
> +		*h = tmp_h;
> +	}
> +}
> +
> +int gsc_g_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
> +{
> +	struct gsc_frame *frame;
> +
> +	frame = ctx_get_frame(ctx, cr->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	cr->c = frame->crop;
> +
> +	return 0;
> +}
> +
> +int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
> +{
> +	struct gsc_frame *f;
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +	struct gsc_variant *variant = gsc->variant;
> +	u32 mod_x = 0, mod_y = 0, tmp_w, tmp_h;
> +	u32 min_w, min_h, max_w, max_h;
> +
> +	if (cr->c.top<  0 || cr->c.left<  0) {
> +		gsc_err("doesn't support negative values for top&  left\n");
> +		return -EINVAL;
> +	}
> +	gsc_dbg("user put w: %d, h: %d", cr->c.width, cr->c.height);
> +
> +	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		f =&ctx->d_frame;
> +	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		f =&ctx->s_frame;
> +	else
> +		return -EINVAL;
> +
> +	max_w = f->f_width;
> +	max_h = f->f_height;
> +	tmp_w = cr->c.width;
> +	tmp_h = cr->c.height;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
> +		if ((is_yuv422(f->fmt->color)&&  f->fmt->num_comp == 1) ||
> +		    is_rgb(f->fmt->color))
> +			min_w = 32;
> +		else
> +			min_w = 64;
> +		if ((is_yuv422(f->fmt->color)&&  f->fmt->num_comp == 3) ||
> +		    is_yuv420(f->fmt->color))
> +			min_h = 32;
> +		else
> +			min_h = 16;
> +	} else {
> +		if (is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color))
> +			mod_x = ffs(variant->pix_align->target_w) - 1;
> +		if (is_yuv420(f->fmt->color))
> +			mod_y = ffs(variant->pix_align->target_h) - 1;
> +		if (ctx->gsc_ctrls.rotate->val == 90 ||
> +		    ctx->gsc_ctrls.rotate->val == 270) {
> +			max_w = f->f_height;
> +			max_h = f->f_width;
> +			min_w = variant->pix_min->target_rot_en_w;
> +			min_h = variant->pix_min->target_rot_en_h;
> +			tmp_w = cr->c.height;
> +			tmp_h = cr->c.width;
> +		} else {
> +			min_w = variant->pix_min->target_rot_dis_w;
> +			min_h = variant->pix_min->target_rot_dis_h;
> +		}
> +	}
> +	gsc_dbg("mod_x: %d, mod_y: %d, min_w: %d, min_h = %d",
> +					mod_x, mod_y, min_w, min_h);
> +	gsc_dbg("tmp_w : %d, tmp_h : %d", tmp_w, tmp_h);
> +
> +	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_x,
> +			&tmp_h, min_h, max_h, mod_y, 0);
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(cr->type)&&
> +	    (ctx->gsc_ctrls.rotate->val == 90 ||
> +	    ctx->gsc_ctrls.rotate->val == 270)) {
> +		gsc_check_crop_change(tmp_h, tmp_w,&cr->c.width,
> +							&cr->c.height);
> +	} else {
> +		gsc_check_crop_change(tmp_w, tmp_h,&cr->c.width,
> +							&cr->c.height);
> +	}
> +
> +	/* adjust left/top if cropping rectangle is out of bounds */
> +	/* Need to add code to algin left value with 2's multiple */
> +	if (cr->c.left + tmp_w>  max_w)
> +		cr->c.left = max_w - tmp_w;
> +	if (cr->c.top + tmp_h>  max_h)
> +		cr->c.top = max_h - tmp_h;
> +
> +	if (is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color))
> +		if (cr->c.left % 2)
> +			cr->c.left -= 1;
> +
> +	gsc_dbg("Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
> +	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
> +
> +	return 0;
> +}
> +
> +int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int dw,
> +			   int dh, int rot, int out_path)
> +{
> +	int tmp_w, tmp_h, sc_down_max;
> +	sc_down_max =
> +		(out_path == GSC_DMA) ? var->sc_down_max : var->local_sc_down;
> +
> +	if (rot == 90 || rot == 270) {
> +		tmp_w = dh;
> +		tmp_h = dw;
> +	} else {
> +		tmp_w = dw;
> +		tmp_h = dh;
> +	}
> +
> +	if ((sw / tmp_w)>  sc_down_max ||
> +	    (sh / tmp_h)>  sc_down_max ||
> +	    (tmp_w / sw)>  var->sc_up_max ||
> +	    (tmp_h / sh)>  var->sc_up_max)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int gsc_set_scaler_info(struct gsc_ctx *ctx)
> +{
> +	struct gsc_scaler *sc =&ctx->scaler;
> +	struct gsc_frame *s_frame =&ctx->s_frame;
> +	struct gsc_frame *d_frame =&ctx->d_frame;
> +	struct gsc_variant *variant = ctx->gsc_dev->variant;
> +	int tx, ty;
> +	int ret;
> +
> +	ret = gsc_check_scaler_ratio(variant, s_frame->crop.width,
> +		s_frame->crop.height, d_frame->crop.width, d_frame->crop.height,
> +		ctx->gsc_ctrls.rotate->val, ctx->out_path);
> +	if (ret) {
> +		gsc_err("out of scaler range");
> +		return ret;
> +	}
> +
> +	if (ctx->gsc_ctrls.rotate->val == 90 ||
> +	    ctx->gsc_ctrls.rotate->val == 270) {
> +		ty = d_frame->crop.width;
> +		tx = d_frame->crop.height;
> +	} else {
> +		tx = d_frame->crop.width;
> +		ty = d_frame->crop.height;
> +	}
> +
> +	ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.width,
> +				      tx,&sc->pre_hratio);
> +	if (ret) {
> +		gsc_err("Horizontal scale ratio is out of range");
> +		return ret;
> +	}
> +
> +	ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.height,
> +				      ty,&sc->pre_vratio);
> +	if (ret) {
> +		gsc_err("Vertical scale ratio is out of range");
> +		return ret;
> +	}
> +
> +	gsc_check_src_scale_info(variant, s_frame,&sc->pre_hratio,
> +				 tx, ty,&sc->pre_vratio);
> +
> +	gsc_get_prescaler_shfactor(sc->pre_hratio, sc->pre_vratio,
> +				&sc->pre_shfactor);
> +
> +	sc->main_hratio = (s_frame->crop.width<<  16) / tx;
> +	sc->main_vratio = (s_frame->crop.height<<  16) / ty;
> +
> +	gsc_dbg("scaler input/output size : sx = %d, sy = %d, tx = %d, ty = %d",
> +			s_frame->crop.width, s_frame->crop.height, tx, ty);
> +	gsc_dbg("scaler ratio info : pre_shfactor : %d, pre_h : %d",
> +			sc->pre_shfactor, sc->pre_hratio);
> +	gsc_dbg("pre_v :%d, main_h : %ld, main_v : %ld",
> +			sc->pre_vratio, sc->main_hratio, sc->main_vratio);
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * V4L2 controls handling
> + */
> +static int gsc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct gsc_ctx *ctx = ctrl_to_ctx(ctrl);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		user_to_drv(ctx->gsc_ctrls.hflip, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_VFLIP:
> +		user_to_drv(ctx->gsc_ctrls.vflip, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_ROTATE:
> +		user_to_drv(ctx->gsc_ctrls.rotate, ctrl->val);
> +		break;
> +
> +	default:
> +		break;

It's safe to remove these two lines. Also see my comments on
user_to_drv() below.

> +	}
> +
> +	if (gsc_m2m_opened(ctx->gsc_dev))
> +		gsc_ctx_state_lock_set(GSC_PARAMS, ctx);
> +
> +	return 0;
> +}
> +
> +const struct v4l2_ctrl_ops gsc_ctrl_ops = {
> +	.s_ctrl = gsc_s_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config gsc_custom_ctrl[] = {
> +	{
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_GLOBAL_ALPHA,

There is now a standard V4L2 control for this: V4L2_CID_ALPHA_COMPONENT.
http://linuxtv.org/downloads/v4l-dvb-apis/control.html
So please use it instead of a private control. We're generally trying 
to avoid private controls. If some driver uses them, they should be well
documented, e.g. under Documentation/video4linux/.

> +		.name = "Set RGB alpha",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +		.max = 255,
> +		.step = 1,
> +		.def = 0,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_CACHEABLE,
> +		.name = "Set cacheable",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,

Err, you're lying here. Boolean control with a slider flag ?
Are you perhaps using V4L2_CTRL_FLAG_SLIDER in some non-standard way ?
(it's set throughout all controls in this array).

> +		.max = 1,
> +		.def = true,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_TV_LAYER_BLEND_ENABLE,
> +		.name = "Enable layer alpha blending",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_TV_LAYER_BLEND_ALPHA,
> +		.name = "Set alpha for layer blending",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +		.min = 0,
> +		.max = 255,
> +		.step = 1,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_TV_PIXEL_BLEND_ENABLE,
> +		.name = "Enable pixel alpha blending",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_TV_CHROMA_ENABLE,
> +		.name = "Enable chromakey",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_TV_CHROMA_VALUE,
> +		.name = "Set chromakey value",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +		.min = 0,
> +		.max = 255,
> +		.step = 1,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_CSC_EQ_MODE,
> +		.name = "Set CSC equation mode",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +		.max = DEFAULT_CSC_EQ,
> +		.def = DEFAULT_CSC_EQ,
> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_CSC_EQ,
> +		.name = "Set CSC equation",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +		.step = 1,
> +		.max = 8,
> +		.def = V4L2_COLORSPACE_REC709,

Are you switching color spaces with a control ? The colorspace 
handling is supposed to be done with VIDIOC_S/G_FMT.
Please, can you explain why these controls are need and what
exact device features they expose ?

Can't what is covered by V4L2_CID_CSC_EQ_MODE and V4L2_CID_CSC_RANGE
be derived from the colorspace ?

> +	}, {
> +		.ops =&gsc_ctrl_ops,
> +		.id = V4L2_CID_CSC_RANGE,
> +		.name = "Set CSC range",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.flags = V4L2_CTRL_FLAG_SLIDER,
> +		.max = DEFAULT_CSC_RANGE,
> +		.def = DEFAULT_CSC_RANGE,
> +	},
> +};
> +
> +int gsc_ctrls_create(struct gsc_ctx *ctx)
> +{
> +	if (ctx->ctrls_rdy) {
> +		gsc_err("Control handler of this context was created already");
> +		return 0;
> +	}
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, GSC_MAX_CTRL_NUM);
> +
> +	ctx->gsc_ctrls.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +				&gsc_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
> +	ctx->gsc_ctrls.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +				&gsc_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	ctx->gsc_ctrls.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +				&gsc_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +
> +	ctx->gsc_ctrls.global_alpha = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[0], NULL);
> +	ctx->gsc_ctrls.layer_blend_en = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[2], NULL);
> +	ctx->gsc_ctrls.layer_alpha = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[3], NULL);
> +	ctx->gsc_ctrls.pixel_blend_en = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[4], NULL);
> +	ctx->gsc_ctrls.chroma_en = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[5], NULL);
> +	ctx->gsc_ctrls.chroma_val = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[6], NULL);
> +
> +/* for CSC equation */

missing tab ?

> +	ctx->gsc_ctrls.csc_eq_mode = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[7], NULL);
> +	ctx->gsc_ctrls.csc_eq = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[8], NULL);
> +	ctx->gsc_ctrls.csc_range = v4l2_ctrl_new_custom(&ctx->ctrl_handler,
> +					&gsc_custom_ctrl[9], NULL);
> +
> +	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
> +
> +
> +	if (ctx->ctrl_handler.error) {
> +		int err = ctx->ctrl_handler.error;
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		gsc_err("Failed to gscaler control hander create");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +void gsc_ctrls_delete(struct gsc_ctx *ctx)
> +{
> +	if (ctx->ctrls_rdy) {
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		ctx->ctrls_rdy = false;
> +	}
> +}
> +
> +/* The color format (num_comp, num_planes) must be already configured. */
> +int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
> +			struct gsc_frame *frame, struct gsc_addr *addr)
> +{
> +	int ret = 0;
> +	u32 pix_size;
> +
> +	if (IS_ERR(vb) || IS_ERR(frame)) {
> +		gsc_err("Invalid argument");
> +		return -EINVAL;
> +	}
> +
> +	pix_size = frame->f_width * frame->f_height;
> +
> +	gsc_dbg("num_planes= %d, num_comp= %d, pix_size= %d",
> +		frame->fmt->num_planes, frame->fmt->num_comp, pix_size);
> +
> +	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	if (frame->fmt->num_planes == 1) {
> +		switch (frame->fmt->num_comp) {
> +		case 1:
> +			addr->cb = 0;
> +			addr->cr = 0;
> +			break;
> +		case 2:
> +			/* decompose Y into Y/Cb */
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			addr->cr = 0;
> +			break;
> +		case 3:
> +			addr->cb = (dma_addr_t)(addr->y + pix_size);
> +			addr->cr = (dma_addr_t)(addr->cb + (pix_size>>  2));
> +			break;
> +		default:
> +			gsc_err("Invalid the number of color planes");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (frame->fmt->num_planes>= 2)
> +			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
> +
> +		if (frame->fmt->num_planes == 3)
> +			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
> +	}
> +
> +	if (frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420) {
> +		u32 t_cb = addr->cb;
> +		addr->cb = addr->cr;
> +		addr->cr = t_cb;

swap(addr->cb, addr->cr); would do as well.

> +	}
> +
> +	gsc_dbg("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
> +		addr->y, addr->cb, addr->cr, ret);
> +
> +	return ret;
> +}
> +
> +static irqreturn_t gsc_irq_handler(int irq, void *priv)
> +{
> +	struct gsc_dev *gsc = priv;
> +	int gsc_irq;
> +
> +	gsc_irq = gsc_hw_get_irq_status(gsc);
> +	gsc_hw_clear_irq(gsc, gsc_irq);
> +
> +	if (gsc_irq == GSC_OR_IRQ) {
> +		gsc_err("Local path input over-run interrupt has occurred!\n");
> +		return IRQ_HANDLED;
> +	}
> +
> +	spin_lock(&gsc->slock);
> +
> +	if (test_and_clear_bit(ST_M2M_RUN,&gsc->state)) {
> +		struct vb2_buffer *src_vb, *dst_vb;
> +		struct gsc_ctx *ctx =
> +			v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
> +
> +		if (!ctx || !ctx->m2m_ctx)
> +			goto isr_unlock;
> +
> +		src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +		dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +		if (src_vb&&  dst_vb) {
> +			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
> +			v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> +
> +			if (test_and_clear_bit(ST_STOP_REQ,&gsc->state))
> +				wake_up(&gsc->irq_queue);
> +			else
> +				v4l2_m2m_job_finish(gsc->m2m.m2m_dev,
> +							ctx->m2m_ctx);
> +
> +			/* wake_up job_abort, stop_streaming */
> +			spin_lock(&ctx->slock);
> +			if (ctx->state&  GSC_CTX_STOP_REQ) {
> +				ctx->state&= ~GSC_CTX_STOP_REQ;
> +				wake_up(&gsc->irq_queue);
> +			}
> +			spin_unlock(&ctx->slock);
> +		}
> +	}
> +
> +isr_unlock:
> +	spin_unlock(&gsc->slock);
> +	return IRQ_HANDLED;
> +}
> +
> +static int gsc_runtime_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct gsc_dev *gsc = (struct gsc_dev *)platform_get_drvdata(pdev);

No need for casting, these two lines can be replaced with:

	struct gsc_dev *gsc = dev_get_drvdata(dev);

> +
> +	if (gsc_m2m_opened(gsc))
> +		gsc->m2m.ctx = NULL;
> +
> +	clk_disable(gsc->clock);
> +	clear_bit(ST_PWR_ON,&gsc->state);
> +
> +	return 0;
> +}
> +
> +static int gsc_runtime_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct gsc_dev *gsc = (struct gsc_dev *)platform_get_drvdata(pdev);

ditto

> +	int ret;
> +
> +	ret = clk_enable(gsc->clock);
> +	if (ret)
> +		return ret;
> +
> +	set_bit(ST_PWR_ON,&gsc->state);
> +	return 0;
> +}
> +
> +static inline void *gsc_get_drv_data(struct platform_device *pdev);

Huh ? No need for "inline" here.

> +
> +static int gsc_probe(struct platform_device *pdev)
> +{
> +	struct gsc_dev *gsc;
> +	struct resource *res;
> +	struct gsc_driverdata *drv_data;
> +

Nit: No need for an empty line.

> +	int ret = 0;
> +
> +	dev_dbg(&pdev->dev, "%s():\n", __func__);

I would remove this line, but that just may be me. Also, how about 
adding:

	struct device *dev = &pdev->dev;

and using it below to simplify the code a little ?

> +	drv_data = (struct gsc_driverdata *)
> +				gsc_get_drv_data(pdev);
> +
> +	if (pdev->dev.of_node) {
> +		pdev->id = of_alias_get_id(pdev->dev.of_node, "gsc");

It is illegal to change struct platform_device::id in drivers after 
a device has been registered to the driver core, isn't it ?

I suggest to just use gsc->id in whole driver, something like:

	if (pdev->dev.of_node)
		gsc->id = of_alias_get_id(pdev->dev.of_node, "gsc");
	else
		gsc->id = pdev->id;
	
	/* sanity check on gsc->id here, e.g. */

	if (gsc->id < 0 || gsc->id >= drv_data->num_entities)
		...

> +		if (pdev->id<  0)
> +			dev_err(&pdev->dev,
> +				"failed to get alias id, errno %d\n", ret);

OK, so it doesn't really fail here if aliases are not specified in DT.
I would just make probe() fail here if the id is wrong.

> +	}
> +
> +	if (pdev->id>= drv_data->num_entities) {
> +		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
> +			pdev->id);
> +		return -EINVAL;
> +	}
> +
> +	gsc = devm_kzalloc(&pdev->dev, sizeof(struct gsc_dev), GFP_KERNEL);
> +	if (!gsc)
> +		return -ENOMEM;
> +
> +	gsc->id = pdev->id;
> +	gsc->variant = drv_data->variant[gsc->id];
> +	gsc->pdev = pdev;
> +	gsc->pdata = pdev->dev.platform_data;
> +
> +	init_waitqueue_head(&gsc->irq_queue);
> +	spin_lock_init(&gsc->slock);
> +	mutex_init(&gsc->lock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	gsc->regs = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!gsc->regs) {
> +		dev_err(&pdev->dev, "failed to map registers\n");
> +		return -ENOENT;
> +	}
> +
> +	/* Get Gscaler clock */
> +	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
> +	if (IS_ERR(gsc->clock)) {
> +		gsc_err("failed to get gscaler.%d clock", gsc->id);
> +		return -ENXIO;
> +	}
> +	clk_put(gsc->clock);

You don't do clk_put until the clock is actively used by the driver.
This is just a wrong clock API usage. I would check if devm_clk_get()
could be used, it does clk_put automatically when a driver is detached.

clk_prepare/clk_unprepare are also missing here. Samsung platforms will 
be eventually converted to common clock API and those calls are a 
mandatory pre-requisite. 

Please see: http://patchwork.linuxtv.org/patch/9920/
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get IRQ resource\n");
> +		return -ENXIO;
> +	}
> +	gsc->irq = res->start;

irq can be dropped from struct gsc_dev, it is not really needed since
you use devm_* API.

> +
> +	ret = devm_request_irq(&pdev->dev, gsc->irq, gsc_irq_handler, 0,
> +							pdev->name, gsc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	gsc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(gsc->alloc_ctx)) {
> +		ret = PTR_ERR(gsc->alloc_ctx);
> +		goto err_irq;
> +	}
> +
> +	platform_set_drvdata(pdev, gsc);
> +
> +	ret = gsc_register_m2m_device(gsc);
> +	if (ret)
> +		goto err_irq;
> +
> +	gsc_runtime_resume(&pdev->dev);

Why is this needed ? If you do that, the clock gets enabled in probe
and pm_runtime calls are useless, since the clock is always enabled
(due to an unbalanced clk_enable at the initialization stage). 
Or am I missing something ?

> +	pm_runtime_enable(&pdev->dev);
> +
> +	gsc_info("gsc-%d registered successfully", gsc->id);

You probably want to make it just dev_dbg(...);

> +	return 0;
> +
> +err_irq:
> +	free_irq(gsc->irq, gsc);

This isn't right, the point of using devm_request_irq() is that an 
IRQ is freed when a driver is unloaded and also when probe() exits 
with an error (if dev->bus->probe() in really_probe() fails
devres_relase_all() is invoked). So can you please remove this line ?

> +	return ret;
> +}
> +
> +static int __devexit gsc_remove(struct platform_device *pdev)
> +{
> +	struct gsc_dev *gsc =
> +		(struct gsc_dev *)platform_get_drvdata(pdev);

No need to cast and a line break.

> +
> +	free_irq(gsc->irq, gsc);

See my comment on free_irq() above.

> +
> +	gsc_unregister_m2m_device(gsc);
> +
> +	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	iounmap(gsc->regs);
> +	release_resource(gsc->regs_res);
> +	kfree(gsc->regs_res);
> +	kfree(gsc);

It is not sane, all these resources are freed/unmapped automatically
by the driver core. So please remove that 4 lines.

It just indicates this driver has never been tested as a loadable module.
Can you please take care of this ? I'm pretty sure there is more bugs,
with eyes and teeth shining white in the darkness...

> +
> +	dev_info(&pdev->dev, "%s driver unloaded\n", pdev->name);

How about just making it dev_dbg ?

> +	return 0;
> +}
> +
> +static int gsc_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev;
> +	struct gsc_dev *gsc;
> +	int ret = 0;
> +
> +	pdev = to_platform_device(dev);
> +	gsc = (struct gsc_dev *)platform_get_drvdata(pdev);

Again, 
	struct gsc_dev *gsc = dev_get_drvdata(dev);

and please move it above to the declarations statements.

> +	if (gsc_m2m_run(gsc)) {
> +		set_bit(ST_STOP_REQ,&gsc->state);
> +		ret = wait_event_timeout(gsc->irq_queue,
> +				!test_bit(ST_STOP_REQ,&gsc->state),
> +				GSC_SHUTDOWN_TIMEOUT);
> +		if (ret == 0)
> +			dev_err(&gsc->pdev->dev, "wait timeout : %s\n",
> +				__func__);
> +	}
> +
> +	pm_runtime_put_sync(dev);

Using the PM runtime calls from within system wide suspend/resume
callback is illegal. You don't know at what state the platform 
run time PM is at the time system the sleep callbacks in this driver
are invoked. Instead, I would just call gsc_runtime_resume/suspend
functions directly and would ensure proper locking of driver's 
runtime PM and system sleep callbacks.

> +
> +	return ret;
> +}
> +
> +static int gsc_resume(struct device *dev)
> +{
> +	struct gsc_dev *gsc;

struct gsc_dev *gsc = dev_get_drvdata(dev);

> +	struct gsc_ctx *ctx;
> +
> +	gsc = dev_get_drvdata(dev);
> +
> +	pm_runtime_get_sync(dev);
> +	if (gsc_m2m_opened(gsc)) {
> +		ctx = v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
> +		if (ctx != NULL) {
> +			gsc->m2m.ctx = NULL;
> +			v4l2_m2m_job_finish(gsc->m2m.m2m_dev, ctx->m2m_ctx);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops gsc_pm_ops = {
> +	.suspend		= gsc_suspend,
> +	.resume			= gsc_resume,
> +	.runtime_suspend	= gsc_runtime_suspend,
> +	.runtime_resume		= gsc_runtime_resume,
> +};
> +
> +struct gsc_pix_max gsc_v_100_max = {
> +	.org_scaler_bypass_w	= 8192,
> +	.org_scaler_bypass_h	= 8192,
> +	.org_scaler_input_w	= 4800,
> +	.org_scaler_input_h	= 3344,
> +	.real_rot_dis_w		= 4800,
> +	.real_rot_dis_h		= 3344,
> +	.real_rot_en_w		= 2047,
> +	.real_rot_en_h		= 2047,
> +	.target_rot_dis_w	= 4800,
> +	.target_rot_dis_h	= 3344,
> +	.target_rot_en_w	= 2016,
> +	.target_rot_en_h	= 2016,
> +};
> +
> +struct gsc_pix_min gsc_v_100_min = {
> +	.org_w			= 64,
> +	.org_h			= 32,
> +	.real_w			= 64,
> +	.real_h			= 32,
> +	.target_rot_dis_w	= 64,
> +	.target_rot_dis_h	= 32,
> +	.target_rot_en_w	= 32,
> +	.target_rot_en_h	= 16,
> +};
> +
> +struct gsc_pix_align gsc_v_100_align = {
> +	.org_h			= 16,
> +	.org_w			= 16, /* yuv420 : 16, others : 8 */
> +	.offset_h		= 2,  /* yuv420/422 : 2, others : 1 */
> +	.real_w			= 16, /* yuv420/422 : 4~16, others : 2~8 */
> +	.real_h			= 16, /* yuv420 : 4~16, others : 1 */
> +	.target_w		= 2,  /* yuv420/422 : 2, others : 1 */
> +	.target_h		= 2,  /* yuv420 : 2, others : 1 */
> +};
> +
> +struct gsc_variant gsc_v_100_variant = {

static const struct ...

> +	.pix_max		=&gsc_v_100_max,
> +	.pix_min		=&gsc_v_100_min,
> +	.pix_align		=&gsc_v_100_align,
> +	.in_buf_cnt		= 8,
> +	.out_buf_cnt		= 16,
> +	.sc_up_max		= 8,
> +	.sc_down_max		= 16,
> +	.poly_sc_down_max	= 4,
> +	.pre_sc_down_max	= 4,
> +	.local_sc_down		= 2,
> +};
> +
> +static struct gsc_driverdata gsc_v_100_drvdata = {
> +	.variant = {
> +		[0] =&gsc_v_100_variant,
> +		[1] =&gsc_v_100_variant,
> +		[2] =&gsc_v_100_variant,
> +		[3] =&gsc_v_100_variant,
> +	},
> +	.num_entities = 4,
> +	.lclk_frequency = 266000000UL,
> +};
> +
> +static struct platform_device_id gsc_driver_ids[] = {
> +	{
> +		.name		= "exynos-gsc",
> +		.driver_data	= (unsigned long)&gsc_v_100_drvdata,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(platform, gsc_driver_ids);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_gsc_match[] = {
> +	{ .compatible = "samsung,exynos-gsc",
> +	.data =&gsc_v_100_drvdata, },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_gsc_match);
> +#else
> +#define exynos_gsc_match NULL
> +#endif

You could drop these 2 lines...

> +
> +static inline void *gsc_get_drv_data(struct platform_device *pdev)

[Unnecesary "inline".]

> +{
> +#ifdef CONFIG_OF

..remove this #ifdefs...

> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +	match = of_match_node(exynos_gsc_match, pdev->dev.of_node);

and use "of_match_ptr(exynos_gsc_match)" instead of exynos_gsc_match
here

> +	return (struct gsc_driverdata *) match->data;
> +	}
> +#endif
> +	return (struct gsc_driverdata *)
> +			platform_get_device_id(pdev)->driver_data;
> +}

static void *gsc_get_drv_data(struct platform_device *pdev)
{
	struct gsc_driverdata *driver_data = NULL;

	if (pdev->dev.of_node) {
		const struct of_device_id *match;
		match = of_match_node(of_match_ptr(exynos_gsc_match), 
				pdev->dev.of_node);
		if (match)
			driver_data =  match->data;
	} else {
		driver_data = platform_get_device_id(pdev)->driver_data;
	}

	return driver_data;
}

> +
> +static struct platform_driver gsc_driver = {
> +	.probe		= gsc_probe,
> +	.remove	= __devexit_p(gsc_remove),
> +	.id_table	= gsc_driver_ids,
> +	.driver = {
> +		.name	= GSC_MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	=&gsc_pm_ops,
> +		.of_match_table = exynos_gsc_match,

... and here.

#ifdefs are *ugly* :)

> +	}
> +};
> +
> +static int __init gsc_init(void)
> +{
> +	int ret = platform_driver_register(&gsc_driver);
> +	if (ret)
> +		gsc_err("platform_driver_register failed: %d\n", ret);
> +	return ret;
> +}
> +
> +static void __exit gsc_exit(void)
> +{
> +	platform_driver_unregister(&gsc_driver);
> +}
> +
> +module_init(gsc_init);
> +module_exit(gsc_exit);

How about using module_platform_driver() macro instead ?

> +
> +MODULE_AUTHOR("Hyunwong Kim<khw0178.kim@xxxxxxxxxxx>");
> +MODULE_DESCRIPTION("Samsung EXYNOS5 Soc series G-Scaler driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/exynos/gsc/gsc-core.h b/drivers/media/video/exynos/gsc/gsc-core.h
> new file mode 100644
> index 0000000..3a236ec
> --- /dev/null
> +++ b/drivers/media/video/exynos/gsc/gsc-core.h
> @@ -0,0 +1,652 @@
> +/* linux/drivers/media/video/exynos/gsc/gsc-core.h
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * header file for Samsung EXYNOS5 SoC series G-scaler driver
> +
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef GSC_CORE_H_
> +#define GSC_CORE_H_
> +
> +#include<linux/delay.h>
> +#include<linux/sched.h>
> +#include<linux/spinlock.h>
> +#include<linux/types.h>
> +#include<linux/videodev2.h>
> +#include<linux/io.h>
> +#include<linux/pm_runtime.h>
> +#include<media/videobuf2-core.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-mem2mem.h>
> +#include<media/v4l2-mediabus.h>
> +#define CONFIG_VB2_GSC_DMA_CONTIG	1
> +#include<media/videobuf2-dma-contig.h>
> +#include "gsc-regs.h"
> +extern int gsc_dbg;
> +
> +#define GSC_MODULE_NAME			"exynos-gsc"
> +
> +#define gsc_info(fmt, args...)						\
> +	do {								\
> +		if (gsc_dbg>= 6)					\
> +			pr_info("[INFO]%s:%d: "fmt "\n",		\

Those [INFO], [ERROR] things are just funny :o)

> +				__func__, __LINE__, ##args);		\
> +	} while (0)
> +
> +#define gsc_err(fmt, args...)						\
> +	do {								\
> +		if (gsc_dbg>= 3)					\
> +			pr_err("[ERROR]%s:%d: "fmt "\n",		\
> +				__func__, __LINE__, ##args);		\
> +	} while (0)
> +
> +#define gsc_warn(fmt, args...)						\
> +	do {								\
> +		if (gsc_dbg>= 4)					\
> +			pr_warn("[WARN]%s:%d: "fmt "\n",		\
> +				__func__, __LINE__, ##args);		\
> +	} while (0)
> +
> +#define gsc_dbg(fmt, args...)						\
> +	do {								\
> +		if (gsc_dbg>= 7)					\
> +			pr_debug("[DEBUG]%s:%d: "fmt "\n",		\
> +				__func__, __LINE__, ##args);		\
> +	} while (0)

As I mentioned above, would be nice to get rid of these custom trace
macros.

> +#define GSC_MAX_CLOCKS			3
> +#define GSC_SHUTDOWN_TIMEOUT		((100*HZ)/1000)
> +#define GSC_MAX_DEVS			4
> +#define WORKQUEUE_NAME_SIZE		32
> +#define FIMD_NAME_SIZE			32
> +#define GSC_M2M_BUF_NUM			0
> +#define GSC_OUT_BUF_MAX			2
> +#define GSC_MAX_CTRL_NUM		10
> +#define GSC_OUT_MAX_MASK_NUM		7
> +#define GSC_SC_ALIGN_4			4
> +#define GSC_SC_ALIGN_2			2
> +#define GSC_OUT_DEF_SRC			15
> +#define GSC_OUT_DEF_DST			7
> +#define DEFAULT_GSC_SINK_WIDTH		800
> +#define DEFAULT_GSC_SINK_HEIGHT		480
> +#define DEFAULT_GSC_SOURCE_WIDTH	800
> +#define DEFAULT_GSC_SOURCE_HEIGHT	480
> +#define DEFAULT_CSC_EQ			1
> +#define DEFAULT_CSC_RANGE		1
> +
> +#define GSC_LAST_DEV_ID			3
> +#define GSC_PAD_SINK			0
> +#define GSC_PAD_SOURCE			1
> +#define GSC_PADS_NUM			2
> +
> +#define	GSC_PARAMS			(1<<  0)
> +#define	GSC_SRC_FMT			(1<<  1)
> +#define	GSC_DST_FMT			(1<<  2)
> +#define	GSC_CTX_M2M			(1<<  3)
> +#define	GSC_CTX_OUTPUT			(1<<  4)
> +#define	GSC_CTX_START			(1<<  5)
> +#define	GSC_CTX_STOP_REQ		(1<<  6)
> +#define	GSC_CTX_CAP			(1<<  10)

Inconsistent indentation.

> +#define MAX_MDEV			2
> +
> +#define V4L2_CID_CACHEABLE			(V4L2_CID_LASTP1 + 1)

That's not right. It should have been:

#define V4L2_CID_CACHEABLE			(V4L2_CID_PRIVATE_BASE + 0)

and +1 for subsequent definitions, until V4L2_CID_CSC_RANGE.

> +#define V4L2_CID_TV_LAYER_BLEND_ENABLE		(V4L2_CID_LASTP1 + 2)
> +#define V4L2_CID_TV_LAYER_BLEND_ALPHA		(V4L2_CID_LASTP1 + 3)
> +#define V4L2_CID_TV_PIXEL_BLEND_ENABLE		(V4L2_CID_LASTP1 + 4)
> +#define V4L2_CID_TV_CHROMA_ENABLE		(V4L2_CID_LASTP1 + 5)
> +#define V4L2_CID_TV_CHROMA_VALUE		(V4L2_CID_LASTP1 + 6)
> +/* for color space conversion equation selection */
> +#define V4L2_CID_CSC_EQ_MODE			(V4L2_CID_LASTP1 + 8)
> +#define V4L2_CID_CSC_EQ				(V4L2_CID_LASTP1 + 9)
> +#define V4L2_CID_CSC_RANGE			(V4L2_CID_LASTP1 + 10)
> +#define V4L2_CID_GLOBAL_ALPHA			(V4L2_CID_LASTP1 + 11)

Remove it and use V4L2_CID_ALPHA_COMPONENT.

> +enum gsc_dev_flags {
> +	/* for global */
> +	ST_PWR_ON,
> +	ST_STOP_REQ,
> +	/* for m2m node */
> +	ST_M2M_OPEN,
> +	ST_M2M_RUN,
> +};
> +
> +enum gsc_irq {
> +	GSC_OR_IRQ = 17,
> +	GSC_DONE_IRQ = 16,

Strange, are these some status bit field definitions ?
Why do we need an enum ? Why these numbers ?

> +};
> +
> +/**
> + * enum gsc_datapath - the path of data used for gscaler
> + * @GSC_CAMERA: from camera
> + * @GSC_DMA: from/to DMA
> + * @GSC_LOCAL: to local path
> + * @GSC_WRITEBACK: from FIMD
> + */
> +enum gsc_datapath {
> +	GSC_CAMERA = 0x1,
> +	GSC_DMA,
> +	GSC_MIXER,
> +	GSC_FIMD,
> +	GSC_WRITEBACK,
> +};
> +
> +enum gsc_color_fmt {
> +	GSC_RGB = 0x1,
> +	GSC_YUV420 = 0x2,
> +	GSC_YUV422 = 0x4,
> +	GSC_YUV444 = 0x8,
> +};
> +
> +enum gsc_yuv_fmt {
> +	GSC_LSB_Y = 0x10,
> +	GSC_LSB_C,
> +	GSC_CBCR = 0x20,
> +	GSC_CRCB,
> +};
> +
> +#define fh_to_ctx(__fh) container_of(__fh, struct gsc_ctx, fh)
> +#define is_rgb(x) (!!((x)&  0x1))
> +#define is_yuv420(x) (!!((x)&  0x2))
> +#define is_yuv422(x) (!!((x)&  0x4))
> +#define gsc_m2m_run(dev) test_bit(ST_M2M_RUN,&(dev)->state)
> +#define gsc_m2m_opened(dev) test_bit(ST_M2M_OPEN,&(dev)->state)
> +
> +#define ctrl_to_ctx(__ctrl) \
> +	container_of((__ctrl)->handler, struct gsc_ctx, ctrl_handler)
> +/**
> + * struct gsc_fmt - the driver's internal color format data
> + * @mbus_code: Media Bus pixel code, -1 if not applicable
> + * @name: format description
> + * @pixelformat: the fourcc code for this format, 0 if not applicable
> + * @yorder: Y/C order
> + * @corder: Chrominance order control
> + * @num_planes: number of physically non-contiguous data planes
> + * @nr_comp: number of physically contiguous data planes
> + * @depth: per plane driver's private 'number of bits per pixel'
> + * @flags: flags indicating which operation mode format applies to
> + */
> +struct gsc_fmt {
> +	enum v4l2_mbus_pixelcode mbus_code;
> +	char	*name;
> +	u32	pixelformat;
> +	u32	color;
> +	u32	yorder;
> +	u32	corder;
> +	u16	num_planes;
> +	u16	num_comp;
> +	u8	depth[VIDEO_MAX_PLANES];
> +	u32	flags;
> +};
> +
> +/**
> + * struct gsc_input_buf - the driver's video buffer
> + * @vb:	videobuf2 buffer
> + * @list : linked list structure for buffer queue
> + * @idx : index of G-Scaler input buffer
> + */
> +struct gsc_input_buf {
> +	struct vb2_buffer	vb;
> +	struct list_head	list;
> +	int			idx;
> +};
> +
> +/**
> + * struct gsc_addr - the G-Scaler physical address set
> + * @y:	 luminance plane address
> + * @cb:	 Cb plane address
> + * @cr:	 Cr plane address
> + */
> +struct gsc_addr {
> +	dma_addr_t	y;
> +	dma_addr_t	cb;
> +	dma_addr_t	cr;
> +};
> +
> +/* struct gsc_ctrls - the G-Scaler control set
> + * @rotate: rotation degree
> + * @hflip: horizontal flip
> + * @vflip: vertical flip
> + * @global_alpha: the alpha value of current frame
> + * @layer_blend_en: enable mixer layer alpha blending
> + * @layer_alpha: set alpha value for mixer layer
> + * @pixel_blend_en: enable mixer pixel alpha blending
> + * @chroma_en: enable chromakey
> + * @chroma_val:	set value for chromakey
> + * @csc_eq_mode: mode to select csc equation of current frame
> + * @csc_eq: csc equation of current frame
> + * @csc_range: csc range of current frame
> + */
> +struct gsc_ctrls {
> +	struct v4l2_ctrl	*rotate;
> +	struct v4l2_ctrl	*hflip;
> +	struct v4l2_ctrl	*vflip;
> +	struct v4l2_ctrl	*global_alpha;
> +	struct v4l2_ctrl	*layer_blend_en;
> +	struct v4l2_ctrl	*layer_alpha;
> +	struct v4l2_ctrl	*pixel_blend_en;
> +	struct v4l2_ctrl	*chroma_en;
> +	struct v4l2_ctrl	*chroma_val;
> +	struct v4l2_ctrl	*csc_eq_mode;
> +	struct v4l2_ctrl	*csc_eq;
> +	struct v4l2_ctrl	*csc_range;
> +};
> +
> +/**
> + * struct gsc_scaler - the configuration data for G-Scaler inetrnal scaler
> + * @pre_shfactor:	pre sclaer shift factor
> + * @pre_hratio:		horizontal ratio of the prescaler
> + * @pre_vratio:		vertical ratio of the prescaler
> + * @main_hratio:	the main scaler's horizontal ratio
> + * @main_vratio:	the main scaler's vertical ratio
> + */
> +struct gsc_scaler {
> +	u32	pre_shfactor;
> +	u32	pre_hratio;
> +	u32	pre_vratio;
> +	unsigned long main_hratio;
> +	unsigned long main_vratio;

Isn't unsigned int or u32 enough ?

> +};
> +
> +struct gsc_dev;
> +
> +struct gsc_ctx;
> +
> +/**
> + * struct gsc_frame - source/target frame properties
> + * @f_width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
> + * @f_height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
> + * @crop:	cropped(source)/scaled(destination) size
> + * @payload:	image size in bytes (w x h x bpp)
> + * @addr:	image frame buffer physical addresses
> + * @fmt:	G-scaler color format pointer

g-scaler, G-scaler or G-Scaler ? How about to choose one and stick 
to it ?

> + * @alph:	frame's alpha value
> + */
> +struct gsc_frame {
> +	u32	f_width;
> +	u32	f_height;
> +	struct v4l2_rect	crop;
> +	unsigned long payload[VIDEO_MAX_PLANES];
> +	struct gsc_addr		addr;
> +	struct gsc_fmt		*fmt;
> +	u8	alpha;
> +};
> +
> +/**
> + * struct gsc_m2m_device - v4l2 memory-to-memory device data
> + * @vfd: the video device node for v4l2 m2m mode
> + * @m2m_dev: v4l2 memory-to-memory device data
> + * @ctx: hardware context data
> + * @refcnt: the reference counter
> + */
> +struct gsc_m2m_device {
> +	struct video_device	*vfd;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +	struct gsc_ctx		*ctx;
> +	int			refcnt;
> +};
> +
> +/**
> + *  struct gsc_pix_max - image pixel size limits in various IP configurations
> + *
> + *  @org_scaler_bypass_w: max pixel width when the scaler is disabled
> + *  @org_scaler_bypass_h: max pixel height when the scaler is disabled
> + *  @org_scaler_input_w: max pixel width when the scaler is enabled
> + *  @org_scaler_input_h: max pixel height when the scaler is enabled
> + *  @real_rot_dis_w: max pixel src cropped height with the rotator is off
> + *  @real_rot_dis_h: max pixel src croppped width with the rotator is off
> + *  @real_rot_en_w: max pixel src cropped width with the rotator is on
> + *  @real_rot_en_h: max pixel src cropped height with the rotator is on
> + *  @target_rot_dis_w: max pixel dst scaled width with the rotator is off
> + *  @target_rot_dis_h: max pixel dst scaled height with the rotator is off
> + *  @target_rot_en_w: max pixel dst scaled width with the rotator is on
> + *  @target_rot_en_h: max pixel dst scaled height with the rotator is on
> + */
> +struct gsc_pix_max {
> +	u16 org_scaler_bypass_w;
> +	u16 org_scaler_bypass_h;
> +	u16 org_scaler_input_w;
> +	u16 org_scaler_input_h;
> +	u16 real_rot_dis_w;
> +	u16 real_rot_dis_h;
> +	u16 real_rot_en_w;
> +	u16 real_rot_en_h;
> +	u16 target_rot_dis_w;
> +	u16 target_rot_dis_h;
> +	u16 target_rot_en_w;
> +	u16 target_rot_en_h;
> +};
> +
> +/**
> + *  struct gsc_pix_min - image pixel size limits in various IP configurations
> + *
> + *  @org_w: minimum source pixel width
> + *  @org_h: minimum source pixel height
> + *  @real_w: minimum input crop pixel width
> + *  @real_h: minimum input crop pixel height
> + *  @target_rot_dis_w: minimum output scaled pixel height when rotator is off
> + *  @target_rot_dis_h: minimum output scaled pixel height when rotator is off
> + *  @target_rot_en_w: minimum output scaled pixel height when rotator is on
> + *  @target_rot_en_h: minimum output scaled pixel height when rotator is on
> + */
> +struct gsc_pix_min {
> +	u16 org_w;
> +	u16 org_h;
> +	u16 real_w;
> +	u16 real_h;
> +	u16 target_rot_dis_w;
> +	u16 target_rot_dis_h;
> +	u16 target_rot_en_w;
> +	u16 target_rot_en_h;
> +};
> +
> +struct gsc_pix_align {
> +	u16 org_h;
> +	u16 org_w;
> +	u16 offset_h;
> +	u16 real_w;
> +	u16 real_h;
> +	u16 target_w;
> +	u16 target_h;
> +};
> +
> +/**
> + * struct gsc_variant - G-Scaler variant information
> + */
> +struct gsc_variant {
> +	struct gsc_pix_max *pix_max;
> +	struct gsc_pix_min *pix_min;
> +	struct gsc_pix_align *pix_align;
> +	u16		in_buf_cnt;
> +	u16		out_buf_cnt;
> +	u16		sc_up_max;
> +	u16		sc_down_max;
> +	u16		poly_sc_down_max;
> +	u16		pre_sc_down_max;
> +	u16		local_sc_down;
> +};
> +
> +/**
> + * struct gsc_driverdata - per device type driver data for init time.
> + *
> + * @variant: the variant information for this driver.
> + * @lclk_frequency: g-scaler clock frequency
> + * @num_entities: the number of g-scalers
> + */
> +struct gsc_driverdata {
> +	struct gsc_variant *variant[GSC_MAX_DEVS];
> +	unsigned long	lclk_frequency;
> +	int		num_entities;
> +};
> +
> +struct gsc_vb2 {
> +	const struct vb2_mem_ops *ops;
> +	void *(*init)(struct gsc_dev *gsc);
> +	void (*cleanup)(void *alloc_ctx);
> +
> +	void (*resume)(void *alloc_ctx);
> +	void (*suspend)(void *alloc_ctx);
> +
> +	int (*cache_flush)(struct vb2_buffer *vb, u32 num_planes);
> +	void (*set_cacheable)(void *alloc_ctx, bool cacheable);
> +	void (*set_sharable)(void *alloc_ctx, bool sharable);
> +};

This looks like something from completely different story, but
seems easy to handle since it's not used in this driver at all,
is it ? Please make sure an unused code is not being added.

> +/**
> + * struct gsc_dev - abstraction for G-Scaler entity
> + * @slock:	the spinlock protecting this data structure
> + * @lock:	the mutex protecting this data structure
> + * @pdev:	pointer to the G-Scaler platform device
> + * @variant:	the IP variant information
> + * @id:		g_scaler device index (0..GSC_MAX_DEVS)
> + * @regs:	the mapped hardware registers
> + * @regs_res:	the resource claimed for IO registers
> + * @irq:	G-scaler interrupt number
> + * @irq_queue:	interrupt handler waitqueue
> + * @m2m:	memory-to-memory V4L2 device information

The comments don't match actual structure declaration below this point.

> + * @out:	memory-to-local V4L2 output device information
> + * @state:	flags used to synchronize m2m and capture mode operation
> + * @alloc_ctx:	videobuf2 memory allocator context
> + * @vb2:	videobuf2 memory allocator call-back functions

Why is this needed ? If it's unused, please just remove it.

> + * @mdev:	pointer to exynos media device
> + * @pipeline:	pointer to subdevs that are connected with gscaler
> + */
> +struct gsc_dev {
> +	spinlock_t			slock;
> +	struct mutex			lock;
> +	struct platform_device		*pdev;
> +	struct gsc_variant		*variant;
> +	u16				id;
> +	struct clk			*clock;
> +	void __iomem			*regs;
> +	struct resource			*regs_res;

unused

> +	int				irq;
> +	wait_queue_head_t		irq_queue;
> +	struct gsc_m2m_device		m2m;
> +	struct exynos_platform_gscaler	*pdata;
> +	unsigned long			state;
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +	const struct gsc_vb2		*vb2;
> +};
> +
> +/**
> + * gsc_ctx - the device context data
> + * @slock:		spinlock protecting this data structure
> + * @s_frame:		source frame properties
> + * @d_frame:		destination frame properties
> + * @in_path:		input mode (DMA or camera)
> + * @out_path:		output mode (DMA or FIFO)
> + * @scaler:		image scaler properties
> + * @flags:		additional flags for image conversion
> + * @state:		flags to keep track of user configuration
> + * @gsc_dev:		the g-scaler device this context applies to
> + * @m2m_ctx:		memory-to-memory device context
> + * @fh:                 v4l2 file handle
> + * @ctrl_handler:       v4l2 controls handler
> + * @ctrls_rdy:          true if the control handler is initialized
> + * @gsc_ctrls		G-Scaler control set
> + * @m2m_ctx:		memory-to-memory device context

Please reorder to match the actual structure declaration.

> + */
> +struct gsc_ctx {
> +	spinlock_t		slock;
> +	struct gsc_frame	s_frame;
> +	struct gsc_frame	d_frame;
> +	enum gsc_datapath	in_path;
> +	enum gsc_datapath	out_path;
> +	struct gsc_scaler	scaler;
> +	u32			flags;
> +	u32			state;
> +	struct gsc_dev		*gsc_dev;
> +	struct v4l2_m2m_ctx	*m2m_ctx;
> +	struct v4l2_fh		fh;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	struct gsc_ctrls	gsc_ctrls;
> +	bool			ctrls_rdy;
> +};
> +
<snip>
> +
> +static inline void user_to_drv(struct v4l2_ctrl *ctrl, s32 value)
> +{
> +	ctrl->cur.val = ctrl->val = value;

No, see what Hans says about assigning values to ctrl->cur in drivers
(Documentation/video4linux/v4l2-controls.txt):

"For try/s_ctrl the new values (i.e. as passed by the user) are filled in and
you can modify them in try_ctrl or set them in s_ctrl. The 'cur' union
contains the current value, which you can use (but not change!) as well.

If s_ctrl returns 0 (OK), then the control framework will copy the new final
values to the 'cur' union.
"

So this user_to_drv() function completely don't make sense - it does what
new_to_cur() function at drivers/media/video/v4l2-ctrls.c is intended for.
Please check how it is all done in drivers/media/video/s5p-fimc/fimc-core.c.

> +}
> +
> +void gsc_hw_set_sw_reset(struct gsc_dev *dev);
> +void gsc_hw_set_one_frm_mode(struct gsc_dev *dev, bool mask);
> +void gsc_hw_set_frm_done_irq_mask(struct gsc_dev *dev, bool mask);
> +void gsc_hw_set_overflow_irq_mask(struct gsc_dev *dev, bool mask);
> +void gsc_hw_set_gsc_irq_enable(struct gsc_dev *dev, bool mask);
> +void gsc_hw_set_input_buf_mask_all(struct gsc_dev *dev);
> +void gsc_hw_set_output_buf_mask_all(struct gsc_dev *dev);
> +void gsc_hw_set_input_buf_masking(struct gsc_dev *dev, u32 shift, bool enable);
> +void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift, bool enable);
> +void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
> +							int index);
> +void gsc_hw_set_output_addr(struct gsc_dev *dev, struct gsc_addr *addr,
> +							int index);
> +void gsc_hw_set_input_path(struct gsc_ctx *ctx);
> +void gsc_hw_set_in_size(struct gsc_ctx *ctx);
> +void gsc_hw_set_in_image_rgb(struct gsc_ctx *ctx);
> +void gsc_hw_set_in_image_format(struct gsc_ctx *ctx);
> +void gsc_hw_set_output_path(struct gsc_ctx *ctx);
> +void gsc_hw_set_out_size(struct gsc_ctx *ctx);
> +void gsc_hw_set_out_image_rgb(struct gsc_ctx *ctx);
> +void gsc_hw_set_out_image_format(struct gsc_ctx *ctx);
> +void gsc_hw_set_prescaler(struct gsc_ctx *ctx);
> +void gsc_hw_set_mainscaler(struct gsc_ctx *ctx);
> +void gsc_hw_set_rotation(struct gsc_ctx *ctx);
> +void gsc_hw_set_global_alpha(struct gsc_ctx *ctx);
> +void gsc_hw_set_sfr_update(struct gsc_ctx *ctx);
> +
> +int gsc_hw_get_input_buf_mask_status(struct gsc_dev *dev);
> +int gsc_hw_get_done_input_buf_index(struct gsc_dev *dev);
> +int gsc_hw_get_nr_unmask_bits(struct gsc_dev *dev);
> +int gsc_wait_reset(struct gsc_dev *dev);
> +int gsc_wait_operating(struct gsc_dev *dev);
> +int gsc_wait_stop(struct gsc_dev *dev);
> +
> +#endif /* GSC_CORE_H_ */
> diff --git a/drivers/media/video/exynos/gsc/gsc-m2m.c b/drivers/media/video/exynos/gsc/gsc-m2m.c
> new file mode 100644
> index 0000000..ead59a0
> --- /dev/null
> +++ b/drivers/media/video/exynos/gsc/gsc-m2m.c
> @@ -0,0 +1,751 @@
> +/* linux/drivers/media/video/exynos/gsc/gsc-m2m.c
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Samsung EXYNOS5 SoC series G-scaler driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include<linux/module.h>
> +#include<linux/kernel.h>
> +#include<linux/version.h>
> +#include<linux/types.h>
> +#include<linux/errno.h>
> +#include<linux/bug.h>
> +#include<linux/interrupt.h>
> +#include<linux/workqueue.h>
> +#include<linux/device.h>
> +#include<linux/platform_device.h>
> +#include<linux/list.h>
> +#include<linux/io.h>
> +#include<linux/slab.h>
> +#include<linux/clk.h>
> +#include<media/v4l2-ioctl.h>
> +
> +#include "gsc-core.h"
> +
> +static int gsc_ctx_stop_req(struct gsc_ctx *ctx)
> +{
> +	struct gsc_ctx *curr_ctx;
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +	int ret = 0;
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
> +	if (!gsc_m2m_run(gsc) || (curr_ctx != ctx))
> +		return 0;
> +	ctx->state |= GSC_CTX_STOP_REQ;
> +	ret = wait_event_timeout(gsc->irq_queue,
> +			!gsc_ctx_state_is_set(GSC_CTX_STOP_REQ, ctx),
> +			GSC_SHUTDOWN_TIMEOUT);
> +	if (!ret)
> +		ret = -EBUSY;
> +
> +	return ret;
> +}
> +
> +static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct gsc_ctx *ctx = q->drv_priv;
> +	int ret;
> +
> +	ret = pm_runtime_get_sync(&ctx->gsc_dev->pdev->dev);
> +	return ret>  0 ? 0 : ret;
> +}
> +
> +static int gsc_m2m_stop_streaming(struct vb2_queue *q)
> +{
> +	struct gsc_ctx *ctx = q->drv_priv;
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +	int ret;
> +
> +	ret = gsc_ctx_stop_req(ctx);
> +	/* FIXME: need to add v4l2_m2m_job_finish(fail) if ret is timeout */
> +	if (ret<  0)
> +		dev_err(&gsc->pdev->dev, "wait timeout : %s\n", __func__);
> +
> +	pm_runtime_put(&ctx->gsc_dev->pdev->dev);
> +
> +	return 0;
> +}
> +
> +static void gsc_m2m_job_abort(void *priv)
> +{
> +	struct gsc_ctx *ctx = priv;
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +	int ret;
> +
> +	ret = gsc_ctx_stop_req(ctx);
> +	/* FIXME: need to add v4l2_m2m_job_finish(fail) if ret is timeout */
> +	if (ret<  0)
> +		dev_err(&gsc->pdev->dev, "wait timeout : %s\n", __func__);
> +}
> +
> +int gsc_fill_addr(struct gsc_ctx *ctx)
> +{
> +	struct gsc_frame *s_frame, *d_frame;
> +	struct vb2_buffer *vb = NULL;
> +	int ret = 0;
> +
> +	s_frame =&ctx->s_frame;
> +	d_frame =&ctx->d_frame;
> +
> +	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	ret = gsc_prepare_addr(ctx, vb, s_frame,&s_frame->addr);
> +	if (ret)
> +		return ret;
> +
> +	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	ret = gsc_prepare_addr(ctx, vb, d_frame,&d_frame->addr);
> +
> +	return ret;
> +}
> +
> +static void gsc_m2m_device_run(void *priv)
> +{
> +	struct gsc_ctx *ctx = priv;
> +	struct gsc_dev *gsc;
> +	unsigned long flags;
> +	u32 ret;
> +	bool is_set = false;
> +
> +	if (WARN(!ctx, "null hardware context\n"))
> +		return;
> +
> +	gsc = ctx->gsc_dev;
> +
> +	spin_lock_irqsave(&ctx->slock, flags);
> +	/* Reconfigure hardware if the context has changed. */
> +	if (gsc->m2m.ctx != ctx) {
> +		gsc_dbg("gsc->m2m.ctx = 0x%p, current_ctx = 0x%p",
> +			  gsc->m2m.ctx, ctx);
> +		ctx->state |= GSC_PARAMS;
> +		gsc->m2m.ctx = ctx;
> +	}
> +
> +	is_set = (ctx->state&  GSC_CTX_STOP_REQ) ? 1 : 0;
> +	ctx->state&= ~GSC_CTX_STOP_REQ;
> +	if (is_set) {
> +		wake_up(&gsc->irq_queue);
> +		goto put_device;
> +	}
> +
> +	ret = gsc_fill_addr(ctx);
> +	if (ret) {
> +		gsc_err("Wrong address");
> +		goto put_device;
> +	}
> +
> +	gsc_set_prefbuf(gsc, ctx->s_frame);
> +	gsc_hw_set_input_addr(gsc,&ctx->s_frame.addr, GSC_M2M_BUF_NUM);
> +	gsc_hw_set_output_addr(gsc,&ctx->d_frame.addr, GSC_M2M_BUF_NUM);
> +
> +	if (ctx->state&  GSC_PARAMS) {
> +		gsc_hw_set_input_buf_masking(gsc, GSC_M2M_BUF_NUM, false);
> +		gsc_hw_set_output_buf_masking(gsc, GSC_M2M_BUF_NUM, false);
> +		gsc_hw_set_frm_done_irq_mask(gsc, false);
> +		gsc_hw_set_gsc_irq_enable(gsc, true);
> +
> +		if (gsc_set_scaler_info(ctx)) {
> +			gsc_err("Scaler setup error");
> +			goto put_device;
> +		}
> +
> +		gsc_hw_set_input_path(ctx);
> +		gsc_hw_set_in_size(ctx);
> +		gsc_hw_set_in_image_format(ctx);
> +
> +		gsc_hw_set_output_path(ctx);
> +		gsc_hw_set_out_size(ctx);
> +		gsc_hw_set_out_image_format(ctx);
> +
> +		gsc_hw_set_prescaler(ctx);
> +		gsc_hw_set_mainscaler(ctx);
> +		gsc_hw_set_rotation(ctx);
> +		gsc_hw_set_global_alpha(ctx);
> +	}
> +	/* When you update SFRs in the middle of operating
> +	gsc_hw_set_sfr_update(ctx);
> +	*/
> +
> +	ctx->state&= ~GSC_PARAMS;
> +
> +	if (!test_and_set_bit(ST_M2M_RUN,&gsc->state)) {
> +		/* One frame mode sequence
> +		 GSCALER_ON on ->  GSCALER_OP_STATUS is operating ->
> +		 GSCALER_ON off */
> +		gsc_hw_enable_control(gsc, true);
> +		ret = gsc_wait_operating(gsc);

gsc_m2m_device_run() can be invoked from the interrupt handler (through
v4l2_mm_job_finish()), so we can be in an interrupt context here. 
Additionally, this section is executed with ctx->slock spinlock held 
(spin_lock_irqsave(&ctx->slock, flags) above). Guess what would have
happened if this code would have been executed on single-processor
system ? Don't you get a "scheduling while atomic" BUG, due to
usleep_range() being called in gsc_wait_operating() ?

It takes maximum 10 jiffies for gsc_wait_operating() to complete,
and all this from within an interrupt context and with interrupts
disabled on a local CPU!

There must be something wrong with the design here...

> +		if (ret<  0) {
> +			gsc_err("gscaler wait operating timeout");
> +			goto put_device;
> +		}
> +		gsc_hw_enable_control(gsc, false);
> +	}
> +
> +	spin_unlock_irqrestore(&ctx->slock, flags);
> +	return;
> +
> +put_device:
> +	ctx->state&= ~GSC_PARAMS;
> +	spin_unlock_irqrestore(&ctx->slock, flags);
> +}
> +
> +static int gsc_m2m_queue_setup(struct vb2_queue *vq,
> +			const struct v4l2_format *fmt,
> +			unsigned int *num_buffers, unsigned int *num_planes,
> +			unsigned int sizes[], void *allocators[])
> +{
> +	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct gsc_frame *frame;
> +	int i;
> +
> +	frame = ctx_get_frame(ctx, vq->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	if (!frame->fmt)
> +		return -EINVAL;
> +
> +	*num_planes = frame->fmt->num_planes;
> +	for (i = 0; i<  frame->fmt->num_planes; i++) {
> +		sizes[i] = get_plane_size(frame, i);
> +		allocators[i] = ctx->gsc_dev->alloc_ctx;
> +	}
> +	return 0;
> +}
> +
> +static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct gsc_frame *frame;
> +	int i;
> +
> +	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
> +		for (i = 0; i<  frame->fmt->num_planes; i++)
> +			vb2_set_plane_payload(vb, i, frame->payload[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	gsc_dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
> +
> +	if (ctx->m2m_ctx)
> +		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> +}
> +
> +struct vb2_ops gsc_m2m_qops = {
> +	.queue_setup	 = gsc_m2m_queue_setup,
> +	.buf_prepare	 = gsc_m2m_buf_prepare,
> +	.buf_queue	 = gsc_m2m_buf_queue,
> +	.wait_prepare	 = gsc_unlock,
> +	.wait_finish	 = gsc_lock,
> +	.stop_streaming	 = gsc_m2m_stop_streaming,
> +	.start_streaming = gsc_m2m_start_streaming,
> +};
> +
> +static int gsc_m2m_querycap(struct file *file, void *fh,
> +			   struct v4l2_capability *cap)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +
> +	strncpy(cap->driver, gsc->pdev->name, sizeof(cap->driver) - 1);
> +	strncpy(cap->card, gsc->pdev->name, sizeof(cap->card) - 1);
> +	cap->bus_info[0] = 0;
> +	cap->capabilities = V4L2_CAP_STREAMING |
> +		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> +
> +	return 0;
> +}
> +
> +static int gsc_m2m_enum_fmt_mplane(struct file *file, void *priv,
> +				struct v4l2_fmtdesc *f)
> +{
> +	return gsc_enum_fmt_mplane(f);
> +}
> +
> +static int gsc_m2m_g_fmt_mplane(struct file *file, void *fh,
> +			     struct v4l2_format *f)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +
> +	return gsc_g_fmt_mplane(ctx, f);
> +}
> +
> +static int gsc_m2m_try_fmt_mplane(struct file *file, void *fh,
> +				  struct v4l2_format *f)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +
> +	return gsc_try_fmt_mplane(ctx, f);
> +}
> +
> +static int gsc_m2m_s_fmt_mplane(struct file *file, void *fh,
> +				 struct v4l2_format *f)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	struct vb2_queue *vq;
> +	struct gsc_frame *frame;
> +	struct v4l2_pix_format_mplane *pix;
> +	int i, ret = 0;
> +
> +	ret = gsc_m2m_try_fmt_mplane(file, fh, f);
> +	if (ret)
> +		return ret;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +
> +	if (vb2_is_streaming(vq)) {
> +		gsc_err("queue (%d) busy", f->type);
> +		return -EBUSY;
> +	}
> +
> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
> +		frame =&ctx->s_frame;
> +	else
> +		frame =&ctx->d_frame;
> +
> +	pix =&f->fmt.pix_mp;
> +	frame->fmt = find_fmt(&pix->pixelformat, NULL, 0);
> +	if (!frame->fmt)
> +		return -EINVAL;
> +
> +	for (i = 0; i<  frame->fmt->num_planes; i++)
> +		frame->payload[i] = pix->plane_fmt[i].sizeimage;
> +
> +	gsc_set_frame_size(frame, pix->width, pix->height);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		gsc_ctx_state_lock_set(GSC_PARAMS | GSC_DST_FMT, ctx);
> +	else
> +		gsc_ctx_state_lock_set(GSC_PARAMS | GSC_SRC_FMT, ctx);
> +
> +	gsc_dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
> +
> +	return 0;
> +}
> +
> +static int gsc_m2m_reqbufs(struct file *file, void *fh,
> +			  struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +	struct gsc_frame *frame;
> +	u32 max_cnt;
> +
> +	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
> +		gsc->variant->in_buf_cnt : gsc->variant->out_buf_cnt;
> +	if (reqbufs->count>  max_cnt)
> +		return -EINVAL;
> +	else if (reqbufs->count == 0) {
> +		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +			gsc_ctx_state_lock_clear(GSC_SRC_FMT, ctx);
> +		else
> +			gsc_ctx_state_lock_clear(GSC_DST_FMT, ctx);
> +	}
> +
> +	frame = ctx_get_frame(ctx, reqbufs->type);
> +
> +	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> +}
> +
> +static int gsc_m2m_querybuf(struct file *file, void *fh,
> +					struct v4l2_buffer *buf)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int gsc_m2m_qbuf(struct file *file, void *fh,
> +			  struct v4l2_buffer *buf)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int gsc_m2m_dqbuf(struct file *file, void *fh,
> +			   struct v4l2_buffer *buf)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int gsc_m2m_streamon(struct file *file, void *fh,
> +			   enum v4l2_buf_type type)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +
> +	/* The source and target color format need to be set */
> +	if (V4L2_TYPE_IS_OUTPUT(type)) {
> +		if (!gsc_ctx_state_is_set(GSC_SRC_FMT, ctx))
> +			return -EINVAL;
> +	} else if (!gsc_ctx_state_is_set(GSC_DST_FMT, ctx)) {
> +		return -EINVAL;
> +	}
> +
> +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> +}
> +
> +static int gsc_m2m_streamoff(struct file *file, void *fh,
> +			    enum v4l2_buf_type type)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> +}
> +
> +/* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
> +static int is_rectangle_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
> +{
> +	if (a->left<  b->left || a->top<  b->top)
> +		return 0;
> +
> +	if (a->left + a->width>  b->left + b->width)
> +		return 0;
> +
> +	if (a->top + a->height>  b->top + b->height)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static int gsc_m2m_g_selection(struct file *file, void *fh,
> +			struct v4l2_selection *s)
> +{
> +	struct gsc_frame *frame;
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +
> +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)&&
> +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
> +		return -EINVAL;
> +
> +	frame = ctx_get_frame(ctx, s->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = frame->f_width;
> +		s->r.height = frame->f_height;
> +		return 0;
> +
> +	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
> +	case V4L2_SEL_TGT_CROP_ACTIVE:
> +		s->r.left = frame->crop.left;
> +		s->r.top = frame->crop.top;
> +		s->r.width = frame->crop.width;
> +		s->r.height = frame->crop.height;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int gsc_m2m_s_selection(struct file *file, void *fh,
> +			struct v4l2_selection *s)
> +{
> +	struct gsc_frame *frame;
> +	struct gsc_ctx *ctx = fh_to_ctx(fh);
> +	struct v4l2_crop cr;
> +	struct gsc_variant *variant = ctx->gsc_dev->variant;
> +	int ret;
> +
> +	cr.type = s->type;
> +	cr.c = s->r;
> +
> +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)&&
> +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
> +		return -EINVAL;
> +
> +	ret = gsc_try_crop(ctx,&cr);
> +	if (ret)
> +		return ret;
> +
> +	if (s->flags&  V4L2_SEL_FLAG_LE&&
> +	    !is_rectangle_enclosed(&cr.c,&s->r))
> +		return -ERANGE;
> +
> +	if (s->flags&  V4L2_SEL_FLAG_GE&&
> +	    !is_rectangle_enclosed(&s->r,&cr.c))
> +		return -ERANGE;
> +
> +	s->r = cr.c;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
> +		frame =&ctx->s_frame;
> +		break;
> +
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP_ACTIVE:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +		frame =&ctx->d_frame;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Check to see if scaling ratio is within supported range */
> +	if (gsc_ctx_state_is_set(GSC_DST_FMT | GSC_SRC_FMT, ctx)) {
> +		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +			ret = gsc_check_scaler_ratio(variant, cr.c.width,
> +				cr.c.height, ctx->d_frame.crop.width,
> +				ctx->d_frame.crop.height,
> +				ctx->gsc_ctrls.rotate->val, ctx->out_path);
> +		} else {
> +			ret = gsc_check_scaler_ratio(variant,
> +				ctx->s_frame.crop.width,
> +				ctx->s_frame.crop.height, cr.c.width,
> +				cr.c.height, ctx->gsc_ctrls.rotate->val,
> +				ctx->out_path);
> +		}
> +
> +		if (ret) {
> +			gsc_err("Out of scaler range");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	frame->crop = cr.c;
> +
> +	gsc_ctx_state_lock_set(GSC_PARAMS, ctx);
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops gsc_m2m_ioctl_ops = {
> +	.vidioc_querycap		= gsc_m2m_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap_mplane	= gsc_m2m_enum_fmt_mplane,
> +	.vidioc_enum_fmt_vid_out_mplane	= gsc_m2m_enum_fmt_mplane,
> +
> +	.vidioc_g_fmt_vid_cap_mplane	= gsc_m2m_g_fmt_mplane,
> +	.vidioc_g_fmt_vid_out_mplane	= gsc_m2m_g_fmt_mplane,
> +
> +	.vidioc_try_fmt_vid_cap_mplane	= gsc_m2m_try_fmt_mplane,
> +	.vidioc_try_fmt_vid_out_mplane	= gsc_m2m_try_fmt_mplane,
> +
> +	.vidioc_s_fmt_vid_cap_mplane	= gsc_m2m_s_fmt_mplane,
> +	.vidioc_s_fmt_vid_out_mplane	= gsc_m2m_s_fmt_mplane,
> +
> +	.vidioc_reqbufs			= gsc_m2m_reqbufs,
> +	.vidioc_querybuf		= gsc_m2m_querybuf,
> +
> +	.vidioc_qbuf			= gsc_m2m_qbuf,
> +	.vidioc_dqbuf			= gsc_m2m_dqbuf,
> +
> +	.vidioc_streamon		= gsc_m2m_streamon,
> +	.vidioc_streamoff		= gsc_m2m_streamoff,
> +
> +	.vidioc_g_selection		= gsc_m2m_g_selection,
> +	.vidioc_s_selection		= gsc_m2m_s_selection
> +
> +};
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct gsc_ctx *ctx = priv;
> +	int ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	src_vq->drv_priv = ctx;
> +	src_vq->ops =&gsc_m2m_qops;
> +	src_vq->mem_ops =&vb2_dma_contig_memops;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->ops =&gsc_m2m_qops;
> +	dst_vq->mem_ops =&vb2_dma_contig_memops;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +static int gsc_m2m_open(struct file *file)
> +{
> +	struct gsc_dev *gsc = video_drvdata(file);
> +	struct gsc_ctx *ctx = NULL;
> +	int ret;
> +
> +	gsc_dbg("pid: %d, state: 0x%lx", task_pid_nr(current), gsc->state);
> +
> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	v4l2_fh_init(&ctx->fh, gsc->m2m.vfd);
> +	ret = gsc_ctrls_create(ctx);
> +	if (ret)
> +		goto error_fh;
> +
> +	/* Use separate control handler per file handle */
> +	ctx->fh.ctrl_handler =&ctx->ctrl_handler;
> +	file->private_data =&ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	ctx->gsc_dev = gsc;
> +	/* Default color format */
> +	ctx->s_frame.fmt = get_format(0);
> +	ctx->d_frame.fmt = get_format(0);
> +	/* Setup the device context for mem2mem mode. */
> +	ctx->state |= GSC_CTX_M2M;
> +	ctx->flags = 0;
> +	ctx->in_path = GSC_DMA;
> +	ctx->out_path = GSC_DMA;
> +	spin_lock_init(&ctx->slock);
> +
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(gsc->m2m.m2m_dev, ctx, queue_init);
> +	if (IS_ERR(ctx->m2m_ctx)) {
> +		gsc_err("Failed to initialize m2m context");
> +		ret = PTR_ERR(ctx->m2m_ctx);
> +		goto error_fh;
> +	}
> +
> +	if (gsc->m2m.refcnt++ == 0)
> +		set_bit(ST_M2M_OPEN,&gsc->state);
> +
> +	gsc_dbg("gsc m2m driver is opened, ctx(0x%p)", ctx);
> +	return 0;
> +
> +error_fh:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int gsc_m2m_release(struct file *file)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
> +	struct gsc_dev *gsc = ctx->gsc_dev;
> +
> +	gsc_dbg("pid: %d, state: 0x%lx, refcnt= %d",
> +		task_pid_nr(current), gsc->state, gsc->m2m.refcnt);
> +
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	gsc_ctrls_delete(ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +
> +	if (--gsc->m2m.refcnt<= 0)
> +		clear_bit(ST_M2M_OPEN,&gsc->state);
> +	kfree(ctx);
> +	return 0;
> +}
> +
> +static unsigned int gsc_m2m_poll(struct file *file,
> +				     struct poll_table_struct *wait)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +}
> +
> +static int gsc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +}
> +static const struct v4l2_file_operations gsc_m2m_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= gsc_m2m_open,
> +	.release	= gsc_m2m_release,
> +	.poll		= gsc_m2m_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= gsc_m2m_mmap,
> +};
> +
> +static struct v4l2_m2m_ops gsc_m2m_ops = {
> +	.device_run	= gsc_m2m_device_run,
> +	.job_abort	= gsc_m2m_job_abort,
> +};
> +
> +int gsc_register_m2m_device(struct gsc_dev *gsc)
> +{
> +	struct video_device *vfd;
> +	struct platform_device *pdev;
> +	int ret = 0;
> +
> +	if (!gsc)
> +		return -ENODEV;
> +
> +	pdev = gsc->pdev;
> +
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		dev_err(&pdev->dev, "Failed to allocate video device\n");
> +		return -ENOMEM;
> +	}
> +
> +	vfd->fops	=&gsc_m2m_fops;
> +	vfd->ioctl_ops	=&gsc_m2m_ioctl_ops;
> +	vfd->release	= video_device_release;
> +	vfd->lock	=&gsc->lock;
> +	snprintf(vfd->name, sizeof(vfd->name), "%s.%d:m2m",
> +					GSC_MODULE_NAME, gsc->id);
> +
> +	video_set_drvdata(vfd, gsc);
> +
> +	gsc->m2m.vfd = vfd;
> +	gsc->m2m.m2m_dev = v4l2_m2m_init(&gsc_m2m_ops);
> +	if (IS_ERR(gsc->m2m.m2m_dev)) {
> +		dev_err(&pdev->dev, "failed to initialize v4l2-m2m device\n");
> +		ret = PTR_ERR(gsc->m2m.m2m_dev);
> +		goto err_m2m_r1;
> +	}
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			 "%s(): failed to register video device\n", __func__);
> +		goto err_m2m_r2;
> +	}
> +
> +	gsc_dbg("gsc m2m driver registered as /dev/video%d", vfd->num);
> +
> +	return 0;
> +
> +err_m2m_r2:
> +	v4l2_m2m_release(gsc->m2m.m2m_dev);
> +err_m2m_r1:
> +	video_device_release(gsc->m2m.vfd);
> +
> +	return ret;
> +}
> +
> +void gsc_unregister_m2m_device(struct gsc_dev *gsc)
> +{
> +	if (gsc)
> +		v4l2_m2m_release(gsc->m2m.m2m_dev);
> +}
> diff --git a/drivers/media/video/exynos/gsc/gsc-regs.c b/drivers/media/video/exynos/gsc/gsc-regs.c
> new file mode 100644
> index 0000000..7c5cce2
> --- /dev/null
> +++ b/drivers/media/video/exynos/gsc/gsc-regs.c
> @@ -0,0 +1,579 @@
> +/* linux/drivers/media/video/exynos/gsc/gsc-regs.c
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Samsung EXYNOS5 SoC series G-scaler driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include<linux/io.h>
> +#include<linux/delay.h>
> +#include<mach/map.h>
> +#include "gsc-core.h"
> +
> +void gsc_hw_set_sw_reset(struct gsc_dev *dev)
> +{
> +	u32 cfg = 0;
> +
> +	cfg |= GSC_SW_RESET_SRESET;
> +	writel(cfg, dev->regs + GSC_SW_RESET);
> +}
> +
> +int gsc_wait_reset(struct gsc_dev *dev)
> +{
> +	unsigned long timeo = jiffies + 10; /* timeout of 50ms */
> +	u32 cfg;
> +
> +	while (time_before(jiffies, timeo)) {
> +		cfg = readl(dev->regs + GSC_SW_RESET);
> +		if (!cfg)
> +			return 0;
> +		usleep_range(10, 20);
> +	}
> +	gsc_dbg("wait time : %d ms", jiffies_to_msecs(jiffies - timeo + 20));
> +
> +	return -EBUSY;
> +}
> +
> +int gsc_wait_operating(struct gsc_dev *dev)
> +{
> +	unsigned long timeo = jiffies + 10; /* timeout of 50ms */

It would have been 50 ms for:

unsigned long timeo = jiffies + msecs_to_jiffies(50); /* timeout of 50ms */

Now it's just 10 jiffies!

Would you mind renaming "timeo" to "end" ?

> +	u32 cfg;
> +
> +	while (time_before(jiffies, timeo)) {
> +		cfg = readl(dev->regs + GSC_ENABLE);
> +		if ((cfg&  GSC_ENABLE_OP_STATUS) == GSC_ENABLE_OP_STATUS)
> +			return 0;
> +		usleep_range(10, 20);
> +	}
> +	gsc_dbg("wait time : %d ms", jiffies_to_msecs(jiffies - timeo + 20));

Misleading value. Might make sense to define some contants for
these timeouts.

> +
> +	return -EBUSY;
> +}
> +
> +int gsc_wait_stop(struct gsc_dev *dev)
> +{
> +	unsigned long timeo = jiffies + 10; /* timeout of 50ms */
> +	u32 cfg;
> +
> +	while (time_before(jiffies, timeo)) {
> +		cfg = readl(dev->regs + GSC_ENABLE);
> +		if (!(cfg&  GSC_ENABLE_OP_STATUS))
> +			return 0;
> +		usleep_range(10, 20);
> +	}
> +	gsc_dbg("wait time : %d ms", jiffies_to_msecs(jiffies - timeo + 20));

ditto

> +
> +	return -EBUSY;
> +}
> +
> +
> +void gsc_hw_set_one_frm_mode(struct gsc_dev *dev, bool mask)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_ENABLE);
> +	if (mask)
> +		cfg |= GSC_ENABLE_ON_CLEAR;
> +	else
> +		cfg&= ~GSC_ENABLE_ON_CLEAR;
> +	writel(cfg, dev->regs + GSC_ENABLE);
> +}
> +
> +int gsc_hw_get_input_buf_mask_status(struct gsc_dev *dev)
> +{
> +	u32 cfg, status, bits = 0;
> +
> +	cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
> +	status = cfg&  GSC_IN_BASE_ADDR_MASK;
> +	while (status) {
> +		status = status&  (status - 1);
> +		bits++;
> +	}
> +	return bits;
> +}
> +
> +int gsc_hw_get_done_input_buf_index(struct gsc_dev *dev)
> +{
> +	u32 cfg, curr_index, i;
> +
> +	cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
> +	curr_index = GSC_IN_CURR_GET_INDEX(cfg);
> +	for (i = curr_index; i>  1; i--) {
> +		if (cfg ^ (1<<  (i - 2)))
> +			return i - 2;
> +	}
> +
> +	for (i = dev->variant->in_buf_cnt; i>  curr_index; i--) {
> +		if (cfg ^ (1<<  (i - 1)))
> +			return i - 1;
> +	}
> +
> +	return curr_index - 1;
> +}
> +
> +void gsc_hw_set_frm_done_irq_mask(struct gsc_dev *dev, bool mask)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_IRQ);
> +	if (mask)
> +		cfg |= GSC_IRQ_FRMDONE_MASK;
> +	else
> +		cfg&= ~GSC_IRQ_FRMDONE_MASK;
> +	writel(cfg, dev->regs + GSC_IRQ);
> +}
> +
> +void gsc_hw_set_overflow_irq_mask(struct gsc_dev *dev, bool mask)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_IRQ);
> +	if (mask)
> +		cfg |= GSC_IRQ_OR_MASK;
> +	else
> +		cfg&= ~GSC_IRQ_OR_MASK;
> +	writel(cfg, dev->regs + GSC_IRQ);
> +}
> +
> +void gsc_hw_set_gsc_irq_enable(struct gsc_dev *dev, bool mask)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_IRQ);
> +	if (mask)
> +		cfg |= GSC_IRQ_ENABLE;
> +	else
> +		cfg&= ~GSC_IRQ_ENABLE;
> +	writel(cfg, dev->regs + GSC_IRQ);
> +}
> +
> +void gsc_hw_set_input_buf_mask_all(struct gsc_dev *dev)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
> +	cfg |= GSC_IN_BASE_ADDR_MASK;
> +	cfg |= GSC_IN_BASE_ADDR_PINGPONG(dev->variant->in_buf_cnt);
> +
> +	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
> +	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CB_MASK);
> +	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CR_MASK);
> +}
> +
> +void gsc_hw_set_output_buf_mask_all(struct gsc_dev *dev)
> +{
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
> +	cfg |= GSC_OUT_BASE_ADDR_MASK;
> +	cfg |= GSC_OUT_BASE_ADDR_PINGPONG(dev->variant->out_buf_cnt);
> +
> +	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
> +	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CB_MASK);
> +	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CR_MASK);
> +}
> +
> +void gsc_hw_set_input_buf_masking(struct gsc_dev *dev, u32 shift,
> +				bool enable)
> +{
> +	u32 cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
> +	u32 mask = 1<<  shift;
> +
> +	cfg&= (~mask);

Suprefluous parentheses.

> +	cfg |= enable<<  shift;
> +
> +	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
> +	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CB_MASK);
> +	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CR_MASK);
> +}
> +
> +void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift,
> +				bool enable)
> +{
> +	u32 cfg = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
> +	u32 mask = 1<<  shift;
> +
> +	cfg&= (~mask);

ditto

> +	cfg |= enable<<  shift;
> +
> +	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
> +	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CB_MASK);
> +	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CR_MASK);
> +}
> +
> +int gsc_hw_get_nr_unmask_bits(struct gsc_dev *dev)
> +{
> +	u32 bits = 0;
> +	u32 mask_bits = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);

Care to add an empty line? It might also look better to order 
declarations in decending line order. 

> +	mask_bits&= GSC_OUT_BASE_ADDR_MASK;
> +
> +	while (mask_bits) {
> +		mask_bits = mask_bits&  (mask_bits - 1);
> +		bits++;
> +	}
> +	bits = 16 - bits;

return 16 - bits;

> +
> +	return bits;
> +}
> +
> +void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
> +				int index)
> +{
> +	gsc_dbg("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
> +		addr->y, addr->cb, addr->cr);
> +	writel(addr->y, dev->regs + GSC_IN_BASE_ADDR_Y(index));
> +	writel(addr->cb, dev->regs + GSC_IN_BASE_ADDR_CB(index));
> +	writel(addr->cr, dev->regs + GSC_IN_BASE_ADDR_CR(index));
> +
> +}
> +
> +void gsc_hw_set_output_addr(struct gsc_dev *dev,
> +			     struct gsc_addr *addr, int index)
> +{
> +	gsc_dbg("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
> +			index, addr->y, addr->cb, addr->cr);
> +	writel(addr->y, dev->regs + GSC_OUT_BASE_ADDR_Y(index));
> +	writel(addr->cb, dev->regs + GSC_OUT_BASE_ADDR_CB(index));
> +	writel(addr->cr, dev->regs + GSC_OUT_BASE_ADDR_CR(index));
> +}
> +
> +void gsc_hw_set_input_path(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +
> +	u32 cfg = readl(dev->regs + GSC_IN_CON);
> +	cfg&= ~(GSC_IN_PATH_MASK | GSC_IN_LOCAL_SEL_MASK);
> +
> +	if (ctx->in_path == GSC_DMA)
> +		cfg |= GSC_IN_PATH_MEMORY;
> +
> +	writel(cfg, dev->regs + GSC_IN_CON);
> +}
> +
> +void gsc_hw_set_in_size(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_frame *frame =&ctx->s_frame;
> +	u32 cfg;
> +
> +	/* Set input pixel offset */
> +	cfg = GSC_SRCIMG_OFFSET_X(frame->crop.left);
> +	cfg |= GSC_SRCIMG_OFFSET_Y(frame->crop.top);
> +	writel(cfg, dev->regs + GSC_SRCIMG_OFFSET);
> +
> +	/* Set input original size */
> +	cfg = GSC_SRCIMG_WIDTH(frame->f_width);
> +	cfg |= GSC_SRCIMG_HEIGHT(frame->f_height);
> +	writel(cfg, dev->regs + GSC_SRCIMG_SIZE);
> +
> +	/* Set input cropped size */
> +	cfg = GSC_CROPPED_WIDTH(frame->crop.width);
> +	cfg |= GSC_CROPPED_HEIGHT(frame->crop.height);
> +	writel(cfg, dev->regs + GSC_CROPPED_SIZE);
> +}
> +
> +void gsc_hw_set_in_image_rgb(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_frame *frame =&ctx->s_frame;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_IN_CON);
> +	if (ctx->gsc_ctrls.csc_eq->val) {
> +		if (ctx->gsc_ctrls.csc_range->val)
> +			cfg |= GSC_IN_RGB_HD_WIDE;
> +		else
> +			cfg |= GSC_IN_RGB_HD_NARROW;
> +	} else {
> +		if (ctx->gsc_ctrls.csc_range->val)
> +			cfg |= GSC_IN_RGB_SD_WIDE;
> +		else
> +			cfg |= GSC_IN_RGB_SD_NARROW;
> +	}
> +
> +	if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB565X)
> +		cfg |= GSC_IN_RGB565;
> +	else if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB32)
> +		cfg |= GSC_IN_XRGB8888;
> +
> +	writel(cfg, dev->regs + GSC_IN_CON);
> +}
> +
> +void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_frame *frame =&ctx->s_frame;
> +	u32 i, depth = 0;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_IN_CON);
> +	cfg&= ~(GSC_IN_RGB_TYPE_MASK | GSC_IN_YUV422_1P_ORDER_MASK |
> +		 GSC_IN_CHROMA_ORDER_MASK | GSC_IN_FORMAT_MASK |
> +		 GSC_IN_TILE_TYPE_MASK | GSC_IN_TILE_MODE);
> +	writel(cfg, dev->regs + GSC_IN_CON);
> +
> +	if (is_rgb(frame->fmt->color)) {
> +		gsc_hw_set_in_image_rgb(ctx);
> +		return;
> +	}
> +	for (i = 0; i<  frame->fmt->num_planes; i++)
> +		depth += frame->fmt->depth[i];
> +
> +	switch (frame->fmt->num_comp) {
> +	case 1:
> +		cfg |= GSC_IN_YUV422_1P;
> +		if (frame->fmt->yorder == GSC_LSB_Y)
> +			cfg |= GSC_IN_YUV422_1P_ORDER_LSB_Y;
> +		else
> +			cfg |= GSC_IN_YUV422_1P_OEDER_LSB_C;
> +		if (frame->fmt->corder == GSC_CBCR)
> +			cfg |= GSC_IN_CHROMA_ORDER_CBCR;
> +		else
> +			cfg |= GSC_IN_CHROMA_ORDER_CRCB;
> +		break;
> +	case 2:
> +		if (depth == 12)
> +			cfg |= GSC_IN_YUV420_2P;
> +		else
> +			cfg |= GSC_IN_YUV422_2P;
> +		if (frame->fmt->corder == GSC_CBCR)
> +			cfg |= GSC_IN_CHROMA_ORDER_CBCR;
> +		else
> +			cfg |= GSC_IN_CHROMA_ORDER_CRCB;
> +		break;
> +	case 3:
> +		if (depth == 12)
> +			cfg |= GSC_IN_YUV420_3P;
> +		else
> +			cfg |= GSC_IN_YUV422_3P;
> +		break;
> +	};
> +
> +	if (is_tiled(frame->fmt))
> +		cfg |= GSC_IN_TILE_C_16x8 | GSC_IN_TILE_MODE;
> +
> +	writel(cfg, dev->regs + GSC_IN_CON);
> +}
> +
> +void gsc_hw_set_output_path(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +
> +	u32 cfg = readl(dev->regs + GSC_OUT_CON);
> +	cfg&= ~GSC_OUT_PATH_MASK;
> +
> +	if (ctx->out_path == GSC_DMA)
> +		cfg |= GSC_OUT_PATH_MEMORY;
> +	else
> +		cfg |= GSC_OUT_PATH_LOCAL;
> +
> +	writel(cfg, dev->regs + GSC_OUT_CON);
> +}
> +
> +void gsc_hw_set_out_size(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_frame *frame =&ctx->d_frame;
> +	u32 cfg;
> +
> +	/* Set output original size */
> +	if (ctx->out_path == GSC_DMA) {
> +		cfg = GSC_DSTIMG_OFFSET_X(frame->crop.left);
> +		cfg |= GSC_DSTIMG_OFFSET_Y(frame->crop.top);
> +		writel(cfg, dev->regs + GSC_DSTIMG_OFFSET);
> +
> +		cfg = GSC_DSTIMG_WIDTH(frame->f_width);
> +		cfg |= GSC_DSTIMG_HEIGHT(frame->f_height);
> +		writel(cfg, dev->regs + GSC_DSTIMG_SIZE);
> +	}
> +
> +	/* Set output scaled size */
> +	if (ctx->gsc_ctrls.rotate->val == 90 ||
> +	    ctx->gsc_ctrls.rotate->val == 270) {
> +		cfg = GSC_SCALED_WIDTH(frame->crop.height);
> +		cfg |= GSC_SCALED_HEIGHT(frame->crop.width);
> +	} else {
> +		cfg = GSC_SCALED_WIDTH(frame->crop.width);
> +		cfg |= GSC_SCALED_HEIGHT(frame->crop.height);
> +	}
> +	writel(cfg, dev->regs + GSC_SCALED_SIZE);
> +}
> +
> +void gsc_hw_set_out_image_rgb(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_frame *frame =&ctx->d_frame;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_OUT_CON);
> +	if (ctx->gsc_ctrls.csc_eq->val) {
> +		if (ctx->gsc_ctrls.csc_range->val)
> +			cfg |= GSC_OUT_RGB_HD_WIDE;
> +		else
> +			cfg |= GSC_OUT_RGB_HD_NARROW;
> +	} else {
> +		if (ctx->gsc_ctrls.csc_range->val)
> +			cfg |= GSC_OUT_RGB_SD_WIDE;
> +		else
> +			cfg |= GSC_OUT_RGB_SD_NARROW;
> +	}
> +
> +	if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB565X)
> +		cfg |= GSC_OUT_RGB565;
> +	else if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB32)
> +		cfg |= GSC_OUT_XRGB8888;
> +
> +	writel(cfg, dev->regs + GSC_OUT_CON);
> +}
> +
> +void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_frame *frame =&ctx->d_frame;
> +	u32 i, depth = 0;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_OUT_CON);
> +	cfg&= ~(GSC_OUT_RGB_TYPE_MASK | GSC_OUT_YUV422_1P_ORDER_MASK |
> +		 GSC_OUT_CHROMA_ORDER_MASK | GSC_OUT_FORMAT_MASK |
> +		 GSC_OUT_TILE_TYPE_MASK | GSC_OUT_TILE_MODE);
> +	writel(cfg, dev->regs + GSC_OUT_CON);
> +
> +	if (is_rgb(frame->fmt->color)) {
> +		gsc_hw_set_out_image_rgb(ctx);
> +		return;
> +	}
> +
> +	if (ctx->out_path != GSC_DMA) {
> +		cfg |= GSC_OUT_YUV444;
> +		goto end_set;
> +	}
> +
> +	for (i = 0; i<  frame->fmt->num_planes; i++)
> +		depth += frame->fmt->depth[i];
> +
> +	switch (frame->fmt->num_comp) {
> +	case 1:
> +		cfg |= GSC_OUT_YUV422_1P;
> +		if (frame->fmt->yorder == GSC_LSB_Y)
> +			cfg |= GSC_OUT_YUV422_1P_ORDER_LSB_Y;
> +		else
> +			cfg |= GSC_OUT_YUV422_1P_OEDER_LSB_C;
> +		if (frame->fmt->corder == GSC_CBCR)
> +			cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
> +		else
> +			cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
> +		break;
> +	case 2:
> +		if (depth == 12)
> +			cfg |= GSC_OUT_YUV420_2P;
> +		else
> +			cfg |= GSC_OUT_YUV422_2P;
> +		if (frame->fmt->corder == GSC_CBCR)
> +			cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
> +		else
> +			cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
> +		break;
> +	case 3:
> +		cfg |= GSC_OUT_YUV420_3P;
> +		break;
> +	};
> +
> +	if (is_tiled(frame->fmt))
> +		cfg |= GSC_OUT_TILE_C_16x8 | GSC_OUT_TILE_MODE;
> +
> +end_set:
> +	writel(cfg, dev->regs + GSC_OUT_CON);
> +}
> +
> +void gsc_hw_set_prescaler(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_scaler *sc =&ctx->scaler;
> +	u32 cfg;
> +
> +	cfg = GSC_PRESC_SHFACTOR(sc->pre_shfactor);
> +	cfg |= GSC_PRESC_H_RATIO(sc->pre_hratio);
> +	cfg |= GSC_PRESC_V_RATIO(sc->pre_vratio);
> +	writel(cfg, dev->regs + GSC_PRE_SCALE_RATIO);
> +}
> +
> +void gsc_hw_set_mainscaler(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_scaler *sc =&ctx->scaler;
> +	u32 cfg;
> +
> +	cfg = GSC_MAIN_H_RATIO_VALUE(sc->main_hratio);
> +	writel(cfg, dev->regs + GSC_MAIN_H_RATIO);
> +
> +	cfg = GSC_MAIN_V_RATIO_VALUE(sc->main_vratio);
> +	writel(cfg, dev->regs + GSC_MAIN_V_RATIO);
> +}
> +
> +void gsc_hw_set_rotation(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_IN_CON);
> +	cfg&= ~GSC_IN_ROT_MASK;
> +
> +	switch (ctx->gsc_ctrls.rotate->val) {
> +	case 270:
> +		cfg |= GSC_IN_ROT_270;
> +		break;
> +	case 180:
> +		cfg |= GSC_IN_ROT_180;
> +		break;
> +	case 90:
> +		if (ctx->gsc_ctrls.hflip->val)
> +			cfg |= GSC_IN_ROT_90_XFLIP;
> +		else if (ctx->gsc_ctrls.vflip->val)
> +			cfg |= GSC_IN_ROT_90_YFLIP;
> +		else
> +			cfg |= GSC_IN_ROT_90;
> +		break;
> +	case 0:
> +		if (ctx->gsc_ctrls.hflip->val)
> +			cfg |= GSC_IN_ROT_XFLIP;
> +		else if (ctx->gsc_ctrls.vflip->val)
> +			cfg |= GSC_IN_ROT_YFLIP;
> +	}
> +
> +	writel(cfg, dev->regs + GSC_IN_CON);
> +}
> +
> +void gsc_hw_set_global_alpha(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	struct gsc_frame *frame =&ctx->d_frame;
> +	u32 cfg;
> +
> +	if (!is_rgb(frame->fmt->color)) {
> +		gsc_dbg("Not a RGB format");
> +		return;
> +	}
> +
> +	cfg = readl(dev->regs + GSC_OUT_CON);
> +	cfg&= ~GSC_OUT_GLOBAL_ALPHA_MASK;
> +
> +	cfg |= GSC_OUT_GLOBAL_ALPHA(ctx->gsc_ctrls.global_alpha->val);
> +	writel(cfg, dev->regs + GSC_OUT_CON);
> +}
> +
> +void gsc_hw_set_sfr_update(struct gsc_ctx *ctx)
> +{
> +	struct gsc_dev *dev = ctx->gsc_dev;
> +	u32 cfg;
> +
> +	cfg = readl(dev->regs + GSC_ENABLE);
> +	cfg |= GSC_ENABLE_SFR_UPDATE;
> +	writel(cfg, dev->regs + GSC_ENABLE);
> +}
...
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index f79d0cc..5b4a33b 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -360,9 +360,11 @@ struct v4l2_pix_format {
>   /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
>   #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
>   #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
> +#define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
>
>   /* three non contiguous planes - Y, Cb, Cr */
>   #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
> +#define V4L2_PIX_FMT_YVU420M v4l2_fourcc('Y', 'V', 'U', 'M') /* 12  YVU420 planar */
>
>   /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
>   #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */

Please split videodev2.h changes into separate patches, adding new fourcc
and proper documentation to media DocBook.

It would be great if you could split this patch even further, it's 
tiresome to review so many lines of code at once. I had this review
half-finished for a few days before I just got it completed tonight,
and you posted another patch version in the meantime.

--

Thanks,
Sylwester
