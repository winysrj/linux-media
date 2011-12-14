Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1LNS6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 13:58:50 -0500
Date: Wed, 14 Dec 2011 19:58:45 +0100
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Vasut <marek.vasut@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3] v4l: Add driver for Micron MT9M032 camera sensor
References: <1323825633-10543-1-git-send-email-martin@neutronstar.dyndns.org>
 <201112140255.31937.marek.vasut@gmail.com>
 <1323846842.756509.13592@localhost>
 <201112141449.05926.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112141449.05926.laurent.pinchart@ideasonboard.com>
Message-Id: <1323889126.283763.19222@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 14, 2011 at 02:49:05PM +0100, Laurent Pinchart wrote:
> Hi Martin,
> 
> On Wednesday 14 December 2011 08:14:01 martin@neutronstar.dyndns.org wrote:
> > On Wed, Dec 14, 2011 at 02:55:31AM +0100, Marek Vasut wrote:
> > > > The MT9M032 is a parallel 1.6MP sensor from Micron controlled through
> > > > I2C.
> > > > 
> > > > The driver creates a V4L2 subdevice. It currently supports cropping,
> > > > gain, exposure and v/h flipping controls in monochrome mode with an
> > > > external pixel clock.
> > > > 
> > > > Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > > > ---
> 
> [snip]
> 
> > > > diff --git a/drivers/media/video/mt9m032.c
> > > > b/drivers/media/video/mt9m032.c new file mode 100644
> > > > index 0000000..b4159c7
> > > > --- /dev/null
> > > > +++ b/drivers/media/video/mt9m032.c
> > > > @@ -0,0 +1,819 @@
> 
> [snip]
> 
> > > > +static int mt9m032_read_reg(struct mt9m032 *sensor, u8 reg)
> > > > +{
> > > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > > +	s32 data = i2c_smbus_read_word_data(client, reg);
> > > > +
> > > > +	return data < 0 ? data : swab16(data);
> > > 
> > > Uhm ... why ?
> > 
> > error codes are not swab16-ed, data values are. Hardware needs swapping of
> > data values.
> 
> You can use i2c_smbus_read_word_swapped() and i2c_smbus_write_word_swapped().

Yes, i didn't notice that they have been added. Nicer to use them.

> 
> > > > +}
> > > > +
> > > > +static int mt9m032_write_reg(struct mt9m032 *sensor, u8 reg,
> > > > +		     const u16 data)
> > > > +{
> > > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > > +
> > > > +	return i2c_smbus_write_word_data(client, reg, swab16(data));
> > > > +}
> 
> [snip]
> 
> > > > +static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool
> > > > hflip) +{
> > > > +	int reg_val = (!!vflip) << MT9M032_READ_MODE2_VFLIP_SHIFT
> > > 
> > > !!(bool) ? hmm ...
> > 
> > a true bool can be any value except 0. !!bool is guaranteed to be either
> > 0 or 1 and this suitable for use in bitshifting to set a specific bit.
> 
> I'd use
> 
> 	int reg_val = (vflip ? MT9M032_READ_MODE2_VFLIP : 0)
> 	            | (hflip ? MT9M032_READ_MODE2_HFLIP : 0)
> 	...
> 
> but that might just be me.

I like shifts more, easy to check in the datasheet.

> 
> BTW, what about using fixed-size types for register values ? u16 would make 
> sense here.

I don't think i would make a difference here.

> 
> > > > +		      | (!!hflip) << MT9M032_READ_MODE2_HFLIP_SHIFT
> > > > +		      | MT9M032_READ_MODE2_ROW_BLC
> > > > +		      | 0x0007;
> > > > +
> > > > +	return mt9m032_write_reg(sensor, MT9M032_READ_MODE2, reg_val);
> > > > +}
> 
> [snip]
> 
> > > > +static int mt9m032_set_gain(struct mt9m032 *sensor, s32 val)
> > > > +{
> > > > +	int digital_gain_val;	/* in 1/8th (0..127) */
> > > > +	int analog_mul;		/* 0 or 1 */
> > > > +	int analog_gain_val;	/* in 1/16th. (0..63) */
> > > > +	u16 reg_val;
> > > > +
> > > > +	digital_gain_val = 51; /* from setup example */
> > > > +
> > > > +	if (val < 63) {
> > > > +		analog_mul = 0;
> > > > +		analog_gain_val = val;
> > > > +	} else {
> > > > +		analog_mul = 1;
> > > > +		analog_gain_val = val / 2;
> > > > +	}
> > > > +
> > > > +	/* a_gain = (1+analog_mul) + (analog_gain_val+1)/16 */
> > > > +	/* overall_gain = a_gain * (1 + digital_gain_val / 8) */
> > > > +
> > > > +	reg_val = (digital_gain_val & MT9M032_GAIN_DIGITAL_MASK) <<
> > > > MT9M032_GAIN_DIGITAL_SHIFT +		  | (analog_mul & 1) <<
> > > > MT9M032_GAIN_AMUL_SHIFT
> > > > +		  | (analog_gain_val & MT9M032_GAIN_ANALOG_MASK);
> > > > +
> > > > +	return mt9m032_write_reg(sensor, MT9M032_GAIN_ALL, reg_val);
> > > > +}
> 
> Lot's of Aptina sensors have a similar gain setup with two or three stages. Do 
> you think it would be worth it creating a function that could be shared 
> between them ?

