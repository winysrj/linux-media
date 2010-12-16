Return-path: <mchehab@gaivota>
Received: from mail-bw0-f42.google.com ([209.85.214.42]:48076 "EHLO
	mail-bw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LPW7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 17:59:54 -0500
Received: by bwz13 with SMTP id 13so258835bwz.1
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 14:59:52 -0800 (PST)
Message-ID: <4D0A985A.6010007@gmail.com>
Date: Thu, 16 Dec 2010 23:53:14 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: riverful.kim@samsung.com
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L/DVB: Add support for M5MOLS Mega Pixel camera
References: <4D01D96B.8040707@samsung.com>
In-Reply-To: <4D01D96B.8040707@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi HeungJun,

Please see my comments below.

On 12/10/2010 08:40 AM, Kim, HeungJun wrote:
> This patch adds support for M5MOLS Mega Pixel Fujitsu camera sensor.
>
> --
>
> Hello,
>
> This is an initial version of I2C/V4L2 subdev driver for M5MOLS camera
> sensor using MIPI interface from Fujitsu. This sensor supports various
> resolution at various fps on Monitoring(as we know preview),
> Preview(camcording), Capture(JPEG) mode. And, each mode supports
> different resolution range. Moreover, there are many image processing
> controls(flip, rotation, focus, zoom) and effects(even like a face
> recognitions). It has been tested with samsung/fimc and s5p-fimc driver
> on Aquila board. And this driver changed until now.
>
> This version supports just Monitoring mode at it's own many resolutions.
> But, there are many features in this sensor, and it's so hard to express
> all this features using a current CID or something else. so, I hope
> this initial version is merged soon in v4l/dvb, and then I wish the
> new needed CID is being added for this, and any other devices in addition.
>
> Any ideas are appreciated, Let me know.
>
> Thanks.
>
> Regards,
> HeungJun Kim
>
> Signed-off-by: Heungjun Kim<riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Part<kyungmin.park@samsung.com>
> ---
>   drivers/media/video/Kconfig  |    6 +
>   drivers/media/video/Makefile |    1 +
>   drivers/media/video/m5mols.c | 1410 ++++++++++++++++++++++++++++++++++++++++++
>   include/media/m5mols.h       |   31 +
>   4 files changed, 1448 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/m5mols.c
>   create mode 100644 include/media/m5mols.h
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 6830d28..f2e6080 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -712,6 +712,12 @@ config VIDEO_SR030PC30
>   	---help---
>   	  This driver supports SR030PC30 VGA camera from Siliconfile
>
> +config VIDEO_M5MOLS
> +	tristate "Fujitsu M5MOLS 8M Pixel sensor support"
> +	depends on I2C&&  VIDEO_V4L2
> +	---help---
> +	  This driver supports M5MOLS 8 MEGA Pixel camera from Fujitsu
> +
>   config VIDEO_VIA_CAMERA
>   	tristate "VIAFB camera controller support"
>   	depends on FB_VIA
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index af79d47..c76e44f 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -72,6 +72,7 @@ obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>   obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>   obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
>   obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
> +obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols.o
>
>   obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
>   obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
> diff --git a/drivers/media/video/m5mols.c b/drivers/media/video/m5mols.c
> new file mode 100644
> index 0000000..9f5c445
> --- /dev/null
> +++ b/drivers/media/video/m5mols.c
> @@ -0,0 +1,1410 @@
> +/*
> + * Driver for M5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2010 Samsung Electronics Co., Ltd
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include<linux/i2c.h>
> +#include<linux/delay.h>
> +#include<linux/slab.h>
> +#include<linux/regulator/consumer.h>
> +
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-subdev.h>
> +#include<media/m5mols.h>
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +
> +/* MACRO */
> +#define e_check_w(fn, cat, byte, val, bitwidth)		do {	\
> +	int ret;						\
> +	ret = (int)(fn);					\
> +	if ((ret)<  0) {					\
> +		dev_err(&client->dev, "fail i2c WRITE [%s] - "	\
> +				"category:0x%02x, "		\
> +				"bytes:0x%02x, "		\
> +				"value:0x%02x\n",		\
> +				(bitwidth),			\
> +				(cat), (byte), (u32)val);	\
> +		return ret;					\
> +	}							\
> +} while (0)
> +
> +#define e_check_r(fn, cat, byte, val, bitwidth)		do {	\
> +	int ret;						\
> +	ret = (int)(fn);					\
> +	if ((ret)<  0) {					\
> +		dev_err(&client->dev, "fail i2c READ [%s] - "	\
> +				"category:0x%02x, "		\
> +				"bytes:0x%02x, "		\
> +				"value:0x%02x\n",		\
> +				(bitwidth),			\
> +				(cat), (byte), (u32)(*val));	\
> +		return ret;					\
> +	}							\
> +} while (0)
> +
> +#define REG_W_8(cat, byte, value)					\
> +	e_check_w(m5mols_write_reg(sd, M5MOLS_8BIT, cat, byte, value),	\
> +			cat, byte, value, "8bit")
> +#define REG_R_8(cat, byte, value)					\
> +	e_check_r(m5mols_read_reg(sd, M5MOLS_8BIT, cat, byte, value),	\
> +			cat, byte, value, "8bit")
> +
> +#define e_check_mode(fn, mode)				do {	\
> +	int ret;						\
> +	ret = (int)(fn);					\
> +	if (ret<  0) {						\
> +		dev_err(&client->dev, "Failed to %s mode\n",	\
> +				(mode));			\
> +		return ret;					\
> +	}							\
> +} while (0)

These macros really do not look good. Moreover they all change
the control flow, i.e. return a value. From Documentation/CodingStyle:

"Things to avoid when using macros:

1) macros that affect control flow:

#define FOO(x)                                  \
         do {                                    \
                 if (blah(x) < 0)                \
                         return -EBUGGERED;      \
         } while(0)

is a _very_ bad idea.  It looks like a function call but exits the
"calling" function; don't break the internal parsers of those who will
read the code."

> +
> +#define mode_monitoring(sd)					\
> +	e_check_mode(m5mols_monitoring_mode(sd), "MONITORING")
> +#define mode_parameter(sd)					\
> +	e_check_mode(m5mols_parameter_mode(sd), "PARAMETER")
> +
> +#define v4l2msg(fmt, arg...)			do {	\
> +	v4l2_dbg(1, debug,&info->sd, fmt, ## arg);	\
> +} while (0)

v4l2_dbg depends on local variable named "info"

 From Documentation/CodingStyle:

2) macros that depend on having a local variable with a magic name:

#define FOO(val) bar(index, val)

might look like a good thing, but it's confusing as hell when one reads
the code and it's prone to breakage from seemingly innocent changes.

