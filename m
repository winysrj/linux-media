Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35093 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab1FELzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 07:55:39 -0400
Date: Sun, 5 Jun 2011 14:55:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Kim, HeungJun" <riverful.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v9] Add support for M-5MOLS 8 Mega Pixel camera ISP
Message-ID: <20110605115529.GC6073@valkosipuli.localdomain>
References: <1305507806-10692-1-git-send-email-riverful.kim@samsung.com>
 <1305871017-22924-1-git-send-email-riverful.kim@samsung.com>
 <20110525135435.GA3547@valkosipuli.localdomain>
 <4DDDFD6F.9000601@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDDFD6F.9000601@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, May 26, 2011 at 04:12:47PM +0900, Kim, HeungJun wrote:
> Hi Sakari,

Hi HeungJun,

> 2011-05-25 ?????? 10:54, Sakari Ailus ??? ???:
> > Hi HeungJun,
> > 
> > Thanks for the patch!
> Also, thanks for the interests of this driver!

You'we welcome! :-)

> > 
> > I'm happy to see that Samsung is interested in getting such a driver to
> > mainline. :-) I suppose that theoretically nothing would prevent plugging
> > such a sensor to the OMAP 3 ISP, for example. It's just that the sensor
> > already does image processing and the ISP might not be that useful because
> > of this. But the interfaces would match, both in software and in hardware.
> This sensor(actually integrated ISP functionality as you know) is powerful,
> and I think this driver can help to make the controls for digital camera.
> 
> But, TI OMAP 3 has also ISP independently, so I think having the ISP module
> in the Processor is more better option cause of choice of various sensors,
> although the driver's developer has more issues which should be handled.
> 
> I hope to handle ISP directly in the Samsung Processor.
> 
> > 
> > This is a subdev driver and uses the control framework. Good. I have
> > comments on the code below. 
> Before that, this driver is already merged in Mauro's branch, and
> I have spent a few months making this drivers for submitting this.
> Some of your comments looks good and needed for this driver.
> But, if I fix this and resend it and another comments happened,
> this may be endless alone fight to reach "mergeing". :)

Sounds good to me. I have a few additional comments.

> So, I want that I keep this comments in mind, and I'll guarantee the fixes
> will be adapted the next time by type of the patch, after this driver patch
> is merged fully in 3.0.
[clip]

> >> +/**
> >> + * struct m5mols_version - firmware version information
> >> + * @customer:	customer information
> >> + * @project:	version of project information according to customer
> >> + * @fw:		firmware revision
> >> + * @hw:		hardware revision
> >> + * @param:	version of the parameter
> >> + * @awb:	Auto WhiteBalance algorithm version
> >> + * @str:	information about manufacturer and packaging vendor
> >> + * @af:		Auto Focus version
> >> + *
> >> + * The register offset starts the customer version at 0x0, and it ends
> >> + * the awb version at 0x09. The customer, project information occupies 1 bytes
> >> + * each. And also the fw, hw, param, awb each requires 2 bytes. The str is
> >> + * unique string associated with firmware's version. It includes information
> >> + * about manufacturer and the vendor of the sensor's packaging. The least
> >> + * significant 2 bytes of the string indicate packaging manufacturer.
> >> + */
> >> +#define VERSION_STRING_SIZE	22
> >> +struct m5mols_version {
> >> +	u8	customer;
> >> +	u8	project;
> >> +	u16	fw;
> >> +	u16	hw;
> >> +	u16	param;
> >> +	u16	awb;
> >> +	u8	str[VERSION_STRING_SIZE];
> >> +	u8	af;
> >> +};
> >> +#define VERSION_SIZE sizeof(struct m5mols_version)
> > 
> > You're using VERSION_SIZE in two places in one function. Is that worth
> > making it a macro? :-)
> Just make for being readable. Until this 9th version of this patch,
> I'm very taking care of over 80 character and for being readable.
> Updating each version, any other word is not used MACRO, and the other word
> need more space, on each line. At the next version, it happened that
> the one not used MACRO should use MACRO. And switching like this
> will be continued repedately.
> 
> So, I think it's no meaningless to use just twice. and want to fix.
> 
> And the other thing commented as belows, are most of same reason.

I'm fine with this.