I don't have time to work on such an extension in a meaningful way.
I'm not sure what's the best way to use this kind of staged gain hardware
best anyway.

> 
> > > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > > +{
> > > > +	struct mt9m032_platform_data* pdata = sensor->pdata;
> > > > +	u16 reg_pll1;
> > > > +	unsigned int pre_div;
> > > > +	int res, ret;
> > > > +
> > > > +	/* TODO: also support other pre-div values */
> 
> I might already have mentioned this, but wouldn't it be time to work a on real 
> PLL setup code that compute the pre-divisor, multiplier and output divisor 
> dynamically from the input and output clock frequencies ?

I'm not sure what the implications for quality and stability of such a
generic setup would be. My gut feeling is most users go with known working
hardcoded values.

Also in the datasheet i have access to, this is totally underdocumented.

> 
> > > > +	if (pdata->pll_pre_div != 6) {
> > > > +		dev_warn(to_dev(sensor),
> > > > +			"Unsupported PLL pre-divisor value %u, using default
> > > 
> > > 6\n",
> > > 
> > > > +			pdata->pll_pre_div);
> > > > +	}
> > > > +	pre_div = 6;
> > > > +
> > > > +	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
> > > > +		(pre_div * pdata->pll_out_div);
> > > > +
> > > > +	reg_pll1 = ((pdata->pll_out_div - 1) &
> > > > MT9M032_PLL_CONFIG1_OUTDIV_MASK) +		   | pdata->pll_mul <<
> > > > MT9M032_PLL_CONFIG1_MUL_SHIFT;
> > > > +
> > > > +	ret = mt9m032_write_reg(sensor, MT9M032_PLL_CONFIG1, reg_pll1);
> > > > +	if (!ret)
> > > > +		ret = mt9m032_write_reg(sensor, 0x10, 0x53); /* Select PLL as
> > > 
> > > clock
> > > 
> > > > source */ +
> > > 
> > > urm ... magic ... black magic ...
> > 
> > yes, indeed. But i don't have any more information.
> > The datasheet nicely states "reserved" and in the bringup section
> > "poke in these magical values, please". :/ Not even a register name.
> 
> What version of the datasheet do you have ? According to the MT9P031 

Rev. B 10/07 EN

> datasheet, register 0x10 is called PLL Control and bits 0 and 1 are described 
> as
> 
> 1	Use PLL
> When set, use the PLL output as the system clock. When clear, use EXTCLK as 
> the system clock.
> 0	Power PLL
> When set, the PLL is powered. When clear, it is not powered.
> 
> The other bits are not documented. The mt9p031 driver has
> 
> #define MT9P031_PLL_CONTROL                             0x10
> #define         MT9P031_PLL_CONTROL_PWROFF              0x0050
> #define         MT9P031_PLL_CONTROL_PWRON               0x0051
> #define         MT9P031_PLL_CONTROL_USEPLL              0x0052
> 
> which you could reuse.

Yes, it seems close enough. But i'm a bit uneasy about mixing from
different datasheets. Would i keep the original names so everybody can see
that it's from a data sheet of a similar but different hardware?

It would be
MT9P031_PLL_CONTROL_PWRON | MT9P031_PLL_CONTROL_USEPLL
then witch resolves to a slightly odd 0x0051 | 0x0052.

> 
> > > > +	if (!ret)
> > > > +		ret = mt9m032_write_reg(sensor, MT9M032_READ_MODE1, 0x8006);
> > > > +							/* more reserved, Continuous */
> > > > +							/* Master Mode */
> > > > +	if (!ret)
> > > > +		res = mt9m032_read_reg(sensor, MT9M032_READ_MODE1);
> > > > +
> > > > +	if (!ret)
> > > > +		ret = mt9m032_write_reg(sensor, MT9M032_FORMATTER1, 0x111e);
> > > > +					/* Set 14-bit mode, select 7 divider */
> > > > +
> > > > +	return ret;
> > > > +}
> 
> 
> [snip]
> 
> > > > +	/*
> > > > +* This driver was developed with a camera module with seperate external
> > > > +* pix clock. For setups which use the clock from the camera interface
> > > > +* the code will need to be extended with the appropriate platform
> > > > +* callback to setup the clock.
> > > > +	 */
> > > > +	chip_version = mt9m032_read_reg(sensor, MT9M032_CHIP_VERSION);
> > > > +	if (0x1402 == chip_version) {
> > > 
> > > So I suspect this can also cast fireballs ? Also, why do you use Yoda
> > > conditions here ? Please run checkpatch.pl on this too just to be sure.
> > 
> > No fireball was visible when looking at the hardware.
> 
> #define         MT9M032_CHIP_VERSION_VALUE              0x1402
> 
> is an option (not sure if it prevents fireballs though).

I don't think it will prevent any burns or fires.
But i'll add it anyway, it's clear enough.

> 
> > > > +		dev_info(&client->dev, "mt9m032: detected sensor.\n");
> > > > +	} else {
> > > > +		dev_warn(&client->dev, "mt9m032: error: detected unsupported
> > > chip version 0x%x\n",
> > > > +			 chip_version);
> > > > +		ret = -ENODEV;
> > > > +		goto free_sensor;
> > > > +	}
> 
> [snip]
> 
> > > > +static int __init mt9m032_init(void)
> > > > +{
> > > > +	int rval;
> > > > +
> > > > +	rval = i2c_add_driver(&mt9m032_i2c_driver);
> > > > +	if (rval)
> > > > +		pr_err("%s: failed registering " MT9M032_NAME "\n", __func__);
> > > > +
> > > > +	return rval;
> > > > +}
> > > > +
> > > > +static void mt9m032_exit(void)
> > > > +{
> > > > +	i2c_del_driver(&mt9m032_i2c_driver);
> > > > +}
> > > > +
> > > > +module_init(mt9m032_init);
> > > > +module_exit(mt9m032_exit);
> 
> v3.3 will have a very handy module_i2c_driver() macro. See 
> https://lkml.org/lkml/2011/11/17/36

If you think i should do that i can. Looses a bit verboseness in case of
errors, but i don't think it matters.

For me both ways are ok.

> 
> > > > +MODULE_AUTHOR("Martin Hostettler");
> > > > +MODULE_DESCRIPTION("MT9M032 camera sensor driver");
> > > > +MODULE_LICENSE("GPL v2");
> 
> -- 
> Regards,
> 
> Laurent Pinchart
