Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:17191 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbcGSM2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 08:28:36 -0400
Subject: Re: [PATCH] v4l: platform: Add Renesas R-Car FDP1 Driver
To: Kieran Bingham <kieran@ksquared.org.uk>, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
References: <1467294083-1811-1-git-send-email-kieran@bingham.xyz>
 <1467294083-1811-2-git-send-email-kieran@bingham.xyz>
Cc: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <578E1CEC.1060002@cisco.com>
Date: Tue, 19 Jul 2016 14:28:28 +0200
MIME-Version: 1.0
In-Reply-To: <1467294083-1811-2-git-send-email-kieran@bingham.xyz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Hmm, I don't think I ever reviewed this one.

So here is my quick review:

General note: I need to see the v4l2-compliance output. Make sure you run
with the latest version from v4l-utils.

On 06/30/16 15:41, Kieran Bingham wrote:
> The FDP1 driver performs advanced de-interlacing on a memory 2 memory
> based video stream, and supports conversion from YCbCr/YUV
> to RGB pixel formats
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
>  MAINTAINERS                        |    9 +
>  drivers/media/platform/Kconfig     |   13 +
>  drivers/media/platform/Makefile    |    1 +
>  drivers/media/platform/rcar_fdp1.c | 2395 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 2418 insertions(+)
>  create mode 100644 drivers/media/platform/rcar_fdp1.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index eb5e3b673c1d..985d243ff066 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7331,6 +7331,15 @@ F:	Documentation/devicetree/bindings/media/renesas,fcp.txt
>  F:	drivers/media/platform/rcar-fcp.c
>  F:	include/media/rcar-fcp.h
>  
> +MEDIA DRIVERS FOR RENESAS - FDP1
> +M:	Kieran Bingham <kieran@bingham.xyz>
> +L:	linux-media@vger.kernel.org
> +L:	linux-renesas-soc@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Supported
> +F:	Documentation/devicetree/bindings/media/renesas,fdp1.txt
> +F:	drivers/media/platform/rcar_fdp1.c
> +
>  MEDIA DRIVERS FOR RENESAS - VSP1
>  M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 0141af8cfdbc..80cdc3b6efa3 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -235,6 +235,19 @@ config VIDEO_SH_VEU
>  	    Support for the Video Engine Unit (VEU) on SuperH and
>  	    SH-Mobile SoCs.
>  
> +config VIDEO_RENESAS_FDP1
> +	tristate "Renesas Fine Display Processor"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> +	depends on ARCH_SHMOBILE || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	---help---
> +	  This is a V4L2 driver for the Renesas Fine Display Processor
> +	  providing colour space conversion, and de-interlacing features.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called rcar_fdp1.
> +
>  config VIDEO_RENESAS_JPU
>  	tristate "Renesas JPEG Processing Unit"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index befc4f97057c..0c8a3ae7b6cb 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -47,6 +47,7 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
>  obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
>  
>  obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
> +obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
>  obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
> new file mode 100644
> index 000000000000..c7280183262a
> --- /dev/null
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -0,0 +1,2395 @@
> +/*
> + * Renesas RCar Fine Display Processor
> + *
> + * Video format converter and frame deinterlacer device.
> + *
> + * Author: Kieran Bingham, <kieran@bingham.xyz>
> + * Copyright (c) 2016 Renesas Electronics Corporation.
> + *
> + * This code is developed and inspired from the vim2m, rcar_jpu,
> + * m2m-deinterlace, and vsp1 drivers.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/timer.h>
> +#include <media/rcar-fcp.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +static unsigned int debug;
> +module_param(debug, uint, 0644);
> +MODULE_PARM_DESC(debug, "activate debug info");
> +
> +/* Min Width/Height/Height-Field */
> +#define FDP1_MIN_W		80U
> +#define FDP1_MIN_H		80U
> +
> +#define FDP1_MAX_W		3840U
> +#define FDP1_MAX_H		2160U
> +
> +#define FDP1_MAX_PLANES		3U
> +
> +/* Flags that indicate a format can be used for capture/output */
> +#define FDP1_CAPTURE		BIT(0)
> +#define FDP1_OUTPUT		BIT(1)
> +
> +#define DRIVER_NAME		"rcar_fdp1"
> +
> +/* Number of Job's to have available on the processing queue */
> +#define FDP1_NUMBER_JOBS 8
> +#define FDP1_NUMBER_BUFFERS ((FDP1_NUMBER_JOBS*2)+1)
> +
> +#define dprintk(fdp1, fmt, arg...) \
> +	v4l2_dbg(1, debug, &fdp1->v4l2_dev, "%s: " fmt, __func__, ## arg)
> +
> +/*
> + * FDP1 registers and bits
> + */
> +
> +/* FDP1 start register - Imm */
> +#define FD1_CTL_CMD			0x0000
> +#define FD1_CTL_CMD_STRCMD		BIT(0)
> +
> +/* Sync generator register - Imm */
> +#define FD1_CTL_SGCMD			0x0004
> +#define FD1_CTL_SGCMD_SGEN		BIT(0)
> +
> +/* Register set end register - Imm */
> +#define FD1_CTL_REGEND			0x0008
> +#define FD1_CTL_REGEND_REGEND		BIT(0)
> +
> +/* Channel activation register - Vupdt */
> +#define FD1_CTL_CHACT			0x000c
> +#define FD1_CTL_CHACT_SMW		BIT(9)
> +#define FD1_CTL_CHACT_WR		BIT(8)
> +#define FD1_CTL_CHACT_SMR		BIT(3)
> +#define FD1_CTL_CHACT_RD2		BIT(2)
> +#define FD1_CTL_CHACT_RD1		BIT(1)
> +#define FD1_CTL_CHACT_RD0		BIT(0)
> +
> +/* Operation Mode Register - Vupdt */
> +#define FD1_CTL_OPMODE			0x0010
> +#define FD1_CTL_OPMODE_PRG		BIT(4)
> +#define FD1_CTL_OPMODE_VIMD_INTERRUPT	(0 << 0)
> +#define FD1_CTL_OPMODE_VIMD_BESTEFFORT	(1 << 0)
> +#define FD1_CTL_OPMODE_VIMD_NOINTERRUPT	(2 << 0)
> +
> +#define FD1_CTL_VPERIOD			0x0014
> +#define FD1_CTL_CLKCTRL			0x0018
> +#define FD1_CTL_CLKCTRL_CSTP_N		BIT(0)
> +
> +/* Software reset register */
> +#define FD1_CTL_SRESET			0x001c
> +#define FD1_CTL_SRESET_SRST		BIT(0)
> +
> +/* Control status register (V-update-status) */
> +#define FD1_CTL_STATUS			0x0024
> +#define FD1_CTL_STATUS_VINT_CNT_MASK	GENMASK(31, 16)
> +#define FD1_CTL_STATUS_VINT_CNT_SHIFT	16
> +#define FD1_CTL_STATUS_SGREGSET		BIT(10)
> +#define FD1_CTL_STATUS_SGVERR		BIT(9)
> +#define FD1_CTL_STATUS_SGFREND		BIT(8)
> +#define FD1_CTL_STATUS_BSY		BIT(0)
> +
> +#define FD1_CTL_VCYCLE_STAT		0x0028
> +
> +/* Interrupt enable register */
> +#define FD1_CTL_IRQENB			0x0038
> +/* Interrupt status register */
> +#define FD1_CTL_IRQSTA			0x003c
> +/* Interrupt control register */
> +#define FD1_CTL_IRQFSET			0x0040
> +
> +/* Common IRQ Bit settings */
> +#define FD1_CTL_IRQ_VERE		BIT(16)
> +#define FD1_CTL_IRQ_VINTE		BIT(4)
> +#define FD1_CTL_IRQ_FREE		BIT(0)
> +#define FD1_CTL_IRQ_MASK		(FD1_CTL_IRQ_VERE | \
> +					 FD1_CTL_IRQ_VINTE | \
> +					 FD1_CTL_IRQ_FREE)
> +
> +/* RPF */
> +#define FD1_RPF_SIZE			0x0060
> +#define FD1_RPF_SIZE_MASK		GENMASK(12, 0)
> +#define FD1_RPF_SIZE_H_SHIFT		16
> +#define FD1_RPF_SIZE_V_SHIFT		0
> +
> +#define FD1_RPF_FORMAT			0x0064
> +#define FD1_RPF_FORMAT_CIPM		BIT(16)
> +#define FD1_RPF_FORMAT_RSPYCS		BIT(13)
> +#define FD1_RPF_FORMAT_RSPUVS		BIT(12)
> +#define FD1_RPF_FORMAT_CF		BIT(8)
> +
> +#define FD1_RPF_PSTRIDE			0x0068
> +#define FD1_RPF_PSTRIDE_Y_SHIFT		16
> +#define FD1_RPF_PSTRIDE_C_SHIFT		0
> +
> +/* RPF0 Source Component Y Address register */
> +#define FD1_RPF0_ADDR_Y			0x006c
> +
> +/* RPF1 Current Picture Registers */
> +#define FD1_RPF1_ADDR_Y			0x0078
> +#define FD1_RPF1_ADDR_C0		0x007c
> +#define FD1_RPF1_ADDR_C1		0x0080
> +
> +/* RPF2 next picture register */
> +#define FD1_RPF2_ADDR_Y			0x0084
> +
> +#define FD1_RPF_SMSK_ADDR		0x0090
> +#define FD1_RPF_SWAP			0x0094
> +
> +/* WPF */
> +#define FD1_WPF_FORMAT			0x00c0
> +#define FD1_WPF_FORMAT_PDV_SHIFT	24
> +#define FD1_WPF_FORMAT_FCNL		BIT(20)
> +#define FD1_WPF_FORMAT_WSPYCS		BIT(15)
> +#define FD1_WPF_FORMAT_WSPUVS		BIT(14)
> +#define FD1_WPF_FORMAT_WRTM_601_16	(0 << 9)
> +#define FD1_WPF_FORMAT_WRTM_601_0	(1 << 9)
> +#define FD1_WPF_FORMAT_WRTM_709_16	(2 << 9)
> +#define FD1_WPF_FORMAT_CSC		BIT(8)
> +
> +#define FD1_WPF_RNDCTL			0x00c4
> +#define FD1_WPF_RNDCTL_CBRM		BIT(28)
> +#define FD1_WPF_RNDCTL_CLMD_NOCLIP	(0 << 12)
> +#define FD1_WPF_RNDCTL_CLMD_CLIP_16_235	(1 << 12)
> +#define FD1_WPF_RNDCTL_CLMD_CLIP_1_254	(2 << 12)
> +
> +#define FD1_WPF_PSTRIDE			0x00c8
> +#define FD1_WPF_PSTRIDE_Y_SHIFT		16
> +#define FD1_WPF_PSTRIDE_C_SHIFT		0
> +
> +/* WPF Destination picture */
> +#define FD1_WPF_ADDR_Y			0x00cc
> +#define FD1_WPF_ADDR_C0			0x00d0
> +#define FD1_WPF_ADDR_C1			0x00d4
> +#define FD1_WPF_SWAP			0x00d8
> +#define FD1_WPF_SWAP_OSWAP_SHIFT	0
> +#define FD1_WPF_SWAP_SSWAP_SHIFT	4
> +
> +/* WPF/RPF Common */
> +#define FD1_RWPF_SWAP_BYTE		BIT(0)
> +#define FD1_RWPF_SWAP_WORD		BIT(1)
> +#define FD1_RWPF_SWAP_LWRD		BIT(2)
> +#define FD1_RWPF_SWAP_LLWD		BIT(3)
> +
> +/* IPC */
> +#define FD1_IPC_MODE			0x0100
> +#define FD1_IPC_MODE_DLI		BIT(8)
> +#define FD1_IPC_MODE_DIM_ADAPT2D3D	(0 << 0)
> +#define FD1_IPC_MODE_DIM_FIXED2D	(1 << 0)
> +#define FD1_IPC_MODE_DIM_FIXED3D	(2 << 0)
> +#define FD1_IPC_MODE_DIM_PREVFIELD	(3 << 0)
> +#define FD1_IPC_MODE_DIM_NEXTFIELD	(4 << 0)
> +
> +#define FD1_IPC_SMSK_THRESH		0x0104
> +#define FD1_IPC_SMSK_THRESH_CONST	0x00010002
> +
> +#define FD1_IPC_COMB_DET		0x0108
> +#define FD1_IPC_COMB_DET_CONST		0x00200040
> +
> +#define FD1_IPC_MOTDEC			0x010c
> +#define FD1_IPC_MOTDEC_CONST		0x00008020
> +
> +/* DLI registers */
> +#define FD1_IPC_DLI_BLEND		0x0120
> +#define FD1_IPC_DLI_BLEND_CONST		0x0080ff02
> +
> +#define FD1_IPC_DLI_HGAIN		0x0124
> +#define FD1_IPC_DLI_HGAIN_CONST		0x001000ff
> +
> +#define FD1_IPC_DLI_SPRS		0x0128
> +#define FD1_IPC_DLI_SPRS_CONST		0x009004ff
> +
> +#define FD1_IPC_DLI_ANGLE		0x012c
> +#define FD1_IPC_DLI_ANGLE_CONST		0x0004080c
> +
> +#define FD1_IPC_DLI_ISOPIX0		0x0130
> +#define FD1_IPC_DLI_ISOPIX0_CONST	0xff10ff10
> +
> +#define FD1_IPC_DLI_ISOPIX1		0x0134
> +#define FD1_IPC_DLI_ISOPIX1_CONST	0x0000ff10
> +
> +/* Sensor registers */
> +#define FD1_IPC_SENSOR_TH0		0x0140
> +#define FD1_IPC_SENSOR_TH0_CONST	0x20208080
> +
> +#define FD1_IPC_SENSOR_TH1		0x0144
> +#define FD1_IPC_SENSOR_TH1_CONST	0
> +
> +#define FD1_IPC_SENSOR_CTL0		0x0170
> +#define FD1_IPC_SENSOR_CTL0_CONST	0x00002201
> +
> +#define FD1_IPC_SENSOR_CTL1		0x0174
> +#define FD1_IPC_SENSOR_CTL1_CONST	0
> +
> +#define FD1_IPC_SENSOR_CTL2		0x0178
> +#define FD1_IPC_SENSOR_CTL2_X_SHIFT	16
> +#define FD1_IPC_SENSOR_CTL2_Y_SHIFT	0
> +
> +#define FD1_IPC_SENSOR_CTL3		0x017c
> +#define FD1_IPC_SENSOR_CTL3_0_SHIFT	16
> +#define FD1_IPC_SENSOR_CTL3_1_SHIFT	0
> +
> +/* Line memory pixel number register */
> +#define FD1_IPC_LMEM			0x01e0
> +#define FD1_IPC_LMEM_LINEAR		1024
> +#define FD1_IPC_LMEM_TILE		960
> +
> +/* Internal Data (HW Version) */
> +#define FD1_IP_INTDATA			0x0800
> +#define FD1_IP_H3			0x02010101
> +#define FD1_IP_M3W			0x02010202
> +
> +/* LUTs */
> +#define FD1_LUT_DIF_ADJ			0x1000
> +#define FD1_LUT_SAD_ADJ			0x1400
> +#define FD1_LUT_BLD_GAIN		0x1800
> +#define FD1_LUT_DIF_GAIN		0x1c00
> +#define FD1_LUT_MDET			0x2000
> +
> +/**
> + * struct fdp1_fmt - The FDP1 internal format data
> + * @fourcc: the fourcc code, to match the V4L2 API
> + * @bpp: bits per pixel per plane
> + * @num_planes: number of planes
> + * @hsub: horizontal subsampling factor
> + * @vsub: vertical subsampling factor
> + * @fmt: 7-bit format code for the fdp1 hardware
> + * @swap_yc: the Y and C components are swapped (Y comes before C)
> + * @swap_uv: the U and V components are swapped (V comes before U)
> + * @swap: swap register control
> + * @types: types of queue this format is applicable to
> + */
> +struct fdp1_fmt {
> +	u32	fourcc;
> +	u8	bpp[3];
> +	u8	num_planes;
> +	u8	hsub;
> +	u8	vsub;
> +	u8	fmt;
> +	bool	swap_yc;
> +	bool	swap_uv;
> +	u8	swap;
> +	u8	types;
> +};
> +
> +static const struct fdp1_fmt fdp1_formats[] = {
> +	/* RGB formats are only supported by the Write Pixel Formatter */
> +
> +	{ V4L2_PIX_FMT_RGB332, { 8, 0, 0}, 1, 1, 1, 0x00, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_XRGB444, { 16, 0, 0}, 1, 1, 1, 0x01, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_XRGB555, { 16, 0, 0}, 1, 1, 1, 0x04, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_RGB565, { 16, 0, 0}, 1, 1, 1, 0x06, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_ABGR32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_XBGR32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_ARGB32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_XRGB32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_RGB24, { 24, 0, 0}, 1, 1, 1, 0x15, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_BGR24, { 24, 0, 0}, 1, 1, 1, 0x18, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_ARGB444, { 16, 0, 0}, 1, 1, 1, 0x19, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD,
> +	  FDP1_CAPTURE },
> +	{ V4L2_PIX_FMT_ARGB555, { 16, 0, 0}, 1, 1, 1, 0x1b, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD,
> +	  FDP1_CAPTURE },
> +
> +	/* YUV Formats are supported by Read and Write Pixel Formatters */
> +
> +	{ V4L2_PIX_FMT_NV16M, { 8, 16, 0}, 2, 2, 1, 0x41, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_NV61M, { 8, 16, 0}, 2, 2, 1, 0x41, false, true,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_NV12M, { 8, 16, 0}, 2, 2, 2, 0x42, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_NV21M, { 8, 16, 0}, 2, 2, 2, 0x42, false, true,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_UYVY, { 16, 0, 0}, 1, 2, 1, 0x47, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_VYUY, { 16, 0, 0}, 1, 2, 1, 0x47, false, true,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YUYV, { 16, 0, 0}, 1, 2, 1, 0x47, true, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YVYU, { 16, 0, 0}, 1, 2, 1, 0x47, true, true,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YUV444M, { 8, 8, 8}, 3, 1, 1, 0x4a, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YVU444M, { 8, 8, 8}, 3, 1, 1, 0x4a, false, true,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YUV422M, { 8, 8, 8}, 3, 2, 1, 0x4b, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YVU422M, { 8, 8, 8}, 3, 2, 1, 0x4b, false, true,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YUV420M, { 8, 8, 8}, 3, 2, 2, 0x4c, false, false,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +	{ V4L2_PIX_FMT_YVU420M, { 8, 8, 8}, 3, 2, 2, 0x4c, false, true,
> +	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
> +	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
> +	  FDP1_CAPTURE | FDP1_OUTPUT },
> +};
> +
> +static int fdp1_fmt_is_rgb(const struct fdp1_fmt *fmt)
> +{
> +	return fmt->fmt <= 0x1b; /* Last RGB code */
> +}
> +
> +/*
> + * FDP1 Lookup tables range from 0...255 only
> + *
> + * Each table must be less than 256 entries, and all tables
> + * are padded out to 256 entries by duplicating the last value.
> + */
> +static u8 fdp1_diff_adj[] = {

Add const for these tables?

> +	0x00, 0x24, 0x43, 0x5e, 0x76, 0x8c, 0x9e, 0xaf,
> +	0xbd, 0xc9, 0xd4, 0xdd, 0xe4, 0xea, 0xef, 0xf3,
> +	0xf6, 0xf9, 0xfb, 0xfc, 0xfd, 0xfe, 0xfe, 0xff,
> +};
> +
> +static u8 fdp1_sad_adj[] = {
> +	0x00, 0x24, 0x43, 0x5e, 0x76, 0x8c, 0x9e, 0xaf,
> +	0xbd, 0xc9, 0xd4, 0xdd, 0xe4, 0xea, 0xef, 0xf3,
> +	0xf6, 0xf9, 0xfb, 0xfc, 0xfd, 0xfe, 0xfe, 0xff,
> +};
> +
> +static u8 fdp1_bld_gain[] = {
> +	0x80,
> +};
> +
> +static u8 fdp1_dif_gain[] = {
> +	0x80,
> +};
> +
> +static u8 fdp1_mdet[] = {
> +	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
> +	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
> +	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
> +	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
> +	0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
> +	0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
> +	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
> +	0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
> +	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
> +	0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f,
> +	0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57,
> +	0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f,
> +	0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
> +	0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f,
> +	0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77,
> +	0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f,
> +	0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> +	0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
> +	0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97,
> +	0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
> +	0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
> +	0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
> +	0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
> +	0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf,
> +	0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
> +	0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
> +	0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
> +	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf,
> +	0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,
> +	0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef,
> +	0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,
> +	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff
> +};
> +
> +/* Per-queue, driver-specific private data */
> +struct fdp1_q_data {
> +	const struct fdp1_fmt	*fmt;
> +	struct v4l2_pix_format_mplane format;
> +
> +	unsigned int		vsize;
> +	unsigned int		stride_y;
> +	unsigned int		stride_c;
> +};
> +
> +/* Custom controls */
> +#define V4L2_CID_DEINT_MODE		(V4L2_CID_USER_BASE + 0x1000)

You have to reserve a range for driver controls in v4l2-controls.h.
This to avoid getting duplicate control IDs.

If the intention is that apps can use this ID, then it needs to be part
of a public driver header as well.

Also clearly document the control, either in the source or in a .txt (or
now probably .rst) file.

Frankly, I wonder if this shouldn't be added as a standard control rather
than driver specific. It's a fairly common feature.

> +
> +static const struct fdp1_fmt *fdp1_find_format(u32 pixelformat)
> +{
> +	const struct fdp1_fmt *fmt;
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fdp1_formats); i++) {
> +		fmt = &fdp1_formats[i];
> +		if (fmt->fourcc == pixelformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +enum fdp1_deint_mode {
> +	FDP1_PROGRESSIVE = 0, /* Must be zero when !deinterlacing */
> +	FDP1_ADAPT2D3D,
> +	FDP1_FIXED2D,
> +	FDP1_FIXED3D,
> +	FDP1_PREVFIELD,
> +	FDP1_NEXTFIELD,
> +};
> +
> +#define FDP1_DEINT_MODE_USES_NEXT(mode) \
> +	(mode == FDP1_ADAPT2D3D || \
> +	 mode == FDP1_FIXED3D   || \
> +	 mode == FDP1_NEXTFIELD)
> +
> +#define FDP1_DEINT_MODE_USES_PREV(mode) \
> +	(mode == FDP1_ADAPT2D3D || \
> +	 mode == FDP1_FIXED3D   || \
> +	 mode == FDP1_PREVFIELD)
> +
> +/*
> + * fdp1_v4l2_buffer: Track v4l2_buffers with a reference count
> + *
> + * As buffers come in, they may be used for more than one field.
> + * It then becomes necessary to track the usage of these buffers,
> + * and only release when the last job has completed using this
> + * vb buffer.
> + */
> +struct fdp1_v4l2_buffer {
> +	struct vb2_v4l2_buffer	vb;
> +	struct list_head	list;
> +};
> +
> +/*
> + * FDP1 operates on potentially 3 fields, which are tracked
> + * from the VB buffers using this context structure.
> + * Will always be a field or a full frame, never two fields.
> + */
> +struct fdp1_buffer {
> +	struct vb2_v4l2_buffer	*vb;
> +	dma_addr_t		addrs[3];
> +
> +	/* Should be NONE:TOP:BOTTOM only */
> +	enum v4l2_field		field;
> +
> +	/* Flag to indicate this is the last field in the vb */
> +	bool			last_field;
> +
> +	/* Buffer queue lists */
> +	struct list_head	list;
> +};
> +
> +struct fdp1_job {
> +	/* These could be pointers to save 'memory' and copying */
> +	struct fdp1_buffer	*previous;
> +	struct fdp1_buffer	*active;
> +	struct fdp1_buffer	*next;
> +	struct fdp1_buffer	dst;
> +
> +	/* A job can only be on one list at a time */
> +	struct list_head	list;
> +};
> +
> +struct fdp1_dev {
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	vfd;
> +
> +	struct mutex		dev_mutex;
> +	spinlock_t		irqlock;
> +	spinlock_t		device_process_lock;
> +
> +	void __iomem		*regs;
> +	unsigned int		irq;
> +	struct device		*dev;
> +	void			*alloc_ctx;
> +
> +	/* Job Queues */
> +	struct fdp1_job		jobs[FDP1_NUMBER_JOBS];
> +	struct list_head	free_job_list;
> +	struct list_head	queued_job_list;
> +	struct list_head	hw_job_list;
> +
> +	unsigned int		clk_rate;
> +
> +	struct rcar_fcp_device	*fcp;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +};
> +
> +struct fdp1_ctx {
> +	struct v4l2_fh		fh;
> +	struct fdp1_dev		*fdp1;
> +
> +	struct v4l2_ctrl_handler hdl;
> +	unsigned int		sequence;
> +
> +	/* Processed buffers in this transaction */
> +	u8			num_processed;
> +
> +	/* Transaction length (i.e. how many buffers per transaction) */
> +	u32			translen;
> +
> +	/* Abort requested by m2m */
> +	int			aborting;
> +
> +	/* Deinterlace processing mode */
> +	enum fdp1_deint_mode	deint_mode;
> +
> +	/*
> +	 * Adaptive 2d 3d mode uses a shared mask
> +	 * This is allocated at streamon, if the ADAPT2D3D mode
> +	 * is requested
> +	 */
> +	unsigned int		smsk_size;
> +	dma_addr_t		smsk_addr[2];
> +	void			*smsk_cpu;
> +
> +	/* Capture pipeline, can specify an alpha value
> +	 * for supported formats. 0-255 only
> +	 */
> +	unsigned char		alpha;
> +
> +	/* Source and destination queue data */
> +	struct fdp1_q_data	out_q; /* HW Source */
> +	struct fdp1_q_data	cap_q; /* HW Destination */
> +
> +	/*
> +	 * Field Queues
> +	 * Interlaced fields fields are used on 3 occasions,
> +	 * and tracked in this list.
> +	 *
> +	 * V4L2 Buffers are tracked inside the fdp1_buffer
> +	 * and released when the last 'field' completes
> +	 */
> +	struct fdp1_buffer	buffers[FDP1_NUMBER_BUFFERS];
> +	struct list_head	free_buffers;
> +	struct list_head	fdp1_buffer_queue;
> +	unsigned int		buffers_queued;
> +
> +	/*
> +	 * For de-interlacing we need to track our previous buffer
> +	 * while preparing our job lists.
> +	 */
> +	struct fdp1_buffer	*previous;
> +};
> +
> +static inline struct fdp1_ctx *fh_to_ctx(struct v4l2_fh *fh)
> +{
> +	return container_of(fh, struct fdp1_ctx, fh);
> +}
> +
> +static struct fdp1_q_data *get_q_data(struct fdp1_ctx *ctx,
> +					 enum v4l2_buf_type type)
> +{
> +	if (V4L2_TYPE_IS_OUTPUT(type))
> +		return &ctx->out_q;
> +	else

'else' can be dropped. checkpatch should have complained about that AFAIK.

> +		return &ctx->cap_q;
> +}
> +
> +/*
> + * list_remove_job: Take the first item off the specified job list
> + *
> + * Returns: pointer to a job, or NULL if the list is empty.
> + */
> +static struct fdp1_job *list_remove_job(struct fdp1_dev *fdp1,
> +					 struct list_head *list)
> +{
> +	struct fdp1_job *job;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fdp1->irqlock, flags);
> +	job = list_first_entry_or_null(list, struct fdp1_job, list);
> +	if (job)
> +		list_del(&job->list);
> +	spin_unlock_irqrestore(&fdp1->irqlock, flags);
> +
> +	return job;
> +}
> +
> +/*
> + * list_add_job: Add a job to the specified job list
> + *
> + * Returns: void - always succeeds
> + */
> +static void list_add_job(struct fdp1_dev *fdp1,
> +			 struct list_head *list,
> +			 struct fdp1_job *job)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fdp1->irqlock, flags);
> +	list_add_tail(&job->list, list);
> +	spin_unlock_irqrestore(&fdp1->irqlock, flags);
> +}
> +
> +static struct fdp1_job *fdp1_job_alloc(struct fdp1_dev *fdp1)
> +{
> +	return list_remove_job(fdp1, &fdp1->free_job_list);
> +}
> +
> +static void fdp1_job_free(struct fdp1_dev *fdp1, struct fdp1_job *job)
> +{
> +	/* Ensure that all residue from previous jobs is gone */
> +	memset(job, 0, sizeof(struct fdp1_job));
> +
> +	list_add_job(fdp1, &fdp1->free_job_list, job);
> +}
> +
> +static void queue_job(struct fdp1_dev *fdp1, struct fdp1_job *job)
> +{
> +	list_add_job(fdp1, &fdp1->queued_job_list, job);
> +}
> +
> +static struct fdp1_job *get_queued_job(struct fdp1_dev *fdp1)
> +{
> +	return list_remove_job(fdp1, &fdp1->queued_job_list);
> +}
> +
> +static void queue_hw_job(struct fdp1_dev *fdp1, struct fdp1_job *job)
> +{
> +	list_add_job(fdp1, &fdp1->hw_job_list, job);
> +}
> +
> +static struct fdp1_job *get_hw_queued_job(struct fdp1_dev *fdp1)
> +{
> +	return list_remove_job(fdp1, &fdp1->hw_job_list);
> +}
> +
> +/*
> + * Buffer lists handling
> + */
> +static struct fdp1_buffer *list_remove_buffer(struct fdp1_dev *fdp1,
> +					       struct list_head *list)
> +{
> +	struct fdp1_buffer *buf;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fdp1->irqlock, flags);
> +	buf = list_first_entry_or_null(list, struct fdp1_buffer, list);
> +	if (buf)
> +		list_del(&buf->list);
> +	spin_unlock_irqrestore(&fdp1->irqlock, flags);
> +
> +	return buf;
> +}
> +
> +/*
> + * list_add_buffer: Add a buffer to the specified list
> + *
> + * Returns: void - always succeeds
> + */
> +static void list_add_buffer(struct fdp1_dev *fdp1,
> +			    struct list_head *list,
> +			    struct fdp1_buffer *buf)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fdp1->irqlock, flags);
> +	list_add_tail(&buf->list, list);
> +	spin_unlock_irqrestore(&fdp1->irqlock, flags);
> +}
> +
> +/*
> + * fdp1_buffer_alloc: Retrieve a buffer to track a single field/frame
> + *
> + * Must always return a buffer, and should block if necessary.
> + */
> +static struct fdp1_buffer *fdp1_buffer_alloc(struct fdp1_ctx *ctx)
> +{
> +	return list_remove_buffer(ctx->fdp1, &ctx->free_buffers);
> +}
> +
> +static void fdp1_buffer_free(struct fdp1_ctx *ctx,
> +			struct fdp1_buffer *buf)
> +{
> +	/* job->previous may be on the first field */
> +	if (!buf)
> +		return;
> +
> +	if (buf->last_field)
> +		v4l2_m2m_buf_done(buf->vb, VB2_BUF_STATE_DONE);
> +
> +	memset(buf, 0, sizeof(struct fdp1_buffer));
> +
> +	list_add_buffer(ctx->fdp1, &ctx->free_buffers, buf);
> +}
> +
> +static void queue_buffer(struct fdp1_ctx *ctx, struct fdp1_buffer *buf)
> +{
> +	list_add_buffer(ctx->fdp1, &ctx->fdp1_buffer_queue, buf);
> +	ctx->buffers_queued++;
> +}
> +
> +static struct fdp1_buffer *dequeue_buffer(struct fdp1_ctx *ctx)
> +{
> +	ctx->buffers_queued--;
> +	return list_remove_buffer(ctx->fdp1, &ctx->fdp1_buffer_queue);
> +}
> +
> +/*
> + * Return the next buffer in the queue - or NULL,
> + * without removing the item from the list
> + */
> +static struct fdp1_buffer *peek_queued_buffer(struct fdp1_ctx *ctx)
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	unsigned long flags;
> +	struct fdp1_buffer *buf;
> +
> +	spin_lock_irqsave(&fdp1->irqlock, flags);
> +	buf = list_first_entry_or_null(&ctx->fdp1_buffer_queue,
> +			struct fdp1_buffer, list);
> +	spin_unlock_irqrestore(&fdp1->irqlock, flags);
> +
> +	return buf;
> +}
> +
> +static u32 fdp1_read(struct fdp1_dev *fdp1, unsigned int reg)
> +{
> +	u32 value = ioread32(fdp1->regs + reg);
> +
> +	if (debug >= 2)
> +		dprintk(fdp1, "Read 0x%08x from 0x%04x\n", value, reg);
> +
> +	return value;
> +}
> +
> +static void fdp1_write(struct fdp1_dev *fdp1, u32 val, unsigned int reg)
> +{
> +	if (debug >= 2)
> +		dprintk(fdp1, "Write 0x%08x to 0x%04x\n", val, reg);
> +
> +	iowrite32(val, fdp1->regs + reg);
> +}
> +
> +/* IPC registers are to be programmed with constant values */
> +static void fdp1_set_ipc_dli(struct fdp1_ctx *ctx)
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +
> +	fdp1_write(fdp1, FD1_IPC_SMSK_THRESH_CONST,	FD1_IPC_SMSK_THRESH);
> +	fdp1_write(fdp1, FD1_IPC_COMB_DET_CONST,	FD1_IPC_COMB_DET);
> +	fdp1_write(fdp1, FD1_IPC_MOTDEC_CONST,	FD1_IPC_MOTDEC);
> +
> +	fdp1_write(fdp1, FD1_IPC_DLI_BLEND_CONST,	FD1_IPC_DLI_BLEND);
> +	fdp1_write(fdp1, FD1_IPC_DLI_HGAIN_CONST,	FD1_IPC_DLI_HGAIN);
> +	fdp1_write(fdp1, FD1_IPC_DLI_SPRS_CONST,	FD1_IPC_DLI_SPRS);
> +	fdp1_write(fdp1, FD1_IPC_DLI_ANGLE_CONST,	FD1_IPC_DLI_ANGLE);
> +	fdp1_write(fdp1, FD1_IPC_DLI_ISOPIX0_CONST,	FD1_IPC_DLI_ISOPIX0);
> +	fdp1_write(fdp1, FD1_IPC_DLI_ISOPIX1_CONST,	FD1_IPC_DLI_ISOPIX1);
> +}
> +
> +
> +static void fdp1_set_ipc_sensor(struct fdp1_ctx *ctx)
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	struct fdp1_q_data *src_q_data = &ctx->out_q;
> +	unsigned int x0, x1;
> +	unsigned int hsize = src_q_data->format.width;
> +	unsigned int vsize = src_q_data->format.height;
> +
> +	x0 = hsize / 3;
> +	x1 = 2 * hsize / 3;
> +
> +	fdp1_write(fdp1, FD1_IPC_SENSOR_TH0_CONST, FD1_IPC_SENSOR_TH0);
> +	fdp1_write(fdp1, FD1_IPC_SENSOR_TH1_CONST, FD1_IPC_SENSOR_TH1);
> +	fdp1_write(fdp1, FD1_IPC_SENSOR_CTL0_CONST, FD1_IPC_SENSOR_CTL0);
> +	fdp1_write(fdp1, FD1_IPC_SENSOR_CTL1_CONST, FD1_IPC_SENSOR_CTL1);
> +
> +	fdp1_write(fdp1, ((hsize - 1) << FD1_IPC_SENSOR_CTL2_X_SHIFT) |
> +			 ((vsize - 1) << FD1_IPC_SENSOR_CTL2_Y_SHIFT),
> +			 FD1_IPC_SENSOR_CTL2);
> +
> +	fdp1_write(fdp1, (x0 << FD1_IPC_SENSOR_CTL3_0_SHIFT) |
> +			 (x1 << FD1_IPC_SENSOR_CTL3_1_SHIFT),
> +			 FD1_IPC_SENSOR_CTL3);
> +}
> +
> +/*
> + * fdp1_write_lut: Write a padded LUT to the hw
> + *
> + * FDP1 uses constant data for de-interlacing processing,
> + * with large tables. These hardware tables are all 256 bytes
> + * long, however they often contain repeated data at the end.
> + *
> + * The last byte of the table is written to all remaining entries.
> + */
> +static void fdp1_write_lut(struct fdp1_dev *fdp1,
> +			   u8 *lut,
> +			   unsigned int len,
> +			   unsigned int base)
> +{
> +	unsigned int i;
> +	u8 pad;
> +
> +	/* Tables larger than the hw are clipped */
> +	len = min(len, 256u);
> +
> +	for (i = 0; i < len; i++)
> +		fdp1_write(fdp1, lut[i], base + (i*4));
> +
> +	/* Tables are padded with the last entry */
> +	pad = lut[i-1];
> +
> +	for (; i < 256; i++)
> +		fdp1_write(fdp1, pad, base + (i*4));
> +}
> +
> +static void fdp1_set_lut(struct fdp1_dev *fdp1)
> +{
> +	fdp1_write_lut(fdp1, fdp1_diff_adj, ARRAY_SIZE(fdp1_diff_adj),
> +			FD1_LUT_DIF_ADJ);
> +	fdp1_write_lut(fdp1, fdp1_sad_adj,  ARRAY_SIZE(fdp1_sad_adj),
> +			FD1_LUT_SAD_ADJ);
> +	fdp1_write_lut(fdp1, fdp1_bld_gain, ARRAY_SIZE(fdp1_bld_gain),
> +			FD1_LUT_BLD_GAIN);
> +	fdp1_write_lut(fdp1, fdp1_dif_gain, ARRAY_SIZE(fdp1_dif_gain),
> +			FD1_LUT_DIF_GAIN);
> +	fdp1_write_lut(fdp1, fdp1_mdet, ARRAY_SIZE(fdp1_mdet),
> +			FD1_LUT_MDET);
> +}
> +
> +static void fdp1_configure_rpf(struct fdp1_ctx *ctx,
> +			       struct fdp1_job *job)
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	u32 picture_size;
> +	u32 pstride;
> +	u32 format;
> +	u32 smsk_addr;
> +
> +	struct fdp1_q_data *q_data = &ctx->out_q;
> +
> +	/* Picture size is common to Source and Destination frames */
> +	picture_size = (q_data->format.width << FD1_RPF_SIZE_H_SHIFT)
> +		     | (q_data->vsize << FD1_RPF_SIZE_V_SHIFT);
> +
> +	/* Strides */
> +	pstride = q_data->stride_y << FD1_RPF_PSTRIDE_Y_SHIFT;
> +	if (q_data->format.num_planes > 1)
> +		pstride |= q_data->stride_c << FD1_RPF_PSTRIDE_C_SHIFT;
> +
> +	/* Format control */
> +	format = q_data->fmt->fmt;
> +	if (q_data->fmt->swap_yc)
> +		format |= FD1_RPF_FORMAT_RSPYCS;
> +
> +	if (q_data->fmt->swap_uv)
> +		format |= FD1_RPF_FORMAT_RSPUVS;
> +
> +	if (job->active->field == V4L2_FIELD_BOTTOM) {
> +		format |= FD1_RPF_FORMAT_CF; /* Set for Bottom field */
> +		smsk_addr = ctx->smsk_addr[0];
> +	} else {
> +		smsk_addr = ctx->smsk_addr[1];
> +	}
> +
> +	/* Deint mode is non-zero when deinterlacing */
> +	if (ctx->deint_mode)
> +		format |= FD1_RPF_FORMAT_CIPM;
> +
> +	fdp1_write(fdp1, format, FD1_RPF_FORMAT);
> +	fdp1_write(fdp1, q_data->fmt->swap, FD1_RPF_SWAP);
> +	fdp1_write(fdp1, picture_size, FD1_RPF_SIZE);
> +	fdp1_write(fdp1, pstride, FD1_RPF_PSTRIDE);
> +	fdp1_write(fdp1, smsk_addr, FD1_RPF_SMSK_ADDR);
> +
> +	/* Previous Field Channel (CH0) */
> +	if (job->previous)
> +		fdp1_write(fdp1, job->previous->addrs[0], FD1_RPF0_ADDR_Y);
> +
> +	/* Current Field Channel (CH1) */
> +	fdp1_write(fdp1, job->active->addrs[0], FD1_RPF1_ADDR_Y);
> +	fdp1_write(fdp1, job->active->addrs[1], FD1_RPF1_ADDR_C0);
> +	fdp1_write(fdp1, job->active->addrs[2], FD1_RPF1_ADDR_C1);
> +
> +	/* Next Field  Channel (CH2) */
> +	if (job->next)
> +		fdp1_write(fdp1, job->next->addrs[0], FD1_RPF2_ADDR_Y);
> +}
> +
> +static void fdp1_configure_wpf(struct fdp1_ctx *ctx,
> +			       struct fdp1_job *job)
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	struct fdp1_q_data *src_q_data = &ctx->out_q;
> +	struct fdp1_q_data *q_data = &ctx->cap_q;
> +	u32 pstride;
> +	u32 format;
> +	u32 swap;
> +	u32 rndctl;
> +
> +	pstride = q_data->format.plane_fmt[0].bytesperline
> +			<< FD1_WPF_PSTRIDE_Y_SHIFT;
> +
> +	if (q_data->format.num_planes > 1)
> +		pstride |= q_data->format.plane_fmt[1].bytesperline
> +			<< FD1_WPF_PSTRIDE_C_SHIFT;
> +
> +	format = q_data->fmt->fmt; /* Output Format Code */
> +
> +	if (q_data->fmt->swap_yc)
> +		format |= FD1_WPF_FORMAT_WSPYCS;
> +
> +	if (q_data->fmt->swap_uv)
> +		format |= FD1_WPF_FORMAT_WSPUVS;
> +
> +	if (fdp1_fmt_is_rgb(q_data->fmt)) {
> +		/* Enable Colour Space conversion */
> +		format |= FD1_WPF_FORMAT_CSC;
> +
> +		/* Set WRTM */
> +		if (src_q_data->format.ycbcr_enc == V4L2_COLORSPACE_REC709)

Wrong define, should be V4L2_YCBCR_ENC_709.

> +			format |= FD1_WPF_FORMAT_WRTM_709_16;

There is no FD1_WPF_FORMAT_WRTM_709_0?

> +		else if (src_q_data->format.quantization ==
> +				V4L2_QUANTIZATION_FULL_RANGE)
> +			format |= FD1_WPF_FORMAT_WRTM_601_0;
> +		else
> +			format |= FD1_WPF_FORMAT_WRTM_601_16;
> +	}
> +
> +	/* Set an alpha value into the Pad Value */
> +	format |= ctx->alpha << FD1_WPF_FORMAT_PDV_SHIFT;
> +
> +	/* Determine picture rounding and clipping */
> +	rndctl = FD1_WPF_RNDCTL_CBRM; /* Rounding Off */
> +	rndctl |= FD1_WPF_RNDCTL_CLMD_NOCLIP;
> +
> +	/* WPF Swap needs both ISWAP and OSWAP setting */
> +	swap = q_data->fmt->swap << FD1_WPF_SWAP_OSWAP_SHIFT;
> +	swap |= src_q_data->fmt->swap << FD1_WPF_SWAP_SSWAP_SHIFT;
> +
> +	fdp1_write(fdp1, format, FD1_WPF_FORMAT);
> +	fdp1_write(fdp1, rndctl, FD1_WPF_RNDCTL);
> +	fdp1_write(fdp1, swap, FD1_WPF_SWAP);
> +	fdp1_write(fdp1, pstride, FD1_WPF_PSTRIDE);
> +
> +	fdp1_write(fdp1, job->dst.addrs[0], FD1_WPF_ADDR_Y);
> +	fdp1_write(fdp1, job->dst.addrs[1], FD1_WPF_ADDR_C0);
> +	fdp1_write(fdp1, job->dst.addrs[2], FD1_WPF_ADDR_C1);
> +}
> +
> +static void fdp1_configure_deint_mode(struct fdp1_ctx *ctx,
> +				      struct fdp1_job *job)
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	u32 opmode = FD1_CTL_OPMODE_VIMD_NOINTERRUPT;
> +	u32 ipcmode = FD1_IPC_MODE_DLI; /* Always set */
> +	u32 channels = FD1_CTL_CHACT_WR | FD1_CTL_CHACT_RD1; /* Always on */
> +
> +	/* De-interlacing Mode */
> +	switch (ctx->deint_mode) {
> +	default:
> +	case FDP1_PROGRESSIVE:
> +		dprintk(fdp1, "Progressive Mode\n");
> +		opmode |= FD1_CTL_OPMODE_PRG;
> +		ipcmode |= FD1_IPC_MODE_DIM_FIXED2D;
> +		break;
> +	case FDP1_ADAPT2D3D:
> +		dprintk(fdp1, "Adapt2d3d Mode\n");
> +		if (ctx->sequence == 0 || ctx->aborting)
> +			ipcmode |= FD1_IPC_MODE_DIM_FIXED2D;
> +		else
> +			ipcmode |= FD1_IPC_MODE_DIM_ADAPT2D3D;
> +
> +		if (ctx->sequence > 1) {
> +			channels |= FD1_CTL_CHACT_SMW;
> +			channels |= FD1_CTL_CHACT_RD0 | FD1_CTL_CHACT_RD2;
> +		}
> +
> +		if (ctx->sequence > 2)
> +			channels |= FD1_CTL_CHACT_SMR;
> +
> +		break;
> +	case FDP1_FIXED3D:
> +		dprintk(fdp1, "Fixed 3d Mode\n");
> +		ipcmode |= FD1_IPC_MODE_DIM_FIXED3D;
> +		/* Except for first and last frame, enable all channels */
> +		if (!(ctx->sequence == 0 || ctx->aborting))
> +			channels |= FD1_CTL_CHACT_RD0 | FD1_CTL_CHACT_RD2;
> +		break;
> +	case FDP1_FIXED2D:
> +		dprintk(fdp1, "Fixed 2d Mode\n");
> +		ipcmode |= FD1_IPC_MODE_DIM_FIXED2D;
> +		/* No extra channels enabled */
> +		break;
> +	case FDP1_PREVFIELD:
> +		dprintk(fdp1, "Previous Field Mode\n");
> +		ipcmode |= FD1_IPC_MODE_DIM_PREVFIELD;
> +		channels |= FD1_CTL_CHACT_RD0; /* Previous */
> +		break;
> +	case FDP1_NEXTFIELD:
> +		dprintk(fdp1, "Next Field Mode\n");
> +		ipcmode |= FD1_IPC_MODE_DIM_NEXTFIELD;
> +		channels |= FD1_CTL_CHACT_RD2; /* Next */
> +		break;
> +	}
> +
> +	fdp1_write(fdp1, channels,	FD1_CTL_CHACT);
> +	fdp1_write(fdp1, opmode,	FD1_CTL_OPMODE);
> +	fdp1_write(fdp1, ipcmode,	FD1_IPC_MODE);
> +}
> +
> +/*
> + * fdp1_device_process() - Run the hardware
> + *
> + * Configure and start the hardware to generate a single frame
> + * of output given our input parameters.
> + */
> +static int fdp1_device_process(struct fdp1_ctx *ctx)
> +
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	struct fdp1_job *job;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fdp1->device_process_lock, flags);
> +
> +	/* Get a job to process */
> +	job = get_queued_job(fdp1);
> +	if (!job) {
> +		/*
> +		 * VINT can call us to see if we can queue another job.
> +		 * If we have no work to do, we simply return.
> +		 */
> +		spin_unlock_irqrestore(&fdp1->device_process_lock, flags);
> +		return 0;
> +	}
> +
> +	/* First Frame only? ... */
> +	fdp1_write(fdp1, FD1_CTL_CLKCTRL_CSTP_N, FD1_CTL_CLKCTRL);
> +
> +	/* Set the mode, and configuration */
> +	fdp1_configure_deint_mode(ctx, job);
> +
> +	/* DLI Static Configuration */
> +	fdp1_set_ipc_dli(ctx);
> +
> +	/* Sensor Configuration */
> +	fdp1_set_ipc_sensor(ctx);
> +
> +	/* Setup the source picture */
> +	fdp1_configure_rpf(ctx, job);
> +
> +	/* Setup the destination picture */
> +	fdp1_configure_wpf(ctx, job);
> +
> +	/* Line Memory Pixel Number Register for linear access */
> +	fdp1_write(fdp1, FD1_IPC_LMEM_LINEAR, FD1_IPC_LMEM);
> +
> +	/* Enable Interrupts */
> +	fdp1_write(fdp1, FD1_CTL_IRQ_MASK, FD1_CTL_IRQENB);
> +
> +	/* Finally, the Immediate Registers */
> +
> +	/* This job is now in the HW queue */
> +	queue_hw_job(fdp1, job);
> +
> +	/* Start the command */
> +	fdp1_write(fdp1, FD1_CTL_CMD_STRCMD, FD1_CTL_CMD);
> +
> +	/* Registers will update to HW at next VINT */
> +	fdp1_write(fdp1, FD1_CTL_REGEND_REGEND, FD1_CTL_REGEND);
> +
> +	/* Enable VINT Generator */
> +	fdp1_write(fdp1, FD1_CTL_SGCMD_SGEN, FD1_CTL_SGCMD);
> +
> +	spin_unlock_irqrestore(&fdp1->device_process_lock, flags);
> +
> +	return 0;
> +}
> +
> +/*
> + * mem2mem callbacks
> + */
> +
> +/**
> + * job_ready() - check whether an instance is ready to be scheduled to run
> + */
> +static int fdp1_m2m_job_ready(void *priv)
> +{
> +	struct fdp1_ctx *ctx = priv;
> +	struct fdp1_q_data *src_q_data = &ctx->out_q;
> +	int srcbufs = 1;
> +	int dstbufs = 1;
> +
> +	dprintk(ctx->fdp1, "+ Src: %d : Dst: %d\n",
> +			v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx),
> +			v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx));
> +
> +	/* One output buffer is required for each field */
> +	if (V4L2_FIELD_HAS_BOTH(src_q_data->format.field))
> +		dstbufs = 2;
> +
> +	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < srcbufs
> +	    || v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < dstbufs) {
> +		dprintk(ctx->fdp1, "Not enough buffers available\n");
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static void fdp1_m2m_job_abort(void *priv)
> +{
> +	struct fdp1_ctx *ctx = priv;
> +
> +	dprintk(ctx->fdp1, "+\n");
> +
> +	/* Will cancel the transaction in the next interrupt handler */
> +	ctx->aborting = 1;
> +
> +	/* Immediate abort sequence */
> +	fdp1_write(ctx->fdp1, 0, FD1_CTL_SGCMD);
> +	fdp1_write(ctx->fdp1, FD1_CTL_SRESET_SRST, FD1_CTL_SRESET);
> +}
> +
> +/*
> + * prepare_buffer: Prepare an fdp1_buffer, from a vb2_v4l2_buffer
> + *
> + * This helps us serialise buffers containing two fields into
> + * sequential top and bottom fields.
> + * Destination buffers also go through this function to
> + * set the vb and addrs in the same manner.
> + */
> +static void prepare_buffer(struct fdp1_ctx *ctx,
> +			   struct fdp1_buffer *buf,
> +			   struct vb2_v4l2_buffer *vb,
> +			   bool next_field, bool last_field)
> +{
> +	struct fdp1_q_data *q_data = get_q_data(ctx, vb->vb2_buf.type);
> +	unsigned int i;
> +
> +	buf->vb = vb;
> +	buf->last_field = last_field;
> +
> +	for (i = 0; i < vb->vb2_buf.num_planes; ++i)
> +		buf->addrs[i] = vb2_dma_contig_plane_dma_addr(&vb->vb2_buf, i);
> +
> +	switch (vb->field) {
> +	case V4L2_FIELD_INTERLACED:

For INTERLACED field order the order depends on the chosen TV standard: for 60 Hz
BOTTOM comes first, for 50 Hz TOP comes first.

Don't shoot the messenger :-)

> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_SEQ_TB:
> +		buf->field = (next_field) ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
> +		break;
> +	case V4L2_FIELD_INTERLACED_BT:
> +	case V4L2_FIELD_SEQ_BT:
> +		buf->field = (next_field) ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
> +		break;
> +	default:
> +		buf->field = vb->field;

Please add a break here.

> +	}
> +
> +	/* Buffer is completed */
> +	if (next_field == false)
> +		return;
> +
> +	/* Adjust buffer addresses for second field */
> +	switch (vb->field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		for (i = 0; i < vb->vb2_buf.num_planes; i++)
> +			buf->addrs[i] +=
> +				(i == 0 ? q_data->stride_y : q_data->stride_c);
> +		break;
> +	case V4L2_FIELD_SEQ_TB:
> +	case V4L2_FIELD_SEQ_BT:
> +		for (i = 0; i < vb->vb2_buf.num_planes; i++)
> +			buf->addrs[i] += q_data->vsize *
> +				(i == 0 ? q_data->stride_y : q_data->stride_c);
> +		break;
> +	}
> +}
> +
> +/*
> + * prepare_job: Prepare and queue a new job for a single action of work
> + *
> + * Prepare the next field, (or frame in progressive) and an output
> + * buffer for the hardware to perform a single operation.
> + */
> +static struct fdp1_job *prepare_job(struct fdp1_ctx *ctx)
> +{
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	struct fdp1_job *job;
> +	unsigned int buffers_required = 1;
> +
> +	dprintk(fdp1, "+\n");
> +
> +	if (FDP1_DEINT_MODE_USES_NEXT(ctx->deint_mode))
> +		buffers_required = 2;
> +
> +	if (ctx->buffers_queued < buffers_required)
> +		return 0;
> +
> +	job = fdp1_job_alloc(fdp1);
> +	if (!job) {
> +		dprintk(fdp1, "No free jobs currently available\n");
> +		return NULL;
> +	}
> +
> +	job->active = dequeue_buffer(ctx);
> +	if (!job->active) {
> +		/* Buffer check should prevent this ever happening */
> +		dprintk(fdp1, "No input buffers currently available\n");
> +
> +		fdp1_job_free(fdp1, job);
> +		return NULL;
> +	}
> +
> +	dprintk(fdp1, "+ Buffer en-route...\n");
> +
> +	/* Source buffers have been prepared on our buffer_queue
> +	 * Prepare our Output buffer
> +	 */
> +	job->dst.vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +	prepare_buffer(ctx, &job->dst, job->dst.vb, false, true);
> +
> +	job->active->vb->sequence = ctx->sequence;
> +	job->dst.vb->sequence = ctx->sequence;
> +	ctx->sequence++;
> +
> +	if (FDP1_DEINT_MODE_USES_PREV(ctx->deint_mode)) {
> +		job->previous = ctx->previous;
> +
> +		/* Active buffer becomes the next job's previous buffer */
> +		ctx->previous = job->active;
> +	}
> +
> +	if (FDP1_DEINT_MODE_USES_NEXT(ctx->deint_mode)) {
> +		/* Must be called after 'active' is dequeued */
> +		job->next = peek_queued_buffer(ctx);
> +	}
> +
> +	/* Transfer timestamps and flags from src->dst */
> +
> +	job->dst.vb->vb2_buf.timestamp = job->active->vb->vb2_buf.timestamp;
> +
> +	job->dst.vb->flags = job->active->vb->flags &
> +				V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +
> +	/* Ideally, the frame-end function will just 'check' to see
> +	 * if there are more jobs instead
> +	 */
> +	ctx->translen++;
> +
> +	/* Finally, Put this job on the processing queue */
> +	queue_job(fdp1, job);
> +
> +	dprintk(fdp1, "Job Queued translen = %d\n", ctx->translen);
> +
> +	return job;
> +}
> +
> +/* fdp1_m2m_device_run() - prepares and starts the device for an M2M task
> + *
> + * A single input buffer is taken and serialised into our fdp1_buffer
> + * queue. The queue is then processed to create as many jobs as possible
> + * from our available input.
> + */
> +static void fdp1_m2m_device_run(void *priv)
> +{
> +	struct fdp1_ctx *ctx = priv;
> +	struct fdp1_dev *fdp1 = ctx->fdp1;
> +	struct fdp1_q_data *src_q_data = &ctx->out_q;
> +	struct vb2_v4l2_buffer *src_vb;
> +	int fields = V4L2_FIELD_HAS_BOTH(src_q_data->format.field) ? 2 : 1;
> +	unsigned int i;
> +
> +	dprintk(fdp1, "+\n");
> +
> +	ctx->translen = 0;
> +
> +	/* Get our incoming buffer of either one or two fields, or one frame */
> +	src_vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +
> +	for (i = 0; i < fields; i++) {
> +		struct fdp1_buffer *buf = fdp1_buffer_alloc(ctx);
> +		bool last_field = (i+1 == fields);
> +
> +		prepare_buffer(ctx, buf, src_vb, i, last_field);
> +		queue_buffer(ctx, buf);
> +		dprintk(fdp1, "Queued Buffer [%d] last_field:%d\n",
> +				i, last_field);
> +	}
> +
> +	/* Queue as many jobs as our data provides for */
> +	while (prepare_job(ctx))
> +		;
> +
> +	if (ctx->translen == 0) {
> +		dprintk(fdp1, "No jobs were processed. M2M action complete\n");
> +		v4l2_m2m_job_finish(fdp1->m2m_dev, ctx->fh.m2m_ctx);
> +		return;
> +	}
> +
> +	/* Kick the job processing action */
> +	fdp1_device_process(ctx);
> +}
> +
> +/*
> + * device_frame_end:
> + *
> + * Handles the M2M level after a buffer completion event.
> + */
> +static void device_frame_end(struct fdp1_dev *fdp1,
> +			     enum vb2_buffer_state state)
> +{
> +	struct fdp1_ctx *ctx;
> +	unsigned long flags;
> +	struct fdp1_job *job = get_hw_queued_job(fdp1);
> +
> +	dprintk(fdp1, "+\n");
> +
> +	ctx = v4l2_m2m_get_curr_priv(fdp1->m2m_dev);
> +
> +	if (ctx == NULL) {
> +		v4l2_err(&fdp1->v4l2_dev,
> +			"Instance released before the end of transaction\n");
> +		return;
> +	}
> +
> +	ctx->num_processed++;
> +
> +	/*
> +	 * fdp1_buffer_free will call buf_done only when the last vb2_buffer
> +	 * reference is complete
> +	 */
> +	if (FDP1_DEINT_MODE_USES_PREV(ctx->deint_mode))
> +		fdp1_buffer_free(ctx, job->previous);
> +	else
> +		fdp1_buffer_free(ctx, job->active);
> +
> +	spin_lock_irqsave(&fdp1->irqlock, flags);
> +	v4l2_m2m_buf_done(job->dst.vb, state);
> +	spin_unlock_irqrestore(&fdp1->irqlock, flags);
> +
> +	/* Move this job back to the free job list */
> +	fdp1_job_free(fdp1, job);
> +
> +	dprintk(fdp1, "curr_ctx->num_processed %d curr_ctx->translen %d\n",
> +			ctx->num_processed, ctx->translen);
> +
> +	if (ctx->num_processed == ctx->translen ||
> +			ctx->aborting) {
> +		dprintk(ctx->fdp1, "Finishing transaction\n");
> +		ctx->num_processed = 0;
> +		v4l2_m2m_job_finish(fdp1->m2m_dev, ctx->fh.m2m_ctx);
> +	} else {
> +		/*
> +		 * For pipelined performance support, this would
> +		 * be called from a VINT handler
> +		 */
> +		fdp1_device_process(ctx);
> +	}
> +}
> +
> +/*
> + * video ioctls
> + */
> +static int fdp1_vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, DRIVER_NAME, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +			"platform:%s", DRIVER_NAME);
> +	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Set the device_caps field of struct video_device instead. Then you can drop
these two lines. This should be used for new drivers.

