Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35877 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab1EYNyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:54:47 -0400
Date: Wed, 25 May 2011 16:54:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v9] Add support for M-5MOLS 8 Mega Pixel camera ISP
Message-ID: <20110525135435.GA3547@valkosipuli.localdomain>
References: <1305507806-10692-1-git-send-email-riverful.kim@samsung.com>
 <1305871017-22924-1-git-send-email-riverful.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305871017-22924-1-git-send-email-riverful.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi HeungJun,

Thanks for the patch!

I'm happy to see that Samsung is interested in getting such a driver to
mainline. :-) I suppose that theoretically nothing would prevent plugging
such a sensor to the OMAP 3 ISP, for example. It's just that the sensor
already does image processing and the ISP might not be that useful because
of this. But the interfaces would match, both in software and in hardware.

This is a subdev driver and uses the control framework. Good. I have
comments on the code below. 

On Fri, May 20, 2011 at 02:56:57PM +0900, HeungJun, Kim wrote:
> Add I2C/V4L2 subdev driver for M-5MOLS integrated image signal processor
> with 8 Mega Pixel sensor.
> 
> Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> 
> Hello everyone,
> 
> This is the ninth version of the subdev for M-5MOLS 8M Pixel camera sensor.
> If you see previous version, you can find at:
> http://www.spinics.net/lists/linux-media/msg32387.html
> 
> The major changes including points commented in the IRC is as follows.
> 1. remove a lot of inline I2C functions for being easy to read
>   : rename m5mols_read/write() to m5mols_read/write()
>   : add I2C_XXX() macro to combinine the arguments of the I2C raw functions
> 2. use atomic macro for checking capture interrupt
> 3. add comments for DocBook
> 
> Thanks to read, and any comments are welcome!
> 
> --
> Thanks and Regards,
> Heungjun Kim
> Samsung Electronics DMC R&D Center
> ---
>  drivers/media/video/Kconfig                  |    2 +
>  drivers/media/video/Makefile                 |    1 +
>  drivers/media/video/m5mols/Kconfig           |    5 +
>  drivers/media/video/m5mols/Makefile          |    3 +
>  drivers/media/video/m5mols/m5mols.h          |  296 ++++++++
>  drivers/media/video/m5mols/m5mols_capture.c  |  191 +++++
>  drivers/media/video/m5mols/m5mols_controls.c |  299 ++++++++
>  drivers/media/video/m5mols/m5mols_core.c     | 1004 ++++++++++++++++++++++++++
>  drivers/media/video/m5mols/m5mols_reg.h      |  399 ++++++++++
>  include/media/m5mols.h                       |   35 +
>  10 files changed, 2235 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/m5mols/Kconfig
>  create mode 100644 drivers/media/video/m5mols/Makefile
>  create mode 100644 drivers/media/video/m5mols/m5mols.h
>  create mode 100644 drivers/media/video/m5mols/m5mols_capture.c
>  create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
>  create mode 100644 drivers/media/video/m5mols/m5mols_core.c
>  create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
>  create mode 100644 include/media/m5mols.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index d61414e..242c80c 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -753,6 +753,8 @@ config VIDEO_NOON010PC30
>  	---help---
>  	  This driver supports NOON010PC30 CIF camera from Siliconfile
>  
> +source "drivers/media/video/m5mols/Kconfig"
> +
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
>  	select OMAP_IOMMU
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index a10e4c3..d5d6de1 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -69,6 +69,7 @@ obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
>  obj-$(CONFIG_VIDEO_MT9V032) += mt9v032.o
>  obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
>  obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
> +obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
>  
>  obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
> diff --git a/drivers/media/video/m5mols/Kconfig b/drivers/media/video/m5mols/Kconfig
> new file mode 100644
> index 0000000..302dc3d
> --- /dev/null
> +++ b/drivers/media/video/m5mols/Kconfig
> @@ -0,0 +1,5 @@
> +config VIDEO_M5MOLS
> +	tristate "Fujitsu M-5MOLS 8MP sensor support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	---help---
> +	  This driver supports Fujitsu M-5MOLS camera sensor with ISP
> diff --git a/drivers/media/video/m5mols/Makefile b/drivers/media/video/m5mols/Makefile
> new file mode 100644
> index 0000000..0a44e02
> --- /dev/null
> +++ b/drivers/media/video/m5mols/Makefile
> @@ -0,0 +1,3 @@
> +m5mols-objs	:= m5mols_core.o m5mols_controls.o m5mols_capture.o
> +
> +obj-$(CONFIG_VIDEO_M5MOLS)		+= m5mols.o
> diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
> new file mode 100644
> index 0000000..10b55c8
> --- /dev/null
> +++ b/drivers/media/video/m5mols/m5mols.h
> @@ -0,0 +1,296 @@
> +/*
> + * Header for M-5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef M5MOLS_H
> +#define M5MOLS_H
> +
> +#include <media/v4l2-subdev.h>
> +#include "m5mols_reg.h"
> +
> +extern int m5mols_debug;
> +
> +#define to_m5mols(__sd)	container_of(__sd, struct m5mols_info, sd)
> +
> +#define to_sd(__ctrl) \
> +	(&container_of(__ctrl->handler, struct m5mols_info, handle)->sd)
> +
> +enum m5mols_restype {
> +	M5MOLS_RESTYPE_MONITOR,
> +	M5MOLS_RESTYPE_CAPTURE,
> +	M5MOLS_RESTYPE_MAX,
> +};
> +
> +/**
> + * struct m5mols_resolution - structure for the resolution
> + * @type: resolution type according to the pixel code
> + * @width: width of the resolution
> + * @height: height of the resolution
> + * @reg: resolution preset register value
> + */
> +struct m5mols_resolution {
> +	u8 reg;
> +	enum m5mols_restype type;
> +	u16 width;
> +	u16 height;
> +};
> +
> +/**
> + * struct m5mols_exif - structure for the EXIF information of M-5MOLS
> + * @exposure_time: exposure time register value
> + * @shutter_speed: speed of the shutter register value
> + * @aperture: aperture register value
> + * @exposure_bias: it calls also EV bias
> + * @iso_speed: ISO register value
> + * @flash: status register value of the flash
> + * @sdr: status register value of the Subject Distance Range
> + * @qval: not written exact meaning in document
> + */
> +struct m5mols_exif {
> +	u32 exposure_time;
> +	u32 shutter_speed;
> +	u32 aperture;
> +	u32 brightness;
> +	u32 exposure_bias;
> +	u16 iso_speed;
> +	u16 flash;
> +	u16 sdr;
> +	u16 qval;
> +};
> +
> +/**
> + * struct m5mols_capture - Structure for the capture capability
> + * @exif: EXIF information
> + * @main: size in bytes of the main image
> + * @thumb: size in bytes of the thumb image, if it was accompanied
> + * @total: total size in bytes of the produced image
> + */
> +struct m5mols_capture {
> +	struct m5mols_exif exif;
> +	u32 main;
> +	u32 thumb;
> +	u32 total;
> +};
> +
> +/**
> + * struct m5mols_scenemode - structure for the scenemode capability
> + * @metering: metering light register value
> + * @ev_bias: EV bias register value
> + * @wb_mode: mode which means the WhiteBalance is Auto or Manual
> + * @wb_preset: whitebalance preset register value in the Manual mode
> + * @chroma_en: register value whether the Chroma capability is enabled or not
> + * @chroma_lvl: chroma's level register value
> + * @edge_en: register value Whether the Edge capability is enabled or not
> + * @edge_lvl: edge's level register value
> + * @af_range: Auto Focus's range
> + * @fd_mode: Face Detection mode
> + * @mcc: Multi-axis Color Conversion which means emotion color
> + * @light: status of the Light
> + * @flash: status of the Flash
> + * @tone: Tone color which means Contrast
> + * @iso: ISO register value
> + * @capt_mode: Mode of the Image Stabilization while the camera capturing
> + * @wdr: Wide Dynamic Range register value
> + *
> + * The each value according to each scenemode is recommended in the documents.
> + */
> +struct m5mols_scenemode {
> +	u32 metering;
> +	u32 ev_bias;
> +	u32 wb_mode;
> +	u32 wb_preset;
> +	u32 chroma_en;
> +	u32 chroma_lvl;
> +	u32 edge_en;
> +	u32 edge_lvl;
> +	u32 af_range;
> +	u32 fd_mode;
> +	u32 mcc;
> +	u32 light;
> +	u32 flash;
> +	u32 tone;
> +	u32 iso;
> +	u32 capt_mode;
> +	u32 wdr;
> +};
> +
> +/**
> + * struct m5mols_version - firmware version information
> + * @customer:	customer information
> + * @project:	version of project information according to customer
> + * @fw:		firmware revision
> + * @hw:		hardware revision
> + * @param:	version of the parameter
> + * @awb:	Auto WhiteBalance algorithm version
> + * @str:	information about manufacturer and packaging vendor
> + * @af:		Auto Focus version
> + *
> + * The register offset starts the customer version at 0x0, and it ends
> + * the awb version at 0x09. The customer, project information occupies 1 bytes
> + * each. And also the fw, hw, param, awb each requires 2 bytes. The str is
> + * unique string associated with firmware's version. It includes information
> + * about manufacturer and the vendor of the sensor's packaging. The least
> + * significant 2 bytes of the string indicate packaging manufacturer.
> + */
> +#define VERSION_STRING_SIZE	22
> +struct m5mols_version {
> +	u8	customer;
> +	u8	project;
> +	u16	fw;
> +	u16	hw;
> +	u16	param;
> +	u16	awb;
> +	u8	str[VERSION_STRING_SIZE];
> +	u8	af;
> +};
> +#define VERSION_SIZE sizeof(struct m5mols_version)

You're using VERSION_SIZE in two places in one function. Is that worth
making it a macro? :-)

I think you should add attribute ((packed)) to the definition as well.

