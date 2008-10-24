Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9OIXvSH001533
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 14:33:57 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9OIXIgH014908
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 14:33:42 -0400
Date: Fri, 24 Oct 2008 20:33:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uwsfykfhj.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0810242027460.7996@axis700.grange>
References: <uwsfykfhj.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: khali@linux-fr.org, V4L <video4linux-list@redhat.com>, i2c@lm-sensors.org,
	mchehab@infradead.org
Subject: Re: [PATCH v8] Add ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 24 Oct 2008, Kuninori Morimoto wrote:

> This patch adds ov772x driver that use soc_camera framework.
> It was tested on SH Migo-r board.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Thanks for fixing! I'll pull it through my hg-tree and ask Mauro to push 
it to Linus. Even though 2.6.28-rc1 has been released, as a new driver 
submission it still might have a chance to get in for 2.6.28.

Thanks
Guennadi

> ---
> Patch v7 -> v8
> fix SWAP_MASK mistake
> remove empty lines.
> 
>  drivers/media/video/Kconfig     |    6 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/ov772x.c    |  966 +++++++++++++++++++++++++++++++++++++++
>  include/media/ov772x.h          |   21 +
>  include/media/v4l2-chip-ident.h |    1 +
>  5 files changed, 995 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ov772x.c
>  create mode 100644 include/media/ov772x.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 47102c2..7b363da 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -750,6 +750,12 @@ config SOC_CAMERA_PLATFORM
>  	help
>  	  This is a generic SoC camera platform driver, useful for testing
>  
> +config SOC_CAMERA_OV772X
> +	tristate "ov772x camera support"
> +	depends on SOC_CAMERA && I2C
> +	help
> +	  This is a ov772x camera driver
> +
>  config VIDEO_PXA27x
>  	tristate "PXA27x Quick Capture Interface driver"
>  	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 16962f3..cc6698e 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -133,6 +133,7 @@ obj-$(CONFIG_SOC_CAMERA)	+= soc_camera.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
>  obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
> +obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
>  obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
>  
>  obj-$(CONFIG_VIDEO_AU0828) += au0828/
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> new file mode 100644
> index 0000000..6206dff
> --- /dev/null
> +++ b/drivers/media/video/ov772x.c
> @@ -0,0 +1,966 @@
> +/*
> + * ov772x Camera Driver
> + *
> + * Copyright (C) 2008 Renesas Solutions Corp.
> + * Kuninori Morimoto <morimoto.kuninori@renesas.com>
> + *
> + * Based on ov7670 and soc_camera_platform driver,
> + *
> + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
> + * Copyright (C) 2008 Magnus Damm
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-common.h>
> +#include <media/soc_camera.h>
> +#include <media/ov772x.h>
> +
> +/*
> + * register offset
> + */
> +#define GAIN        0x00 /* AGC - Gain control gain setting */
> +#define BLUE        0x01 /* AWB - Blue channel gain setting */
> +#define RED         0x02 /* AWB - Red   channel gain setting */
> +#define GREEN       0x03 /* AWB - Green channel gain setting */
> +#define COM1        0x04 /* Common control 1 */
> +#define BAVG        0x05 /* U/B Average Level */
> +#define GAVG        0x06 /* Y/Gb Average Level */
> +#define RAVG        0x07 /* V/R Average Level */
> +#define AECH        0x08 /* Exposure Value - AEC MSBs */
> +#define COM2        0x09 /* Common control 2 */
> +#define PID         0x0A /* Product ID Number MSB */
> +#define VER         0x0B /* Product ID Number LSB */
> +#define COM3        0x0C /* Common control 3 */
> +#define COM4        0x0D /* Common control 4 */
> +#define COM5        0x0E /* Common control 5 */
> +#define COM6        0x0F /* Common control 6 */
> +#define AEC         0x10 /* Exposure Value */
> +#define CLKRC       0x11 /* Internal clock */
> +#define COM7        0x12 /* Common control 7 */
> +#define COM8        0x13 /* Common control 8 */
> +#define COM9        0x14 /* Common control 9 */
> +#define COM10       0x15 /* Common control 10 */
> +#define HSTART      0x17 /* Horizontal sensor size */
> +#define HSIZE       0x18 /* Horizontal frame (HREF column) end high 8-bit */
> +#define VSTART      0x19 /* Vertical frame (row) start high 8-bit */
> +#define VSIZE       0x1A /* Vertical sensor size */
> +#define PSHFT       0x1B /* Data format - pixel delay select */
> +#define MIDH        0x1C /* Manufacturer ID byte - high */
> +#define MIDL        0x1D /* Manufacturer ID byte - low  */
> +#define LAEC        0x1F /* Fine AEC value */
> +#define COM11       0x20 /* Common control 11 */
> +#define BDBASE      0x22 /* Banding filter Minimum AEC value */
> +#define DBSTEP      0x23 /* Banding filter Maximum Setp */
> +#define AEW         0x24 /* AGC/AEC - Stable operating region (upper limit) */
> +#define AEB         0x25 /* AGC/AEC - Stable operating region (lower limit) */
> +#define VPT         0x26 /* AGC/AEC Fast mode operating region */
> +#define HOUTSIZE    0x29 /* Horizontal data output size MSBs */
> +#define EXHCH       0x2A /* Dummy pixel insert MSB */
> +#define EXHCL       0x2B /* Dummy pixel insert LSB */
> +#define VOUTSIZE    0x2C /* Vertical data output size MSBs */
> +#define ADVFL       0x2D /* LSB of insert dummy lines in Vertical direction */
> +#define ADVFH       0x2E /* MSG of insert dummy lines in Vertical direction */
> +#define YAVE        0x2F /* Y/G Channel Average value */
> +#define LUMHTH      0x30 /* Histogram AEC/AGC Luminance high level threshold */
> +#define LUMLTH      0x31 /* Histogram AEC/AGC Luminance low  level threshold */
> +#define HREF        0x32 /* Image start and size control */
> +#define DM_LNL      0x33 /* Dummy line low  8 bits */
> +#define DM_LNH      0x34 /* Dummy line high 8 bits */
> +#define ADOFF_B     0x35 /* AD offset compensation value for B  channel */
> +#define ADOFF_R     0x36 /* AD offset compensation value for R  channel */
> +#define ADOFF_GB    0x37 /* AD offset compensation value for Gb channel */
> +#define ADOFF_GR    0x38 /* AD offset compensation value for Gr channel */
> +#define OFF_B       0x39 /* Analog process B  channel offset value */
> +#define OFF_R       0x3A /* Analog process R  channel offset value */
> +#define OFF_GB      0x3B /* Analog process Gb channel offset value */
> +#define OFF_GR      0x3C /* Analog process Gr channel offset value */
> +#define COM12       0x3D /* Common control 12 */
> +#define COM13       0x3E /* Common control 13 */
> +#define COM14       0x3F /* Common control 14 */
> +#define COM15       0x40 /* Common control 15*/
> +#define COM16       0x41 /* Common control 16 */
> +#define TGT_B       0x42 /* BLC blue channel target value */
> +#define TGT_R       0x43 /* BLC red  channel target value */
> +#define TGT_GB      0x44 /* BLC Gb   channel target value */
> +#define TGT_GR      0x45 /* BLC Gr   channel target value */
> +#define LCC0        0x46 /* Lens correction control 0 */
> +#define LCC1        0x47 /* Lens correction option 1 - X coordinate */
> +#define LCC2        0x48 /* Lens correction option 2 - Y coordinate */
> +#define LCC3        0x49 /* Lens correction option 3 */
> +#define LCC4        0x4A /* Lens correction option 4 - radius of the circular */
> +#define LCC5        0x4B /* Lens correction option 5 */
> +#define LCC6        0x4C /* Lens correction option 6 */
> +#define FIXGAIN     0x4D /* Analog fix gain amplifer */
> +#define AREF0       0x4E /* Sensor reference control */
> +#define AREF1       0x4F /* Sensor reference current control */
> +#define AREF2       0x50 /* Analog reference control */
> +#define AREF3       0x51 /* ADC    reference control */
> +#define AREF4       0x52 /* ADC    reference control */
> +#define AREF5       0x53 /* ADC    reference control */
> +#define AREF6       0x54 /* Analog reference control */
> +#define AREF7       0x55 /* Analog reference control */
> +#define UFIX        0x60 /* U channel fixed value output */
> +#define VFIX        0x61 /* V channel fixed value output */
> +#define AW_BB_BLK   0x62 /* AWB option for advanced AWB */
> +#define AW_B_CTRL0  0x63 /* AWB control byte 0 */
> +#define DSP_CTRL1   0x64 /* DSP control byte 1 */
> +#define DSP_CTRL2   0x65 /* DSP control byte 2 */
> +#define DSP_CTRL3   0x66 /* DSP control byte 3 */
> +#define DSP_CTRL4   0x67 /* DSP control byte 4 */
> +#define AW_B_BIAS   0x68 /* AWB BLC level clip */
> +#define AW_BCTRL1   0x69 /* AWB control  1 */
> +#define AW_BCTRL2   0x6A /* AWB control  2 */
> +#define AW_BCTRL3   0x6B /* AWB control  3 */
> +#define AW_BCTRL4   0x6C /* AWB control  4 */
> +#define AW_BCTRL5   0x6D /* AWB control  5 */
> +#define AW_BCTRL6   0x6E /* AWB control  6 */
> +#define AW_BCTRL7   0x6F /* AWB control  7 */
> +#define AW_BCTRL8   0x70 /* AWB control  8 */
> +#define AW_BCTRL9   0x71 /* AWB control  9 */
> +#define AW_BCTRL10  0x72 /* AWB control 10 */
> +#define AW_BCTRL11  0x73 /* AWB control 11 */
> +#define AW_BCTRL12  0x74 /* AWB control 12 */
> +#define AW_BCTRL13  0x75 /* AWB control 13 */
> +#define AW_BCTRL14  0x76 /* AWB control 14 */
> +#define AW_BCTRL15  0x77 /* AWB control 15 */
> +#define AW_BCTRL16  0x78 /* AWB control 16 */
> +#define AW_BCTRL17  0x79 /* AWB control 17 */
> +#define AW_BCTRL18  0x7A /* AWB control 18 */
> +#define AW_BCTRL19  0x7B /* AWB control 19 */
> +#define AW_BCTRL20  0x7C /* AWB control 20 */
> +#define AW_BCTRL21  0x7D /* AWB control 21 */
> +#define GAM1        0x7E /* Gamma Curve  1st segment input end point */
> +#define GAM2        0x7F /* Gamma Curve  2nd segment input end point */
> +#define GAM3        0x80 /* Gamma Curve  3rd segment input end point */
> +#define GAM4        0x81 /* Gamma Curve  4th segment input end point */
> +#define GAM5        0x82 /* Gamma Curve  5th segment input end point */
> +#define GAM6        0x83 /* Gamma Curve  6th segment input end point */
> +#define GAM7        0x84 /* Gamma Curve  7th segment input end point */
> +#define GAM8        0x85 /* Gamma Curve  8th segment input end point */
> +#define GAM9        0x86 /* Gamma Curve  9th segment input end point */
> +#define GAM10       0x87 /* Gamma Curve 10th segment input end point */
> +#define GAM11       0x88 /* Gamma Curve 11th segment input end point */
> +#define GAM12       0x89 /* Gamma Curve 12th segment input end point */
> +#define GAM13       0x8A /* Gamma Curve 13th segment input end point */
> +#define GAM14       0x8B /* Gamma Curve 14th segment input end point */
> +#define GAM15       0x8C /* Gamma Curve 15th segment input end point */
> +#define SLOP        0x8D /* Gamma curve highest segment slope */
> +#define DNSTH       0x8E /* De-noise threshold */
> +#define EDGE0       0x8F /* Edge enhancement control 0 */
> +#define EDGE1       0x90 /* Edge enhancement control 1 */
> +#define DNSOFF      0x91 /* Auto De-noise threshold control */
> +#define EDGE2       0x92 /* Edge enhancement strength low  point control */
> +#define EDGE3       0x93 /* Edge enhancement strength high point control */
> +#define MTX1        0x94 /* Matrix coefficient 1 */
> +#define MTX2        0x95 /* Matrix coefficient 2 */
> +#define MTX3        0x96 /* Matrix coefficient 3 */
> +#define MTX4        0x97 /* Matrix coefficient 4 */
> +#define MTX5        0x98 /* Matrix coefficient 5 */
> +#define MTX6        0x99 /* Matrix coefficient 6 */
> +#define MTX_CTRL    0x9A /* Matrix control */
> +#define BRIGHT      0x9B /* Brightness control */
> +#define CNTRST      0x9C /* Contrast contrast */
> +#define CNTRST_CTRL 0x9D /* Contrast contrast center */
> +#define UVAD_J0     0x9E /* Auto UV adjust contrast 0 */
> +#define UVAD_J1     0x9F /* Auto UV adjust contrast 1 */
> +#define SCAL0       0xA0 /* Scaling control 0 */
> +#define SCAL1       0xA1 /* Scaling control 1 */
> +#define SCAL2       0xA2 /* Scaling control 2 */
> +#define FIFODLYM    0xA3 /* FIFO manual mode delay control */
> +#define FIFODLYA    0xA4 /* FIFO auto   mode delay control */
> +#define SDE         0xA6 /* Special digital effect control */
> +#define USAT        0xA7 /* U component saturation control */
> +#define VSAT        0xA8 /* V component saturation control */
> +#define HUE0        0xA9 /* Hue control 0 */
> +#define HUE1        0xAA /* Hue control 1 */
> +#define SIGN        0xAB /* Sign bit for Hue and contrast */
> +#define DSPAUTO     0xAC /* DSP auto function ON/OFF control */
> +
> +/*
> + * register detail
> + */
> +
> +/* COM2 */
> +#define SOFT_SLEEP_MODE 0x10	/* Soft sleep mode */
> +				/* Output drive capability */
> +#define OCAP_1x         0x00	/* 1x */
> +#define OCAP_2x         0x01	/* 2x */
> +#define OCAP_3x         0x02	/* 3x */
> +#define OCAP_4x         0x03	/* 4x */
> +
> +/* COM3 */
> +#define SWAP_MASK       0x38
> +
> +#define VFIMG_ON_OFF    0x80	/* Vertical flip image ON/OFF selection */
> +#define HMIMG_ON_OFF    0x40	/* Horizontal mirror image ON/OFF selection */
> +#define SWAP_RGB        0x20	/* Swap B/R  output sequence in RGB mode */
> +#define SWAP_YUV        0x10	/* Swap Y/UV output sequence in YUV mode */
> +#define SWAP_ML         0x08	/* Swap output MSB/LSB */
> +				/* Tri-state option for output clock */
> +#define NOTRI_CLOCK     0x04	/*   0: Tri-state    at this period */
> +				/*   1: No tri-state at this period */
> +				/* Tri-state option for output data */
> +#define NOTRI_DATA      0x02	/*   0: Tri-state    at this period */
> +				/*   1: No tri-state at this period */
> +#define SCOLOR_TEST     0x01	/* Sensor color bar test pattern */
> +
> +/* COM4 */
> +				/* PLL frequency control */
> +#define PLL_BYPASS      0x00	/*  00: Bypass PLL */
> +#define PLL_4x          0x40	/*  01: PLL 4x */
> +#define PLL_6x          0x80	/*  10: PLL 6x */
> +#define PLL_8x          0xc0	/*  11: PLL 8x */
> +				/* AEC evaluate window */
> +#define AEC_FULL        0x00	/*  00: Full window */
> +#define AEC_1p2         0x10	/*  01: 1/2  window */
> +#define AEC_1p4         0x20	/*  10: 1/4  window */
> +#define AEC_2p3         0x30	/*  11: Low 2/3 window */
> +
> +/* COM5 */
> +#define AFR_ON_OFF      0x80	/* Auto frame rate control ON/OFF selection */
> +#define AFR_SPPED       0x40	/* Auto frame rate control speed slection */
> +				/* Auto frame rate max rate control */
> +#define AFR_NO_RATE     0x00	/*     No  reduction of frame rate */
> +#define AFR_1p2         0x10	/*     Max reduction to 1/2 frame rate */
> +#define AFR_1p4         0x20	/*     Max reduction to 1/4 frame rate */
> +#define AFR_1p8         0x30	/* Max reduction to 1/8 frame rate */
> +				/* Auto frame rate active point control */
> +#define AF_2x           0x00	/*     Add frame when AGC reaches  2x gain */
> +#define AF_4x           0x04	/*     Add frame when AGC reaches  4x gain */
> +#define AF_8x           0x08	/*     Add frame when AGC reaches  8x gain */
> +#define AF_16x          0x0c	/* Add frame when AGC reaches 16x gain */
> +				/* AEC max step control */
> +#define AEC_NO_LIMIT    0x01	/*   0 : AEC incease step has limit */
> +				/*   1 : No limit to AEC increase step */
> +
> +/* COM7 */
> +				/* SCCB Register Reset */
> +#define SCCB_RESET      0x80	/*   0 : No change */
> +				/*   1 : Resets all registers to default */
> +				/* Resolution selection */
> +#define SLCT_MASK       0x40	/*   Mask of VGA or QVGA */
> +#define SLCT_VGA        0x00	/*   0 : VGA */
> +#define SLCT_QVGA       0x40	/*   1 : QVGA */
> +#define ITU656_ON_OFF   0x20	/* ITU656 protocol ON/OFF selection */
> +				/* RGB output format control */
> +#define FMT_GBR422      0x00	/*      00 : GBR 4:2:2 */
> +#define FMT_RGB565      0x04	/*      01 : RGB 565 */
> +#define FMT_RGB555      0x08	/*      10 : RGB 555 */
> +#define FMT_RGB444      0x0c	/* 11 : RGB 444 */
> +				/* Output format control */
> +#define OFMT_YUV        0x00	/*      00 : YUV */
> +#define OFMT_P_BRAW     0x01	/*      01 : Processed Bayer RAW */
> +#define OFMT_RGB        0x02	/*      10 : RGB */
> +#define OFMT_BRAW       0x03	/* 11 : Bayer RAW */
> +
> +/* COM8 */
> +#define FAST_ALGO       0x80	/* Enable fast AGC/AEC algorithm */
> +				/* AEC Setp size limit */
> +#define UNLMT_STEP      0x40	/*   0 : Step size is limited */
> +				/*   1 : Unlimited step size */
> +#define BNDF_ON_OFF     0x20	/* Banding filter ON/OFF */
> +#define AEC_BND         0x10	/* Enable AEC below banding value */
> +#define AEC_ON_OFF      0x08	/* Fine AEC ON/OFF control */
> +#define AGC_ON          0x04	/* AGC Enable */
> +#define AWB_ON          0x02	/* AWB Enable */
> +#define AEC_ON          0x01	/* AEC Enable */
> +
> +/* COM9 */
> +#define BASE_AECAGC     0x80	/* Histogram or average based AEC/AGC */
> +				/* Automatic gain ceiling - maximum AGC value */
> +#define GAIN_2x         0x00	/*    000 :   2x */
> +#define GAIN_4x         0x10	/*    001 :   4x */
> +#define GAIN_8x         0x20	/*    010 :   8x */
> +#define GAIN_16x        0x30	/* 011 :  16x */
> +#define GAIN_32x        0x40	/*    100 :  32x */
> +#define GAIN_64x        0x50	/* 101 :  64x */
> +#define GAIN_128x       0x60	/* 110 : 128x */
> +#define DROP_VSYNC      0x04	/* Drop VSYNC output of corrupt frame */
> +#define DROP_HREF       0x02	/* Drop HREF  output of corrupt frame */
> +
> +/* COM11 */
> +#define SGLF_ON_OFF     0x02	/* Single frame ON/OFF selection */
> +#define SGLF_TRIG       0x01	/* Single frame transfer trigger */
> +
> +/* EXHCH */
> +#define VSIZE_LSB       0x04	/* Vertical data output size LSB */
> +
> +/* DSP_CTRL1 */
> +#define FIFO_ON         0x80	/* FIFO enable/disable selection */
> +#define UV_ON_OFF       0x40	/* UV adjust function ON/OFF selection */
> +#define YUV444_2_422    0x20	/* YUV444 to 422 UV channel option selection */
> +#define CLR_MTRX_ON_OFF 0x10	/* Color matrix ON/OFF selection */
> +#define INTPLT_ON_OFF   0x08	/* Interpolation ON/OFF selection */
> +#define GMM_ON_OFF      0x04	/* Gamma function ON/OFF selection */
> +#define AUTO_BLK_ON_OFF 0x02	/* Black defect auto correction ON/OFF */
> +#define AUTO_WHT_ON_OFF 0x01	/* White define auto correction ON/OFF */
> +
> +/* DSP_CTRL3 */
> +#define UV_MASK         0x80	/* UV output sequence option */
> +#define UV_ON           0x80	/*   ON */
> +#define UV_OFF          0x00	/*   OFF */
> +#define CBAR_MASK       0x20	/* DSP Color bar mask */
> +#define CBAR_ON         0x20	/*   ON */
> +#define CBAR_OFF        0x00	/*   OFF */
> +
> +/* HSTART */
> +#define HST_VGA         0x23
> +#define HST_QVGA        0x3F
> +
> +/* HSIZE */
> +#define HSZ_VGA         0xA0
> +#define HSZ_QVGA        0x50
> +
> +/* VSTART */
> +#define VST_VGA         0x07
> +#define VST_QVGA        0x03
> +
> +/* VSIZE */
> +#define VSZ_VGA         0xF0
> +#define VSZ_QVGA        0x78
> +
> +/* HOUTSIZE */
> +#define HOSZ_VGA        0xA0
> +#define HOSZ_QVGA       0x50
> +
> +/* VOUTSIZE */
> +#define VOSZ_VGA        0xF0
> +#define VOSZ_QVGA       0x78
> +
> +/*
> + * bit configure (32 bit)
> + * this is used in struct ov772x_color_format :: option
> + */
> +#define OP_UV       0x00000001
> +#define OP_SWAP_RGB 0x00000002
> +
> +/*
> + * struct
> + */
> +struct regval_list {
> +	unsigned char reg_num;
> +	unsigned char value;
> +};
> +
> +struct ov772x_color_format {
> +	char                     *name;
> +	__u32                     fourcc;
> +	const struct regval_list *regs;
> +	unsigned int              option;
> +};
> +
> +struct ov772x_win_size {
> +	char                     *name;
> +	__u32                     width;
> +	__u32                     height;
> +	unsigned char             com7_bit;
> +	const struct regval_list *regs;
> +};
> +
> +struct ov772x_priv {
> +	struct ov772x_camera_info        *info;
> +	struct i2c_client                *client;
> +	struct soc_camera_device          icd;
> +	const struct ov772x_color_format *fmt;
> +	const struct ov772x_win_size     *win;
> +};
> +
> +#define ENDMARKER { 0xff, 0xff }
> +
> +static const struct regval_list ov772x_default_regs[] =
> +{
> +	{ COM3,  0x00 },
> +	{ COM4,  PLL_4x | 0x01 },
> +	{ 0x16,  0x00 }, /* Mystery */
> +	{ COM11, 0x10 }, /* Mystery */
> +	{ 0x28,  0x00 }, /* Mystery */
> +	{ HREF,  0x00 },
> +	{ COM13, 0xe2 }, /* Mystery */
> +	{ AREF0, 0xef },
> +	{ AREF2, 0x60 },
> +	{ AREF6, 0x7a },
> +	ENDMARKER,
> +};
> +
> +/*
> + * register setting for color format
> + */
> +static const struct regval_list ov772x_RGB555_regs[] = {
> +	{ COM7, FMT_RGB555 | OFMT_RGB },
> +	ENDMARKER,
> +};
> +
> +static const struct regval_list ov772x_RGB565_regs[] = {
> +	{ COM7, FMT_RGB565 | OFMT_RGB },
> +	ENDMARKER,
> +};
> +
> +static const struct regval_list ov772x_YYUV_regs[] = {
> +	{ COM3, SWAP_YUV },
> +	{ COM7, OFMT_YUV },
> +	ENDMARKER,
> +};
> +
> +static const struct regval_list ov772x_UVYY_regs[] = {
> +	{ COM7, OFMT_YUV },
> +	ENDMARKER,
> +};
> +
> +
> +/*
> + * register setting for window size
> + */
> +static const struct regval_list ov772x_qvga_regs[] = {
> +	{ HSTART,   HST_QVGA },
> +	{ HSIZE,    HSZ_QVGA },
> +	{ VSTART,   VST_QVGA },
> +	{ VSIZE,    VSZ_QVGA  },
> +	{ HOUTSIZE, HOSZ_QVGA },
> +	{ VOUTSIZE, VOSZ_QVGA },
> +	ENDMARKER,
> +};
> +
> +static const struct regval_list ov772x_vga_regs[] = {
> +	{ HSTART,   HST_VGA },
> +	{ HSIZE,    HSZ_VGA },
> +	{ VSTART,   VST_VGA },
> +	{ VSIZE,    VSZ_VGA },
> +	{ HOUTSIZE, HOSZ_VGA },
> +	{ VOUTSIZE, VOSZ_VGA },
> +	ENDMARKER,
> +};
> +
> +/*
> + * supported format list
> + */
> +
> +#define SETFOURCC(type) .name = (#type), .fourcc = (V4L2_PIX_FMT_ ## type)
> +static const struct soc_camera_data_format ov772x_fmt_lists[] = {
> +	{
> +		SETFOURCC(YUYV),
> +		.depth      = 16,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +	},
> +	{
> +		SETFOURCC(YVYU),
> +		.depth      = 16,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +	},
> +	{
> +		SETFOURCC(UYVY),
> +		.depth      = 16,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +	},
> +	{
> +		SETFOURCC(RGB555),
> +		.depth      = 16,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +	},
> +	{
> +		SETFOURCC(RGB555X),
> +		.depth      = 16,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +	},
> +	{
> +		SETFOURCC(RGB565),
> +		.depth      = 16,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +	},
> +	{
> +		SETFOURCC(RGB565X),
> +		.depth      = 16,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +	},
> +};
> +
> +/*
> + * color format list
> + */
> +#define T_YUYV 0
> +static const struct ov772x_color_format ov772x_cfmts[] = {
> +	[T_YUYV] = {
> +		SETFOURCC(YUYV),
> +		.regs   = ov772x_YYUV_regs,
> +	},
> +	{
> +		SETFOURCC(YVYU),
> +		.regs   = ov772x_YYUV_regs,
> +		.option = OP_UV,
> +	},
> +	{
> +		SETFOURCC(UYVY),
> +		.regs   = ov772x_UVYY_regs,
> +	},
> +	{
> +		SETFOURCC(RGB555),
> +		.regs   = ov772x_RGB555_regs,
> +		.option = OP_SWAP_RGB,
> +	},
> +	{
> +		SETFOURCC(RGB555X),
> +		.regs   = ov772x_RGB555_regs,
> +	},
> +	{
> +		SETFOURCC(RGB565),
> +		.regs   = ov772x_RGB565_regs,
> +		.option = OP_SWAP_RGB,
> +	},
> +	{
> +		SETFOURCC(RGB565X),
> +		.regs   = ov772x_RGB565_regs,
> +	},
> +};
> +
> +
> +/*
> + * window size list
> + */
> +#define VGA_WIDTH   640
> +#define VGA_HEIGHT  480
> +#define QVGA_WIDTH  320
> +#define QVGA_HEIGHT 240
> +#define MAX_WIDTH   VGA_WIDTH
> +#define MAX_HEIGHT  VGA_HEIGHT
> +
> +static const struct ov772x_win_size ov772x_win_vga = {
> +	.name     = "VGA",
> +	.width    = VGA_WIDTH,
> +	.height   = VGA_HEIGHT,
> +	.com7_bit = SLCT_VGA,
> +	.regs     = ov772x_vga_regs,
> +};
> +
> +static const struct ov772x_win_size ov772x_win_qvga = {
> +	.name     = "QVGA",
> +	.width    = QVGA_WIDTH,
> +	.height   = QVGA_HEIGHT,
> +	.com7_bit = SLCT_QVGA,
> +	.regs     = ov772x_qvga_regs,
> +};
> +
> +
> +/*
> + * general function
> + */
> +
> +static int ov772x_write_array(struct i2c_client        *client,
> +			      const struct regval_list *vals)
> +{
> +	while (vals->reg_num != 0xff) {
> +		int ret = i2c_smbus_write_byte_data(client,
> +						    vals->reg_num,
> +						    vals->value);
> +		if (ret < 0)
> +			return ret;
> +		vals++;
> +	}
> +	return 0;
> +}
> +
> +static int ov772x_mask_set(struct i2c_client *client,
> +					  u8  command,
> +					  u8  mask,
> +					  u8  set)
> +{
> +	s32 val = i2c_smbus_read_byte_data(client, command);
> +	val &= ~mask;
> +	val |=  set;
> +
> +	return i2c_smbus_write_byte_data(client, command, val);
> +}
> +
> +static int ov772x_reset(struct i2c_client *client)
> +{
> +	int ret = i2c_smbus_write_byte_data(client, COM7, SCCB_RESET);
> +	msleep(1);
> +	return ret;
> +}
> +
> +/*
> + * soc_camera_ops function
> + */
> +
> +static int ov772x_init(struct soc_camera_device *icd)
> +{
> +	return 0;
> +}
> +
> +static int ov772x_release(struct soc_camera_device *icd)
> +{
> +	return 0;
> +}
> +
> +static int ov772x_start_capture(struct soc_camera_device *icd)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	int                 ret;
> +
> +
> +	if (!priv->win)
> +		priv->win = &ov772x_win_vga;
> +	if (!priv->fmt)
> +		priv->fmt = &ov772x_cfmts[T_YUYV];
> +
> +	/*
> +	 * reset hardware
> +	 */
> +	ov772x_reset(priv->client);
> +	ret = ov772x_write_array(priv->client, ov772x_default_regs);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set color format
> +	 */
> +	ret = ov772x_write_array(priv->client, priv->fmt->regs);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set size format
> +	 */
> +	ret = ov772x_write_array(priv->client, priv->win->regs);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set COM7 bit ( QVGA or VGA )
> +	 */
> +	ret = ov772x_mask_set(priv->client,
> +			      COM7, SLCT_MASK, priv->win->com7_bit);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set UV setting
> +	 */
> +	if (priv->fmt->option & OP_UV) {
> +		ret = ov772x_mask_set(priv->client,
> +				      DSP_CTRL3, UV_MASK, UV_ON);
> +		if (ret < 0)
> +			goto start_end;
> +	}
> +
> +	/*
> +	 * set SWAP setting
> +	 */
> +	if (priv->fmt->option & OP_SWAP_RGB) {
> +		ret = ov772x_mask_set(priv->client,
> +				      COM3, SWAP_MASK, SWAP_RGB);
> +		if (ret < 0)
> +			goto start_end;
> +	}
> +
> +	dev_info(&icd->dev,
> +		 "format %s, win %s\n", priv->fmt->name, priv->win->name);
> +
> +start_end:
> +	priv->fmt = NULL;
> +	priv->win = NULL;
> +
> +	return ret;
> +}
> +
> +static int ov772x_stop_capture(struct soc_camera_device *icd)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	ov772x_reset(priv->client);
> +	return 0;
> +}
> +
> +static int ov772x_set_bus_param(struct soc_camera_device *icd,
> +				unsigned long		  flags)
> +{
> +	return 0;
> +}
> +
> +static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +
> +	return  SOCAM_PCLK_SAMPLE_RISING |
> +		SOCAM_HSYNC_ACTIVE_HIGH  |
> +		SOCAM_VSYNC_ACTIVE_HIGH  |
> +		SOCAM_MASTER             |
> +		priv->info->buswidth;
> +}
> +
> +static int ov772x_get_chip_id(struct soc_camera_device *icd,
> +			      struct v4l2_chip_ident   *id)
> +{
> +	id->ident    = V4L2_IDENT_OV772X;
> +	id->revision = 0;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int ov772x_get_register(struct soc_camera_device *icd,
> +			       struct v4l2_register *reg)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	int                 ret;
> +
> +	if (reg->reg > 0xff)
> +		return -EINVAL;
> +
> +	ret = i2c_smbus_read_byte_data(priv->client, reg->reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	reg->val = (__u64)ret;
> +
> +	return 0;
> +}
> +
> +static int ov772x_set_register(struct soc_camera_device *icd,
> +			       struct v4l2_register *reg)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +
> +	if (reg->reg > 0xff ||
> +	    reg->val > 0xff)
> +		return -EINVAL;
> +
> +	return i2c_smbus_write_byte_data(priv->client, reg->reg, reg->val);
> +}
> +#endif
> +
> +static int ov772x_set_fmt_cap(struct soc_camera_device *icd,
> +			      __u32                     pixfmt,
> +			      struct v4l2_rect         *rect)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	int ret = -EINVAL;
> +	int i;
> +
> +	/*
> +	 * select format
> +	 */
> +	priv->fmt = NULL;
> +	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
> +		if (pixfmt == ov772x_cfmts[i].fourcc) {
> +			priv->fmt = ov772x_cfmts + i;
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int ov772x_try_fmt_cap(struct soc_camera_device *icd,
> +			      struct v4l2_format       *f)
> +{
> +	struct v4l2_pix_format *pix  = &f->fmt.pix;
> +	struct ov772x_priv     *priv;
> +
> +	priv = container_of(icd, struct ov772x_priv, icd);
> +
> +	/* QVGA */
> +	if (pix->width  <= ov772x_win_qvga.width ||
> +	    pix->height <= ov772x_win_qvga.height) {
> +		priv->win   = &ov772x_win_qvga;
> +		pix->width  =  ov772x_win_qvga.width;
> +		pix->height =  ov772x_win_qvga.height;
> +	}
> +
> +	/* VGA */
> +	else if (pix->width  <= ov772x_win_vga.width ||
> +		 pix->height <= ov772x_win_vga.height) {
> +		priv->win   = &ov772x_win_vga;
> +		pix->width  =  ov772x_win_vga.width;
> +		pix->height =  ov772x_win_vga.height;
> +	}
> +
> +	pix->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int ov772x_video_probe(struct soc_camera_device *icd)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	u8                  pid, ver;
> +
> +	/*
> +	 * We must have a parent by now. And it cannot be a wrong one.
> +	 * So this entire test is completely redundant.
> +	 */
> +	if (!icd->dev.parent ||
> +	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
> +		return -ENODEV;
> +
> +	/*
> +	 * ov772x only use 8 or 10 bit bus width
> +	 */
> +	if (SOCAM_DATAWIDTH_10 != priv->info->buswidth &&
> +	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
> +		dev_err(&icd->dev, "bus width error\n");
> +		return -ENODEV;
> +	}
> +
> +	icd->formats     = ov772x_fmt_lists;
> +	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
> +
> +	if (priv->info->link.power)
> +		priv->info->link.power(&priv->client->dev, 1);
> +
> +	/*
> +	 * check and show product ID and manufacturer ID
> +	 */
> +	pid = i2c_smbus_read_byte_data(priv->client, PID);
> +	ver = i2c_smbus_read_byte_data(priv->client, VER);
> +	if (pid != 0x77 ||
> +	    ver != 0x21) {
> +		if (priv->info->link.power)
> +			priv->info->link.power(&priv->client->dev, 0);
> +		return -ENODEV;
> +	}
> +
> +	dev_info(&icd->dev,
> +		 "ov772x Product ID %0x:%0x Manufacturer ID %x:%x\n",
> +		 pid,
> +		 ver,
> +		 i2c_smbus_read_byte_data(priv->client, MIDH),
> +		 i2c_smbus_read_byte_data(priv->client, MIDL));
> +
> +
> +	return soc_camera_video_start(icd);
> +}
> +
> +static void ov772x_video_remove(struct soc_camera_device *icd)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +
> +	soc_camera_video_stop(icd);
> +
> +	if (priv->info->link.power)
> +		priv->info->link.power(&priv->client->dev, 0);
> +
> +}
> +
> +static struct soc_camera_ops ov772x_ops = {
> +	.owner			= THIS_MODULE,
> +	.probe			= ov772x_video_probe,
> +	.remove			= ov772x_video_remove,
> +	.init			= ov772x_init,
> +	.release		= ov772x_release,
> +	.start_capture		= ov772x_start_capture,
> +	.stop_capture		= ov772x_stop_capture,
> +	.set_fmt_cap		= ov772x_set_fmt_cap,
> +	.try_fmt_cap		= ov772x_try_fmt_cap,
> +	.set_bus_param		= ov772x_set_bus_param,
> +	.query_bus_param	= ov772x_query_bus_param,
> +	.get_chip_id		= ov772x_get_chip_id,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.get_register		= ov772x_get_register,
> +	.set_register		= ov772x_set_register,
> +#endif
> +};
> +
> +/*
> + * i2c_driver function
> + */
> +
> +static int ov772x_probe(struct i2c_client          *client,
> +			const struct i2c_device_id *did)
> +
> +{
> +	struct ov772x_priv        *priv;
> +	struct ov772x_camera_info *info;
> +	struct soc_camera_device  *icd;
> +	struct i2c_adapter        *adapter = to_i2c_adapter(client->dev.parent);
> +	int                        ret;
> +
> +	info = client->dev.platform_data;
> +	if (!info)
> +		return -EINVAL;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_err(&adapter->dev,
> +			"I2C-Adapter doesn't support "
> +			"I2C_FUNC_SMBUS_BYTE_DATA\n");
> +		return -EIO;
> +	}
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->info   = info;
> +	priv->client = client;
> +	i2c_set_clientdata(client, priv);
> +
> +	icd             = &priv->icd;
> +	icd->ops        = &ov772x_ops;
> +	icd->control    = &client->dev;
> +	icd->width_max  = MAX_WIDTH;
> +	icd->height_max = MAX_HEIGHT;
> +	icd->iface      = priv->info->link.bus_id;
> +
> +	ret = soc_camera_device_register(icd);
> +
> +	if (ret)
> +		kfree(priv);
> +
> +	return ret;
> +}
> +
> +static int ov772x_remove(struct i2c_client *client)
> +{
> +	struct ov772x_priv *priv = i2c_get_clientdata(client);
> +
> +	soc_camera_device_unregister(&priv->icd);
> +	kfree(priv);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov772x_id[] = {
> +	{"ov772x", 0},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ov772x_id);
> +
> +
> +static struct i2c_driver ov772x_i2c_driver = {
> +	.driver = {
> +		.name = "ov772x",
> +	},
> +	.probe    = ov772x_probe,
> +	.remove   = ov772x_remove,
> +	.id_table = ov772x_id,
> +};
> +
> +/*
> + * module function
> + */
> +
> +static int __init ov772x_module_init(void)
> +{
> +	printk(KERN_INFO "ov772x driver\n");
> +	return i2c_add_driver(&ov772x_i2c_driver);
> +}
> +
> +static void __exit ov772x_module_exit(void)
> +{
> +	i2c_del_driver(&ov772x_i2c_driver);
> +}
> +
> +module_init(ov772x_module_init);
> +module_exit(ov772x_module_exit);
> +
> +MODULE_DESCRIPTION("SoC Camera driver for ov772x");
> +MODULE_AUTHOR("Kuninori Morimoto");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/ov772x.h b/include/media/ov772x.h
> new file mode 100644
> index 0000000..e391d55
> --- /dev/null
> +++ b/include/media/ov772x.h
> @@ -0,0 +1,21 @@
> +/* ov772x Camera
> + *
> + * Copyright (C) 2008 Renesas Solutions Corp.
> + * Kuninori Morimoto <morimoto.kuninori@renesas.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __OV772X_H__
> +#define __OV772X_H__
> +
> +#include <media/soc_camera.h>
> +
> +struct ov772x_camera_info {
> +	unsigned long          buswidth;
> +	struct soc_camera_link link;
> +};
> +
> +#endif /* __OV772X_H__ */
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index d73a8e9..bfe5142 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -60,6 +60,7 @@ enum {
>  
>  	/* OmniVision sensors: reserved range 250-299 */
>  	V4L2_IDENT_OV7670 = 250,
> +	V4L2_IDENT_OV772X = 251,
>  
>  	/* Conexant MPEG encoder/decoders: reserved range 410-420 */
>  	V4L2_IDENT_CX23415 = 415,
> -- 
> 1.5.4.3
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