> +	return 0;
> +}
> +
> +static int fdp1_enum_fmt(struct v4l2_fmtdesc *f, u32 type)
> +{
> +	unsigned int i, num;
> +
> +	num = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(fdp1_formats); ++i) {
> +		if (fdp1_formats[i].types & type) {
> +			if (num == f->index)
> +				break;
> +			++num;
> +		}
> +	}
> +
> +	/* Format not found */
> +	if (i >= ARRAY_SIZE(fdp1_formats))
> +		return -EINVAL;
> +
> +	/* Format found */
> +	f->pixelformat = fdp1_formats[i].fourcc;
> +
> +	return 0;
> +}
> +
> +static int fdp1_enum_fmt_vid_cap(struct file *file, void *priv,
> +				 struct v4l2_fmtdesc *f)
> +{
> +	return fdp1_enum_fmt(f, FDP1_CAPTURE);
> +}
> +
> +static int fdp1_enum_fmt_vid_out(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	return fdp1_enum_fmt(f, FDP1_OUTPUT);
> +}
> +
> +static int fdp1_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct fdp1_q_data *q_data;
> +	struct fdp1_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (!v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type))
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, f->type);
> +	f->fmt.pix_mp = q_data->format;
> +
> +	return 0;
> +}
> +
> +static int __fdp1_try_fmt(struct fdp1_ctx *ctx, const struct fdp1_fmt **fmtinfo,
> +			  struct v4l2_pix_format_mplane *pix,
> +			  enum v4l2_buf_type type)
> +{
> +	const struct fdp1_fmt *fmt;
> +	unsigned int width = pix->width;
> +	unsigned int height = pix->height;
> +	unsigned int fmt_type;
> +	unsigned int i;
> +
> +	fmt_type = V4L2_TYPE_IS_OUTPUT(type) ? FDP1_OUTPUT : FDP1_CAPTURE;
> +
> +	fmt = fdp1_find_format(pix->pixelformat);
> +	if (!fmt || !(fmt->types & fmt_type))
> +		fmt = fdp1_find_format(V4L2_PIX_FMT_YUYV);
> +
> +	pix->pixelformat = fmt->fourcc;
> +
> +	/* Manage colorspace on the two queues */
> +	if (V4L2_TYPE_IS_OUTPUT(type)) {
> +		if (pix->colorspace == V4L2_COLORSPACE_DEFAULT)
> +			pix->colorspace = V4L2_COLORSPACE_REC709;

Please read https://hverkuil.home.xs4all.nl/cec.html#colorspaces carefully.

The colorspace has nothing to do with YUV vs RGB.

I don't know the functionality of this m2m device, but my guess is that it
has a standard 4x3 matrix to do 'colorspace' conversion (I quote it because
it is almost never a real colorspace conversion, but just an RGB/YUV conversion).

As of today the application is expected to set the colorspace information on
the OUTPUT format and the driver fills it in for the CAPTURE side.

But here you probably want to let the application give some information as
well, specifically YCBCR_ENC_601 vs 709 and FULL vs LIM_RANGE.

If that's the case, then look at this old patch of mine, adding support for this:

https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=csc&id=d0e588c1a36604538e16f24cad3444c84f5da73e

> +
> +		if (pix->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
> +			pix->ycbcr_enc =
> +				V4L2_MAP_YCBCR_ENC_DEFAULT(pix->colorspace);
> +
> +		if (pix->quantization == V4L2_QUANTIZATION_DEFAULT)
> +			pix->quantization =
> +				V4L2_MAP_QUANTIZATION_DEFAULT(false,
> +						pix->colorspace,
> +						pix->ycbcr_enc);
> +	} else {
> +		/* Manage the CAPTURE Queue */
> +		struct fdp1_q_data *src_data = &ctx->out_q;
> +
> +		if (fdp1_fmt_is_rgb(fmt)) {
> +			pix->colorspace = V4L2_COLORSPACE_SRGB;
> +			pix->ycbcr_enc = V4L2_YCBCR_ENC_SYCC;
> +			pix->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +		} else {
> +			/* Copy input queue colorspace across */
> +			pix->colorspace = src_data->format.colorspace;
> +			pix->ycbcr_enc = src_data->format.ycbcr_enc;
> +			pix->quantization = src_data->format.quantization;
> +		}
> +	}
> +
> +	/* We should be allowing FIELDS through on the Output queue !*/
> +	if (V4L2_TYPE_IS_OUTPUT(type)) {
> +		/* Clamp to allowable field types */
> +		if (pix->field == V4L2_FIELD_ANY ||
> +		    pix->field == V4L2_FIELD_NONE)
> +			pix->field = V4L2_FIELD_NONE;
> +		else if (!V4L2_FIELD_HAS_BOTH(pix->field))
> +			pix->field = V4L2_FIELD_INTERLACED;
> +
> +		dprintk(ctx->fdp1, "Output Field Type set as %d\n", pix->field);
> +	} else {
> +		pix->field = V4L2_FIELD_NONE;
> +	}
> +
> +	pix->num_planes = fmt->num_planes;
> +
> +	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
> +	width = round_down(width, fmt->hsub);
> +	height = round_down(height, fmt->vsub);
> +
> +	/* Clamp the width and height */
> +	pix->width = clamp(width, FDP1_MIN_W, FDP1_MAX_W);
> +	pix->height = clamp(height, FDP1_MIN_H, FDP1_MAX_H);
> +
> +	/* Compute and clamp the stride and image size. While not documented in
> +	 * the datasheet, strides not aligned to a multiple of 128 bytes result
> +	 * in image corruption.
> +	 */
> +	for (i = 0; i < min_t(unsigned int, fmt->num_planes, 2U); ++i) {
> +		unsigned int hsub = i > 0 ? fmt->hsub : 1;
> +		unsigned int vsub = i > 0 ? fmt->vsub : 1;
> +		 /* From VSP : TODO: Confirm alignment limits for FDP1 */
> +		unsigned int align = 128;
> +		unsigned int bpl;
> +
> +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
> +			      pix->width / hsub * fmt->bpp[i] / 8,
> +			      round_down(65535U, align));
> +
> +		pix->plane_fmt[i].bytesperline = round_up(bpl, align);
> +		pix->plane_fmt[i].sizeimage = pix->plane_fmt[i].bytesperline
> +					    * pix->height / vsub;
> +
> +		memset(pix->plane_fmt[i].reserved, 0,
> +				sizeof(pix->plane_fmt[i].reserved));
> +	}
> +
> +	if (fmt->num_planes == 3) {
> +		/* The second and third planes must have the same stride. */
> +		pix->plane_fmt[2].bytesperline = pix->plane_fmt[1].bytesperline;
> +		pix->plane_fmt[2].sizeimage = pix->plane_fmt[1].sizeimage;
> +
> +		memset(pix->plane_fmt[2].reserved, 0,
> +				sizeof(pix->plane_fmt[2].reserved));
> +	}
> +
> +	pix->num_planes = fmt->num_planes;
> +
> +	if (fmtinfo)
> +		*fmtinfo = fmt;
> +
> +	return 0;
> +}
> +
> +static int fdp1_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct fdp1_ctx *ctx = fh_to_ctx(priv);
> +	int ret;
> +
> +	ret = __fdp1_try_fmt(ctx, NULL, &f->fmt.pix_mp, f->type);
> +
> +	if (ret < 0)
> +		dprintk(ctx->fdp1, "try_fmt failed %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int fdp1_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct fdp1_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
> +	struct fdp1_q_data *q_data;
> +	const struct fdp1_fmt *fmtinfo;
> +	int ret;
> +
> +	vq = v4l2_m2m_get_vq(m2m_ctx, f->type);
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&ctx->fdp1->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	ret = __fdp1_try_fmt(ctx, &fmtinfo, &f->fmt.pix_mp, f->type);
> +	if (ret < 0) {
> +		v4l2_err(&ctx->fdp1->v4l2_dev, "set_fmt failed %d\n", ret);
> +		return ret;
> +	}
> +
> +	q_data = get_q_data(ctx, f->type);
> +	q_data->format = f->fmt.pix_mp;
> +	q_data->fmt = fmtinfo;
> +
> +	q_data->vsize = f->fmt.pix_mp.height;
> +	if (q_data->format.field != V4L2_FIELD_NONE)
> +		q_data->vsize /= 2;
> +
> +	q_data->stride_y = q_data->format.plane_fmt[0].bytesperline;
> +	q_data->stride_c = q_data->format.plane_fmt[1].bytesperline;
> +
> +	/* Adjust strides for interleaved buffers */
> +	if (q_data->format.field == V4L2_FIELD_INTERLACED ||
> +	    q_data->format.field == V4L2_FIELD_INTERLACED_TB ||
> +	    q_data->format.field == V4L2_FIELD_INTERLACED_BT) {
> +		q_data->stride_y *= 2;
> +		q_data->stride_c *= 2;
> +	}
> +
> +	dprintk(ctx->fdp1,
> +		"Setting format for type %d, wxh: %dx%d, fmt: %4s (%d)\n",
> +			f->type, q_data->format.width, q_data->format.height,
> +			(char *)&q_data->fmt->fourcc, q_data->fmt->fourcc);
> +
> +	return 0;
> +}
> +
> +static int fdp1_g_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct fdp1_ctx *ctx =
> +		container_of(ctrl->handler, struct fdp1_ctx, hdl);
> +	struct fdp1_q_data *src_q_data = &ctx->out_q;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
> +		if (V4L2_FIELD_HAS_BOTH(src_q_data->format.field))
> +			ctrl->val = 2;
> +		else
> +			ctrl->val = 1;
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static int fdp1_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct fdp1_ctx *ctx =
> +		container_of(ctrl->handler, struct fdp1_ctx, hdl);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ALPHA_COMPONENT:
> +		ctx->alpha = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_DEINT_MODE:
> +		ctx->deint_mode = ctrl->val;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops fdp1_ctrl_ops = {
> +	.s_ctrl = fdp1_s_ctrl,
> +	.g_volatile_ctrl = fdp1_g_ctrl,
> +};
> +
> +static const char * const fdp1_ctrl_deint_menu[] = {
> +	"Progressive",
> +	"Adaptive 2d/3d",
> +	"Fixed 2d",
> +	"Fixed 3d",
> +	"Previous field",
> +	"Next field",
> +	NULL
> +};
> +
> +static const struct v4l2_ctrl_config fdp1_ctrl_deint_mode = {
> +	.ops = &fdp1_ctrl_ops,
> +	.id = V4L2_CID_DEINT_MODE,
> +	.name = "Deinterlace Mode",
> +	.type = V4L2_CTRL_TYPE_MENU,
> +	.qmenu = fdp1_ctrl_deint_menu,
> +	.def = FDP1_FIXED3D,
> +	.min = FDP1_ADAPT2D3D,
> +	.max = FDP1_NEXTFIELD,
> +	.menu_skip_mask = BIT(0),
> +};
> +
> +static const struct v4l2_ioctl_ops fdp1_ioctl_ops = {
> +	.vidioc_querycap	= fdp1_vidioc_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap_mplane = fdp1_enum_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_out_mplane = fdp1_enum_fmt_vid_out,
> +	.vidioc_g_fmt_vid_cap_mplane	= fdp1_g_fmt,
> +	.vidioc_g_fmt_vid_out_mplane	= fdp1_g_fmt,
> +	.vidioc_try_fmt_vid_cap_mplane	= fdp1_try_fmt,
> +	.vidioc_try_fmt_vid_out_mplane	= fdp1_try_fmt,
> +	.vidioc_s_fmt_vid_cap_mplane	= fdp1_s_fmt,
> +	.vidioc_s_fmt_vid_out_mplane	= fdp1_s_fmt,
> +
> +	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_prepare_buf	= v4l2_m2m_ioctl_prepare_buf,
> +	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
> +
> +	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +};
> +
> +/*
> + * Queue operations
> + */
> +
> +static int fdp1_queue_setup(struct vb2_queue *vq,
> +				unsigned int *nbuffers, unsigned int *nplanes,
> +				unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct fdp1_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct fdp1_q_data *q_data;
> +	unsigned int i;
> +
> +	q_data = get_q_data(ctx, vq->type);
> +
> +	if (*nplanes) {
> +		if (*nplanes > FDP1_MAX_PLANES)
> +			return -EINVAL;
> +
> +		for (i = 0; i < *nplanes; i++)
> +			alloc_ctxs[i] = ctx->fdp1->alloc_ctx;
> +
> +		return 0;
> +	}
> +
> +	*nplanes = q_data->format.num_planes;
> +
> +	for (i = 0; i < *nplanes; i++) {
> +		sizes[i] = q_data->format.plane_fmt[i].sizeimage;
> +		alloc_ctxs[i] = ctx->fdp1->alloc_ctx;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fdp1_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct fdp1_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct fdp1_q_data *q_data;
> +	unsigned int i;
> +
> +	q_data = get_q_data(ctx, vb->vb2_queue->type);
> +
> +	/* Default to Progressive if ANY selected */
> +	if (vbuf->field == V4L2_FIELD_ANY)
> +		vbuf->field = V4L2_FIELD_NONE;
> +
> +	/* We only support progressive CAPTURE */
> +	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type) &&
> +	     vbuf->field != V4L2_FIELD_NONE) {
> +		dprintk(ctx->fdp1, "field isn't supported on capture\n");
> +			return -EINVAL;
> +	}
> +
> +	for (i = 0; i < q_data->format.num_planes; i++) {
> +		unsigned long size = q_data->format.plane_fmt[i].sizeimage;
> +
> +		if (vb2_plane_size(vb, i) < size) {
> +			dprintk(ctx->fdp1,
> +				"data will not fit into plane [%u/%u] (%lu < %lu)\n",
> +				i, q_data->format.num_planes,
> +				vb2_plane_size(vb, i), size);
> +			return -EINVAL;
> +		}
> +
> +		/* We have known size formats all around */
> +		vb2_set_plane_payload(vb, i, size);
> +	}
> +
> +	return 0;
> +}
> +
> +static void fdp1_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct fdp1_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> +}
> +
> +static int fdp1_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct fdp1_ctx *ctx = vb2_get_drv_priv(q);
> +	struct fdp1_q_data *q_data = get_q_data(ctx, q->type);
> +
> +	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> +		/*
> +		 * Force our deint_mode when we are progressive,
> +		 * ignoring any setting on the device from the user,
> +		 * Otherwise, lock in the requested de-interlace mode.
> +		 */
> +		if (q_data->format.field == V4L2_FIELD_NONE)
> +			ctx->deint_mode = FDP1_PROGRESSIVE;
> +
> +		if (ctx->deint_mode == FDP1_ADAPT2D3D) {
> +			u32 stride;
> +			dma_addr_t smsk_base;
> +			const u32 bpp = 2; /* bytes per pixel */
> +
> +			stride = round_up(q_data->format.width, 8);
> +
> +			ctx->smsk_size = bpp * stride * q_data->vsize;
> +
> +			ctx->smsk_cpu = dma_alloc_coherent(ctx->fdp1->dev,
> +				ctx->smsk_size, &smsk_base, GFP_KERNEL);
> +
> +			if (ctx->smsk_cpu == NULL) {
> +				dprintk(ctx->fdp1, "Failed to alloc smsk\n");
> +				return -ENOMEM;
> +			}
> +
> +			ctx->smsk_addr[0] = smsk_base;
> +			ctx->smsk_addr[1] = smsk_base + (ctx->smsk_size/2);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void fdp1_stop_streaming(struct vb2_queue *q)
> +{
> +	struct fdp1_ctx *ctx = vb2_get_drv_priv(q);
> +	struct vb2_v4l2_buffer *vbuf;
> +	unsigned long flags;
> +
> +	while (1) {
> +		if (V4L2_TYPE_IS_OUTPUT(q->type))
> +			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +		else
> +			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +		if (vbuf == NULL)
> +			break;
> +		spin_lock_irqsave(&ctx->fdp1->irqlock, flags);
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +		spin_unlock_irqrestore(&ctx->fdp1->irqlock, flags);
> +	}
> +
> +	/* Empty Output queues */
> +	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> +		/* Empty our internal queues */
> +		struct fdp1_buffer *b;
> +
> +		/* Free any queued buffers */
> +		b = dequeue_buffer(ctx);
> +		while (b != NULL) {
> +			fdp1_buffer_free(ctx, b);
> +			b = dequeue_buffer(ctx);
> +		}
> +
> +		/* Free smsk_data */
> +		if (ctx->smsk_cpu) {
> +			dma_free_coherent(ctx->fdp1->dev, ctx->smsk_size,
> +					ctx->smsk_cpu, ctx->smsk_addr[0]);
> +			ctx->smsk_addr[0] = ctx->smsk_addr[1] = 0;
> +			ctx->smsk_cpu = NULL;
> +		}
> +
> +		WARN(!list_empty(&ctx->fdp1_buffer_queue),
> +				"Buffer queue not empty");
> +	} else {
> +		/* Empty Capture queues (Jobs) */
> +		struct fdp1_job *job;
> +
> +		job = get_queued_job(ctx->fdp1);
> +		while (job) {
> +			if (FDP1_DEINT_MODE_USES_PREV(ctx->deint_mode))
> +				fdp1_buffer_free(ctx, job->previous);
> +			else
> +				fdp1_buffer_free(ctx, job->active);
> +
> +			v4l2_m2m_buf_done(job->dst.vb, VB2_BUF_STATE_ERROR);
> +
> +			job = get_queued_job(ctx->fdp1);
> +		}
> +
> +		/* Free any held buffer in the ctx */
> +		fdp1_buffer_free(ctx, ctx->previous);
> +
> +		WARN(!list_empty(&ctx->fdp1->queued_job_list),
> +				"Queued Job List not empty");
> +
> +		WARN(!list_empty(&ctx->fdp1->hw_job_list),
> +				"HW Job list not empty");
> +	}
> +}
> +
> +static struct vb2_ops fdp1_qops = {
> +	.queue_setup	 = fdp1_queue_setup,
> +	.buf_prepare	 = fdp1_buf_prepare,
> +	.buf_queue	 = fdp1_buf_queue,
> +	.start_streaming = fdp1_start_streaming,
> +	.stop_streaming  = fdp1_stop_streaming,
> +	.wait_prepare	 = vb2_ops_wait_prepare,
> +	.wait_finish	 = vb2_ops_wait_finish,
> +};
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct fdp1_ctx *ctx = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops = &fdp1_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->fdp1->dev_mutex;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &fdp1_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->fdp1->dev_mutex;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +/*
> + * File operations
> + */
> +static int fdp1_open(struct file *file)
> +{
> +	struct fdp1_dev *fdp1 = video_drvdata(file);
> +	struct fdp1_ctx *ctx = NULL;
> +	struct v4l2_ctrl *ctrl;
> +	unsigned int i;
> +	int ret = 0;
> +
> +	if (mutex_lock_interruptible(&fdp1->dev_mutex))
> +		return -ERESTARTSYS;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		ret = -ENOMEM;
> +		goto done;
> +	}
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	ctx->fdp1 = fdp1;
> +
> +	/* Initialise Queues */
> +	INIT_LIST_HEAD(&ctx->free_buffers);
> +	INIT_LIST_HEAD(&ctx->fdp1_buffer_queue);
> +
> +	/* Initialise the buffers on the free list */
> +	for (i = 0; i < ARRAY_SIZE(ctx->buffers); i++)
> +		list_add(&ctx->buffers[i].list, &ctx->free_buffers);
> +
> +	ctx->translen = 1;
> +	ctx->sequence = 0;
> +
> +	/* Initialise controls */
> +
> +	v4l2_ctrl_handler_init(&ctx->hdl, 3);
> +	v4l2_ctrl_new_custom(&ctx->hdl, &fdp1_ctrl_deint_mode, NULL);
> +
> +	ctrl = v4l2_ctrl_new_std(&ctx->hdl, &fdp1_ctrl_ops,
> +			V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 2, 1, 1);
> +	if (ctrl)
> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
> +			       V4L2_CTRL_FLAG_READ_ONLY;