> > 
> > I think you should add attribute ((packed)) to the definition as well.
> It looks needed. I added attibute packed for this struct for the next time.
> 
> > 
> >> +/**
> >> + * struct m5mols_info - M-5MOLS driver data structure
> >> + * @pdata: platform data
> >> + * @sd: v4l-subdev instance
> >> + * @pad: media pad
> >> + * @ffmt: current fmt according to resolution type
> >> + * @res_type: current resolution type
> >> + * @code: current code
> >> + * @irq_waitq: waitqueue for the capture
> >> + * @work_irq: workqueue for the IRQ
> >> + * @flags: state variable for the interrupt handler
> >> + * @handle: control handler
> >> + * @autoexposure: Auto Exposure control
> >> + * @exposure: Exposure control
> >> + * @autowb: Auto White Balance control
> >> + * @colorfx: Color effect control
> >> + * @saturation:	Saturation control
> >> + * @zoom: Zoom control
> >> + * @ver: information of the version
> >> + * @cap: the capture mode attributes
> >> + * @power: current sensor's power status
> >> + * @ctrl_sync: true means all controls of the sensor are initialized
> >> + * @int_capture: true means the capture interrupt is issued once
> >> + * @lock_ae: true means the Auto Exposure is locked
> >> + * @lock_awb: true means the Aut WhiteBalance is locked
> >> + * @resolution:	register value for current resolution
> >> + * @interrupt: register value for current interrupt status
> >> + * @mode: register value for current operation mode
> >> + * @mode_save: register value for current operation mode for saving
> >> + * @set_power: optional power callback to the board code
> >> + */
> >> +struct m5mols_info {
> >> +	const struct m5mols_platform_data *pdata;
> >> +	struct v4l2_subdev sd;
> >> +	struct media_pad pad;
> >> +	struct v4l2_mbus_framefmt ffmt[M5MOLS_RESTYPE_MAX];
> >> +	int res_type;
> >> +	enum v4l2_mbus_pixelcode code;
> >> +	wait_queue_head_t irq_waitq;
> >> +	struct work_struct work_irq;
> >> +	unsigned long flags;
> > 
> > You want to keep flags in the stack, not in a context independent location.
> > This will move to functions which actually use it.
> I don't understand well what you mean "stack" and "context". Sorry for lack of
> English skill. Tell me more specific detailed.

Please ignore my previous comment on this. In confused this with something
else.

> And as I tell about this variable "flags", this should be shared in the two files,
> m5mols_capture.c and m5mols_core.c. 
> 
> > 
> >> +
> >> +	struct v4l2_ctrl_handler handle;
> >> +	/* Autoexposure/exposure control cluster */
> >> +	struct {
> >> +		struct v4l2_ctrl *autoexposure;
> >> +		struct v4l2_ctrl *exposure;
> >> +	};
> > 
> > Would it be different without the anonymous struct?
> These two v4l2_ctrl is clustered. So, anonymous struct should be used
> for v4l2_ctrl_cluster().

It makes no difference in how the pointers are arranged in the memory.

[clip]

> >> +	[REG_SCENE_FIRE] = {
> >> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> >> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> >> +		REG_AF_NORMAL, REG_FD_OFF,
> >> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> >> +		6, REG_ISO_50, REG_CAP_NONE, REG_WDR_OFF,
> >> +	},
> >> +	[REG_SCENE_TEXT] = {
> >> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> >> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 7,
> >> +		REG_AF_MACRO, REG_FD_OFF,
> >> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> >> +		6, REG_ISO_AUTO, REG_CAP_ANTI_SHAKE, REG_WDR_ON,
> >> +	},
> >> +	[REG_SCENE_CANDLE] = {
> >> +		REG_AE_CENTER, REG_AE_INDEX_00, REG_AWB_AUTO, 0,
> >> +		REG_CHROMA_ON, 3, REG_EDGE_ON, 5,
> >> +		REG_AF_NORMAL, REG_FD_OFF,
> >> +		REG_MCC_OFF, REG_LIGHT_OFF, REG_FLASH_OFF,
> >> +		6, REG_ISO_AUTO, REG_CAP_NONE, REG_WDR_OFF,
> >> +	},
> > 
> > As it seems this functionality is dynamically configurable, and much of that
> > looks like something user space might want to choose independently,
> It's not. The preset itself can be user space APIs, but the order and procedure
> should be handled in the driver or kernel, at least in this case.
> 
> The wrong order and missing command are not completed the one of scenemode.
> 
> > shouldn't the underlying low level controls be exposed to user space as
> > such?
> > 
> > There definitely are different approaches to this; providing higher level
> > interface is restricting but on the other hand it may be better depending on
> > an application.
> > 
> > Some of these parameters would already have a V4L2 control for them.
> Actually, I have a plan to prepare RFC to expose some controls and
> things related with control timing. :)

I'm looking forward to this. Control timing is also something I'm interested
in.

> Briefly saying that, the current control framework can handle independently,
> but it's possible to handle any control attached the other control(s).
> So, some controls to supposed to be attached is combined with final specific control,
> or IOCTL, and if any specific control is called by user, the other controls
> is doing by orderly.
> 
> The benefit of such thing, is easy to handle controls in the user defined
> circumstance like camera, more user-friendly. And, at the kernel or driver side,
> it's supported only things which the device proivde.
> The driver's code will be simple and the user is happy.
> 
> Anyway, this is not part of this story, so let's talk about this later.

[clip]

> >> diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
> >> new file mode 100644
> >> index 0000000..76eac26
> >> --- /dev/null
> >> +++ b/drivers/media/video/m5mols/m5mols_core.c
> >> @@ -0,0 +1,1004 @@
> >> +/*
> >> + * Driver for M-5MOLS 8M Pixel camera sensor with ISP
> >> + *
> >> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> >> + * Author: HeungJun Kim, riverful.kim@samsung.com
> >> + *
> >> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> >> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + */
> >> +
> >> +#include <linux/i2c.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/irq.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/version.h>
> >> +#include <linux/gpio.h>
> >> +#include <linux/regulator/consumer.h>
> >> +#include <linux/videodev2.h>
> >> +#include <media/v4l2-ctrls.h>
> >> +#include <media/v4l2-device.h>
> >> +#include <media/v4l2-subdev.h>
> >> +#include <media/m5mols.h>
> >> +
> >> +#include "m5mols.h"
> >> +#include "m5mols_reg.h"
> >> +
> >> +int m5mols_debug;
> >> +module_param(m5mols_debug, int, 0644);
> >> +
> >> +#define MODULE_NAME		"M5MOLS"
> >> +#define M5MOLS_I2C_CHECK_RETRY	500
> >> +
> >> +/* The regulator consumer names for external voltage regulators */
> >> +static struct regulator_bulk_data supplies[] = {
> >> +	{
> >> +		.supply = "core",	/* ARM core power, 1.2V */
> >> +	}, {
> >> +		.supply	= "dig_18",	/* digital power 1, 1.8V */
> >> +	}, {
> >> +		.supply	= "d_sensor",	/* sensor power 1, 1.8V */
> >> +	}, {
> >> +		.supply	= "dig_28",	/* digital power 2, 2.8V */
> >> +	}, {
> >> +		.supply	= "a_sensor",	/* analog power */
> >> +	}, {
> >> +		.supply	= "dig_12",	/* digital power 3, 1.2V */
> >> +	},
> >> +};
> > 
> > This looks like something that belongs to board code, or perhaps in the near
> > future, to the device tree. The power supplies that are required by a device
> > is highly board dependent.
> If the regulator name is not common all M-5MOLS, You're right.
> But the regulator name of M-5MOLS is fixed.

As far as I understand, M-5MOLS is a sensor which you can, in principle,
attach to more or less random hardware. The regulators are not part of the
sensor. If someone adds a board which has regulators names or otherwise
arranged differently, this change must be done at that time.

> The benefit fixed in the driver helps that the developer can attach the driver,
> if he/she knows the names of regulators.
> 
> Commonly, you're right, but in this case(documented accurately with M-5MOLS
> datasheet), it's better.
>  
[clip]

