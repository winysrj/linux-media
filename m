Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:48489 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0HVTqb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Aug 2010 15:46:31 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] [PATCH 3/6] SoC Camera: add driver for OV6650 sensor
Date: Sun, 22 Aug 2010 21:45:39 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl> <201007180624.45693.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1008131203310.31714@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1008131203310.31714@axis700.grange>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201008222145.40942.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Guennadi,
Thanks for your review time.

Sunday 22 August 2010 18:40:13 Guennadi Liakhovetski wrote:
> On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:
> > This patch provides a V4L2 SoC Camera driver for OV6650 camera sensor,
> > found on OMAP1 SoC based Amstrad Delta videophone.
>
> Have you also had a look at drivers/media/video/gspca/sonixb.c - in also
> supports ov6650 among other sensors.

Yes, I have, but given up for now since:
1. the gspca seems using the sensor in "Bayer 8 BGGR" mode only, which I was 
   not even able to select using mplayer to test my drivers with,
2. not all settings used there are clear for me, so I've decided to revisit 
   them later, when I first get a stable, even if not perfect, working driver 
   version accepted, instead of following them blindly.

> > Since I have no experience with camera sensors, and the sensor
> > documentation I was able to find was not very comprehensive, I left most
> > settings at their default (reset) values, except for:
> > - those required for proper mediabus parameters and picture format setup,
> > - those used by controls.
> > Resulting picture quality is far from perfect, but better than nothing.
> >
...
> > --- linux-2.6.35-rc3.orig/drivers/media/video/ov6650.c	1970-01-01 
01:00:00.000000000 +0100 
> > +++ linux-2.6.35-rc3/drivers/media/video/ov6650.c	2010-07-18 
02:06:22.000000000 +0200 
> > @@ -0,0 +1,1336 @@ 
> > +/*
> > + * V4L2 SoC Camera driver for OmniVision OV6650 Camera Sensor
> > + *
> > + * Copyright (C) 2010 Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > + *
> > + * Based on OmniVision OV96xx Camera Driver
> > + * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
> > + *
> > + * Based on ov772x camera driver:
> > + * Copyright (C) 2008 Renesas Solutions Corp.
> > + * Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > + *
> > + * Based on ov7670 and soc_camera_platform driver,
> > + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
> > + * Copyright (C) 2008 Magnus Damm
> > + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> > + *
> > + * Hardware specific bits initialy based on former work by Matt Callow
> > + * drivers/media/video/omap/sensor_ov6650.c
> > + * Copyright (C) 2006 Matt Callow
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/i2c.h>
> > +#include <linux/slab.h>
> > +#include <linux/delay.h>
> > +#include <media/v4l2-chip-ident.h>
> > +#include <media/soc_camera.h>
>
> Please, sort headers alphabetically (media/ and linux/ separately, of
> course).

OK.

> > +
> > +
> > +/* Register definitions */
> > +#define	REG_GAIN		0x00	/* range 00 - 3F */
> > +#define	REG_BLUE		0x01
> > +#define	REG_RED			0x02
> > +#define	REG_SAT			0x03	/* [7:4] saturation [0:3] reserved */
> > +#define	REG_HUE			0x04	/* [7:6] rsrvd [5] hue en [4:0] hue */
> > +
> > +#define	REG_BRT			0x06
> > +
> > +#define	REG_PIDH		0x0a
> > +#define	REG_PIDL		0x0b
> > +
> > +#define	REG_AECH		0x10
> > +#define	REG_CLKRC		0x11	/* Data Format and Internal Clock */
> > +					/* [7:6] Input system clock (MHz)*/
> > +					/*   00=8, 01=12, 10=16, 11=24 */
> > +					/* [5:0]: Internal Clock Pre-Scaler */
> > +#define	REG_COMA		0x12	/* [7] Reset */
> > +#define	REG_COMB		0x13
> > +#define	REG_COMC		0x14
> > +#define	REG_COMD		0x15
> > +#define REG_COML		0x16
>
> You used TAB in most defines and a space in this one and a few ones below.
> Please, use the same for all (I personally would just use a space).

