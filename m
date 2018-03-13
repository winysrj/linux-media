Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45263 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752218AbeCMMt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 08:49:59 -0400
Date: Tue, 13 Mar 2018 13:49:37 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
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
Message-ID: <20180313124937.zva652gt4dou7apj@flea>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
 <20180302143500.32650-9-maxime.ripard@bootlin.com>
 <20180309111624.hexk74upa6s53r3t@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gi4mah2icywx45u5"
Content-Disposition: inline
In-Reply-To: <20180309111624.hexk74upa6s53r3t@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gi4mah2icywx45u5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Fri, Mar 09, 2018 at 01:16:24PM +0200, Sakari Ailus wrote:
> > + *
> > + *   +--------------+
> > + *   |  Oscillator  |
>=20
> I wonder if this should be simply called external clock, that's what the
> sensor uses.

Ack

> > + *   +------+-------+
> > + *          |
> > + *   +------+-------+
> > + *   | System clock | - reg 0x3035, bits 4-7
> > + *   +------+-------+
> > + *          |
> > + *   +------+-------+ - reg 0x3036, for the multiplier
> > + *   |     PLL      | - reg 0x3037, bits 4 for the root divider
> > + *   +------+-------+ - reg 0x3037, bits 0-3 for the pre-divider
> > + *          |
> > + *   +------+-------+
> > + *   |     SCLK     | - reg 0x3108, bits 0-1 for the root divider
> > + *   +------+-------+
> > + *          |
> > + *   +------+-------+
> > + *   |    PCLK      | - reg 0x3108, bits 4-5 for the root divider
> > + *   +--------------+
> > + *
> > + * This is deviating from the datasheet at least for the register
> > + * 0x3108, since it's said here that the PCLK would be clocked from
> > + * the PLL. However, changing the SCLK divider value has a direct
> > + * effect on the PCLK rate, which wouldn't be the case if both PCLK
> > + * and SCLK were to be sourced from the PLL.
> > + *
> > + * These parameters also match perfectly the rate that is output by
> > + * the sensor, so we shouldn't have too much factors missing (or they
> > + * would be set to 1).
> > + */
> > +
> > +/*
> > + * FIXME: This is supposed to be ranging from 1 to 16, but the value
> > + * is always set to either 1 or 2 in the vendor kernels.
>=20
> There could be limits for the clock rates after the first divider. In
> practice the clock rates are mostly one of the common frequencies (9,6; 1=
2;
> 19,2 or 24 MHz) so there's no need to use the other values.

There's probably some limits on the various combinations as well. I
first tried to use the full range, and there was some combinations
that were not usable, even though the clock rate should have been
correct.

> > + */
> > +#define OV5640_SYSDIV_MIN	1
> > +#define OV5640_SYSDIV_MAX	2
> > +
> > +static unsigned long ov5640_calc_sysclk(struct ov5640_dev *sensor,
> > +					unsigned long rate,
> > +					u8 *sysdiv)
> > +{
> > +	unsigned long best =3D ~0;
> > +	u8 best_sysdiv =3D 1;
> > +	u8 _sysdiv;
> > +
> > +	for (_sysdiv =3D OV5640_SYSDIV_MIN;
> > +	     _sysdiv <=3D OV5640_SYSDIV_MAX;
> > +	     _sysdiv++) {
> > +		unsigned long tmp;
> > +
> > +		tmp =3D sensor->xclk_freq / _sysdiv;
> > +		if (abs(rate - tmp) < abs(rate - best)) {
> > +			best =3D tmp;
> > +			best_sysdiv =3D _sysdiv;
> > +		}
> > +
> > +		if (tmp =3D=3D rate)
> > +			goto out;
> > +	}
> > +
> > +out:
> > +	*sysdiv =3D best_sysdiv;
> > +	return best;
> > +}
> > +
> > +/*
> > + * FIXME: This is supposed to be ranging from 1 to 8, but the value is
> > + * always set to 3 in the vendor kernels.
> > + */
> > +#define OV5640_PLL_PREDIV_MIN	3
> > +#define OV5640_PLL_PREDIV_MAX	3
>=20
> Same reasoning here than above. I might leave a comment documenting the
> values the hardware supports, removing FIXME as this isn't really an issue
> as far as I see.

Ok, I'll do it then

