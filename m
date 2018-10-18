Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:56651 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbeJRVgf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 17:36:35 -0400
Date: Thu, 18 Oct 2018 15:35:25 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, sam@elite-embedded.com,
        mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Subject: Re: [PATCH 1/2] media: ov5640: Add check for PLL1 output max
 frequency
Message-ID: <20181018133525.GG17549@w540>
References: <1539805038-22321-1-git-send-email-jacopo+renesas@jmondi.org>
 <1539805038-22321-2-git-send-email-jacopo+renesas@jmondi.org>
 <20181018091550.64thz7irmbyymj5b@flea>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mhjHhnbe5PrRcwjY"
Content-Disposition: inline
In-Reply-To: <20181018091550.64thz7irmbyymj5b@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mhjHhnbe5PrRcwjY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Maxime,

On Thu, Oct 18, 2018 at 11:15:50AM +0200, Maxime Ripard wrote:
> On Wed, Oct 17, 2018 at 09:37:17PM +0200, Jacopo Mondi wrote:
> > Check that the PLL1 output frequency does not exceed the maximum allowed 1GHz
> > frequency.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/ov5640.c | 23 +++++++++++++++++++----
> >  1 file changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > index e098435..1f2e72d 100644
> > --- a/drivers/media/i2c/ov5640.c
> > +++ b/drivers/media/i2c/ov5640.c
> > @@ -770,7 +770,7 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
> >   * always set to either 1 or 2 in the vendor kernels.
> >   */
> >  #define OV5640_SYSDIV_MIN	1
> > -#define OV5640_SYSDIV_MAX	2
> > +#define OV5640_SYSDIV_MAX	16
> >
> >  /*
> >   * This is supposed to be ranging from 1 to 16, but the value is always
> > @@ -806,15 +806,20 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
> >   * This is supposed to be ranging from 1 to 8, but the value is always
> >   * set to 1 in the vendor kernels.
> >   */
> > -#define OV5640_PCLK_ROOT_DIV	1
> > +#define OV5640_PCLK_ROOT_DIV			1
> > +#define OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS	0x00
> >
> >  static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
> >  					    u8 pll_prediv, u8 pll_mult,
> >  					    u8 sysdiv)
> >  {
> > -	unsigned long rate = clk_get_rate(sensor->xclk);
> > +	unsigned long sysclk = sensor->xclk_freq / pll_prediv * pll_mult;
> >
> > -	return rate / pll_prediv * pll_mult / sysdiv;
> > +	/* PLL1 output cannot exceed 1GHz. */
> > +	if (sysclk / 1000000 > 1000)
> > +		return 0;
> > +
> > +	return sysclk / sysdiv;
> >  }
> >
> >  static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> > @@ -844,6 +849,16 @@ static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> >  			_rate = ov5640_compute_sys_clk(sensor,
> >  						       OV5640_PLL_PREDIV,
> >  						       _pll_mult, _sysdiv);
> > +
> > +			/*
> > +			 * We have reached the maximum allowed PLL1 output,
> > +			 * increase sysdiv.
> > +			 */
> > +			if (rate == 0) {
> > +				_pll_mult = OV5640_PLL_MULT_MAX + 1;
> > +				continue;
> > +			}
> > +
>
> Both your patches look sane to me. However, I guess here you're
> setting _pll_mult at this value so that you won't reach the for
> condition on the next iteration?
>
> Wouldn't it be cleaner to just use a break statement here?

Yes, it's much cleaner indeed. Not sure why I thought this was a good
idea tbh.

Would you like me to send a v2, or can you take care of this when
re-sending v5?

Thanks
   j

>
> Thanks!
> Maxime
>
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com



--mhjHhnbe5PrRcwjY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbyIwdAAoJEHI0Bo8WoVY8o04P/RuaHIOkzo9nRUXNRyQhlG5k
4L3Gi6KOcEWPha5IV+ZWjCGwwhZCa9pDxZhGpBwDz5kek+nfxPbEiAB0BpCemX45
dNAitquOdNeW7rhPCfnixRcmD0qkn3h+ZWd6V8g69G7kHfN+e2mbDymTkNBBmXRd
1GO5Xt705r6qHd8mpcveWOuN2sIhaf3g/aieW445vSbbpqy/bX4V0BTDM0PMcRK9
DOQg7wn0YYETRZXmBvKuhEoGfeqUUhzuKgimI/0UUn9jI3t8skFjWb0DBdWn1gzH
Zj2LuzzMWjuBUck38ZOeg03DKktIqXdw795qQTjWYrSQ9z/YI+fz83EeXri0Lws3
CUi3Ti3vz9n/xPGeSkURmHP4VNlOaJmmSwQHShmWL///f+/9FynyykObjJlnpUA6
wWgqYFpD1B34cj9ciTasb18cC4rCA56alYcE8dCH4GV+zdWNm48XNpk6DePzXYJz
4uaR4Q4uxV4ZgqMX03irXwEOvzhO2Sjo3XVsmrI/4r1Vni3Y9NyY/22FylOat0oL
9oHpKQPDXaoaN2iRcfvxEGuLWivy35bycTuiZMmF9mSyTFf8fOp5ak6DKGjQVyY2
mR+OAiz1I8ZINi8PuY6Jv0t0cZsoJ3LUUvqGEYCBN1ChELhc93m4zoTnLZeJ1IYV
VsxfqgF9Gb0S68qFXZgB
=S78n
-----END PGP SIGNATURE-----

--mhjHhnbe5PrRcwjY--
