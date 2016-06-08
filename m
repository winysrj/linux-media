Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:40152 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756348AbcFHVi4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 17:38:56 -0400
Date: Wed, 8 Jun 2016 23:38:51 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Songjun Wu <songjun.wu@atmel.com>
Cc: <laurent.pinchart@ideasonboard.com>, <nicolas.ferre@atmel.com>,
	<alexandre.belloni@free-electrons.com>, <robh@kernel.org>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Richard =?UTF-8?B?UsO2amZvcnM=?= <richard@puffinpack.se>,
	Benoit Parrot <bparrot@ti.com>, <linux-kernel@vger.kernel.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	<linux-media@vger.kernel.org>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: Re: [PATCH v4 1/2] [media] atmel-isc: add the Image Sensor
 Controller code
Message-ID: <20160608233851.7414a61a@bbrezillon>
In-Reply-To: <1465283513-30224-2-git-send-email-songjun.wu@atmel.com>
References: <1465283513-30224-1-git-send-email-songjun.wu@atmel.com>
 <1465283513-30224-2-git-send-email-songjun.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Songjun,

On Tue, 7 Jun 2016 15:11:52 +0800
Songjun Wu <songjun.wu@atmel.com> wrote:

> Add driver for the Image Sensor Controller. It manages
> incoming data from a parallel based CMOS/CCD sensor.
> It has an internal image processor, also integrates a
> triple channel direct memory access controller master
> interface.
> 
> Signed-off-by: Songjun Wu <songjun.wu@atmel.com>
> ---
> 
> Changes in v4:
> - Modify the isc clock code since the dt is changed.
> 
> Changes in v3:
> - Add pm runtime feature.
> - Modify the isc clock code since the dt is changed.
> 
> Changes in v2:
> - Add "depends on COMMON_CLK" and "VIDEO_V4L2_SUBDEV_API"
>   in Kconfig file.
> - Correct typos and coding style according to Laurent's remarks
> - Delete the loop while in 'isc_clk_enable' function.
> - Add the code to support VIDIOC_CREATE_BUFS in
>   'isc_queue_setup' function.
> - Invoke isc_config to configure register in
>   'isc_start_streaming' function.
> - Add the struct completion 'comp' to synchronize with
>   the frame end interrupt in 'isc_stop_streaming' function.
> - Check the return value of the clk_prepare_enable
>   in 'isc_open' function.
> - Set the default format in 'isc_open' function.
> - Add an exit condition in the loop while in 'isc_config'.
> - Delete the hardware setup operation in 'isc_set_format'.
> - Refuse format modification during streaming
>   in 'isc_s_fmt_vid_cap' function.
> - Invoke v4l2_subdev_alloc_pad_config to allocate and
>   initialize the pad config in 'isc_async_complete' function.
> - Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
> - Replace the module_platform_driver_probe() with
>   module_platform_driver().
> 
>  drivers/media/platform/Kconfig                |    1 +
>  drivers/media/platform/Makefile               |    2 +
>  drivers/media/platform/atmel/Kconfig          |    9 +
>  drivers/media/platform/atmel/Makefile         |    1 +
>  drivers/media/platform/atmel/atmel-isc-regs.h |  276 +++++
>  drivers/media/platform/atmel/atmel-isc.c      | 1580 +++++++++++++++++++++++++
>  6 files changed, 1869 insertions(+)
>  create mode 100644 drivers/media/platform/atmel/Kconfig
>  create mode 100644 drivers/media/platform/atmel/Makefile
>  create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>  create mode 100644 drivers/media/platform/atmel/atmel-isc.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 84e041c..91d7aea 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -110,6 +110,7 @@ source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/s5p-tv/Kconfig"
>  source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
> +source "drivers/media/platform/atmel/Kconfig"
>  
>  config VIDEO_TI_CAL
>  	tristate "TI CAL (Camera Adaptation Layer) driver"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index bbb7bd1..ad8f471 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -55,4 +55,6 @@ obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
>  
>  obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
>  
> +obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
> +
>  ccflags-y += -I$(srctree)/drivers/media/i2c
> diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
> new file mode 100644
> index 0000000..867dca2
> --- /dev/null
> +++ b/drivers/media/platform/atmel/Kconfig
> @@ -0,0 +1,9 @@
> +config VIDEO_ATMEL_ISC
> +	tristate "ATMEL Image Sensor Controller (ISC) support"
> +	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> +	depends on ARCH_AT91 || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select REGMAP_MMIO
> +	help
> +	   This module makes the ATMEL Image Sensor Controller available
> +	   as a v4l2 device.
> \ No newline at end of file
> diff --git a/drivers/media/platform/atmel/Makefile b/drivers/media/platform/atmel/Makefile
> new file mode 100644
> index 0000000..9d7c999
> --- /dev/null
> +++ b/drivers/media/platform/atmel/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_ATMEL_ISC) += atmel-isc.o
> diff --git a/drivers/media/platform/atmel/atmel-isc-regs.h b/drivers/media/platform/atmel/atmel-isc-regs.h
> new file mode 100644
> index 0000000..dda9396
> --- /dev/null
> +++ b/drivers/media/platform/atmel/atmel-isc-regs.h
> @@ -0,0 +1,276 @@
> +#ifndef __ATMEL_ISC_REGS_H
> +#define __ATMEL_ISC_REGS_H
> +
> +#include <linux/bitops.h>
> +
> +/* ISC Control Enable Register 0 */
> +#define ISC_CTRLEN      0x00000000
> +
> +#define ISC_CTRLEN_CAPTURE              BIT(0)
> +#define ISC_CTRLEN_CAPTURE_MASK         BIT(0)
> +
> +#define ISC_CTRLEN_UPPRO                BIT(1)
> +#define ISC_CTRLEN_UPPRO_MASK           BIT(1)
> +
> +#define ISC_CTRLEN_HISREQ               BIT(2)
> +#define ISC_CTRLEN_HISREQ_MASK          BIT(2)
> +
> +#define ISC_CTRLEN_HISCLR               BIT(3)
> +#define ISC_CTRLEN_HISCLR_MASK          BIT(3)
> +
> +/* ISC Control Disable Register 0 */
> +#define ISC_CTRLDIS     0x00000004
> +
> +#define ISC_CTRLDIS_DISABLE             BIT(0)
> +#define ISC_CTRLDIS_DISABLE_MASK        BIT(0)
> +
> +#define ISC_CTRLDIS_SWRST               BIT(8)
> +#define ISC_CTRLDIS_SWRST_MASK          BIT(8)

