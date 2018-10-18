Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52850 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbeJRRP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 13:15:57 -0400
Date: Thu, 18 Oct 2018 11:15:50 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: sam@elite-embedded.com, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org
Subject: Re: [PATCH 1/2] media: ov5640: Add check for PLL1 output max
 frequency
Message-ID: <20181018091550.64thz7irmbyymj5b@flea>
References: <1539805038-22321-1-git-send-email-jacopo+renesas@jmondi.org>
 <1539805038-22321-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fptgibnuibvnu7n3"
Content-Disposition: inline
In-Reply-To: <1539805038-22321-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fptgibnuibvnu7n3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 17, 2018 at 09:37:17PM +0200, Jacopo Mondi wrote:
> Check that the PLL1 output frequency does not exceed the maximum allowed =
1GHz
> frequency.
>=20
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/i2c/ov5640.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index e098435..1f2e72d 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -770,7 +770,7 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, =
u16 reg,
>   * always set to either 1 or 2 in the vendor kernels.
>   */
>  #define OV5640_SYSDIV_MIN	1
> -#define OV5640_SYSDIV_MAX	2
> +#define OV5640_SYSDIV_MAX	16
> =20
>  /*
>   * This is supposed to be ranging from 1 to 16, but the value is always
> @@ -806,15 +806,20 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor=
, u16 reg,
>   * This is supposed to be ranging from 1 to 8, but the value is always
>   * set to 1 in the vendor kernels.
>   */
> -#define OV5640_PCLK_ROOT_DIV	1
> +#define OV5640_PCLK_ROOT_DIV			1
> +#define OV5640_PLL_SYS_ROOT_DIVIDER_BYPASS	0x00
> =20
>  static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
>  					    u8 pll_prediv, u8 pll_mult,
>  					    u8 sysdiv)
>  {
> -	unsigned long rate =3D clk_get_rate(sensor->xclk);
> +	unsigned long sysclk =3D sensor->xclk_freq / pll_prediv * pll_mult;
> =20
> -	return rate / pll_prediv * pll_mult / sysdiv;
> +	/* PLL1 output cannot exceed 1GHz. */
> +	if (sysclk / 1000000 > 1000)
> +		return 0;
> +
> +	return sysclk / sysdiv;
>  }
> =20
>  static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
> @@ -844,6 +849,16 @@ static unsigned long ov5640_calc_sys_clk(struct ov56=
40_dev *sensor,
>  			_rate =3D ov5640_compute_sys_clk(sensor,
>  						       OV5640_PLL_PREDIV,
>  						       _pll_mult, _sysdiv);
> +
> +			/*
> +			 * We have reached the maximum allowed PLL1 output,
> +			 * increase sysdiv.
> +			 */
> +			if (rate =3D=3D 0) {
> +				_pll_mult =3D OV5640_PLL_MULT_MAX + 1;
> +				continue;
> +			}
> +

Both your patches look sane to me. However, I guess here you're
setting _pll_mult at this value so that you won't reach the for
condition on the next iteration?

Wouldn't it be cleaner to just use a break statement here?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--fptgibnuibvnu7n3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlvIT0UACgkQ0rTAlCFN
r3TsYQ/6A0uPMHuFBCYJmognpsiJ8R0AKxY2I+HEmvurFxfPMKyWVjnm4Gizwkmb
Y0R7soaBZLCNnbRFWkm0aICy0w+BNTgWm0SfwLFd7QSjb/CoVIMO47IAJ+5qPmpc
G3zh18bul/kUQUVUVfAFXl9YI3UAjvXu5W/BjkNlUlceTW0C6yeh+lUpnvPLABUy
9PI2pOgJ1LBNWE34SY0AjTUgTqpF6kx6zG0SrY/oip5CFlB9l9v617C6p30hhdxz
6ZdGTv7Jw/KyZ32F9N4R3DShl2UoRaSudMCwGEF0xKwVP2xrw4+F0J+VhTvr4M9f
cvJwDLcZjkVQna915JEIwgTDuc175r928JVOSUS6VT+g9pxP3Ktt8Nckja6azQAu
nkAAr6JbY+EqckeLYOH8pBaUUJx+V7A8Z2Pqqnb56UPRcUqHeVWD9KokaBP+kbm9
cb9RWojfE5GJQh0xQOdDS31aa3RojSG6kUIGh8ZhXMOW2+slp2uoktgDHC6oc0Zc
l0CD+eLPCgvRgsMRzCVzphEMJoAl/Q8QBJR+vGYc3Z7NmNGXgZfwpvhIRKUiQlgu
BIdOnXB7zRtrAQm6HlNYWK/k1ujG1d3aUtfFqsU7sU2wp2nq1noTVqcm/2Q3/3WP
EaHynRLQvBDnmHig0Uk2oJHiCIbidXpCeIJfurnQf5JH9cbT/vA=
=D6E7
-----END PGP SIGNATURE-----

--fptgibnuibvnu7n3--
