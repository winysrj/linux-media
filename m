Return-path: <mchehab@gaivota>
Received: from mailout4.samsung.com ([203.254.224.34]:58778 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab0LPL32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 06:29:28 -0500
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LDI00CC3QKXJB80@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Dec 2010 20:29:22 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LDI001CQQKXOO@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Dec 2010 20:29:21 +0900 (KST)
Date: Thu, 16 Dec 2010 20:29:19 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [PATCH] V4L/DVB: Add support for M5MOLS Mega Pixel camera
In-reply-to: <201012160827.46575.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	g.liakhovetski@gmx.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D09F80F.807@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D01D96B.8040707@samsung.com>
 <201012160827.46575.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,


2010-12-16 오후 4:27, Hans Verkuil 쓴 글:
> Thanks for the reminder, I missed this patch.
> 
> Review comments are below.
> 

<snip>

>> +
>> +/* MACRO */
>> +#define e_check_w(fn, cat, byte, val, bitwidth)		do {	\
>> +	int ret;						\
>> +	ret = (int)(fn);					\
>> +	if ((ret) < 0) {					\
>> +		dev_err(&client->dev, "fail i2c WRITE [%s] - "	\
>> +				"category:0x%02x, "		\
>> +				"bytes:0x%02x, "		\
>> +				"value:0x%02x\n",		\
>> +				(bitwidth),			\
>> +				(cat), (byte), (u32)val);	\
>> +		return ret;					\
>> +	}							\
>> +} while (0)
>> +
>> +#define e_check_r(fn, cat, byte, val, bitwidth)		do {	\
>> +	int ret;						\
>> +	ret = (int)(fn);					\
>> +	if ((ret) < 0) {					\
>> +		dev_err(&client->dev, "fail i2c READ [%s] - "	\
>> +				"category:0x%02x, "		\
>> +				"bytes:0x%02x, "		\
>> +				"value:0x%02x\n",		\
>> +				(bitwidth),			\
>> +				(cat), (byte), (u32)(*val));	\
>> +		return ret;					\
>> +	}							\
>> +} while (0)
>> +
>> +#define REG_W_8(cat, byte, value)					\
>> +	e_check_w(m5mols_write_reg(sd, M5MOLS_8BIT, cat, byte, value),	\
>> +			cat, byte, value, "8bit")
>> +#define REG_R_8(cat, byte, value)					\
>> +	e_check_r(m5mols_read_reg(sd, M5MOLS_8BIT, cat, byte, value),	\
>> +			cat, byte, value, "8bit")
>> +
>> +#define e_check_mode(fn, mode)				do {	\
>> +	int ret;						\
>> +	ret = (int)(fn);					\
>> +	if (ret < 0) {						\
>> +		dev_err(&client->dev, "Failed to %s mode\n",	\
>> +				(mode));			\
>> +		return ret;					\
>> +	}							\
>> +} while (0)
>> +
>> +#define mode_monitoring(sd)					\
>> +	e_check_mode(m5mols_monitoring_mode(sd), "MONITORING")
>> +#define mode_parameter(sd)					\
>> +	e_check_mode(m5mols_parameter_mode(sd), "PARAMETER")
> 
> All these #defines above can be replaced by static inline functions. That the
> better option since static inline functions are type-safe.
> 
You're definitely right. So, I know that #defines must be used carefully, either.
But, in this driver code, the macros to use ultimately like this(e.g., REG_W_8(),
REG_R_8(), mode_monitoring(), mode_parameter()), is never return any value.
It return itself, if any error is sensed.
Namely, it's a bulk of codes, not a function.

IMHO, The reasons I made of this macro are 3 things.

1. It may not looks good to add 3 or 4 lines code for checking error return values.
2. It can prevent to miss error-checking code. Just use macro, then be able to
    handle error check, and show the kernel msg about i2c error return, or anything
    errors.
3. If this macro changes to function type, it need one more error checking codes
    in the functions using this macros. So, then, the driver operation flow is a
    litte mess-up.

Actually, to use static inline function for typesafing is right, I know.
But, can you think one more time, plz?
If I'm wrong after your thinking, I'll change this to inline functions. 

<snip>