No need to create _MASK macros when you manipulate single bits.

> +
> +/* ISC Control Status Register 0 */
> +#define ISC_CTRLSR      0x00000008
> +
> +#define ISC_CTRLSR_CAPTURE      BIT(0)
> +#define ISC_CTRLSR_UPPRO        BIT(1)
> +#define ISC_CTRLSR_HISREQ       BIT(2)
> +#define ISC_CTRLSR_FIELD        BIT(4)
> +#define ISC_CTRLSR_SIP          BIT(31)

The CTREN and CTRLSR seem similar, please share the same definition.
Something like:

ISC_CTRL_CAPTURE		BIT(0)
ISC_CTRL_UPPRO			BIT(1)
...

> +
> +/* ISC Parallel Front End Configuration 0 Register */
> +#define ISC_PFE_CFG0    0x0000000c
> +
> +#define ISC_PFE_CFG0_HPOL_LOW   BIT(0)
> +#define ISC_PFE_CFG0_HPOL_HIGH  0x0
> +#define ISC_PFE_CFG0_HPOL_MASK  BIT(0)
> +
> +#define ISC_PFE_CFG0_VPOL_LOW   BIT(1)
> +#define ISC_PFE_CFG0_VPOL_HIGH  0x0
> +#define ISC_PFE_CFG0_VPOL_MASK  BIT(1)
> +
> +#define ISC_PFE_CFG0_PPOL_LOW   BIT(2)
> +#define ISC_PFE_CFG0_PPOL_HIGH  0x0
> +#define ISC_PFE_CFG0_PPOL_MASK  BIT(2)

Ditto. Drop the _MASK and _HIGH definitions and keep the _LOW ones.

> +
> +#define ISC_PFE_CFG0_MODE_PROGRESSIVE   0x0

Nit: the value is 0 here, so it works fine, but it would be clearer to
put (0 << 4), since the mode field starts at bit4.

> +#define ISC_PFE_CFG0_MODE_MASK          GENMASK(6, 4)
> +
> +#define ISC_PFE_CFG0_BPS_EIGHT  (0x4 << 28)
> +#define ISC_PFG_CFG0_BPS_NINE   (0x3 << 28)
> +#define ISC_PFG_CFG0_BPS_TEN    (0x2 << 28)
> +#define ISC_PFG_CFG0_BPS_ELEVEN (0x1 << 28)
> +#define ISC_PFG_CFG0_BPS_TWELVE 0x0

Ditto.

> +#define ISC_PFE_CFG0_BPS_MASK   GENMASK(30, 28)
> +
> +/* ISC Clock Enable Register */
> +#define ISC_CLKEN               0x00000018
> +#define ISC_CLKEN_EN            0x1
> +#define ISC_CLKEN_EN_SHIFT(n)   (n)
> +#define ISC_CLKEN_EN_MASK(n)    BIT(n)
> +
> +/* ISC Clock Disable Register */
> +#define ISC_CLKDIS              0x0000001c
> +#define ISC_CLKDIS_DIS          0x1
> +#define ISC_CLKDIS_DIS_SHIFT(n) (n)
> +#define ISC_CLKDIS_DIS_MASK(n)  BIT(n)

Same remark as above, just define a single macro

ISC_CLK(n)			BIT(n)

and use it for the EN/DIS/STA registers.

No need for the _MASK() and _SHIFT() ones.