> +/**
> + * struct m5mols_info - M-5MOLS driver data structure
> + * @pdata: platform data
> + * @sd: v4l-subdev instance
> + * @pad: media pad
> + * @ffmt: current fmt according to resolution type
> + * @res_type: current resolution type
> + * @code: current code
> + * @irq_waitq: waitqueue for the capture
> + * @work_irq: workqueue for the IRQ
> + * @flags: state variable for the interrupt handler
> + * @handle: control handler
> + * @autoexposure: Auto Exposure control
> + * @exposure: Exposure control
> + * @autowb: Auto White Balance control
> + * @colorfx: Color effect control
> + * @saturation:	Saturation control
> + * @zoom: Zoom control
> + * @ver: information of the version
> + * @cap: the capture mode attributes
> + * @power: current sensor's power status
> + * @ctrl_sync: true means all controls of the sensor are initialized
> + * @int_capture: true means the capture interrupt is issued once
> + * @lock_ae: true means the Auto Exposure is locked
> + * @lock_awb: true means the Aut WhiteBalance is locked
> + * @resolution:	register value for current resolution
> + * @interrupt: register value for current interrupt status
> + * @mode: register value for current operation mode
> + * @mode_save: register value for current operation mode for saving
> + * @set_power: optional power callback to the board code
> + */
> +struct m5mols_info {
> +	const struct m5mols_platform_data *pdata;
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +	struct v4l2_mbus_framefmt ffmt[M5MOLS_RESTYPE_MAX];
> +	int res_type;
> +	enum v4l2_mbus_pixelcode code;
> +	wait_queue_head_t irq_waitq;
> +	struct work_struct work_irq;
> +	unsigned long flags;

You want to keep flags in the stack, not in a context independent location.
This will move to functions which actually use it.

> +
> +	struct v4l2_ctrl_handler handle;
> +	/* Autoexposure/exposure control cluster */
> +	struct {
> +		struct v4l2_ctrl *autoexposure;
> +		struct v4l2_ctrl *exposure;
> +	};

Would it be different without the anonymous struct?

> +	struct v4l2_ctrl *autowb;
> +	struct v4l2_ctrl *colorfx;
> +	struct v4l2_ctrl *saturation;
> +	struct v4l2_ctrl *zoom;
> +
> +	struct m5mols_version ver;
> +	struct m5mols_capture cap;
> +	bool power;
> +	bool ctrl_sync;
> +	bool lock_ae;
> +	bool lock_awb;
> +	u8 resolution;
> +	u32 interrupt;

What would be the reason to store interrupt status information here, and
again, not in a variable which is allocated from the stack?

> +	u32 mode;
> +	u32 mode_save;
> +	int (*set_power)(struct device *dev, int on);
> +};
> +
> +#define ST_CAPT_IRQ 0
> +
> +#define is_powered(__info) (__info->power)
> +#define is_ctrl_synced(__info) (__info->ctrl_sync)
> +#define is_available_af(__info)	(__info->ver.af)
> +#define is_code(__code, __type) (__code == m5mols_default_ffmt[__type].code)
> +#define is_manufacturer(__info, __manufacturer)	\
> +				(__info->ver.str[0] == __manufacturer[0] && \
> +				 __info->ver.str[1] == __manufacturer[1])
> +/*
> + * I2C operation of the M-5MOLS
> + *
> + * The I2C read operation of the M-5MOLS requires 2 messages. The first
> + * message sends the information about the command, command category, and total
> + * message size. The second message is used to retrieve the data specifed in
> + * the first message
> + *
> + *   1st message                                2nd message
> + *   +-------+---+----------+-----+-------+     +------+------+------+------+
> + *   | size1 | R | category | cmd | size2 |     | d[0] | d[1] | d[2] | d[3] |
> + *   +-------+---+----------+-----+-------+     +------+------+------+------+
> + *   - size1: message data size(5 in this case)
> + *   - size2: desired buffer size of the 2nd message
> + *   - d[0..3]: according to size2
> + *
> + * The I2C write operation needs just one message. The message includes
> + * category, command, total size, and desired data.
> + *
> + *   1st message
> + *   +-------+---+----------+-----+------+------+------+------+
> + *   | size1 | W | category | cmd | d[0] | d[1] | d[2] | d[3] |
> + *   +-------+---+----------+-----+------+------+------+------+
> + *   - d[0..3]: according to size1
> + */
> +int m5mols_read(struct v4l2_subdev *sd, u32 reg_comb, u32 *val);
> +int m5mols_write(struct v4l2_subdev *sd, u32 reg_comb, u32 val);
> +int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 value);
> +
> +/*
> + * Mode operation of the M-5MOLS
> + *
> + * Changing the mode of the M-5MOLS is needed right executing order.
> + * There are three modes(PARAMETER, MONITOR, CAPTURE) which can be changed
> + * by user. There are various categories associated with each mode.
> + *
> + * +============================================================+
> + * | mode	| category					|
> + * +============================================================+
> + * | FLASH	| FLASH(only after Stand-by or Power-on)	|
> + * | SYSTEM	| SYSTEM(only after sensor arm-booting)		|
> + * | PARAMETER	| PARAMETER					|
> + * | MONITOR	| MONITOR(preview), Auto Focus, Face Detection	|
> + * | CAPTURE	| Single CAPTURE, Preview(recording)		|
> + * +============================================================+
> + *
> + * The available executing order between each modes are as follows:
> + *   PARAMETER <---> MONITOR <---> CAPTURE
> + */
> +int m5mols_mode(struct m5mols_info *info, u32 mode);
> +
> +int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg);
> +int m5mols_sync_controls(struct m5mols_info *info);
> +int m5mols_start_capture(struct m5mols_info *info);
> +int m5mols_do_scenemode(struct m5mols_info *info, u32 mode);
> +int m5mols_lock_3a(struct m5mols_info *info, bool lock);
> +int m5mols_set_ctrl(struct v4l2_ctrl *ctrl);
> +
> +/* The firmware function */
> +int m5mols_update_fw(struct v4l2_subdev *sd,
> +		     int (*set_power)(struct m5mols_info *, bool));
> +
> +#endif	/* M5MOLS_H */
> diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
> new file mode 100644
> index 0000000..d71a390
> --- /dev/null
> +++ b/drivers/media/video/m5mols/m5mols_capture.c
> @@ -0,0 +1,191 @@
> +/*
> + * The Capture code for Fujitsu M-5MOLS ISP
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/version.h>
> +#include <linux/gpio.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/videodev2.h>
> +#include <linux/version.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/m5mols.h>
> +
> +#include "m5mols.h"
> +#include "m5mols_reg.h"
> +
> +static int m5mols_capture_error_handler(struct m5mols_info *info,
> +					int timeout)
> +{
> +	int ret;
> +
> +	/* Disable all interrupts and clear relevant interrupt staus bits */
> +	ret = m5mols_write(&info->sd, SYSTEM_INT_ENABLE,
> +			   info->interrupt & ~(REG_INT_CAPTURE));
> +	if (ret)
> +		return ret;
> +
> +	if (timeout == 0)
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}

Timeout should be handled outside this function. It does nothing else based
on it except return an error code.

> +/**
> + * m5mols_read_rational - I2C read of a rational number
> + *
> + * Read numerator and denominator from registers @addr_num and @addr_den
> + * respectively and return the division result in @val.
> + */
> +static int m5mols_read_rational(struct v4l2_subdev *sd, u32 addr_num,
> +				u32 addr_den, u32 *val)

Are there cases where addr_num + 4 != addr_den? If so, you could just drop
addr_den.