Agree.

...
> > +
> > +#define NUM_REGS		(REG_BMCO + 1)
>
> NUM_REGS is unused, don't need to define it.

OK.

...
> > +#define SAT_SHIFT		4
> > +#define SAT_MASK		0xf
> > +#define SET_SAT(x)		(((x) & SAT_MASK) << SAT_SHIFT)
>
> Nitpicking, but I would
>
> +#define SAT_SHIFT		4
> +#define SAT_MASK		0xf0
> +#define SET_SAT(x)		(((x) << SAT_SHIFT) & SAT_MASK)
>
> Advantage: your SAT_MASK is already correctly shifted, so, you don't have
> to you SET_SAT(SAT_MASK) to get to the register value.

You're right.

> > +
> > +#define HUE_EN			BIT(5)
>
> You have to #include <linux/bitops.h> for the BIT() macro

OK.

...
> > +/* write a register */
> > +static int ov6650_reg_write(struct i2c_client *client, u8 reg, u8 val)
> > +{
> > +	int ret;
> > +	u8 _val;
> > +	unsigned char data[2] = { reg, val };
> > +	struct i2c_msg msg = {
> > +		.addr	= client->addr,
> > +		.flags	= 0,
> > +		.len	= 2,
> > +		.buf	= data,
> > +	};
> > +
> > +	ret = i2c_transfer(client->adapter, &msg, 1);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "Failed writing register 0x%02x!\n", reg);
> > +		return ret;
> > +	}
> > +	msleep(1);
>
> Hm, interesting... Is this really needed?

If you mean msleep(1) - yes, the sensor didn't work correctly for me without 
that msleep().

I you mean reading the register back - I've not tried without, will do.

> > +
> > +	/* we have to read the register back ... no idea why, maybe HW bug */
> > +	ret = ov6650_reg_read(client, reg, &_val);
>
> You can also use "val" - it is not needed any more - and drop "_val."

Will do.

> > +	if (ret)
> > +		dev_err(&client->dev,
> > +			"Failed reading back register 0x%02x!\n", reg);
> > +
> > +	return 0;
> > +}
> > +
> > +
> > +/* Read a register, alter its bits, write it back */
> > +static int ov6650_reg_rmw(struct i2c_client *client, u8 reg, u8 set, u8
> > mask) +{
> > +	u8 val;
> > +	int ret;
> > +
> > +	ret = ov6650_reg_read(client, reg, &val);
> > +	if (ret) {
> > +		dev_err(&client->dev,
> > +			"[Read]-Modify-Write of register %02x failed!\n", reg);
> > +		return val;
>
> You mean "return ret"

Yes, thanks.

> > +	}
> > +
> > +	val &= ~mask;
> > +	val |= set;
> > +
> > +	ret = ov6650_reg_write(client, reg, val);
> > +	if (ret)
> > +		dev_err(&client->dev,
> > +			"Read-Modify-[Write] of register %02x failed!\n", reg);
> > +
> > +	return ret;
> > +}
> > +
> > +/* Soft reset the camera. This has nothing to do with the RESET pin! */
> > +static int ov6650_reset(struct i2c_client *client)
> > +{
> > +	int ret;
> > +
> > +	dev_dbg(&client->dev, "reset\n");
> > +
> > +	ret = ov6650_reg_rmw(client, REG_COMA, COMA_RESET, 0);
> > +	if (ret)
> > +		dev_err(&client->dev,
> > +			"An error occured while entering soft reset!\n");
> > +
> > +	return ret;
> > +}