> +
> +/* ISC Clock Status Register */
> +#define ISC_CLKSR               0x00000020
> +#define ISC_CLKSR_CLK_MASK(n)   BIT(n)
> +#define ISC_CLKSR_SIP_PROGRESS  BIT(31)
> +
> +/* ISC Clock Configuration Register */
> +#define ISC_CLKCFG              0x00000024
> +#define ISC_CLKCFG_DIV_SHIFT(n) ((n)*16)
> +#define ISC_CLKCFG_DIV_MASK(n)  GENMASK(((n)*16 + 7), (n)*16)
> +#define ISC_CLKCFG_SEL_SHIFT(n) ((n)*16 + 8)
> +#define ISC_CLKCFG_SEL_MASK(n)  GENMASK(((n)*17 + 8), ((n)*16 + 8))
> +
> +/* ISC Interrupt Enable Register */
> +#define ISC_INTEN       0x00000028
> +
> +#define ISC_INTEN_DDONE         BIT(8)
> +#define ISC_INTEN_DDONE_MASK    BIT(8)
> +
> +/* ISC Interrupt Disable Register */
> +#define ISC_INTDIS      0x0000002c
> +
> +#define ISC_INTDIS_DDONE        BIT(8)
> +#define ISC_INTDIS_DDONE_MASK   BIT(8)

Ditto.

> +
> +/* ISC Interrupt Mask Register */
> +#define ISC_INTMASK     0x00000030
> +
> +/* ISC Interrupt Status Register */
> +#define ISC_INTSR       0x00000034
> +
> +#define ISC_INTSR_DDONE         BIT(8)
> +
> +/* ISC White Balance Control Register */
> +#define ISC_WB_CTRL     0x00000058
> +
> +#define ISC_WB_CTRL_EN          BIT(0)
> +#define ISC_WB_CTRL_DIS         0x0
> +#define ISC_WB_CTRL_MASK        BIT(0)

Ditto.

> +
> +/* ISC White Balance Configuration Register */
> +#define ISC_WB_CFG      0x0000005c
> +
> +#define ISC_WB_CFG_BAYCFG_GRGR  0x0
> +#define ISC_WB_CFG_BAYCFG_RGRG  0x1
> +#define ISC_WB_CFG_BAYCFG_GBGB  0x2
> +#define ISC_WB_CFG_BAYCFG_BGBG  0x3
> +#define ISC_WB_CFG_BAYCFG_MASK  GENMASK(1, 0)
> +
> +/* ISC Color Filter Array Control Register */
> +#define ISC_CFA_CTRL    0x00000070
> +
> +#define ISC_CFA_CTRL_EN         BIT(0)
> +#define ISC_CFA_CTRL_DIS        0x0
> +#define ISC_CFA_CTRL_MASK       BIT(0)
> +
> +/* ISC Color Filter Array Configuration Register */
> +#define ISC_CFA_CFG     0x00000074
> +
> +#define ISC_CFA_CFG_BAY_GRGR    0x0
> +#define ISC_CFA_CFG_BAY_RGRG    0x1
> +#define ISC_CFA_CFG_BAY_GBGB    0x2
> +#define ISC_CFA_CFG_BAY_BGBG    0x3
> +#define ISC_CFA_CFG_BAY_MASK    GENMASK(1, 0)

Again, same values for WB and CFA => merge the definitions.

