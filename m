Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53582 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933059AbcLNUMM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 15:12:12 -0500
Date: Wed, 14 Dec 2016 21:12:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161214201202.GB28424@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161214130310.GA15405@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <20161214130310.GA15405@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Wednesday 14 December 2016 13:24:51 Pavel Machek wrote:
> > =20
> > Add driver for et8ek8 sensor, found in Nokia N900 main camera. Can be
> > used for taking photos in 2.5MP resolution with fcam-dev.
> >=20
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > ---
> > From v4 I did cleanups to coding style and removed various oddities.
> >=20
> > Exposure value is now in native units, which simplifies the code.
> >=20
> > The patch to add device tree bindings was already acked by device tree
> > people.

> > +	default:
> > +		WARN_ONCE(1, ET8EK8_NAME ": %s: invalid message length.\n",
> > +			  __func__);
>=20
> dev_warn_once()
=2E..
> > +	if (WARN_ONCE(cnt > ET8EK8_MAX_MSG,
> > +		      ET8EK8_NAME ": %s: too many messages.\n", __func__)) {
>=20
> Maybe replace it with dev_warn_once() too? That condition in WARN_ONCE
> does not look nice...
=2E..
> > +			if (WARN(next->type !=3D ET8EK8_REG_8BIT &&
> > +				 next->type !=3D ET8EK8_REG_16BIT,
> > +				 "Invalid type =3D %d", next->type)) {
> dev_warn()
>
> > +	WARN_ON(sensor->power_count < 0);
>=20
> Rather some dev_warn()? Do we need stack trace here?

I don't see what is wrong with WARN(). These are not expected to
trigger, if they do we'll fix it. If you feel strongly about this,
feel free to suggest a patch.

> > +static int et8ek8_i2c_reglist_find_write(struct i2c_client *client,
> > +					 struct et8ek8_meta_reglist *meta,
> > +					 u16 type)
> > +{
> > +	struct et8ek8_reglist *reglist;
> > +
> > +	reglist =3D et8ek8_reglist_find_type(meta, type);
> > +	if (!reglist)
> > +		return -EINVAL;
> > +
> > +	return et8ek8_i2c_write_regs(client, reglist->regs);
> > +}
> > +
> > +static struct et8ek8_reglist **et8ek8_reglist_first(
> > +		struct et8ek8_meta_reglist *meta)
> > +{
> > +	return &meta->reglist[0].ptr;
> > +}
>=20
> Above code looks like re-implementation of linked-list. Does not kernel
> already provide some?

Its actually array of pointers as far as I can tell. I don't think any
helpers would be useful here.

> > +	new =3D et8ek8_gain_table[gain];
> > +
> > +	/* FIXME: optimise I2C writes! */
>=20
> Is this FIMXE still valid?

Probably. Lets optimize it after merge.

> > +	if (sensor->power_count) {
> > +		WARN_ON(1);
>=20
> Such warning is probably not useful...

It should not happen, AFAICT. That's why I'd like to know if it does.

> > +#include "et8ek8_reg.h"
> > +
> > +/*
> > + * Stingray sensor mode settings for Scooby
> > + */
>=20
> Are settings for this sensor Stingray enough?

Seems to work well enough for me. If more modes are needed, we can add
them later.

> It was me who copied these sensors settings to kernel driver. And I
> chose only Stingray as this is what was needed for my N900 for
> testing... Btw, you could add somewhere my and Ivo's Signed-off and
> copyright state as we both modified et8ek8.c code...

Normally, people add copyrights when they modify the code. If you want
to do it now, please send me a patch. (With those warn_ons too, if you
care, but I think the code is fine as is).

I got code from Dmitry, so it has his signed-off.

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhRp5IACgkQMOfwapXb+vKScgCeLIe7izOb5cwV5Sd6dX0QZUQR
18wAn2bsyebsv2rRMQf/4ltXEeUIvSQP
=TjEu
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
