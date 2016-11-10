Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51761 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752287AbcKJIq4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 03:46:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [RFC 1/5] media: i2c: max2175: Add MAX2175 support
Date: Thu, 10 Nov 2016 10:46:56 +0200
Message-ID: <5646490.suYeSea0Qa@avalon>
In-Reply-To: <SG2PR06MB1038BC62A3011C8EAB20B61FC3D40@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <2034831.3otZHvJ6bZ@avalon> <SG2PR06MB1038BC62A3011C8EAB20B61FC3D40@SG2PR06MB1038.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

On Friday 21 Oct 2016 14:49:30 Ramesh Shanmugasundaram wrote:
> > On Wednesday 12 Oct 2016 15:10:25 Ramesh Shanmugasundaram wrote:
> >> This patch adds driver support for MAX2175 chip. This is Maxim
> >> Integrated's RF to Bits tuner front end chip designed for
> >> software-defined radio solutions. This driver exposes the tuner as a
> >> sub-device instance with standard and custom controls to configure the
> >> device.
> >>
> >> Signed-off-by: Ramesh Shanmugasundaram
> >> <ramesh.shanmugasundaram@bp.renesas.com> ---
> >> 
> >>  .../devicetree/bindings/media/i2c/max2175.txt      |   60 +
> >>  drivers/media/i2c/Kconfig                          |    4 +
> >>  drivers/media/i2c/Makefile                         |    2 +
> >>  drivers/media/i2c/max2175/Kconfig                  |    8 +
> >>  drivers/media/i2c/max2175/Makefile                 |    4 +
> >>  drivers/media/i2c/max2175/max2175.c                | 1624 +++++++++++++
> >>  drivers/media/i2c/max2175/max2175.h                |  124 ++
> >>  7 files changed, 1826 insertions(+)
> >>  create mode 100644
> >> Documentation/devicetree/bindings/media/i2c/max2175.txt
> >>  create mode 100644 drivers/media/i2c/max2175/Kconfig  create mode
> >> 100644 drivers/media/i2c/max2175/Makefile
> >>  create mode 100644 drivers/media/i2c/max2175/max2175.c
> >>  create mode 100644 drivers/media/i2c/max2175/max2175.h
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt
> >> b/Documentation/devicetree/bindings/media/i2c/max2175.txt new file
> >> mode 100644
> >> index 0000000..2250d5f
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> >> @@ -0,0 +1,60 @@

[snip]

> >> +Optional properties:
> >> +--------------------
> >> +- maxim,slave	   : empty property indicates this is a slave of
> >> another
> >> +		     master tuner. This is used to define two tuners in
> >> +		     diversity mode (1 master, 1 slave). By default each
> >> +		     tuner is an individual master.
> > 
> > Would it be useful to make that property a phandle to the master tuner, to
> > give drivers a way to access the master ? I haven't checked whether there
> > could be use cases for that.
> 
> As of now, I cannot find any use case for it from the datasheet. In future,
> we could add if such need arise.

My point is that making the maxim,slave property a phandle now would allow 
handling such future cases without any change to the DT bindings.

[snip]

> > > diff --git a/drivers/media/i2c/max2175/max2175.c
> > > b/drivers/media/i2c/max2175/max2175.c new file mode 100644 index
> > > 0000000..71b60c2
> > > --- /dev/null
> > > +++ b/drivers/media/i2c/max2175/max2175.c

[snip]

> > > +static int max2175_poll_csm_ready(struct max2175_ctx *ctx) {
> > > +	return max2175_poll_timeout(ctx, 69, 1, 1, 0, 50);
> > 
> > Please define macros for register addresses and values, this is just
> > unreadable.
> 
> The Tuner provider is unwilling to disclose all register details. I agree on
> the readability issue with this restriction but this is somewhat true for
> some sensitive IPs in the media subsystem.

Is it the case that you don't have access to the information, or that you have 
been forbidden to disclose them by the tuner manufacturer ?

> > > +}

[snip]