> +
> +/* ISC Color Correction Control Register */
> +#define ISC_CC_CTRL     0x00000078
> +
> +#define ISC_CC_CTRL_EN          BIT(0)
> +#define ISC_CC_CTRL_DIS         0x0
> +#define ISC_CC_CTRL_MASK        BIT(0)
> +
> +/* ISC Gamma Correction Control Register */
> +#define ISC_GAM_CTRL    0x00000094
> +
> +#define ISC_GAM_CTRL_EN         BIT(0)
> +#define ISC_GAM_CTRL_DIS        0x0
> +#define ISC_GAM_CTRL_MASK       BIT(0)
> +
> +#define ISC_GAM_CTRL_B_EN       BIT(1)
> +#define ISC_GAM_CTRL_B_DIS      0x0
> +#define ISC_GAM_CTRL_B_MASK     BIT(1)
> +
> +#define ISC_GAM_CTRL_G_EN       BIT(2)
> +#define ISC_GAM_CTRL_G_DIS      0x0
> +#define ISC_GAM_CTRL_G_MASK     BIT(2)
> +
> +#define ISC_GAM_CTRL_R_EN       BIT(3)
> +#define ISC_GAM_CTRL_R_DIS      0x0
> +#define ISC_GAM_CTRL_R_MASK     BIT(3)
> +
> +#define ISC_GAM_CTRL_ALL_CHAN_MASK (ISC_GAM_CTRL_B_MASK | \
> +				    ISC_GAM_CTRL_G_MASK | \
> +				    ISC_GAM_CTRL_R_MASK)
> +
> +/* Color Space Conversion Control Register */
> +#define ISC_CSC_CTRL    0x00000398
> +
> +#define ISC_CSC_CTRL_EN         BIT(0)
> +#define ISC_CSC_CTRL_DIS        0x0
> +#define ISC_CSC_CTRL_MASK       BIT(0)
> +
> +/* Contrast And Brightness Control Register */
> +#define ISC_CBC_CTRL    0x000003b4
> +
> +#define ISC_CBC_CTRL_EN         BIT(0)
> +#define ISC_CBC_CTRL_DIS        0x0
> +#define ISC_CBC_CTRL_MASK       BIT(0)
> +
> +/* Subsampling 4:4:4 to 4:2:2 Control Register */
> +#define ISC_SUB422_CTRL 0x000003c4
> +
> +#define ISC_SUB422_CTRL_EN      BIT(0)
> +#define ISC_SUB422_CTRL_DIS     0x0
> +#define ISC_SUB422_CTRL_MASK    BIT(0)
> +
> +/* Subsampling 4:2:2 to 4:2:0 Control Register */
> +#define ISC_SUB420_CTRL 0x000003cc
> +
> +#define ISC_SUB420_CTRL_EN      BIT(0)
> +#define ISC_SUB420_CTRL_DIS     0x0
> +#define ISC_SUB420_CTRL_MASK    BIT(0)
> +
> +#define ISC_SUB420_CTRL_FILTER_PROG     0x0
> +#define ISC_SUB420_CTRL_FILTER_INTER    BIT(4)
> +#define ISC_SUB420_CTRL_FILTER_MASK     BIT(4)
> +
> +/* Rounding, Limiting and Packing Configuration Register */
> +#define ISC_RLP_CFG     0x000003d0
> +
> +#define ISC_RLP_CFG_MODE_DAT8           0x0
> +#define ISC_RLP_CFG_MODE_DAT9           0x1
> +#define ISC_RLP_CFG_MODE_DAT10          0x2
> +#define ISC_RLP_CFG_MODE_DAT11          0x3
> +#define ISC_RLP_CFG_MODE_DAT12          0x4
> +#define ISC_RLP_CFG_MODE_DATY8          0x5
> +#define ISC_RLP_CFG_MODE_DATY10         0x6
> +#define ISC_RLP_CFG_MODE_ARGB444        0x7
> +#define ISC_RLP_CFG_MODE_ARGB555        0x8
> +#define ISC_RLP_CFG_MODE_RGB565         0x9
> +#define ISC_RLP_CFG_MODE_ARGB32         0xa
> +#define ISC_RLP_CFG_MODE_YYCC           0xb
> +#define ISC_RLP_CFG_MODE_YYCC_LIMITED   0xc
> +#define ISC_RLP_CFG_MODE_MASK           GENMASK(3, 0)
> +
> +/* DMA Configuration Register */
> +#define ISC_DCFG        0x000003e0
> +#define ISC_DCFG_IMODE_PACKED8          0x0
> +#define ISC_DCFG_IMODE_PACKED16         0x1
> +#define ISC_DCFG_IMODE_PACKED32         0x2
> +#define ISC_DCFG_IMODE_YC422SP          0x3
> +#define ISC_DCFG_IMODE_YC422P           0x4
> +#define ISC_DCFG_IMODE_YC420SP          0x5
> +#define ISC_DCFG_IMODE_YC420P           0x6
> +#define ISC_DCFG_IMODE_MASK             GENMASK(2, 0)
> +
> +#define ISC_DCFG_YMBSIZE_SINGLE         0x0
> +#define ISC_DCFG_YMBSIZE_BEATS4         (0x1 << 4)
> +#define ISC_DCFG_YMBSIZE_BEATS8         (0x2 << 4)
> +#define ISC_DCFG_YMBSIZE_BEATS16        (0x3 << 4)
> +#define ISC_DCFG_YMBSIZE_MASK           GENMASK(5, 4)
> +
> +#define ISC_DCFG_CMBSIZE_SINGLE         0x0
> +#define ISC_DCFG_CMBSIZE_BEATS4         (0x1 << 8)
> +#define ISC_DCFG_CMBSIZE_BEATS8         (0x2 << 8)
> +#define ISC_DCFG_CMBSIZE_BEATS16        (0x3 << 8)
> +#define ISC_DCFG_CMBSIZE_MASK           GENMASK(9, 8)
> +
> +/* DMA Control Register */
> +#define ISC_DCTRL       0x000003e4
> +
> +#define ISC_DCTRL_DE_EN         BIT(0)
> +#define ISC_DCTRL_DE_DIS        0x0
> +#define ISC_DCTRL_DE_MASK       BIT(0)
> +
> +#define ISC_DCTRL_DVIEW_PACKED          0x0
> +#define ISC_DCTRL_DVIEW_SEMIPLANAR      (0x1 << 1)
> +#define ISC_DCTRL_DVIEW_PLANAR          (0x2 << 1)
> +#define ISC_DCTRL_DVIEW_MASK            GENMASK(2, 1)
> +
> +#define ISC_DCTRL_IE_IS         0x0
> +#define ISC_DCTRL_IE_NOT        BIT(4)
> +#define ISC_DCTRL_IE_MASK       BIT(4)
> +
> +#define ISC_DCTRL_WB_EN         BIT(5)
> +#define ISC_DCTRL_WB_DIS        0x0
> +#define ISC_DCTRL_WB_MASK       BIT(5)
> +
> +#define ISC_DCTRL_DESC_IS_DONE  BIT(7)
> +#define ISC_DCTRL_DESC_NOT_DONE 0x0
> +#define ISC_DCTRL_DESC_MASK     BIT(7)
> +
> +/* DMA Descriptor Address Register */
> +#define ISC_DNDA        0x000003e8
> +
> +/* DMA Address 0 Register */
> +#define ISC_DAD0        0x000003ec
> +
> +/* DMA Stride 0 Register */
> +#define ISC_DST0        0x000003f0

