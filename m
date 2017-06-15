Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41953 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750791AbdFOHMk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 03:12:40 -0400
Subject: Re: [RFC 2/2] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera
 interface
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl>
Date: Thu, 15 Jun 2017 09:12:32 +0200
MIME-Version: 1.0
In-Reply-To: <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

Here is a quick review of this driver. Once a v2 is posted I'll do a more thorough
check.

On 06/14/2017 05:15 PM, Dave Stevenson wrote:
> Add driver for the Unicam camera receiver block on
> BCM283x processors.
> 
> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> ---
>   drivers/media/platform/Kconfig                   |    1 +
>   drivers/media/platform/Makefile                  |    2 +
>   drivers/media/platform/bcm2835/Kconfig           |   14 +
>   drivers/media/platform/bcm2835/Makefile          |    3 +
>   drivers/media/platform/bcm2835/bcm2835-unicam.c  | 2100 ++++++++++++++++++++++
>   drivers/media/platform/bcm2835/vc4-regs-unicam.h |  257 +++
>   6 files changed, 2377 insertions(+)
>   create mode 100644 drivers/media/platform/bcm2835/Kconfig
>   create mode 100644 drivers/media/platform/bcm2835/Makefile
>   create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>   create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 8da521a..1111aa9 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -135,6 +135,7 @@ source "drivers/media/platform/am437x/Kconfig"
>   source "drivers/media/platform/xilinx/Kconfig"
>   source "drivers/media/platform/rcar-vin/Kconfig"
>   source "drivers/media/platform/atmel/Kconfig"
> +source "drivers/media/platform/bcm2835/Kconfig"
>   
>   config VIDEO_TI_CAL
>   	tristate "TI CAL (Camera Adaptation Layer) driver"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 6bbdf94..9c5e412 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -81,3 +81,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
>   obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
>   
>   obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
> +
> +obj-y					+= bcm2835/
> diff --git a/drivers/media/platform/bcm2835/Kconfig b/drivers/media/platform/bcm2835/Kconfig
> new file mode 100644
> index 0000000..9f9be9e
> --- /dev/null
> +++ b/drivers/media/platform/bcm2835/Kconfig
> @@ -0,0 +1,14 @@
> +# Broadcom VideoCore4 V4L2 camera support
> +
> +config VIDEO_BCM2835_UNICAM
> +	tristate "Broadcom BCM2835 Unicam video capture driver"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on ARCH_BCM2708 || ARCH_BCM2709 || ARCH_BCM2835 || COMPILE_TEST

So this block is available on other broadcom SoCs as well? Not just the 2835?
Should the description of this Kconfig be adapted?

> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
> +	---help---
> +	  Say Y here to enable V4L2 subdevice for CSI2 receiver.
> +	  This is a V4L2 subdevice that interfaces directly to the VC4 peripheral.
> +
> +	   To compile this driver as a module, choose M here. The module
> +	   will be called bcm2835-unicam.
> diff --git a/drivers/media/platform/bcm2835/Makefile b/drivers/media/platform/bcm2835/Makefile
> new file mode 100644
> index 0000000..a98aba0
> --- /dev/null
> +++ b/drivers/media/platform/bcm2835/Makefile
> @@ -0,0 +1,3 @@
> +# Makefile for BCM2835 Unicam driver
> +
> +obj-$(CONFIG_VIDEO_BCM2835_UNICAM) += bcm2835-unicam.o
> diff --git a/drivers/media/platform/bcm2835/bcm2835-unicam.c b/drivers/media/platform/bcm2835/bcm2835-unicam.c
> new file mode 100644
> index 0000000..26039da
> --- /dev/null
> +++ b/drivers/media/platform/bcm2835/bcm2835-unicam.c
> @@ -0,0 +1,2100 @@
> +/*
> + * BCM2835 Unicam capture Driver
> + *
> + * Copyright (C) 2017 - Raspberry Pi (Trading) Ltd.
> + *
> + * Dave Stevenson <dave.stevenson@raspberrypi.org>
> + *
> + * Based on TI am437x driver by Benoit Parrot and Lad, Prabhakar and
> + * TI CAL camera interface driver by Benoit Parrot.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/of_graph.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/videobuf2-v4l2.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "vc4-regs-unicam.h"
> +
> +#define UNICAM_MODULE_NAME	"unicam"
> +#define UNICAM_VERSION		"0.1.0"
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Debug level 0-3");
> +
> +#define unicam_dbg(level, dev, fmt, arg...)	\
> +		v4l2_dbg(level, debug, &(dev)->v4l2_dev, fmt, ##arg)
> +#define unicam_info(dev, fmt, arg...)	\
> +		v4l2_info(&(dev)->v4l2_dev, fmt, ##arg)
> +#define unicam_err(dev, fmt, arg...)	\
> +		v4l2_err(&(dev)->v4l2_dev, fmt, ##arg)
> +
> +/*
> + * Stride is a 16 bit register. Max width is therefore determined by
> + * that divided by the number of bits per pixel. Take 32bpp as a
> + * worst case.
> + * No imposed limit on the height, so adopt a square image for want
> + * of anything better.
> + */
> +#define MAX_WIDTH	((65536 / 4) - 1)
> +#define MAX_HEIGHT	MAX_WIDTH
> +
> +#define DEFAULT_MAX_DATA_LANES	2
> +
> +/*
> + * struct unicam_fmt - Unicam media bus format information
> + * @pixelformat: V4L2 pixel format FCC identifier.
> + * @code: V4L2 media bus format code.
> + * @depth: Bits per pixel (when stored in memory).
> + * @csi_dt: CSI data type.
> + */
> +struct unicam_fmt {
> +	u32	fourcc;
> +	u32	code;
> +	u8	depth;
> +	u8	csi_dt;
> +};
> +
> +/*
> + * The peripheral can unpack and repack between several of
> + * the Bayer raw formats, so any Bayer format can be advertised
> + * as the same Bayer order in each of the supported bit depths.
> + * Use lower case to avoid clashing with V4L2_PIX_FMT_SGBRG8
> + * formats.
> + */
> +#define PIX_FMT_ALL_BGGR  v4l2_fourcc('b', 'g', 'g', 'r')
> +#define PIX_FMT_ALL_RGGB  v4l2_fourcc('r', 'g', 'g', 'b')
> +#define PIX_FMT_ALL_GBRG  v4l2_fourcc('g', 'b', 'r', 'g')
> +#define PIX_FMT_ALL_GRBG  v4l2_fourcc('g', 'r', 'b', 'g')
> +
> +static const struct unicam_fmt formats[] = {
> +	/* YUV Formats */
> +	{
> +		.fourcc		= V4L2_PIX_FMT_YUYV,
> +		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_UYVY,
> +		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_YVYU,
> +		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_VYUY,
> +		.code		= MEDIA_BUS_FMT_VYUY8_2X8,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_YUYV,
> +		.code		= MEDIA_BUS_FMT_YUYV8_1X16,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_UYVY,
> +		.code		= MEDIA_BUS_FMT_UYVY8_1X16,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_YVYU,
> +		.code		= MEDIA_BUS_FMT_YVYU8_1X16,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_VYUY,
> +		.code		= MEDIA_BUS_FMT_VYUY8_1X16,
> +		.depth		= 16,
> +		.csi_dt		= 0x1e,
> +	}, {
> +	/* RGB Formats */
> +		.fourcc		= V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
> +		.code		= MEDIA_BUS_FMT_RGB565_2X8_LE,
> +		.depth		= 16,
> +		.csi_dt		= 0x22,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
> +		.code		= MEDIA_BUS_FMT_RGB565_2X8_BE,
> +		.depth		= 16,
> +		.csi_dt		= 0x22
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
> +		.code		= MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
> +		.depth		= 16,
> +		.csi_dt		= 0x21,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
> +		.code		= MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
> +		.depth		= 16,
> +		.csi_dt		= 0x21,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_RGB24, /* rgb */
> +		.code		= MEDIA_BUS_FMT_RGB888_1X24,
> +		.depth		= 24,
> +		.csi_dt		= 0x24,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_BGR24, /* bgr */
> +		.code		= MEDIA_BUS_FMT_BGR888_1X24,
> +		.depth		= 24,
> +		.csi_dt		= 0x24,
> +	}, {
> +		.fourcc		= V4L2_PIX_FMT_RGB32, /* argb */
> +		.code		= MEDIA_BUS_FMT_ARGB8888_1X32,
> +		.depth		= 32,
> +		.csi_dt		= 0x0,
> +	}, {
> +	/* Bayer Formats */
> +		.fourcc		= PIX_FMT_ALL_BGGR,
> +		.code		= MEDIA_BUS_FMT_SBGGR8_1X8,
> +		.depth		= 8,
> +		.csi_dt		= 0x2a,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GBRG,
> +		.code		= MEDIA_BUS_FMT_SGBRG8_1X8,
> +		.depth		= 8,
> +		.csi_dt		= 0x2a,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GRBG,
> +		.code		= MEDIA_BUS_FMT_SGRBG8_1X8,
> +		.depth		= 8,
> +		.csi_dt		= 0x2a,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_RGGB,
> +		.code		= MEDIA_BUS_FMT_SRGGB8_1X8,
> +		.depth		= 8,
> +		.csi_dt		= 0x2a,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_BGGR,
> +		.code		= MEDIA_BUS_FMT_SBGGR10_1X10,
> +		.depth		= 10,
> +		.csi_dt		= 0x2b,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GBRG,
> +		.code		= MEDIA_BUS_FMT_SGBRG10_1X10,
> +		.depth		= 10,
> +		.csi_dt		= 0x2b,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GRBG,
> +		.code		= MEDIA_BUS_FMT_SGRBG10_1X10,
> +		.depth		= 10,
> +		.csi_dt		= 0x2b,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_RGGB,
> +		.code		= MEDIA_BUS_FMT_SRGGB10_1X10,
> +		.depth		= 10,
> +		.csi_dt		= 0x2b,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_BGGR,
> +		.code		= MEDIA_BUS_FMT_SBGGR12_1X12,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GBRG,
> +		.code		= MEDIA_BUS_FMT_SGBRG12_1X12,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GRBG,
> +		.code		= MEDIA_BUS_FMT_SGRBG12_1X12,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_RGGB,
> +		.code		= MEDIA_BUS_FMT_SRGGB12_1X12,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_RGGB,
> +		.code		= MEDIA_BUS_FMT_SRGGB16_1X16,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GBRG,
> +		.code		= MEDIA_BUS_FMT_SGBRG16_1X16,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GBRG,
> +		.code		= MEDIA_BUS_FMT_SGRBG16_1X16,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	}, {
> +		.fourcc		= PIX_FMT_ALL_GRBG,
> +		.code		= MEDIA_BUS_FMT_SGRBG16_1X16,
> +		.depth		= 12,
> +		.csi_dt		= 0x2c,
> +	},
> +};
> +
> +struct bayer_fmt {
> +	u32 fourcc;
> +	u8 depth;
> +};
> +
> +const struct bayer_fmt all_bayer_bggr[] = {
> +	{V4L2_PIX_FMT_SBGGR8,	8},
> +	{V4L2_PIX_FMT_SBGGR10P,	10},
> +	{V4L2_PIX_FMT_SBGGR12,	12},
> +	{V4L2_PIX_FMT_SBGGR16,	16},
> +	{0,			0}
> +};
> +
> +const struct bayer_fmt all_bayer_rggb[] = {
> +	{V4L2_PIX_FMT_SRGGB8,	8},
> +	{V4L2_PIX_FMT_SRGGB10P,	10},
> +	{V4L2_PIX_FMT_SRGGB12,	12},
> +	/* V4L2_PIX_FMT_SRGGB16,	16},*/

Why is this commented out? Either uncomment, add a proper comment explaining why
or remove it.

> +	{0,			0}
> +};
> +
> +const struct bayer_fmt all_bayer_gbrg[] = {
> +	{V4L2_PIX_FMT_SGBRG8,	8},
> +	{V4L2_PIX_FMT_SGBRG10P,	10},
> +	{V4L2_PIX_FMT_SGBRG12,	12},
> +	/* V4L2_PIX_FMT_SGBRG16,	16}, */
> +	{0,			0}
> +};
> +
> +const struct bayer_fmt all_bayer_grbg[] = {
> +	{V4L2_PIX_FMT_SGRBG8,	8},
> +	{V4L2_PIX_FMT_SGRBG10P,	10},
> +	{V4L2_PIX_FMT_SGRBG12,	12},
> +	/* V4L2_PIX_FMT_SGRBG16,	16},*/
> +	{0,			0}
> +};
> +
> +struct unicam_dmaqueue {
> +	struct list_head	active;
> +};
> +
> +struct unicam_buffer {
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head list;
> +};
> +
> +struct unicam_cfg {
> +	/* peripheral base address */
> +	void __iomem *base;
> +	/* clock gating base address */
> +	void __iomem *clk_gate_base;
> +	unsigned int irq;
> +
> +	unsigned int periph_max_data_lanes;
> +};
> +
> +#define MAX_POSSIBLE_FMTS \
> +		(ARRAY_SIZE(formats) + \
> +		ARRAY_SIZE(all_bayer_bggr) + \
> +		ARRAY_SIZE(all_bayer_rggb) + \
> +		ARRAY_SIZE(all_bayer_grbg) + \
> +		ARRAY_SIZE(all_bayer_gbrg))
> +
> +struct unicam_device {
> +	/* V4l2 specific parameters */
> +	/* Identifies video device for this channel */
> +	struct video_device video_dev;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +
> +	struct v4l2_fwnode_endpoint	endpoint;
> +
> +	struct v4l2_async_subdev asd;
> +
> +	/* unicam cfg */
> +	struct unicam_cfg cfg;
> +	/* clock handle */
> +	struct clk *clock;
> +	/* V4l2 device */
> +	struct v4l2_device v4l2_dev;
> +	/* parent device */
> +	struct platform_device *pdev;
> +	/* subdevice async Notifier */
> +	struct v4l2_async_notifier notifier;
> +	unsigned int sequence;
> +
> +	/* ptr to  sub device */
> +	struct v4l2_subdev *sensor;
> +	/* Pad config for the sensor */
> +	struct v4l2_subdev_pad_config *sensor_config;
> +	/* current input at the sub device */
> +	int current_input;
> +
> +	/* Pointer pointing to current v4l2_buffer */
> +	struct unicam_buffer *cur_frm;
> +	/* Pointer pointing to next v4l2_buffer */
> +	struct unicam_buffer *next_frm;
> +
> +	/* video capture */
> +	const struct unicam_fmt	*fmt;
> +	/* Used to store current pixel format */
> +	struct v4l2_format		v_fmt;
> +	/* Used to store current mbus frame format */
> +	struct v4l2_mbus_framefmt	m_fmt;
> +
> +	struct unicam_fmt	active_fmts[MAX_POSSIBLE_FMTS];
> +	int		num_active_fmt;
> +	unsigned int		virtual_channel;
> +	enum v4l2_mbus_type bus_type;
> +	unsigned int max_data_lanes;
> +	unsigned int active_data_lanes;
> +
> +	struct v4l2_rect crop;
> +
> +	/* Currently selected input on subdev */
> +	int input;
> +
> +	/* Buffer queue used in video-buf */
> +	struct vb2_queue buffer_queue;
> +	/* Queue of filled frames */
> +	struct unicam_dmaqueue dma_queue;
> +	/* IRQ lock for DMA queue */
> +	spinlock_t dma_queue_lock;
> +	/* lock used to access this structure */
> +	struct mutex lock;
> +	/* Flag to denote that we are processing buffers */
> +	int streaming;
> +};
> +
> +/* Hardware access */
> +#define clk_write(dev, val) writel((val) | 0x5a000000, (dev)->clk_gate_base)
> +#define clk_read(dev) readl((dev)->clk_gate_base)
> +
> +#define reg_read(dev, offset) readl((dev)->base + (offset))
> +#define reg_write(dev, offset, val) writel(val, (dev)->base + (offset))
> +
> +#define reg_read_field(dev, offset, mask) get_field(reg_read((dev), (offset), \
> +						    mask))
> +
> +static inline int get_field(u32 value, u32 mask)
> +{
> +	return (value & mask) >> __ffs(mask);
> +}
> +
> +static inline void set_field(u32 *valp, u32 field, u32 mask)
> +{
> +	u32 val = *valp;
> +
> +	val &= ~mask;
> +	val |= (field << __ffs(mask)) & mask;
> +	*valp = val;
> +}
> +
> +static inline void reg_write_field(struct unicam_cfg *dev, u32 offset,
> +				   u32 field, u32 mask)
> +{
> +	u32 val = reg_read((dev), (offset));
> +
> +	set_field(&val, field, mask);
> +	reg_write((dev), (offset), val);
> +}
> +
> +/* Format setup functions */
> +
> +static int find_depth_by_code(u32 code)
> +{
> +	const struct unicam_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < ARRAY_SIZE(formats); k++) {
> +		fmt = &formats[k];
> +		if (fmt->code == code)
> +			return fmt->depth;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int unicam_runtime_get(struct unicam_device *dev)
> +{
> +	int r;
> +
> +	r = pm_runtime_get_sync(&dev->pdev->dev);
> +
> +	return r;
> +}
> +
> +static inline void unicam_runtime_put(struct unicam_device *dev)
> +{
> +	pm_runtime_put_sync(&dev->pdev->dev);
> +}
> +
> +static const struct unicam_fmt *find_format_by_code(struct unicam_device *dev,
> +						    u32 code)
> +{
> +	const struct unicam_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < dev->num_active_fmt; k++) {
> +		fmt = &dev->active_fmts[k];
> +		if (fmt->code == code)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static const struct unicam_fmt *find_format_by_pix(struct unicam_device *dev,
> +						   u32 pixelformat)
> +{
> +	const struct unicam_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < dev->num_active_fmt; k++) {
> +		fmt = &dev->active_fmts[k];
> +		if (fmt->fourcc == pixelformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static char *fourcc_to_str(u32 fmt)
> +{
> +	static char code[5];
> +
> +	code[0] = (unsigned char)(fmt & 0xff);
> +	code[1] = (unsigned char)((fmt >> 8) & 0xff);
> +	code[2] = (unsigned char)((fmt >> 16) & 0xff);
> +	code[3] = (unsigned char)((fmt >> 24) & 0xff);
> +	code[4] = '\0';
> +
> +	return code;
> +}

I understand that there can be two instances of this device, so using a static char is
wrong.

I think this function can be a useful addition to v4l2-common.c/h.

BTW, v4l2-ctl uses this function to convert a fourcc to a string:

std::string fcc2s(unsigned int val)
{
         std::string s;

         s += val & 0x7f;
         s += (val >> 8) & 0x7f;
         s += (val >> 16) & 0x7f;
         s += (val >> 24) & 0x7f;
         if (val & (1 << 31))
                 s += "-BE";
         return s;
}

Bit 31 has special meaning.

Proposal for v4l2-common.h:

#define V4L2_FOURCC_MAX_SIZE 8
char *v4l2_fourcc2s(u32 fourcc, char *buf);

This function fills in buf and returns buf.

> +
> +static void dump_active_formats(struct unicam_device *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev->num_active_fmt; i++) {
> +		unicam_dbg(3, dev, "active_fmt[%d] (%p) is code %04X, fourcc %s, depth %d\n",
> +			   i, &dev->active_fmts[i], dev->active_fmts[i].code,
> +			   fourcc_to_str(dev->active_fmts[i].fourcc),
> +			   dev->active_fmts[i].depth);
> +	}
> +}
> +
> +static inline int bytes_per_line(u32 width, const struct unicam_fmt *fmt)
> +{
> +	/* Stride must be a multiple of 16. */
> +	return ALIGN((width * fmt->depth) >> 3,  16);
> +}
> +
> +static int __subdev_get_format(struct unicam_device *dev,
> +			       struct v4l2_mbus_framefmt *fmt)
> +{
> +	struct v4l2_subdev_format sd_fmt = {0};
> +	struct v4l2_mbus_framefmt *mbus_fmt = &sd_fmt.format;
> +	int ret;
> +
> +	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	sd_fmt.pad = 0;
> +
> +	ret = v4l2_subdev_call(dev->sensor, pad, get_fmt, dev->sensor_config,
> +			       &sd_fmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	*fmt = *mbus_fmt;
> +
> +	unicam_dbg(1, dev, "%s %dx%d code:%04X\n", __func__,
> +		   fmt->width, fmt->height, fmt->code);
> +
> +	return 0;
> +}
> +
> +static int __subdev_set_format(struct unicam_device *dev,
> +			       struct v4l2_mbus_framefmt *fmt)
> +{
> +	struct v4l2_subdev_format sd_fmt;
> +	struct v4l2_mbus_framefmt *mbus_fmt = &sd_fmt.format;
> +	int ret;
> +
> +	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	sd_fmt.pad = 0;
> +	*mbus_fmt = *fmt;
> +
> +	ret = v4l2_subdev_call(dev->sensor, pad, set_fmt, dev->sensor_config,
> +			       &sd_fmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	unicam_dbg(1, dev, "%s %dx%d code:%04X\n", __func__,
> +		   fmt->width, fmt->height, fmt->code);
> +
> +	return 0;
> +}
> +
> +static int unicam_calc_format_size(struct unicam_device *dev,
> +				   const struct unicam_fmt *fmt,
> +				   struct v4l2_format *f)
> +{
> +	int min_bytesperline, min_sizeimage;
> +
> +	if (!fmt) {
> +		unicam_dbg(3, dev, "No unicam_fmt provided!\n");
> +		return -EINVAL;
> +	}
> +
> +	v4l_bound_align_image(&f->fmt.pix.width, 16, MAX_WIDTH, 2,
> +			      &f->fmt.pix.height, 16, MAX_HEIGHT, 0, 0);
> +
> +	min_bytesperline = bytes_per_line(f->fmt.pix.width, fmt);
> +	if (f->fmt.pix.bytesperline > min_bytesperline)
> +		f->fmt.pix.bytesperline = ALIGN(f->fmt.pix.bytesperline, 16);
> +	else
> +		f->fmt.pix.bytesperline = min_bytesperline;
> +
> +	min_sizeimage = f->fmt.pix.height *
> +			f->fmt.pix.bytesperline;
> +	if (f->fmt.pix.sizeimage < min_sizeimage)
> +		f->fmt.pix.sizeimage = min_sizeimage;

As mentioned in the earlier discussion apps can't set this.

> +
> +	unicam_dbg(1, dev, "width %d, fmt %s, depth %d\n",
> +		   f->fmt.pix.width, fourcc_to_str(f->fmt.pix.pixelformat),
> +		   fmt->depth);
> +	unicam_dbg(3, dev, "%s: fourcc: %s size: %dx%d bpl:%d img_size:%d\n",
> +		   __func__, fourcc_to_str(f->fmt.pix.pixelformat),
> +		   f->fmt.pix.width, f->fmt.pix.height,
> +		   f->fmt.pix.bytesperline, f->fmt.pix.sizeimage);
> +
> +	return 0;
> +}
> +
> +static void unicam_wr_dma_addr(struct unicam_device *dev, unsigned int dmaaddr)
> +{
> +	unicam_dbg(1, dev, "wr_dma_addr %08X-%08X\n",
> +		   dmaaddr, dmaaddr + dev->v_fmt.fmt.pix.sizeimage);
> +	reg_write(&dev->cfg, UNICAM_IBSA0, dmaaddr);
> +	reg_write(&dev->cfg,
> +		  UNICAM_IBEA0,
> +		  dmaaddr + dev->v_fmt.fmt.pix.sizeimage);
> +	reg_write(&dev->cfg, UNICAM_DBSA0, (uint32_t)dmaaddr);
> +	reg_write(&dev->cfg, UNICAM_DBEA0, (uint32_t)dmaaddr + (16 << 10));
> +}
> +
> +static inline void unicam_schedule_next_buffer(struct unicam_device *dev)
> +{
> +	struct unicam_dmaqueue *dma_q = &dev->dma_queue;
> +	struct unicam_buffer *buf;
> +	unsigned long addr;
> +
> +	buf = list_entry(dma_q->active.next, struct unicam_buffer, list);
> +	dev->next_frm = buf;
> +	list_del(&buf->list);
> +
> +	addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
> +	unicam_wr_dma_addr(dev, addr);
> +}
> +
> +static inline void unicam_process_buffer_complete(struct unicam_device *dev)
> +{
> +	dev->cur_frm->vb.field = dev->m_fmt.field;
> +	dev->cur_frm->vb.sequence = dev->sequence++;
> +
> +	vb2_buffer_done(&dev->cur_frm->vb.vb2_buf, VB2_BUF_STATE_DONE);
> +	dev->cur_frm = dev->next_frm;
> +}
> +
> +/*
> + * unicam_isr : ISR handler for unicam capture
> + * @irq: irq number
> + * @dev_id: dev_id ptr
> + *
> + * It changes status of the captured buffer, takes next buffer from the queue
> + * and sets its address in unicam registers
> + */
> +static irqreturn_t unicam_isr(int irq, void *dev)
> +{
> +	struct unicam_device *unicam = (struct unicam_device *)dev;
> +	int ista, sta;
> +	struct unicam_cfg *cfg = &unicam->cfg;
> +	struct unicam_dmaqueue *dma_q = &unicam->dma_queue;
> +
> +	/*
> +	 * Don't service interrupts if not streaming.
> +	 * Avoids issues if the VPU should enable the
> +	 * peripheral without the kernel knowing (that
> +	 * shouldn't happen, but causes issues if it does).
> +	 */
> +	if (!unicam->streaming)
> +		return IRQ_HANDLED;
> +
> +	sta = reg_read(cfg, UNICAM_STA);
> +	/* Write value back to clear the interrupts */
> +	reg_write(cfg, UNICAM_STA, sta);
> +
> +	ista = reg_read(cfg, UNICAM_ISTA);
> +	/* Write value back to clear the interrupts */
> +	reg_write(cfg, UNICAM_ISTA, ista);
> +
> +	if (!(sta && (UNICAM_IS | UNICAM_PI0)))
> +		return IRQ_HANDLED;
> +
> +	if (ista & UNICAM_FSI) {
> +		/*
> +		 * Timestamp is to be when the first data byte was captured,
> +		 * aka frame start.
> +		 */
> +		if (unicam->cur_frm)
> +			unicam->cur_frm->vb.vb2_buf.timestamp = ktime_get_ns();
> +	}
> +	if (ista & UNICAM_FEI || sta & UNICAM_PI0) {
> +		/*
> +		 * Ensure we have swapped buffers already as we can't
> +		 * stop the peripheral. Overwrite the frame we've just
> +		 * captured instead.
> +		 */
> +		if (unicam->cur_frm &&
> +		    unicam->cur_frm != unicam->next_frm)
> +			unicam_process_buffer_complete(unicam);
> +	}
> +
> +	if (ista & (UNICAM_FSI | UNICAM_LCI)) {
> +		spin_lock(&unicam->dma_queue_lock);
> +		if (!list_empty(&dma_q->active) &&
> +		    unicam->cur_frm == unicam->next_frm)
> +			unicam_schedule_next_buffer(unicam);
> +		spin_unlock(&unicam->dma_queue_lock);
> +	}
> +
> +	if (reg_read(&unicam->cfg, UNICAM_ICTL) & UNICAM_FCM) {
> +		/* Switch out of trigger mode if selected */
> +		reg_write_field(&unicam->cfg, UNICAM_ICTL, 1, UNICAM_TFC);
> +		reg_write_field(&unicam->cfg, UNICAM_ICTL, 0, UNICAM_FCM);
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +static int unicam_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +
> +	strlcpy(cap->driver, UNICAM_MODULE_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, UNICAM_MODULE_NAME, sizeof(cap->card));
> +
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +		 "platform:%s", dev->v4l2_dev.name);
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +			    V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

This has changed. Instead set the device_caps field in struct video_device.
The v4l2 core will then fill in these two fields for you based on the struct
video_device device_caps field.

> +	return 0;
> +}
> +
> +static int unicam_enum_fmt_vid_cap(struct file *file, void  *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	const struct unicam_fmt *fmt = NULL;
> +
> +	if (f->index >= dev->num_active_fmt)
> +		return -EINVAL;
> +
> +	fmt = &dev->active_fmts[f->index];
> +
> +	f->pixelformat = fmt->fourcc;
> +	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

No need to set type.

> +	return 0;
> +}
> +
> +static int unicam_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +
> +	*f = dev->v_fmt;
> +
> +	return 0;
> +}
> +
> +static int unicam_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	const struct unicam_fmt *fmt;
> +	struct v4l2_subdev_format sd_fmt;
> +	struct v4l2_mbus_framefmt *mbus_fmt = &sd_fmt.format;
> +	int ret;
> +
> +	fmt = find_format_by_pix(dev, f->fmt.pix.pixelformat);
> +	if (!fmt) {
> +		unicam_dbg(3, dev, "Fourcc format (0x%08x) not found.\n",
> +			   f->fmt.pix.pixelformat);
> +
> +		/* Just get the first one enumerated */
> +		fmt = &dev->active_fmts[0];
> +		f->fmt.pix.pixelformat = fmt->fourcc;
> +	}
> +
> +	sd_fmt.which = V4L2_SUBDEV_FORMAT_TRY;
> +	sd_fmt.pad = 0;
> +
> +	v4l2_fill_mbus_format(mbus_fmt, &f->fmt.pix, fmt->code);
> +
> +	ret = v4l2_subdev_call(dev->sensor, pad, set_fmt, dev->sensor_config,
> +			       &sd_fmt);
> +	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	v4l2_fill_pix_format(&f->fmt.pix, &sd_fmt.format);
> +
> +	/*
> +	 * Use current colorspace for now, it will get
> +	 * updated properly during s_fmt
> +	 */
> +	f->fmt.pix.colorspace = dev->v_fmt.fmt.pix.colorspace;
> +	return unicam_calc_format_size(dev, fmt, f);
> +}
> +
> +static int unicam_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	struct vb2_queue *q = &dev->buffer_queue;
> +	const struct unicam_fmt *fmt;
> +	struct v4l2_mbus_framefmt mbus_fmt = {0};
> +	int ret;
> +
> +	if (vb2_is_busy(q)) {
> +		unicam_dbg(3, dev, "%s device busy\n", __func__);

debug message seems pointless since the error code indicates this already.

> +		return -EBUSY;
> +	}
> +
> +	ret = unicam_try_fmt_vid_cap(file, priv, f);
> +	if (ret < 0)
> +		return ret;
> +
> +	fmt = find_format_by_pix(dev, f->fmt.pix.pixelformat);
> +	dump_active_formats(dev);
> +
> +	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, fmt->code);
> +
> +	ret = __subdev_set_format(dev, &mbus_fmt);
> +	if (ret) {
> +		unicam_dbg(3, dev,
> +			   "%s __subdev_set_format failed %d\n",
> +			   __func__, ret);
> +		return ret;
> +	}
> +
> +	/* Just double check nothing has gone wrong */
> +	if (mbus_fmt.code != fmt->code) {
> +		unicam_dbg(3, dev,
> +			   "%s subdev changed format on us, this should not happen\n",
> +			   __func__);
> +		return -EINVAL;
> +	}
> +
> +	v4l2_fill_pix_format(&dev->v_fmt.fmt.pix, &mbus_fmt);
> +	dev->v_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dev->v_fmt.fmt.pix.pixelformat = fmt->fourcc;
> +	dev->v_fmt.fmt.pix.bytesperline = f->fmt.pix.bytesperline;
> +	dev->v_fmt.fmt.pix.sizeimage = f->fmt.pix.sizeimage;
> +	unicam_calc_format_size(dev, fmt, &dev->v_fmt);
> +
> +	unicam_dbg(3, dev,
> +		   "%s %dx%d, mbus_fmt %s, V4L2 pix %s. About to overwrite pix with %s\n",
> +		   __func__,
> +		   dev->v_fmt.fmt.pix.width,
> +		   dev->v_fmt.fmt.pix.height,
> +		   fourcc_to_str(mbus_fmt.code),
> +		   fourcc_to_str(dev->v_fmt.fmt.pix.pixelformat),
> +		   fourcc_to_str(fmt->fourcc));
> +
> +	dev->fmt = fmt;
> +	dev->m_fmt = mbus_fmt;
> +	*f = dev->v_fmt;
> +
> +	return 0;
> +}
> +
> +static int unicam_queue_setup(struct vb2_queue *vq,
> +			      unsigned int *nbuffers,
> +			      unsigned int *nplanes,
> +			      unsigned int sizes[],
> +			      struct device *alloc_devs[])
> +{
> +	struct unicam_device *dev = vb2_get_drv_priv(vq);
> +	unsigned int size = dev->v_fmt.fmt.pix.sizeimage;
> +
> +	if (vq->num_buffers + *nbuffers < 3)
> +		*nbuffers = 3 - vq->num_buffers;
> +
> +	if (*nplanes) {
> +		if (sizes[0] < size) {
> +			unicam_err(dev, "sizes[0] %i < size %u\n",
> +				   sizes[0], size);
> +			return -EINVAL;
> +		}
> +		size = sizes[0];
> +	}
> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +
> +	return 0;
> +}
> +
> +static int unicam_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct unicam_device *dev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct unicam_buffer *buf = container_of(vb, struct unicam_buffer,
> +					      vb.vb2_buf);
> +	unsigned long size;
> +
> +	if (WARN_ON(!dev->fmt))
> +		return -EINVAL;
> +
> +	size = dev->v_fmt.fmt.pix.sizeimage;
> +	if (vb2_plane_size(vb, 0) < size) {
> +		unicam_err(dev, "data will not fit into plane (%lu < %lu)\n",
> +			   vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(&buf->vb.vb2_buf, 0, size);
> +	return 0;
> +}
> +
> +static void unicam_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct unicam_device *dev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct unicam_buffer *buf = container_of(vb, struct unicam_buffer,
> +					      vb.vb2_buf);
> +	struct unicam_dmaqueue *dma_queue = &dev->dma_queue;
> +	unsigned long flags = 0;
> +
> +	/* recheck locking */
> +	spin_lock_irqsave(&dev->dma_queue_lock, flags);
> +	list_add_tail(&buf->list, &dma_queue->active);
> +	spin_unlock_irqrestore(&dev->dma_queue_lock, flags);
> +}
> +
> +static void unicam_wr_dma_config(struct unicam_device *dev,
> +				 unsigned int stride)
> +{
> +	reg_write(&dev->cfg, UNICAM_IBLS, stride);
> +}
> +
> +static void unicam_set_packing_config(struct unicam_device *dev)
> +{
> +	int pack, unpack;
> +	u32 val;
> +	int mbus_depth = find_depth_by_code(dev->fmt->code);
> +	int v4l2_depth = dev->fmt->depth;
> +
> +	if (mbus_depth == v4l2_depth) {
> +		unpack = UNICAM_PUM_NONE;
> +		pack = UNICAM_PPM_NONE;
> +	} else {
> +		switch (mbus_depth) {
> +		case 8:
> +			unpack = UNICAM_PUM_UNPACK8;
> +			break;
> +		case 10:
> +			unpack = UNICAM_PUM_UNPACK10;
> +			break;
> +		case 12:
> +			unpack = UNICAM_PUM_UNPACK12;
> +			break;
> +		case 14:
> +			unpack = UNICAM_PUM_UNPACK14;
> +			break;
> +		case 16:
> +			unpack = UNICAM_PUM_UNPACK16;
> +			break;
> +		default:
> +			unpack = UNICAM_PUM_NONE;
> +			break;
> +		}
> +		switch (v4l2_depth) {
> +		case 8:
> +			pack = UNICAM_PPM_PACK8;
> +			break;
> +		case 10:
> +			pack = UNICAM_PPM_PACK10;
> +			break;
> +		case 12:
> +			pack = UNICAM_PPM_PACK12;
> +			break;
> +		case 14:
> +			pack = UNICAM_PPM_PACK14;
> +			break;
> +		case 16:
> +			pack = UNICAM_PPM_PACK16;
> +			break;
> +		default:
> +			pack = UNICAM_PPM_NONE;
> +			break;
> +		}
> +	}
> +
> +	val = 0;
> +	set_field(&val, 2, UNICAM_DEBL_MASK);
> +	set_field(&val, unpack, UNICAM_PUM_MASK);
> +	set_field(&val, pack, UNICAM_PPM_MASK);
> +	reg_write(&dev->cfg, UNICAM_IPIPE, val);
> +}
> +
> +static void unicam_cfg_image_id(struct unicam_device *dev)
> +{
> +	struct unicam_cfg *cfg = &dev->cfg;
> +
> +	if (dev->bus_type == V4L2_MBUS_CSI2) {
> +		/* CSI2 mode */
> +		reg_write(cfg, UNICAM_IDI0,
> +			  (dev->virtual_channel << 6) |
> +			  dev->fmt->csi_dt);
> +	} else { /* CCP2 mode */
> +		reg_write(cfg, UNICAM_IDI0,
> +			  (0x80 | dev->fmt->csi_dt));
> +	}
> +}
> +
> +void unicam_start_rx(struct unicam_device *dev, unsigned long addr)
> +{
> +	u32 val;
> +	unsigned int i;
> +	struct unicam_cfg *cfg = &dev->cfg;
> +	int line_int_freq = dev->v_fmt.fmt.pix.height >> 2;
> +
> +	if (line_int_freq < 128)
> +		line_int_freq = 128;
> +
> +	/* Enable lane clocks */
> +	val = 1;
> +	for (i = 0; i < dev->active_data_lanes; i++)
> +		val = val << 2 | 1;
> +	clk_write(cfg, val);
> +
> +	/* Basic init */
> +	reg_write(cfg, UNICAM_CTRL, UNICAM_MEM);
> +
> +	/* Enable analogue control, and leave in reset. */
> +	val = UNICAM_AR;
> +	set_field(&val, 7, UNICAM_CTATADJ_MASK);
> +	set_field(&val, 7, UNICAM_PTATADJ_MASK);
> +	reg_write(cfg, UNICAM_ANA, val);
> +	usleep_range(1000, 2000);
> +
> +	/* Come out of reset */
> +	reg_write_field(cfg, UNICAM_ANA, 0, UNICAM_AR);
> +
> +	/* Peripheral reset */
> +	reg_write_field(cfg, UNICAM_CTRL, 1, UNICAM_CPR);
> +	reg_write_field(cfg, UNICAM_CTRL, 0, UNICAM_CPR);
> +
> +	reg_write_field(cfg, UNICAM_CTRL, 0, UNICAM_CPE);
> +
> +	/* Enable Rx control. */
> +	val = reg_read(cfg, UNICAM_CTRL);
> +	set_field(&val, UNICAM_CPM_CSI2, UNICAM_CPM_MASK);
> +	set_field(&val, UNICAM_DCM_STROBE, UNICAM_DCM_MASK);
> +	set_field(&val, 0xF, UNICAM_PFT_MASK);
> +	set_field(&val, 128, UNICAM_OET_MASK);
> +	reg_write(cfg, UNICAM_CTRL, val);
> +
> +	reg_write(cfg, UNICAM_IHWIN, 0);
> +	reg_write(cfg, UNICAM_IVWIN, 0);
> +
> +	val = reg_read(&dev->cfg, UNICAM_PRI);
> +	set_field(&val, 0, UNICAM_BL_MASK);
> +	set_field(&val, 0, UNICAM_BS_MASK);
> +	set_field(&val, 0xE, UNICAM_PP_MASK);
> +	set_field(&val, 8, UNICAM_NP_MASK);
> +	set_field(&val, 2, UNICAM_PT_MASK);
> +	set_field(&val, 1, UNICAM_PE);
> +	reg_write(cfg, UNICAM_PRI, val);
> +
> +	reg_write_field(cfg, UNICAM_ANA, 0, UNICAM_DDL);
> +
> +	/* Always start in trigger frame capture mode (UNICAM_FCM set) */
> +	val = UNICAM_FSIE | UNICAM_FEIE | UNICAM_FCM;
> +	set_field(&val,  line_int_freq, UNICAM_LCIE_MASK);
> +	reg_write(cfg, UNICAM_ICTL, val);
> +	reg_write(cfg, UNICAM_STA, UNICAM_STA_MASK_ALL);
> +	reg_write(cfg, UNICAM_ISTA, UNICAM_ISTA_MASK_ALL);
> +
> +	/* tclk_term_en */
> +	reg_write_field(cfg, UNICAM_CLT, 2, UNICAM_CLT1_MASK);
> +	/* tclk_settle */
> +	reg_write_field(cfg, UNICAM_CLT, 6, UNICAM_CLT2_MASK);
> +	/* td_term_en */
> +	reg_write_field(cfg, UNICAM_DLT, 2, UNICAM_DLT1_MASK);
> +	/* ths_settle */
> +	reg_write_field(cfg, UNICAM_DLT, 6, UNICAM_DLT2_MASK);
> +	/* trx_enable */
> +	reg_write_field(cfg, UNICAM_DLT, 0, UNICAM_DLT3_MASK);
> +
> +	reg_write_field(cfg, UNICAM_CTRL, 0, UNICAM_SOE);
> +
> +	val = 0;
> +	set_field(&val, 1, UNICAM_PCE);
> +	set_field(&val, 1, UNICAM_GI);
> +	set_field(&val, 1, UNICAM_CPH);
> +	set_field(&val, 0, UNICAM_PCVC_MASK);
> +	set_field(&val, 1, UNICAM_PCDT_MASK);
> +	reg_write(cfg, UNICAM_CMP0, val);
> +
> +	/* Enable clock lane */
> +	val = 0;
> +	set_field(&val, 1, UNICAM_CLE);
> +	set_field(&val, 1, UNICAM_CLLPE);
> +	reg_write(cfg, UNICAM_CLK, val);
> +
> +	/* Enable required data lanes */
> +	val = 0;
> +	set_field(&val, 1, UNICAM_DLE);
> +	set_field(&val, 1, UNICAM_DLLPE);
> +	reg_write(cfg, UNICAM_DAT0, val);
> +
> +	if (dev->active_data_lanes == 1)
> +		val = 0;
> +	reg_write(cfg, UNICAM_DAT1, val);
> +
> +	if (dev->cfg.periph_max_data_lanes > 2) {
> +		if (dev->active_data_lanes == 2)
> +			val = 0;
> +		reg_write(cfg, UNICAM_DAT2, val);
> +
> +		if (dev->active_data_lanes == 3)
> +			val = 0;
> +		reg_write(cfg, UNICAM_DAT3, val);
> +	}
> +
> +	unicam_wr_dma_config(dev, dev->v_fmt.fmt.pix.bytesperline);
> +	unicam_wr_dma_addr(dev, addr);
> +	unicam_set_packing_config(dev);
> +	unicam_cfg_image_id(dev);
> +
> +	val = 0;
> +	set_field(&val, 0, UNICAM_EDL_MASK);
> +	reg_write(cfg, UNICAM_DCS, val);
> +
> +	val = reg_read(cfg, UNICAM_MISC);
> +	set_field(&val, 1, UNICAM_FL0);
> +	set_field(&val, 1, UNICAM_FL1);
> +	reg_write(cfg, UNICAM_MISC, val);
> +
> +	reg_write_field(cfg, UNICAM_CTRL, 1, UNICAM_CPE);
> +
> +	reg_write_field(cfg, UNICAM_ICTL, 1, UNICAM_LIP_MASK);
> +
> +	reg_write_field(cfg, UNICAM_DCS, 1, UNICAM_LDP);
> +
> +	/*
> +	 * Enable trigger only for the first frame to
> +	 * sync correctly to the FS from the source.
> +	 */
> +	reg_write_field(cfg, UNICAM_ICTL, 1, UNICAM_TFC);
> +}
> +
> +static void unicam_disable(struct unicam_device *dev)
> +{
> +	struct unicam_cfg *cfg = &dev->cfg;
> +
> +	/* Analogue lane control disable */
> +	reg_write_field(cfg, UNICAM_ANA, 1, UNICAM_DDL);
> +
> +	/* Stop the output engine */
> +	reg_write_field(cfg, UNICAM_CTRL, 1, UNICAM_SOE);
> +
> +	/* Disable the data lanes. */
> +	reg_write(cfg, UNICAM_DAT0, 0);
> +	reg_write(cfg, UNICAM_DAT1, 0);
> +
> +	if (dev->cfg.periph_max_data_lanes > 2) {
> +		reg_write(cfg, UNICAM_DAT2, 0);
> +		reg_write(cfg, UNICAM_DAT3, 0);
> +	}
> +
> +	/* Peripheral reset */
> +	reg_write_field(cfg, UNICAM_CTRL, 1, UNICAM_CPR);
> +	usleep_range(50, 100);
> +	reg_write_field(cfg, UNICAM_CTRL, 0, UNICAM_CPR);
> +
> +	/* Disable peripheral */
> +	reg_write_field(cfg, UNICAM_CTRL, 0, UNICAM_CPE);
> +
> +	/* Disable all lane clocks */
> +	clk_write(cfg, 0);
> +}
> +
> +static int unicam_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct unicam_device *dev = vb2_get_drv_priv(vq);
> +	struct unicam_dmaqueue *dma_q = &dev->dma_queue;
> +	struct unicam_buffer *buf, *tmp;
> +	unsigned long addr = 0;
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&dev->dma_queue_lock, flags);
> +	if (list_empty(&dma_q->active)) {
> +		spin_unlock_irqrestore(&dev->dma_queue_lock, flags);
> +		unicam_dbg(3, dev, "buffer queue is empty\n");
> +		return -EIO;

This can't happen. This function will only be called if at least 2 buffers
have been queued (the value you set as min_buffers_needed).

> +	}
> +
> +	buf = list_entry(dma_q->active.next, struct unicam_buffer, list);
> +	dev->cur_frm = buf;
> +	dev->next_frm = buf;
> +	list_del(&buf->list);
> +	spin_unlock_irqrestore(&dev->dma_queue_lock, flags);
> +
> +	addr = vb2_dma_contig_plane_dma_addr(&dev->cur_frm->vb.vb2_buf, 0);
> +	dev->sequence = 0;
> +
> +	ret = unicam_runtime_get(dev);
> +	if (ret < 0) {
> +		unicam_dbg(3, dev, "unicam_runtime_get failed\n");
> +		goto err_release_buffers;
> +	}
> +
> +	dev->active_data_lanes = dev->max_data_lanes;
> +	if (v4l2_subdev_has_op(dev->sensor, video, g_mbus_config)) {
> +		struct v4l2_mbus_config mbus_config;
> +
> +		ret = v4l2_subdev_call(dev->sensor, video, g_mbus_config,
> +				       &mbus_config);
> +		if (ret < 0) {
> +			unicam_dbg(3, dev, "g_mbus_config failed\n");
> +			goto err_pm_put;
> +		}
> +
> +		switch (mbus_config.flags & V4L2_MBUS_CSI2_LANES) {
> +		case V4L2_MBUS_CSI2_1_LANE:
> +			dev->active_data_lanes = 1;
> +			break;
> +		case V4L2_MBUS_CSI2_2_LANE:
> +			dev->active_data_lanes = 2;
> +			break;
> +		case V4L2_MBUS_CSI2_3_LANE:
> +			dev->active_data_lanes = 3;
> +			break;
> +		case V4L2_MBUS_CSI2_4_LANE:
> +			dev->active_data_lanes = 4;
> +			break;
> +		default:
> +			unicam_err(dev, "Invalid CSI2 lane flag value - %X\n",
> +				   mbus_config.flags & V4L2_MBUS_CSI2_LANES);
> +			break;
> +		}
> +	}
> +	if (dev->active_data_lanes > dev->cfg.periph_max_data_lanes) {
> +		unicam_err(dev, "Device has requested %u data lanes, which is >%u supported by peripheral",
> +			   dev->active_data_lanes,
> +			   dev->cfg.periph_max_data_lanes);
> +		ret = -EINVAL;
> +		goto err_pm_put;
> +	}
> +
> +	unicam_dbg(1, dev, "Running with %u data lanes\n",
> +		   dev->active_data_lanes);
> +
> +	ret = clk_set_rate(dev->clock, 100 * 1000 * 1000);
> +	if (ret) {
> +		unicam_err(dev, "failed to set up clock\n");
> +		goto err_pm_put;
> +	}
> +
> +	ret = clk_prepare_enable(dev->clock);
> +	if (ret) {
> +		unicam_err(dev, "Failed to enable CSI clock: %d\n", ret);
> +		goto err_pm_put;
> +	}
> +	ret = v4l2_subdev_call(dev->sensor, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD) {
> +		unicam_err(dev, "power on failed in subdev\n");
> +		goto err_clock_unprepare;
> +	}
> +	dev->streaming = 1;
> +
> +	unicam_start_rx(dev, addr);
> +
> +	ret = v4l2_subdev_call(dev->sensor, video, s_stream, 1);
> +	if (ret < 0) {
> +		unicam_err(dev, "stream on failed in subdev\n");
> +		goto err_disable_unicam;
> +	}
> +
> +	return 0;
> +
> +err_disable_unicam:
> +	unicam_disable(dev);
> +	v4l2_subdev_call(dev->sensor, core, s_power, 0);
> +err_clock_unprepare:
> +	clk_disable_unprepare(dev->clock);
> +err_pm_put:
> +	unicam_runtime_put(dev);
> +err_release_buffers:
> +	list_for_each_entry_safe(buf, tmp, &dma_q->active, list) {
> +		list_del(&buf->list);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> +	}
> +	if (dev->cur_frm != dev->next_frm)
> +		vb2_buffer_done(&dev->next_frm->vb.vb2_buf,
> +				VB2_BUF_STATE_QUEUED);
> +	vb2_buffer_done(&dev->cur_frm->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> +	dev->next_frm = NULL;
> +	dev->cur_frm = NULL;
> +
> +	return ret;
> +}
> +
> +static void unicam_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct unicam_device *dev = vb2_get_drv_priv(vq);
> +	struct unicam_dmaqueue *dma_q = &dev->dma_queue;
> +	struct unicam_buffer *buf, *tmp;
> +	unsigned long flags;
> +
> +	if (v4l2_subdev_call(dev->sensor, video, s_stream, 0) < 0)
> +		unicam_err(dev, "stream off failed in subdev\n");
> +
> +	unicam_disable(dev);
> +
> +	/* Release all active buffers */
> +	spin_lock_irqsave(&dev->dma_queue_lock, flags);
> +	list_for_each_entry_safe(buf, tmp, &dma_q->active, list) {
> +		list_del(&buf->list);
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	if (dev->cur_frm == dev->next_frm) {
> +		vb2_buffer_done(&dev->cur_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	} else {
> +		vb2_buffer_done(&dev->cur_frm->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		vb2_buffer_done(&dev->next_frm->vb.vb2_buf,
> +				VB2_BUF_STATE_ERROR);
> +	}
> +	dev->cur_frm = NULL;
> +	dev->next_frm = NULL;
> +	spin_unlock_irqrestore(&dev->dma_queue_lock, flags);
> +
> +	if (v4l2_subdev_has_op(dev->sensor, core, s_power)) {
> +		if (v4l2_subdev_call(dev->sensor, core, s_power, 0) < 0)
> +			unicam_err(dev, "power off failed in subdev\n");
> +	}
> +
> +	clk_disable_unprepare(dev->clock);
> +	unicam_runtime_put(dev);
> +}
> +
> +static int unicam_enum_input(struct file *file, void *priv,
> +			     struct v4l2_input *inp)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +
> +	if (inp->index != 0)
> +		return -EINVAL;
> +
> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> +	if (v4l2_subdev_has_op(dev->sensor, pad, dv_timings_cap)) {

Use s_dv_timings instead of dv_timings_cap.

> +		inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
> +		inp->std = 0;
> +	} else if (v4l2_subdev_has_op(dev->sensor, video, querystd)) {

Use s_std instead of querystd. FYI: querystd is not always implemented.

> +		inp->capabilities = V4L2_IN_CAP_STD;
> +		inp->std = V4L2_STD_ALL;

This needs to come from the g_tvnorms op.

> +	} else {
> +		inp->capabilities = 0;
> +		inp->std = 0;
> +	}
> +	sprintf(inp->name, "Camera 0");
> +	return 0;
> +}
> +
> +static int unicam_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	*i = dev->input;
> +	return 0;
> +}
> +
> +static int unicam_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	if (v4l2_subdev_has_op(dev->sensor, video, s_routing))
> +		ret =  v4l2_subdev_call(dev->sensor, video, s_routing, i, 0, 0);
> +	else
> +		ret = -EINVAL;	/* v4l2-compliance insists on -EINVAL */