>> +static struct v4l2_queryctrl m5mols_controls[] = {
>> +	/* White balance */
>> +	{
>> +		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
>> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
>> +		.name		= "Auto White Balance",
>> +		.minimum	= 0,
>> +		.maximum	= 1,
>> +		.step		= 1,
>> +		.default_value	= 0,
>> +	},
>> +	/* Exposure metering/control */
>> +	{
>> +		.id		= V4L2_CID_EXPOSURE_AUTO,
>> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>> +		.name		= "Exposure control preset",
>> +		.minimum	= 0,
>> +		.maximum	= 3,
>> +		.step		= 1,
>> +		.default_value	= V4L2_EXPOSURE_AUTO,
>> +	},
>> +	{
>> +		.id		= V4L2_CID_EXPOSURE,
>> +		.type		= V4L2_CTRL_TYPE_MENU,
>> +		.name		= "Exposure bias",
>> +		.minimum	= 0,
>> +		.maximum	= ARRAY_SIZE(m5mols_qm_ev_prst) - 2,
>> +		.step		= 1,
>> +		.default_value	= 5,	/* 0EV */
>> +	},
>> +	/* Adjustment features */
>> +	{
>> +		.id		= V4L2_CID_COLORFX,
>> +		.type		= V4L2_CTRL_TYPE_MENU,
>> +		.name		= "Image effect",
>> +		.minimum	= 0,
>> +		.maximum	= ARRAY_SIZE(m5mols_qm_effect_prst) - 2,
>> +		.step		= 1,
>> +		.default_value	= 0,
>> +	},
>> +	{
>> +		.id		= V4L2_CID_SATURATION,
>> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>> +		.name		= "Saturation",
>> +		.minimum	= 1,
>> +		.maximum	= 7,
>> +		.step		= 1,
>> +		.default_value	= 4,
>> +	}, {
>> +	}
>> +};
> 
> New drivers should use the control framework.
> 
> See Documentation/video4linux/v4l2-controls.txt.
> 

Oh. I didn't know yet. I'll change old control method to new control framework.
I think this type of method is needed for many functional sub-devices, before.

<snip>

>> +static int m5mols_read_reg(struct v4l2_subdev *sd, u8 size,
>> +		u8 category, u8 byte, u32 *val)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	struct device *cdev = &client->dev;
>> +	struct i2c_msg msg[1];
>> +	unsigned char buf[5];
>> +	unsigned char rd[M5MOLS_MAXBIT + 1];
>> +	int ret, retry = 0;
>> +
>> +	if (!client->adapter)
>> +		return -ENODEV;
>> +
>> +	if ((size != M5MOLS_8BIT)
>> +		&& (size != M5MOLS_16BIT)
>> +		&& (size != M5MOLS_32BIT)) {
>> +		dev_err(cdev, "Wrong data size\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +again:
>> +	msg->addr = client->addr;
>> +	msg->flags =  0;
>> +	msg->len = size + 4;
>> +	msg->buf = buf;
>> +
>> +	/* high byte goes first */
>> +	buf[0] = size + 4;
>> +	buf[1] = 0x01;	/* read */
>> +	buf[2] = category;
>> +	buf[3] = byte;
>> +	buf[4] = size;
>> +
>> +	ret = i2c_transfer(client->adapter, msg, 1);
>> +	if (ret < 0) {
>> +		if (retry <= M5MOLS_I2C_RETRY) {
>> +			dev_dbg(cdev, "retry ... %d\n", retry);
>> +			retry++;
>> +			mdelay(20);
>> +			goto again;
>> +		}
> 
> Put the 'return ret' here.
> 
>> +
>> +	} else {
> 
> then the 'else' isn't needed anymore and the code below can be
> shifted one indent to the left.
> 

Ok. I'll do that. 

>> +static int m5mols_monitoring_mode(struct v4l2_subdev *sd)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	struct m5mols_info *info = to_m5mols(sd);
>> +	int ret = -EBUSY;
>> +
>> +	if (info->mode == M5MOLS_MONITOR)
>> +		return 0;
>> +	else
>> +		info->mode_b = info->mode;	/* mode_backup */
>> +
>> +	/* Goto monitoring mode */
>> +	REG_W_8(CAT_SYSTEM, CAT0_SYSMODE, M5MOLS_MONITOR);
>> +	ret = m5mols_check_busy(sd, CAT_SYSTEM, CAT0_SYSMODE, M5MOLS_MONITOR);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* restore monitor format */
>> +	memcpy(&info->fmt_mon, &info->fmt, sizeof(struct v4l2_mbus_framefmt));
> 
> Just do: info->fmt_mon = info->fmt;

I'll change it.

<snip>

>> +++ b/include/media/m5mols.h
>> @@ -0,0 +1,31 @@
>> +/*
>> + * Driver for M5MOLS 8M Pixel camera sensor with ISP
>> + *
>> + * Copyright (C) 2010 Samsung Electronics Co., Ltd
>> + * Author: HeungJun Kim, riverful.kim@samsung.com
>> + *
>> + * Copyright (C) 2009 Samsung Electronics Co., Ltd
>> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef __M5MOLS_H
>> +#define __M5MOLS_H
>> +
>> +#include <media/v4l2-mediabus.h>
>> +#include <linux/regulator/consumer.h>
>> +
>> +struct m5mols_platform_data {
>> +	struct v4l2_mbus_framefmt	fmt;		/* default fmt */
>> +	const char			**supply_names;	/* regulator name */
>> +	int				supply_size;	/* name string size */
>> +
>> +	int (*set_power)(int on);
>> +	int (*set_clock)(struct device *dev, int on);
>> +};
>> +
>> +#endif	/* __M5MOLS_H */
>>
> 
> Regards,
> 
> 	Hans
> 

I'll change 3 things of 4. After I catch your one more comments about changing
definitions to inline functions, I'll re-send patch v2, ASAP.

Thanks for reviewing.

Regards,
Heungjun Kim