I just didn't go through all the definitions, but please make sure you
get rid of all the duplicate and useless definitions in your next
version.

> +
> +#endif
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> new file mode 100644
> index 0000000..57f3a97
> --- /dev/null
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -0,0 +1,1580 @@
> +/*
> + * Atmel Image Sensor Controller (ISC) driver
> + *
> + * Copyright (C) 2016 Atmel
> + *
> + * Author: Songjun Wu <songjun.wu@atmel.com>
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * Sensor-->PFE-->WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB-->RLP-->DMA
> + *
> + * ISC video pipeline integrates the following submodules:
> + * PFE: Parallel Front End to sample the camera sensor input stream
> + *  WB: Programmable white balance in the Bayer domain
> + * CFA: Color filter array interpolation module
> + *  CC: Programmable color correction
> + * GAM: Gamma correction
> + * CSC: Programmable color space conversion
> + * CBC: Contrast and Brightness control
> + * SUB: This module performs YCbCr444 to YCbCr420 chrominance subsampling
> + * RLP: This module performs rounding, range limiting
> + *      and packing of the incoming data
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/regmap.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-image-sizes.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "atmel-isc-regs.h"
> +
> +#define ATMEL_ISC_NAME		"atmel_isc"
> +
> +#define ISC_MAX_SUPPORT_WIDTH   2592
> +#define ISC_MAX_SUPPORT_HEIGHT  1944
> +
> +#define ISC_CLK_MAX_DIV		255
> +
> +enum isc_clk_id {
> +	ISC_ISPCK = 0,
> +	ISC_MCK = 1,
> +};
> +
> +struct isc_clk {
> +	struct clk_hw   hw;
> +	struct clk      *clk;

Why do you need this backpointer?

> +	struct regmap   *regmap;
> +	spinlock_t      *lock;

I'm pretty you don't need this lock. The regmap is taking care of
concurrent accesses for you.

> +	u8		id;
> +	u8		parent_id;

Hm, do we really want to cache clk source configuration? What's the
problem with setting it directly when the CCF calls ->set_parent()?

> +	u32		div;

Ditto.

We usually use this caching mechanism when we can't decorrelate
enable/disable operation from parenting/dividing operations, but that
doesn't seem to be the case here.

> +
> +	struct isc_device *isc;

Do you really need this pointer to the isc device?

> +};
> +
> +#define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
> +
> +struct isc_buffer {
> +	struct vb2_v4l2_buffer  vb;
> +	struct list_head	list;
> +};
> +
> +struct isc_subdev_entity {
> +	struct v4l2_subdev		*sd;
> +	struct v4l2_async_subdev	*asd;
> +	struct v4l2_async_notifier      notifier;
> +	struct v4l2_subdev_pad_config	*config;
> +
> +	u32 pfe_cfg0;
> +
> +	struct list_head list;
> +};
> +
> +/*
> + * struct isc_format - ISC media bus format information
> + * @fourcc:		Fourcc code for this format
> + * @isc_mbus_code:      V4L2 media bus format code if ISC is preferred
> + * @sd_mbus_code:       V4L2 media bus format code if subdev is preferred
> + * @bpp:		Bytes per pixel (when stored in memory)
> + * @reg_sd_bps:		reg value for bits per sample if subdev is preferred
> + *			(when transferred over a bus)
> + * @reg_isc_bps:	reg value for bits per sample if ISC is preferred
> + *			(when transferred over a bus)
> + * @pipeline:		pipeline switch if ISC is preferred
> + * @isc_support:	ISC can convert raw format to this format
> + * @sd_support:		Subdev supports this format
> + */
> +struct isc_format {
> +	u32	fourcc;
> +	u32	isc_mbus_code;
> +	u32	sd_mbus_code;
> +
> +	u8	bpp;
> +
> +	u32	reg_sd_bps;
> +	u32	reg_isc_bps;
> +
> +	u32	reg_wb_cfg;
> +	u32	reg_cfa_cfg;
> +	u32	reg_rlp_mode;
> +	u32	reg_dcfg_imode;
> +	u32	reg_dctrl_dview;
> +
> +	u32	pipeline;
> +
> +	bool	isc_support;
> +	bool	sd_support;
> +};
> +
> +struct isc_device {
> +	struct regmap		*regmap;
> +	struct clk		*hclock;
> +	struct clk		*ispck;
> +	struct isc_clk		isc_clks[2];
> +	spinlock_t		clk_lock;

Let the regmap use its own lock instead of passing yours.

> +
> +	struct device		*dev;
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	video_dev;
> +
> +	struct vb2_queue	vb2_vidq;
> +	struct vb2_alloc_ctx	*alloc_ctx;
> +
> +	spinlock_t		dma_queue_lock;
> +	struct list_head	dma_queue;
> +	struct isc_buffer	*cur_frm;
> +	unsigned int		sequence;
> +	bool			stop;
> +	struct completion	comp;
> +
> +	struct v4l2_format	fmt;
> +
> +	struct isc_format	**user_formats;
> +	unsigned int		num_user_formats;
> +	const struct isc_format	*current_fmt;
> +
> +	struct mutex		lock;
> +
> +	struct isc_subdev_entity	*current_subdev;
> +	struct list_head		subdev_entities;
> +};
> +
> +struct reg_mask {
> +	u32 reg;
> +	u32 mask;
> +};