> > > +static int max2175_set_lo_freq(struct max2175_ctx *ctx, u64 lo_freq)
> > > +{
> > > +	int ret;
> > > +	u32 lo_mult;
> > > +	u64 scaled_lo_freq;
> > > +	const u64 scale_factor = 1000000ULL;
> > > +	u64 scaled_npf, scaled_integer, scaled_fraction;
> > > +	u32 frac_desired, int_desired;
> > > +	u8 loband_bits, vcodiv_bits;
> > 
> > Do you really support frequencies above 4GHz ?
> 
> Nope.
> 
> If not most of the 64-bit
> 
> > values could be stored in 32 bits.
> 
> The 64bit variables are needed to extract the fractional part (upto 6 digit
> precision) out of floating point divisions (original user space code).

OK. The code would be more efficient if you made the scaling factor a power of 
two though. 1048576 could be a good value.

> >> +
> >> +	scaled_lo_freq = lo_freq;
> >> +	/* Scale to larger number for precision */
> >> +	scaled_lo_freq = scaled_lo_freq * scale_factor * 100;

I just noticed that you could write the two lines as

	scaled_lo_freq = lo_freq * scale_factor * 100;

By the way, why do you multiply by 100 here, and...

> >> +	mxm_dbg(ctx, "scaled lo_freq %llu lo_freq %llu\n",
> >> +		scaled_lo_freq, lo_freq);
> >> +
> >> +	if (MAX2175_IS_BAND_AM(ctx)) {
> >> +		if (max2175_get_bit(ctx, 5, 7) == 0)
> >> +			loband_bits = 0;
> >> +			vcodiv_bits = 0;
> >> +			lo_mult = 16;
> >> +	} else if (max2175_get_bits(ctx, 5, 1, 0) == MAX2175_BAND_FM) {
> >> +		if (lo_freq <= 74700000) {
> >> +			loband_bits = 0;
> >> +			vcodiv_bits = 0;
> >> +			lo_mult = 16;
> >> +		} else if ((lo_freq > 74700000) && (lo_freq <= 110000000)) {
> > 
> > No need for the inner parentheses.
> 
> Agreed.
> 
> >> +			loband_bits = 1;
> >> +			vcodiv_bits = 0;
> >> +		} else {
> >> +			loband_bits = 1;
> >> +			vcodiv_bits = 3;
> >> +		}
> >> +		lo_mult = 8;
> >> +	} else if (max2175_get_bits(ctx, 5, 1, 0) == MAX2175_BAND_VHF) {
> >> +		if (lo_freq <= 210000000) {
> >> +			loband_bits = 2;
> >> +			vcodiv_bits = 2;
> >> +		} else {
> >> +			loband_bits = 2;
> >> +			vcodiv_bits = 1;
> >> +		}
> >> +		lo_mult = 4;
> >> +	} else {
> >> +		loband_bits = 3;
> >> +		vcodiv_bits = 2;
> >> +		lo_mult = 2;
> >> +	}
> >> +
> >> +	if (max2175_get_bits(ctx, 5, 1, 0) == MAX2175_BAND_L)
> >> +		scaled_npf = (scaled_lo_freq / ctx->xtal_freq / lo_mult) /
> >> 100;
> >> +	else
> >> +		scaled_npf = (scaled_lo_freq / ctx->xtal_freq * lo_mult) /
> >> 100;

... divide by 100 here without using the value in-between nor after ?

> >> +
> >> +	scaled_integer = scaled_npf / scale_factor * scale_factor;
> >> +	int_desired = (u32)(scaled_npf / scale_factor);
> >> +	scaled_fraction = scaled_npf - scaled_integer;
> >> +	frac_desired = (u32)(scaled_fraction * 1048576 / scale_factor);
> >> +
> >> +	/* Check CSM is not busy */
> >> +	ret = max2175_poll_csm_ready(ctx);
> >> +	if (ret) {
> >> +		v4l2_err(ctx->client, "lo_freq: csm busy. freq %llu\n",
> >> +			 lo_freq);
> >> +		return ret;
> >> +	}
> >> +
> >> +	mxm_dbg(ctx, "loband %u vcodiv %u lo_mult %u scaled_npf %llu\n",
> >> +		loband_bits, vcodiv_bits, lo_mult, scaled_npf);
> >> +	mxm_dbg(ctx, "scaled int %llu frac %llu desired int %u frac %u\n",
> >> +		scaled_integer, scaled_fraction, int_desired, frac_desired);
> >> +
> >> +	/* Write the calculated values to the appropriate registers */
> >> +	max2175_set_bits(ctx, 5, 3, 2, loband_bits);
> >> +	max2175_set_bits(ctx, 6, 7, 6, vcodiv_bits);
> >> +	max2175_set_bits(ctx, 1, 7, 0, (u8)(int_desired & 0xff));
> >> +	max2175_set_bits(ctx, 2, 3, 0, (u8)((frac_desired >> 16) & 0x1f));
> >> +	max2175_set_bits(ctx, 3, 7, 0, (u8)((frac_desired >> 8) & 0xff));
> >> +	max2175_set_bits(ctx, 4, 7, 0, (u8)(frac_desired & 0xff));
> >> +	/* Flush the above registers to device */
> >> +	max2175_flush_regstore(ctx, 1, 6);
> >> +	return ret;
> >> +}

[snip]

> >> +static int max2175_get_lna_gain(struct max2175_ctx *ctx) {
> >> +	int gain = 0;
> >> +	enum max2175_band band = max2175_get_bits(ctx, 5, 1, 0);
> >> +
> >> +	switch (band) {
> >> +	case MAX2175_BAND_AM:
> >> +		gain = max2175_read_bits(ctx, 51, 3, 1);
> >> +		break;
> >> +	case MAX2175_BAND_FM:
> >> +		gain = max2175_read_bits(ctx, 50, 3, 1);
> >> +		break;
> >> +	case MAX2175_BAND_VHF:
> >> +		gain = max2175_read_bits(ctx, 52, 3, 0);
> >> +		break;
> >> +	default:
> >> +		v4l2_err(ctx->client, "invalid band %d to get rf gain\n",
> >> band);
> > 
> > Can this happen ?
> 
> Yes, there is "L-band". It is a paranoia check as I am testing by comparing
> logs sometimes :-(

OK. By the way, you could get rid of the gain variable by returning directly 
in the case statements.

> >> +		break;
> >> +	}
> >> +	return gain;
> >> +}

[snip]

> >> +static const struct v4l2_ctrl_config max2175_i2s_mode = {
> >> +	.ops = &max2175_ctrl_ops,
> >> +	.id = V4L2_CID_MAX2175_I2S_MODE,
> >> +	.name = "I2S_MODE value",
> >> +	.type = V4L2_CTRL_TYPE_INTEGER,
> > 
> > Should this be a menu control ?
> 
> Hmm... the strings would be named "i2s mode x"? Will that be OK?

How about describing the modes instead ? Are they standardized ?

> >> +	.min = 0,
> >> +	.max = 4,
> >> +	.step = 1,
> >> +	.def = 0,
> >> +};

[snip]

-- 
Regards,

Laurent Pinchart

