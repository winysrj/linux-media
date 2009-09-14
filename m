Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49944 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755652AbZINOld (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 10:41:33 -0400
Date: Mon, 14 Sep 2009 16:41:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
In-Reply-To: <200909141626.58217.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909141635220.4359@axis700.grange>
References: <200908220850.07435.marek.vasut@gmail.com>
 <200909042225.59000.marek.vasut@gmail.com> <Pine.LNX.4.64.0909102330070.4458@axis700.grange>
 <200909141626.58217.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Sep 2009, Marek Vasut wrote:

[snip]

> > > +/* NOTE: The RGB555X format still has issues, so it's left out. */
> > > +static const struct soc_camera_data_format ov9640_fmt_lists[] = {
> > > +{
> > > +	.name		= "VYUY",
> > > +	.fourcc		= V4L2_PIX_FMT_VYUY,
> > > +	.depth		= 16,
> > > +	.colorspace	= V4L2_COLORSPACE_JPEG,
> > > +},
> > > +{
> > > +	.name		= "RGB565X",
> > > +	.fourcc		= V4L2_PIX_FMT_RGB565X,
> > 
> > Hm, so, do we keep RGB565X here or do we add a BGR565? We'll anyway have
> > to do that when converting to imagebus, so, better do it right straight
> > away, to avoid having to modify user-space apps.
> 
> I changed this, but the RGB can still possibly be broken (can be fixed later). 

Well, no, sorry, I do not think it's a good idea to commit code, that we 
believe does not work. Then, please, remove RGB codes and add a TODO comment.

> The yuv works fine (and with the register tweak I did it's even more standard-
> conformant).

Ok.

> > > +/* read a register */
> > > +static int ov9640_reg_read(struct i2c_client *client, u8 reg, u8 *val)
> > > +{
> > > +	int ret;
> > > +	u8 data = reg;
> > > +	struct i2c_msg msg = {
> > > +		.addr	= client->addr,
> > > +		.flags	= 0,
> > > +		.len	= 1,
> > > +		.buf	= &data,
> > > +	};
> > > +
> > > +	ret = i2c_transfer(client->adapter, &msg, 1);
> > 
> > Are there any advantages in using raw i2c operations over smbus calls? The
> > latter look much simpler, cf., e.g., mt9m001:
> > 
> > static int reg_read(struct i2c_client *client, const u8 reg)
> > {
> > 	s32 data = i2c_smbus_read_word_data(client, reg);
> > 	return data < 0 ? data : swab16(data);
> > }
> > 
> > static int reg_write(struct i2c_client *client, const u8 reg,
> > 		     const u16 data)
> > {
> > 	return i2c_smbus_write_word_data(client, reg, swab16(data));
> > }
> > 
> > Ok, going through smbus layer takes a bit of time, but that's just done
> > during configuration.
> 
> Yes, the sensor doesnt work with SMBUS calls, that's why those are there. It 
> took me a while to figure it out.

Ok, then we should remove the check for SMBUS in probing.

> > > +/* program default register values */
> > > +static int ov9640_prog_dflt(struct i2c_client *client)
> > > +{
> > > +	int i, ret;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(ov9640_regs_dflt); i++) {
> > > +		ret = ov9640_reg_write(client, ov9640_regs_dflt[i].reg,
> > > +						ov9640_regs_dflt[i].val);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	/* wait for the changes to actually happen */
> > > +	mdelay(150);
> > 
> > I still think that's a lot. Have you tried any lower values? I would try
> > 50ms, if that works, try 10ms...
> 
> You are free to try, I'm not doing anything about this. It doesnt work with 
> lower values, period.

So, you did try it? Ok, then at least add a comment specifying whichlargest 
value didn't work for you.

> > > +	/*
> > > +	 * We must have a parent by now. And it cannot be a wrong one.
> > > +	 * So this entire test is completely redundant.
> > > +	 */
> > > +	if (!icd->dev.parent ||
> > > +	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface) {
> > > +		dev_err(&icd->dev, "Parent missing or invalid!\n");
> > 
> > Please, see
> > http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;
> > h=d680a88e84792f84310042919065c90c5eb87423

Please adjust your dev_{dbg,err,warn,info} calls according to that patch.

> > > +/*
> > > + * i2c_driver function
> > > + */
> > > +static int ov9640_probe(struct i2c_client *client,
> > > +			 const struct i2c_device_id *did)
> > > +{
> > > +	struct ov9640_priv *priv;
> > > +	struct i2c_adapter *adapter	= to_i2c_adapter(client->dev.parent);
> > > +	struct soc_camera_device *icd	= client->dev.platform_data;
> > > +	struct soc_camera_link *icl;
> > > +	int ret;
> > > +
> > > +	if (!icd) {
> > > +		dev_err(&client->dev, "Missing soc-camera data!\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	icl = to_soc_camera_link(icd);
> > > +	if (!icl) {
> > > +		dev_err(&client->dev, "Missing platform_data for driver\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
> > 
> > You're not using smbus calls, so, don't need this check. Or switch to
> > using them:-)

And remove this.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