You're reinventing the wheel, please use reg_field.

> +
> +static unsigned int sensor_preferred = 1;
> +module_param(sensor_preferred, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(sensor_preferred,
> +"Sensor is preferred to output the specified format (1-on 0-off) default 1");

Fix the indentation.

> +
> +/* WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB422-->SUB420 */
> +const struct reg_mask pipeline_regs[] = {
> +	{ ISC_WB_CTRL,  ISC_WB_CTRL_MASK },
> +	{ ISC_CFA_CTRL, ISC_CFA_CTRL_MASK },
> +	{ ISC_CC_CTRL,  ISC_CC_CTRL_MASK },
> +	{ ISC_GAM_CTRL, ISC_GAM_CTRL_MASK | ISC_GAM_CTRL_ALL_CHAN_MASK },
> +	{ ISC_CSC_CTRL, ISC_CSC_CTRL_MASK },
> +	{ ISC_CBC_CTRL, ISC_CBC_CTRL_MASK },
> +	{ ISC_SUB422_CTRL, ISC_SUB422_CTRL_MASK },
> +	{ ISC_SUB420_CTRL, ISC_SUB420_CTRL_MASK }
> +};
> +
> +#define RAW_FMT_INDEX_START	0
> +#define RAW_FMT_INDEX_END	11
> +#define ISC_FMT_INDEX_START	12
> +#define ISC_FMT_INDEX_END	12
> +
> +/*
> + * index(0~11):  raw formats.
> + * index(12~12): the formats which can be converted from raw format by ISC.
> + * index():      the formats which can only be provided by subdev.
> + */
> +static struct isc_format isc_formats[] = {
> +{V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SBGGR8_1X8,
> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_BGBG,
> +ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_GBGB,
> +ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SGRBG8_1X8,
> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_GRGR,
> +ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
> +1, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_RGRG,
> +ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +
> +{V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10,
> +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_BGBG,
> +ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10,
> +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_GBGB,
> +ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10,
> +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_GRGR,
> +ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10,
> +2, ISC_PFG_CFG0_BPS_TEN, ISC_PFG_CFG0_BPS_TEN, ISC_WB_CFG_BAYCFG_RGRG,
> +ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +
> +{V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12, MEDIA_BUS_FMT_SBGGR12_1X12,
> +2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_BGBG,
> +ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12, MEDIA_BUS_FMT_SGBRG12_1X12,
> +2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_GBGB,
> +ISC_CFA_CFG_BAY_GBGB, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12, MEDIA_BUS_FMT_SGRBG12_1X12,
> +2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_GRGR,
> +ISC_CFA_CFG_BAY_GRGR, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +{V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12, MEDIA_BUS_FMT_SRGGB12_1X12,
> +2, ISC_PFG_CFG0_BPS_TWELVE, ISC_PFG_CFG0_BPS_TWELVE, ISC_WB_CFG_BAYCFG_RGRG,
> +ISC_CFA_CFG_BAY_RGRG, ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
> +ISC_DCTRL_DVIEW_PACKED, 0x0, false, false},
> +
> +{V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8, MEDIA_BUS_FMT_YUYV8_2X8,
> +2, ISC_PFE_CFG0_BPS_EIGHT, ISC_PFE_CFG0_BPS_EIGHT, ISC_WB_CFG_BAYCFG_BGBG,
> +ISC_CFA_CFG_BAY_BGBG, ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
> +ISC_DCTRL_DVIEW_PACKED, 0x7f, false, false},
> +};

Indentation.

> +
> +static int isc_clk_enable(struct clk_hw *hw)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +	u32 id = isc_clk->id;
> +	struct regmap *regmap = isc_clk->regmap;
> +	unsigned long flags;
> +
> +	dev_dbg(isc_clk->isc->dev, "ISC CLK: %s, div = %d, parent id = %d\n",
> +		__func__, isc_clk->div, isc_clk->parent_id);
> +
> +	spin_lock_irqsave(isc_clk->lock, flags);

Drop the locking here...

> +
> +	regmap_update_bits(regmap, ISC_CLKCFG,
> +			   ISC_CLKCFG_DIV_MASK(id) | ISC_CLKCFG_SEL_MASK(id),
> +			   (isc_clk->div << ISC_CLKCFG_DIV_SHIFT(id)) |
> +			   (isc_clk->parent_id << ISC_CLKCFG_SEL_SHIFT(id)));

... this update bit operation is already protected.

> +
> +	regmap_update_bits(regmap, ISC_CLKEN,
> +			   ISC_CLKEN_EN_MASK(id),
> +			   ISC_CLKEN_EN << ISC_CLKEN_EN_SHIFT(id));

You're manipulating a write-only register, use

	regmap_write(regmap, ISC_CLKEN, ISC_CLK(id));

> +
> +	spin_unlock_irqrestore(isc_clk->lock, flags);
> +
> +	return 0;
> +}
> +
> +static void isc_clk_disable(struct clk_hw *hw)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +	u32 id = isc_clk->id;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(isc_clk->lock, flags);
> +
> +	regmap_update_bits(isc_clk->regmap, ISC_CLKDIS,
> +			   ISC_CLKDIS_DIS_MASK(id),
> +			   ISC_CLKDIS_DIS << ISC_CLKDIS_DIS_SHIFT(id));

Ditto (drop the lock and use regmap_write()).

> +
> +	spin_unlock_irqrestore(isc_clk->lock, flags);
> +}
> +
> +static int isc_clk_is_enabled(struct clk_hw *hw)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +	unsigned long flags;
> +	u32 status;
> +
> +	spin_lock_irqsave(isc_clk->lock, flags);
> +	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
> +	spin_unlock_irqrestore(isc_clk->lock, flags);

Ditto (drop the lock).

> +
> +	return status & ISC_CLKSR_CLK_MASK(isc_clk->id) ? 1 : 0;
> +}
> +
> +static unsigned long
> +isc_clk_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +
> +	return DIV_ROUND_CLOSEST(parent_rate, isc_clk->div + 1);
> +}
> +
> +static int isc_clk_determine_rate(struct clk_hw *hw,
> +				  struct clk_rate_request *req)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +	long best_rate = -EINVAL;
> +	int best_diff = -1;
> +	unsigned int i, div;
> +
> +	for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
> +		struct clk_hw *parent;
> +		unsigned long parent_rate;
> +
> +		parent = clk_hw_get_parent_by_index(hw, i);
> +		if (!parent)
> +			continue;
> +
> +		parent_rate = clk_hw_get_rate(parent);
> +		if (!parent_rate)
> +			continue;
> +
> +		for (div = 1; div < ISC_CLK_MAX_DIV + 2; div++) {
> +			unsigned long rate;
> +			int diff;
> +
> +			rate = DIV_ROUND_CLOSEST(parent_rate, div);
> +			diff = abs(req->rate - rate);
> +
> +			if (best_diff < 0 || best_diff > diff) {
> +				best_rate = rate;
> +				best_diff = diff;
> +				req->best_parent_rate = parent_rate;
> +				req->best_parent_hw = parent;
> +			}
> +
> +			if (!best_diff || rate < req->rate)
> +				break;
> +		}
> +
> +		if (!best_diff)
> +			break;
> +	}
> +
> +	dev_dbg(isc_clk->isc->dev,

Ok, that explains why you were keeping a pointer to isc. Just store a
pointer to dev and you should be fine.

> +		"ISC CLK: %s, best_rate = %ld, parent clk: %s @ %ld\n",
> +		__func__, best_rate,
> +		__clk_get_name((req->best_parent_hw)->clk),
> +		req->best_parent_rate);
> +
> +	if (best_rate < 0)
> +		return best_rate;
> +
> +	req->rate = best_rate;
> +
> +	return 0;
> +}
> +
> +static int isc_clk_set_parent(struct clk_hw *hw, u8 index)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +
> +	if (index >= clk_hw_get_num_parents(hw))
> +		return -EINVAL;
> +
> +	isc_clk->parent_id = index;