> +
> +/*
> + * Specification
> + *
> + * Sensor can be attached up to resolution of 4096*1664
> + * Supports the embedded JPEG encoder and object recognition control.
> + *
> + * QXGA format sensor with 1/4" optics
> + * Effective resolution: 2048(H)x1536(V)
> + * JPEG on the fly compression
> + * MJPEG supported
> + * 8-bit parallel video interface
> + * Output format:
> + *  8-Bit ITU-R.656/601 (4:2:2 YCbCr)
> + *  565RGB
> + *  CIS Raw Data
> + * input clock frequency of 13MHz-27MHz
> + * Variable frame rate Up to 7.5fps for QXGA @60MHz PCLK
> + * and up to 30fps for VGA
> + */
> +
> +#define MOD_NAME		"M5MOLS"
> +
> +#define DEFAULT_FPS		30
> +#define DEFAULT_WIDTH		1280
> +#define DEFAULT_HEIGHT		720
> +#define DEFAULT_PRESET		0x21
> +#define DEFAULT_DATABUS		M5MOLS_DATABUS_MIPI
> +#define DEFAULT_CODE		V4L2_MBUS_FMT_YUYV8_2X8
> +
> +#define M5MOLS_I2C_RETRY	3
> +#define M5MOLS_I2C_CHECK_RETRY	50
> +
> +/* chip version */
> +#define M5MOLS_VERSION		0x21
> +#define	M5MOLS_DATABUS_MIPI	2
> +
> +/* category register */
> +#define CAT_SYSTEM		0x00
> +#define CAT_PARAM		0x01
> +#define CAT_MON			0x02
> +#define CAT_AE			0x03
> +#define CAT_WB			0x06
> +#define CAT_CAP_PARAM		0x0B
> +#define CAT_CAP_CTRL		0x0C
> +#define CAT_FLASH		0x0F	/* related with F/W */
> +
> +/* category 00: System register bytes */
> +#define CAT0_PJ_CODE		0x01
> +#define CAT0_SYSMODE		0x0B
> +#define CAT0_INT_ROOTEN		0x12
> +
> +/* category 01: Parameter mode register bytes */
> +#define CAT1_DATABUS		0x00
> +#define CAT1_MONSIZE		0x01
> +#define CAT1_MONFPS		0x02
> +#define CAT1_EFFECT		0x0B
> +#define CAT1_DENOMINATOR	0x31
> +
> +/* category 02: Monitor register bytes */
> +#define CAT2_CFIXB		0x09
> +#define CAT2_CFIXR		0x0A
> +#define CAT2_COLOR_EFFECT	0x0B
> +#define CAT2_CHROMA_LVL		0x0F
> +#define CAT2_CHROMA_EN		0x10
> +
> +/* category 03: AE register bytes */
> +#define CAT3_AE_LOCK		0x00
> +
> +/* category 06: WB register bytes */
> +#define CAT6_AWB_MODE		0x02
> +#define CAT6_AWB_SPEED		0x04
> +
> +enum m5mols_data_length {
> +	M5MOLS_8BIT		= 1,
> +	M5MOLS_16BIT		= 2,
> +	M5MOLS_32BIT		= 4,
> +	M5MOLS_MAXBIT		= 4,
> +};
> +
> +/* register value definitions */
> +enum m5mols_mode {
> +	M5MOLS_SYSINIT		= 0x00,
> +	M5MOLS_PARMSET		= 0x01,
> +	M5MOLS_MONITOR		= 0x02,
> +	M5MOLS_UNKNOWN		= 0xff,
> +};
> +
> +enum m5mols_framepersecond_preset {
> +	M5MOLS_FPS_ERR		= 0x00,
> +	M5MOLS_FPS_AUTO		= 0x01,
> +	M5MOLS_FPS_30		= 0x02,
> +	M5MOLS_FPS_15		= 0x03,
> +	M5mOLS_FPS_12		= 0x04,
> +	M5MOLS_FPS_10		= 0x05,
> +	M5MOLS_FPS_24		= 0x07,
> +	M5MOLS_FPS_20		= 0x08,
> +	M5MOLS_FPS_21		= 0x09,
> +	M5MOLS_FPS_22		= 0x0a,
> +	M5MOLS_FPS_23		= 0x0b,
> +};
> +
> +enum m5mols_wb_mode {
> +	M5MOLS_AWB		= 0x01,
> +	M5MOLS_MWB		= 0x02,
> +};
> +
> +enum m5mols_res_type {
> +	M5MOLS_RES_MON,
> +	M5MOLS_RES_PREVIEW,
> +	M5MOLS_RES_THUMB,
> +	M5MOLS_RES_CAPTURE,
> +	M5MOLS_RES_UNKNOWN,
> +};
> +
> +u8 m5mols_chroma_level[] = {
> +	0x0,	/* default */
> +	0x1c, 0x3e, 0x5f, 0x80, 0xa1, 0xc2, 0xe4,
> +};
> +#define CHROMA_LEVEL_SIZE	ARRAY_SIZE(m5mols_chroma_level)

This constant is used only in one place. Maybe it's worth dropping it?

> +
> +u8 m5mols_ev_speed[] = {
> +	0x0,	/* default */
> +	0xfc, 0xfd, 0xfe, 0xff, 0x00, 0x01, 0x02, 0x03, 0x04,
> +};
> +#define EV_SPEED_SIZE		ARRAY_SIZE(m5mols_ev_speed)

Ditto.