...
> > +/* Set status of additional camera capabilities */
> > +static int ov6650_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control
> > *ctrl) +{
> > +	struct i2c_client *client = sd->priv;
> > +	struct ov6650 *priv = to_ov6650(client);
> > +	bool automatic;
> > +	int ret = 0;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_AUTOGAIN:
> > +		if (ctrl->value) {
> > +			ret = ov6650_reg_write(client, REG_GAIN, DEF_GAIN);
> > +			if (ret)
> > +				break;
> > +			priv->gain = DEF_GAIN;
> > +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AGC, 0);
> > +		} else {
> > +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AGC);
> > +		}
> > +		if (ret)
> > +			break;
> > +		priv->agc = ctrl->value;
> > +		break;
> > +	case V4L2_CID_GAIN:
> > +		ret = ov6650_reg_write(client, REG_GAIN, ctrl->value);
> > +		if (ret)
> > +			break;
> > +		priv->gain = ctrl->value;
> > +		automatic = (priv->gain == DEF_GAIN);
> > +		if (automatic)
> > +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AGC, 0);
> > +		else
> > +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AGC);
> > +		if (ret)
> > +			break;
> > +		priv->agc = automatic;
>
> I wouldn't touch autogain here. You have V4L2_CID_AUTOGAIN for that.
> Setting gain to a value, that happens to be equal default, doesn't have to
> turn autogain on, does it?

Right. The reason for doing it like this was being able to test controls using 
limited mplayer capabilities. Now that I've learned how I can do this with 
v4l2-dbg, I'll revert to a more common algorithm, for this one and all 
similiar cases below.

> > +		break;
> > +	case V4L2_CID_AUTO_WHITE_BALANCE:
> > +		if (ctrl->value) {
> > +			ret = ov6650_reg_write(client, REG_BLUE, DEF_BLUE);
> > +			if (ret)
> > +				break;
> > +			priv->blue = DEF_BLUE;
> > +			ret = ov6650_reg_write(client, REG_RED, DEF_RED);
> > +			if (ret)
> > +				break;
> > +			priv->red = DEF_RED;
> > +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AWB, 0);
> > +		} else {
> > +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AWB);
> > +		}
> > +		if (ret)
> > +			break;
> > +		priv->awb = ctrl->value;
> > +		break;
> > +	case V4L2_CID_BLUE_BALANCE:
> > +		ret = ov6650_reg_write(client, REG_BLUE, ctrl->value);
> > +		if (ret)
> > +			break;
> > +		priv->blue = ctrl->value;
> > +		automatic = (priv->blue == DEF_BLUE &&
> > +				priv->red == DEF_RED);
> > +		if (automatic)
> > +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AWB, 0);
> > +		else
> > +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AWB);
> > +		if (ret)
> > +			break;
> > +		priv->awb = automatic;
> > +		break;
> > +	case V4L2_CID_RED_BALANCE:
> > +		ret = ov6650_reg_write(client, REG_RED, ctrl->value);
> > +		if (ret)
> > +			break;
> > +		priv->red = ctrl->value;
> > +		automatic = (priv->blue == DEF_BLUE &&
> > +				priv->red == DEF_RED);
> > +		if (automatic)
> > +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AWB, 0);
> > +		else
> > +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AWB);
> > +		if (ret)
> > +			break;
> > +		priv->awb = automatic;
>
> Same here, I wouldn't touch AWB in the above two controls. You have
> V4L2_CID_AUTO_WHITE_BALANCE for that.

ditto

> > +		break;
> > +	case V4L2_CID_SATURATION:
> > +		ret = ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->value),
> > +				SET_SAT(SAT_MASK));
>
> With the proposed change it would look like
>
> +		ret = ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->value),
> +				SAT_MASK);
>
> which I personally find a bit more pleasant to the eyes;)

Sure.

> > +		if (ret)
> > +			break;
> > +		priv->saturation = ctrl->value;
> > +		break;
> > +	case V4L2_CID_HUE_AUTO:
> > +		if (ctrl->value) {
> > +			ret = ov6650_reg_rmw(client, REG_HUE,
> > +					SET_HUE(DEF_HUE), SET_HUE(HUE_MASK));
> > +			if (ret)
> > +				break;
> > +			priv->hue = DEF_HUE;
> > +		} else {
> > +			ret = ov6650_reg_rmw(client, REG_HUE, HUE_EN, 0);
> > +		}
> > +		if (ret)
> > +			break;
> > +		priv->hue_auto = ctrl->value;
>
> Hm, sorry, don't understand. If the user sets auto-hue to ON, you set the
> hue enable bit and hue value to default. 