Apply the value directly in the CLKCFG register. If you want to make
sure div and source are applied at the same time, then implement
->set_rate_and_parent() instead of implementing both ->set_rate() and
->set_parent().

> +
> +	return 0;
> +}
> +
> +static u8 isc_clk_get_parent(struct clk_hw *hw)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +
> +	return isc_clk->parent_id;

Read the register value.

> +}
> +
> +static int isc_clk_set_rate(struct clk_hw *hw,
> +			    unsigned long rate,
> +			    unsigned long parent_rate)
> +{
> +	struct isc_clk *isc_clk = to_isc_clk(hw);
> +	u32 div;
> +
> +	if (!rate)
> +		return -EINVAL;
> +
> +	div = DIV_ROUND_CLOSEST(parent_rate, rate);
> +	if (div > (ISC_CLK_MAX_DIV + 1) || !div)
> +		return -EINVAL;
> +
> +	isc_clk->div = div - 1;
> +
> +	return 0;
> +}

See my comment about ->set_rate_and_parent().

> +
> +static const struct clk_ops isc_clk_ops = {
> +	.enable		= isc_clk_enable,
> +	.disable	= isc_clk_disable,
> +	.is_enabled	= isc_clk_is_enabled,
> +	.recalc_rate	= isc_clk_recalc_rate,
> +	.determine_rate	= isc_clk_determine_rate,
> +	.set_parent	= isc_clk_set_parent,
> +	.get_parent	= isc_clk_get_parent,
> +	.set_rate	= isc_clk_set_rate,
> +};
> +
> +static int isc_clk_register(struct isc_device *isc, unsigned int id)
> +{
> +	struct regmap *regmap = isc->regmap;
> +	struct device_node *np = isc->dev->of_node;
> +	struct isc_clk *isc_clk;
> +	struct clk_init_data init;
> +	const char *clk_name = np->name;
> +	const char **parent_names;
> +	int num_parents, ret = 0;
> +
> +	num_parents = of_clk_get_parent_count(np);
> +	if (num_parents < 1 || num_parents > 3)
> +		return -EINVAL;
> +
> +	if (num_parents > 2 && id == ISC_ISPCK)
> +		num_parents = 2;
> +
> +	parent_names = kcalloc(num_parents, sizeof(char *), GFP_KERNEL);
> +	if (!parent_names)
> +		return -ENOMEM;

You have a maximum of 3 parents, you should probably declare a static
array:

	const char *parent_names[3];

> +
> +	of_clk_parent_fill(np, parent_names, num_parents);
> +
> +	if (id == ISC_MCK)
> +		of_property_read_string(np, "clock-output-names", &clk_name);
> +	else
> +		clk_name = "isc-ispck";

Hm, that's a bit weird, but I guess you have no other choice, since
this clock is only used internally.

> +
> +	init.parent_names	= parent_names;
> +	init.num_parents	= num_parents;
> +	init.name		= clk_name;
> +	init.ops		= &isc_clk_ops;
> +	init.flags		= CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
> +
> +	isc_clk = &isc->isc_clks[id];
> +	isc_clk->hw.init	= &init;
> +	isc_clk->regmap		= regmap;
> +	isc_clk->lock		= &isc->clk_lock;
> +	isc_clk->id		= id;
> +	isc_clk->isc		= isc;
> +
> +	isc_clk->clk = clk_register(NULL, &isc_clk->hw);

	clk_register(isc->dev, &isc_clk->hw);

> +	if (IS_ERR(isc_clk->clk)) {
> +		dev_err(isc->dev, "%s: clock register fail\n", clk_name);
> +		ret = PTR_ERR(isc_clk->clk);
> +		goto free_parent_names;
> +	} else if (id == ISC_MCK)
> +		of_clk_add_provider(np, of_clk_src_simple_get, isc_clk->clk);
> +
> +free_parent_names:
> +	kfree(parent_names);
> +	return ret;
> +}
> +
> +static int isc_clk_init(struct isc_device *isc)
> +{
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(isc->isc_clks); i++)
> +		isc->isc_clks[i].clk = ERR_PTR(-EINVAL);
> +
> +	spin_lock_init(&isc->clk_lock);
> +
> +	for (i = 0; i < 2; i++) {
> +		ret = isc_clk_register(isc, i);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void isc_clk_cleanup(struct isc_device *isc)
> +{
> +	unsigned int i;
> +
> +	of_clk_del_provider(isc->dev->of_node);
> +
> +	for (i = 0; i < ARRAY_SIZE(isc->isc_clks); i++) {
> +		struct isc_clk *isc_clk = &isc->isc_clks[i];
> +
> +		if (!IS_ERR(isc_clk->clk))
> +			clk_unregister(isc_clk->clk);
> +	}
> +}
> +
> +static int isc_queue_setup(struct vb2_queue *vq,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], void *alloc_ctxs[])