v4l2_ctrl_new_std already marks this as READ_ONLY.

> +
> +	v4l2_ctrl_new_std(&ctx->hdl, &fdp1_ctrl_ops,
> +			  V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 255);
> +
> +	if (ctx->hdl.error) {
> +		ret = ctx->hdl.error;
> +		v4l2_ctrl_handler_free(&ctx->hdl);
> +		goto done;
> +	}
> +
> +	ctx->fh.ctrl_handler = &ctx->hdl;
> +	v4l2_ctrl_handler_setup(&ctx->hdl);
> +
> +	/* Configure default parameters. */
> +	__fdp1_try_fmt(ctx, &ctx->out_q.fmt, &ctx->out_q.format,
> +		      V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> +	__fdp1_try_fmt(ctx, &ctx->cap_q.fmt, &ctx->cap_q.format,
> +		      V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(fdp1->m2m_dev, ctx, &queue_init);
> +
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret = PTR_ERR(ctx->fh.m2m_ctx);
> +
> +		v4l2_ctrl_handler_free(&ctx->hdl);
> +		kfree(ctx);
> +		goto done;
> +	}
> +
> +	/* Perform any power management required */
> +	pm_runtime_get_sync(fdp1->dev);
> +
> +	v4l2_fh_add(&ctx->fh);
> +
> +	dprintk(fdp1, "Created instance: %p, m2m_ctx: %p\n",
> +		ctx, ctx->fh.m2m_ctx);
> +
> +done:
> +	mutex_unlock(&fdp1->dev_mutex);
> +	return ret;
> +}
> +
> +static int fdp1_release(struct file *file)
> +{
> +	struct fdp1_dev *fdp1 = video_drvdata(file);
> +	struct fdp1_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	dprintk(fdp1, "Releasing instance %p\n", ctx);
> +
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	v4l2_ctrl_handler_free(&ctx->hdl);
> +	mutex_lock(&fdp1->dev_mutex);
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +	mutex_unlock(&fdp1->dev_mutex);
> +	kfree(ctx);
> +
> +	pm_runtime_put(fdp1->dev);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations fdp1_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= fdp1_open,
> +	.release	= fdp1_release,
> +	.poll		= v4l2_m2m_fop_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= v4l2_m2m_fop_mmap,
> +};
> +
> +static const struct video_device fdp1_videodev = {
> +	.name		= DRIVER_NAME,
> +	.vfl_dir	= VFL_DIR_M2M,
> +	.fops		= &fdp1_fops,
> +	.ioctl_ops	= &fdp1_ioctl_ops,
> +	.minor		= -1,
> +	.release	= video_device_release_empty,
> +};
> +
> +static const struct v4l2_m2m_ops m2m_ops = {
> +	.device_run	= fdp1_m2m_device_run,
> +	.job_ready	= fdp1_m2m_job_ready,
> +	.job_abort	= fdp1_m2m_job_abort,
> +};
> +
> +static irqreturn_t fdp1_irq_handler(int irq, void *dev_id)
> +{
> +	struct fdp1_dev *fdp1 = dev_id;
> +	u32 int_status;
> +	u32 ctl_status;
> +	u32 vint_cnt;
> +	u32 cycles;
> +
> +	int_status = fdp1_read(fdp1, FD1_CTL_IRQSTA);
> +	cycles = fdp1_read(fdp1, FD1_CTL_VCYCLE_STAT);
> +	ctl_status = fdp1_read(fdp1, FD1_CTL_STATUS);
> +	vint_cnt = (ctl_status & FD1_CTL_STATUS_VINT_CNT_MASK) >>
> +			FD1_CTL_STATUS_VINT_CNT_SHIFT;
> +
> +	/* Clear interrupts */
> +	fdp1_write(fdp1, ~(int_status) & FD1_CTL_IRQ_MASK, FD1_CTL_IRQSTA);
> +
> +	if (debug >= 2) {
> +		dprintk(fdp1, "IRQ: 0x%x %s%s%s\n", int_status,
> +			int_status & FD1_CTL_IRQ_VERE ? "[Error]" : "[!E]",
> +			int_status & FD1_CTL_IRQ_VINTE ? "[VSync]" : "[!V]",
> +			int_status & FD1_CTL_IRQ_FREE ? "[FrameEnd]" : "[!F]");
> +
> +		dprintk(fdp1, "CycleStatus = %d (%dms)\n",
> +			cycles, cycles/(fdp1->clk_rate/1000));
> +
> +		dprintk(fdp1,
> +			"Control Status = 0x%08x : VINT_CNT = %d %s:%s:%s:%s\n",
> +			ctl_status, vint_cnt,
> +			ctl_status & FD1_CTL_STATUS_SGREGSET ? "RegSet" : "",
> +			ctl_status & FD1_CTL_STATUS_SGVERR ? "Vsync Error" : "",
> +			ctl_status & FD1_CTL_STATUS_SGFREND ? "FrameEnd" : "",
> +			ctl_status & FD1_CTL_STATUS_BSY ? "Busy" : "");
> +		dprintk(fdp1, "***********************************\n");
> +	}
> +
> +	/* Spurious interrupt */
> +	if (!(FD1_CTL_IRQ_MASK & int_status))
> +		return IRQ_NONE;
> +
> +	/* Work completed, release the frame */
> +	if (FD1_CTL_IRQ_VERE & int_status)
> +		device_frame_end(fdp1, VB2_BUF_STATE_ERROR);
> +	else if (FD1_CTL_IRQ_FREE & int_status)
> +		device_frame_end(fdp1, VB2_BUF_STATE_DONE);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int fdp1_probe(struct platform_device *pdev)
> +{
> +	struct fdp1_dev *fdp1;
> +	struct video_device *vfd;
> +	struct device_node *fcp_node;
> +	struct resource *res;
> +	struct clk *clk;
> +	unsigned int i;
> +
> +	int ret;
> +	int hw_version;
> +
> +	fdp1 = devm_kzalloc(&pdev->dev, sizeof(*fdp1), GFP_KERNEL);
> +	if (!fdp1)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&fdp1->free_job_list);
> +	INIT_LIST_HEAD(&fdp1->queued_job_list);
> +	INIT_LIST_HEAD(&fdp1->hw_job_list);
> +
> +	/* Initialise the jobs on the free list */
> +	for (i = 0; i < ARRAY_SIZE(fdp1->jobs); i++)
> +		list_add(&fdp1->jobs[i].list, &fdp1->free_job_list);
> +
> +	mutex_init(&fdp1->dev_mutex);
> +
> +	spin_lock_init(&fdp1->irqlock);
> +	spin_lock_init(&fdp1->device_process_lock);
> +	fdp1->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, fdp1);
> +
> +	/* Memory-mapped registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	fdp1->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(fdp1->regs))
> +		return PTR_ERR(fdp1->regs);
> +
> +	/* Interrupt service routine registration */
> +	fdp1->irq = ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "cannot find IRQ\n");
> +		return ret;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, fdp1->irq, fdp1_irq_handler, 0,
> +			       dev_name(&pdev->dev), fdp1);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot claim IRQ %d\n", fdp1->irq);
> +		return ret;
> +	}
> +
> +	/* FCP */
> +	fcp_node = of_parse_phandle(pdev->dev.of_node, "renesas,fcp", 0);
> +	if (fcp_node) {
> +		fdp1->fcp = rcar_fcp_get(fcp_node);
> +		of_node_put(fcp_node);
> +		if (IS_ERR(fdp1->fcp)) {
> +			dev_err(&pdev->dev, "FCP not found (%ld)\n",
> +				PTR_ERR(fdp1->fcp));
> +			return PTR_ERR(fdp1->fcp);
> +		}
> +	}
> +
> +	/* Determine our clock rate */
> +	clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	fdp1->clk_rate = clk_get_rate(clk);
> +	clk_put(clk);
> +
> +	/* Memory allocation contexts */
> +	fdp1->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(fdp1->alloc_ctx)) {
> +		v4l2_err(&fdp1->v4l2_dev, "Failed to init memory allocator\n");
> +		return PTR_ERR(fdp1->alloc_ctx);
> +	}
> +
> +	/* V4L2 device registration */
> +	ret = v4l2_device_register(&pdev->dev, &fdp1->v4l2_dev);
> +	if (ret) {
> +		v4l2_err(&fdp1->v4l2_dev, "Failed to register video device\n");
> +		goto vb2_allocator_rollback;
> +	}
> +
> +	/* M2M registration */
> +	fdp1->m2m_dev = v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(fdp1->m2m_dev)) {
> +		v4l2_err(&fdp1->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(fdp1->m2m_dev);
> +		goto unreg_dev;
> +	}
> +
> +	/* Video registration */
> +	fdp1->vfd = fdp1_videodev;
> +	vfd = &fdp1->vfd;
> +	vfd->lock = &fdp1->dev_mutex;
> +	vfd->v4l2_dev = &fdp1->v4l2_dev;
> +	video_set_drvdata(vfd, fdp1);
> +	strlcpy(vfd->name, fdp1_videodev.name, sizeof(vfd->name));
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		v4l2_err(&fdp1->v4l2_dev, "Failed to register video device\n");
> +		goto release_m2m;
> +	}
> +
> +	v4l2_info(&fdp1->v4l2_dev,
> +			"Device registered as /dev/video%d\n", vfd->num);
> +
> +	/* Power up the cells to read HW */
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(fdp1->dev);
> +
> +	hw_version = fdp1_read(fdp1, FD1_IP_INTDATA);
> +	switch (hw_version) {
> +	case FD1_IP_H3:
> +		dprintk(fdp1, "FDP1 Version R-Car H3\n");
> +		break;
> +	case FD1_IP_M3W:
> +		dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
> +		break;
> +	default:
> +		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
> +				hw_version);
> +	}
> +
> +	/* Allow the hw to sleep until an open call puts it to use */
> +	pm_runtime_put(fdp1->dev);
> +
> +	return 0;
> +
> +release_m2m:
> +	v4l2_m2m_release(fdp1->m2m_dev);
> +
> +unreg_dev:
> +	v4l2_device_unregister(&fdp1->v4l2_dev);
> +
> +vb2_allocator_rollback:
> +	vb2_dma_contig_cleanup_ctx(fdp1->alloc_ctx);
> +
> +	return ret;
> +}
> +
> +static int fdp1_remove(struct platform_device *pdev)
> +{
> +	struct fdp1_dev *fdp1 = platform_get_drvdata(pdev);
> +
> +	v4l2_m2m_release(fdp1->m2m_dev);
> +	video_unregister_device(&fdp1->vfd);
> +	v4l2_device_unregister(&fdp1->v4l2_dev);
> +	vb2_dma_contig_cleanup_ctx(fdp1->alloc_ctx);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static int fdp1_pm_runtime_suspend(struct device *dev)
> +{
> +	struct fdp1_dev *fdp1 = dev_get_drvdata(dev);
> +
> +	rcar_fcp_disable(fdp1->fcp);
> +
> +	return 0;
> +}
> +
> +static int fdp1_pm_runtime_resume(struct device *dev)
> +{
> +	struct fdp1_dev *fdp1 = dev_get_drvdata(dev);
> +
> +	/* Program in the static LUTs */
> +	fdp1_set_lut(fdp1);
> +
> +	return rcar_fcp_enable(fdp1->fcp);
> +}
> +
> +static const struct dev_pm_ops fdp1_pm_ops = {
> +	SET_RUNTIME_PM_OPS(fdp1_pm_runtime_suspend,
> +			   fdp1_pm_runtime_resume,
> +			   NULL)
> +};
> +
> +static const struct of_device_id fdp1_dt_ids[] = {
> +	{ .compatible = "renesas,fdp1" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, fdp1_dt_ids);
> +
> +static struct platform_driver fdp1_pdrv = {
> +	.probe		= fdp1_probe,
> +	.remove		= fdp1_remove,
> +	.driver		= {
> +		.name	= DRIVER_NAME,
> +		.of_match_table = fdp1_dt_ids,
> +		.pm	= &fdp1_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(fdp1_pdrv);
> +
> +MODULE_DESCRIPTION("Renesas R-Car Fine Display Processor Driver");
> +MODULE_AUTHOR("Kieran Bingham <kieran@bingham.xyz>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> 

Regards,

	Hans