> >> +int m5mols_write(struct v4l2_subdev *sd, u32 reg, u32 val)
> >> +{
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +	u8 wbuf[M5MOLS_I2C_MAX_SIZE + 4];
> >> +	u8 category = I2C_CATEGORY(reg);
> >> +	u8 cmd = I2C_COMMAND(reg);
> >> +	u8 size	= I2C_SIZE(reg);
> >> +	u32 *buf = (u32 *)&wbuf[4];
> >> +	struct i2c_msg msg[1];
> >> +	int ret;
> >> +
> >> +	if (!client->adapter)
> >> +		return -ENODEV;
> >> +
> >> +	if (size != 1 && size != 2 && size != 4) {
> > 
> > You could define sizes for the types, e.g.
> > 
> > #define I2C_SIZE_U8	1
> I already try to do like this, using width as definition.
> But it makes many lines over 80 characters. Moreover, using just number
> is more simple in this case.

Wrapping lines is also possible but sometimes it's just better not to.

> Ditto - over 80 characters.
> 
> > 
> >> +		v4l2_err(sd, "Wrong data size\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	msg->addr = client->addr;
> >> +	msg->flags = 0;
> >> +	msg->len = (u16)size + 4;
> >> +	msg->buf = wbuf;
> >> +	wbuf[0] = size + 4;
> >> +	wbuf[1] = M5MOLS_BYTE_WRITE;
> >> +	wbuf[2] = category;
> >> +	wbuf[3] = cmd;
> >> +
> >> +	*buf = m5mols_swap_byte((u8 *)&val, size);
> >> +
> >> +	usleep_range(200, 200);
> > 
> > Why to sleep always? Does the sensor require a delay between each I2C
> > access?
> It's experimental values. The M-5MOLS I2C communication is a litte sensitive,
> and I expect that this sensor is integrated with another ARM-core and internal
> Firmware, and ARM-core's performance is not good. So, the dealy should be needed.

Perhaps a comment telling this would be good?

> 
> > 
> >> +	ret = i2c_transfer(client->adapter, msg, 1);
> >> +	if (ret < 0) {
> >> +		v4l2_err(sd, "write failed: size:%d cat:%02x cmd:%02x. %d\n",
> >> +			size, category, cmd, ret);
> >> +		return ret;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +int m5mols_busy(struct v4l2_subdev *sd, u8 category, u8 cmd, u32 mask)
> >> +{
> >> +	u32 busy, i;
> >> +	int ret;
> >> +
> >> +	for (i = 0; i < M5MOLS_I2C_CHECK_RETRY; i++) {
> >> +		ret = m5mols_read(sd, I2C_REG(category, cmd, 1), &busy);
> >> +		if (ret < 0)
> >> +			return ret;
> >> +		if ((busy & mask) == mask)
> >> +			return 0;
> >> +	}
> >> +	return -EBUSY;
> >> +}
> >> +
> >> +/**
> >> + * m5mols_enable_interrupt - Clear interrupt pending bits and unmask interrupts
> >> + *
> >> + * Before writing desired interrupt value the INT_FACTOR register should
> >> + * be read to clear pending interrupts.
> >> + */
> >> +int m5mols_enable_interrupt(struct v4l2_subdev *sd, u32 reg)
> >> +{
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +	u32 mask = is_available_af(info) ? REG_INT_AF : 0;
> >> +	u32 dummy;
> >> +	int ret;
> >> +
> >> +	ret = m5mols_read(sd, SYSTEM_INT_FACTOR, &dummy);
> >> +	if (!ret)
> >> +		ret = m5mols_write(sd, SYSTEM_INT_ENABLE, reg & ~mask);
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * m5mols_reg_mode - Write the mode and check busy status
> >> + *
> >> + * It always accompanies a little delay changing the M-5MOLS mode, so it is
> >> + * needed checking current busy status to guarantee right mode.
> >> + */
> >> +static int m5mols_reg_mode(struct v4l2_subdev *sd, u32 mode)
> >> +{
> >> +	int ret = m5mols_write(sd, SYSTEM_SYSMODE, mode);
> >> +
> >> +	return ret ? ret : m5mols_busy(sd, CAT_SYSTEM, CAT0_SYSMODE, mode);
> >> +}
> >> +
> >> +/**
> >> + * m5mols_mode - manage the M-5MOLS's mode
> >> + * @mode: the required operation mode
> >> + *
> >> + * The commands of M-5MOLS are grouped into specific modes. Each functionality
> >> + * can be guaranteed only when the sensor is operating in mode which which
> >> + * a command belongs to.
> >> + */
> >> +int m5mols_mode(struct m5mols_info *info, u32 mode)
> >> +{
> >> +	struct v4l2_subdev *sd = &info->sd;
> >> +	int ret = -EINVAL;
> >> +	u32 reg;
> >> +
> >> +	if (mode < REG_PARAMETER && mode > REG_CAPTURE)
> >> +		return ret;
> >> +
> >> +	ret = m5mols_read(sd, SYSTEM_SYSMODE, &reg);
> >> +	if ((!ret && reg == mode) || ret)
> >> +		return ret;
> >> +
> >> +	switch (reg) {
> >> +	case REG_PARAMETER:
> >> +		ret = m5mols_reg_mode(sd, REG_MONITOR);
> >> +		if (!ret && mode == REG_MONITOR)
> >> +			break;
> >> +		if (!ret)
> >> +			ret = m5mols_reg_mode(sd, REG_CAPTURE);
> >> +		break;
> >> +
> >> +	case REG_MONITOR:
> >> +		if (mode == REG_PARAMETER) {
> >> +			ret = m5mols_reg_mode(sd, REG_PARAMETER);
> >> +			break;
> >> +		}
> >> +
> >> +		ret = m5mols_reg_mode(sd, REG_CAPTURE);
> >> +		break;
> >> +
> >> +	case REG_CAPTURE:
> >> +		ret = m5mols_reg_mode(sd, REG_MONITOR);
> >> +		if (!ret && mode == REG_MONITOR)
> >> +			break;
> >> +		if (!ret)
> >> +			ret = m5mols_reg_mode(sd, REG_PARAMETER);
> >> +		break;
> >> +
> >> +	default:
> >> +		v4l2_warn(sd, "Wrong mode: %d\n", mode);
> >> +	}
> >> +
> >> +	if (!ret)
> >> +		info->mode = mode;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * m5mols_get_version - retrieve full revisions information of M-5MOLS
> >> + *
> >> + * The version information includes revisions of hardware and firmware,
> >> + * AutoFocus alghorithm version and the version string.
> >> + */
> >> +static int m5mols_get_version(struct v4l2_subdev *sd)
> >> +{
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +	union {
> >> +		struct m5mols_version ver;
> >> +		u8 bytes[VERSION_SIZE];
> > 
> > You could even use u8 bytes[0] if you really need this union.
> > 
> > ((char *)&ver)[cmd], for example.
> > 
> >> +	} version;
> >> +	u32 *value;
> >> +	u8 cmd = CAT0_VER_CUSTOMER;
> >> +	int ret;
> >> +
> >> +	do {
> >> +		value = (u32 *)&version.bytes[cmd];
> >> +		ret = m5mols_read(sd, SYSTEM_CMD(cmd), value);
> >> +		if (ret)
> >> +			return ret;
> >> +	} while (cmd++ != CAT0_VER_AWB);
> >> +
> >> +	do {
> >> +		value = (u32 *)&version.bytes[cmd];
> >> +		ret = m5mols_read(sd, SYSTEM_VER_STRING, value);
> >> +		if (ret)
> >> +			return ret;
> >> +		if (cmd >= VERSION_SIZE - 1)
> >> +			return -EINVAL;
> >> +	} while (version.bytes[cmd++]);
> > 
> > 
> > Please move cmd++ outside the condition.
> Ok, I'll keep that.
> 
> > 
> > I think you should have a different function to read and write different
> > types, e.g. m5mols_read_u8 and m5mols_read_u16.
> As I said, this is good option and it will be changed like your recommendation.
> I very consider this usage at the next time.
> 
> > 
> > You have the access width encoded in the register value. That would still be
> > checked by the function.
> > 
> > You also could subtract CAT0_VER_CUSTOMER from cmd when using it as index
> > to bytes[] above, as you now rely that it is actually zero.
> > 
> >> +
> >> +	value = (u32 *)&version.bytes[cmd];
> >> +	ret = m5mols_read(sd, AF_VERSION, value);
> > 
> > I think it'd be cleaner to refer to (u32 *)&version.bytes[cmd] directly
> > instead of using value.
> > 
> > Can you be sure that cmd points to the AF version here?
> > 
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	/* store version information swapped for being readable */
> >> +	info->ver	= version.ver;
> > 
> > You could use info->ver straight away and drop version.ver.
> Ok, but this is also making me hard. It's been always stucked by over 80 character.
> And, I choose this the best.
> But, another option is appeared, I'll consider this again.
> 
> > 
> >> +	info->ver.fw	= be16_to_cpu(info->ver.fw);
> >> +	info->ver.hw	= be16_to_cpu(info->ver.hw);
> >> +	info->ver.param	= be16_to_cpu(info->ver.param);
> >> +	info->ver.awb	= be16_to_cpu(info->ver.awb);
> >> +
> >> +	v4l2_info(sd, "Manufacturer\t[%s]\n",
> >> +			is_manufacturer(info, REG_SAMSUNG_ELECTRO) ?
> >> +			"Samsung Electro-Machanics" :
> >> +			is_manufacturer(info, REG_SAMSUNG_OPTICS) ?
> >> +			"Samsung Fiber-Optics" :
> >> +			is_manufacturer(info, REG_SAMSUNG_TECHWIN) ?
> >> +			"Samsung Techwin" : "None");
> >> +	v4l2_info(sd, "Customer/Project\t[0x%02x/0x%02x]\n",
> >> +			info->ver.customer, info->ver.project);
> >> +
> >> +	if (!is_available_af(info))
> >> +		v4l2_info(sd, "No support Auto Focus on this firmware\n");
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * __find_restype - Lookup M-5MOLS resolution type according to pixel code
> >> + * @code: pixel code
> >> + */
> >> +static enum m5mols_restype __find_restype(enum v4l2_mbus_pixelcode code)
> >> +{
> >> +	enum m5mols_restype type = M5MOLS_RESTYPE_MONITOR;
> >> +
> >> +	do {
> >> +		if (code == m5mols_default_ffmt[type].code)
> >> +			return type;
> > 
> > type++ here, and ++ off of the condition below.
> Ok, I'll adapt this for the next time.
> 
> > 
> >> +	} while (type++ != SIZE_DEFAULT_FFMT);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * __find_resolution - Lookup preset and type of M-5MOLS's resolution
> >> + * @mf: pixel format to find/negotiate the resolution preset for
> >> + * @type: M-5MOLS resolution type
> >> + * @resolution:	M-5MOLS resolution preset register value
> >> + *
> >> + * Find nearest resolution matching resolution preset and adjust mf
> >> + * to supported values.
> >> + */
> >> +static int __find_resolution(struct v4l2_subdev *sd,
> >> +			     struct v4l2_mbus_framefmt *mf,
> >> +			     enum m5mols_restype *type,
> >> +			     u32 *resolution)
> >> +{
> >> +	const struct m5mols_resolution *fsize = &m5mols_reg_res[0];
> >> +	const struct m5mols_resolution *match = NULL;
> >> +	enum m5mols_restype stype = __find_restype(mf->code);
> >> +	int i = ARRAY_SIZE(m5mols_reg_res);
> >> +	unsigned int min_err = ~0;
> >> +
> >> +	while (i--) {
> >> +		int err;
> >> +		if (stype == fsize->type) {
> >> +			err = abs(fsize->width - mf->width)
> >> +				+ abs(fsize->height - mf->height);
> >> +
> >> +			if (err < min_err) {
> >> +				min_err = err;
> >> +				match = fsize;
> >> +			}
> >> +		}
> >> +		fsize++;
> >> +	}
> >> +	if (match) {
> >> +		mf->width  = match->width;
> >> +		mf->height = match->height;
> >> +		*resolution = match->reg;
> >> +		*type = stype;
> >> +		return 0;
> >> +	}
> >> +
> >> +	return -EINVAL;
> >> +}
> >> +
> >> +static struct v4l2_mbus_framefmt *__find_format(struct m5mols_info *info,
> >> +				struct v4l2_subdev_fh *fh,
> >> +				enum v4l2_subdev_format_whence which,
> >> +				enum m5mols_restype type)
> >> +{
> >> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> >> +		return fh ? v4l2_subdev_get_try_format(fh, 0) : NULL;
> >> +
> >> +	return &info->ffmt[type];
> >> +}
> >> +
> >> +static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> >> +			  struct v4l2_subdev_format *fmt)
> >> +{
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +	struct v4l2_mbus_framefmt *format;
> >> +
> >> +	if (fmt->pad != 0)
> >> +		return -EINVAL;
> >> +
> >> +	format = __find_format(info, fh, fmt->which, info->res_type);
> >> +	if (!format)
> >> +		return -EINVAL;
> >> +
> >> +	fmt->format = *format;
> >> +	return 0;
> >> +}
> >> +
> >> +static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> >> +			  struct v4l2_subdev_format *fmt)
> >> +{
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +	struct v4l2_mbus_framefmt *format = &fmt->format;
> >> +	struct v4l2_mbus_framefmt *sfmt;
> >> +	enum m5mols_restype type;
> >> +	u32 resolution = 0;
> >> +	int ret;
> >> +
> >> +	if (fmt->pad != 0)
> >> +		return -EINVAL;
> >> +
> >> +	ret = __find_resolution(sd, format, &type, &resolution);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	sfmt = __find_format(info, fh, fmt->which, type);
> >> +	if (!sfmt)
> >> +		return 0;
> >> +
> >> +	*sfmt		= m5mols_default_ffmt[type];
> >> +	sfmt->width	= format->width;
> >> +	sfmt->height	= format->height;
> >> +
> >> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> >> +		info->resolution = resolution;
> >> +		info->code = format->code;
> >> +		info->res_type = type;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
> >> +				 struct v4l2_subdev_fh *fh,
> >> +				 struct v4l2_subdev_mbus_code_enum *code)
> >> +{
> >> +	ifv (!code || code->index >= SIZE_DEFAULT_FFMT)
> > 
> > Is it possible that code == NULL?
> It depends on the driver using this subdev driver. 
> The test have done on the s5p-fimc driver for now, but I don't have
> any trouble cause of code == NULL.
> 
> But, probably the code can get through by userspace, so it should be
> needed I guess.

The contents are from user space but the pointer is not. No need to check
for NULL. See subdev_do_ioctl() in v4l2-subdev.c.

[clip]
> > 
> >> +		return -EINVAL;
> >> +
> >> +	code->code = m5mols_default_ffmt[code->index].code;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
> >> +	.enum_mbus_code	= m5mols_enum_mbus_code,
> >> +	.get_fmt	= m5mols_get_fmt,
> >> +	.set_fmt	= m5mols_set_fmt,
> >> +};
> >> +
> >> +/**
> >> + * m5mols_sync_controls - Apply default scene mode and the current controls
> >> + *
> >> + * This is used only streaming for syncing between v4l2_ctrl framework and
> >> + * m5mols's controls. First, do the scenemode to the sensor, then call
> >> + * v4l2_ctrl_handler_setup. It can be same between some commands and
> >> + * the scenemode's in the default v4l2_ctrls. But, such commands of control
> >> + * should be prior to the scenemode's one.
> >> + */
> >> +int m5mols_sync_controls(struct m5mols_info *info)
> >> +{
> >> +	int ret = -EINVAL;
> >> +
> >> +	if (!is_ctrl_synced(info)) {
> >> +		ret = m5mols_do_scenemode(info, REG_SCENE_NORMAL);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >> +		v4l2_ctrl_handler_setup(&info->handle);
> >> +		info->ctrl_sync = true;
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * m5mols_start_monitor - Start the monitor mode
> >> + *
> >> + * Before applying the controls setup the resolution and frame rate
> >> + * in PARAMETER mode, and then switch over to MONITOR mode.
> >> + */
> >> +static int m5mols_start_monitor(struct m5mols_info *info)
> >> +{
> >> +	struct v4l2_subdev *sd = &info->sd;
> >> +	int ret;
> >> +
> >> +	ret = m5mols_mode(info, REG_PARAMETER);
> >> +	if (!ret)
> >> +		ret = m5mols_write(sd, PARM_MON_SIZE, info->resolution);
> >> +	if (!ret)
> >> +		ret = m5mols_write(sd, PARM_MON_FPS, REG_FPS_30);
> >> +	if (!ret)
> >> +		ret = m5mols_mode(info, REG_MONITOR);
> >> +	if (!ret)
> >> +		ret = m5mols_sync_controls(info);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
> >> +{
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +
> >> +	if (enable) {
> >> +		int ret = -EINVAL;
> >> +
> >> +		if (is_code(info->code, M5MOLS_RESTYPE_MONITOR))
> >> +			ret = m5mols_start_monitor(info);
> >> +		if (is_code(info->code, M5MOLS_RESTYPE_CAPTURE))
> >> +			ret = m5mols_start_capture(info);
> >> +
> >> +		return ret;
> >> +	}
> >> +
> >> +	return m5mols_mode(info, REG_PARAMETER);
> >> +}
> >> +
> >> +static const struct v4l2_subdev_video_ops m5mols_video_ops = {
> >> +	.s_stream	= m5mols_s_stream,
> >> +};
> >> +
> >> +static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
> >> +{
> >> +	struct v4l2_subdev *sd = to_sd(ctrl);
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +	int ret;
> >> +
> >> +	info->mode_save = info->mode;
> >> +
> >> +	ret = m5mols_mode(info, REG_PARAMETER);
> >> +	if (!ret)
> >> +		ret = m5mols_set_ctrl(ctrl);
> >> +	if (!ret)
> >> +		ret = m5mols_mode(info, info->mode_save);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {
> >> +	.s_ctrl	= m5mols_s_ctrl,
> >> +};
> >> +
> >> +static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
> >> +{
> >> +	struct v4l2_subdev *sd = &info->sd;
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +	const struct m5mols_platform_data *pdata = info->pdata;
> >> +	int ret;
> >> +
> >> +	if (enable) {
> >> +		if (is_powered(info))
> >> +			return 0;
> >> +
> >> +		if (info->set_power) {
> >> +			ret = info->set_power(&client->dev, 1);
> >> +			if (ret)
> >> +				return ret;
> >> +		}
> >> +
> >> +		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
> >> +		if (ret) {
> >> +			info->set_power(&client->dev, 0);
> >> +			return ret;
> >> +		}
> >> +
> >> +		gpio_set_value(pdata->gpio_reset, !pdata->reset_polarity);
> >> +		usleep_range(1000, 1000);
> >> +		info->power = true;
> >> +
> >> +		return ret;
> >> +	}
> >> +
> >> +	if (!is_powered(info))
> >> +		return 0;
> >> +
> >> +	ret = regulator_bulk_disable(ARRAY_SIZE(supplies), supplies);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	if (info->set_power)
> >> +		info->set_power(&client->dev, 0);
> >> +
> >> +	gpio_set_value(pdata->gpio_reset, pdata->reset_polarity);
> >> +	usleep_range(1000, 1000);
> >> +	info->power = false;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/* m5mols_update_fw - optional firmware update routine */
> >> +int __attribute__ ((weak)) m5mols_update_fw(struct v4l2_subdev *sd,
> >> +		int (*set_power)(struct m5mols_info *, bool))
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * m5mols_sensor_armboot - Booting M-5MOLS internal ARM core.
> >> + *
> >> + * Booting internal ARM core makes the M-5MOLS is ready for getting commands
> >> + * with I2C. It's the first thing to be done after it powered up. It must wait
> >> + * at least 520ms recommended by M-5MOLS datasheet, after executing arm booting.
> >> + */
> >> +static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = m5mols_write(sd, FLASH_CAM_START, REG_START_ARM_BOOT);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	msleep(520);
> >> +
> >> +	ret = m5mols_get_version(sd);
> >> +	if (!ret)
> >> +		ret = m5mols_update_fw(sd, m5mols_sensor_power);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	v4l2_dbg(1, m5mols_debug, sd, "Success ARM Booting\n");
> >> +
> >> +	ret = m5mols_write(sd, PARM_INTERFACE, REG_INTERFACE_MIPI);
> >> +	if (!ret)
> >> +		ret = m5mols_enable_interrupt(sd, REG_INT_AF);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int m5mols_init_controls(struct m5mols_info *info)
> >> +{
> >> +	struct v4l2_subdev *sd = &info->sd;
> >> +	u16 max_exposure;
> >> +	u16 step_zoom;
> >> +	int ret;
> >> +
> >> +	/* Determine value's range & step of controls for various FW version */
> >> +	ret = m5mols_read(sd, AE_MAX_GAIN_MON, (u32 *)&max_exposure);
> >> +	if (!ret)
> >> +		step_zoom = is_manufacturer(info, REG_SAMSUNG_OPTICS) ? 31 : 1;
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	v4l2_ctrl_handler_init(&info->handle, 6);
> >> +	info->autowb = v4l2_ctrl_new_std(&info->handle,
> >> +			&m5mols_ctrl_ops, V4L2_CID_AUTO_WHITE_BALANCE,
> >> +			0, 1, 1, 0);
> >> +	info->saturation = v4l2_ctrl_new_std(&info->handle,
> >> +			&m5mols_ctrl_ops, V4L2_CID_SATURATION,
> >> +			1, 5, 1, 3);
> >> +	info->zoom = v4l2_ctrl_new_std(&info->handle,
> >> +			&m5mols_ctrl_ops, V4L2_CID_ZOOM_ABSOLUTE,
> >> +			1, 70, step_zoom, 1);
> >> +	info->exposure = v4l2_ctrl_new_std(&info->handle,
> >> +			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE,
> >> +			0, max_exposure, 1, (int)max_exposure/2);
> >> +	info->colorfx = v4l2_ctrl_new_std_menu(&info->handle,
> >> +			&m5mols_ctrl_ops, V4L2_CID_COLORFX,
> >> +			4, (1 << V4L2_COLORFX_BW), V4L2_COLORFX_NONE);
> >> +	info->autoexposure = v4l2_ctrl_new_std_menu(&info->handle,
> >> +			&m5mols_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
> >> +			1, 0, V4L2_EXPOSURE_MANUAL);
> >> +
> >> +	sd->ctrl_handler = &info->handle;
> >> +	if (info->handle.error) {
> >> +		v4l2_err(sd, "Failed to initialize controls: %d\n", ret);
> >> +		v4l2_ctrl_handler_free(&info->handle);
> >> +		return info->handle.error;
> >> +	}
> >> +
> >> +	v4l2_ctrl_cluster(2, &info->autoexposure);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * m5mols_s_power - Main sensor power control function
> >> + *
> >> + * To prevent breaking the lens when the sensor is powered off the Soft-Landing
> >> + * algorithm is called where available. The Soft-Landing algorithm availability
> >> + * dependends on the firmware provider.
> >> + */
> >> +static int m5mols_s_power(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +	int ret;
> >> +
> >> +	if (on) {
> >> +		ret = m5mols_sensor_power(info, true);
> >> +		if (!ret)
> >> +			ret = m5mols_sensor_armboot(sd);
> >> +		if (!ret)
> >> +			ret = m5mols_init_controls(info);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >> +		info->ffmt[M5MOLS_RESTYPE_MONITOR] =
> >> +			m5mols_default_ffmt[M5MOLS_RESTYPE_MONITOR];
> >> +		info->ffmt[M5MOLS_RESTYPE_CAPTURE] =
> >> +			m5mols_default_ffmt[M5MOLS_RESTYPE_CAPTURE];
> >> +		return ret;
> >> +	}
> >> +
> >> +	if (is_manufacturer(info, REG_SAMSUNG_TECHWIN)) {
> >> +		ret = m5mols_mode(info, REG_MONITOR);
> >> +		if (!ret)
> >> +			ret = m5mols_write(sd, AF_EXECUTE, REG_AF_STOP);
> >> +		if (!ret)
> >> +			ret = m5mols_write(sd, AF_MODE, REG_AF_POWEROFF);
> >> +		if (!ret)
> >> +			ret = m5mols_busy(sd, CAT_SYSTEM, CAT0_STATUS,
> >> +					REG_AF_IDLE);
> >> +		if (!ret)
> >> +			v4l2_info(sd, "Success soft-landing lens\n");
> >> +	}
> >> +
> >> +	ret = m5mols_sensor_power(info, false);
> >> +	if (!ret) {
> >> +		v4l2_ctrl_handler_free(&info->handle);
> >> +		info->ctrl_sync = false;
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int m5mols_log_status(struct v4l2_subdev *sd)
> >> +{
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +
> >> +	v4l2_ctrl_handler_log_status(&info->handle, sd->name);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct v4l2_subdev_core_ops m5mols_core_ops = {
> >> +	.s_power	= m5mols_s_power,
> >> +	.g_ctrl		= v4l2_subdev_g_ctrl,
> >> +	.s_ctrl		= v4l2_subdev_s_ctrl,
> >> +	.queryctrl	= v4l2_subdev_queryctrl,
> >> +	.querymenu	= v4l2_subdev_querymenu,
> >> +	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
> >> +	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
> >> +	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
> >> +	.log_status	= m5mols_log_status,
> >> +};
> >> +
> >> +static const struct v4l2_subdev_ops m5mols_ops = {
> >> +	.core		= &m5mols_core_ops,
> >> +	.pad		= &m5mols_pad_ops,
> >> +	.video		= &m5mols_video_ops,
> >> +};
> >> +
> >> +static void m5mols_irq_work(struct work_struct *work)
> >> +{
> >> +	struct m5mols_info *info =
> >> +		container_of(work, struct m5mols_info, work_irq);
> >> +	struct v4l2_subdev *sd = &info->sd;
> >> +	u32 reg;
> >> +	int ret;
> >> +
> >> +	if (!is_powered(info) ||
> >> +			m5mols_read(sd, SYSTEM_INT_FACTOR, &info->interrupt))
> >> +		return;
> >> +
> >> +	switch (info->interrupt & REG_INT_MASK) {
> >> +	case REG_INT_AF:
> >> +		if (!is_available_af(info))
> >> +			break;
> >> +		ret = m5mols_read(sd, AF_STATUS, &reg);
> >> +		v4l2_dbg(2, m5mols_debug, sd, "AF %s\n",
> >> +			 reg == REG_AF_FAIL ? "Failed" :
> >> +			 reg == REG_AF_SUCCESS ? "Success" :
> >> +			 reg == REG_AF_IDLE ? "Idle" : "Busy");
> >> +		break;
> >> +	case REG_INT_CAPTURE:
> >> +		if (!test_and_set_bit(ST_CAPT_IRQ, &info->flags))
> >> +			wake_up_interruptible(&info->irq_waitq);
> >> +
> >> +		v4l2_dbg(2, m5mols_debug, sd, "CAPTURE\n");
> >> +		break;
> >> +	default:
> >> +		v4l2_dbg(2, m5mols_debug, sd, "Undefined: %02x\n", reg);
> >> +		break;
> >> +	};
> >> +}
> >> +
> >> +static irqreturn_t m5mols_irq_handler(int irq, void *data)
> >> +{
> >> +	struct v4l2_subdev *sd = data;
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +
> >> +	schedule_work(&info->work_irq);
> >> +
> >> +	return IRQ_HANDLED;
> >> +}
> >> +
> >> +static int __devinit m5mols_probe(struct i2c_client *client,
> >> +				  const struct i2c_device_id *id)
> >> +{
> >> +	const struct m5mols_platform_data *pdata = client->dev.platform_data;
> >> +	struct m5mols_info *info;
> >> +	struct v4l2_subdev *sd;
> >> +	int ret;
> >> +
> >> +	if (pdata == NULL) {
> >> +		dev_err(&client->dev, "No platform data\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	if (!gpio_is_valid(pdata->gpio_reset)) {
> >> +		dev_err(&client->dev, "No valid RESET GPIO specified\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	if (!pdata->irq) {
> >> +		dev_err(&client->dev, "Interrupt not assigned\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	info = kzalloc(sizeof(struct m5mols_info), GFP_KERNEL);
> >> +	if (!info)
> >> +		return -ENOMEM;
> >> +
> >> +	info->pdata = pdata;
> >> +	info->set_power	= pdata->set_power;
> >> +
> >> +	ret = gpio_request(pdata->gpio_reset, "M5MOLS_NRST");
> >> +	if (ret) {
> >> +		dev_err(&client->dev, "Failed to request gpio: %d\n", ret);
> >> +		goto out_free;
> >> +	}
> >> +	gpio_direction_output(pdata->gpio_reset, pdata->reset_polarity);
> >> +
> >> +	ret = regulator_bulk_get(&client->dev, ARRAY_SIZE(supplies), supplies);
> >> +	if (ret) {
> >> +		dev_err(&client->dev, "Failed to get regulators: %d\n", ret);
> >> +		goto out_gpio;
> >> +	}
> >> +
> >> +	sd = &info->sd;
> >> +	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> >> +	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
> >> +
> >> +	info->pad.flags = MEDIA_PAD_FL_SOURCE;
> >> +	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
> >> +	if (ret < 0)
> >> +		goto out_reg;
> >> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> >> +
> >> +	init_waitqueue_head(&info->irq_waitq);
> >> +	INIT_WORK(&info->work_irq, m5mols_irq_work);
> >> +	ret = request_irq(pdata->irq, m5mols_irq_handler,
> >> +			  IRQF_TRIGGER_RISING, MODULE_NAME, sd);
> >> +	if (ret) {
> >> +		dev_err(&client->dev, "Interrupt request failed: %d\n", ret);
> >> +		goto out_me;
> >> +	}
> >> +	info->res_type = M5MOLS_RESTYPE_MONITOR;
> >> +	return 0;
> >> +out_me:
> >> +	media_entity_cleanup(&sd->entity);
> >> +out_reg:
> >> +	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
> >> +out_gpio:
> >> +	gpio_free(pdata->gpio_reset);
> >> +out_free:
> >> +	kfree(info);
> >> +	return ret;
> >> +}
> >> +
> >> +static int __devexit m5mols_remove(struct i2c_client *client)
> >> +{
> >> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> +	struct m5mols_info *info = to_m5mols(sd);
> >> +
> >> +	v4l2_device_unregister_subdev(sd);
> >> +	free_irq(info->pdata->irq, sd);
> >> +
> >> +	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
> >> +	gpio_free(info->pdata->gpio_reset);
> >> +	media_entity_cleanup(&sd->entity);
> >> +	kfree(info);
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct i2c_device_id m5mols_id[] = {
> >> +	{ MODULE_NAME, 0 },
> >> +	{ },
> >> +};
> >> +MODULE_DEVICE_TABLE(i2c, m5mols_id);
> >> +
> >> +static struct i2c_driver m5mols_i2c_driver = {
> >> +	.driver = {
> >> +		.name	= MODULE_NAME,
> >> +	},
> >> +	.probe		= m5mols_probe,
> >> +	.remove		= __devexit_p(m5mols_remove),
> >> +	.id_table	= m5mols_id,
> >> +};
> >> +
> >> +static int __init m5mols_mod_init(void)
> >> +{
> >> +	return i2c_add_driver(&m5mols_i2c_driver);
> >> +}
> >> +
> >> +static void __exit m5mols_mod_exit(void)
> >> +{
> >> +	i2c_del_driver(&m5mols_i2c_driver);
> >> +}
> >> +
> >> +module_init(m5mols_mod_init);
> >> +module_exit(m5mols_mod_exit);
> >> +
> >> +MODULE_AUTHOR("HeungJun Kim <riverful.kim@samsung.com>");
> >> +MODULE_AUTHOR("Dongsoo Kim <dongsoo45.kim@samsung.com>");
> >> +MODULE_DESCRIPTION("Fujitsu M-5MOLS 8M Pixel camera driver");
> >> +MODULE_LICENSE("GPL");
> >> diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
> >> new file mode 100644
> >> index 0000000..b83e36f
> >> --- /dev/null
> >> +++ b/drivers/media/video/m5mols/m5mols_reg.h
> >> @@ -0,0 +1,399 @@
> >> +/*
> >> + * Register map for M-5MOLS 8M Pixel camera sensor with ISP
> >> + *
> >> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
> >> + * Author: HeungJun Kim, riverful.kim@samsung.com
> >> + *
> >> + * Copyright (C) 2009 Samsung Electronics Co., Ltd.
> >> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + */
> >> +
> >> +#ifndef M5MOLS_REG_H
> >> +#define M5MOLS_REG_H
> >> +
> >> +#define M5MOLS_I2C_MAX_SIZE	4
> >> +#define M5MOLS_BYTE_READ	0x01
> >> +#define M5MOLS_BYTE_WRITE	0x02
> >> +
> >> +#define I2C_CATEGORY(__cat)		((__cat >> 16) & 0xff)
> >> +#define I2C_COMMAND(__comm)		((__comm >> 8) & 0xff)
> >> +#define I2C_SIZE(__reg_s)		((__reg_s) & 0xff)
> > 
> > I would put category and command to lower 16 bits and size in the upper 16
> > bits, but this is up to you. I think this would improve readability.
> OK. I would deeply consider that :-)
> 
> > 
> >> +#define I2C_REG(__cat, __cmd, __reg_s)	((__cat << 16) | (__cmd << 8) | __reg_s)
> >> +
> >> +/*
> >> + * Category section register
> >> + *
> >> + * The category means set including relevant command of M-5MOLS.
> >> + */
> >> +#define CAT_SYSTEM		0x00
> >> +#define CAT_PARAM		0x01
> >> +#define CAT_MONITOR		0x02
> >> +#define CAT_AE			0x03
> >> +#define CAT_WB			0x06
> >> +#define CAT_EXIF		0x07
> >> +#define CAT_FD			0x09
> >> +#define CAT_LENS		0x0a
> >> +#define CAT_CAPT_PARM		0x0b
> >> +#define CAT_CAPT_CTRL		0x0c
> >> +#define CAT_FLASH		0x0f	/* related to FW, revisions, booting */
> > 
> > What about defining registers so that the category is part of the register
> > address? This is actually how it's in the address space as well.
> > 
> >> +
> >> +/*
> >> + * Category 0 - SYSTEM mode
> >> + *
> >> + * The SYSTEM mode in the M-5MOLS means area available to handle with the whole
> >> + * & all-round system of sensor. It deals with version/interrupt/setting mode &
> >> + * even sensor's status. Especially, the M-5MOLS sensor with ISP varies by
> >> + * packaging & manufacturer, even the customer and project code. And the
> >> + * function details may vary among them. The version information helps to
> >> + * determine what methods shall be used in the driver.
> >> + *
> >> + * There is many registers between customer version address and awb one. For
> >> + * more specific contents, see definition if file m5mols.h.
> >> + */
> >> +#define CAT0_VER_CUSTOMER	0x00	/* customer version */
> > 
> > If you keep the definitions as they are, I think "CAT0" should be replaced
> > by "SYSTEM". This would make it clear that the registers belong to that
> > category, instead of a numeric one.
> Actually, this register named on Document of M-5MOLS. I wanted to satisfy
> to keep that name and to looks readable.
> So, I choose only the name pointing the register value, is followed by document,
> and the prefix like SYSTEM_ is used in the code.
> 
> > 
> >> +#define CAT0_VER_AWB		0x09	/* Auto WB version */
> >> +#define CAT0_VER_STRING		0x0a	/* string including M-5MOLS */
> >> +#define CAT0_SYSMODE		0x0b	/* SYSTEM mode register */
> >> +#define CAT0_STATUS		0x0c	/* SYSTEM mode status register */
> >> +#define CAT0_INT_FACTOR		0x10	/* interrupt pending register */
> >> +#define CAT0_INT_ENABLE		0x11	/* interrupt enable register */
> >> +
> >> +#define SYSTEM_SYSMODE		I2C_REG(CAT_SYSTEM, CAT0_SYSMODE, 1)
> >> +#define REG_SYSINIT		0x00	/* SYSTEM mode */
> >> +#define REG_PARAMETER		0x01	/* PARAMETER mode */
> >> +#define REG_MONITOR		0x02	/* MONITOR mode */
> >> +#define REG_CAPTURE		0x03	/* CAPTURE mode */
> >> +
> >> +#define SYSTEM_CMD(__cmd)	I2C_REG(CAT_SYSTEM, cmd, 1)
> >> +#define SYSTEM_VER_STRING	I2C_REG(CAT_SYSTEM, CAT0_VER_STRING, 1)
> >> +#define REG_SAMSUNG_ELECTRO	"SE"	/* Samsung Electro-Mechanics */
> >> +#define REG_SAMSUNG_OPTICS	"OP"	/* Samsung Fiber-Optics */
> >> +#define REG_SAMSUNG_TECHWIN	"TB"	/* Samsung Techwin */
> >> +
> >> +#define SYSTEM_INT_FACTOR	I2C_REG(CAT_SYSTEM, CAT0_INT_FACTOR, 1)
> >> +#define SYSTEM_INT_ENABLE	I2C_REG(CAT_SYSTEM, CAT0_INT_ENABLE, 1)
> >> +#define REG_INT_MODE		(1 << 0)
> >> +#define REG_INT_AF		(1 << 1)
> >> +#define REG_INT_ZOOM		(1 << 2)
> >> +#define REG_INT_CAPTURE		(1 << 3)
> >> +#define REG_INT_FRAMESYNC	(1 << 4)
> >> +#define REG_INT_FD		(1 << 5)
> >> +#define REG_INT_LENS_INIT	(1 << 6)
> >> +#define REG_INT_SOUND		(1 << 7)
> >> +#define REG_INT_MASK		0x0f
> > 
> > I would prefix the register bit definitions with the name of the register.
> > 
> > E.g.
> > 
> > #define SYSTEM_INT_FACTOR_MODE	(1 << 0)
> It's Ditto "over 80 character"
> 
> If already used once like this, it should use in another case, so
> length of the SYSTEM_INT_FACTOR_MODE does not matter itself, but the other
> case can be troubled.

It's sometimes acceptable to have over 80 characters per line. Yes, it's an
exception but sometimes it's the case. See e.g. videodev2.h, for example.

Regards,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
