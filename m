Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34878 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S935629Ab0COI4n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 04:56:43 -0400
Date: Mon, 15 Mar 2010 09:56:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
	Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] V4L: v4l2-subdev driver for AK8813 and AK8814 TV-encoders
 from AKM
In-Reply-To: <201003141201.39209.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1003141208330.4425@axis700.grange>
References: <Pine.LNX.4.64.1003111124440.4385@axis700.grange>
 <201003141201.39209.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 14 Mar 2010, Hans Verkuil wrote:

> Review notes below...
> 
> On Thursday 11 March 2010 11:25:42 Guennadi Liakhovetski wrote:
> > AK8814 only differs from AK8813 by included Macrovision Copy Protection
> > function. This patch adds a driver for AK8813 and AK8814 I2C PAL/NTSC TV
> > encoders.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---

[snip]

> > diff --git a/drivers/media/video/ak881x.c b/drivers/media/video/ak881x.c
> > new file mode 100644
> > index 0000000..b91f0f6
> > --- /dev/null
> > +++ b/drivers/media/video/ak881x.c
> > @@ -0,0 +1,360 @@
> > +/*
> > + * Driver for AK8813 / AK8814 TV-ecoders from Asahi Kasei Microsystems Co., Ltd. (AKM)
> > + *
> > + * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/i2c.h>
> > +#include <linux/init.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/videodev2.h>
> > +
> > +#include <media/ak881x.h>
> > +#include <media/v4l2-chip-ident.h>
> > +#include <media/v4l2-common.h>
> > +#include <media/v4l2-device.h>
> > +
> > +#define AK881X_INTERFACE_MODE	0
> > +#define AK881X_VIDEO_PROCESS1	1
> > +#define AK881X_VIDEO_PROCESS2	2
> > +#define AK881X_VIDEO_PROCESS3	3
> > +#define AK881X_DAC_MODE		5
> > +#define AK881X_STATUS		0x24
> > +#define AK881X_DEVICE_ID	0x25
> > +#define AK881X_DEVICE_REVISION	0x26
> > +
> > +struct ak881x {
> > +	struct v4l2_subdev subdev;
> > +	struct ak881x_pdata *pdata;
> > +	int id;	/* DEVICE_ID code V4L2_IDENT_AK881X code from v4l2-chip-ident.h */
> > +	char revision;	/* DEVICE_REVISION content */
> > +};
> > +
> > +static int reg_read(struct i2c_client *client, const u8 reg)
> > +{
> > +	return i2c_smbus_read_byte_data(client, reg);
> > +}
> > +
> > +static int reg_write(struct i2c_client *client, const u8 reg,
> > +		     const u8 data)
> > +{
> > +	return i2c_smbus_write_byte_data(client, reg, data);
> > +}
> 
> I suggest making these inline.

Disagree. It has been advised on the LKML to _not_ use inline in .c files 
- the compiler decides itself, and it does trivially inline these.

> I also recommend using struct v4l2_subdev instead of struct i2c_client as
> argument. In my experience it makes the code cleaner if the mapping from
> subdev to i2c_client is done at the lowest possible level.

May I disagree with this one too?;) Just for a mere reason, that in this 
specific case, register-access routines should not need anything except the 
i2c-client - by desiign.

