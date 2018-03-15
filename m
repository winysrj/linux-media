Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45440 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751314AbeCOI5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 04:57:51 -0400
Date: Thu, 15 Mar 2018 10:57:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH 08/12] media: ov5640: Adjust the clock based on the
 expected rate
Message-ID: <20180315085747.kagwxp2tanudr2nf@valkosipuli.retiisi.org.uk>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
 <20180302143500.32650-9-maxime.ripard@bootlin.com>
 <20180309111624.hexk74upa6s53r3t@valkosipuli.retiisi.org.uk>
 <20180313124937.zva652gt4dou7apj@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313124937.zva652gt4dou7apj@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 13, 2018 at 01:49:37PM +0100, Maxime Ripard wrote:
> Hi Sakari,
> 
> On Fri, Mar 09, 2018 at 01:16:24PM +0200, Sakari Ailus wrote:
> > > + *
> > > + *   +--------------+
> > > + *   |  Oscillator  |
> > 
> > I wonder if this should be simply called external clock, that's what the
> > sensor uses.
> 
> Ack
> 
> > > + *   +------+-------+
> > > + *          |
> > > + *   +------+-------+
> > > + *   | System clock | - reg 0x3035, bits 4-7
> > > + *   +------+-------+
> > > + *          |
> > > + *   +------+-------+ - reg 0x3036, for the multiplier
> > > + *   |     PLL      | - reg 0x3037, bits 4 for the root divider
> > > + *   +------+-------+ - reg 0x3037, bits 0-3 for the pre-divider
> > > + *          |
> > > + *   +------+-------+
> > > + *   |     SCLK     | - reg 0x3108, bits 0-1 for the root divider
> > > + *   +------+-------+
> > > + *          |
> > > + *   +------+-------+
> > > + *   |    PCLK      | - reg 0x3108, bits 4-5 for the root divider
> > > + *   +--------------+
> > > + *
> > > + * This is deviating from the datasheet at least for the register
> > > + * 0x3108, since it's said here that the PCLK would be clocked from
> > > + * the PLL. However, changing the SCLK divider value has a direct
> > > + * effect on the PCLK rate, which wouldn't be the case if both PCLK
> > > + * and SCLK were to be sourced from the PLL.
> > > + *
> > > + * These parameters also match perfectly the rate that is output by
> > > + * the sensor, so we shouldn't have too much factors missing (or they
> > > + * would be set to 1).
> > > + */
> > > +
> > > +/*
> > > + * FIXME: This is supposed to be ranging from 1 to 16, but the value
> > > + * is always set to either 1 or 2 in the vendor kernels.
> > 
> > There could be limits for the clock rates after the first divider. In
> > practice the clock rates are mostly one of the common frequencies (9,6; 12;
> > 19,2 or 24 MHz) so there's no need to use the other values.
> 
> There's probably some limits on the various combinations as well. I
> first tried to use the full range, and there was some combinations
> that were not usable, even though the clock rate should have been
> correct.

Apart from the multipliers and dividers, each node in the clock tree likely
has minimum and maximum frequencies. One way to try to figure out those
limits is to figure out which frequencies are used in existing mode
definitions. Sensor documentation seldom contains that information.

> 
> > > + */
> > > +#define OV5640_SYSDIV_MIN	1
> > > +#define OV5640_SYSDIV_MAX	2
> > > +
> > > +static unsigned long ov5640_calc_sysclk(struct ov5640_dev *sensor,
> > > +					unsigned long rate,
> > > +					u8 *sysdiv)
> > > +{
> > > +	unsigned long best = ~0;
> > > +	u8 best_sysdiv = 1;
> > > +	u8 _sysdiv;
> > > +
> > > +	for (_sysdiv = OV5640_SYSDIV_MIN;
> > > +	     _sysdiv <= OV5640_SYSDIV_MAX;
> > > +	     _sysdiv++) {
> > > +		unsigned long tmp;
> > > +
> > > +		tmp = sensor->xclk_freq / _sysdiv;
> > > +		if (abs(rate - tmp) < abs(rate - best)) {
> > > +			best = tmp;
> > > +			best_sysdiv = _sysdiv;
> > > +		}
> > > +
> > > +		if (tmp == rate)
> > > +			goto out;
> > > +	}
> > > +
> > > +out:
> > > +	*sysdiv = best_sysdiv;
> > > +	return best;
> > > +}
> > > +
> > > +/*
> > > + * FIXME: This is supposed to be ranging from 1 to 8, but the value is
> > > + * always set to 3 in the vendor kernels.
> > > + */
> > > +#define OV5640_PLL_PREDIV_MIN	3
> > > +#define OV5640_PLL_PREDIV_MAX	3
> > 
> > Same reasoning here than above. I might leave a comment documenting the
> > values the hardware supports, removing FIXME as this isn't really an issue
> > as far as I see.
> 
> Ok, I'll do it then
> 
> > > +
> > > +/*
> > > + * FIXME: This is supposed to be ranging from 1 to 2, but the value is
> > > + * always set to 1 in the vendor kernels.
> > > + */
> > > +#define OV5640_PLL_ROOT_DIV_MIN	1
> > > +#define OV5640_PLL_ROOT_DIV_MAX	1
> > > +
> > > +#define OV5640_PLL_MULT_MIN	4
> > > +#define OV5640_PLL_MULT_MAX	252
> > > +
> > > +static unsigned long ov5640_calc_pll(struct ov5640_dev *sensor,
> > > +				     unsigned long rate,
> > > +				     u8 *sysdiv, u8 *prediv, u8 *rdiv, u8 *mult)
> > > +{
> > > +	unsigned long best = ~0;
> > > +	u8 best_sysdiv = 1, best_prediv = 1, best_mult = 1, best_rdiv = 1;
> > > +	u8 _prediv, _mult, _rdiv;
> > > +
> > > +	for (_prediv = OV5640_PLL_PREDIV_MIN;
> > > +	     _prediv <= OV5640_PLL_PREDIV_MAX;
> > > +	     _prediv++) {
> > > +		for (_mult = OV5640_PLL_MULT_MIN;
> > > +		     _mult <= OV5640_PLL_MULT_MAX;
> > > +		     _mult++) {
> > > +			for (_rdiv = OV5640_PLL_ROOT_DIV_MIN;
> > > +			     _rdiv <= OV5640_PLL_ROOT_DIV_MAX;
> > > +			     _rdiv++) {
> > > +				unsigned long pll;
> > > +				unsigned long sysclk;
> > > +				u8 _sysdiv;
> > > +
> > > +				/*
> > > +				 * The PLL multiplier cannot be odd if
> > > +				 * above 127.
> > > +				 */
> > > +				if (_mult > 127 && !(_mult % 2))
> > > +					continue;
> > > +
> > > +				sysclk = rate * _prediv * _rdiv / _mult;
> > > +				sysclk = ov5640_calc_sysclk(sensor, sysclk,
> > > +							    &_sysdiv);
> > > +
> > > +				pll = sysclk / _rdiv / _prediv * _mult;
> > > +				if (abs(rate - pll) < abs(rate - best)) {
> > > +					best = pll;
> > > +					best_sysdiv = _sysdiv;
> > > +					best_prediv = _prediv;
> > > +					best_mult = _mult;
> > > +					best_rdiv = _rdiv;
> > 
> > The smiapp PLL calculator only accepts an exact match. That hasn't been an
> > issue previously, I wonder if this would work here, too.
> 
> I don't recall which one exactly, but I think at least 480p@30fps
> wasn't an exact match in our case. Given the insanely high blanking
> periods, we might reduce them in order to fall back to something
> exact, but I really wanted to be as close to what was already done in
> the bytes array as possible, given the already quite intrusive nature
> of the patches.

:-)

What's the target CSI-2 bus frequency (or pixel rate)? If you configure the
PLL without one, then you could end up having as high frequencies the
sensor allows but the host might not be able to handle them.

The smiapp driver uses a list of allowed frequencies for a given board
which effectively also ensures also EMC compatibility.

> 
> > I think you could remove the inner loop, too, if put what
> > ov5640_calc_sysclk() does here. You know the desired clock rate so you can
> > calculate the total divisor (_rdiv * sysclk divider).
> 
> I guess we can have two approaches here. Since most of the dividers
> are fixed, I could have a much simpler code anyway, or I could keep it
> that way if we ever want to extend it.
> 
> It seems you imply that you'd like something simpler, so I can even
> simplify much more than what's already there if you want.

It just seems that the complexity of this loop is somewhere around O(n^6)
even though most variables have a rather small set of possible values. The
et8ek8 driver used to have a mode list with similar complexity and the
handling of which actually noticeably slowed down the system. :-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