> +{
> +	u32 num, den;
> +
> +	int ret = m5mols_read(sd, addr_num, &num);
> +	if (!ret)
> +		ret = m5mols_read(sd, addr_den, &den);
> +	if (ret)
> +		return ret;
> +	*val = den == 0 ? 0 : num / den;
> +	return ret;
> +}
> +
> +/**
> + * m5mols_capture_info - Gather captured image information
> + *
> + * For now it gathers only EXIF information and file size.
> + */
> +static int m5mols_capture_info(struct m5mols_info *info)
> +{
> +	struct m5mols_exif *exif = &info->cap.exif;
> +	struct v4l2_subdev *sd = &info->sd;
> +	int ret;
> +
> +	ret = m5mols_read_rational(sd, EXIF_INFO_EXPTIME_NU,
> +				   EXIF_INFO_EXPTIME_DE, &exif->exposure_time);
> +	if (ret)
> +		return ret;
> +	ret = m5mols_read_rational(sd, EXIF_INFO_TV_NU, EXIF_INFO_TV_DE,
> +				   &exif->shutter_speed);
> +	if (ret)
> +		return ret;
> +	ret = m5mols_read_rational(sd, EXIF_INFO_AV_NU, EXIF_INFO_AV_DE,
> +				   &exif->aperture);
> +	if (ret)
> +		return ret;
> +	ret = m5mols_read_rational(sd, EXIF_INFO_BV_NU, EXIF_INFO_BV_DE,
> +				   &exif->brightness);
> +	if (ret)
> +		return ret;
> +	ret = m5mols_read_rational(sd, EXIF_INFO_EBV_NU, EXIF_INFO_EBV_DE,
> +				   &exif->exposure_bias);
> +	if (ret)
> +		return ret;

You could define register-memory address pairs in a structure and read the
registers in a loop to the memory. This would be cleaner than few tonnes of
function calls.

> +	ret = m5mols_read(sd, EXIF_INFO_ISO, (u32 *)&exif->iso_speed);
> +	if (!ret)
> +		ret = m5mols_read(sd, EXIF_INFO_FLASH, (u32 *)&exif->flash);
> +	if (!ret)
> +		ret = m5mols_read(sd, EXIF_INFO_SDR, (u32 *)&exif->sdr);
> +	if (!ret)
> +		ret = m5mols_read(sd, EXIF_INFO_QVAL, (u32 *)&exif->qval);
> +	if (ret)
> +		return ret;

Please don't do typecasting for pointers like this. You end up overwriting
other parts of memory. The final call will write to memory which isn't part
of the structure.

> +	if (!ret)
> +		ret = m5mols_read(sd, CAPC_IMAGE_SIZE, &info->cap.main);
> +	if (!ret)
> +		ret = m5mols_read(sd, CAPC_THUMB_SIZE, &info->cap.thumb);
> +	if (!ret)
> +		info->cap.total = info->cap.main + info->cap.thumb;
> +
> +	return ret;
> +}
> +
> +int m5mols_start_capture(struct m5mols_info *info)
> +{
> +	struct v4l2_subdev *sd = &info->sd;
> +	u32 resolution = info->resolution;
> +	int timeout;
> +	int ret;
> +
> +	/*
> +	 * Preparing capture. Setting control & interrupt before entering
> +	 * capture mode
> +	 *
> +	 * 1) change to MONITOR mode for operating control & interrupt
> +	 * 2) set controls (considering v4l2_control value & lock 3A)
> +	 * 3) set interrupt
> +	 * 4) change to CAPTURE mode
> +	 */
> +	ret = m5mols_mode(info, REG_MONITOR);
> +	if (!ret)
> +		ret = m5mols_sync_controls(info);
> +	if (!ret)
> +		ret = m5mols_lock_3a(info, true);
> +	if (!ret)
> +		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
> +	if (!ret)
> +		ret = m5mols_mode(info, REG_CAPTURE);
> +	if (!ret) {
> +		/* Wait for capture interrupt, after changing capture mode */
> +		timeout = wait_event_interruptible_timeout(info->irq_waitq,
> +					   test_bit(ST_CAPT_IRQ, &info->flags),
> +					   msecs_to_jiffies(2000));
> +		if (test_and_clear_bit(ST_CAPT_IRQ, &info->flags))
> +			ret = m5mols_capture_error_handler(info, timeout);
> +	}
> +	if (!ret)
> +		ret = m5mols_lock_3a(info, false);
> +	if (ret)
> +		return ret;
> +	/*
> +	 * Starting capture. Setting capture frame count and resolution and
> +	 * the format(available format: JPEG, Bayer RAW, YUV).
> +	 *
> +	 * 1) select single or multi(enable to 25), format, size
> +	 * 2) set interrupt
> +	 * 3) start capture(for main image, now)
> +	 * 4) get information
> +	 * 5) notify file size to v4l2 device(e.g, to s5p-fimc v4l2 device)
> +	 */
> +	ret = m5mols_write(sd, CAPC_SEL_FRAME, 1);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPP_YUVOUT_MAIN, REG_JPEG);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPP_MAIN_IMAGE_SIZE, resolution);
> +	if (!ret)
> +		ret = m5mols_enable_interrupt(sd, REG_INT_CAPTURE);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPC_START, REG_CAP_START_MAIN);
> +	if (!ret) {
> +		/* Wait for the capture completion interrupt */
> +		timeout = wait_event_interruptible_timeout(info->irq_waitq,
> +					   test_bit(ST_CAPT_IRQ, &info->flags),
> +					   msecs_to_jiffies(2000));
> +		if (test_and_clear_bit(ST_CAPT_IRQ, &info->flags)) {
> +			ret = m5mols_capture_info(info);
> +			if (!ret)
> +				v4l2_subdev_notify(sd, 0, &info->cap.total);
> +		}
> +	}
> +
> +	return m5mols_capture_error_handler(info, timeout);
> +}
> diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
> new file mode 100644
> index 0000000..817c16f
> --- /dev/null
> +++ b/drivers/media/video/m5mols/m5mols_controls.c
> @@ -0,0 +1,299 @@
> +/*
> + * Controls for M-5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + * Author: HeungJun Kim, riverful.kim@samsung.com

<e-mail@address>

> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
> +
> +#include "m5mols.h"
> +#include "m5mols_reg.h"
> +
> +static struct m5mols_scenemode m5mols_default_scenemode[] = {
> +	[REG_SCENE_NORMAL] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_NORMAL, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		5, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_PORTRAIT] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 4,
> +		REG_AF_NORMAL, BIT_FD_EN | BIT_FD_DRAW_FACE_FRAME,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_LANDSCAPE] = {
> +		REG_AE_ALL, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 4, REG_EDGE_ON, 6,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_SPORTS] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_PARTY_INDOOR] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 4, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_200, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_BEACH_SNOW] = {
> +		REG_AE_CENTER, REG_AE_INDEX_10_POS, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 4, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_50, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_SUNSET] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_PRESET,
> +		REG_AWB_DAYLIGHT,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_DAWN_DUSK] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_PRESET,
> +		REG_AWB_FLUORESCENT_1,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_FALL] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 5, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_NIGHT] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_AGAINST_LIGHT] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_FIRE] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_50, REG_CAP_NONE, REG_WDR_OFF,
> +	},
> +	[REG_SCENE_TEXT] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 7,
> +		REG_AF_MACRO, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_ANTI_SHAKE, REG_WDR_ON,
> +	},
> +	[REG_SCENE_CANDLE] = {
> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> +		REG_AF_NORMAL, REG_FD_OFF,
> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> +	},

As it seems this functionality is dynamically configurable, and much of that
looks like something user space might want to choose independently,
shouldn't the underlying low level controls be exposed to user space as
such?

There definitely are different approaches to this; providing higher level
interface is restricting but on the other hand it may be better depending on
an application.

Some of these parameters would already have a V4L2 control for them.

> +};
> +
> +/**
> + * m5mols_do_scenemode() - Change current scenemode
> + * @mode:	Desired mode of the scenemode
> + *
> + * WARNING: The execution order is important. Do not change the order.
> + */
> +int m5mols_do_scenemode(struct m5mols_info *info, u32 mode)
> +{
> +	struct v4l2_subdev *sd = &info->sd;
> +	struct m5mols_scenemode scenemode = m5mols_default_scenemode[mode];
> +	int ret;
> +
> +	if (mode > REG_SCENE_CANDLE)
> +		return -EINVAL;
> +
> +	ret = m5mols_lock_3a(info, false);
> +	if (!ret)
> +		ret = m5mols_write(sd, AE_EV_PRESET_MONITOR, mode);
> +	if (!ret)
> +		ret = m5mols_write(sd, AE_EV_PRESET_CAPTURE, mode);
> +	if (!ret)
> +		ret = m5mols_write(sd, AE_MODE, scenemode.metering);
> +	if (!ret)
> +		ret = m5mols_write(sd, AE_INDEX, scenemode.ev_bias);
> +	if (!ret)
> +		ret = m5mols_write(sd, AWB_MODE, scenemode.wb_mode);
> +	if (!ret)
> +		ret = m5mols_write(sd, AWB_MANUAL, scenemode.wb_preset);
> +	if (!ret)
> +		ret = m5mols_write(sd, MON_CHROMA_EN, scenemode.chroma_en);
> +	if (!ret)
> +		ret = m5mols_write(sd, MON_CHROMA_LVL, scenemode.chroma_lvl);
> +	if (!ret)
> +		ret = m5mols_write(sd, MON_EDGE_EN, scenemode.edge_en);
> +	if (!ret)
> +		ret = m5mols_write(sd, MON_EDGE_LVL, scenemode.edge_lvl);
> +	if (!ret && is_available_af(info))
> +		ret = m5mols_write(sd, AF_MODE, scenemode.af_range);
> +	if (!ret && is_available_af(info))
> +		ret = m5mols_write(sd, FD_CTL, scenemode.fd_mode);
> +	if (!ret)
> +		ret = m5mols_write(sd, MON_TONE_CTL, scenemode.tone);
> +	if (!ret)
> +		ret = m5mols_write(sd, AE_ISO, scenemode.iso);
> +	if (!ret)
> +		ret = m5mols_mode(info, REG_CAPTURE);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPP_WDR_EN, scenemode.wdr);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPP_MCC_MODE, scenemode.mcc);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPP_LIGHT_CTRL, scenemode.light);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPP_FLASH_CTRL, scenemode.flash);
> +	if (!ret)
> +		ret = m5mols_write(sd, CAPC_MODE, scenemode.capt_mode);
> +	if (!ret)
> +		ret = m5mols_mode(info, REG_MONITOR);
> +
> +	return ret;
> +}
> +
> +static int m5mols_lock_ae(struct m5mols_info *info, bool lock)
> +{
> +	int ret = 0;
> +
> +	if (info->lock_ae != lock)
> +		ret = m5mols_write(&info->sd, AE_LOCK,
> +				lock ? REG_AE_LOCK : REG_AE_UNLOCK);
> +	if (!ret)
> +		info->lock_ae = lock;
> +
> +	return ret;
> +}
> +
> +static int m5mols_lock_awb(struct m5mols_info *info, bool lock)
> +{
> +	int ret = 0;
> +
> +	if (info->lock_awb != lock)
> +		ret = m5mols_write(&info->sd, AWB_LOCK,
> +				lock ? REG_AWB_LOCK : REG_AWB_UNLOCK);
> +	if (!ret)
> +		info->lock_awb = lock;
> +
> +	return ret;
> +}
> +
> +/* m5mols_lock_3a() - Lock 3A(Auto Exposure, Auto Whitebalance, Auto Focus) */
> +int m5mols_lock_3a(struct m5mols_info *info, bool lock)
> +{
> +	int ret;
> +
> +	ret = m5mols_lock_ae(info, lock);
> +	if (!ret)
> +		ret = m5mols_lock_awb(info, lock);
> +	/* Don't need to handle unlocking AF */
> +	if (!ret && is_available_af(info) && lock)
> +		ret = m5mols_write(&info->sd, AF_EXECUTE, REG_AF_STOP);
> +
> +	return ret;
> +}
> +
> +/* m5mols_set_ctrl() - The main s_ctrl function called by m5mols_set_ctrl() */
> +int m5mols_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct v4l2_subdev *sd = to_sd(ctrl);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_ZOOM_ABSOLUTE:
> +		return m5mols_write(sd, MON_ZOOM, ctrl->val);
> +
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		ret = m5mols_lock_ae(info,
> +			ctrl->val == V4L2_EXPOSURE_AUTO ? false : true);
> +		if (!ret && ctrl->val == V4L2_EXPOSURE_AUTO)
> +			ret = m5mols_write(sd, AE_MODE, REG_AE_ALL);
> +		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL) {
> +			int val = info->exposure->val;
> +			ret = m5mols_write(sd, AE_MODE, REG_AE_OFF);
> +			if (!ret)
> +				ret = m5mols_write(sd, AE_MAN_GAIN_MON, val);
> +			if (!ret)
> +				ret = m5mols_write(sd, AE_MAN_GAIN_CAP, val);
> +		}
> +		return ret;
> +
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		ret = m5mols_lock_awb(info, ctrl->val ? false : true);
> +		if (!ret)
> +			ret = m5mols_write(sd, AWB_MODE, ctrl->val ?
> +				REG_AWB_AUTO : REG_AWB_PRESET);
> +		return ret;
> +
> +	case V4L2_CID_SATURATION:
> +		ret = m5mols_write(sd, MON_CHROMA_LVL, ctrl->val);
> +		if (!ret)
> +			ret = m5mols_write(sd, MON_CHROMA_EN, REG_CHROMA_ON);
> +		return ret;
> +
> +	case V4L2_CID_COLORFX:
> +		/*
> +		 * This control uses two kinds of registers: normal & color.
> +		 * The normal effect belongs to category 1, while the color
> +		 * one belongs to category 2.
> +		 *
> +		 * The normal effect uses one register: CAT1_EFFECT.
> +		 * The color effect uses three registers:
> +		 * CAT2_COLOR_EFFECT, CAT2_CFIXR, CAT2_CFIXB.
> +		 */
> +		ret = m5mols_write(sd, PARM_EFFECT,
> +			ctrl->val == V4L2_COLORFX_NEGATIVE ? REG_EFFECT_NEGA :
> +			ctrl->val == V4L2_COLORFX_EMBOSS ? REG_EFFECT_EMBOSS :
> +			REG_EFFECT_OFF);
> +		if (!ret)
> +			ret = m5mols_write(sd, MON_EFFECT,
> +				ctrl->val == V4L2_COLORFX_SEPIA ?
> +				REG_COLOR_EFFECT_ON : REG_COLOR_EFFECT_OFF);
> +		if (!ret)
> +			ret = m5mols_write(sd, MON_CFIXR,
> +				ctrl->val == V4L2_COLORFX_SEPIA ?
> +				REG_CFIXR_SEPIA : 0);
> +		if (!ret)
> +			ret = m5mols_write(sd, MON_CFIXB,
> +				ctrl->val == V4L2_COLORFX_SEPIA ?
> +				REG_CFIXB_SEPIA : 0);
> +		return ret;
> +	}
> +
> +	return -EINVAL;
> +}
> diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
> new file mode 100644
> index 0000000..76eac26
> --- /dev/null
> +++ b/drivers/media/video/m5mols/m5mols_core.c
> @@ -0,0 +1,1004 @@
> +/*
> + * Driver for M-5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/version.h>
> +#include <linux/gpio.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/m5mols.h>
> +
> +#include "m5mols.h"
> +#include "m5mols_reg.h"
> +
> +int m5mols_debug;
> +module_param(m5mols_debug, int, 0644);
> +
> +#define MODULE_NAME		"M5MOLS"
> +#define M5MOLS_I2C_CHECK_RETRY	500
> +
> +/* The regulator consumer names for external voltage regulators */
> +static struct regulator_bulk_data supplies[] = {
> +	{
> +		.supply = "core",	/* ARM core power, 1.2V */
> +	}, {
> +		.supply	= "dig_18",	/* digital power 1, 1.8V */
> +	}, {
> +		.supply	= "d_sensor",	/* sensor power 1, 1.8V */
> +	}, {
> +		.supply	= "dig_28",	/* digital power 2, 2.8V */
> +	}, {
> +		.supply	= "a_sensor",	/* analog power */
> +	}, {
> +		.supply	= "dig_12",	/* digital power 3, 1.2V */
> +	},
> +};

This looks like something that belongs to board code, or perhaps in the near
future, to the device tree. The power supplies that are required by a device
is highly board dependent.