No, I reset the hue enable bit here, which I understand is used for applying a 
non-default hue value if set rather than enabling auto hue. Maybe my 
understanding of this bit function is wrong.

> If the user sets auto-hue to OFF, 
> you just set the hue enable bit on and don't change the value. Does ov6650
> actually support auto-hue?

All I was able to find out was the HUE register bits described like this:

Bit[7:6]: Reserved
Bit[5]: Hue Enable
Bit[4:0]: Hue setting

and the register default value: 0x10.

What do you think the bit[5] meaning is?

> > +		break;
> > +	case V4L2_CID_HUE:
> > +		ret = ov6650_reg_rmw(client, REG_HUE, SET_HUE(ctrl->value),
> > +				SET_HUE(HUE_MASK));
> > +		if (ret)
> > +			break;
> > +		priv->hue = ctrl->value;
> > +		priv->hue_auto = (priv->hue == DEF_HUE);
>
> Here it seems like in order to adjust hue you always have to set the
> enable bit. Again, I wouldn't touch hue_auto here - default and auto are
> different things.

Yes, one more mplayer testing related case that requires updating to a more 
common algorithm.

> > +		break;
> > +	case V4L2_CID_BRIGHTNESS:
> > +		ret = ov6650_reg_write(client, REG_BRT, ctrl->value);
> > +		if (ret)
> > +			break;
> > +		priv->brightness = ctrl->value;
> > +		break;
> > +	case V4L2_CID_EXPOSURE_AUTO:
> > +		switch (ctrl->value) {
> > +		case V4L2_EXPOSURE_AUTO:
> > +			ret = ov6650_reg_write(client, REG_AECH, DEF_AECH);
>
> Is this a requirement for auto-exposure, that you have to set the (analog
> manual) exposure to the default value?

Again, probably it's not.

> > +			if (ret)
> > +				break;
> > +			priv->exposure = DEF_AECH;
> > +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
> > +			break;
> > +		default:
> > +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
> > +			break;
> > +		}
> > +		if (ret)
> > +			break;
> > +		priv->aec = ctrl->value;
> > +		break;
> > +	case V4L2_CID_EXPOSURE:
> > +		ret = ov6650_reg_write(client, REG_AECH, ctrl->value);
> > +		if (ret)
> > +			break;
> > +		priv->exposure = ctrl->value;
> > +		automatic = (priv->exposure == DEF_AECH);
> > +		if (automatic)
> > +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
> > +		else
> > +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
> > +		if (ret)
> > +			break;
> > +		priv->aec = automatic ? V4L2_EXPOSURE_AUTO :
> > +				V4L2_EXPOSURE_MANUAL;
>
> Again - don't see why you need to touch the auto setting here.

Won't do this any longer.

> > +		break;
> > +	case V4L2_CID_GAMMA:
> > +		ret = ov6650_reg_write(client, REG_GAM1, ctrl->value);
> > +		if (ret)
> > +			break;
> > +		priv->gamma = ctrl->value;
> > +		break;
> > +	case V4L2_CID_VFLIP:
> > +		if (ctrl->value)
> > +			ret = ov6650_reg_rmw(client, REG_COMB,
> > +							COMB_FLIP_V, 0);
> > +		else
> > +			ret = ov6650_reg_rmw(client, REG_COMB,
> > +							0, COMB_FLIP_V);
> > +		if (ret)
> > +			break;
> > +		priv->vflip = ctrl->value;
> > +		break;
> > +	case V4L2_CID_HFLIP:
> > +		if (ctrl->value)
> > +			ret = ov6650_reg_rmw(client, REG_COMB,
> > +							COMB_FLIP_H, 0);
> > +		else
> > +			ret = ov6650_reg_rmw(client, REG_COMB,
> > +							0, COMB_FLIP_H);
> > +		if (ret)
> > +			break;
> > +		priv->hflip = ctrl->value;
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}