Try to align parameters to the open parenthesis.

> +{
> +	struct isc_device *isc = vb2_get_drv_priv(vq);
> +	unsigned int size = isc->fmt.fmt.pix.sizeimage;
> +
> +	alloc_ctxs[0] = isc->alloc_ctx;
> +
> +	if (*nplanes)
> +		return sizes[0] < size ? -EINVAL : 0;
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +
> +	return 0;
> +}
> +
> +static int isc_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct isc_device *isc = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size = isc->fmt.fmt.pix.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		v4l2_err(&isc->v4l2_dev, "buffer too small (%lu < %lu)\n",
> +			 vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);
> +
> +	vbuf->field = isc->fmt.fmt.pix.field;
> +
> +	return 0;
> +}
> +
> +static inline void isc_start_dma(struct regmap *regmap,
> +				 struct isc_buffer *frm, u32 dview)
> +{
> +	dma_addr_t addr;
> +
> +	addr = vb2_dma_contig_plane_dma_addr(&frm->vb.vb2_buf, 0);
> +
> +	regmap_write(regmap, ISC_DCTRL, dview | ISC_DCTRL_IE_IS);
> +	regmap_write(regmap, ISC_DAD0, addr);
> +	regmap_update_bits(regmap, ISC_CTRLEN,
> +			   ISC_CTRLEN_CAPTURE_MASK, ISC_CTRLEN_CAPTURE);
> +}
> +
> +static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
> +{
> +	if ((sensor_preferred && isc_fmt->sd_support) ||
> +	    !isc_fmt->isc_support)
> +		return true;
> +	else
> +		return false;
> +}
> +
> +static void isc_set_pipeline(struct regmap *regmap, u32 pipeline)
> +{
> +	const struct reg_mask *reg = &pipeline_regs[0];
> +	u32 val;
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(pipeline_regs); i++) {
> +		if (pipeline & BIT(i))
> +			val = reg->mask;
> +		else
> +			val = 0;
> +
> +		regmap_update_bits(regmap, reg->reg, reg->mask, val);

		regmap_field_update_bits();

> +
> +		reg++;
> +	}
> +}

It's a long driver, so I'll leave the remaining bits for someone else,
but I guess you got the idea on the different aspects I pointed out,
and you'll be able to adjust the rest of the code accordingly ;).

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