> +static struct v4l2_mbus_framefmt m5mols_default_ffmt[M5MOLS_RESTYPE_MAX] = {
> +	[M5MOLS_RESTYPE_MONITOR] = {
> +		.width		= 1920,
> +		.height		= 1080,
> +		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
> +		.field		= V4L2_FIELD_NONE,
> +		.colorspace	= V4L2_COLORSPACE_JPEG,
> +	},
> +	[M5MOLS_RESTYPE_CAPTURE] = {
> +		.width		= 1920,
> +		.height		= 1080,
> +		.code		= V4L2_MBUS_FMT_JPEG_1X8,
> +		.field		= V4L2_FIELD_NONE,
> +		.colorspace	= V4L2_COLORSPACE_JPEG,
> +	},
> +};
> +#define SIZE_DEFAULT_FFMT	ARRAY_SIZE(m5mols_default_ffmt)
> +
> +static const struct m5mols_resolution m5mols_reg_res[] = {
> +	{ 0x01, M5MOLS_RESTYPE_MONITOR, 128, 96 },	/* SUB-QCIF */
> +	{ 0x03, M5MOLS_RESTYPE_MONITOR, 160, 120 },	/* QQVGA */
> +	{ 0x05, M5MOLS_RESTYPE_MONITOR, 176, 144 },	/* QCIF */
> +	{ 0x06, M5MOLS_RESTYPE_MONITOR, 176, 176 },
> +	{ 0x08, M5MOLS_RESTYPE_MONITOR, 240, 320 },	/* QVGA */
> +	{ 0x09, M5MOLS_RESTYPE_MONITOR, 320, 240 },	/* QVGA */
> +	{ 0x0c, M5MOLS_RESTYPE_MONITOR, 240, 400 },	/* WQVGA */
> +	{ 0x0d, M5MOLS_RESTYPE_MONITOR, 400, 240 },	/* WQVGA */
> +	{ 0x0e, M5MOLS_RESTYPE_MONITOR, 352, 288 },	/* CIF */
> +	{ 0x13, M5MOLS_RESTYPE_MONITOR, 480, 360 },
> +	{ 0x15, M5MOLS_RESTYPE_MONITOR, 640, 360 },	/* qHD */
> +	{ 0x17, M5MOLS_RESTYPE_MONITOR, 640, 480 },	/* VGA */
> +	{ 0x18, M5MOLS_RESTYPE_MONITOR, 720, 480 },
> +	{ 0x1a, M5MOLS_RESTYPE_MONITOR, 800, 480 },	/* WVGA */
> +	{ 0x1f, M5MOLS_RESTYPE_MONITOR, 800, 600 },	/* SVGA */
> +	{ 0x21, M5MOLS_RESTYPE_MONITOR, 1280, 720 },	/* HD */
> +	{ 0x25, M5MOLS_RESTYPE_MONITOR, 1920, 1080 },	/* 1080p */
> +	{ 0x29, M5MOLS_RESTYPE_MONITOR, 3264, 2448 },	/* 2.63fps 8M */
> +	{ 0x39, M5MOLS_RESTYPE_MONITOR, 800, 602 },	/* AHS_MON debug */
> +
> +	{ 0x02, M5MOLS_RESTYPE_CAPTURE, 320, 240 },	/* QVGA */
> +	{ 0x04, M5MOLS_RESTYPE_CAPTURE, 400, 240 },	/* WQVGA */
> +	{ 0x07, M5MOLS_RESTYPE_CAPTURE, 480, 360 },
> +	{ 0x08, M5MOLS_RESTYPE_CAPTURE, 640, 360 },	/* qHD */
> +	{ 0x09, M5MOLS_RESTYPE_CAPTURE, 640, 480 },	/* VGA */
> +	{ 0x0a, M5MOLS_RESTYPE_CAPTURE, 800, 480 },	/* WVGA */
> +	{ 0x10, M5MOLS_RESTYPE_CAPTURE, 1280, 720 },	/* HD */
> +	{ 0x14, M5MOLS_RESTYPE_CAPTURE, 1280, 960 },	/* 1M */
> +	{ 0x17, M5MOLS_RESTYPE_CAPTURE, 1600, 1200 },	/* 2M */
> +	{ 0x19, M5MOLS_RESTYPE_CAPTURE, 1920, 1080 },	/* Full-HD */
> +	{ 0x1a, M5MOLS_RESTYPE_CAPTURE, 2048, 1152 },	/* 3Mega */
> +	{ 0x1b, M5MOLS_RESTYPE_CAPTURE, 2048, 1536 },
> +	{ 0x1c, M5MOLS_RESTYPE_CAPTURE, 2560, 1440 },	/* 4Mega */
> +	{ 0x1d, M5MOLS_RESTYPE_CAPTURE, 2560, 1536 },
> +	{ 0x1f, M5MOLS_RESTYPE_CAPTURE, 2560, 1920 },	/* 5Mega */
> +	{ 0x21, M5MOLS_RESTYPE_CAPTURE, 3264, 1836 },	/* 6Mega */
> +	{ 0x22, M5MOLS_RESTYPE_CAPTURE, 3264, 1960 },
> +	{ 0x25, M5MOLS_RESTYPE_CAPTURE, 3264, 2448 },	/* 8Mega */
> +};
> +
> +/**
> + * m5mols_swap_byte - an byte array to integer conversion function
> + * @size: size in bytes of I2C packet defined in the M-5MOLS datasheet
> + *
> + * Convert I2C data byte array with performing any required byte
> + * reordering to assure proper values for each data type, regardless
> + * of the architecture endianness.
> + */
> +static u32 m5mols_swap_byte(u8 *data, u8 length)
> +{
> +	if (length == 1)
> +		return *data;
> +	else if (length == 2)
> +		return be16_to_cpu(*((u16 *)data));
> +	else
> +		return be32_to_cpu(*((u32 *)data));
> +}
> +
> +/**
> + * m5mols_read -  I2C read function
> + * @reg: combination of size, category and command for the I2C packet
> + * @val: read value
> + */
> +int m5mols_read(struct v4l2_subdev *sd, u32 reg, u32 *val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u8 rbuf[M5MOLS_I2C_MAX_SIZE + 1];
> +	u8 size = I2C_SIZE(reg);
> +	u8 category = I2C_CATEGORY(reg);
> +	u8 cmd = I2C_COMMAND(reg);
> +	struct i2c_msg msg[2];
> +	u8 wbuf[5];
> +	int ret;
> +
> +	if (!client->adapter)
> +		return -ENODEV;
> +
> +	if (size != 1 && size != 2 && size != 4) {
> +		v4l2_err(sd, "Wrong data size\n");
> +		return -EINVAL;
> +	}
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = 0;
> +	msg[0].len = 5;
> +	msg[0].buf = wbuf;
> +	wbuf[0] = 5;
> +	wbuf[1] = M5MOLS_BYTE_READ;
> +	wbuf[2] = category;
> +	wbuf[3] = cmd;
> +	wbuf[4] = size;
> +
> +	msg[1].addr = client->addr;
> +	msg[1].flags = I2C_M_RD;
> +	msg[1].len = size + 1;
> +	msg[1].buf = rbuf;
> +
> +	/* minimum stabilization time */
> +	usleep_range(200, 200);
> +
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +	if (ret < 0) {
> +		v4l2_err(sd, "read failed: size:%d cat:%02x cmd:%02x. %d\n",
> +			 size, category, cmd, ret);
> +		return ret;
> +	}
> +
> +	*val = m5mols_swap_byte(&rbuf[1], size);
> +
> +	return 0;
> +}
> +
> +/**
> + * m5mols_write - I2C command write function
> + * @reg: combination of size, category and command for the I2C packet
> + * @val: value to write
> + */
> +int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u8 wbuf[M5MOLS_I2C_MAX_SIZE + 4];
> +	u8 category = I2C_CATEGORY(reg);
> +	u8 cmd = I2C_COMMAND(reg);
> +	u8 size	= I2C_SIZE(reg);
> +	u32 *buf = (u32 *)&wbuf[4];
> +	struct i2c_msg msg[1];
> +	int ret;
> +
> +	if (!client->adapter)
> +		return -ENODEV;
> +
> +	if (size != 1 && size != 2 && size != 4) {

You could define sizes for the types, e.g.

#define I2C_SIZE_U8	1

> +		v4l2_err(sd, "Wrong data size\n");
> +		return -EINVAL;
> +	}
> +
> +	msg->addr = client->addr;
> +	msg->flags = 0;
> +	msg->len = (u16)size + 4;
> +	msg->buf = wbuf;
> +	wbuf[0] = size + 4;
> +	wbuf[1] = M5MOLS_BYTE_WRITE;
> +	wbuf[2] = category;
> +	wbuf[3] = cmd;
> +
> +	*buf = m5mols_swap_byte((u8 *)&val, size);
> +
> +	usleep_range(200, 200);

Why to sleep always? Does the sensor require a delay between each I2C
access?

> +	ret = i2c_transfer(client->adapter, msg, 1);
> +	if (ret < 0) {
> +		v4l2_err(sd, "write failed: size:%d cat:%02x cmd:%02x. %d\n",
> +			size, category, cmd, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 mask)
> +{
> +	u32 busy, i;
> +	int ret;
> +
> +	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
> +		ret = m5mols_read(sd, I2C_REG(category, cmd, 1), &busy);
> +		if (ret < 0)
> +			return ret;
> +		if ((busy & mask) == mask)
> +			return 0;
> +	}
> +	return -EBUSY;
> +}
> +
> +/**
> + * m5mols_enable_interrupt - Clear interrupt pending bits and unmask interrupts
> + *
> + * Before writing desired interrupt value the INT_FACTOR register should
> + * be read to clear pending interrupts.
> + */
> +int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	u32 mask = is_available_af(info) ? REG_INT_AF : 0;
> +	u32 dummy;
> +	int ret;
> +
> +	ret = m5mols_read(sd, SYSTEM_INT_FACTOR, &dummy);
> +	if (!ret)
> +		ret = m5mols_write(sd, SYSTEM_INT_ENABLE, reg & ~mask);
> +	return ret;
> +}
> +
> +/**
> + * m5mols_reg_mode - Write the mode and check busy status
> + *
> + * It always accompanies a little delay changing the M-5MOLS mode, so it is
> + * needed checking current busy status to guarantee right mode.
> + */
> +static int m5mols_reg_mode(struct v4l2_subdev *sd, u32 mode)
> +{
> +	int ret = m5mols_write(sd, SYSTEM_SYSMODE, mode);
> +
> +	return ret ? ret : m5mols_busy(sd, CAT_SYSTEM, CAT0_SYSMODE, mode);
> +}
> +
> +/**
> + * m5mols_mode - manage the M-5MOLS's mode
> + * @mode: the required operation mode
> + *
> + * The commands of M-5MOLS are grouped into specific modes. Each functionality
> + * can be guaranteed only when the sensor is operating in mode which which
> + * a command belongs to.
> + */
> +int m5mols_mode(struct m5mols_info *info, u32 mode)
> +{
> +	struct v4l2_subdev *sd = &info->sd;
> +	int ret = -EINVAL;
> +	u32 reg;
> +
> +	if (mode < REG_PARAMETER && mode > REG_CAPTURE)
> +		return ret;
> +
> +	ret = m5mols_read(sd, SYSTEM_SYSMODE, &reg);
> +	if ((!ret && reg == mode) || ret)
> +		return ret;
> +
> +	switch (reg) {
> +	case REG_PARAMETER:
> +		ret = m5mols_reg_mode(sd, REG_MONITOR);
> +		if (!ret && mode == REG_MONITOR)
> +			break;
> +		if (!ret)
> +			ret = m5mols_reg_mode(sd, REG_CAPTURE);
> +		break;
> +
> +	case REG_MONITOR:
> +		if (mode == REG_PARAMETER) {
> +			ret = m5mols_reg_mode(sd, REG_PARAMETER);
> +			break;
> +		}
> +
> +		ret = m5mols_reg_mode(sd, REG_CAPTURE);
> +		break;
> +
> +	case REG_CAPTURE:
> +		ret = m5mols_reg_mode(sd, REG_MONITOR);
> +		if (!ret && mode == REG_MONITOR)
> +			break;
> +		if (!ret)
> +			ret = m5mols_reg_mode(sd, REG_PARAMETER);
> +		break;
> +
> +	default:
> +		v4l2_warn(sd, "Wrong mode: %d\n", mode);
> +	}
> +
> +	if (!ret)
> +		info->mode = mode;
> +
> +	return ret;
> +}
> +
> +/**
> + * m5mols_get_version - retrieve full revisions information of M-5MOLS
> + *
> + * The version information includes revisions of hardware and firmware,
> + * AutoFocus alghorithm version and the version string.
> + */
> +static int m5mols_get_version(struct v4l2_subdev *sd)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	union {
> +		struct m5mols_version ver;
> +		u8 bytes[VERSION_SIZE];

You could even use u8 bytes[0] if you really need this union.

((char *)&ver)[cmd], for example.

> +	} version;
> +	u32 *value;
> +	u8 cmd = CAT0_VER_CUSTOMER;
> +	int ret;
> +
> +	do {
> +		value = (u32 *)&version.bytes[cmd];
> +		ret = m5mols_read(sd, SYSTEM_CMD(cmd), value);
> +		if (ret)
> +			return ret;
> +	} while (cmd++ != CAT0_VER_AWB);
> +
> +	do {
> +		value = (u32 *)&version.bytes[cmd];
> +		ret = m5mols_read(sd, SYSTEM_VER_STRING, value);
> +		if (ret)
> +			return ret;
> +		if (cmd >= VERSION_SIZE - 1)
> +			return -EINVAL;
> +	} while (version.bytes[cmd++]);