> > +
> > +/*
> > + * FIXME: This is supposed to be ranging from 1 to 2, but the value is
> > + * always set to 1 in the vendor kernels.
> > + */
> > +#define OV5640_PLL_ROOT_DIV_MIN	1
> > +#define OV5640_PLL_ROOT_DIV_MAX	1
> > +
> > +#define OV5640_PLL_MULT_MIN	4
> > +#define OV5640_PLL_MULT_MAX	252
> > +
> > +static unsigned long ov5640_calc_pll(struct ov5640_dev *sensor,
> > +				     unsigned long rate,
> > +				     u8 *sysdiv, u8 *prediv, u8 *rdiv, u8 *mult)
> > +{
> > +	unsigned long best =3D ~0;
> > +	u8 best_sysdiv =3D 1, best_prediv =3D 1, best_mult =3D 1, best_rdiv =
=3D 1;
> > +	u8 _prediv, _mult, _rdiv;
> > +
> > +	for (_prediv =3D OV5640_PLL_PREDIV_MIN;
> > +	     _prediv <=3D OV5640_PLL_PREDIV_MAX;
> > +	     _prediv++) {
> > +		for (_mult =3D OV5640_PLL_MULT_MIN;
> > +		     _mult <=3D OV5640_PLL_MULT_MAX;
> > +		     _mult++) {
> > +			for (_rdiv =3D OV5640_PLL_ROOT_DIV_MIN;
> > +			     _rdiv <=3D OV5640_PLL_ROOT_DIV_MAX;
> > +			     _rdiv++) {
> > +				unsigned long pll;
> > +				unsigned long sysclk;
> > +				u8 _sysdiv;
> > +
> > +				/*
> > +				 * The PLL multiplier cannot be odd if
> > +				 * above 127.
> > +				 */
> > +				if (_mult > 127 && !(_mult % 2))
> > +					continue;
> > +
> > +				sysclk =3D rate * _prediv * _rdiv / _mult;
> > +				sysclk =3D ov5640_calc_sysclk(sensor, sysclk,
> > +							    &_sysdiv);
> > +
> > +				pll =3D sysclk / _rdiv / _prediv * _mult;
> > +				if (abs(rate - pll) < abs(rate - best)) {
> > +					best =3D pll;
> > +					best_sysdiv =3D _sysdiv;
> > +					best_prediv =3D _prediv;
> > +					best_mult =3D _mult;
> > +					best_rdiv =3D _rdiv;
>=20
> The smiapp PLL calculator only accepts an exact match. That hasn't been an
> issue previously, I wonder if this would work here, too.

I don't recall which one exactly, but I think at least 480p@30fps
wasn't an exact match in our case. Given the insanely high blanking
periods, we might reduce them in order to fall back to something
exact, but I really wanted to be as close to what was already done in
the bytes array as possible, given the already quite intrusive nature
of the patches.

> I think you could remove the inner loop, too, if put what
> ov5640_calc_sysclk() does here. You know the desired clock rate so you can
> calculate the total divisor (_rdiv * sysclk divider).

I guess we can have two approaches here. Since most of the dividers
are fixed, I could have a much simpler code anyway, or I could keep it
that way if we ever want to extend it.

It seems you imply that you'd like something simpler, so I can even
simplify much more than what's already there if you want.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--gi4mah2icywx45u5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqnyOAACgkQ0rTAlCFN
r3RXQw/9HNTjwhcEf03Aazr3IfKmmBcrfaVFahjDubowToMo+XUDq3FwSNX/okX6
4XlkjR6/kEv59uXCqNl41AQyc6pDx9vvz69EPrhLfEHwIFDdDvYr1/DAGbq8fB41
LI02VgdKj4A6S2HjODXQz8iU+4wgexmCvODt1P1UTZeKFHt5/HPywsREHFhVx3/h
289ms5Ocrr2cwirY0AAbL/sgdWIwpwcT/yeJww9NKLip4nNaysQG1slwQZdh367B
nbLxQV2SyOSrIVMUjVb8XG/PrXmmWWqBkxP8mhMXBPjMu23rEKn9WKChDhcPyDIm
/vqio6plNLcO3Kd42yPneDIkoOSiy+1iHBaIBYByltdsidklYP2cQGOaqz+qIkVg
i/cKYgQoUNCKjI6i5g1P0x93oiYCugd4ka/BSSZgCb4aNdr2lLLmRHepNrCXH7kB
4+lFB1JtVHHaOI0E5vs2Ktbl0w9evVErnMSjGV6zLoCv4Xg3lCWD3GL03pfiPe2d
QreX/eqnwlsvgzXRXx4CvB/VauXyVIwVuEHnNvcKNlBD0d1Am0kR1b8CSYe5pmUF
bAHAqSW7jB20RP/rLyWd+hsTLwJRh6uQ1e7AumBY1dY+/D1P3S/JksAD0BqqeJGt
Hr5wYlNTycdfc7hJK0D4MKxN3hmQI5UdMVWlhKE1FyWvhtleyps=
=nRhw
-----END PGP SIGNATURE-----

--gi4mah2icywx45u5--