> +
> +struct m5mols_resolution {
> +	unsigned char		value;
> +	enum m5mols_res_type	type;
> +	unsigned long		width;
> +	unsigned long		height;

Is unsigned long really needed here? How about u16?

> +};
> +
> +struct m5mols_format {
> +	struct v4l2_fmtdesc		fmt;
> +	enum v4l2_mbus_pixelcode	code;
> +	enum v4l2_colorspace		colorspace;
> +};
> +
> +struct m5mols_timeperframe {
> +	unsigned char		preset;
> +	int			fps;
> +};
> +
> +/* m5mols user control set */
> +struct m5mols_adjust {
> +	int			saturation;
> +	unsigned int		effect;		/* COLOR-FX */
> +};
> +
> +struct m5mols_wb {
> +	unsigned int		auto_wb;	/* auto or manual */
> +};
> +
> +struct m5mols_exposure {
> +	enum v4l2_exposure_auto_type	exp_mode;
> +	int				exp_bias;
> +};
> +
> +struct m5mols_userset {
> +	struct m5mols_adjust		adjust;
> +	struct m5mols_wb		wb;
> +	struct m5mols_exposure		exposure;
> +};
> +
> +struct m5mols_info {
> +	struct v4l2_subdev		sd;
> +	struct v4l2_mbus_framefmt	fmt, fmt_mon;
> +	struct v4l2_fract		tpf;		/* time per frame */
> +	struct i2c_client		*client;
> +	struct m5mols_platform_data	*pdata;
> +	struct m5mols_userset		uiset;
> +	unsigned char			fmt_preset;
> +	enum m5mols_mode		mode, mode_b;
> +	u8				version;
> +
> +	int				supply_size;
> +	struct regulator_bulk_data	*supply;
> +};
> +
> +/* The DEFAULT names of power supply are referenced with M5MO datasheet. */
> +static const char * const supply_names[] = {
> +	"1.2v_core",		/* CAM_S_ANA_2.8V */
> +	"1.8v_sensor",
> +	"1.8v_digital",
> +	"2.8v_digital",
> +	"2.8v_a_sensor",
> +	"1.2v_digital",
> +	"ext_signal1",		/* Optional: nRST, MCLK */
> +	"ext_i2c_vdd",		/* Optional like a I2C */
> +};
> +#define M5MOLS_NUM_SUPPLIES	 ARRAY_SIZE(supply_names)
> +
> +static const struct m5mols_format m5mols_formats[] = {
> +	{
> +		.fmt		= {
> +			.description	= "YUV422, YUYV",
> +			.pixelformat	= V4L2_PIX_FMT_YUYV,
> +		},
> +		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
> +		.colorspace	= V4L2_COLORSPACE_JPEG,
> +	},
> +};
> +
> +static const struct m5mols_resolution m5mols_size[] = {
> +	/* monitor size */
> +	{0x01, M5MOLS_RES_MON, 128, 96},	/* SUB-QCIF */
> +	{0x03, M5MOLS_RES_MON, 160, 120},	/* QQVGA */
> +	{0x05, M5MOLS_RES_MON, 176, 144},	/* QCIF */
> +	{0x06, M5MOLS_RES_MON, 176, 176},	/* 176*176 */
> +	{0x08, M5MOLS_RES_MON, 240, 320},	/* 1 QVGA */
> +	{0x09, M5MOLS_RES_MON, 320, 240},	/* QVGA */
> +	{0x0c, M5MOLS_RES_MON, 240, 400},	/* l WQVGA */
> +	{0x0d, M5MOLS_RES_MON, 400, 240},	/* WQVGA */
> +	{0x0e, M5MOLS_RES_MON, 352, 288},	/* CIF */
> +	{0x13, M5MOLS_RES_MON, 480, 360},	/* 480*360 */
> +	{0x15, M5MOLS_RES_MON, 640, 360},	/* qHD */
> +	{0x17, M5MOLS_RES_MON, 640, 480},	/* VGA */
> +	{0x18, M5MOLS_RES_MON, 720, 480},	/* 720x480 */
> +	{0x1a, M5MOLS_RES_MON, 800, 480},	/* WVGA */
> +	{0x1f, M5MOLS_RES_MON, 800, 600},	/* SVGA */
> +	{0x21, M5MOLS_RES_MON, 1280, 720},	/* HD */
> +	{0x25, M5MOLS_RES_MON, 1920, 1080},	/* 1080p */
> +	{0x29, M5MOLS_RES_MON, 3264, 2448},	/* 8M (2.63fps@3264*2448) */
> +	{0x30, M5MOLS_RES_MON, 320, 240},	/* 60fps for slow motion */
> +	{0x31, M5MOLS_RES_MON, 320, 240},	/* 120fps for slow motion */
> +	{0x39, M5MOLS_RES_MON, 800, 602},	/* AHS_MON debug */
> +};
> +
> +static const struct m5mols_timeperframe m5mols_fps[] = {
> +	{M5MOLS_FPS_30, 30},
> +	{M5MOLS_FPS_24, 24},
> +	{M5MOLS_FPS_20, 20},
> +	{M5MOLS_FPS_15, 15},
> +	{M5mOLS_FPS_12, 12},
> +	{M5MOLS_FPS_10, 10},
> +	{M5MOLS_FPS_21, 21},
> +	{M5MOLS_FPS_22, 22},
> +	{M5MOLS_FPS_23, 23},
> +	{M5MOLS_FPS_AUTO, 0},		/* AUTO fps */
> +};
> +
> +static const char * const m5mols_qm_ev_prst[] = {
> +	"-4", "-3", "-2", "-1", "0", "1", "2", "3", "4",
> +};
> +
> +static const char * const m5mols_qm_effect_prst[] = {
> +	[V4L2_COLORFX_SEPIA]	= "Sepia",
> +	[V4L2_COLORFX_NEGATIVE]	= "Negtive",
> +	[V4L2_COLORFX_EMBOSS]	= "Emboss",
> +};
> +
> +static struct v4l2_queryctrl m5mols_controls[] = {
> +	/* White balance */
> +	{
> +		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Auto White Balance",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	/* Exposure metering/control */
> +	{
> +		.id		= V4L2_CID_EXPOSURE_AUTO,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Exposure control preset",
> +		.minimum	= 0,
> +		.maximum	= 3,
> +		.step		= 1,
> +		.default_value	= V4L2_EXPOSURE_AUTO,
> +	},
> +	{
> +		.id		= V4L2_CID_EXPOSURE,
> +		.type		= V4L2_CTRL_TYPE_MENU,
> +		.name		= "Exposure bias",
> +		.minimum	= 0,
> +		.maximum	= ARRAY_SIZE(m5mols_qm_ev_prst) - 2,
> +		.step		= 1,
> +		.default_value	= 5,	/* 0EV */
> +	},
> +	/* Adjustment features */
> +	{
> +		.id		= V4L2_CID_COLORFX,
> +		.type		= V4L2_CTRL_TYPE_MENU,
> +		.name		= "Image effect",
> +		.minimum	= 0,
> +		.maximum	= ARRAY_SIZE(m5mols_qm_effect_prst) - 2,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	{
> +		.id		= V4L2_CID_SATURATION,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Saturation",
> +		.minimum	= 1,
> +		.maximum	= 7,
> +		.step		= 1,
> +		.default_value	= 4,
> +	}, {
> +	}
> +};
> +
> +const char **m5mols_ctrl_get_menu(u32 id)
> +{
> +	switch (id) {
> +	case V4L2_CID_COLORFX:
> +		return (const char **)m5mols_qm_effect_prst;
> +	case V4L2_CID_EXPOSURE:
> +		return (const char **)m5mols_qm_ev_prst;
> +	default:
> +		return v4l2_ctrl_get_menu(id);
> +	}
> +}
> +
> +static inline struct m5mols_info *to_m5mols(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct m5mols_info, sd);
> +}
> +
> +/*
> + * m5mols_read_reg
> + * [data size + 4], [0x02(w) or 0x01(r)], [category] + [x]
> + * if 8bit [x] == [val&  0xff]
> + * if 16bit [x] == [val>>  8],[val&  0xff]
> + * if 32bit == [val>>24],[(val>>16)&0xff],[(val>>8)&0xff],[val&0xff]
> + */
> +static int m5mols_read_reg(struct v4l2_subdev *sd, u8 size,
> +		u8 category, u8 byte, u32 *val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct device *cdev =&client->dev;
> +	struct i2c_msg msg[1];
> +	unsigned char buf[5];
> +	unsigned char rd[M5MOLS_MAXBIT + 1];
> +	int ret, retry = 0;
> +
> +	if (!client->adapter)
> +		return -ENODEV;
> +
> +	if ((size != M5MOLS_8BIT)
> +		&&  (size != M5MOLS_16BIT)
> +		&&  (size != M5MOLS_32BIT)) {
> +		dev_err(cdev, "Wrong data size\n");
> +		return -EINVAL;
> +	}
> +
> +again:
> +	msg->addr = client->addr;
> +	msg->flags =  0;
> +	msg->len = size + 4;
> +	msg->buf = buf;
> +
> +	/* high byte goes first */
> +	buf[0] = size + 4;
> +	buf[1] = 0x01;	/* read */
> +	buf[2] = category;
> +	buf[3] = byte;
> +	buf[4] = size;
> +
> +	ret = i2c_transfer(client->adapter, msg, 1);
> +	if (ret<  0) {
> +		if (retry<= M5MOLS_I2C_RETRY) {
> +			dev_dbg(cdev, "retry ... %d\n", retry);
> +			retry++;
> +			mdelay(20);
> +			goto again;
> +		}
> +
> +	} else {
> +		msg->flags = I2C_M_RD;
> +		msg->len = size + 1;
> +		msg->buf = rd;
> +		ret = i2c_transfer(client->adapter, msg, 1);
> +
> +		/* MSB first */
> +		if (size == M5MOLS_8BIT)
> +			*val = rd[1];
> +		else if (size == M5MOLS_16BIT)
> +			*val = rd[2] + (rd[1]<<  8);
> +		else
> +			*val = rd[4] + (rd[3]<<  8) +
> +				(rd[2]<<  16) + (rd[1]<<  24);
> +		return 0;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * m5mols_write_reg
> + * [data size + 4], [0x02(w) or 0x01(r)], [category] + [x]
> + * if 8bit [x] == [val&  0xff]
> + * if 16bit [x] == [val>>  8],[val&  0xff]
> + * if 32bit == [val>>24],[(val>>16)&0xff],[(val>>8)&0xff],[val&0xff]
> + */
> +static int m5mols_write_reg(struct v4l2_subdev *sd,
> +		u8 size, u8 category, u8 byte, u32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct device *cdev =&client->dev;
> +	struct i2c_msg msg[1];
> +	unsigned char wbuf[M5MOLS_MAXBIT + 4];
> +	int ret, retry = 0;
> +
> +	if (!client->adapter)
> +		return -ENODEV;
> +
> +	if ((size != M5MOLS_8BIT)
> +		&&  (size != M5MOLS_16BIT)
> +		&&  (size != M5MOLS_32BIT)) {
> +		dev_err(cdev, "Wrong data size\n");
> +		return -EINVAL;
> +	}
> +
> +again:
> +	msg->addr = client->addr;
> +	msg->flags = 0;
> +	msg->len = size + 4;
> +	msg->buf = wbuf;
> +
> +	/* MSB first */
> +	wbuf[0] = size + 4;
> +	wbuf[1] = 0x02;		/* write */
> +	wbuf[2] = category;
> +	wbuf[3] = byte;
> +
> +	/* last byte size depends on data size */
> +	if (size == M5MOLS_8BIT)
> +		wbuf[4] = (u8)(val&  0xff);
> +	else if (size == M5MOLS_16BIT) {
> +		wbuf[4] = (u8)(val>>  8);
> +		wbuf[5] = (u8)(val&  0xff);
> +	} else {
> +		wbuf[4] = (u8)(val>>  24);
> +		wbuf[5] = (u8)((val>>  16)&  0xff);
> +		wbuf[6] = (u8)((val>>  8)&  0xff);
> +		wbuf[7] = (u8)(val&  0xff);
> +	}
> +
> +	ret = i2c_transfer(client->adapter, msg, 1);
> +	if (ret<  0) {
> +		if (retry<= M5MOLS_I2C_RETRY) {
> +			dev_dbg(cdev, "retry ... %d\n", retry);
> +			retry++;
> +			mdelay(20);
> +			goto again;
> +		}
> +		return ret;
> +	}
> +	mdelay(20);
> +
> +	return 0;
> +}
> +
> +static int m5mols_check_busy(struct v4l2_subdev *sd,
> +		u8 category, u8 byte, u32 value)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u32 busy, i;
> +
> +	for (i = 0; i<  M5MOLS_I2C_CHECK_RETRY; i++) {
> +		REG_R_8(category, byte,&busy);
> +		if (busy == value)	/* bingo */
> +			return 0;
> +		mdelay(1);
> +	}
> +	return -EBUSY;
> +}
> +
> +static void m5mols_info_report(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct device *cdev =&client->dev;
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	switch (info->mode) {
> +	case M5MOLS_SYSINIT:
> +		dev_dbg(cdev, "SYSINIT mode\n");
> +		break;
> +	case M5MOLS_PARMSET:
> +		dev_dbg(cdev, "PARMSET mode\n");
> +		break;
> +	case M5MOLS_MONITOR:
> +		dev_dbg(cdev, "MONITOR mode\n");
> +		break;
> +	case M5MOLS_UNKNOWN:
> +		dev_dbg(cdev, "UNKNOWN mode\n");
> +		break;
> +	default:
> +		dev_dbg(cdev, "mode ERROR\n");
> +		break;
> +	}
> +}
> +
> +static int m5mols_parameter_mode(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int ret = -EBUSY;
> +
> +	if (info->mode == M5MOLS_PARMSET)
> +		return 0;
> +	else
> +		info->mode_b = info->mode;	/* mode_backup */
> +
> +	/* Goto Parameter setting mode */
> +	REG_W_8(CAT_SYSTEM, CAT0_SYSMODE, M5MOLS_PARMSET);
> +	ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_SYSMODE, M5MOLS_PARMSET);
> +	if (ret<  0)
> +		return ret;
> +
> +	info->mode = M5MOLS_PARMSET;
> +	m5mols_info_report(sd);
> +
> +	return ret;
> +}
> +
> +static int m5mols_monitoring_mode(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int ret = -EBUSY;
> +
> +	if (info->mode == M5MOLS_MONITOR)
> +		return 0;
> +	else
> +		info->mode_b = info->mode;	/* mode_backup */
> +
> +	/* Goto monitoring mode */
> +	REG_W_8(CAT_SYSTEM, CAT0_SYSMODE, M5MOLS_MONITOR);
> +	ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_SYSMODE, M5MOLS_MONITOR);
> +	if (ret<  0)
> +		return ret;
> +
> +	/* restore monitor format */
> +	memcpy(&info->fmt_mon,&info->fmt, sizeof(struct v4l2_mbus_framefmt));
> +
> +	info->mode = M5MOLS_MONITOR;
> +	m5mols_info_report(sd);
> +
> +	return ret;
> +}
> +
> +static int m5mols_check_version(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	REG_R_8(CAT_SYSTEM, CAT0_PJ_CODE, (u32 *)&info->version);
> +	if (info->version != M5MOLS_VERSION)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +/*
> + * m5mols_resolution_preset
> + * finds out index of requested resolution with i
> + * or returns -einval in case of not supported pixelformat
> + * m5msion] is representing supported resolutions
> + */
> +static int m5mols_resolution_preset(struct v4l2_subdev *sd,
> +		u32 width, u32 height,
> +		enum m5mols_res_type type)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int i;
> +
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_size); i++) {
> +		if ((m5mols_size[i].type == type)&&
> +			(m5mols_size[i].width == width)&&
> +			(m5mols_size[i].height == height))
> +			break;
> +	}
> +
> +	if (i>= ARRAY_SIZE(m5mols_size)) {
> +		v4l2msg("no matching resolution\n");
> +		return -EINVAL;
> +	}
> +
> +	return m5mols_size[i].value;
> +}
> +
> +/*
> + * m5mols_fps_preset
> + * handles v4l2_streamparm.parm.capture.tpf(v4l2_fract)
> + * It returns the closest fps if it has no matching fps
> + * numerator/denominator (30fps = 1/30)
> + * driver considers zero numerator as auto fps
> + */
> +static int m5mols_fps_preset(struct v4l2_subdev *sd,
> +		struct v4l2_captureparm *parm)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct v4l2_fract *fps =&parm->timeperframe;
> +	int numerator = fps->numerator;
> +	int denominator = fps->denominator;
> +	int i;
> +
> +	if (!denominator) {
> +		v4l2msg("Don't give zero for denominator of fps.");
> +		v4l2msg("Going auto fps mode\n");
> +		return M5MOLS_FPS_AUTO;
> +	}
> +
> +	if (!numerator) {
> +		v4l2msg("Going auto fps mode\n");
> +		return M5MOLS_FPS_AUTO;
> +	}
> +
> +	if ((numerator * denominator)<  0)
> +		return -EINVAL;
> +
> +	if (numerator != 1)
> +		denominator = denominator / numerator;
> +
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_fps); i++)
> +		if (m5mols_fps[i].fps == denominator)
> +			goto out;
> +
> +	/* If no matching one, get the closest one (excluding Auto FPS) */
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_fps) - 2; i++)
> +		if (abs(m5mols_fps[i].fps - denominator)
> +			<  abs(m5mols_fps[i+1].fps - denominator))
> +			break;
> +out:
> +	v4l2msg("try numerator[%d], and picking [%d]fps.\n",
> +			numerator,
> +			m5mols_fps[i].fps);
> +
> +	return m5mols_fps[i].preset;
> +}
> +
> +/*
> + * m5mols_effect_preset
> + *
> + * CbCr effect
> + *  read : CAT_PARAM, CAT1_EFFECT =>  if !0x00 goto param mode and set 0x00
> + *  mode : monitor mode
> + *  write: CAT_MON, CAT2_COLOR_EFFECT 0x01(on)
> + *  write: CAT_MON, CAT2_CFIXB(Cb), CAT2_CFIXR(Cr)
> + *
> + * Gamma effect
> + *  read : CAT_MON, CAT2_COLOR_EFFECT =>  if !0x00 then set 0x00
> + *  mode : parameter mode
> + *  write: CAT_PARAM, CAT1_EFFECT, index
> + *  mode : monitor mode
> + */
> +static int m5mols_effect_preset(struct v4l2_subdev *sd, signed int value)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	u32 chroma = 0, gamma = 0;
> +
> +	if (!m5mols_qm_effect_prst[value])
> +		return -EINVAL;
> +
> +	if (value == 0) {
> +		REG_W_8(CAT_MON, CAT2_COLOR_EFFECT, 0x00);
> +		REG_W_8(CAT_PARAM, CAT1_EFFECT, 0x00);
> +
> +		v4l2msg("Failed to change effect mode\n");
> +		mode_monitoring(sd);
> +		return -EINVAL;
> +	}
> +
> +	REG_R_8(CAT_PARAM, CAT1_EFFECT,&gamma);
> +	REG_R_8(CAT_MON, CAT2_COLOR_EFFECT,&chroma);
> +
> +	switch (value) {
> +	case V4L2_COLORFX_SEPIA:	/* Sepia */
> +		if (gamma != 0x00) {
> +			mode_parameter(sd);
> +			REG_W_8(CAT_MON, CAT2_COLOR_EFFECT, 0x00);
> +			mode_monitoring(sd);
> +		}
> +		REG_W_8(CAT_MON, CAT2_COLOR_EFFECT, 0x01);
> +		REG_W_8(CAT_MON, CAT2_CFIXB, 0xD8);
> +		REG_W_8(CAT_MON, CAT2_CFIXR, 0x18);
> +		break;
> +
> +	case V4L2_COLORFX_NEGATIVE:	/* Negative (gamma) */
> +		if (chroma != 0x00)
> +			REG_W_8(CAT_MON, CAT2_COLOR_EFFECT, 0x00);
> +		mode_parameter(sd);
> +		REG_W_8(CAT_PARAM, CAT1_EFFECT, 0x01);
> +		break;
> +
> +	case V4L2_COLORFX_EMBOSS:	/* Emboss (gamma) */
> +		if (chroma != 0x00)
> +			REG_W_8(CAT_MON, CAT2_COLOR_EFFECT, 0x06);
> +		mode_parameter(sd);
> +		REG_W_8(CAT_PARAM, CAT1_EFFECT, 0x06);
> +		break;
> +	default:
> +		v4l2msg("Not supported COLORFX value yet\n");
> +		break;
> +	}
> +
> +	v4l2msg("Effect %s configured\n", m5mols_qm_effect_prst[value]);
> +
> +	return 0;
> +}
> +
> +static void m5mols_set_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct m5mols_userset *userset =&info->uiset;
> +
> +	switch (ctrl->id) {
> +
> +	/* White balance */
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		userset->wb.auto_wb = ctrl->value;
> +		break;
> +
> +	/* Exposure metering/control */
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		userset->exposure.exp_mode = ctrl->value;
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		userset->exposure.exp_bias = ctrl->value;
> +		break;
> +
> +	/* Adjustment features */
> +	case V4L2_CID_COLORFX:
> +		userset->adjust.effect = ctrl->value;
> +		break;
> +	case V4L2_CID_SATURATION:
> +		userset->adjust.saturation = ctrl->value;
> +		break;
> +
> +	default:
> +		v4l2msg("UNKNOWN CID [%d]\n", ctrl->id);
> +		break;
> +	}
> +}
> +
> +/*
> + * m5mols_set_default_ctrl - Reset CID values to default
> + */
> +static void m5mols_set_default_ctrl(struct v4l2_subdev *sd)
> +{
> +	struct v4l2_control ctrl;
> +	int i;
> +
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_controls); i++) {
> +		ctrl.id = m5mols_controls[i].id;
> +		ctrl.value = m5mols_controls[i].default_value;
> +		m5mols_set_ctrl(sd,&ctrl);
> +	}
> +}
> +
> +static int m5mols_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	switch (ctrl->id) {
> +
> +	/* White balance */
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		ctrl->value = info->uiset.wb.auto_wb;
> +		break;
> +
> +	/* Exposure metering/control */
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		ctrl->value = info->uiset.exposure.exp_mode;
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		ctrl->value = info->uiset.exposure.exp_bias;
> +		break;
> +
> +	/* Adjustment features */
> +	case V4L2_CID_SATURATION:
> +		ctrl->value = info->uiset.adjust.saturation;
> +		break;
> +	case V4L2_CID_COLORFX:
> +		ctrl->value = info->uiset.adjust.effect;
> +		break;
> +
> +	default:
> +		v4l2msg("UNKNOWN CID [%d]\n", ctrl->id);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int m5mols_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct m5mols_userset *userset =&info->uiset;
> +	int i, ret = 0;
> +
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_controls); i++)
> +		if (m5mols_controls[i].id == ctrl->id)
> +			break;
> +
> +	if (i == ARRAY_SIZE(m5mols_controls))
> +		return -EINVAL;
> +
> +	mode_parameter(sd);
> +
> +	switch (ctrl->id) {
> +
> +	/* White balance */
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		if (ctrl->value == 1)
> +			REG_W_8(CAT_WB, CAT6_AWB_MODE, M5MOLS_AWB);
> +		else if (ctrl->value == 0)
> +			REG_W_8(CAT_WB, CAT6_AWB_MODE, M5MOLS_MWB);
> +		else
> +			return -EINVAL;
> +		userset->wb.auto_wb = ctrl->value;
> +		break;
> +
> +	/* Exposure metering/control */
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		switch (ctrl->value) {
> +		case V4L2_EXPOSURE_AUTO:
> +			REG_W_8(CAT_AE, CAT3_AE_LOCK, 0x01);
> +			break;
> +		case V4L2_EXPOSURE_MANUAL:
> +			REG_W_8(CAT_AE, CAT3_AE_LOCK, 0x00);
> +			break;
> +		case V4L2_EXPOSURE_SHUTTER_PRIORITY:
> +		case V4L2_EXPOSURE_APERTURE_PRIORITY:
> +		default:
> +			v4l2msg("Not supported Exposure mode\n");
> +			return -EINVAL;
> +			break;
> +		};
> +		userset->exposure.exp_mode = ctrl->value;
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		if (ctrl->value<  1 || ctrl->value>  EV_SPEED_SIZE) {
> +			v4l2msg("EV bias out of boundary\n");
> +			return -EINVAL;
> +			break;
> +		}
> +		REG_W_8(CAT_WB, CAT6_AWB_SPEED, m5mols_ev_speed[ctrl->value]);
> +		userset->exposure.exp_bias = ctrl->value;
> +		break;
> +
> +	/* Adjustment features */
> +	case V4L2_CID_SATURATION:
> +		if (ctrl->value<  1 || ctrl->value>  CHROMA_LEVEL_SIZE) {
> +			v4l2msg("Saturation out of boundary\n");
> +			return -EINVAL;
> +			break;
> +		}
> +		REG_W_8(CAT_MON, CAT2_CHROMA_LVL,
> +				m5mols_chroma_level[ctrl->value]);
> +		REG_W_8(CAT_MON, CAT2_CHROMA_EN, 0x01);
> +		userset->adjust.saturation = ctrl->value;
> +		break;
> +	case V4L2_CID_COLORFX:
> +		ret = m5mols_effect_preset(sd, ctrl->value);
> +		userset->adjust.effect = ctrl->value;
> +		break;
> +
> +	default:
> +		v4l2msg("UNKNOWN CID[%d]\n", ctrl->id);
> +		break;
> +	}
> +
> +	mode_monitoring(sd);
> +
> +	return ret;
> +}
> +
> +static int m5mols_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> +{
> +	int i;
> +
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_controls); i++)
> +		if (m5mols_controls[i].id == qc->id) {
> +			memcpy(qc,&m5mols_controls[i],
> +					sizeof(struct v4l2_queryctrl));
> +			return 0;
> +		}
> +
> +	return -EINVAL;
> +}
> +
> +static int m5mols_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qm)
> +{
> +	struct v4l2_queryctrl qctrl;
> +
> +	qctrl.id = qm->id;
> +	m5mols_queryctrl(sd,&qctrl);
> +
> +	return v4l2_ctrl_query_menu(qm,&qctrl, m5mols_ctrl_get_menu(qm->id));
> +}
> +
> +static int m5mols_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
> +			      enum v4l2_mbus_pixelcode *code)
> +{
> +	if (!code || index>= ARRAY_SIZE(m5mols_formats))
> +		return -EINVAL;
> +
> +	*code = m5mols_formats[index].code;
> +
> +	return 0;
> +}
> +
> +static int m5mols_g_mbus_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_mbus_framefmt *gfmt)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct v4l2_mbus_framefmt *fmt =&info->fmt;
> +
> +	if (!gfmt)
> +		return -EINVAL;
> +
> +	memset(gfmt, 0, sizeof(struct v4l2_mbus_framefmt));