Please move cmd++ outside the condition.

I think you should have a different function to read and write different
types, e.g. m5mols_read_u8 and m5mols_read_u16.

You have the access width encoded in the register value. That would still be
checked by the function.

You also could subtract CAT0_VER_CUSTOMER from cmd when using it as index
to bytes[] above, as you now rely that it is actually zero.

> +
> +	value = (u32 *)&version.bytes[cmd];
> +	ret = m5mols_read(sd, AF_VERSION, value);

I think it'd be cleaner to refer to (u32 *)&version.bytes[cmd] directly
instead of using value.

Can you be sure that cmd points to the AF version here?

> +	if (ret)
> +		return ret;
> +
> +	/* store version information swapped for being readable */
> +	info->ver	= version.ver;

You could use info->ver straight away and drop version.ver.

> +	info->ver.fw	= be16_to_cpu(info->ver.fw);
> +	info->ver.hw	= be16_to_cpu(info->ver.hw);
> +	info->ver.param	= be16_to_cpu(info->ver.param);
> +	info->ver.awb	= be16_to_cpu(info->ver.awb);
> +
> +	v4l2_info(sd, "Manufacturer\t[%s]\n",
> +			is_manufacturer(info, REG_SAMSUNG_ELECTRO) ?
> +			"Samsung Electro-Machanics" :
> +			is_manufacturer(info, REG_SAMSUNG_OPTICS) ?
> +			"Samsung Fiber-Optics" :
> +			is_manufacturer(info, REG_SAMSUNG_TECHWIN) ?
> +			"Samsung Techwin" : "None");
> +	v4l2_info(sd, "Customer/Project\t[0x%02x/0x%02x]\n",
> +			info->ver.customer, info->ver.project);
> +
> +	if (!is_available_af(info))
> +		v4l2_info(sd, "No support Auto Focus on this firmware\n");
> +
> +	return ret;
> +}
> +
> +/**
> + * __find_restype - Lookup M-5MOLS resolution type according to pixel code
> + * @code: pixel code
> + */
> +static enum m5mols_restype __find_restype(enum v4l2_mbus_pixelcode code)
> +{
> +	enum m5mols_restype type = M5MOLS_RESTYPE_MONITOR;
> +
> +	do {
> +		if (code == m5mols_default_ffmt[type].code)
> +			return type;

type++ here, and ++ off of the condition below.

> +	} while (type++ != SIZE_DEFAULT_FFMT);
> +
> +	return 0;
> +}
> +
> +/**
> + * __find_resolution - Lookup preset and type of M-5MOLS's resolution
> + * @mf: pixel format to find/negotiate the resolution preset for
> + * @type: M-5MOLS resolution type
> + * @resolution:	M-5MOLS resolution preset register value
> + *
> + * Find nearest resolution matching resolution preset and adjust mf
> + * to supported values.
> + */
> +static int __find_resolution(struct v4l2_subdev *sd,
> +			     struct v4l2_mbus_framefmt *mf,
> +			     enum m5mols_restype *type,
> +			     u32 *resolution)
> +{
> +	const struct m5mols_resolution *fsize = &m5mols_reg_res[0];
> +	const struct m5mols_resolution *match = NULL;
> +	enum m5mols_restype stype = __find_restype(mf->code);
> +	int i = ARRAY_SIZE(m5mols_reg_res);
> +	unsigned int min_err = ~0;
> +
> +	while (i--) {
> +		int err;
> +		if (stype == fsize->type) {
> +			err = abs(fsize->width - mf->width)
> +				+ abs(fsize->height - mf->height);
> +
> +			if (err < min_err) {
> +				min_err = err;
> +				match = fsize;
> +			}
> +		}
> +		fsize++;
> +	}
> +	if (match) {
> +		mf->width  = match->width;
> +		mf->height = match->height;
> +		*resolution = match->reg;
> +		*type = stype;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static struct v4l2_mbus_framefmt *__find_format(struct m5mols_info *info,
> +				struct v4l2_subdev_fh *fh,
> +				enum v4l2_subdev_format_whence which,
> +				enum m5mols_restype type)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return fh ? v4l2_subdev_get_try_format(fh, 0) : NULL;
> +
> +	return &info->ffmt[type];
> +}
> +
> +static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct v4l2_mbus_framefmt *format;
> +
> +	if (fmt->pad != 0)
> +		return -EINVAL;
> +
> +	format = __find_format(info, fh, fmt->which, info->res_type);
> +	if (!format)
> +		return -EINVAL;
> +
> +	fmt->format = *format;
> +	return 0;
> +}
> +
> +static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	struct v4l2_mbus_framefmt *format = &fmt->format;
> +	struct v4l2_mbus_framefmt *sfmt;
> +	enum m5mols_restype type;
> +	u32 resolution = 0;
> +	int ret;
> +
> +	if (fmt->pad != 0)
> +		return -EINVAL;
> +
> +	ret = __find_resolution(sd, format, &type, &resolution);
> +	if (ret < 0)
> +		return ret;
> +
> +	sfmt = __find_format(info, fh, fmt->which, type);
> +	if (!sfmt)
> +		return 0;
> +
> +	*sfmt		= m5mols_default_ffmt[type];
> +	sfmt->width	= format->width;
> +	sfmt->height	= format->height;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		info->resolution = resolution;
> +		info->code = format->code;
> +		info->res_type = type;
> +	}
> +
> +	return 0;
> +}
> +
> +static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	ifv (!code || code->index >= SIZE_DEFAULT_FFMT)

Is it possible that code == NULL?

