Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:54541 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab2EGVAl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 17:00:41 -0400
Date: Mon, 7 May 2012 23:00:31 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add fc0011 tuner driver
Message-ID: <20120507230031.2b1e9e3c@milhouse>
In-Reply-To: <4FA81C3A.1020108@iki.fi>
References: <20120402181432.74e8bd50@milhouse>
	<4FA81C3A.1020108@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/O8q0fL7aEGYZyNy6I_lCKvz"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/O8q0fL7aEGYZyNy6I_lCKvz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 07 May 2012 22:02:18 +0300
Antti Palosaari <crope@iki.fi> wrote:

> On 02.04.2012 19:14, Michael B=C3=BCsch wrote:
> > This adds support for the Fitipower fc0011 DVB-t tuner.
> >
> > Signed-off-by: Michael Buesch<m@bues.ch>
>=20
> > +	unsigned int i, vco_retries;
> > +	u32 freq =3D p->frequency / 1000;
> > +	u32 bandwidth =3D p->bandwidth_hz / 1000;
> > +	u32 fvco, xin, xdiv, xdivr;
> > +	u16 frac;
> > +	u8 fa, fp, vco_sel, vco_cal;
> > +	u8 regs[FC11_NR_REGS] =3D { };
>=20
> > +
> > +	dev_dbg(&priv->i2c->dev, "Tuned to "
> > +		"fa=3D%02X fp=3D%02X xin=3D%02X%02X vco=3D%02X vcosel=3D%02X "
> > +		"vcocal=3D%02X(%u) bw=3D%u\n",
> > +		(unsigned int)regs[FC11_REG_FA],
> > +		(unsigned int)regs[FC11_REG_FP],
> > +		(unsigned int)regs[FC11_REG_XINHI],
> > +		(unsigned int)regs[FC11_REG_XINLO],
> > +		(unsigned int)regs[FC11_REG_VCO],
> > +		(unsigned int)regs[FC11_REG_VCOSEL],
> > +		(unsigned int)vco_cal, vco_retries,
> > +		(unsigned int)bandwidth);
>=20
> Just for the interest, is there any reason you use so much casting or is=
=20
> that only your style?

Well it makes sure the types are what the format string and thus vararg cod=
e expects.
it is true that most (probably all) of those explicit casts could be remove=
d and instead
rely on implicit casts and promotions. But I personally prefer explicit cas=
ts
in this case (and only this case).

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/O8q0fL7aEGYZyNy6I_lCKvz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqDfwAAoJEPUyvh2QjYsOB1AQANMoWnmyVCB8TNB+8puQAHoj
zMtp2qJyFnWgyiOk8Qvv65npG09FuB5GkLJqhIbcXKS7Yu9ObumuwbsJNZGE2HXx
bRcL8QOQz1BEA8/hX/YuLlJGOENfn4cf9EHK2aNa5PudvbVPi54kDlcP7lsXOskD
+ZdNtKgM0i3Nn3fG3XgJJLRcTVutdv/43e0szLlZTxnRNwAy7zb8l4NtKqGtNJiE
f9HuBIGaS4/XvMOtMOji9jXg6AsGkajb9j+cuYHkcH6vHw5S7vigk9MNKVnaWke6
hmFpvcURqEx4qg0JO4VU1C8FXreioKpobxgTTohlZhBgn7Z5sqW3MwzYA/VIjC7h
e+0cNh1OSTzv4yf/bJ0JO6mUABxg0Sq3nZdHpKQAwtyNvTk3T3DXcZFPKUeHOWLL
wouAbUZEHH6P3EBKMF2bMhj3zJ6yfFWSb1zV0yH6Vx6jpUD8rZfOYUK+KZ+jM4K7
Lz3mpFqz8e0cJtc2asyL4cT2pwuo3im5FuEWf1zWiriUrRHUj13Q0mEUyaSLPPzK
f2BquU+uW2+hMdCHXop9JAt9J3J454LrKSZtQgXWeUii6aXMxc9T+yQ6sfsVisSQ
P9T/RBzK/ZLDcUYNQYobQDg5Bf10+5BA0JGHYYtctyoOKQlmYC8qhkRnwAQv3HU6
hX6gLN0MtaS6O+Z3nJ/v
=v0lH
-----END PGP SIGNATURE-----

--Sig_/O8q0fL7aEGYZyNy6I_lCKvz--
