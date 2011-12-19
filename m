Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37197 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1LSKnW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 05:43:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH v3] v4l: Add driver for Micron MT9M032 camera sensor
Date: Mon, 19 Dec 2011 11:43:23 +0100
Cc: Marek Vasut <marek.vasut@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1323825633-10543-1-git-send-email-martin@neutronstar.dyndns.org> <201112141449.05926.laurent.pinchart@ideasonboard.com> <1323889126.283763.19222@localhost>
In-Reply-To: <1323889126.283763.19222@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112191143.24254.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Wednesday 14 December 2011 19:58:45 Martin Hostettler wrote:
> On Wed, Dec 14, 2011 at 02:49:05PM +0100, Laurent Pinchart wrote:
> > On Wednesday 14 December 2011 08:14:01 Martin Hostettler wrote:
> > > On Wed, Dec 14, 2011 at 02:55:31AM +0100, Marek Vasut wrote:
> > > > > The MT9M032 is a parallel 1.6MP sensor from Micron controlled
> > > > > through I2C.
> > > > > 
> > > > > The driver creates a V4L2 subdevice. It currently supports
> > > > > cropping, gain, exposure and v/h flipping controls in monochrome
> > > > > mode with an external pixel clock.
> > > > > 
> > > > > Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > > > > ---

[snip]