The memset is not needed since you are going to assign all fields
of the data structure below, or at least this is what you intended
to do.

> +
> +	fmt->width	= gfmt->width;
> +	fmt->height	= gfmt->height;
> +	fmt->code	= gfmt->code;
> +	fmt->colorspace	= gfmt->colorspace;
> +	fmt->field	= V4L2_FIELD_NONE;

Since g_mbus_fmt is supposed to return the data you should be assigning
info->fmt value to *gfmt, rather than setting info->fmt to zero.

> +
> +	return 0;
> +}
> +
> +static int m5mols_s_mbus_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_mbus_framefmt *sfmt)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct v4l2_mbus_framefmt *fmt =&info->pdata->fmt;
> +	int i, preset;
> +
> +	/* checking width,height for preset */
> +	preset = m5mols_resolution_preset(sd, fmt->width, fmt->height,
> +			M5MOLS_RES_MON);
> +	if (preset<  0)
> +		return preset;

So this driver supports only one resolution? What prevents us from
using all resolutions available in m5mols_size array?

> +
> +	/* checking code */
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_formats); i++)
> +		if (sfmt->code == m5mols_formats[i].code)
> +			break;
> +
> +	if (i == ARRAY_SIZE(m5mols_formats))
> +		return -EINVAL;
> +
> +	fmt->width	= sfmt->width;
> +	fmt->height	= sfmt->height;
> +	fmt->code	= sfmt->code;
> +	fmt->colorspace	= sfmt->colorspace;

