Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:34813 "EHLO
	nasmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcDSHqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2016 03:46:34 -0400
Subject: Re: [PATCH 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1460533460-32336-1-git-send-email-songjun.wu@atmel.com>
 <1460533460-32336-2-git-send-email-songjun.wu@atmel.com>
 <81160604.beJHM8QlLS@avalon>
CC: <g.liakhovetski@gmx.de>, <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Benoit Parrot" <bparrot@ti.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
From: "Wu, Songjun" <songjun.wu@atmel.com>
Message-ID: <5715E24F.8040906@atmel.com>
Date: Tue, 19 Apr 2016 15:46:23 +0800
MIME-Version: 1.0
In-Reply-To: <81160604.beJHM8QlLS@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/15/2016 00:21, Laurent Pinchart wrote:
> Hello Songjun,
>
> Thank you for the patch.
>
> On Wednesday 13 Apr 2016 15:44:19 Songjun Wu wrote:
>> Add driver for the Image Sensor Controller. It manages
>> incoming data from a parallel based CMOS/CCD sensor.
>> It has an internal image processor, also integrates a
>> triple channel direct memory access controller master
>> interface.
>>
>> Signed-off-by: Songjun Wu <songjun.wu@atmel.com>
>> ---
>>
>>   drivers/media/platform/Kconfig                |    1 +
>>   drivers/media/platform/Makefile               |    2 +
>>   drivers/media/platform/atmel/Kconfig          |    9 +
>>   drivers/media/platform/atmel/Makefile         |    3 +
>>   drivers/media/platform/atmel/atmel-isc-regs.h |  280 +++++
>>   drivers/media/platform/atmel/atmel-isc.c      | 1537 ++++++++++++++++++++++
>>   6 files changed, 1832 insertions(+)
>>   create mode 100644 drivers/media/platform/atmel/Kconfig
>>   create mode 100644 drivers/media/platform/atmel/Makefile
>>   create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>>   create mode 100644 drivers/media/platform/atmel/atmel-isc.c
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 201f5c2..1b50ed1 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -110,6 +110,7 @@ source "drivers/media/platform/exynos4-is/Kconfig"
>>   source "drivers/media/platform/s5p-tv/Kconfig"
>>   source "drivers/media/platform/am437x/Kconfig"
>>   source "drivers/media/platform/xilinx/Kconfig"
>> +source "drivers/media/platform/atmel/Kconfig"
>>
>>   config VIDEO_TI_CAL
>>   	tristate "TI CAL (Camera Adaptation Layer) driver"
>> diff --git a/drivers/media/platform/Makefile
>> b/drivers/media/platform/Makefile index bbb7bd1..ad8f471 100644
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -55,4 +55,6 @@ obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
>>
>>   obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
>>
>> +obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
>> +
>>   ccflags-y += -I$(srctree)/drivers/media/i2c
>> diff --git a/drivers/media/platform/atmel/Kconfig
>> b/drivers/media/platform/atmel/Kconfig new file mode 100644
>> index 0000000..5ebc4a6
>> --- /dev/null
>> +++ b/drivers/media/platform/atmel/Kconfig
>> @@ -0,0 +1,9 @@
>> +config VIDEO_ATMEL_ISC
>> +	tristate "ATMEL Image Sensor Controller (ISC) support"
>> +	depends on VIDEO_V4L2 && HAS_DMA
>> +	depends on ARCH_AT91 || COMPILE_TEST
>
> As commented separately, you're missing "depends on COMMON_CLK".
>
Accept, thank you.

>> +	select VIDEOBUF2_DMA_CONTIG
>> +	select REGMAP_MMIO
>> +	help
>> +	   This module makes the ATMEL Image Sensor Controller available
>> +	   as a v4l2 device.
>> \ No newline at end of file
>> diff --git a/drivers/media/platform/atmel/Makefile
>> b/drivers/media/platform/atmel/Makefile new file mode 100644
>> index 0000000..eb8cdbb
>> --- /dev/null
>> +++ b/drivers/media/platform/atmel/Makefile
>> @@ -0,0 +1,3 @@
>> +# Makefile for ATMEL ISC driver
>
> The makefile isn't limited to the ISC driver, even if that's the only one
> currently located in the atmel directory. The atmel-isi driver should be
> placed here when it will move away from soc-camera. I would just write
> "Makefile for Atmel drivers", or even remove the comment completely.
>
Accept.
atmel-isi driver will be added into this folder later.
I think "Makefile for Atmel drivers" is better.
Thank you.

>> +obj-$(CONFIG_VIDEO_ATMEL_ISC) += atmel-isc.o
>> diff --git a/drivers/media/platform/atmel/atmel-isc-regs.h
>> b/drivers/media/platform/atmel/atmel-isc-regs.h new file mode 100644
>> index 0000000..8be9e4a
>> --- /dev/null
>> +++ b/drivers/media/platform/atmel/atmel-isc-regs.h
>> @@ -0,0 +1,280 @@
>> +
>
> No need for a blank line here.
>
Accept, thank you.

>> +#ifndef __ATMEL_ISC_REGS_H
>> +#define __ATMEL_ISC_REGS_H
>> +
>> +#include <linux/bitops.h>
>
> [snip]
>
>> +/* ISC Clock Configuration Register */
>> +#define ISC_CLKCFG              0x00000024
>> +#define ISC_CLKCFG_DIV_SHIFT(n) (n*16)
>
> As n can be an expression, you should enclose it in parentheses, ((n)*16).
> Same for tall the macros below.
>
Accept, thank you.

>> +#define ISC_CLKCFG_DIV_MASK(n)  GENMASK((n*16 + 7), n*16)
>> +#define ISC_CLKCFG_SEL_SHIFT(n) (n*16 + 8)
>> +#define ISC_CLKCFG_SEL_MASK(n)  GENMASK((n*17 + 8), (n*16 + 8))
>> +
>
> [snip]
>
>> diff --git a/drivers/media/platform/atmel/atmel-isc.c
>> b/drivers/media/platform/atmel/atmel-isc.c new file mode 100644
>> index 0000000..4ffbfc9
>> --- /dev/null
>> +++ b/drivers/media/platform/atmel/atmel-isc.c
>> @@ -0,0 +1,1537 @@
>> +/*
>> + * Atmel Image Sensor Controller (ISC) driver
>> + *
>> + * Copyright (C) 2016 Atmel
>> + *
>> + * Author: Songjun Wu <songjun.wu@atmel.com>
>> + *
>> + * This program is free software; you may redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * Sensor-->PFE-->WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB-->RLP-->DMA
>> + *
>> + * ISC video pipeline integrates the following submodules:
>> + * PFE: Parallel Front End to sample the camera sensor input stream
>> + * WB:  Programmable white balance in the Bayer domain
>> + * CFA: Color filter array interpolation module
>> + * CC:  Programmable color correction
>> + * GAM: Gamma correction
>> + * CSC: Programmable color space conversion
>> + * CBC: Contrast and Brightness control
>> + * SUB: This module performs YCbCr444 to YCbCr420 chrominance subsampling
>> + * RLP: This module performs rounding, range limiting
>> + *      and packing of the incoming data
>> + */
>> +
>> +#include <linux/of.h>
>> +#include <linux/clk.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/delay.h>
>> +#include <linux/videodev2.h>
>
> Please sort the header file alphabetically, it helps locating duplicates.
>
Accept, thank you.

>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-of.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +
>> +#include "atmel-isc-regs.h"
>> +
>> +#define ATMEL_ISC_NAME	  "atmel_isc"
>> +
>> +#define ISC_MAX_BUF_NUM		VIDEO_MAX_FRAME
>> +#define ISC_MAX_SUPPORT_WIDTH   2592
>> +#define ISC_MAX_SUPPORT_HEIGHT  1944
>> +
>> +#define ISC_ISPCK_SOURCE_MAX    2
>> +#define ISC_MCK_SOURCE_MAX      3
>> +#define ISC_CLK_MAX_DIV		255
>> +
>> +#define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
>
> I'd make this a static inline function for additional type checking, and move
> it right after the struct isc_clk definition.
>
Accept, thank you.

>> +static u32 sensor_preferred;
>> +
>> +static DEFINE_SPINLOCK(isc_clk_lock);
>
> No global variables please, you should store these two in the isc_device
> structure.
>
Accept, it will be defined in the isc_device structure.
Thank you.

>> +enum isc_clk_id {
>> +	ISC_ISPCK = 0,
>> +	ISC_MCK = 1,
>> +};
>> +
>> +struct isc_clk {
>> +	struct clk_hw   hw;
>> +	struct clk      *clk;
>> +	struct regmap   *regmap;
>> +	spinlock_t      *lock;
>> +	enum isc_clk_id id;
>> +	u32		div;
>> +	u8		parent_id;
>> +};
>> +
>> +struct isc_buffer {
>> +	struct vb2_v4l2_buffer  vb;
>> +	struct list_head	list;
>> +};
>> +
>> +struct isc_subdev_entity {
>> +	struct v4l2_subdev		*sd;
>> +	struct v4l2_async_subdev	*asd;
>> +	struct v4l2_async_notifier      notifier;
>> +
>> +	u32 hsync_active;
>> +	u32 vsync_active;
>> +	u32 pclk_sample;
>> +
>> +	struct list_head list;
>> +};
>> +
>> +/*
>> + * struct isc_format - ISC media bus format information
>> + * @fourcc:		Fourcc code for this format
>> + * @isc_mbus_code:      V4L2 media bus format code if ISC is preferred
>> + * @sd_mbus_code:       V4L2 media bus format code if subdev is preferred
>> + * @bpp:		Bytes per pixel (when stored in memory)
>> + * @reg_sd_bps:		reg value for bits per sample if subdev is preferred
>> + *			(when transferred over a bus)
>> + * @reg_isc_bps:	reg value for bits per sample if ISC is preferred
>> + *			(when transferred over a bus)
>> + * @pipeline:		pipeline switch if ISC is preferred
>> + * @isc_support:	ISC can convert raw format to this format
>> + * @sd_support:		Subdev supports this format
>> + */
>> +struct isc_format {
>> +	u32	fourcc;
>> +	u32	isc_mbus_code;
>> +	u32	sd_mbus_code;
>> +
>> +	u8	bpp;
>> +
>> +	u32	reg_sd_bps;
>> +	u32	reg_isc_bps;
>> +
>> +	u32	reg_wb_cfg;
>> +	u32	reg_cfa_cfg;
>> +	u32	reg_rlp_mode;
>> +	u32	reg_dcfg_imode;
>> +	u32	reg_dctrl_dview;
>> +
>> +	u32	pipeline;
>> +
>> +	bool	isc_support;
>> +	bool	sd_support;
>> +};
>> +
>> +struct isc_device {
>> +	struct regmap		*regmap;
>> +	struct clk		*hclock;
>> +	struct clk		*ispck;
>> +	struct isc_clk		isc_clks[2];
>> +
>> +	struct device		*dev;
>> +	struct v4l2_device	v4l2_dev;
>> +	struct video_device	video_dev;
>> +
>> +	struct vb2_queue	vb2_vidq;
>> +	struct vb2_alloc_ctx	*alloc_ctx;
>> +
>> +	spinlock_t		dma_queue_lock;
>> +	struct list_head	dma_queue;
>> +	struct isc_buffer	*cur_frm;
>> +	unsigned int		sequence;
>> +	bool			stop;
>> +
>> +	struct v4l2_format	fmt;
>> +
>> +	struct isc_format	**user_formats;
>> +	int			num_user_formats;
>
> This can't be negative, you can make it an unsigned int.
>
Accept, thank you.

>> +	const struct isc_format	*current_fmt;
>> +
>> +	struct mutex		lock;
>> +
>> +	struct isc_subdev_entity	*current_subdev;
>> +	struct list_head		subdev_entities;
>> +};
>> +
>> +struct reg_mask {
>> +	u32 reg;
>> +	u32 mask;
>> +};
>> +
>> +/* WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB422-->SUB420 */
>> +const struct reg_mask pipeline_regs[] = {
>> +	{ ISC_WB_CTRL,  ISC_WB_CTRL_MASK },
>> +	{ ISC_CFA_CTRL, ISC_CFA_CTRL_MASK },
>> +	{ ISC_CC_CTRL,  ISC_CC_CTRL_MASK },
>> +	{ ISC_GAM_CTRL, ISC_GAM_CTRL_MASK | ISC_GAM_CTRL_ALL_CHAN_MASK },
>> +	{ ISC_CSC_CTRL, ISC_CSC_CTRL_MASK },
>> +	{ ISC_CBC_CTRL, ISC_CBC_CTRL_MASK },
>> +	{ ISC_SUB422_CTRL, ISC_SUB422_CTRL_MASK },
>> +	{ ISC_SUB420_CTRL, ISC_SUB420_CTRL_MASK }
>> +};
>> +
>> +#define RAW_FMT_INDEX_START	0
>> +#define RAW_FMT_INDEX_END	11
>> +#define ISC_FMT_INDEX_START	12
>> +#define ISC_FMT_INDEX_END	12
>> +
>> +/*
>> + * index(0~11):  raw formats.
>> + * index(12~12): the formats which can be converted from raw format by ISC.
>> + * index():      the formats which can only be provided by subdev.
>> + */
>> +static struct isc_format isc_formats[] = {
>> +{V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SBGGR8_1X8,
>> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_BGBG,
>> +ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
>> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +{V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
>> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_GBGB,
>> +ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
>> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +{V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SGRBG8_1X8,
>> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_GRGR,
>> +ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
>> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +{V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
>> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_RGRG,
>> +ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
>> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +
>> +{V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10,
>> MEDIA_BUS_FMT_SBGGR10_1X10, +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN,
>> ISC_WB_CFG_BAYCFG_BGBG, +ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT10,
>> ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +{V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10,
>> MEDIA_BUS_FMT_SGBRG10_1X10, +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN,
>> ISC_WB_CFG_BAYCFG_GBGB, +ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT10,
>> ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +{V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10,
>> MEDIA_BUS_FMT_SGRBG10_1X10, +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN,
>> ISC_WB_CFG_BAYCFG_GRGR, +ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT10,
>> ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +{V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10,
>> MEDIA_BUS_FMT_SRGGB10_1X10, +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN,
>> ISC_WB_CFG_BAYCFG_RGRG, +ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT10,
>> ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
>> +
>> +{V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12,
>> MEDIA_BUS_FMT_SBGGR12_1X12, +2, ISC_PFG_CFG0_BPS_TWELVE,
>> ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_BGBG, +ISC_CFA_CFG_BAY_BGBG,
>> ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED,
>> 0x0, false, false},
>> +{V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12,
>> MEDIA_BUS_FMT_SGBRG12_1X12, +2, ISC_PFG_CFG0_BPS_TWELVE,
>> ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_GBGB, +ISC_CFA_CFG_BAY_GBGB,
>> ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED,
>> 0x0, false, false},
>> +{V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12,
>> MEDIA_BUS_FMT_SGRBG12_1X12, +2, ISC_PFG_CFG0_BPS_TWELVE,
>> ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_GRGR, +ISC_CFA_CFG_BAY_GRGR,
>> ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED,
>> 0x0, false, false},
>> +{V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12,
>> MEDIA_BUS_FMT_SRGGB12_1X12, +2, ISC_PFG_CFG0_BPS_TWELVE,
>> ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_RGRG, +ISC_CFA_CFG_BAY_RGRG,
>> ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16, +ISC_DCTRL_DVIEW_PACKED,
>> 0x0, false, false},
>> +
>> +{V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, MEDIA_BUS_FMT_YUYV8_2X8,
>> +2, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_BGBG,
>> +ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
>> +ISC_DCTRL_DVIEW_PACKED, 0x7f, false, false},
>> +};
>> +
>> +static int isc_clk_enable(struct clk_hw *hw)
>> +{
>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>> +	u32 id = isc_clk->id;
>> +	struct regmap *regmap = isc_clk->regmap;
>> +	unsigned long flags;
>> +	u32 sr_val;
>> +
>> +	pr_debug("ISC CLK: %s, div = %d, parent id = %d\n",
>> +		 __func__, isc_clk->div, isc_clk->parent_id);
>
> Please use dev_dbg() instead of pr_debug(). Same comment for all the other
> pr_*() calls below.
>
Accept, thank you.

>> +	spin_lock_irqsave(isc_clk->lock, flags);
>> +
>> +	regmap_update_bits(regmap, ISC_CLKCFG,
>> +			   ISC_CLKCFG_DIV_MASK(id) | ISC_CLKCFG_SEL_MASK(id),
>> +			   (isc_clk->div << ISC_CLKCFG_DIV_SHIFT(id)) |
>> +			   (isc_clk->parent_id << ISC_CLKCFG_SEL_SHIFT(id)));
>> +
>> +	regmap_read(regmap, ISC_CLKSR, &sr_val);
>> +	while (sr_val & ISC_CLKSR_SIP_PROGRESS) {
>> +		cpu_relax();
>> +		regmap_read(regmap, ISC_CLKSR, &sr_val);
>> +	}
>
> A busy loop while holding a spinlock ? Ouch... You should at least set a
> higher bound on the number of iterations.
>
Accept, after the clock register is written, we need wait the SIP flag 
before the clock register is written again, the time is very short.
I think the number of iterations will be added when the loop is under 
spinlock.
Thank you.

>> +	regmap_update_bits(regmap, ISC_CLKEN,
>> +			   ISC_CLKEN_EN_MASK(id),
>> +			   ISC_CLKEN_EN << ISC_CLKEN_EN_SHIFT(id));
>> +
>> +	spin_unlock_irqrestore(isc_clk->lock, flags);
>> +
>> +	return 0;
>> +}
>> +
>> +static void isc_clk_disable(struct clk_hw *hw)
>> +{
>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>> +	u32 id = isc_clk->id;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(isc_clk->lock, flags);
>> +
>> +	regmap_update_bits(isc_clk->regmap, ISC_CLKDIS,
>> +			   ISC_CLKDIS_DIS_MASK(id),
>> +			   ISC_CLKDIS_DIS << ISC_CLKDIS_DIS_SHIFT(id));
>> +
>> +	spin_unlock_irqrestore(isc_clk->lock, flags);
>> +}
>> +
>> +static int isc_clk_is_enabled(struct clk_hw *hw)
>> +{
>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>> +	unsigned long flags;
>> +	u32 status;
>> +
>> +	spin_lock_irqsave(isc_clk->lock, flags);
>> +	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
>> +	spin_unlock_irqrestore(isc_clk->lock, flags);
>> +
>> +	return status & ISC_CLKSR_CLK_MASK(isc_clk->id) ? 1 : 0;
>> +}
>> +
>> +static unsigned long
>> +isc_clk_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
>> +{
>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>> +
>> +	return DIV_ROUND_CLOSEST(parent_rate, isc_clk->div + 1);
>> +}
>> +
>> +static int isc_clk_determine_rate(struct clk_hw *hw,
>> +				  struct clk_rate_request *req)
>> +{
>> +	struct clk_hw *parent = NULL;
>> +	long best_rate = -EINVAL;
>> +	unsigned long tmp_rate, parent_rate;
>> +	u32 div;
>> +	int tmp_diff, best_diff = -1;
>
> tmp in variable names is frowned upon, you can call them rate and diff instead
> of tmp_rate and tmp_diff. I would also declare those two variables inside the
> inner for loop, ans that's where they're used. Similarly, you can declare
> parent and best_diff inside the outer for loop.
>
Accept, thank you.

>> +	int i;
>
> i never takes negative values, you can make it an unsigned int.
>
Accept, thank you.

>> +	for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
>> +		parent = clk_hw_get_parent_by_index(hw, i);
>> +		if (!parent)
>> +			continue;
>> +
>> +		parent_rate = clk_hw_get_rate(parent);
>> +		if (!parent_rate)
>> +			continue;
>> +
>> +		for (div = 1; div < ISC_CLK_MAX_DIV + 2; div++) {
>> +			tmp_rate = DIV_ROUND_CLOSEST(parent_rate, div);
>> +			tmp_diff = abs(req->rate - tmp_rate);
>> +
>> +			if (best_diff < 0 || best_diff > tmp_diff) {
>> +				best_rate = tmp_rate;
>> +				best_diff = tmp_diff;
>> +				req->best_parent_rate = parent_rate;
>> +				req->best_parent_hw = parent;
>> +			}
>> +
>> +			if (!best_diff || tmp_rate < req->rate)
>> +				break;
>> +		}
>> +
>> +		if (!best_diff)
>> +			break;
>> +	}
>> +
>> +	pr_debug("ISC CLK: %s, best_rate = %ld, parent clk: %s @ %ld\n",
>> +		 __func__, best_rate,
>> +		 __clk_get_name((req->best_parent_hw)->clk),
>> +		 req->best_parent_rate);
>> +
>> +	if (best_rate < 0)
>> +		return best_rate;
>> +
>> +	req->rate = best_rate;
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_clk_set_parent(struct clk_hw *hw, u8 index)
>> +{
>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>> +
>> +	if (index >= clk_hw_get_num_parents(hw))
>> +		return -EINVAL;
>> +
>> +	isc_clk->parent_id = index;
>> +
>> +	return 0;
>> +}
>> +
>> +static u8 isc_clk_get_parent(struct clk_hw *hw)
>> +{
>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>> +
>> +	return isc_clk->parent_id;
>> +}
>> +
>> +static int isc_clk_set_rate(struct clk_hw *hw,
>> +			    unsigned long rate,
>> +			    unsigned long parent_rate)
>> +{
>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>> +	u32 div;
>> +
>> +	if (!rate)
>> +		return -EINVAL;
>> +
>> +	div = DIV_ROUND_CLOSEST(parent_rate, rate);
>> +	if ((div > (ISC_CLK_MAX_DIV + 1)) || !div)
>> +		return -EINVAL;
>> +
>> +	isc_clk->div = div - 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct clk_ops isc_clk_ops = {
>> +	.enable		= isc_clk_enable,
>> +	.disable	= isc_clk_disable,
>> +	.is_enabled	= isc_clk_is_enabled,
>> +	.recalc_rate	= isc_clk_recalc_rate,
>> +	.determine_rate	= isc_clk_determine_rate,
>> +	.set_parent	= isc_clk_set_parent,
>> +	.get_parent	= isc_clk_get_parent,
>> +	.set_rate	= isc_clk_set_rate,
>> +};
>> +
>> +static int isc_clk_register(struct isc_device *isc,
>> +			    spinlock_t *lock, struct device_node *np)
>> +{
>> +	struct regmap *regmap = isc->regmap;
>> +	struct isc_clk *isc_clk;
>> +	struct clk_init_data init;
>> +	const char *clk_name = np->name;
>> +	const char **parent_names;
>> +	u32 id;
>> +	int num_parents, source_max, ret = 0;
>> +
>> +	if (of_property_read_u32(np, "reg", &id))
>> +		return -EINVAL;
>> +
>> +	switch (id) {
>> +	case ISC_ISPCK:
>> +		source_max = ISC_ISPCK_SOURCE_MAX;
>> +		break;
>> +	case ISC_MCK:
>> +		source_max = ISC_MCK_SOURCE_MAX;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	num_parents = of_clk_get_parent_count(np);
>> +	if ((num_parents < 1) || (num_parents > source_max))
>
> No need for the inner parentheses.
>
Accept, thank you.

>> +		return -EINVAL;
>> +
>> +	parent_names = kcalloc(num_parents, sizeof(char *), GFP_KERNEL);
>> +	if (!parent_names)
>> +		return -ENOMEM;
>> +
>> +	of_clk_parent_fill(np, parent_names, num_parents);
>> +
>> +	init.parent_names	= parent_names;
>> +	init.num_parents	= num_parents;
>> +	init.name		= clk_name;
>> +	init.ops		= &isc_clk_ops;
>> +	init.flags		= CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
>> +
>> +	isc_clk = &isc->isc_clks[id];
>> +	isc_clk->hw.init	= &init;
>> +	isc_clk->regmap		= regmap;
>> +	isc_clk->lock		= lock;
>> +	isc_clk->id		= id;
>> +
>> +	isc_clk->clk = clk_register(NULL, &isc_clk->hw);
>> +	if (!IS_ERR(isc_clk->clk))
>> +		of_clk_add_provider(np, of_clk_src_simple_get, isc_clk->clk);
>> +	else {
>> +		dev_err(isc->dev, "%s: clock register fail\n", clk_name);
>> +		ret = PTR_ERR(isc_clk->clk);
>> +		goto free_parent_names;
>> +	}
>> +
>> +free_parent_names:
>> +	kfree(parent_names);
>> +	return ret;
>> +}
>> +
>> +static int isc_clk_init(struct isc_device *isc)
>> +{
>> +	struct device_node *np = of_get_child_by_name(isc->dev->of_node,
>> +						      "clk_in_isc");
>
> Do you really need the clk_in_isc DT node ? I would have assumed that the
> clock topology inside the ISC is fixed, and that it would be enough to just
> specify the three parent clocks in the ISC DT node and create the two internal
> clocks in the driver without needing a DT description.
>
Accept, your suggestion is very reasonable, I will remove the clock DT node.
Thank you.

>> +	struct device_node *childnp;
>> +	int i, ret;
>
> i only takes positive values, you can make it an unsigned int.
>
Accept, thank you.

>> +
>> +	if (!np) {
>> +		dev_err(isc->dev, "No clock node\n");
>> +		return -ENOENT;
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(isc->isc_clks); i++)
>> +		isc->isc_clks[i].clk = ERR_PTR(-EINVAL);
>> +
>> +	for_each_child_of_node(np, childnp) {
>> +		ret = isc_clk_register(isc, &isc_clk_lock, childnp);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void isc_clk_cleanup(struct isc_device *isc)
>> +{
>> +	struct device_node *np = of_get_child_by_name(isc->dev->of_node,
>> +						      "clk_in_isc");
>> +	struct device_node *childnp;
>> +	unsigned int i;
>> +
>> +	if (!np)
>> +		return;
>> +
>> +	for_each_child_of_node(np, childnp)
>> +		of_clk_del_provider(childnp);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(isc->isc_clks); i++) {
>> +		struct isc_clk *isc_clk = &isc->isc_clks[i];
>> +
>> +		if (!IS_ERR(isc_clk->clk))
>> +			clk_unregister(isc_clk->clk);
>> +	}
>> +}
>> +
>> +static int isc_parse_dt(struct device *dev, struct isc_device *isc)
>> +{
>> +	struct device_node *np = dev->of_node;
>> +	struct device_node *epn = NULL, *rem;
>> +	struct v4l2_of_endpoint v4l2_epn;
>> +	struct isc_subdev_entity *subdev_entity;
>> +	unsigned int flags;
>> +	int i, ret = 0;
>
> i is assigned by never used, you can remove it.
>
Accept, thank you.

>> +	if (!np) {
>> +		dev_err(dev, "only supports device tree\n");
>> +		return -EINVAL;
>> +	}
>
> Can this happen ?
>
It can be removed, if no isc np, the isc device will not be created.
Thank you.

>> +	ret = of_property_read_u32(np, "atmel,sensor-preferred",
>> +				   &sensor_preferred);
>> +	if (ret)
>> +		sensor_preferred = 1;
>> +
>> +	INIT_LIST_HEAD(&isc->subdev_entities);
>> +
>> +	for (i = 0; ; i++) {
>> +		epn = of_graph_get_next_endpoint(np, epn);
>> +		if (!epn)
>> +			break;
>> +
>> +		rem = of_graph_get_remote_port_parent(epn);
>> +		if (!rem) {
>> +			dev_notice(dev, "Remote device at %s not found\n",
>> +			of_node_full_name(epn));
>
> Please fix the indentation.
>
Accept, thank you.

>> +			continue;
>> +		}
>> +
>> +		ret = v4l2_of_parse_endpoint(epn, &v4l2_epn);
>> +		if (ret) {
>> +			of_node_put(rem);
>> +			ret = -EINVAL;
>> +			dev_err(dev, "Could not parse the endpoint\n");
>> +			break;
>> +		}
>> +
>> +		subdev_entity = devm_kzalloc(dev,
>> +					  sizeof(*subdev_entity), GFP_KERNEL);
>> +		if (subdev_entity == NULL) {
>> +			of_node_put(rem);
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
>> +
>> +		subdev_entity->asd = devm_kzalloc(dev,
>> +				     sizeof(*subdev_entity->asd), GFP_KERNEL);
>> +		if (subdev_entity->asd == NULL) {
>> +			of_node_put(rem);
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
>> +
>> +		flags = v4l2_epn.bus.parallel.flags;
>> +
>> +		if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
>> +			subdev_entity->hsync_active = ISC_PFE_CFG0_HPOL_LOW;
>> +		else
>> +			subdev_entity->hsync_active = ISC_PFE_CFG0_HPOL_HIGH;
>> +
>> +		if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
>> +			subdev_entity->vsync_active = ISC_PFE_CFG0_VPOL_LOW;
>> +		else
>> +			subdev_entity->vsync_active = ISC_PFE_CFG0_VPOL_HIGH;
>> +
>> +		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>> +			subdev_entity->pclk_sample = ISC_PFE_CFG0_PPOL_LOW;
>> +		else
>> +			subdev_entity->pclk_sample = ISC_PFE_CFG0_PPOL_HIGH;
>
> Instead of storing the flags in three separate variables that you combine when
> writing the ISC_PFE_CFG0 register, you could store them in a single variable
> (possibly named pfe_cfg0).
>
Accept, thank you.

>> +
>> +		subdev_entity->asd->match_type = V4L2_ASYNC_MATCH_OF;
>> +		subdev_entity->asd->match.of.node = rem;
>> +		list_add_tail(&subdev_entity->list, &isc->subdev_entities);
>> +	}
>> +
>> +	of_node_put(epn);
>> +	return ret;
>> +}
>
> I would move the DT parsing function down right above the probe function, as
> they're logically related.
>
Accept, thank you.

>> +static int isc_queue_setup(struct vb2_queue *vq,
>> +			   unsigned int *nbuffers, unsigned int *nplanes,
>> +			   unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +	struct isc_device *isc = vb2_get_drv_priv(vq);
>> +
>> +	*nplanes = 1;
>> +	sizes[0] = isc->fmt.fmt.pix.sizeimage;
>> +	alloc_ctxs[0] = isc->alloc_ctx;
>
> To support VIDIOC_CREATE_BUFS you need to take implement the following (from
> include/media/videobuf2-core.h).
>
Accept, thank you.
I will add the code to support VIDIOC_CREATE_BUFS.

>   *                  When called from VIDIOC_REQBUFS, *num_planes == 0, the
>   *                  driver has to use the currently configured format to
>   *                  determine the plane sizes and *num_buffers is the total
>   *                  number of buffers that are being allocated. When called
>   *                  from VIDIOC_CREATE_BUFS, *num_planes != 0 and it
>   *                  describes the requested number of planes and sizes[]
>   *                  contains the requested plane sizes. If either
>   *                  *num_planes or the requested sizes are invalid callback
>   *                  must return -EINVAL. In this case *num_buffers are
>   *                  being allocated additionally to q->num_buffers.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct isc_device *isc = vb2_get_drv_priv(vb->vb2_queue);
>> +	unsigned long size = isc->fmt.fmt.pix.sizeimage;
>> +
>> +	if (vb2_plane_size(vb, 0) < size) {
>> +		v4l2_err(&isc->v4l2_dev, "buffer too small (%lu < %lu)\n",
>> +			 vb2_plane_size(vb, 0), size);
>> +		return -EINVAL;
>> +	}
>> +
>> +	vb2_set_plane_payload(vb, 0, size);
>> +
>> +	vbuf->field = isc->fmt.fmt.pix.field;
>> +
>> +	return 0;
>> +}
>> +
>> +static inline void isc_start_dma(struct regmap *regmap,
>> +				 struct isc_buffer *frm, u32 dview)
>> +{
>> +	unsigned long addr;
>> +
>> +	addr = vb2_dma_contig_plane_dma_addr(&frm->vb.vb2_buf, 0);
>
> The function returns a dma_addr_t, let's use that for the variable type.
>
Accept, thank you.

>> +	regmap_write(regmap, ISC_DCTRL, ISC_DCTRL_IE_IS | dview);
>> +	regmap_write(regmap, ISC_DAD0, addr);
>> +	regmap_update_bits(regmap, ISC_CTRLEN,
>> +			   ISC_CTRLEN_CAPTURE_MASK, ISC_CTRLEN_CAPTURE);
>> +}
>> +
>> +static int isc_start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +	struct isc_device *isc = vb2_get_drv_priv(vq);
>> +	struct regmap *regmap = isc->regmap;
>> +	struct isc_buffer *buf, *tmp;
>> +	unsigned long flags;
>> +	int ret;
>> +
>> +	/* Enable stream on the sub device */
>> +	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 1);
>> +	if (ret && (ret != -ENOIOCTLCMD)) {
>
> No need for the inner parentheses.
>
Accept, thank you.

>> +		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev\n");
>> +		goto err;
>> +	}
>> +
>> +	/* Enable DMA interrupt */
>> +	regmap_update_bits(regmap, ISC_INTEN,
>> +			   ISC_INTEN_DDONE_MASK, ISC_INTEN_DDONE);
>> +
>> +	spin_lock_irqsave(&isc->dma_queue_lock, flags);
>> +
>> +	isc->sequence = 0;
>> +	isc->stop = false;
>> +
>> +	isc->cur_frm = list_first_entry(&isc->dma_queue,
>> +					struct isc_buffer, list);
>> +	list_del(&isc->cur_frm->list);
>> +
>> +	isc_start_dma(regmap, isc->cur_frm, isc->current_fmt->reg_dctrl_dview);
>> +
>> +	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
>> +
>> +	return 0;
>> +
>> +err:
>> +	spin_lock_irqsave(&isc->dma_queue_lock, flags);
>> +	list_for_each_entry_safe(buf, tmp, &isc->dma_queue, list) {
>> +		list_del(&buf->list);
>> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
>> +	}
>
> Slight optimization, you could remove the list_del call, turn
> list_for_each_entry_safe into list_for_each entry, and add a
> INIT_LIST_HEAD(&isc->dma_queue) after the loop. Same in the next function.
>
Accept, thank you.

>> +	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
>> +
>> +	return ret;
>> +}
>> +
>> +static void isc_stop_streaming(struct vb2_queue *vq)
>> +{
>> +	struct isc_device *isc = vb2_get_drv_priv(vq);
>> +	struct regmap *regmap = isc->regmap;
>> +	unsigned long flags;
>> +	struct isc_buffer *buf, *tmp;
>> +	int ret;
>> +	u32 val;
>> +
>> +	isc->stop = true;
>> +
>> +	/* Wait until the end of the current frame */
>> +	regmap_read(regmap, ISC_CTRLSR, &val);
>> +	while (val & ISC_CTRLSR_CAPTURE) {
>> +		usleep_range(1000, 2000);
>> +		regmap_read(regmap, ISC_CTRLSR, &val);
>> +	}
>
> Can't you synchronize with the frame end interrupt  instead of using a busy
> loop ? The code here doesn't guarantee that your frame end interrupt won't
> race you.
>
The capture will be disabled automatically when a frame capture is 
completed. When 'isc->stop' is set to true, the new frame capture will 
not be enabled in the frame end interrupt, then the capture is disabled 
automatically, we can synchronize the capture status by loop reading the 
capture status register in stop_streaming function. If the frame list is 
empty, the frame end interrupt will not be triggered, if we want to 
synchronize with the frame end interrupt, it will not be synchronized 
forever.

Maybe my understanding is not correct. What's your opinion?

>> +	/* Disable DMA interrupt */
>> +	regmap_update_bits(regmap, ISC_INTDIS,
>> +			   ISC_INTDIS_DDONE_MASK, ISC_INTDIS_DDONE);
>> +
>> +	/* Disable stream on the sub device */
>> +	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 0);
>> +	if (ret && (ret != -ENOIOCTLCMD))
>> +		v4l2_err(&isc->v4l2_dev, "stream off failed in subdev\n");
>> +
>> +	/* Release all active buffers */
>> +	spin_lock_irqsave(&isc->dma_queue_lock, flags);
>> +	list_for_each_entry_safe(buf, tmp, &isc->dma_queue, list) {
>> +		list_del(&buf->list);
>> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +	}
>> +	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
>> +}
>> +
>> +static void isc_buffer_queue(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct isc_buffer *buf = container_of(vbuf, struct isc_buffer, vb);
>> +	struct isc_device *isc = vb2_get_drv_priv(vb->vb2_queue);
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&isc->dma_queue_lock, flags);
>> +	list_add_tail(&buf->list, &isc->dma_queue);
>> +	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
>> +}
>> +
>> +static struct vb2_ops isc_vb2_ops = {
>> +	.queue_setup		= isc_queue_setup,
>> +	.wait_prepare		= vb2_ops_wait_prepare,
>> +	.wait_finish		= vb2_ops_wait_finish,
>> +	.buf_prepare		= isc_buffer_prepare,
>> +	.start_streaming	= isc_start_streaming,
>> +	.stop_streaming		= isc_stop_streaming,
>> +	.buf_queue		= isc_buffer_queue,
>> +};
>> +
>> +static int isc_open(struct file *file)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +	struct v4l2_subdev *sd = isc->current_subdev->sd;
>> +	int ret;
>> +	u32 val;
>> +
>> +	if (mutex_lock_interruptible(&isc->lock))
>> +		return -ERESTARTSYS;
>> +
>> +	ret = v4l2_fh_open(file);
>> +	if (ret < 0)
>> +		goto unlock;
>> +
>> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
>> +	if ((ret < 0) && (ret != -ENOIOCTLCMD))
>
> No need for inner parentheses.
>
Acceopt, thank you.

>> +		goto unlock;
>> +	else
>> +		ret = 0;
>> +
>> +	/* Clean the interrupt status register */
>> +	regmap_read(isc->regmap, ISC_INTSR, &val);
>> +
>> +	clk_prepare_enable(isc->hclock);
>> +	clk_prepare_enable(isc->ispck);
>
> You need to check the return value of those two functions (which would remove
> the need to set ret to 0 above). A possibly good option would be to implement
> runtime PM support and move clock enable/disable (and possible the s_power
> call) to the runtime PM resume/suspend handlers.
>
Accept. Runtime PM feature will be added.
Thank you.

>> +
>> +unlock:
>> +	mutex_unlock(&isc->lock);
>> +	return ret;
>> +}
>> +
>> +static int isc_release(struct file *file)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +	struct v4l2_subdev *sd = isc->current_subdev->sd;
>> +	int ret;
>> +
>> +	mutex_lock(&isc->lock);
>> +
>> +	ret = _vb2_fop_release(file, NULL);
>> +
>> +	v4l2_subdev_call(sd, core, s_power, 0);
>> +
>> +	clk_disable_unprepare(isc->ispck);
>> +	clk_disable_unprepare(isc->hclock);
>> +
>> +	mutex_unlock(&isc->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_file_operations isc_fops = {
>> +	.owner		= THIS_MODULE,
>> +	.open		= isc_open,
>> +	.release	= isc_release,
>> +	.unlocked_ioctl	= video_ioctl2,
>> +	.read		= vb2_fop_read,
>> +	.mmap		= vb2_fop_mmap,
>> +	.poll		= vb2_fop_poll,
>> +};
>> +
>> +static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
>> +{
>> +	if ((sensor_preferred && isc_fmt->sd_support) ||
>> +	    !isc_fmt->isc_support)
>> +		return true;
>> +	else
>> +		return false;
>> +}
>> +
>> +static int isc_querycap(struct file *file, void *priv,
>> +			struct v4l2_capability *cap)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +
>> +	strcpy(cap->driver, ATMEL_ISC_NAME);
>> +	strcpy(cap->card, "Atmel Image Sensor Controller");
>> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
>> +		 "platform:%s", isc->v4l2_dev.name);
>> +
>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_enum_fmt_vid_cap(struct file *file, void *priv,
>> +				struct v4l2_fmtdesc *f)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +	u32 index = f->index;
>> +
>> +	if (index >= isc->num_user_formats)
>> +		return -EINVAL;
>> +
>> +	f->pixelformat = isc->user_formats[index]->fourcc;
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_g_fmt_vid_cap(struct file *file, void *priv,
>> +			     struct v4l2_format *fmt)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +
>> +	*fmt = isc->fmt;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
>> +						unsigned int fourcc)
>> +{
>> +	int num_formats = isc->num_user_formats;
>
> unsigned int here too.
>
Accept, thank you.

>> +	struct isc_format *fmt;
>> +	int i;
>
> And here.
>
Accept, thank you.

>> +
>> +	for (i = 0; i < num_formats; i++) {
>> +		fmt = isc->user_formats[i];
>> +		if (fmt->fourcc == fourcc)
>> +			return fmt;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
>> +		       struct isc_format **current_fmt, u32 *code)
>> +{
>> +	struct isc_format *isc_fmt;
>> +	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
>> +	struct v4l2_subdev_pad_config pad_cfg;
>> +	struct v4l2_subdev_format format = {
>> +		.which = V4L2_SUBDEV_FORMAT_TRY,
>> +	};
>> +	u32 mbus_code;
>> +	int ret;
>> +
>> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	isc_fmt = find_format_by_fourcc(isc, pixfmt->pixelformat);
>> +	if (!isc_fmt) {
>> +		v4l2_warn(&isc->v4l2_dev, "Format 0x%x not found\n",
>> +			  pixfmt->pixelformat);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Limit to Atmel ISC hardware capabilities */
>> +	if (pixfmt->width > ISC_MAX_SUPPORT_WIDTH)
>> +		pixfmt->width = ISC_MAX_SUPPORT_WIDTH;
>> +	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
>> +		pixfmt->height = ISC_MAX_SUPPORT_HEIGHT;
>> +
>> +	if (sensor_is_preferred(isc_fmt))
>> +		mbus_code = isc_fmt->sd_mbus_code;
>> +	else
>> +		mbus_code = isc_fmt->isc_mbus_code;
>> +
>> +	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
>
> Please have a look at the "[media] v4l: subdev: Add pad config allocator and
> init" patch that just got merged, it should help you allocate your
> v4l2_subdev_pad_config properly.
>
Accept.
The 'v4l2_subdev_alloc_pad_config' will be called to init pad config 
allocator.
But it's just got merged, in my branch, it does not exist yet. Do I need 
modified my code, and submit all the code again?
Could you give the correct git address?
Thank you.

>> +	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
>> +			       &pad_cfg, &format);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	v4l2_fill_pix_format(pixfmt, &format.format);
>> +
>> +	switch (pixfmt->field) {
>> +	case V4L2_FIELD_ANY:
>> +	case V4L2_FIELD_NONE:
>> +		break;
>> +	default:
>> +		v4l2_err(&isc->v4l2_dev, "Field type %d unsupported.\n",
>> +			 pixfmt->field);
>> +		return -EINVAL;
>> +	}
>> +
>> +	pixfmt->bytesperline = pixfmt->width * isc_fmt->bpp;
>> +	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
>> +
>> +	if (current_fmt)
>> +		*current_fmt = isc_fmt;
>> +
>> +	if (code)
>> +		*code = mbus_code;
>> +
>> +	return 0;
>> +}
>> +
>> +static void isc_set_pipeline(struct regmap *regmap, u32 pipeline)
>> +{
>> +	const struct reg_mask *reg = &pipeline_regs[0];
>> +	u32 val;
>> +	int i;
>
> unsigned int.
>
Accept, thank you.

>> +
>> +	for (i = 0; i < ARRAY_SIZE(pipeline_regs); i++) {
>> +		if (pipeline & BIT(i))
>> +			val = reg->mask;
>> +		else
>> +			val = 0;
>> +
>> +		regmap_update_bits(regmap, reg->reg, reg->mask, val);
>> +
>> +		reg++;
>> +	}
>> +}
>> +
>> +static void isc_set_format(struct isc_device *isc)
>> +{
>> +	struct regmap *regmap = isc->regmap;
>> +	const struct isc_format *current_fmt = isc->current_fmt;
>> +	struct isc_subdev_entity *subdev = isc->current_subdev;
>> +	u32 pipeline, val, mask;
>> +
>> +	if (sensor_is_preferred(current_fmt)) {
>> +		val = current_fmt->reg_sd_bps;
>> +		pipeline = 0x0;
>> +	} else {
>> +		val = current_fmt->reg_isc_bps;
>> +		pipeline = current_fmt->pipeline;
>> +
>> +		regmap_update_bits(regmap, ISC_WB_CFG, ISC_WB_CFG_BAYCFG_MASK,
>> +				   current_fmt->reg_wb_cfg);
>> +		regmap_update_bits(regmap, ISC_CFA_CFG, ISC_CFA_CFG_BAY_MASK,
>> +				   current_fmt->reg_cfa_cfg);
>> +	}
>> +
>> +	val |= subdev->hsync_active | subdev->vsync_active |
>> +	       subdev->pclk_sample | ISC_PFE_CFG0_MODE_PROGRESSIVE;
>> +	mask = ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_MASK |
>> +	       ISC_PFE_CFG0_VPOL_MASK | ISC_PFE_CFG0_PPOL_MASK |
>> +	       ISC_PFE_CFG0_MODE_MASK;
>> +
>> +	regmap_update_bits(regmap, ISC_PFE_CFG0, mask, val);
>> +
>> +	regmap_update_bits(regmap, ISC_RLP_CFG, ISC_RLP_CFG_MODE_MASK,
>> +			   current_fmt->reg_rlp_mode);
>> +
>> +	regmap_update_bits(regmap, ISC_DCFG, ISC_DCFG_IMODE_MASK,
>> +			   current_fmt->reg_dcfg_imode);
>> +
>> +	isc_set_pipeline(regmap, pipeline);
>> +
>> +	/* Update profile */
>> +	regmap_update_bits(regmap, ISC_CTRLEN,
>> +			   ISC_CTRLEN_UPPRO_MASK, ISC_CTRLEN_UPPRO);
>> +
>> +	regmap_read(regmap, ISC_CTRLSR, &val);
>> +	while (val & ISC_CTRLSR_UPPRO) {
>> +		cpu_relax();
>> +		regmap_read(regmap, ISC_CTRLSR, &val);
>> +	}
>
> You need an exit condition here too in case the hardware gets stuck for some
> reason. It shouldn't happen in theory, and always does in practice :-)
>
Accept, I will add the number of iterations or a timer. Do you think 
which is better?
Thank you.

>> +}
>> +
>> +static int isc_s_fmt_vid_cap(struct file *file, void *priv,
>> +			     struct v4l2_format *f)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +	struct v4l2_subdev_format format = {
>> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>> +	};
>> +	struct isc_format *current_fmt;
>> +	int ret;
>> +	u32 mbus_code;
>> +
>> +	ret = isc_try_fmt(isc, f, &current_fmt, &mbus_code);
>> +	if (ret)
>> +		return ret;
>> +
>> +	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, mbus_code);
>> +	ret = v4l2_subdev_call(isc->current_subdev->sd, pad,
>> +			       set_fmt, NULL, &format);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	isc->fmt = *f;
>> +	isc->current_fmt = current_fmt;
>> +
>> +	isc_set_format(isc);
>
> I would move hardware setup to streamon time. You also need locking here to
> refuse format modification during streaming.
>
Accept. I will move the hardware setup to streamon time, then the format 
modification will not happen during the streaming.
Thank you.

>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_try_fmt_vid_cap(struct file *file, void *priv,
>> +			       struct v4l2_format *f)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +
>> +	return isc_try_fmt(isc, f, NULL, NULL);
>> +}
>> +
>> +static int isc_enum_input(struct file *file, void *priv,
>> +			  struct v4l2_input *inp)
>> +{
>> +	if (inp->index != 0)
>> +		return -EINVAL;
>> +
>> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
>> +	inp->std = 0;
>> +	strcpy(inp->name, "Camera");
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_g_input(struct file *file, void *priv, unsigned int *i)
>> +{
>> +	*i = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_s_input(struct file *file, void *priv, unsigned int i)
>> +{
>> +	if (i > 0)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_g_parm(struct file *file, void *fh, struct v4l2_streamparm
>> *a)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +	int ret;
>> +
>> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	ret = v4l2_subdev_call(isc->current_subdev->sd, video, g_parm, a);
>> +	if (ret == -ENOIOCTLCMD)
>> +		ret = 0;
>> +
>> +	return ret;
>> +}
>> +
>> +static int isc_s_parm(struct file *file, void *fh, struct v4l2_streamparm
>> *a)
>> +{
>> +	struct isc_device *isc = video_drvdata(file);
>> +	int ret;
>> +
>> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_parm, a);
>> +	if (ret == -ENOIOCTLCMD)
>> +		ret = 0;
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops isc_ioctl_ops = {
>> +	.vidioc_querycap		= isc_querycap,
>> +	.vidioc_enum_fmt_vid_cap	= isc_enum_fmt_vid_cap,
>> +	.vidioc_g_fmt_vid_cap		= isc_g_fmt_vid_cap,
>> +	.vidioc_s_fmt_vid_cap		= isc_s_fmt_vid_cap,
>> +	.vidioc_try_fmt_vid_cap		= isc_try_fmt_vid_cap,
>> +
>> +	.vidioc_enum_input		= isc_enum_input,
>> +	.vidioc_g_input			= isc_g_input,
>> +	.vidioc_s_input			= isc_s_input,
>> +
>> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
>> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
>> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
>> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
>> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
>> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
>> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
>> +	.vidioc_streamon		= vb2_ioctl_streamon,
>> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
>> +
>> +	.vidioc_g_parm			= isc_g_parm,
>> +	.vidioc_s_parm			= isc_s_parm,
>> +};
>> +
>> +static irqreturn_t isc_interrupt(int irq, void *dev_id)
>> +{
>> +	struct isc_device *isc = (struct isc_device *)dev_id;
>> +	struct regmap *regmap = isc->regmap;
>> +	u32 isc_intsr, isc_intmask, pending;
>> +	irqreturn_t ret = IRQ_NONE;
>> +
>> +	spin_lock(&isc->dma_queue_lock);
>> +
>> +	regmap_read(regmap, ISC_INTSR, &isc_intsr);
>> +	regmap_read(regmap, ISC_INTMASK, &isc_intmask);
>
> Unless I'm mistaken ISC_INTMASK is never written. How does this work ?
>
ISC_INTMASK is a read-only register, if an interrupt is set, then the 
corresponding field in ISC_INTMASK will be set automatically. If an 
interrupt is triggered, we can mask the interrupt status fields that not 
be enabled through the value of ISC_INTMASK.

>> +	pending = isc_intsr & isc_intmask;
>> +
>> +	if (likely(pending & ISC_INTSR_DDONE)) {
>> +		if (isc->cur_frm) {
>> +			struct vb2_v4l2_buffer *vbuf = &isc->cur_frm->vb;
>> +			struct vb2_buffer *vb = &vbuf->vb2_buf;
>> +
>> +			vb->timestamp = ktime_get_ns();
>> +			vbuf->sequence = isc->sequence++;
>> +			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +			isc->cur_frm = NULL;
>> +		}
>> +
>> +		if (!list_empty(&isc->dma_queue) && !isc->stop) {
>> +			isc->cur_frm = list_first_entry(&isc->dma_queue,
>> +						     struct isc_buffer, list);
>> +			list_del(&isc->cur_frm->list);
>> +
>> +			isc_start_dma(regmap, isc->cur_frm,
>> +				      isc->current_fmt->reg_dctrl_dview);
>> +		}
>> +
>> +		ret = IRQ_HANDLED;
>> +	}
>> +
>> +	spin_unlock(&isc->dma_queue_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int isc_async_bound(struct v4l2_async_notifier *notifier,
>> +			   struct v4l2_subdev *subdev,
>> +			   struct v4l2_async_subdev *asd)
>> +{
>> +	struct isc_device *isc = container_of(notifier->v4l2_dev,
>> +					      struct isc_device, v4l2_dev);
>> +	struct isc_subdev_entity *subdev_entity =
>> +		container_of(notifier, struct isc_subdev_entity, notifier);
>> +
>> +	if (video_is_registered(&isc->video_dev)) {
>> +		v4l2_err(&isc->v4l2_dev, "only supports one sub-device.\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	subdev_entity->sd = subdev;
>> +
>> +	return 0;
>> +}
>> +
>> +static void isc_async_unbind(struct v4l2_async_notifier *notifier,
>> +			     struct v4l2_subdev *subdev,
>> +			     struct v4l2_async_subdev *asd)
>> +{
>> +	struct isc_device *isc = container_of(notifier->v4l2_dev,
>> +					      struct isc_device, v4l2_dev);
>> +
>> +	video_unregister_device(&isc->video_dev);
>> +	vb2_dma_contig_cleanup_ctx(isc->alloc_ctx);
>> +	isc->alloc_ctx = NULL;
>> +}
>> +
>> +static struct isc_format *find_format_by_code(unsigned int code, int
>> *index)
>> +{
>> +	struct isc_format *fmt = &isc_formats[0];
>> +	int i;
>
> unsigned int.
>
Accept, thank you.

>> +
>> +	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> +		if (fmt->sd_mbus_code == code) {
>> +			*index = i;
>> +			return fmt;
>> +		}
>> +
>> +		fmt++;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static int isc_formats_init(struct isc_device *isc)
>> +{
>> +	struct isc_format *fmt;
>> +	struct v4l2_subdev *subdev = isc->current_subdev->sd;
>> +	int num_fmts, i, j;
>> +	struct v4l2_subdev_mbus_code_enum mbus_code = {
>> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>> +	};
>> +
>> +	fmt = &isc_formats[0];
>> +	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> +		fmt->isc_support = false;
>> +		fmt->sd_support = false;
>> +
>> +		fmt++;
>> +	}
>> +
>> +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
>> +	       NULL, &mbus_code)) {
>> +		mbus_code.index++;
>> +		fmt = find_format_by_code(mbus_code.code, &i);
>> +		if (!fmt)
>> +			continue;
>> +
>> +		fmt->sd_support = true;
>> +
>> +		if (i <= RAW_FMT_INDEX_END) {
>> +			for (j = ISC_FMT_INDEX_START;
>> +			     j <= ISC_FMT_INDEX_END; j++) {
>> +				isc_formats[j].isc_support = true;
>> +				isc_formats[j].isc_mbus_code = mbus_code.code;
>> +				isc_formats[j].reg_isc_bps = fmt->reg_sd_bps;
>> +				isc_formats[j].reg_wb_cfg = fmt->reg_wb_cfg;
>> +				isc_formats[j].reg_cfa_cfg = fmt->reg_cfa_cfg;
>> +			}
>> +		}
>> +	}
>> +
>> +	fmt = &isc_formats[0];
>> +	for (i = 0, num_fmts = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> +		if (fmt->isc_support || fmt->sd_support)
>> +			num_fmts++;
>> +
>> +		fmt++;
>> +	}
>> +
>> +	if (!num_fmts)
>> +		return -ENXIO;
>> +
>> +	isc->num_user_formats = num_fmts;
>> +	isc->user_formats = devm_kcalloc(isc->dev,
>> +					 num_fmts, sizeof(struct isc_format *),
>> +					 GFP_KERNEL);
>> +	if (!isc->user_formats) {
>> +		v4l2_err(&isc->v4l2_dev, "could not allocate memory\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	fmt = &isc_formats[0];
>> +	for (i = 0, j = 0; i < ARRAY_SIZE(isc_formats); i++) {
>> +		if (fmt->isc_support || fmt->sd_support)
>> +			isc->user_formats[j++] = fmt;
>> +
>> +		fmt++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int isc_async_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +	struct isc_device *isc = container_of(notifier->v4l2_dev,
>> +					      struct isc_device, v4l2_dev);
>> +	struct video_device *vdev = &isc->video_dev;
>> +	struct vb2_queue *q = &isc->vb2_vidq;
>> +	int ret;
>> +
>> +	mutex_init(&isc->lock);
>> +
>> +	isc->current_subdev = container_of(notifier,
>> +					   struct isc_subdev_entity, notifier);
>> +
>> +	/* Initialize videobuf2 queue */
>> +	isc->alloc_ctx = vb2_dma_contig_init_ctx(isc->dev);
>> +	if (IS_ERR(isc->alloc_ctx)) {
>> +		ret = PTR_ERR(isc->alloc_ctx);
>> +		v4l2_err(&isc->v4l2_dev,
>> +			 "Failed to get the context: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	q->io_modes		= VB2_MMAP;
>> +	q->drv_priv		= isc;
>> +	q->buf_struct_size	= sizeof(struct isc_buffer);
>> +	q->ops			= &isc_vb2_ops;
>> +	q->mem_ops		= &vb2_dma_contig_memops;
>> +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +	q->lock			= &isc->lock;
>> +	q->min_buffers_needed	= 1;
>> +
>> +	ret = vb2_queue_init(q);
>> +	if (ret < 0) {
>> +		v4l2_err(&isc->v4l2_dev,
>> +			 "vb2_queue_init() failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	/* Init video dma queues */
>> +	INIT_LIST_HEAD(&isc->dma_queue);
>> +	spin_lock_init(&isc->dma_queue_lock);
>> +
>> +	/* Register video device */
>> +	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
>> +	vdev->release		= video_device_release_empty;
>> +	vdev->fops		= &isc_fops;
>> +	vdev->ioctl_ops		= &isc_ioctl_ops;
>> +	vdev->v4l2_dev		= &isc->v4l2_dev;
>> +	vdev->vfl_dir		= VFL_DIR_RX;
>> +	vdev->queue		= q;
>> +	vdev->lock		= &isc->lock;
>> +	vdev->ctrl_handler	= isc->current_subdev->sd->ctrl_handler;
>> +	video_set_drvdata(vdev, isc);
>> +
>> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
>> +	if (ret < 0) {
>> +		v4l2_err(&isc->v4l2_dev,
>> +			 "video_register_device failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = isc_formats_init(isc);
>> +	if (ret < 0) {
>> +		v4l2_err(&isc->v4l2_dev,
>> +			 "Init format failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void isc_subdev_cleanup(struct isc_device *isc)
>> +{
>> +	struct isc_subdev_entity *subdev_entity, *tmp;
>> +
>> +	list_for_each_entry_safe(subdev_entity, tmp,
>> +				 &isc->subdev_entities, list) {
>> +		list_del(&subdev_entity->list);
>> +		v4l2_async_notifier_unregister(&subdev_entity->notifier);
>> +	}
>> +}
>> +
>> +/* regmap configuration */
>> +#define ATMEL_ISC_REG_MAX    0xbfc
>> +static const struct regmap_config isc_regmap_config = {
>> +	.reg_bits       = 32,
>> +	.reg_stride     = 4,
>> +	.val_bits       = 32,
>> +	.max_register	= ATMEL_ISC_REG_MAX,
>> +};
>> +
>> +static int atmel_isc_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct isc_device *isc;
>> +	struct resource *res;
>> +	void __iomem *io_base;
>> +	struct isc_subdev_entity *subdev_entity;
>> +	int irq;
>> +	int ret;
>> +
>> +	isc = devm_kzalloc(dev, sizeof(*isc), GFP_KERNEL);
>> +	if (!isc)
>> +		return -ENOMEM;
>> +
>> +	platform_set_drvdata(pdev, isc);
>> +	isc->dev = &pdev->dev;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		dev_err(dev, "no memory resource\n");
>> +		return -ENXIO;
>> +	}
>
> devm_ioremap_resource() will check for !res, no need to duplicate the check
> here.
>
Accept, the check will be removed.
Thank you.

>> +
>> +	io_base = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(io_base)) {
>> +		ret = PTR_ERR(io_base);
>> +		dev_err(dev, "failed to remap register memory: %d\n", ret);
>
> devm_ioremap_resource() prints an error message in case of failure, no need
> for a second one.
>
Accept, the check will be removed.
Thank you.

>> +		return ret;
>> +	}
>> +
>> +	isc->regmap = devm_regmap_init_mmio(dev, io_base, &isc_regmap_config);
>> +	if (IS_ERR(isc->regmap)) {
>> +		ret = PTR_ERR(isc->regmap);
>> +		dev_err(dev, "failed to init register map: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (IS_ERR_VALUE(irq)) {
>> +		ret = irq;
>> +		dev_err(dev, "failed to get irq: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret =  devm_request_irq(dev, irq, isc_interrupt, 0,
>
> s/=  /= /
>
>> +				ATMEL_ISC_NAME, (void *)isc);
>
> No need to cast the isc pointer to (void *), that's automatic in C.
>
Accept, thank you.

>> +	if (ret < 0) {
>> +		dev_err(dev, "can't register ISR for IRQ %u (ret=%i)\n",
>> +			irq, ret);
>> +		return ret;
>> +	}
>> +
>> +	isc->hclock = devm_clk_get(dev, "hclock");
>> +	if (IS_ERR(isc->hclock)) {
>> +		ret = PTR_ERR(isc->hclock);
>> +		dev_err(dev, "failed to get hclock: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = isc_clk_init(isc);
>> +	if (ret) {
>> +		dev_err(dev, "failed to init isc clock: %d\n", ret);
>> +		goto clean_isc_clk;
>> +	}
>> +
>> +	isc->ispck = devm_clk_get(dev, "ispck");
>> +	if (IS_ERR(isc->ispck)) {
>> +		ret = PTR_ERR(isc->ispck);
>> +		dev_err(dev, "failed to get isc_ispck: %d\n", ret);
>> +		goto clean_isc_clk;
>> +	}
>> +
>> +	/* ispck should be greater or equal to hclock */
>> +	ret = clk_set_rate(isc->ispck, clk_get_rate(isc->hclock));
>> +	if (ret) {
>> +		dev_err(dev, "failed to set ispck rate: %d\n", ret);
>> +		goto clean_isc_clk;
>> +	}
>> +
>> +	ret = v4l2_device_register(dev, &isc->v4l2_dev);
>> +	if (ret) {
>> +		dev_err(dev, "unable to register v4l2 device.\n");
>> +		goto clean_isc_clk;
>> +	}
>> +
>> +	ret = isc_parse_dt(dev, isc);
>> +	if (ret) {
>> +		dev_err(dev, "fail to parse device tree\n");
>> +		goto unregister_v4l2_device;
>> +	}
>> +
>> +	if (list_empty(&isc->subdev_entities)) {
>> +		dev_err(dev, "no subdev found\n");
>> +		goto unregister_v4l2_device;
>> +	}
>> +
>> +	list_for_each_entry(subdev_entity, &isc->subdev_entities, list) {
>> +		subdev_entity->notifier.subdevs = &subdev_entity->asd;
>> +		subdev_entity->notifier.num_subdevs = 1;
>> +		subdev_entity->notifier.bound = isc_async_bound;
>> +		subdev_entity->notifier.unbind = isc_async_unbind;
>> +		subdev_entity->notifier.complete = isc_async_complete;
>> +
>> +		ret = v4l2_async_notifier_register(&isc->v4l2_dev,
>> +						   &subdev_entity->notifier);
>> +		if (ret) {
>> +			dev_err(dev, "fail to register async notifier\n");
>> +			goto cleanup_subdev;
>> +		}
>> +
>> +		if (video_is_registered(&isc->video_dev))
>> +			break;
>> +	}
>> +
>> +	return 0;
>> +
>> +cleanup_subdev:
>> +	isc_subdev_cleanup(isc);
>> +
>> +unregister_v4l2_device:
>> +	v4l2_device_unregister(&isc->v4l2_dev);
>> +
>> +clean_isc_clk:
>> +	isc_clk_cleanup(isc);
>> +
>> +	return ret;
>> +}
>> +
>> +static int atmel_isc_remove(struct platform_device *pdev)
>> +{
>> +	struct isc_device *isc = platform_get_drvdata(pdev);
>> +
>> +	isc_subdev_cleanup(isc);
>> +
>> +	v4l2_device_unregister(&isc->v4l2_dev);
>> +
>> +	isc_clk_cleanup(isc);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id atmel_isc_of_match[] = {
>> +	{ .compatible = "atmel,sama5d2-isc" },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, atmel_isc_of_match);
>> +
>> +static struct platform_driver atmel_isc_driver = {
>> +	.remove	 = atmel_isc_remove,
>> +	.driver	 = {
>> +		.name   = ATMEL_ISC_NAME,
>> +		.owner  = THIS_MODULE,
>
> module_platform_driver() will set this field for you, no need to do it
> manually.
>
Accept, thank you.

>> +		.of_match_table = of_match_ptr(atmel_isc_of_match),
>> +	},
>> +};
>> +
>> +module_platform_driver_probe(atmel_isc_driver, atmel_isc_probe);
>
> No need for module_platform_driver_probe(), you can use
> module_platform_driver() and set the probe function pointer in your driver
> structure.
>
Accept, thank you.

>> +
>> +MODULE_AUTHOR("Songjun Wu <songjun.wu@atmel.com>");
>> +MODULE_DESCRIPTION("The V4L2 driver for Atmel-ISC");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_SUPPORTED_DEVICE("video");
>