> +		return -EINVAL;
> +
> +	code->code = m5mols_default_ffmt[code->index].code;
> +
> +	return 0;
> +}
> +
> +static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
> +	.enum_mbus_code	= m5mols_enum_mbus_code,
> +	.get_fmt	= m5mols_get_fmt,
> +	.set_fmt	= m5mols_set_fmt,
> +};
> +
> +/**
> + * m5mols_sync_controls - Apply default scene mode and the current controls
> + *
> + * This is used only streaming for syncing between v4l2_ctrl framework and
> + * m5mols's controls. First, do the scenemode to the sensor, then call
> + * v4l2_ctrl_handler_setup. It can be same between some commands and
> + * the scenemode's in the default v4l2_ctrls. But, such commands of control
> + * should be prior to the scenemode's one.
> + */
> +int m5mols_sync_controls(struct m5mols_info *info)
> +{
> +	int ret = -EINVAL;
> +
> +	if (!is_ctrl_synced(info)) {
> +		ret = m5mols_do_scenemode(info, REG_SCENE_NORMAL);
> +		if (ret)
> +			return ret;
> +
> +		v4l2_ctrl_handler_setup(&info->handle);
> +		info->ctrl_sync = true;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * m5mols_start_monitor - Start the monitor mode
> + *
> + * Before applying the controls setup the resolution and frame rate
> + * in PARAMETER mode, and then switch over to MONITOR mode.
> + */
> +static int m5mols_start_monitor(struct m5mols_info *info)
> +{
> +	struct v4l2_subdev *sd = &info->sd;
> +	int ret;
> +
> +	ret = m5mols_mode(info, REG_PARAMETER);
> +	if (!ret)
> +		ret = m5mols_write(sd, PARM_MON_SIZE, info->resolution);
> +	if (!ret)
> +		ret = m5mols_write(sd, PARM_MON_FPS, REG_FPS_30);
> +	if (!ret)
> +		ret = m5mols_mode(info, REG_MONITOR);
> +	if (!ret)
> +		ret = m5mols_sync_controls(info);
> +
> +	return ret;
> +}
> +
> +static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	if (enable) {
> +		int ret = -EINVAL;
> +
> +		if (is_code(info->code, M5MOLS_RESTYPE_MONITOR))
> +			ret = m5mols_start_monitor(info);
> +		if (is_code(info->code, M5MOLS_RESTYPE_CAPTURE))
> +			ret = m5mols_start_capture(info);
> +
> +		return ret;
> +	}
> +
> +	return m5mols_mode(info, REG_PARAMETER);
> +}
> +
> +static const struct v4l2_subdev_video_ops m5mols_video_ops = {
> +	.s_stream	= m5mols_s_stream,
> +};
> +
> +static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct v4l2_subdev *sd = to_sd(ctrl);
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int ret;
> +
> +	info->mode_save = info->mode;
> +
> +	ret = m5mols_mode(info, REG_PARAMETER);
> +	if (!ret)
> +		ret = m5mols_set_ctrl(ctrl);
> +	if (!ret)
> +		ret = m5mols_mode(info, info->mode_save);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
> +	.s_ctrl	= m5mols_s_ctrl,
> +};
> +
> +static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
> +{
> +	struct v4l2_subdev *sd = &info->sd;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	const struct m5mols_platform_data *pdata = info->pdata;
> +	int ret;
> +
> +	if (enable) {
> +		if (is_powered(info))
> +			return 0;
> +
> +		if (info->set_power) {
> +			ret = info->set_power(&client->dev, 1);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
> +		if (ret) {
> +			info->set_power(&client->dev, 0);
> +			return ret;
> +		}
> +
> +		gpio_set_value(pdata->gpio_reset, !pdata->reset_polarity);
> +		usleep_range(1000, 1000);
> +		info->power = true;
> +
> +		return ret;
> +	}
> +
> +	if (!is_powered(info))
> +		return 0;
> +
> +	ret = regulator_bulk_disable(ARRAY_SIZE(supplies), supplies);
> +	if (ret)
> +		return ret;
> +
> +	if (info->set_power)
> +		info->set_power(&client->dev, 0);
> +
> +	gpio_set_value(pdata->gpio_reset, pdata->reset_polarity);
> +	usleep_range(1000, 1000);
> +	info->power = false;
> +
> +	return ret;
> +}
> +
> +/* m5mols_update_fw - optional firmware update routine */
> +int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
> +		int (*set_power)(struct m5mols_info *, bool))
> +{
> +	return 0;
> +}
> +
> +/**
> + * m5mols_sensor_armboot - Booting M-5MOLS internal ARM core.
> + *
> + * Booting internal ARM core makes the M-5MOLS is ready for getting commands
> + * with I2C. It's the first thing to be done after it powered up. It must wait
> + * at least 520ms recommended by M-5MOLS datasheet, after executing arm booting.
> + */
> +static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
> +{
> +	int ret;
> +
> +	ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
> +	if (ret < 0)
> +		return ret;
> +
> +	msleep(520);
> +
> +	ret = m5mols_get_version(sd);
> +	if (!ret)
> +		ret = m5mols_update_fw(sd, m5mols_sensor_power);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_dbg(1, m5mols_debug, sd, "Success ARM Booting\n");
> +
> +	ret = m5mols_write(sd, PARM_INTERFACE, REG_INTERFACE_MIPI);
> +	if (!ret)
> +		ret = m5mols_enable_interrupt(sd, REG_INT_AF);
> +
> +	return ret;
> +}
> +
> +static int m5mols_init_controls(struct m5mols_info *info)
> +{
> +	struct v4l2_subdev *sd = &info->sd;
> +	u16 max_exposure;
> +	u16 step_zoom;
> +	int ret;
> +
> +	/* Determine value's range & step of controls for various FW version */
> +	ret = m5mols_read(sd, AE_MAX_GAIN_MON, (u32 *)&max_exposure);
> +	if (!ret)
> +		step_zoom = is_manufacturer(info, REG_SAMSUNG_OPTICS) ? 31 : 1;
> +	if (ret)
> +		return ret;
> +
> +	v4l2_ctrl_handler_init(&info->handle, 6);
> +	info->autowb = v4l2_ctrl_new_std(&info->handle,
> +			&m5mols_ctrl_ops, V4L2_CID_AUTO_WHITE_BALANCE,
> +			0, 1, 1, 0);
> +	info->saturation = v4l2_ctrl_new_std(&info->handle,
> +			&m5mols_ctrl_ops, V4L2_CID_SATURATION,
> +			1, 5, 1, 3);
> +	info->zoom = v4l2_ctrl_new_std(&info->handle,
> +			&m5mols_ctrl_ops, V4L2_CID_ZOOM_ABSOLUTE,
> +			1, 70, step_zoom, 1);
> +	info->exposure = v4l2_ctrl_new_std(&info->handle,
> +			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
> +			0, max_exposure, 1, (int)max_exposure/2);
> +	info->colorfx = v4l2_ctrl_new_std_menu(&info->handle,
> +			&m5mols_ctrl_ops, V4L2_CID_COLORFX,
> +			4, (1 << V4L2_COLORFX_BW), V4L2_COLORFX_NONE);
> +	info->autoexposure = v4l2_ctrl_new_std_menu(&info->handle,
> +			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
> +			1, 0, V4L2_EXPOSURE_MANUAL);
> +
> +	sd->ctrl_handler = &info->handle;
> +	if (info->handle.error) {
> +		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
> +		v4l2_ctrl_handler_free(&info->handle);
> +		return info->handle.error;
> +	}
> +
> +	v4l2_ctrl_cluster(2, &info->autoexposure);
> +
> +	return 0;
> +}
> +
> +/**
> + * m5mols_s_power - Main sensor power control function
> + *
> + * To prevent breaking the lens when the sensor is powered off the Soft-Landing
> + * algorithm is called where available. The Soft-Landing algorithm availability
> + * dependends on the firmware provider.
> + */
> +static int m5mols_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +	int ret;
> +
> +	if (on) {
> +		ret = m5mols_sensor_power(info, true);
> +		if (!ret)
> +			ret = m5mols_sensor_armboot(sd);
> +		if (!ret)
> +			ret = m5mols_init_controls(info);
> +		if (ret)
> +			return ret;
> +
> +		info->ffmt[M5MOLS_RESTYPE_MONITOR] =
> +			m5mols_default_ffmt[M5MOLS_RESTYPE_MONITOR];
> +		info->ffmt[M5MOLS_RESTYPE_CAPTURE] =
> +			m5mols_default_ffmt[M5MOLS_RESTYPE_CAPTURE];
> +		return ret;
> +	}
> +
> +	if (is_manufacturer(info, REG_SAMSUNG_TECHWIN)) {
> +		ret = m5mols_mode(info, REG_MONITOR);
> +		if (!ret)
> +			ret = m5mols_write(sd, AF_EXECUTE, REG_AF_STOP);
> +		if (!ret)
> +			ret = m5mols_write(sd, AF_MODE, REG_AF_POWEROFF);
> +		if (!ret)
> +			ret = m5mols_busy(sd, CAT_SYSTEM, CAT0_STATUS,
> +					REG_AF_IDLE);
> +		if (!ret)
> +			v4l2_info(sd, "Success soft-landing lens\n");
> +	}
> +
> +	ret = m5mols_sensor_power(info, false);
> +	if (!ret) {
> +		v4l2_ctrl_handler_free(&info->handle);
> +		info->ctrl_sync = false;
> +	}
> +
> +	return ret;
> +}
> +
> +static int m5mols_log_status(struct v4l2_subdev *sd)
> +{
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	v4l2_ctrl_handler_log_status(&info->handle, sd->name);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops m5mols_core_ops = {
> +	.s_power	= m5mols_s_power,
> +	.g_ctrl		= v4l2_subdev_g_ctrl,
> +	.s_ctrl		= v4l2_subdev_s_ctrl,
> +	.queryctrl	= v4l2_subdev_queryctrl,
> +	.querymenu	= v4l2_subdev_querymenu,
> +	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
> +	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
> +	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
> +	.log_status	= m5mols_log_status,
> +};
> +
> +static const struct v4l2_subdev_ops m5mols_ops = {
> +	.core		= &m5mols_core_ops,
> +	.pad		= &m5mols_pad_ops,
> +	.video		= &m5mols_video_ops,
> +};
> +
> +static void m5mols_irq_work(struct work_struct *work)
> +{
> +	struct m5mols_info *info =
> +		container_of(work, struct m5mols_info, work_irq);
> +	struct v4l2_subdev *sd = &info->sd;
> +	u32 reg;
> +	int ret;
> +
> +	if (!is_powered(info) ||
> +			m5mols_read(sd, SYSTEM_INT_FACTOR, &info->interrupt))
> +		return;
> +
> +	switch (info->interrupt & REG_INT_MASK) {
> +	case REG_INT_AF:
> +		if (!is_available_af(info))
> +			break;
> +		ret = m5mols_read(sd, AF_STATUS, &reg);
> +		v4l2_dbg(2, m5mols_debug, sd, "AF %s\n",
> +			 reg == REG_AF_FAIL ? "Failed" :
> +			 reg == REG_AF_SUCCESS ? "Success" :
> +			 reg == REG_AF_IDLE ? "Idle" : "Busy");
> +		break;
> +	case REG_INT_CAPTURE:
> +		if (!test_and_set_bit(ST_CAPT_IRQ, &info->flags))
> +			wake_up_interruptible(&info->irq_waitq);
> +
> +		v4l2_dbg(2, m5mols_debug, sd, "CAPTURE\n");
> +		break;
> +	default:
> +		v4l2_dbg(2, m5mols_debug, sd, "Undefined: %02x\n", reg);
> +		break;
> +	};
> +}
> +
> +static irqreturn_t m5mols_irq_handler(int irq, void *data)
> +{
> +	struct v4l2_subdev *sd = data;
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	schedule_work(&info->work_irq);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit m5mols_probe(struct i2c_client *client,
> +				  const struct i2c_device_id *id)
> +{
> +	const struct m5mols_platform_data *pdata = client->dev.platform_data;
> +	struct m5mols_info *info;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "No platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!gpio_is_valid(pdata->gpio_reset)) {
> +		dev_err(&client->dev, "No valid RESET GPIO specified\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!pdata->irq) {
> +		dev_err(&client->dev, "Interrupt not assigned\n");
> +		return -EINVAL;
> +	}
> +
> +	info = kzalloc(sizeof(struct m5mols_info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->pdata = pdata;
> +	info->set_power	= pdata->set_power;
> +
> +	ret = gpio_request(pdata->gpio_reset, "M5MOLS_NRST");
> +	if (ret) {
> +		dev_err(&client->dev, "Failed to request gpio: %d\n", ret);
> +		goto out_free;
> +	}
> +	gpio_direction_output(pdata->gpio_reset, pdata->reset_polarity);
> +
> +	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed to get regulators: %d\n", ret);
> +		goto out_gpio;
> +	}
> +
> +	sd = &info->sd;
> +	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> +	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
> +
> +	info->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
> +	if (ret < 0)
> +		goto out_reg;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +
> +	init_waitqueue_head(&info->irq_waitq);
> +	INIT_WORK(&info->work_irq, m5mols_irq_work);
> +	ret = request_irq(pdata->irq, m5mols_irq_handler,
> +			  IRQF_TRIGGER_RISING, MODULE_NAME, sd);
> +	if (ret) {
> +		dev_err(&client->dev, "Interrupt request failed: %d\n", ret);
> +		goto out_me;
> +	}
> +	info->res_type = M5MOLS_RESTYPE_MONITOR;
> +	return 0;
> +out_me:
> +	media_entity_cleanup(&sd->entity);
> +out_reg:
> +	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
> +out_gpio:
> +	gpio_free(pdata->gpio_reset);
> +out_free:
> +	kfree(info);
> +	return ret;
> +}
> +
> +static int __devexit m5mols_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct m5mols_info *info = to_m5mols(sd);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	free_irq(info->pdata->irq, sd);
> +
> +	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
> +	gpio_free(info->pdata->gpio_reset);
> +	media_entity_cleanup(&sd->entity);
> +	kfree(info);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id m5mols_id[] = {
> +	{ MODULE_NAME, 0 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, m5mols_id);
> +
> +static struct i2c_driver m5mols_i2c_driver = {
> +	.driver = {
> +		.name	= MODULE_NAME,
> +	},
> +	.probe		= m5mols_probe,
> +	.remove		= __devexit_p(m5mols_remove),
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
> +MODULE_AUTHOR("HeungJun Kim <riverful.kim@samsung.com>");
> +MODULE_AUTHOR("Dongsoo Kim <dongsoo45.kim@samsung.com>");
> +MODULE_DESCRIPTION("Fujitsu M-5MOLS 8M Pixel camera driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
> new file mode 100644
> index 0000000..b83e36f
> --- /dev/null
> +++ b/drivers/media/video/m5mols/m5mols_reg.h
> @@ -0,0 +1,399 @@
> +/*
> + * Register map for M-5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef M5MOLS_REG_H
> +#define M5MOLS_REG_H
> +
> +#define M5MOLS_I2C_MAX_SIZE	4
> +#define M5MOLS_BYTE_READ	0x01
> +#define M5MOLS_BYTE_WRITE	0x02
> +
> +#define I2C_CATEGORY(__cat)		((__cat >> 16) & 0xff)
> +#define I2C_COMMAND(__comm)		((__comm >> 8) & 0xff)
> +#define I2C_SIZE(__reg_s)		((__reg_s) & 0xff)

I would put category and command to lower 16 bits and size in the upper 16
bits, but this is up to you. I think this would improve readability.

> +#define I2C_REG(__cat, __cmd, __reg_s)	((__cat << 16) | (__cmd << 8) | __reg_s)
> +
> +/*
> + * Category section register
> + *
> + * The category means set including relevant command of M-5MOLS.
> + */
> +#define CAT_SYSTEM		0x00
> +#define CAT_PARAM		0x01
> +#define CAT_MONITOR		0x02
> +#define CAT_AE			0x03
> +#define CAT_WB			0x06
> +#define CAT_EXIF		0x07
> +#define CAT_FD			0x09
> +#define CAT_LENS		0x0a
> +#define CAT_CAPT_PARM		0x0b
> +#define CAT_CAPT_CTRL		0x0c
> +#define CAT_FLASH		0x0f	/* related to FW, revisions, booting */

What about defining registers so that the category is part of the register
address? This is actually how it's in the address space as well.

> +
> +/*
> + * Category 0 - SYSTEM mode
> + *
> + * The SYSTEM mode in the M-5MOLS means area available to handle with the whole
> + * & all-round system of sensor. It deals with version/interrupt/setting mode &
> + * even sensor's status. Especially, the M-5MOLS sensor with ISP varies by
> + * packaging & manufacturer, even the customer and project code. And the
> + * function details may vary among them. The version information helps to
> + * determine what methods shall be used in the driver.
> + *
> + * There is many registers between customer version address and awb one. For
> + * more specific contents, see definition if file m5mols.h.
> + */
> +#define CAT0_VER_CUSTOMER	0x00	/* customer version */

If you keep the definitions as they are, I think "CAT0" should be replaced
by "SYSTEM". This would make it clear that the registers belong to that
category, instead of a numeric one.

> +#define CAT0_VER_AWB		0x09	/* Auto WB version */
> +#define CAT0_VER_STRING		0x0a	/* string including M-5MOLS */
> +#define CAT0_SYSMODE		0x0b	/* SYSTEM mode register */
> +#define CAT0_STATUS		0x0c	/* SYSTEM mode status register */
> +#define CAT0_INT_FACTOR		0x10	/* interrupt pending register */
> +#define CAT0_INT_ENABLE		0x11	/* interrupt enable register */
> +
> +#define SYSTEM_SYSMODE		I2C_REG(CAT_SYSTEM, CAT0_SYSMODE, 1)
> +#define REG_SYSINIT		0x00	/* SYSTEM mode */
> +#define REG_PARAMETER		0x01	/* PARAMETER mode */
> +#define REG_MONITOR		0x02	/* MONITOR mode */
> +#define REG_CAPTURE		0x03	/* CAPTURE mode */
> +
> +#define SYSTEM_CMD(__cmd)	I2C_REG(CAT_SYSTEM, cmd, 1)
> +#define SYSTEM_VER_STRING	I2C_REG(CAT_SYSTEM, CAT0_VER_STRING, 1)
> +#define REG_SAMSUNG_ELECTRO	"SE"	/* Samsung Electro-Mechanics */
> +#define REG_SAMSUNG_OPTICS	"OP"	/* Samsung Fiber-Optics */
> +#define REG_SAMSUNG_TECHWIN	"TB"	/* Samsung Techwin */
> +
> +#define SYSTEM_INT_FACTOR	I2C_REG(CAT_SYSTEM, CAT0_INT_FACTOR, 1)
> +#define SYSTEM_INT_ENABLE	I2C_REG(CAT_SYSTEM, CAT0_INT_ENABLE, 1)
> +#define REG_INT_MODE		(1 << 0)
> +#define REG_INT_AF		(1 << 1)
> +#define REG_INT_ZOOM		(1 << 2)
> +#define REG_INT_CAPTURE		(1 << 3)
> +#define REG_INT_FRAMESYNC	(1 << 4)
> +#define REG_INT_FD		(1 << 5)
> +#define REG_INT_LENS_INIT	(1 << 6)
> +#define REG_INT_SOUND		(1 << 7)
> +#define REG_INT_MASK		0x0f

I would prefix the register bit definitions with the name of the register.

E.g.

#define SYSTEM_INT_FACTOR_MODE	(1 << 0)

> +
> +/*
> + * category 1 - PARAMETER mode
> + *
> + * This category supports function of camera features of M-5MOLS. It means we
> + * can handle with preview(MONITOR) resolution size/frame per second/interface
> + * between the sensor and the Application Processor/even the image effect.
> + */
> +#define CAT1_DATA_INTERFACE	0x00	/* interface between sensor and AP */
> +#define CAT1_MONITOR_SIZE	0x01	/* resolution at the MONITOR mode */
> +#define CAT1_MONITOR_FPS	0x02	/* frame per second at this mode */
> +#define CAT1_EFFECT		0x0b	/* image effects */
> +
> +#define PARM_MON_SIZE		I2C_REG(CAT_PARAM, CAT1_MONITOR_SIZE, 1)
> +
> +#define PARM_MON_FPS		I2C_REG(CAT_PARAM, CAT1_MONITOR_FPS, 1)
> +#define REG_FPS_30		0x02
> +
> +#define PARM_INTERFACE		I2C_REG(CAT_PARAM, CAT1_DATA_INTERFACE, 1)
> +#define REG_INTERFACE_MIPI	0x02
> +
> +#define PARM_EFFECT		I2C_REG(CAT_PARAM, CAT1_EFFECT, 1)
> +#define REG_EFFECT_OFF		0x00
> +#define REG_EFFECT_NEGA		0x01
> +#define REG_EFFECT_EMBOSS	0x06
> +#define REG_EFFECT_OUTLINE	0x07
> +#define REG_EFFECT_WATERCOLOR	0x08
> +
> +/*
> + * Category 2 - MONITOR mode
> + *
> + * The MONITOR mode is same as preview mode as we said. The M-5MOLS has another
> + * mode named "Preview", but this preview mode is used at the case specific
> + * vider-recording mode. This mmode supports only YUYV format. On the other
> + * hand, the JPEG & RAW formats is supports by CAPTURE mode. And, there are
> + * another options like zoom/color effect(different with effect in PARAMETER
> + * mode)/anti hand shaking algorithm.
> + */
> +#define CAT2_ZOOM		0x01	/* set the zoom position & execute */
> +#define CAT2_ZOOM_STEP		0x03	/* set the zoom step */
> +#define CAT2_CFIXB		0x09	/* CB value for color effect */
> +#define CAT2_CFIXR		0x0a	/* CR value for color effect */
> +#define CAT2_COLOR_EFFECT	0x0b	/* set on/off of color effect */
> +#define CAT2_CHROMA_LVL		0x0f	/* set chroma level */
> +#define CAT2_CHROMA_EN		0x10	/* set on/off of choroma */
> +#define CAT2_EDGE_LVL		0x11	/* set sharpness level */
> +#define CAT2_EDGE_EN		0x12	/* set on/off sharpness */
> +#define CAT2_TONE_CTL		0x25	/* set tone color(contrast) */
> +
> +#define MON_ZOOM		I2C_REG(CAT_MONITOR, CAT2_ZOOM, 1)
> +
> +#define MON_CFIXR		I2C_REG(CAT_MONITOR, CAT2_CFIXR, 1)
> +#define MON_CFIXB		I2C_REG(CAT_MONITOR, CAT2_CFIXB, 1)
> +#define REG_CFIXB_SEPIA		0xd8
> +#define REG_CFIXR_SEPIA		0x18
> +
> +#define MON_EFFECT		I2C_REG(CAT_MONITOR, CAT2_COLOR_EFFECT, 1)
> +#define REG_COLOR_EFFECT_OFF	0x00
> +#define REG_COLOR_EFFECT_ON	0x01
> +
> +#define MON_CHROMA_EN		I2C_REG(CAT_MONITOR, CAT2_CHROMA_EN, 1)
> +#define MON_CHROMA_LVL		I2C_REG(CAT_MONITOR, CAT2_CHROMA_LVL, 1)
> +#define REG_CHROMA_OFF		0x00
> +#define REG_CHROMA_ON		0x01
> +
> +#define MON_EDGE_EN		I2C_REG(CAT_MONITOR, CAT2_EDGE_EN, 1)
> +#define MON_EDGE_LVL		I2C_REG(CAT_MONITOR, CAT2_EDGE_LVL, 1)
> +#define REG_EDGE_OFF		0x00
> +#define REG_EDGE_ON		0x01
> +
> +#define MON_TONE_CTL		I2C_REG(CAT_MONITOR, CAT2_TONE_CTL, 1)
> +
> +/*
> + * Category 3 - Auto Exposure
> + *
> + * The M-5MOLS exposure capbility is detailed as which is similar to digital
> + * camera. This category supports AE locking/various AE mode(range of exposure)
> + * /ISO/flickering/EV bias/shutter/meteoring, and anything else. And the
> + * maximum/minimum exposure gain value depending on M-5MOLS firmware, may be
> + * different. So, this category also provide getting the max/min values. And,
> + * each MONITOR and CAPTURE mode has each gain/shutter/max exposure values.
> + */
> +#define CAT3_AE_LOCK		0x00	/* locking Auto exposure */
> +#define CAT3_AE_MODE		0x01	/* set AE mode, mode means range */
> +#define CAT3_ISO		0x05	/* set ISO */
> +#define CAT3_EV_PRESET_MONITOR	0x0a	/* EV(scenemode) preset for MONITOR */
> +#define CAT3_EV_PRESET_CAPTURE	0x0b	/* EV(scenemode) preset for CAPTURE */
> +#define CAT3_MANUAL_GAIN_MON	0x12	/* meteoring value for the MONITOR */
> +#define CAT3_MAX_GAIN_MON	0x1a	/* max gain value for the MONITOR */
> +#define CAT3_MANUAL_GAIN_CAP	0x26	/* meteoring value for the CAPTURE */
> +#define CAT3_AE_INDEX		0x38	/* AE index */
> +
> +#define AE_LOCK			I2C_REG(CAT_AE, CAT3_AE_LOCK, 1)
> +#define REG_AE_UNLOCK		0x00
> +#define REG_AE_LOCK		0x01
> +
> +#define AE_MODE			I2C_REG(CAT_AE, CAT3_AE_MODE, 1)
> +#define REG_AE_OFF		0x00	/* AE off */
> +#define REG_AE_ALL		0x01	/* calc AE in all block integral */
> +#define REG_AE_CENTER		0x03	/* calc AE in center weighted */
> +#define REG_AE_SPOT		0x06	/* calc AE in specific spot */
> +
> +#define AE_ISO			I2C_REG(CAT_AE, CAT3_ISO, 1)
> +#define REG_ISO_AUTO		0x00
> +#define REG_ISO_50		0x01
> +#define REG_ISO_100		0x02
> +#define REG_ISO_200		0x03
> +#define REG_ISO_400		0x04
> +#define REG_ISO_800		0x05
> +
> +#define AE_EV_PRESET_MONITOR	I2C_REG(CAT_AE, CAT3_EV_PRESET_MONITOR, 1)
> +#define AE_EV_PRESET_CAPTURE	I2C_REG(CAT_AE, CAT3_EV_PRESET_CAPTURE, 1)
> +#define REG_SCENE_NORMAL	0x00
> +#define REG_SCENE_PORTRAIT	0x01
> +#define REG_SCENE_LANDSCAPE	0x02
> +#define REG_SCENE_SPORTS	0x03
> +#define REG_SCENE_PARTY_INDOOR	0x04
> +#define REG_SCENE_BEACH_SNOW	0x05
> +#define REG_SCENE_SUNSET	0x06
> +#define REG_SCENE_DAWN_DUSK	0x07
> +#define REG_SCENE_FALL		0x08
> +#define REG_SCENE_NIGHT		0x09
> +#define REG_SCENE_AGAINST_LIGHT	0x0a
> +#define REG_SCENE_FIRE		0x0b
> +#define REG_SCENE_TEXT		0x0c
> +#define REG_SCENE_CANDLE	0x0d
> +
> +#define AE_MAN_GAIN_MON		I2C_REG(CAT_AE, CAT3_MANUAL_GAIN_MON, 2)
> +#define AE_MAX_GAIN_MON		I2C_REG(CAT_AE, CAT3_MAX_GAIN_MON, 2)
> +#define AE_MAN_GAIN_CAP		I2C_REG(CAT_AE, CAT3_MANUAL_GAIN_CAP, 2)
> +
> +#define AE_INDEX		I2C_REG(CAT_AE, CAT3_AE_INDEX, 1)
> +#define REG_AE_INDEX_20_NEG	0x00
> +#define REG_AE_INDEX_15_NEG	0x01
> +#define REG_AE_INDEX_10_NEG	0x02
> +#define REG_AE_INDEX_05_NEG	0x03
> +#define REG_AE_INDEX_00		0x04
> +#define REG_AE_INDEX_05_POS	0x05
> +#define REG_AE_INDEX_10_POS	0x06
> +#define REG_AE_INDEX_15_POS	0x07
> +#define REG_AE_INDEX_20_POS	0x08
> +
> +/*
> + * Category 6 - White Balance
> + *
> + * This category provide AWB locking/mode/preset/speed/gain bias, etc.
> + */
> +#define CAT6_AWB_LOCK		0x00	/* locking Auto Whitebalance */
> +#define CAT6_AWB_MODE		0x02	/* set Auto or Manual */
> +#define CAT6_AWB_MANUAL		0x03	/* set Manual(preset) value */
> +
> +#define AWB_LOCK		I2C_REG(CAT_WB, CAT6_AWB_LOCK, 1)
> +#define REG_AWB_UNLOCK		0x00
> +#define REG_AWB_LOCK		0x01
> +
> +#define AWB_MODE		I2C_REG(CAT_WB, CAT6_AWB_MODE, 1)
> +#define REG_AWB_AUTO		0x01	/* AWB off */
> +#define REG_AWB_PRESET		0x02	/* AWB preset */
> +
> +#define AWB_MANUAL		I2C_REG(CAT_WB, CAT6_AWB_MANUAL, 1)
> +#define REG_AWB_INCANDESCENT	0x01
> +#define REG_AWB_FLUORESCENT_1	0x02
> +#define REG_AWB_FLUORESCENT_2	0x03
> +#define REG_AWB_DAYLIGHT	0x04
> +#define REG_AWB_CLOUDY		0x05
> +#define REG_AWB_SHADE		0x06
> +#define REG_AWB_HORIZON		0x07
> +#define REG_AWB_LEDLIGHT	0x09
> +
> +/*
> + * Category 7 - EXIF information
> + */
> +#define CAT7_INFO_EXPTIME_NU	0x00
> +#define CAT7_INFO_EXPTIME_DE	0x04
> +#define CAT7_INFO_TV_NU		0x08
> +#define CAT7_INFO_TV_DE		0x0c
> +#define CAT7_INFO_AV_NU		0x10
> +#define CAT7_INFO_AV_DE		0x14
> +#define CAT7_INFO_BV_NU		0x18
> +#define CAT7_INFO_BV_DE		0x1c
> +#define CAT7_INFO_EBV_NU	0x20
> +#define CAT7_INFO_EBV_DE	0x24
> +#define CAT7_INFO_ISO		0x28
> +#define CAT7_INFO_FLASH		0x2a
> +#define CAT7_INFO_SDR		0x2c
> +#define CAT7_INFO_QVAL		0x2e
> +
> +#define EXIF_INFO_EXPTIME_NU	I2C_REG(CAT_EXIF, CAT7_INFO_EXPTIME_NU, 4)
> +#define EXIF_INFO_EXPTIME_DE	I2C_REG(CAT_EXIF, CAT7_INFO_EXPTIME_DE, 4)
> +#define EXIF_INFO_TV_NU		I2C_REG(CAT_EXIF, CAT7_INFO_TV_NU, 4)
> +#define EXIF_INFO_TV_DE		I2C_REG(CAT_EXIF, CAT7_INFO_TV_DE, 4)
> +#define EXIF_INFO_AV_NU		I2C_REG(CAT_EXIF, CAT7_INFO_AV_NU, 4)
> +#define EXIF_INFO_AV_DE		I2C_REG(CAT_EXIF, CAT7_INFO_AV_DE, 4)
> +#define EXIF_INFO_BV_NU		I2C_REG(CAT_EXIF, CAT7_INFO_BV_NU, 4)
> +#define EXIF_INFO_BV_DE		I2C_REG(CAT_EXIF, CAT7_INFO_BV_DE, 4)
> +#define EXIF_INFO_EBV_NU	I2C_REG(CAT_EXIF, CAT7_INFO_EBV_NU, 4)
> +#define EXIF_INFO_EBV_DE	I2C_REG(CAT_EXIF, CAT7_INFO_EBV_DE, 4)
> +#define EXIF_INFO_ISO		I2C_REG(CAT_EXIF, CAT7_INFO_ISO, 2)
> +#define EXIF_INFO_FLASH		I2C_REG(CAT_EXIF, CAT7_INFO_FLASH, 2)
> +#define EXIF_INFO_SDR		I2C_REG(CAT_EXIF, CAT7_INFO_SDR, 2)
> +#define EXIF_INFO_QVAL		I2C_REG(CAT_EXIF, CAT7_INFO_QVAL, 2)
> +
> +/*
> + * Category 9 - Face Detection
> + */
> +#define CAT9_FD_CTL		0x00
> +
> +#define FD_CTL			I2C_REG(CAT_FD, CAT9_FD_CTL, 1)
> +#define BIT_FD_EN		0
> +#define BIT_FD_DRAW_FACE_FRAME	4
> +#define BIT_FD_DRAW_SMILE_LVL	6
> +#define REG_FD(shift)		(1 << shift)
> +#define REG_FD_OFF		0x0
> +
> +/*
> + * Category A - Lens Parameter
> + */
> +#define CATA_AF_MODE		0x01
> +#define CATA_AF_EXECUTE		0x02
> +#define CATA_AF_STATUS		0x03
> +#define CATA_AF_VERSION		0x0a
> +
> +#define AF_MODE			I2C_REG(CAT_LENS, CATA_AF_MODE, 1)
> +#define REG_AF_NORMAL		0x00	/* Normal AF, one time */
> +#define REG_AF_MACRO		0x01	/* Macro AF, one time */
> +#define REG_AF_POWEROFF		0x07
> +
> +#define AF_EXECUTE		I2C_REG(CAT_LENS, CATA_AF_EXECUTE, 1)
> +#define REG_AF_STOP		0x00
> +#define REG_AF_EXE_AUTO		0x01
> +#define REG_AF_EXE_CAF		0x02
> +
> +#define AF_STATUS		I2C_REG(CAT_LENS, CATA_AF_STATUS, 1)
> +#define REG_AF_FAIL		0x00
> +#define REG_AF_SUCCESS		0x02
> +#define REG_AF_IDLE		0x04
> +#define REG_AF_BUSY		0x05
> +
> +#define AF_VERSION		I2C_REG(CAT_LENS, CATA_AF_VERSION, 1)
> +
> +/*
> + * Category B - CAPTURE Parameter
> + */
> +#define CATB_YUVOUT_MAIN	0x00
> +#define CATB_MAIN_IMAGE_SIZE	0x01
> +#define CATB_MCC_MODE		0x1d
> +#define CATB_WDR_EN		0x2c
> +#define CATB_LIGHT_CTRL		0x40
> +#define CATB_FLASH_CTRL		0x41
> +
> +#define CAPP_YUVOUT_MAIN	I2C_REG(CAT_CAPT_PARM, CATB_YUVOUT_MAIN, 1)
> +#define REG_YUV422		0x00
> +#define REG_BAYER10		0x05
> +#define REG_BAYER8		0x06
> +#define REG_JPEG		0x10
> +
> +#define CAPP_MAIN_IMAGE_SIZE	I2C_REG(CAT_CAPT_PARM, CATB_MAIN_IMAGE_SIZE, 1)
> +
> +#define CAPP_MCC_MODE		I2C_REG(CAT_CAPT_PARM, CATB_MCC_MODE, 1)
> +#define REG_MCC_OFF		0x00
> +#define REG_MCC_NORMAL		0x01
> +
> +#define CAPP_WDR_EN		I2C_REG(CAT_CAPT_PARM, CATB_WDR_EN, 1)
> +#define REG_WDR_OFF		0x00
> +#define REG_WDR_ON		0x01
> +#define REG_WDR_AUTO		0x02
> +
> +#define CAPP_LIGHT_CTRL		I2C_REG(CAT_CAPT_PARM, CATB_LIGHT_CTRL, 1)
> +#define REG_LIGHT_OFF		0x00
> +#define REG_LIGHT_ON		0x01
> +#define REG_LIGHT_AUTO		0x02
> +
> +#define CAPP_FLASH_CTRL		I2C_REG(CAT_CAPT_PARM, CATB_FLASH_CTRL, 1)
> +#define REG_FLASH_OFF		0x00
> +#define REG_FLASH_ON		0x01
> +#define REG_FLASH_AUTO		0x02
> +
> +/*
> + * Category C - CAPTURE Control
> + */
> +#define CATC_CAP_MODE		0x00
> +#define CATC_CAP_SEL_FRAME	0x06	/* It determines Single or Multi */
> +#define CATC_CAP_START		0x09
> +#define CATC_CAP_IMAGE_SIZE	0x0d
> +#define CATC_CAP_THUMB_SIZE	0x11
> +
> +#define CAPC_MODE		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_MODE, 1)
> +#define REG_CAP_NONE		0x00
> +#define REG_CAP_ANTI_SHAKE	0x02
> +
> +#define CAPC_SEL_FRAME		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_SEL_FRAME, 1)
> +
> +#define CAPC_START		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_START, 1)
> +#define REG_CAP_START_MAIN	0x01
> +#define REG_CAP_START_THUMB	0x03
> +
> +#define CAPC_IMAGE_SIZE		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_IMAGE_SIZE, 1)
> +#define CAPC_THUMB_SIZE		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_THUMB_SIZE, 1)
> +
> +/*
> + * Category F - Flash
> + *
> + * This mode provides functions about internal flash stuff and system startup.
> + */
> +#define CATF_CAM_START		0x12	/* It starts internal ARM core booting
> +					 * after power-up */
> +
> +#define FLASH_CAM_START		I2C_REG(CAT_FLASH, CATF_CAM_START, 1)
> +#define REG_START_ARM_BOOT	0x01
> +
> +#endif	/* M5MOLS_REG_H */
> diff --git a/include/media/m5mols.h b/include/media/m5mols.h
> new file mode 100644
> index 0000000..2d7e7ca
> --- /dev/null
> +++ b/include/media/m5mols.h
> @@ -0,0 +1,35 @@
> +/*
> + * Driver header for M-5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef MEDIA_M5MOLS_H
> +#define MEDIA_M5MOLS_H
> +
> +/**
> + * struct m5mols_platform_data - platform data for M-5MOLS driver
> + * @irq:	GPIO getting the irq pin of M-5MOLS
> + * @gpio_reset:	GPIO driving the reset pin of M-5MOLS
> + * @reset_polarity: active state for gpio_rst pin, 0 or 1
> + * @set_power:	an additional callback to the board setup code
> + *		to be called after enabling and before disabling
> + *		the sensor's supply regulators
> + */
> +struct m5mols_platform_data {
> +	int irq;
> +	int gpio_reset;
> +	u8 reset_polarity;
> +	int (*set_power)(struct device *dev, int on);
> +};
> +
> +#endif	/* MEDIA_M5MOLS_H */
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
