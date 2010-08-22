Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56295 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752424Ab0HVUaN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Aug 2010 16:30:13 -0400
Date: Sun, 22 Aug 2010 22:30:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RFC] [PATCH 3/6] SoC Camera: add driver for OV6650 sensor
In-Reply-To: <201008222145.40942.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1008222201140.872@axis700.grange>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl>
 <201007180624.45693.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1008131203310.31714@axis700.grange>
 <201008222145.40942.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sun, 22 Aug 2010, Janusz Krzysztofik wrote:

> Hi Guennadi,
> Thanks for your review time.
> 
> Sunday 22 August 2010 18:40:13 Guennadi Liakhovetski wrote:
> > On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:
> > > This patch provides a V4L2 SoC Camera driver for OV6650 camera sensor,
> > > found on OMAP1 SoC based Amstrad Delta videophone.
> >
> > Have you also had a look at drivers/media/video/gspca/sonixb.c - in also
> > supports ov6650 among other sensors.
> 
> Yes, I have, but given up for now since:
> 1. the gspca seems using the sensor in "Bayer 8 BGGR" mode only, which I was 
>    not even able to select using mplayer to test my drivers with,
> 2. not all settings used there are clear for me, so I've decided to revisit 
>    them later, when I first get a stable, even if not perfect, working driver 
>    version accepted, instead of following them blindly.

But good that you've looked at it.

> > > +	unsigned char data[2] = { reg, val };
> > > +	struct i2c_msg msg = {
> > > +		.addr	= client->addr,
> > > +		.flags	= 0,
> > > +		.len	= 2,
> > > +		.buf	= data,
> > > +	};
> > > +
> > > +	ret = i2c_transfer(client->adapter, &msg, 1);
> > > +	if (ret < 0) {
> > > +		dev_err(&client->dev, "Failed writing register 0x%02x!\n", reg);
> > > +		return ret;
> > > +	}
> > > +	msleep(1);
> >
> > Hm, interesting... Is this really needed?
> 
> If you mean msleep(1) - yes, the sensor didn't work correctly for me without 
> that msleep().

Yes, I meant msleep(1).

> I you mean reading the register back - I've not tried without, will do.

Ok.

> > > +	case V4L2_CID_HUE_AUTO:
> > > +		if (ctrl->value) {
> > > +			ret = ov6650_reg_rmw(client, REG_HUE,
> > > +					SET_HUE(DEF_HUE), SET_HUE(HUE_MASK));
> > > +			if (ret)
> > > +				break;
> > > +			priv->hue = DEF_HUE;
> > > +		} else {
> > > +			ret = ov6650_reg_rmw(client, REG_HUE, HUE_EN, 0);
> > > +		}
> > > +		if (ret)
> > > +			break;
> > > +		priv->hue_auto = ctrl->value;
> >
> > Hm, sorry, don't understand. If the user sets auto-hue to ON, you set the
> > hue enable bit and hue value to default. 
> 
> No, I reset the hue enable bit here, which I understand is used for applying a 
> non-default hue value if set rather than enabling auto hue. Maybe my 
> understanding of this bit function is wrong.
> 
> > If the user sets auto-hue to OFF, 
> > you just set the hue enable bit on and don't change the value. Does ov6650
> > actually support auto-hue?
> 
> All I was able to find out was the HUE register bits described like this:
> 
> Bit[7:6]: Reserved
> Bit[5]: Hue Enable
> Bit[4:0]: Hue setting
> 
> and the register default value: 0x10.
> 
> What do you think the bit[5] meaning is?

Well, from how I interpret, what you say, I think, there is no auto-hue 
implemented by this sensor, at least, not by this register. Maybe drop 
auto-hue support completely? It seems to me just a manual hue value can be 
set.

> > > +/* select nearest higher resolution for capture */
> > > +static void ov6650_res_roundup(u32 *width, u32 *height)
> > > +{
> > > +	int i;
> > > +	enum { QCIF, CIF };
> > > +	int res_x[] = { 176, 352 };
> > > +	int res_y[] = { 144, 288 };
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(res_x); i++) {
> > > +		if (res_x[i] >= *width && res_y[i] >= *height) {
> > > +			*width = res_x[i];
> > > +			*height = res_y[i];
> > > +			return;
> > > +		}
> > > +	}
> > > +
> > > +	*width = res_x[CIF];
> > > +	*height = res_y[CIF];
> > > +}
> >
> > This can be replaced by a version of
> >
> > http://www.spinics.net/lists/linux-media/msg21893.html
> >
> > when it is fixed and accepted;) I'll try to send an updated version of
> > that patch tomorrow.
> 
> Fine, I'll use this instead of my dirty workarounds.

/me has to update that patch... Will try to do that asap.

> > > +
> > > +/* program default register values */
> > > +static int ov6650_prog_dflt(struct i2c_client *client)
> > > +{
> > > +	int i, ret;
> > > +
> > > +	dev_dbg(&client->dev, "reinitializing\n");
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(ov6650_regs_dflt); i++) {
> > > +		ret = ov6650_reg_write(client, ov6650_regs_dflt[i].reg,
> > > +						ov6650_regs_dflt[i].val);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> >
> > Hm, please, don't. I generally don't like such register - value array
> > magic for a number of reasons, and in your case it's just one (!) register
> > write operation - please, remove this array and just write the register
> > explicitly. 
> 
> OK (with a reservation that I can probably end up with more than just one, 
> non-default settings written explicitly).

Thas's ok. I find a sequence of explicit register writes nicer, e.g., 
because then you can insert comments / delays / meaningful debugging / 
other branching between them. Pushing an array of register values to the 
hardware looks like "no idea what this stuff is good for, I just copied 
this from vendor's example / sniffed from the hardware..."

> > > +	ret = ov6650_reg_write(client, REG_HSTRT, hstrt);
> > > +	if (!ret)
> > > +		ret = ov6650_reg_write(client, REG_HSTOP, hstop);
> > > +	if (!ret)
> > > +		ret = ov6650_reg_write(client, REG_VSTRT, vstrt);
> > > +	if (!ret)
> > > +		ret = ov6650_reg_write(client, REG_VSTOP, vstop);
> >
> > Are cropping and scaling on this camera absolutely independent? I.e., you
> > can set any output format (CIF or QCIF) and it will just scale whatever
> > rectangle has been configured? And the other way round - you set arbitrary
> > cropping and output format stays the same?
> 
> I believe it works like I have put it here, but will try to recheck to make 
> sure. Simply using v4l2-debug for this seems insufficient, since changing a 
> frame format on the fly will get DMA out of sync immediately. What tool or 
> utility could you advise for testing?

firstly, soc-camera is quite restrictive about s_crop ATM: it disallows 
changes to the cropping sizes (only position can be changed). Whereby, now 
that I think about it again, perhaps this wasn't a very good idea: 
effectively this kills live zooming. Maybe we can lift that restriction 
again. In any case, I don't know any existing programs, that can stream 
video and simultaneously allow the user to issue crop and scale commands. 
I just hacked mplayer and gstreamer for that. Or, to test changing left 
and top offsets, I had mplayer running and issued crops and scales from 
another window with a command-line tool like v4l2-dbg.

> > > +static struct v4l2_subdev_video_ops ov6650_video_ops = {
> > > +	.s_stream	= ov6650_s_stream,
> > > +	.s_mbus_fmt	= ov6650_s_fmt,
> > > +	.try_mbus_fmt	= ov6650_try_fmt,
> >
> > Please, implement.g_mbus_fmt.
> 
> OK (in addition to what I've already implemented, I guess).

Of course

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
