Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34378 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935154AbcKKHQK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 02:16:10 -0500
Subject: Re: [PATCH 2/5] media: i2c: max2175: Add MAX2175 support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1478706284-59134-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <d9e9aac2-001c-491b-db34-a9eed6240722@iki.fi>
Date: Fri, 11 Nov 2016 09:16:04 +0200
MIME-Version: 1.0
In-Reply-To: <1478706284-59134-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

On 11/09/2016 05:44 PM, Ramesh Shanmugasundaram wrote:

> +static int max2175_set_lo_freq(struct max2175 *ctx, u64 lo_freq)
> +{
> +	u64 scaled_lo_freq, scaled_npf, scaled_integer, scaled_fraction;
> +	u32 frac_desired, int_desired, lo_mult = 1;
> +	const u32 scale_factor = 1000000U;
> +	u8 loband_bits = 0, vcodiv_bits = 0;
> +	enum max2175_band band;
> +	int ret;
> +
> +	/* Scale to larger number for precision */
> +	scaled_lo_freq = lo_freq * scale_factor * 100;
> +	band = max2175_read_bits(ctx, 5, 1, 0);
> +
> +	mxm_dbg(ctx, "set_lo_freq: scaled lo_freq %llu lo_freq %llu band %d\n",
> +		scaled_lo_freq, lo_freq, band);
> +
> +	switch (band) {
> +	case MAX2175_BAND_AM:
> +		if (max2175_read_bit(ctx, 5, 7) == 0)
> +			lo_mult = 16;

else is lo_mult = 1. No idea if it is correct, but sounds very small 
output divider for low freq like am band. And on the other-hand local 
oscillator output divider, which I expect this to be, is usually 2 or more.

> +		break;
> +	case MAX2175_BAND_FM:
> +		if (lo_freq <= 74700000) {
> +			lo_mult = 16;

No meaning as you set it later 8.

> +		} else if (lo_freq > 74700000 && lo_freq <= 110000000) {
> +			loband_bits = 1;
> +		} else {
> +			loband_bits = 1;
> +			vcodiv_bits = 3;
> +		}
> +		lo_mult = 8;
> +		break;
> +	case MAX2175_BAND_VHF:
> +		if (lo_freq <= 210000000) {
> +			loband_bits = 2;
> +			vcodiv_bits = 2;
> +		} else {
> +			loband_bits = 2;
> +			vcodiv_bits = 1;
> +		}
> +		lo_mult = 4;
> +		break;
> +	default:
> +		loband_bits = 3;
> +		vcodiv_bits = 2;
> +		lo_mult = 2;
> +		break;
> +	}
> +
> +	if (band == MAX2175_BAND_L)
> +		scaled_npf = div_u64(div_u64(scaled_lo_freq, ctx->xtal_freq),
> +				     lo_mult);
> +	else
> +		scaled_npf = div_u64(scaled_lo_freq, ctx->xtal_freq) * lo_mult;
> +
> +	scaled_npf = div_u64(scaled_npf, 100);
> +	scaled_integer = div_u64(scaled_npf, scale_factor) * scale_factor;
> +	int_desired = div_u64(scaled_npf, scale_factor);
> +	scaled_fraction = scaled_npf - scaled_integer;
> +	frac_desired = div_u64(scaled_fraction << 20, scale_factor);
> +
> +	/* Check CSM is not busy */
> +	ret = max2175_poll_csm_ready(ctx);
> +	if (ret)
> +		return ret;
> +
> +	mxm_dbg(ctx, "loband %u vcodiv %u lo_mult %u scaled_npf %llu\n",
> +		loband_bits, vcodiv_bits, lo_mult, scaled_npf);
> +	mxm_dbg(ctx, "scaled int %llu frac %llu desired int %u frac %u\n",
> +		scaled_integer, scaled_fraction, int_desired, frac_desired);
> +
> +	/* Write the calculated values to the appropriate registers */
> +	max2175_write(ctx, 1, int_desired);
> +	max2175_write_bits(ctx, 2, 3, 0, (frac_desired >> 16) & 0xf);
> +	max2175_write(ctx, 3, frac_desired >> 8);
> +	max2175_write(ctx, 4, frac_desired);
> +	max2175_write_bits(ctx, 5, 3, 2, loband_bits);
> +	max2175_write_bits(ctx, 6, 7, 6, vcodiv_bits);
> +	return ret;
> +}

That synthesizer config is hard to understand. It seems to be 
fractional-N, with configurable N, K and output divider - like a school 
book example.

               +----------------------------+
               v                            |
      Fref   +----+     +-------+         +------+
     ------> | PD | --> |  VCO  | ------> | /N.F |
             +----+     +-------+         +------+
                          |
                          |
                          v
                        +-------+  Fout
                        | /Rout | ------>
                        +-------+

I made following look-up table in order to understand it:

band      lo freq band vcodiv div_out
   AM  <  50000000    0      0      16 // reg 5 bit 7 ?
   FM  <  74700000    0      0      16
   FM  < 110000000    1      0       8
   FM  < 160000000    1      3       8
  VHF  < 210000000    2      2       4
  VHF  < 600000000    2      1       4
    L  <2000000000    3      2       2

"vcodiv" looks unrelated to synth calculation, dunno what it is.

One which makes calculation very complex looking is that it is based of 
floating point calculus. On integer mathematics you should replace 
fractional part with fractional modulus (usually letter "K" is used for 
fractional modulus on PLL calc).

So that ends up something like:
1) select suitable lo output divider from desired output frequency
2) calculate vco frequency
3) convert vco frequency to N and K
* N = Fvco/Fref
* K = Fvco%Fref
4) convert K to control word (looks like << 20)
5) program values

Result should be calculus without scaling.

regards
Antti


-- 
http://palosaari.fi/