I think you should also be adjusting the colorspace and "field"
if "sfmt" The sensor seem to support only V4L2_COLORSPACE_JPEG
so you might want to just do:

sfmt->colorspace = V4L2_COLORSPACE_JPEG;
sfmt->field 	 = V4L2_FIELD_NONE;

> +	fmt->field	= V4L2_FIELD_NONE;
> +
> +	mode_parameter(sd);
> +
> +	info->fmt_preset = (u8)preset;
> +	REG_W_8(CAT_PARAM, CAT1_MONSIZE, info->fmt_preset);
> +
> +	if (info->mode_b == M5MOLS_MONITOR)
> +		mode_monitoring(sd);
> +
> +	return 0;
> +}
> +
> +static int m5mols_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct v4l2_captureparm *cp =&parms->parm.capture;
> +
> +	if (!parms)
> +		return -EINVAL;
> +
> +	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	memset(cp, 0, sizeof(struct v4l2_captureparm));
> +
> +	cp->capability = V4L2_CAP_TIMEPERFRAME;
> +	cp->timeperframe.numerator = info->tpf.numerator;
> +	cp->timeperframe.denominator = info->tpf.denominator;
> +
> +	return 0;
> +}
> +
> +static int m5mols_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct v4l2_captureparm *cp =&parms->parm.capture;
> +	u32 tpf_denom = 0;
> +	int ret = -EINVAL;
> +
> +	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return ret;
> +
> +	cp->capability = V4L2_CAP_TIMEPERFRAME;
> +
> +	/* checking timeperframe */
> +	ret = m5mols_fps_preset(sd, cp);
> +	if (ret<  0)
> +		return ret;
> +
> +	mode_parameter(sd);
> +
> +	/* make it compatible with various fps */
> +	tpf_denom = cp->timeperframe.denominator&  0xff;
> +
> +	REG_W_8(CAT_PARAM, CAT1_DENOMINATOR, tpf_denom);
> +
> +	if (info->mode_b == M5MOLS_MONITOR)
> +		mode_monitoring(sd);
> +
> +	info->tpf = cp->timeperframe;
> +
> +	v4l2msg("%d from app and set %d to camera\n",
> +		cp->timeperframe.denominator, tpf_denom);
> +
> +	return 0;
> +}
> +
> +static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	if (enable) {
> +		if (info->mode != M5MOLS_MONITOR) {
> +			/* streamon @ mode Monitor */
> +			mode_monitoring(sd);
> +			info->mode = M5MOLS_MONITOR;
> +		}
> +	} else {
> +		if (info->mode != M5MOLS_PARMSET) {
> +			/* streamoff @ mode Monitor */
> +			mode_parameter(sd);
> +			info->mode = M5MOLS_PARMSET;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int m5mols_enum_framesizes(struct v4l2_subdev *sd,
> +		struct v4l2_frmsizeenum *fsize)
> +{
> +	int i;
> +
> +	/* checking pixelformat */
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_formats); i++)
> +		if (fsize->pixel_format ==
> +				m5mols_formats[i].fmt.pixelformat)
> +			break;
> +
> +	if (i == ARRAY_SIZE(m5mols_formats))
> +		return -EINVAL;
> +
> +	/* checking index */
> +	if (fsize->index>= ARRAY_SIZE(m5mols_size))
> +		return -EINVAL;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +	fsize->discrete.width = m5mols_size[fsize->index].width;
> +	fsize->discrete.height = m5mols_size[fsize->index].height;
> +
> +	return 0;
> +}
> +
> +static int m5mols_enum_frameintervals(struct v4l2_subdev *sd,
> +		struct v4l2_frmivalenum *fival)
> +{
> +	int i;
> +
> +	/* checking pixelformat */
> +	for (i = 0; i<  ARRAY_SIZE(m5mols_formats); i++)
> +		if (fival->pixel_format ==
> +				m5mols_formats[i].fmt.pixelformat)
> +			break;
> +
> +	/* checking index */
> +	if (i == ARRAY_SIZE(m5mols_formats))
> +		return -EINVAL;
> +
> +	fival->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +	fival->discrete.numerator = 1;
> +	fival->discrete.denominator = m5mols_fps[fival->index].fps;
> +
> +	return 0;
> +}
> +
> +/*
> + * m5mols_s_power
> + * enable power for sensor. The callback from platfoprm data is used
> + */
> +static int m5mols_s_power(struct v4l2_subdev *sd, int enable)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct device *cdev =&client->dev;
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct m5mols_platform_data *pdata = info->pdata;
> +	int ret = 0;
> +
> +	BUG_ON(!pdata);
> +
> +	if (enable) {
> +		if (pdata->set_clock)
> +			pdata->set_clock(cdev, enable);
> +		if (pdata->set_power)
> +			ret = pdata->set_power(1);
> +		return ret;
> +	} else {
> +		if (pdata->set_power)
> +			ret = pdata->set_power(0);
> +		if (pdata->set_clock)
> +			pdata->set_clock(cdev, enable);
> +	}
> +	return ret;
> +}
> +
> +/*
> + * m5mols_s_config
> + * pre-setting related with m5mo by device, on probing.
> + */
> +static int m5mols_s_config(struct v4l2_subdev *sd,
> +		int irq, void *platform_data)
> +{
> +	struct m5mols_platform_data *pdata =
> +		(struct m5mols_platform_data *)platform_data;
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	if (pdata->fmt.width&&  pdata->fmt.height) {
> +		info->fmt = pdata->fmt;
> +	} else {
> +		info->fmt.width = DEFAULT_WIDTH;
> +		info->fmt.height = DEFAULT_HEIGHT;
> +		info->fmt.code = DEFAULT_CODE;
> +	}
> +
> +	info->fmt_mon = info->fmt;
> +
> +	info->tpf.numerator = 1;
> +	info->tpf.denominator = DEFAULT_FPS;
> +
> +	info->mode = M5MOLS_UNKNOWN;
> +	info->mode_b = M5MOLS_UNKNOWN;
> +	info->pdata = pdata;
> +
> +	m5mols_set_default_ctrl(sd);
> +
> +	return 0;
> +}
> +
> +/*
> + * m5mols_init
> + * power on, boot ARM booting, and set m5mo chip default values,
> + * before streaming. Sequence is below:
> + *  1. ARM booting
> + *  2. get&  check chip version.
> + *  3. set format, fps, dababus(MIPI)
> + */
> +static int m5mols_init(struct v4l2_subdev *sd, u32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct device *cdev =&client->dev;
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int ret = -EINVAL;
> +
> +	/* 1. ARM booting
> +	 * It must be sure boot-up time at least upper 500ms in document. */
> +	REG_W_8(CAT_FLASH, CAT0_INT_ROOTEN, 0x01);
> +	msleep(500);
> +	dev_dbg(cdev, "Success ARM Booting\n");
> +
> +	/* 2. get&  check chip version */
> +	ret = m5mols_check_version(sd);
> +	if (ret)
> +		return ret;
> +
> +	/* 3. set format preset, fps, dababus(MIPI) */
> +	REG_W_8(CAT_PARAM, CAT1_DATABUS, DEFAULT_DATABUS);
> +	REG_W_8(CAT_PARAM, CAT1_MONFPS, DEFAULT_FPS);
> +	if (!info->fmt_preset)
> +		REG_W_8(CAT_PARAM, CAT1_MONSIZE, DEFAULT_PRESET);
> +	else
> +		REG_W_8(CAT_PARAM, CAT1_MONSIZE, info->fmt_preset);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops m5mols_core_ops = {
> +	.init			= m5mols_init,

"init" should not be used in new drivers. You may want to call
m5mols_init from within m5mols_s_power function.

> +	.s_config		= m5mols_s_config,
> +	.s_power		= m5mols_s_power,
> +	.g_ctrl			= m5mols_g_ctrl,
> +	.s_ctrl			= m5mols_s_ctrl,
> +	.queryctrl		= m5mols_queryctrl,
> +	.querymenu		= m5mols_querymenu,
> +};
> +
> +static const struct v4l2_subdev_video_ops m5mols_video_ops = {
> +	.enum_framesizes	= m5mols_enum_framesizes,
> +	.enum_frameintervals	= m5mols_enum_frameintervals,
> +	.enum_mbus_fmt		= m5mols_enum_mbus_fmt,
> +	.g_mbus_fmt		= m5mols_g_mbus_fmt,
> +	.s_mbus_fmt		= m5mols_s_mbus_fmt,
> +	.g_parm			= m5mols_g_parm,
> +	.s_parm			= m5mols_s_parm,
> +	.s_stream		= m5mols_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops m5mols_ops = {
> +	.core =&m5mols_core_ops,
> +	.video =&m5mols_video_ops,
> +};
> +
> +static int m5mols_get_regulator(struct m5mols_info *info)
> +{
> +	struct m5mols_platform_data *pdata = info->pdata;
> +	struct device *cdev =&info->client->dev;
> +	const char **names;
> +	int i = 0;
> +
> +	/* check supply names&  supply size  */
> +	if (!pdata->supply_names || (pdata->supply_size<= 0)) {
> +		info->supply_size = M5MOLS_NUM_SUPPLIES;
> +		names = (const char **)supply_names;
> +	} else {
> +		info->supply_size = pdata->supply_size;
> +		names = pdata->supply_names;
> +	}
> +
> +	/* alloc supply data */
> +	info->supply = kzalloc(sizeof(struct regulator_bulk_data) *
> +			info->supply_size, GFP_KERNEL);
> +	if (!info->supply)
> +		return -ENOMEM;
> +
> +	/* copy regulator names */
> +	for (i = 0; i<  info->supply_size; i++)
> +		info->supply[i].supply = names[i];
> +
> +	/* get regulators */
> +	return regulator_bulk_get(cdev, info->supply_size, info->supply);
> +}

Hmm, I do not see any regulator_bulk_enable/regulator_bulk_disable in 
this patch. So you are really not using the regulators, they are only 
requested by the driver in probe() and freed on module unload?
How is it supposed to work?

> +
> +static int m5mols_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct m5mols_platform_data *pdata = client->dev.platform_data;
> +	struct device *cdev =&client->dev;
> +	struct m5mols_info *info;
> +	struct v4l2_subdev *sd;
> +	int ret = 0;
> +
> +	if (pdata == NULL) {
> +		dev_err(cdev, "No platform data\n");
> +		return -EIO;
> +	}
> +
> +	info = kzalloc(sizeof(struct m5mols_info), GFP_KERNEL);
> +	if (info == NULL) {
> +		dev_err(cdev, "Failed to allocate info\n");
> +		return -ENOMEM;
> +	}
> +	info->pdata = client->dev.platform_data;
> +	info->client = client;
> +
> +	ret = m5mols_get_regulator(info);
> +	if (!ret) {
> +		sd =&info->sd;
> +		strcpy(sd->name, MOD_NAME);
> +		v4l2_i2c_subdev_init(sd, client,&m5mols_ops);
> +		dev_info(cdev, "m5mols has been probed\n");
> +	} else {
> +		dev_err(cdev, "Failed to get regulators, %d\n", ret);
> +	}
> +
> +	return ret;
> +}
> +
> +static int m5mols_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	regulator_bulk_free(info->supply_size, info->supply);
> +	kfree(info->supply);
> +	kfree(info);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id m5mols_id[] = {
> +	{ MOD_NAME, 0 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, m5mols_id);
> +
> +static struct i2c_driver m5mols_i2c_driver = {
> +	.driver = {
> +		.name	= MOD_NAME,
> +	},
> +	.probe		= m5mols_probe,
> +	.remove		= m5mols_remove,
> +	.id_table	= m5mols_id,
> +};
> +
> +static int __init m5mols_mod_init(void)
> +{
> +	return i2c_add_driver(&m5mols_i2c_driver);
> +}
> +
> +static void __exit m5mols_mod_exit(void)
> +{
> +	i2c_del_driver(&m5mols_i2c_driver);
> +}
> +
> +module_init(m5mols_mod_init);
> +module_exit(m5mols_mod_exit);
> +
> +MODULE_AUTHOR("HeungJun Kim<riverful.kim@samsung.com>");
> +MODULE_AUTHOR("Dongsoo Kim<dongsoo45.kim@samsung.com>");
> +MODULE_DESCRIPTION("Fujitsu M5MOLS 8M Pixel camera sensor with ISP driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/m5mols.h b/include/media/m5mols.h
> new file mode 100644
> index 0000000..af789db
> --- /dev/null
> +++ b/include/media/m5mols.h
> @@ -0,0 +1,31 @@
> +/*
> + * Driver for M5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2010 Samsung Electronics Co., Ltd
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __M5MOLS_H
> +#define __M5MOLS_H

Identifiers beginning with two underscores are reserved for compiler's
internal use. It would be better to use e.g. M5MOLS_H_ instead.

> +
> +#include<media/v4l2-mediabus.h>
> +#include<linux/regulator/consumer.h>
> +
> +struct m5mols_platform_data {
> +	struct v4l2_mbus_framefmt	fmt;		/* default fmt */

You have an array of supported resolutions defined within the driver,
what is the purpose of passing default format in "platform data"?
It should be possible to negotiate formats with try/g/s_mbus_fmt
subdev ops. Hard coding default format doesn't look like a good idea
to me. Is his due to some kind of limitation?

> +	const char			**supply_names;	/* regulator name */
> +	int				supply_size;	/* name string size */
> +
> +	int (*set_power)(int on);
> +	int (*set_clock)(struct device *dev, int on);
> +};
> +
> +#endif	/* __M5MOLS_H */

Regards,
Sylwester