...
> > +/* select nearest higher resolution for capture */
> > +static void ov6650_res_roundup(u32 *width, u32 *height)
> > +{
> > +	int i;
> > +	enum { QCIF, CIF };
> > +	int res_x[] = { 176, 352 };
> > +	int res_y[] = { 144, 288 };
> > +
> > +	for (i = 0; i < ARRAY_SIZE(res_x); i++) {
> > +		if (res_x[i] >= *width && res_y[i] >= *height) {
> > +			*width = res_x[i];
> > +			*height = res_y[i];
> > +			return;
> > +		}
> > +	}
> > +
> > +	*width = res_x[CIF];
> > +	*height = res_y[CIF];
> > +}
>
> This can be replaced by a version of
>
> http://www.spinics.net/lists/linux-media/msg21893.html
>
> when it is fixed and accepted;) I'll try to send an updated version of
> that patch tomorrow.

Fine, I'll use this instead of my dirty workarounds.

> > +
> > +/* program default register values */
> > +static int ov6650_prog_dflt(struct i2c_client *client)
> > +{
> > +	int i, ret;
> > +
> > +	dev_dbg(&client->dev, "reinitializing\n");
> > +
> > +	for (i = 0; i < ARRAY_SIZE(ov6650_regs_dflt); i++) {
> > +		ret = ov6650_reg_write(client, ov6650_regs_dflt[i].reg,
> > +						ov6650_regs_dflt[i].val);
> > +		if (ret)
> > +			return ret;
> > +	}
>
> Hm, please, don't. I generally don't like such register - value array
> magic for a number of reasons, and in your case it's just one (!) register
> write operation - please, remove this array and just write the register
> explicitly. 

OK (with a reservation that I can probably end up with more than just one, 
non-default settings written explicitly).

> You also don't need DEF_COMA - writing an explicit "0" and 
> adding a comment - "clear all flags, including reset" would be perfect!

No problem, but to be honest, I didn't intend to clear any flags here except 
the reset flag, just reverting back to the register default reset value. Since 
an overall result will be the same, I can accept your way.

> > +
> > +	return 0;
> > +}
> > +
> > +/* set the format we will capture in */
> > +static int ov6650_s_fmt(struct v4l2_subdev *sd,
> > +			struct v4l2_mbus_framefmt *mf)
> > +{
> > +	struct i2c_client *client = sd->priv;
> > +	struct soc_camera_device *icd	= client->dev.platform_data;
> > +	struct soc_camera_sense *sense = icd->sense;
> > +	struct ov6650 *priv = to_ov6650(client);
> > +	enum v4l2_colorspace cspace;
> > +	enum v4l2_mbus_pixelcode code = mf->code;
> > +	unsigned long pclk;
> > +	u8 coma_set = 0, coma_mask = 0, coml_set = 0, coml_mask = 0, clkrc;
> > +	int ret;
> > +
> > +	/* select color matrix configuration for given color encoding */
> > +	switch (code) {
> > +	case V4L2_MBUS_FMT_GREY8_1X8:
> > +		dev_dbg(&client->dev, "pixel format GREY8_1X8\n");
> > +		coma_set |= COMA_BW;
> > +		coma_mask |= COMA_RGB | COMA_WORD_SWAP | COMA_BYTE_SWAP;
> > +		coml_mask |= COML_ONE_CHANNEL;
> > +		cspace = V4L2_COLORSPACE_JPEG;
> > +		priv->pclk_max = 4000000;
> > +		break;
> > +	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
> > +		dev_dbg(&client->dev, "pixel format YUYV8_2X8_LE\n");
> > +		coma_set |= COMA_WORD_SWAP;
> > +		coma_mask |= COMA_RGB | COMA_BW | COMA_BYTE_SWAP;
> > +		goto yuv;
>
> Well, this doesn't look critical to me, i.e., eventually I would accept
> this, but, as you know, goto's in the kernel are (almost) only used for
> failure cases, besides, what makes this use even less pretty, this is a
> goto into a switch statement... I would set a "yuv = 1" variable instead
> of goto's, and use a "if (yuv) after the switch.

OK, I'll rearrange this piece of code like you suggest to avoid a goto.

> > +	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
> > +		dev_dbg(&client->dev, "pixel format YVYU8_2X8_LE (untested)\n");
> > +		coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP |
> > +				COMA_BYTE_SWAP;
> > +		goto yuv;
> > +	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
> > +		dev_dbg(&client->dev, "pixel format YUYV8_2X8_BE\n");
> > +		if (mf->width == W_CIF) {
> > +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> > +			coma_mask |= COMA_RGB | COMA_BW;
> > +		} else {
> > +			coma_set |= COMA_BYTE_SWAP;
> > +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> > +		}
> > +		goto yuv;
> > +	case V4L2_MBUS_FMT_YVYU8_2X8_BE:
> > +		dev_dbg(&client->dev, "pixel format YVYU8_2X8_BE (untested)\n");
> > +		if (mf->width == W_CIF) {
> > +			coma_set |= COMA_BYTE_SWAP;
> > +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> > +		} else {
> > +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> > +			coma_mask |= COMA_RGB | COMA_BW;
> > +		}
> > +yuv:
> > +		coml_set |= COML_ONE_CHANNEL;
> > +		cspace = V4L2_COLORSPACE_JPEG;
> > +		priv->pclk_max = 8000000;
> > +		break;
> > +	case V4L2_MBUS_FMT_SBGGR8_1X8:
> > +		dev_dbg(&client->dev, "pixel format SBGGR8_1X8 (untested)\n");
> > +		coma_set |= COMA_RAW_RGB | COMA_RGB;
> > +		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
> > +		coml_mask |= COML_ONE_CHANNEL;
> > +		cspace = V4L2_COLORSPACE_SRGB;
> > +		priv->pclk_max = 4000000;
> > +		break;
> > +	default:
> > +		dev_err(&client->dev, "Pixel format not handled : %x\n", code);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* select register configuration for given resolution */
> > +	ov6650_res_roundup(&mf->width, &mf->height);
> > +
> > +	switch (mf->width) {
> > +	case W_QCIF:
> > +		dev_dbg(&client->dev, "resolution QCIF\n");
> > +		priv->qcif = 1;
> > +		coma_set |= COMA_QCIF;
> > +		priv->pclk_max /= 2;
> > +		break;
> > +	case W_CIF:
> > +		dev_dbg(&client->dev, "resolution CIF\n");
> > +		priv->qcif = 0;
> > +		coma_mask |= COMA_QCIF;
> > +		break;
> > +	default:
> > +		dev_err(&client->dev, "unspported resolution!\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (priv->timeperframe.numerator && priv->timeperframe.denominator)
> > +		pclk = priv->pclk_max * priv->timeperframe.denominator /
> > +				(FRAME_RATE_MAX * priv->timeperframe.numerator);
> > +	else
> > +		pclk = priv->pclk_max;
> > +
> > +	if (sense) {
> > +		if (sense->master_clock == 8000000) {
> > +			dev_dbg(&client->dev, "8MHz input clock\n");
> > +			clkrc = CLKRC_6MHz;
> > +		} else if (sense->master_clock == 12000000) {
> > +			dev_dbg(&client->dev, "12MHz input clock\n");
> > +			clkrc = CLKRC_12MHz;
> > +		} else if (sense->master_clock == 16000000) {
> > +			dev_dbg(&client->dev, "16MHz input clock\n");
> > +			clkrc = CLKRC_16MHz;
> > +		} else if (sense->master_clock == 24000000) {
> > +			dev_dbg(&client->dev, "24MHz input clock\n");
> > +			clkrc = CLKRC_24MHz;
> > +		} else {
> > +			dev_err(&client->dev,
> > +				"unspported input clock, check platform data"
> > +				"\n");
> > +			return -EINVAL;
> > +		}
> > +		priv->pclk_limit = sense->pixel_clock_max;
> > +		if (priv->pclk_limit &&
> > +				(priv->pclk_limit < pclk))
>
> This can go on one line.

It will.

> > +			pclk = priv->pclk_limit;
> > +	} else {
> > +		priv->pclk_limit = 0;
> > +		clkrc = 0xc0;
> > +		dev_dbg(&client->dev, "using default 24MHz input clock\n");
> > +	}
> > +
> > +	clkrc |= (priv->pclk_max - 1) / pclk;
> > +	pclk = priv->pclk_max / GET_CLKRC_DIV(clkrc);
>
> This would look better as
>
> 	clkrc_div = (priv->pclk_max - 1) / pclk;
> 	clkrc |= clkrc_div;
> 	pclk = priv->pclk_max / clkrc_div;

OK.

> > +	dev_dbg(&client->dev, "pixel clock divider: %ld.%ld\n",
> > +			sense->master_clock / pclk,
> > +			10 * sense->master_clock % pclk / pclk);
> > +
> > +	ov6650_reset(client);
> > +
> > +	ret = ov6650_prog_dflt(client);
> > +	if (ret)
> > +		return ret;
> > +
> > +
>
> Superfluous empty line;)

Mhm.

> > +	ret = ov6650_reg_rmw(client, REG_COMA, coma_set, coma_mask);
> > +	if (!ret)
> > +		ret = ov6650_reg_write(client, REG_CLKRC, clkrc);
> > +	if (!ret)
> > +		ret = ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
> > +
> > +	if (!ret) {
> > +		mf->code	= code;
> > +		mf->colorspace	= cspace;
> > +	}
> > +
> > +	return ret;
> > +}

...
> > +static int ov6650_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap
> > *a) +{
> > +	struct i2c_client *client = sd->priv;
> > +	struct ov6650 *priv = to_ov6650(client);
> > +	int shift = !priv->qcif;
> > +
> > +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> > +
> > +	/* Crop limits depend on selected frame format (CIF/QCIF) */
> > +	a->bounds.left			= DEF_HSTRT << shift;
> > +	a->bounds.top			= DEF_VSTRT << shift;
> > +	a->bounds.width			= W_QCIF << shift;
> > +	a->bounds.height		= H_QCIF << shift;
> > +	/* REVISIT: should defrect provide actual or default geometry? */
>
> default

Thanks for clarification.

> > +	a->defrect			= a->bounds;
> > +	a->pixelaspect.numerator	= 1;
> > +	a->pixelaspect.denominator	= 1;
> > +
> > +	return 0;
> > +}

...
> > +static int ov6650_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> > +{
> > +	struct i2c_client *client = sd->priv;
> > +	struct ov6650 *priv = to_ov6650(client);
> > +	struct v4l2_rect *rect = &a->c;
> > +	int shift = !priv->qcif;
> > +	u8 hstrt, vstrt, hstop, vstop;
> > +	int ret;
> > +
> > +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> > +
> > +	hstrt = rect->left >> shift;
> > +	vstrt = rect->top >> shift;
> > +	hstop = hstrt + (rect->width >> shift);
> > +	vstop = vstrt + (rect->height >> shift);
> > +
> > +	if ((hstop > DEF_HSTOP) || (vstop > DEF_VSTOP)) {
> > +		dev_err(&client->dev, "Invalid window geometry!\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = ov6650_reg_write(client, REG_HSTRT, hstrt);
> > +	if (!ret)
> > +		ret = ov6650_reg_write(client, REG_HSTOP, hstop);
> > +	if (!ret)
> > +		ret = ov6650_reg_write(client, REG_VSTRT, vstrt);
> > +	if (!ret)
> > +		ret = ov6650_reg_write(client, REG_VSTOP, vstop);
>
> Are cropping and scaling on this camera absolutely independent? I.e., you
> can set any output format (CIF or QCIF) and it will just scale whatever
> rectangle has been configured? And the other way round - you set arbitrary
> cropping and output format stays the same?

I believe it works like I have put it here, but will try to recheck to make 
sure. Simply using v4l2-debug for this seems insufficient, since changing a 
frame format on the fly will get DMA out of sync immediately. What tool or 
utility could you advise for testing?

> > +
> > +	return ret;
> > +}

...
> > +static struct soc_camera_ops ov6650_ops = {
> > +	.set_bus_param		= ov6650_set_bus_param,
> > +	.query_bus_param	= ov6650_query_bus_param,
> > +	.controls		= ov6650_controls,
> > +	.num_controls		= ARRAY_SIZE(ov6650_controls),
> > +};
> > +
> > +static struct v4l2_subdev_core_ops ov6650_core_ops = {
> > +	.g_ctrl			= ov6650_g_ctrl,
> > +	.s_ctrl			= ov6650_s_ctrl,
> > +	.g_chip_ident		= ov6650_g_chip_ident,
> > +#ifdef CONFIG_VIDEO_ADV_DEBUG
> > +	.g_register		= ov6650_get_register,
> > +	.s_register		= ov6650_set_register,
> > +#endif
> > +
>
> Superfluous empty line

Will remove.

> > +};
> > +
> > +static struct v4l2_subdev_video_ops ov6650_video_ops = {
> > +	.s_stream	= ov6650_s_stream,
> > +	.s_mbus_fmt	= ov6650_s_fmt,
> > +	.try_mbus_fmt	= ov6650_try_fmt,
>
> Please, implement.g_mbus_fmt.

OK (in addition to what I've already implemented, I guess).

> > +	.enum_mbus_fmt	= ov6650_enum_fmt,
> > +	.cropcap	= ov6650_cropcap,
> > +	.g_crop		= ov6650_g_crop,
> > +	.s_crop		= ov6650_s_crop,
> > +	.g_parm		= ov6650_g_parm,
> > +	.s_parm		= ov6650_s_parm,
> > +
>
> Superfluous empty line

Mhm.

> > +};
> > +
> > +static struct v4l2_subdev_ops ov6650_subdev_ops = {
> > +	.core	= &ov6650_core_ops,
> > +	.video	= &ov6650_video_ops,
> > +};
> > +
> > +/*
> > + * i2c_driver function
> > + */
> > +static int ov6650_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *did)
> > +{
> > +	struct ov6650 *priv;
> > +	struct soc_camera_device *icd	= client->dev.platform_data;
>
> Nothing to align here, a space before "=" would suffice;)

OK.

> > +	struct soc_camera_link *icl;
> > +	int ret;
> > +
> > +	if (!icd) {
> > +		dev_err(&client->dev, "Missing soc-camera data!\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	icl = to_soc_camera_link(icd);
> > +	if (!icl) {
> > +		dev_err(&client->dev, "Missing platform_data for driver\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	priv = kzalloc(sizeof(struct ov6650), GFP_KERNEL);
> > +	if (!priv) {
> > +		dev_err(&client->dev,
> > +			"Failed to allocate memory for private data!\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	v4l2_i2c_subdev_init(&priv->subdev, client, &ov6650_subdev_ops);
> > +
> > +	icd->ops	= &ov6650_ops;
>
> A matter of taste, eventually, but I'd use a space.

OK.

> > +
> > +	ret = ov6650_video_probe(icd, client);
> > +
> > +	if (ret) {
> > +		icd->ops = NULL;
> > +		i2c_set_clientdata(client, NULL);
> > +		kfree(priv);
> > +	}
> > +
> > +	return ret;
> > +}

Thanks,
Janusz
