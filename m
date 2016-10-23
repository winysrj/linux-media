Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35184 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754225AbcJWKcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 06:32:24 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: v4.9-rc1: smiapp divides by zero
Date: Sun, 23 Oct 2016 12:32:20 +0200
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
        sre@kernel.org, linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20161023073322.GA3523@amd> <20161023102213.GA13705@amd>
In-Reply-To: <20161023102213.GA13705@amd>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6429053.YPL4hkA8Wf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201610231232.20750@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart6429053.YPL4hkA8Wf
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 23 October 2016 12:22:13 Pavel Machek wrote:
> Hi!
>=20
> I tried to update camera code on n900 to v4.9-rc1, and I'm getting
> some divide by zero, that eventually cascades into fcam-dev not
> working.
>=20
> mul is zero in my testing, resulting in divide by zero.
>=20
> (Note that this is going from my patched camera-v4.8 tree to
> camera-v4.9 tree.)
>=20
> Best regards,
> 								Pavel

Hi! Ideally look at existing camera patches. I do not know which one is
last, but here are some links:

https://github.com/freemangordon/linux-n900/tree/v4.6-rc4-n900-camera
https://github.com/freemangordon/linux-n900/tree/camera
https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=3Dn9=
00-camera-ivo
https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=3Dn9=
00-camera

> diff --git a/drivers/media/i2c/smiapp-pll.c
> b/drivers/media/i2c/smiapp-pll.c index 5ad1edb..e0a6edd 100644
> --- a/drivers/media/i2c/smiapp-pll.c
> +++ b/drivers/media/i2c/smiapp-pll.c
> @@ -16,6 +16,8 @@
>   * General Public License for more details.
>   */
>=20
> +#define DEBUG
> +
>  #include <linux/device.h>
>  #include <linux/gcd.h>
>  #include <linux/lcm.h>
> @@ -457,6 +459,10 @@ int smiapp_pll_calculate(struct device *dev,
>  	i =3D gcd(pll->pll_op_clk_freq_hz, pll->ext_clk_freq_hz);
>  	mul =3D div_u64(pll->pll_op_clk_freq_hz, i);
>  	div =3D pll->ext_clk_freq_hz / i;
> +	if (!mul) {
> +		dev_err(dev, "forcing mul to 1\n");
> +		mul =3D 1;
> +	}
>  	dev_dbg(dev, "mul %u / div %u\n", mul, div);
>=20
>  	min_pre_pll_clk_div =3D

Is not this patch still enough?
https://patchwork.kernel.org/patch/8921761/

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6429053.YPL4hkA8Wf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlgMkbQACgkQi/DJPQPkQ1IyIACfQ1CTllrsWMoSjdRo+PK+YA4i
yDYAnRMgBc83lA92iYREs+Znzq9aMrhR
=Watm
-----END PGP SIGNATURE-----

--nextPart6429053.YPL4hkA8Wf--