> > > > > +static int update_read_mode2(struct mt9m032 *sensor, bool vflip,
> > > > > bool hflip) +{
> > > > > +	int reg_val = (!!vflip) << MT9M032_READ_MODE2_VFLIP_SHIFT
> > > > 
> > > > !!(bool) ? hmm ...
> > > 
> > > a true bool can be any value except 0. !!bool is guaranteed to be
> > > either 0 or 1 and this suitable for use in bitshifting to set a
> > > specific bit.
> > 
> > I'd use
> > 
> > 	int reg_val = (vflip ? MT9M032_READ_MODE2_VFLIP : 0)
> > 	
> > 	            | (hflip ? MT9M032_READ_MODE2_HFLIP : 0)
> > 	
> > 	...
> > 
> > but that might just be me.
> 
> I like shifts more, easy to check in the datasheet.

That's a matter of taste I guess. I personnally find the second option more 
readable.

> > BTW, what about using fixed-size types for register values ? u16 would
> > make sense here.
> 
> I don't think i would make a difference here.

It won't make much of a difference, but it makes the code clearer in my 
opinion (otherwise I wouldn't have proposed it :-)).

> > > > > +		      | (!!hflip) << MT9M032_READ_MODE2_HFLIP_SHIFT
> > > > > +		      | MT9M032_READ_MODE2_ROW_BLC
> > > > > +		      | 0x0007;
> > > > > +
> > > > > +	return mt9m032_write_reg(sensor, MT9M032_READ_MODE2, reg_val);
> > > > > +}

[snip]

> > > > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > > > +{
> > > > > +	struct mt9m032_platform_data* pdata = sensor->pdata;
> > > > > +	u16 reg_pll1;
> > > > > +	unsigned int pre_div;
> > > > > +	int res, ret;
> > > > > +
> > > > > +	/* TODO: also support other pre-div values */
> > 
> > I might already have mentioned this, but wouldn't it be time to work a on
> > real PLL setup code that compute the pre-divisor, multiplier and output
> > divisor dynamically from the input and output clock frequencies ?
> 
> I'm not sure what the implications for quality and stability of such a
> generic setup would be. My gut feeling is most users go with known working
> hardcoded values.

That won't be future-proof. We will need DT bindings in the near future, and 
PLL parameters won't be there. That's one of the reasons why they should be 
computed automatically.

Regarding quality and stability, let's just write code that produces PLL 
parameters values identical to the ones you would otherwise hardcode manually 
:-)

> Also in the datasheet i have access to, this is totally underdocumented.

I'm pretty sure the MT9P031 documentation applies here.

> > > > > +	if (pdata->pll_pre_div != 6) {
> > > > > +		dev_warn(to_dev(sensor),
> > > > > +			"Unsupported PLL pre-divisor value %u, using default
> > > > 
> > > > 6\n",
> > > > 
> > > > > +			pdata->pll_pre_div);
> > > > > +	}
> > > > > +	pre_div = 6;
> > > > > +
> > > > > +	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
> > > > > +		(pre_div * pdata->pll_out_div);
> > > > > +
> > > > > +	reg_pll1 = ((pdata->pll_out_div - 1) &
> > > > > MT9M032_PLL_CONFIG1_OUTDIV_MASK) +		   | pdata->pll_mul <<
> > > > > MT9M032_PLL_CONFIG1_MUL_SHIFT;
> > > > > +
> > > > > +	ret = mt9m032_write_reg(sensor, MT9M032_PLL_CONFIG1, reg_pll1);
> > > > > +	if (!ret)
> > > > > +		ret = mt9m032_write_reg(sensor, 0x10, 0x53); /* Select PLL as
> > > > 
> > > > clock
> > > > 
> > > > > source */ +
> > > > 
> > > > urm ... magic ... black magic ...
> > > 
> > > yes, indeed. But i don't have any more information.
> > > The datasheet nicely states "reserved" and in the bringup section
> > > "poke in these magical values, please". :/ Not even a register name.
> > 
> > What version of the datasheet do you have ? According to the MT9P031
> 
> Rev. B 10/07 EN

I'll see if I can get something newer.

> > datasheet, register 0x10 is called PLL Control and bits 0 and 1 are
> > described as
> > 
> > 1	Use PLL
> > When set, use the PLL output as the system clock. When clear, use EXTCLK
> > as the system clock.
> > 0	Power PLL
> > When set, the PLL is powered. When clear, it is not powered.
> > 
> > The other bits are not documented. The mt9p031 driver has
> > 
> > #define MT9P031_PLL_CONTROL                             0x10
> > #define         MT9P031_PLL_CONTROL_PWROFF              0x0050
> > #define         MT9P031_PLL_CONTROL_PWRON               0x0051
> > #define         MT9P031_PLL_CONTROL_USEPLL              0x0052
> > 
> > which you could reuse.
> 
> Yes, it seems close enough. But i'm a bit uneasy about mixing from
> different datasheets. Would i keep the original names so everybody can see
> that it's from a data sheet of a similar but different hardware?

I'd use MT9M032, with a comment right above the definitions stating that they 
come from the MT9P031 documentation.

> It would be
> MT9P031_PLL_CONTROL_PWRON | MT9P031_PLL_CONTROL_USEPLL
> then witch resolves to a slightly odd 0x0051 | 0x0052.

Yes it's a bit odd, but that's the best I've been able to find :-)

> > > > > +	if (!ret)
> > > > > +		ret = mt9m032_write_reg(sensor, MT9M032_READ_MODE1, 0x8006);
> > > > > +							/* more reserved, Continuous */
> > > > > +							/* Master Mode */
> > > > > +	if (!ret)
> > > > > +		res = mt9m032_read_reg(sensor, MT9M032_READ_MODE1);
> > > > > +
> > > > > +	if (!ret)
> > > > > +		ret = mt9m032_write_reg(sensor, MT9M032_FORMATTER1, 0x111e);
> > > > > +					/* Set 14-bit mode, select 7 divider */
> > > > > +
> > > > > +	return ret;
> > > > > +}

[snip]

> > > > > +static int __init mt9m032_init(void)
> > > > > +{
> > > > > +	int rval;
> > > > > +
> > > > > +	rval = i2c_add_driver(&mt9m032_i2c_driver);
> > > > > +	if (rval)
> > > > > +		pr_err("%s: failed registering " MT9M032_NAME "\n", __func__);
> > > > > +
> > > > > +	return rval;
> > > > > +}
> > > > > +
> > > > > +static void mt9m032_exit(void)
> > > > > +{
> > > > > +	i2c_del_driver(&mt9m032_i2c_driver);
> > > > > +}
> > > > > +
> > > > > +module_init(mt9m032_init);
> > > > > +module_exit(mt9m032_exit);
> > 
> > v3.3 will have a very handy module_i2c_driver() macro. See
> > https://lkml.org/lkml/2011/11/17/36
> 
> If you think i should do that i can. Looses a bit verboseness in case of
> errors, but i don't think it matters.
> 
> For me both ways are ok.

Many drivers have been moved to module_*_driver(), I think that's the 
preferred way.

-- 
Regards,

Laurent Pinchart