> > +
> > +static int reg_set(struct i2c_client *client, const u8 reg,
> > +		   const u8 data, u8 mask)
> > +{
> > +	int ret = reg_read(client, reg);
> > +	if (ret < 0)
> > +		return ret;
> > +	return reg_write(client, reg, (ret & ~mask) | (data & mask));
> > +}
> > +
> > +static struct ak881x *to_ak881x(const struct i2c_client *client)
> > +{
> > +	return container_of(i2c_get_clientdata(client), struct ak881x, subdev);
> > +}
> 
> Ditto for this one.
> 
> > +
> > +static int ak881x_g_chip_ident(struct v4l2_subdev *sd,
> > +				struct v4l2_dbg_chip_ident *id)
> > +{
> > +	struct i2c_client *client = sd->priv;
> 
> Don't use sd->priv directly. Use v4l2_get_subdevdata(sd) instead.

Ok.

> > +	struct ak881x *ak881x = to_ak881x(client);
> > +
> > +	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
> > +		return -EINVAL;
> > +
> > +	if (id->match.addr != client->addr)
> > +		return -ENODEV;
> > +
> > +	id->ident	= ak881x->id;
> > +	id->revision	= ak881x->revision;
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > +static int ak881x_g_register(struct v4l2_subdev *sd,
> > +			      struct v4l2_dbg_register *reg)
> > +{
> > +	struct i2c_client *client = sd->priv;
> > +
> > +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x26)
> > +		return -EINVAL;
> > +
> > +	if (reg->match.addr != client->addr)
> > +		return -ENODEV;
> > +
> > +	reg->val = reg_read(client, reg->reg);
> > +
> > +	if (reg->val > 0xffff)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ak881x_s_register(struct v4l2_subdev *sd,
> > +			      struct v4l2_dbg_register *reg)
> > +{
> > +	struct i2c_client *client = sd->priv;
> > +
> > +	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x26)
> > +		return -EINVAL;
> > +
> > +	if (reg->match.addr != client->addr)
> > +		return -ENODEV;
> > +
> > +	if (reg_write(client, reg->reg, reg->val) < 0)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static int ak881x_try_g_fmt(struct v4l2_subdev *sd,
> > +			    struct v4l2_mbus_framefmt *mf)
> 
> Can you rename this function to ak881x_try_g_mbus_fmt? Same for the other
> fmt functions.

Well, we (including you) wanted to eventually convert all subdev drivers 
to mediabus, and then to rename *_mbus_fmt to just *_fmt. That's why I 
kept these names without "mbus" also in all soc-camera drivers, as I was 
converting them to mediabus. So, I would prefer to keep this here too.

> > +{
> > +	v4l_bound_align_image(&mf->width, 0, 720, 2,
> > +			      &mf->height, 0, 480, 1, 0);
> 
> 480? Doesn't this do 576 as well when PAL is selected?

Right, it, probably, can.

> > +	mf->field	= V4L2_FIELD_INTERLACED;
> > +	mf->code	= V4L2_MBUS_FMT_YUYV8_2X8_LE;
> > +	mf->colorspace	= V4L2_COLORSPACE_SMPTE170M;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ak881x_s_fmt(struct v4l2_subdev *sd,
> > +			 struct v4l2_mbus_framefmt *mf)
> > +{
> > +	if (mf->field != V4L2_FIELD_INTERLACED ||
> > +	    mf->code != V4L2_MBUS_FMT_YUYV8_2X8_LE)
> > +		return -EINVAL;
> > +
> > +	return ak881x_try_g_fmt(sd, mf);
> > +}
> > +
> > +static int ak881x_enum_fmt(struct v4l2_subdev *sd, int index,
> > +			    enum v4l2_mbus_pixelcode *code)
> > +{
> > +	if (index)
> > +		return -EINVAL;
> > +
> > +	*code = V4L2_MBUS_FMT_YUYV8_2X8_LE;
> > +	return 0;
> > +}
> > +
> > +static int ak881x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
> > +{
> > +	a->bounds.left			= 0;
> > +	a->bounds.top			= 0;
> > +	a->bounds.width			= 720;
> > +	a->bounds.height		= 240 * 2;
> 
> 288 * 2 for PAL?

Yup.

> > +	a->defrect			= a->bounds;
> > +	a->type				= V4L2_BUF_TYPE_VIDEO_OUTPUT;
> > +	a->pixelaspect.numerator	= 1;
> > +	a->pixelaspect.denominator	= 1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ak881x_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
> > +{
> > +	struct i2c_client *client = sd->priv;
> > +	u8 vp1;
> > +
> > +	switch (std) {
> > +	case V4L2_STD_NTSC_M:
> > +	default:
> > +		vp1 = 0;
> > +		break;
> > +	case V4L2_STD_NTSC_443:
> > +		vp1 = 3;
> > +		break;
> > +	case V4L2_STD_PAL_M:
> > +		vp1 = 5;
> > +		break;
> > +	case V4L2_STD_PAL_60:
> > +		vp1 = 7;
> > +		break;
> > +	case V4L2_STD_PAL_B:
> > +	case V4L2_STD_PAL_D:
> > +	case V4L2_STD_PAL_G:
> > +	case V4L2_STD_PAL_H:
> > +	case V4L2_STD_PAL_I:
> > +		vp1 = 0xf;
> > +	}
> > +
> > +	reg_set(client, AK881X_VIDEO_PROCESS1, vp1, 0xf);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ak881x_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct i2c_client *client = sd->priv;
> > +	struct ak881x *ak881x = to_ak881x(client);
> > +
> > +	if (enable) {
> > +		u8 dac;
> > +		/* For colour-bar testing set bit 6 of AK881X_VIDEO_PROCESS1 */
> > +		/* Default: composite output */
> > +		if (ak881x->pdata->flags & AK881X_COMPONENT)
> > +			dac = 3;
> > +		else
> > +			dac = 4;
> > +		/* Turn on the DAC(s) */
> > +		reg_write(client, AK881X_DAC_MODE, dac);
> > +		dev_dbg(&client->dev, "chip status 0x%x\n",
> > +			reg_read(client, AK881X_STATUS));
> > +	} else {
> > +		/* ...and clear bit 6 of AK881X_VIDEO_PROCESS1 here */
> > +		reg_write(client, AK881X_DAC_MODE, 0);
> > +		dev_dbg(&client->dev, "chip status 0x%x\n",
> > +			reg_read(client, AK881X_STATUS));
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static struct v4l2_subdev_core_ops ak881x_subdev_core_ops = {
> > +	.g_chip_ident	= ak881x_g_chip_ident,
> > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > +	.g_register	= ak881x_g_register,
> > +	.s_register	= ak881x_s_register,
> > +#endif
> > +};
> > +
> > +static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
> > +	.s_mbus_fmt	= ak881x_s_fmt,
> > +	.g_mbus_fmt	= ak881x_try_g_fmt,
> > +	.try_mbus_fmt	= ak881x_try_g_fmt,
> > +	.cropcap	= ak881x_cropcap,
> > +	.enum_mbus_fmt	= ak881x_enum_fmt,
> > +	.s_std_output	= ak881x_s_std_output,
> > +	.s_stream	= ak881x_s_stream,
> > +};
> > +
> > +static struct v4l2_subdev_ops ak881x_subdev_ops = {
> > +	.core	= &ak881x_subdev_core_ops,
> > +	.video	= &ak881x_subdev_video_ops,
> > +};
> > +
> > +static int ak881x_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *did)
> > +{
> > +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> > +	struct ak881x *ak881x;
> > +	u8 ifmode, data;
> > +
> > +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
> > +		dev_warn(&adapter->dev,
> > +			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> > +		return -EIO;
> > +	}
> > +
> > +	ak881x = kzalloc(sizeof(struct ak881x), GFP_KERNEL);
> > +	if (!ak881x)
> > +		return -ENOMEM;
> > +
> > +	v4l2_i2c_subdev_init(&ak881x->subdev, client, &ak881x_subdev_ops);
> > +
> > +	data = reg_read(client, AK881X_DEVICE_ID);
> > +
> > +	switch (data) {
> > +	case 0x13:
> > +		ak881x->id = V4L2_IDENT_AK8813;
> > +		break;
> > +	case 0x14:
> > +		ak881x->id = V4L2_IDENT_AK8814;
> > +		break;
> > +	default:
> > +		dev_err(&client->dev,
> > +			"No ak881x chip detected, register read %x\n", data);
> > +		i2c_set_clientdata(client, NULL);
> 
> No need to call i2c_set_clientdata here.

Ok.

> > +		kfree(ak881x);
> > +		return -ENODEV;
> > +	}
> > +
> > +	ak881x->revision = reg_read(client, AK881X_DEVICE_REVISION);
> > +	ak881x->pdata = client->dev.platform_data;
> > +
> > +	if (ak881x->pdata) {
> > +		if (ak881x->pdata->flags & AK881X_FIELD)
> > +			ifmode = 4;
> > +		else
> > +			ifmode = 0;
> > +
> > +		switch (ak881x->pdata->flags & AK881X_IF_MODE_MASK) {
> > +		case AK881X_IF_MODE_BT656:
> > +			ifmode |= 1;
> > +			break;
> > +		case AK881X_IF_MODE_MASTER:
> > +			ifmode |= 2;
> > +			break;
> > +		case AK881X_IF_MODE_SLAVE:
> > +		default:
> > +			break;
> > +		}
> > +
> > +		dev_dbg(&client->dev, "IF mode %x\n", ifmode);
> > +
> > +		/*
> > +		 * "Line Blanking No." seems to be the same as the number of
> > +		 * "black" lines on, e.g., SuperH VOU, whose default value of 20
> > +		 * "incidentally" matches ak881x' default
> > +		 */
> > +		reg_write(client, AK881X_INTERFACE_MODE, ifmode | (20 << 3));
> > +	}
> > +
> > +	dev_info(&client->dev, "Detected an ak881x chip ID %x, revision %x\n",
> > +		 data, ak881x->revision);
> 
> Please use this instead:
> 
>         v4l2_info(&ak881x->subdev, "chip found @ 0x%02x (%s, revision %x)\n",
>                  client->addr << 1, client->adapter->name, ak881x->revision);
> 
> This is for consistency with other i2c v4l drivers.
> 
> Please also use v4l2_info/warn/err/dbg instead of the dev_ versions (except if
> there is no subdev pointer available). Again for consistency with other i2c
> drivers (and a more concise prefix as well).

Ooh, why do we have to be special?... Firstly, it is a Linux convention to 
specify I2C device addresses without the read / write bit. Granted it has 
introduced enough confusion, but don't we make it even worse with this?... 
Secondly, I didn't like these macros as I first saw them, and I still 
don't like them for a very simple reason: do all driver subsystems now 
have to introduce their own *_printk versions? usb_info()? pci_info()? 
ata_info()? net_info()?... Don't we have dev_* exactly for this purpose - 
to be used by all drivers, regardless of the subsystem? Can we maybe 
rethink this approach, shall we?

> > +
> > +	return 0;
> > +}
> > +
> > +static int ak881x_remove(struct i2c_client *client)
> > +{
> > +	struct ak881x *ak881x = to_ak881x(client);
> > +
> > +	i2c_set_clientdata(client, NULL);
> 
> This is not right. Use this instead:
> 
>         v4l2_device_unregister_subdev(sd);
> 
> See v4l2-framework.txt why you should do this in remove().

Ok.

> > +	kfree(ak881x);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id ak881x_id[] = {
> > +	{ "ak8813", 0 },
> > +	{ "ak8814", 0 },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, ak881x_id);
> > +
> > +static struct i2c_driver ak881x_i2c_driver = {
> > +	.driver = {
> > +		.name = "ak881x",
> > +	},
> > +	.probe		= ak881x_probe,
> > +	.remove		= ak881x_remove,
> > +	.id_table	= ak881x_id,
> > +};
> > +
> > +static int __init ak881x_module_init(void)
> > +{
> > +	return i2c_add_driver(&ak881x_i2c_driver);
> > +}
> > +
> > +static void __exit ak881x_module_exit(void)
> > +{
> > +	i2c_del_driver(&ak881x_i2c_driver);
> > +}
> > +
> > +module_init(ak881x_module_init);
> > +module_exit(ak881x_module_exit);
> > +
> > +MODULE_DESCRIPTION("TV-output driver for ak8813/ak8814");
> > +MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/include/media/ak881x.h b/include/media/ak881x.h
> > new file mode 100644
> > index 0000000..b7f2add
> > --- /dev/null
> > +++ b/include/media/ak881x.h
> > @@ -0,0 +1,25 @@
> > +/*
> > + * Header for AK8813 / AK8814 TV-ecoders from Asahi Kasei Microsystems Co., Ltd. (AKM)
> > + *
> > + * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef AK881X_H
> > +#define AK881X_H
> > +
> > +#define AK881X_IF_MODE_MASK	(3 << 0)
> > +#define AK881X_IF_MODE_BT656	(0 << 0)
> > +#define AK881X_IF_MODE_MASTER	(1 << 0)
> > +#define AK881X_IF_MODE_SLAVE	(2 << 0)
> > +#define AK881X_FIELD		(1 << 2)
> > +#define AK881X_COMPONENT	(1 << 3)
> > +
> > +struct ak881x_pdata {
> > +	unsigned long flags;
> 
> Why unsigned long? u32 makes more sense. For 64-bit archs unsigned long is
> 64 bits.

Disagree. I'm trying to follow the rule to only use fixed-bitsize types 
where needed, e.g., where values, they describe, correspond to some (fixed 
width) hardware registers, or are a part of an ABI. In all other cases I 
prefer to use C-native types. So, if you really want to save those 32 bits 
per ak881x device on hypothetical 64-bit systems where it can ever by used 
- we can make it unsigned int, otherwise, using a long for flags has 
become more or less a tradition, I think.

> > +};
> > +
> > +#endif
> > diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> > index 6cc107d..5d7b742 100644
> > --- a/include/media/v4l2-chip-ident.h
> > +++ b/include/media/v4l2-chip-ident.h
> > @@ -289,6 +289,10 @@ enum {
> >  
> >  	/* Sharp RJ54N1CB0C, 0xCB0C = 51980 */
> >  	V4L2_IDENT_RJ54N1CB0C = 51980,
> > +
> > +	/* AKM AK8813/AK8814 */
> > +	V4L2_IDENT_AK8813 = 8813,
> > +	V4L2_IDENT_AK8814 = 8814,
> 
> The IDs in v4l2-chip-ident.h should be kept in increasing numeric order. I see
> that several are already placed out of order. I'm going to make a patch for
> that and then you can add these new IDs in the right place.

Yep, will do.

> >  };
> >  
> >  #endif
> > 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