Drop this if-else entirely. s_routing makes really no sense when using a device
tree. In this particular case there really is just one input, period.

> +
> +	/* Must always be able to set input to 0 */
> +	if (!i)
> +		ret = 0;
> +	if (!ret)
> +		dev->input = i;
> +
> +	return ret;
> +}
> +
> +static int unicam_querystd(struct file *file, void *priv,
> +			   v4l2_std_id *std)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret = v4l2_subdev_call(dev->sensor, video, querystd, std);
> +	return ret;

No need for the local ret variable.

> +}
> +
> +static int unicam_g_std(struct file *file, void *priv, v4l2_std_id *std)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret = v4l2_subdev_call(dev->sensor, video, g_std, std);
> +	return ret;
> +}
> +
> +static int unicam_s_std(struct file *file, void *priv, v4l2_std_id std)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret = v4l2_subdev_call(dev->sensor, video, s_std, std);
> +	return ret;
> +}
> +
> +static int unicam_s_edid(struct file *file, void *priv, struct v4l2_edid *edid)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret =  v4l2_subdev_call(dev->sensor, pad, set_edid, edid);
> +
> +	return ret;
> +}
> +
> +static int unicam_g_edid(struct file *file, void *priv, struct v4l2_edid *edid)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret =  v4l2_subdev_call(dev->sensor, pad, get_edid, edid);
> +
> +	return ret;
> +}
> +
> +static int unicam_g_dv_timings(struct file *file, void *priv,
> +			       struct v4l2_dv_timings *timings)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret =  v4l2_subdev_call(dev->sensor, video, g_dv_timings, timings);
> +
> +	return ret;
> +}
> +
> +static int unicam_s_dv_timings(struct file *file, void *priv,
> +			       struct v4l2_dv_timings *timings)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret =  v4l2_subdev_call(dev->sensor, video, s_dv_timings, timings);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> +
> +static int unicam_query_dv_timings(struct file *file, void *priv,
> +				   struct v4l2_dv_timings *timings)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret =  v4l2_subdev_call(dev->sensor, video, query_dv_timings, timings);
> +
> +	return ret;
> +}
> +
> +static int unicam_enum_dv_timings(struct file *file, void *priv,
> +				  struct v4l2_enum_dv_timings *timings)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret =  v4l2_subdev_call(dev->sensor, pad, enum_dv_timings, timings);
> +
> +	return ret;
> +}
> +
> +static int unicam_dv_timings_cap(struct file *file, void *priv,
> +				 struct v4l2_dv_timings_cap *cap)
> +{
> +	struct unicam_device *dev = video_drvdata(file);
> +	int ret;
> +
> +	ret =  v4l2_subdev_call(dev->sensor, pad, dv_timings_cap, cap);
> +
> +	return ret;
> +}
> +
> +static int unicam_subscribe_event(struct v4l2_fh *fh,
> +				  const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_event_subscribe(fh, sub, 4, NULL);
> +	}
> +
> +	return v4l2_ctrl_subscribe_event(fh, sub);
> +}
> +
> +static void unicam_notify(struct v4l2_subdev *sd,
> +			  unsigned int notification, void *arg)
> +{
> +	struct unicam_device *dev =
> +		container_of(sd->v4l2_dev, struct unicam_device, v4l2_dev);
> +
> +	switch (notification) {
> +	case V4L2_DEVICE_NOTIFY_EVENT:
> +		v4l2_event_queue(&dev->video_dev, arg);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static const struct vb2_ops unicam_video_qops = {
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +	.queue_setup		= unicam_queue_setup,
> +	.buf_prepare		= unicam_buffer_prepare,
> +	.buf_queue		= unicam_buffer_queue,
> +	.start_streaming	= unicam_start_streaming,
> +	.stop_streaming		= unicam_stop_streaming,
> +};
> +
> +/* unicam capture driver file operations */
> +static const struct v4l2_file_operations unicam_fops = {
> +	.owner		= THIS_MODULE,
> +	.open           = v4l2_fh_open,
> +	.release        = vb2_fop_release,
> +	.read		= vb2_fop_read,
> +	.poll		= vb2_fop_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= vb2_fop_mmap,
> +};
> +
> +/* unicam capture ioctl operations */
> +static const struct v4l2_ioctl_ops unicam_ioctl_ops = {
> +	.vidioc_querycap		= unicam_querycap,
> +	.vidioc_enum_fmt_vid_cap	= unicam_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= unicam_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= unicam_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		= unicam_try_fmt_vid_cap,
> +
> +	.vidioc_enum_input		= unicam_enum_input,
> +	.vidioc_g_input			= unicam_g_input,
> +	.vidioc_s_input			= unicam_s_input,
> +
> +	.vidioc_querystd		= unicam_querystd,
> +	.vidioc_s_std			= unicam_s_std,
> +	.vidioc_g_std			= unicam_g_std,
> +
> +	.vidioc_g_edid			= unicam_g_edid,
> +	.vidioc_s_edid			= unicam_s_edid,
> +
> +	.vidioc_s_dv_timings		= unicam_s_dv_timings,
> +	.vidioc_g_dv_timings		= unicam_g_dv_timings,
> +	.vidioc_query_dv_timings	= unicam_query_dv_timings,
> +	.vidioc_enum_dv_timings		= unicam_enum_dv_timings,
> +	.vidioc_dv_timings_cap		= unicam_dv_timings_cap,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +
> +	.vidioc_log_status		= v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		= unicam_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};
> +
> +static int
> +unicam_async_bound(struct v4l2_async_notifier *notifier,
> +		   struct v4l2_subdev *subdev,
> +		   struct v4l2_async_subdev *asd)
> +{
> +	struct unicam_device *unicam = container_of(notifier->v4l2_dev,
> +					       struct unicam_device, v4l2_dev);
> +	struct v4l2_subdev_mbus_code_enum mbus_code;
> +	int j;
> +	struct unicam_fmt *active_fmt;
> +	int ret = 0;
> +
> +	unicam_dbg(1, unicam, "unicam_async_bound\n");
> +
> +	if (unicam->sensor) {
> +		unicam_info(unicam, "Rejecting subdev %s (Already set!!)",
> +			    subdev->name);
> +		return 0;
> +	}
> +
> +	unicam->sensor = subdev;
> +	unicam_dbg(1, unicam, "Using sensor %s for capture\n", subdev->name);
> +
> +	/* Enumerate sub device formats and enable all matching local formats */
> +	unicam->num_active_fmt = 0;
> +	active_fmt = &unicam->active_fmts[0];
> +	unicam_dbg(2, unicam, "Get supported formats...\n");
> +	for (j = 0; ret != -EINVAL && ret != -ENOIOCTLCMD; ++j) {
> +		const struct unicam_fmt *fmt = NULL;
> +		int k;
> +
> +		memset(&mbus_code, 0, sizeof(mbus_code));
> +		mbus_code.index = j;
> +		ret = v4l2_subdev_call(subdev, pad, enum_mbus_code,
> +				       NULL, &mbus_code);
> +		if (ret < 0) {
> +			unicam_dbg(2, unicam,
> +				   "subdev->enum_mbus_code idx %d returned %d - continue\n",
> +				   j, ret);
> +			continue;
> +		}
> +
> +		unicam_dbg(2, unicam,
> +			   "subdev %s: code: %04x idx: %d\n",
> +			   subdev->name, mbus_code.code, j);
> +
> +		for (k = 0; k < ARRAY_SIZE(formats); k++) {
> +			if (mbus_code.code == formats[k].code) {
> +				fmt = &formats[k];
> +				break;
> +			}
> +		}
> +		unicam_dbg(2, unicam, "fmt %04x returned as %p, V4L2 FOURCC %04x, csi_dt %02X\n",
> +			   mbus_code.code, fmt, fmt ? fmt->fourcc : 0,
> +			   fmt ? fmt->csi_dt : 0);
> +		if (fmt) {
> +			const struct bayer_fmt *fmt_list = NULL;
> +
> +			switch (fmt->fourcc) {
> +			case PIX_FMT_ALL_BGGR:
> +				fmt_list = all_bayer_bggr;
> +				break;
> +			case PIX_FMT_ALL_RGGB:
> +				fmt_list = all_bayer_rggb;
> +				break;
> +			case PIX_FMT_ALL_GBRG:
> +				fmt_list = all_bayer_gbrg;
> +				break;
> +			case PIX_FMT_ALL_GRBG:
> +				fmt_list = all_bayer_grbg;
> +				break;
> +			}
> +			if (fmt_list) {
> +				for (k = 0; fmt_list[k].fourcc; k++) {
> +					*active_fmt = *fmt;
> +					active_fmt->fourcc = fmt_list[k].fourcc;
> +					active_fmt->depth = fmt_list[k].depth;
> +					unicam_dbg(2, unicam,
> +						   "matched fourcc: %s: code: %04x idx: %d\n",
> +						   fourcc_to_str(fmt->fourcc),
> +						   fmt->code,
> +						   unicam->num_active_fmt);
> +					unicam->num_active_fmt++;
> +					active_fmt++;
> +				}
> +			} else {
> +				*active_fmt = *fmt;
> +				unicam_dbg(2, unicam,
> +					   "matched fourcc: %s: code: %04x idx: %d\n",
> +					   fourcc_to_str(fmt->fourcc),
> +					   fmt->code,
> +					   unicam->num_active_fmt);
> +				unicam->num_active_fmt++;
> +				active_fmt++;
> +			}
> +		}
> +	}
> +	unicam_dbg(2, unicam,
> +		   "Done all formats\n");
> +	dump_active_formats(unicam);
> +
> +	return 0;
> +}
> +
> +static int unicam_probe_complete(struct unicam_device *unicam)
> +{
> +	struct video_device *vdev;
> +	struct vb2_queue *q;
> +	const struct unicam_fmt *fmt;
> +	struct v4l2_mbus_framefmt mbus_fmt;
> +	int ret;
> +
> +	v4l2_set_subdev_hostdata(unicam->sensor, unicam);
> +
> +	unicam->v4l2_dev.notify = unicam_notify;
> +
> +	unicam->sensor_config = v4l2_subdev_alloc_pad_config(unicam->sensor);
> +	if (!unicam->sensor_config)
> +		return -ENOMEM;
> +
> +	ret = __subdev_get_format(unicam, &mbus_fmt);
> +	if (ret) {
> +		unicam_err(unicam, "Failed to get_format - ret %d\n", ret);
> +		return ret;
> +	}
> +
> +	fmt = find_format_by_code(unicam, mbus_fmt.code);
> +	if (!fmt) {
> +		unicam_dbg(3, unicam, "mbus code format (0x%08x) not found.\n",
> +			   mbus_fmt.code);
> +		return -EINVAL;
> +	}
> +
> +	/* Save current subdev format */
> +	v4l2_fill_pix_format(&unicam->v_fmt.fmt.pix, &mbus_fmt);
> +	unicam->v_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	unicam->v_fmt.fmt.pix.pixelformat  = fmt->fourcc;
> +	unicam->v_fmt.fmt.pix.bytesperline = 0;
> +	unicam_calc_format_size(unicam, fmt, &unicam->v_fmt);
> +	unicam->fmt = fmt;
> +	unicam->m_fmt = mbus_fmt;
> +
> +	if (v4l2_subdev_has_op(unicam->sensor, video, querystd)) {

Check against s_std

> +		if (v4l2_subdev_has_op(unicam->sensor, video, g_tvnorms)) {
> +			v4l2_std_id tvnorms;
> +
> +			ret = v4l2_subdev_call(unicam->sensor, video,
> +					       g_tvnorms, &tvnorms);
> +			if (ret) {
> +				unicam_dbg(1, unicam, "Sensor supports g_tvnorms, but returned error\n");
> +				unicam->video_dev.tvnorms |= V4L2_STD_ALL;

I recommend a WARN_ON and an error return. This really should not happen.
If it does, then it is a subdev bug.

> +			} else {
> +				unicam->video_dev.tvnorms |= tvnorms;
> +			}
> +		} else {
> +			unicam->video_dev.tvnorms |= V4L2_STD_ALL;

Same here.

> +		}
> +	}

Based on the subdev capabilities (sensor, STD, DV_TIMINGS) you should disable ioctls
by calling v4l2_disable_ioctl. See e.g. drivers/media/platform/vivid/vivid-core.c.

> +
> +	spin_lock_init(&unicam->dma_queue_lock);
> +	mutex_init(&unicam->lock);
> +
> +	/* Add controls from the subdevice */
> +	ret = v4l2_ctrl_add_handler(&unicam->ctrl_handler,
> +				    unicam->sensor->ctrl_handler, NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	q = &unicam->buffer_queue;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
> +	q->drv_priv = unicam;
> +	q->ops = &unicam_video_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->buf_struct_size = sizeof(struct unicam_buffer);
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &unicam->lock;
> +	q->min_buffers_needed = 2;
> +	q->dev = &unicam->pdev->dev;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		unicam_err(unicam, "vb2_queue_init() failed\n");
> +		return ret;
> +	}
> +
> +	INIT_LIST_HEAD(&unicam->dma_queue.active);
> +
> +	vdev = &unicam->video_dev;
> +	strlcpy(vdev->name, UNICAM_MODULE_NAME, sizeof(vdev->name));
> +	vdev->release = video_device_release_empty;
> +	vdev->fops = &unicam_fops;
> +	vdev->ioctl_ops = &unicam_ioctl_ops;
> +	vdev->v4l2_dev = &unicam->v4l2_dev;
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	vdev->queue = q;
> +	vdev->lock = &unicam->lock;
> +	vdev->dev_debug = 0xff;

Drop this line. Shouldn't be set by drivers.

But you should set vdev->device_caps here.

> +	video_set_drvdata(vdev, unicam);
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		unicam_err(unicam,
> +			   "Unable to register video device.\n");
> +		return ret;
> +	}
> +
> +	ret = v4l2_device_register_subdev_nodes(&unicam->v4l2_dev);
> +	if (ret) {
> +		unicam_err(unicam,
> +			   "Unable to register subdev nodes.\n");
> +		video_unregister_device(&unicam->video_dev);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int unicam_async_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct unicam_device *unicam = container_of(notifier->v4l2_dev,
> +					struct unicam_device, v4l2_dev);
> +
> +	return unicam_probe_complete(unicam);
> +}
> +
> +static struct device_node *
> +of_get_port(const struct device_node *parent)
> +{
> +	struct device_node *port = NULL;
> +
> +	if (!parent)
> +		return NULL;
> +
> +	port = of_get_child_by_name(parent, "port");
> +
> +	return port;
> +}
> +
> +static struct device_node *
> +of_get_next_endpoint(const struct device_node *parent,
> +		     struct device_node *prev)
> +{
> +	struct device_node *ep = NULL;
> +
> +	if (!parent)
> +		return NULL;
> +
> +	do {
> +		ep = of_get_next_child(parent, prev);
> +		if (!ep)
> +			return NULL;
> +		prev = ep;
> +	} while (of_node_cmp(ep->name, "endpoint") != 0);
> +
> +	return ep;
> +}
> +
> +static int of_unicam_connect_subdevs(struct unicam_device *dev)
> +{
> +	struct platform_device *pdev = dev->pdev;
> +	struct device_node *parent, *ep_node = NULL, *port = NULL,
> +			*remote_ep = NULL, *sensor_node = NULL;
> +	struct v4l2_fwnode_endpoint *endpoint;
> +	struct v4l2_async_subdev *asd;
> +	int ret = -EINVAL;
> +	unsigned int lane;
> +	struct v4l2_async_subdev **subdevs = NULL;
> +
> +	parent = pdev->dev.of_node;
> +
> +	asd = &dev->asd;
> +	endpoint = &dev->endpoint;
> +
> +	dev->cfg.periph_max_data_lanes = DEFAULT_MAX_DATA_LANES;
> +	of_property_read_u32(parent, "max_data_lanes",
> +			     &dev->cfg.periph_max_data_lanes);
> +
> +	unicam_dbg(3, dev, "Scanning Port node for csi2 port\n");
> +	port = of_get_port(parent);
> +	if (!port) {
> +		unicam_dbg(1, dev, "No port node found for csi2 port\n");
> +		goto cleanup_exit;
> +	}
> +
> +	if (!port) {
> +		unicam_dbg(1, dev, "No port node matches csi2 port\n");
> +		goto cleanup_exit;
> +	}
> +
> +	unicam_dbg(3, dev, "Scanning sub-device for csi2 port\n");
> +
> +	ep_node = of_get_next_endpoint(port, ep_node);
> +	if (!ep_node) {
> +		unicam_dbg(3, dev, "can't get next endpoint\n");
> +		goto cleanup_exit;
> +	}
> +
> +	unicam_dbg(3, dev, "ep_node is %s\n",
> +		   ep_node->name);
> +
> +	sensor_node = of_graph_get_remote_port_parent(ep_node);
> +	if (!sensor_node) {
> +		unicam_dbg(3, dev, "can't get remote parent\n");
> +		goto cleanup_exit;
> +	}
> +	unicam_dbg(3, dev, "sensor_node is %s\n",
> +		   sensor_node->name);
> +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> +	asd->match.fwnode.fwnode = of_fwnode_handle(sensor_node);
> +
> +	remote_ep = of_parse_phandle(ep_node, "remote-endpoint", 0);
> +	if (!remote_ep) {
> +		unicam_dbg(3, dev, "can't get remote-endpoint\n");
> +		goto cleanup_exit;
> +	}
> +	unicam_dbg(3, dev, "remote_ep is %s\n",
> +		   remote_ep->name);
> +	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
> +	unicam_dbg(3, dev, "parsed remote_ep to endpoint. nr_of_link_frequencies %u, bus_type %u\n",
> +		   endpoint->nr_of_link_frequencies, endpoint->bus_type);
> +
> +	if (endpoint->bus_type != V4L2_MBUS_CSI2) {
> +		/* We can support CCP2 too, but no enum defined for that. */
> +		unicam_err(dev, "sub-device %s is not a CSI2 device %d\n",
> +			   sensor_node->name, endpoint->bus_type);
> +		goto cleanup_exit;
> +	}
> +
> +	/* Store bus type - CSI2 vs CCP2 */
> +	dev->bus_type = endpoint->bus_type;
> +	unicam_dbg(3, dev, "bus_type is %d\n", dev->bus_type);
> +
> +	/* Store Virtual Channel number */
> +	dev->virtual_channel = endpoint->base.id;
> +
> +	/* Store number of data lanes */
> +	dev->max_data_lanes = endpoint->bus.mipi_csi2.num_data_lanes;
> +
> +	if (dev->max_data_lanes > dev->cfg.periph_max_data_lanes) {
> +		/* We can support CCP2 too, but no enum defined for that. */
> +		unicam_err(dev, "Subdevice %s wants too many data lanes (%u > %u)\n",
> +			   sensor_node->name, dev->max_data_lanes,
> +			   dev->cfg.periph_max_data_lanes);
> +		goto cleanup_exit;
> +	}
> +	for (lane = 0; lane < dev->max_data_lanes; lane++) {
> +		if (endpoint->bus.mipi_csi2.data_lanes[lane] != lane + 1) {
> +			unicam_err(dev, "Subdevice %s - incompatible data lane config\n",
> +				   sensor_node->name);
> +			goto cleanup_exit;
> +		}
> +	}
> +
> +	unicam_dbg(3, dev, "v4l2-endpoint: CSI2\n");
> +	unicam_dbg(3, dev, "Virtual Channel=%d\n", dev->virtual_channel);
> +	unicam_dbg(3, dev, "flags=0x%08x\n", endpoint->bus.mipi_csi2.flags);
> +	unicam_dbg(3, dev, "clock_lane=%d\n",
> +		   endpoint->bus.mipi_csi2.clock_lane);
> +	unicam_dbg(3, dev, "num_data_lanes=%d\n",
> +		   endpoint->bus.mipi_csi2.num_data_lanes);
> +	unicam_dbg(3, dev, "data_lanes= <\n");
> +	for (lane = 0; lane < endpoint->bus.mipi_csi2.num_data_lanes; lane++)
> +		unicam_dbg(3, dev, "\t%u\n",
> +			   endpoint->bus.mipi_csi2.data_lanes[lane]);
> +	unicam_dbg(3, dev, "\t>\n");
> +
> +	unicam_dbg(1, dev, "found sub-device %s\n",
> +		   sensor_node->name);
> +
> +	subdevs = devm_kzalloc(&dev->pdev->dev, sizeof(*subdevs), GFP_KERNEL);
> +	if (!subdevs) {
> +		ret = -ENOMEM;
> +		goto cleanup_exit;
> +	}
> +	subdevs[0] = asd;
> +	dev->notifier.subdevs = subdevs;
> +	dev->notifier.num_subdevs = 1;
> +	dev->notifier.bound = unicam_async_bound;
> +	dev->notifier.complete = unicam_async_complete;
> +	ret = v4l2_async_notifier_register(&dev->v4l2_dev,
> +					   &dev->notifier);
> +	if (ret) {
> +		unicam_err(dev, "Error registering async notifier - ret %d\n",
> +			   ret);
> +		ret = -EINVAL;
> +	}
> +
> +cleanup_exit:
> +	if (remote_ep)
> +		of_node_put(remote_ep);
> +	if (sensor_node)
> +		of_node_put(sensor_node);
> +	if (ep_node)
> +		of_node_put(ep_node);
> +	if (port)
> +		of_node_put(port);
> +
> +	return ret;
> +}
> +
> +/*
> + * unicam_probe : This function creates device entries by register
> + * itself to the V4L2 driver and initializes fields of each
> + * device objects
> + */
> +static int unicam_probe(struct platform_device *pdev)
> +{
> +	struct unicam_cfg *unicam_cfg;
> +	struct unicam_device *unicam;
> +	struct v4l2_ctrl_handler *hdl;
> +	struct resource	*res;
> +	int ret;
> +
> +	unicam = devm_kzalloc(&pdev->dev, sizeof(*unicam), GFP_KERNEL);
> +	if (!unicam)
> +		return -ENOMEM;
> +
> +	unicam->pdev = pdev;
> +	unicam_cfg = &unicam->cfg;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	unicam_cfg->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(unicam_cfg->base)) {
> +		unicam_err(unicam, "Failed to get main io block\n");
> +		return PTR_ERR(unicam_cfg->base);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	unicam_cfg->clk_gate_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(unicam_cfg->clk_gate_base)) {
> +		unicam_err(unicam, "Failed to get 2nd io block\n");
> +		return PTR_ERR(unicam_cfg->clk_gate_base);
> +	}
> +
> +	unicam->clock = devm_clk_get(&pdev->dev, "lp_clock");
> +	if (IS_ERR(unicam->clock)) {
> +		unicam_err(unicam, "Failed to get clock\n");
> +		return PTR_ERR(unicam->clock);
> +	}
> +
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret <= 0) {
> +		dev_err(&pdev->dev, "No IRQ resource\n");
> +		return -ENODEV;
> +	}
> +	unicam_cfg->irq = ret;
> +
> +	ret = devm_request_irq(&pdev->dev, unicam_cfg->irq, unicam_isr, 0,
> +			       "unicam_capture0", unicam);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to request interrupt\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = v4l2_device_register(&pdev->dev, &unicam->v4l2_dev);
> +	if (ret) {
> +		unicam_err(unicam,
> +			   "Unable to register v4l2 device.\n");
> +		return ret;
> +	}
> +
> +	/* Reserve space for the controls */
> +	/*
> +	 * Currently the subdev with the largest number of controls (13) is
> +	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> +	 * that this is a hint only: too large and you waste some memory, too
> +	 * small and there is a (very) small performance hit when looking up
> +	 * controls in the internal hash.
> +	 */
> +	hdl = &unicam->ctrl_handler;
> +	ret = v4l2_ctrl_handler_init(hdl, 16);
> +	if (ret < 0)
> +		goto probe_out_v4l2_unregister;
> +	unicam->v4l2_dev.ctrl_handler = hdl;
> +
> +	/* set the driver data in platform device */
> +	platform_set_drvdata(pdev, unicam);
> +
> +	ret = of_unicam_connect_subdevs(unicam);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to connect subdevs\n");
> +		goto free_hdl;
> +	}
> +
> +	/* Enabling module functional clock */
> +	pm_runtime_enable(&pdev->dev);
> +
> +	return 0;
> +
> +free_hdl:
> +	v4l2_ctrl_handler_free(hdl);
> +probe_out_v4l2_unregister:
> +	v4l2_device_unregister(&unicam->v4l2_dev);
> +	return ret;
> +}
> +
> +/*
> + * unicam_remove : It un-register device from V4L2 driver
> + */
> +static int unicam_remove(struct platform_device *pdev)
> +{
> +	struct unicam_device *unicam = platform_get_drvdata(pdev);
> +
> +	unicam_dbg(2, unicam, "%s\n", __func__);
> +
> +	pm_runtime_disable(&pdev->dev);
> +
> +	v4l2_async_notifier_unregister(&unicam->notifier);
> +	v4l2_ctrl_handler_free(&unicam->ctrl_handler);
> +	v4l2_device_unregister(&unicam->v4l2_dev);
> +	video_unregister_device(&unicam->video_dev);
> +	if (unicam->sensor_config)
> +		v4l2_subdev_free_pad_config(unicam->sensor_config);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id unicam_of_match[] = {
> +	{ .compatible = "brcm,bcm2835-unicam", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, unicam_of_match);
> +
> +static struct platform_driver unicam_driver = {
> +	.probe		= unicam_probe,
> +	.remove		= unicam_remove,
> +	.driver = {
> +		.name	= UNICAM_MODULE_NAME,
> +		.of_match_table = of_match_ptr(unicam_of_match),
> +	},
> +};
> +
> +module_platform_driver(unicam_driver);
> +
> +MODULE_AUTHOR("Dave Stevenson <dave.stevenson@raspberrypi.org>");
> +MODULE_DESCRIPTION("BCM2835 Unicam driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(UNICAM_VERSION);
> diff --git a/drivers/media/platform/bcm2835/vc4-regs-unicam.h b/drivers/media/platform/bcm2835/vc4-regs-unicam.h
> new file mode 100644
> index 0000000..793e42a
> --- /dev/null
> +++ b/drivers/media/platform/bcm2835/vc4-regs-unicam.h
> @@ -0,0 +1,257 @@
> +/*
> + *  Copyright (C) 2017 Raspberry Pi Trading.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef VC4_REGS_UNICAM_H
> +#define VC4_REGS_UNICAM_H
> +
> +/* The following values are taken from files found within the code drop
> + * made by Broadcom for the BCM21553 Graphics Driver.
> + */
> +
> +/*
> + * Modified from brcm_usrlib/dag/vmcsx/vcinclude/hardware_vc4.h to
> + * just have the offset, and use the BIT and GENMASK kernel macros.
> + */
> +
> +#define UNICAM_CTRL	0x000
> +#define UNICAM_STA	0x004
> +#define UNICAM_ANA	0x008
> +#define UNICAM_PRI	0x00c
> +#define UNICAM_CLK	0x010
> +#define UNICAM_CLT	0x014
> +#define UNICAM_DAT0	0x018
> +#define UNICAM_DAT1	0x01c
> +#define UNICAM_DAT2	0x020
> +#define UNICAM_DAT3	0x024
> +#define UNICAM_DLT	0x028
> +#define UNICAM_CMP0	0x02c
> +#define UNICAM_CMP1	0x030
> +#define UNICAM_CAP0	0x034
> +#define UNICAM_CAP1	0x038
> +#define UNICAM_ICTL	0x100
> +#define UNICAM_ISTA	0x104
> +#define UNICAM_IDI0	0x108
> +#define UNICAM_IPIPE	0x10c
> +#define UNICAM_IBSA0	0x110
> +#define UNICAM_IBEA0	0x114
> +#define UNICAM_IBLS	0x118
> +#define UNICAM_IBWP	0x11c
> +#define UNICAM_IHWIN	0x120
> +#define UNICAM_IHSTA	0x124
> +#define UNICAM_IVWIN	0x128
> +#define UNICAM_IVSTA	0x12c
> +#define UNICAM_ICC	0x130
> +#define UNICAM_ICS	0x134
> +#define UNICAM_IDC	0x138
> +#define UNICAM_IDPO	0x13c
> +#define UNICAM_IDCA	0x140
> +#define UNICAM_IDCD	0x144
> +#define UNICAM_IDS	0x148
> +#define UNICAM_DCS	0x200
> +#define UNICAM_DBSA0	0x204
> +#define UNICAM_DBEA0	0x208
> +#define UNICAM_DBWP	0x20c
> +#define UNICAM_DBCTL	0x300
> +#define UNICAM_IBSA1	0x304
> +#define UNICAM_IBEA1	0x308
> +#define UNICAM_IDI1	0x30c
> +#define UNICAM_DBSA1	0x310
> +#define UNICAM_DBEA1	0x314
> +#define UNICAM_MISC	0x400
> +
> +/* The following bitmasks are from Broadcom datasheets */
> +/* UNICAM_CTRL Register */
> +#define UNICAM_CPE		BIT(0)
> +#define UNICAM_MEM		BIT(1)
> +#define UNICAM_CPR		BIT(2)
> +#define UNICAM_CPM_MASK		GENMASK(3, 3)
> +#define UNICAM_CPM_CSI2		0
> +#define UNICAM_CPM_CCP2		1
> +#define UNICAM_SOE		BIT(4)
> +#define UNICAM_DCM_MASK		GENMASK(5, 5)
> +#define UNICAM_DCM_STROBE	0
> +#define UNICAM_DCM_DATA		1
> +#define UNICAM_SLS		BIT(6)
> +#define UNICAM_PFT_MASK		GENMASK(11, 8)
> +#define UNICAM_OET_MASK		GENMASK(20, 12)
> +
> +/* UNICAM_STA Register */
> +#define UNICAM_SYN		BIT(0)
> +#define UNICAM_CS		BIT(1)
> +#define UNICAM_SBE		BIT(2)
> +#define UNICAM_PBE		BIT(3)
> +#define UNICAM_HOE		BIT(4)
> +#define UNICAM_PLE		BIT(5)
> +#define UNICAM_SSC		BIT(6)
> +#define UNICAM_CRCE		BIT(7)
> +#define UNICAM_OES		BIT(8)
> +#define UNICAM_IFO		BIT(9)
> +#define UNICAM_OFO		BIT(10)
> +#define UNICAM_BFO		BIT(11)
> +#define UNICAM_DL		BIT(12)
> +#define UNICAM_PS		BIT(13)
> +#define UNICAM_IS		BIT(14)
> +#define UNICAM_PI0		BIT(15)
> +#define UNICAM_PI1		BIT(16)
> +#define UNICAM_FSI_S		BIT(17)
> +#define UNICAM_FEI_S		BIT(18)
> +#define UNICAM_LCI_S		BIT(19)
> +#define UNICAM_BUF0_RDY		BIT(20)
> +#define UNICAM_BUF0_NO		BIT(21)
> +#define UNICAM_BUF1_RDY		BIT(22)
> +#define UNICAM_BUF1_NO		BIT(23)
> +#define UNICAM_DI		BIT(24)
> +
> +#define UNICAM_STA_MASK_ALL \
> +		(UNICAM_DL + \
> +		UNICAM_SBE + \
> +		UNICAM_PBE + \
> +		UNICAM_HOE + \
> +		UNICAM_PLE + \
> +		UNICAM_SSC + \
> +		UNICAM_CRCE + \
> +		UNICAM_IFO + \
> +		UNICAM_OFO + \
> +		UNICAM_PS + \
> +		UNICAM_PI0 + \
> +		UNICAM_PI1)
> +
> +/* UNICAM_ANA Register */
> +#define UNICAM_APD		BIT(0)
> +#define UNICAM_BPD		BIT(1)
> +#define UNICAM_AR		BIT(2)
> +#define UNICAM_DDL		BIT(3)
> +#define UNICAM_CTATADJ_MASK	GENMASK(7, 4)
> +#define UNICAM_PTATADJ_MASK	GENMASK(11, 8)
> +
> +/* UNICAM_PRI Register */
> +#define UNICAM_PE		BIT(0)
> +#define UNICAM_PT_MASK		GENMASK(2, 1)
> +#define UNICAM_NP_MASK		GENMASK(7, 4)
> +#define UNICAM_PP_MASK		GENMASK(11, 8)
> +#define UNICAM_BS_MASK		GENMASK(15, 12)
> +#define UNICAM_BL_MASK		GENMASK(17, 16)
> +
> +/* UNICAM_CLK Register */
> +#define UNICAM_CLE		BIT(0)
> +#define UNICAM_CLPD		BIT(1)
> +#define UNICAM_CLLPE		BIT(2)
> +#define UNICAM_CLHSE		BIT(3)
> +#define UNICAM_CLTRE		BIT(4)
> +#define UNICAM_CLAC_MASK	GENMASK(8, 5)
> +#define UNICAM_CLSTE		BIT(29)
> +
> +/* UNICAM_CLT Register */
> +#define UNICAM_CLT1_MASK	GENMASK(7, 0)
> +#define UNICAM_CLT2_MASK	GENMASK(15, 8)
> +
> +/* UNICAM_DATn Registers */
> +#define UNICAM_DLE		BIT(0)
> +#define UNICAM_DLPD		BIT(1)
> +#define UNICAM_DLLPE		BIT(2)
> +#define UNICAM_DLHSE		BIT(3)
> +#define UNICAM_DLTRE		BIT(4)
> +#define UNICAM_DLSM		BIT(5)
> +#define UNICAM_DLFO		BIT(28)
> +#define UNICAM_DLSTE		BIT(29)
> +
> +#define UNICAM_DAT_MASK_ALL (UNICAM_DLSTE + UNICAM_DLFO)
> +
> +/* UNICAM_DLT Register */
> +#define UNICAM_DLT1_MASK	GENMASK(7, 0)
> +#define UNICAM_DLT2_MASK	GENMASK(15, 8)
> +#define UNICAM_DLT3_MASK	GENMASK(23, 16)
> +
> +/* UNICAM_ICTL Register */
> +#define UNICAM_FSIE		BIT(0)
> +#define UNICAM_FEIE		BIT(1)
> +#define UNICAM_IBOB		BIT(2)
> +#define UNICAM_FCM		BIT(3)
> +#define UNICAM_TFC		BIT(4)
> +#define UNICAM_LIP_MASK		GENMASK(6, 5)
> +#define UNICAM_LCIE_MASK	GENMASK(28, 16)
> +
> +/* UNICAM_IDI0/1 Register */
> +#define UNICAM_ID0_MASK		GENMASK(7, 0)
> +#define UNICAM_ID1_MASK		GENMASK(15, 8)
> +#define UNICAM_ID2_MASK		GENMASK(23, 16)
> +#define UNICAM_ID3_MASK		GENMASK(31, 24)
> +
> +/* UNICAM_ISTA Register */
> +#define UNICAM_FSI		BIT(0)
> +#define UNICAM_FEI		BIT(1)
> +#define UNICAM_LCI		BIT(2)
> +
> +#define UNICAM_ISTA_MASK_ALL (UNICAM_FSI + UNICAM_FEI + UNICAM_LCI)
> +
> +/* UNICAM_IPIPE Register */
> +#define UNICAM_PUM_MASK		GENMASK(2, 0)
> +		/* Unpacking modes */
> +		#define UNICAM_PUM_NONE		0
> +		#define UNICAM_PUM_UNPACK6	1
> +		#define UNICAM_PUM_UNPACK7	2
> +		#define UNICAM_PUM_UNPACK8	3
> +		#define UNICAM_PUM_UNPACK10	4
> +		#define UNICAM_PUM_UNPACK12	5
> +		#define UNICAM_PUM_UNPACK14	6
> +		#define UNICAM_PUM_UNPACK16	7
> +#define UNICAM_DDM_MASK		GENMASK(6, 3)
> +#define UNICAM_PPM_MASK		GENMASK(9, 7)
> +		/* Packing modes */
> +		#define UNICAM_PPM_NONE		0
> +		#define UNICAM_PPM_PACK8	1
> +		#define UNICAM_PPM_PACK10	2
> +		#define UNICAM_PPM_PACK12	3
> +		#define UNICAM_PPM_PACK14	4
> +		#define UNICAM_PPM_PACK16	5
> +#define UNICAM_DEM_MASK		GENMASK(11, 10)
> +#define UNICAM_DEBL_MASK	GENMASK(14, 12)
> +#define UNICAM_ICM_MASK		GENMASK(16, 15)
> +#define UNICAM_IDM_MASK		GENMASK(17, 17)
> +
> +/* UNICAM_ICC Register */
> +#define UNICAM_ICFL_MASK	GENMASK(4, 0)
> +#define UNICAM_ICFH_MASK	GENMASK(9, 5)
> +#define UNICAM_ICST_MASK	GENMASK(12, 10)
> +#define UNICAM_ICLT_MASK	GENMASK(15, 13)
> +#define UNICAM_ICLL_MASK	GENMASK(31, 16)
> +
> +/* UNICAM_DCS Register */
> +#define UNICAM_DIE		BIT(0)
> +#define UNICAM_DIM		BIT(1)
> +#define UNICAM_DBOB		BIT(3)
> +#define UNICAM_FDE		BIT(4)
> +#define UNICAM_LDP		BIT(5)
> +#define UNICAM_EDL_MASK		GENMASK(15, 8)
> +
> +/* UNICAM_DBCTL Register */
> +#define UNICAM_DBEN		BIT(0)
> +#define UNICAM_BUF0_IE		BIT(1)
> +#define UNICAM_BUF1_IE		BIT(2)
> +
> +/* UNICAM_CMP[0,1] register */
> +#define UNICAM_PCE		BIT(31)
> +#define UNICAM_GI		BIT(9)
> +#define UNICAM_CPH		BIT(8)
> +#define UNICAM_PCVC_MASK	GENMASK(7, 6)
> +#define UNICAM_PCDT_MASK	GENMASK(5, 0)
> +
> +/* UNICAM_MISC register */
> +#define UNICAM_FL0		BIT(6)
> +#define UNICAM_FL1		BIT(9)
> +
> +#endif
> 

Overall this looks pretty good!

Regards,

	Hans
