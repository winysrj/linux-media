Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48420 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933476AbcLMVHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 16:07:30 -0500
Date: Tue, 13 Dec 2016 22:05:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161213210506.GA11569@amd>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have finally found the old mail you were refering to. Let me go
through it.

> > +/*
> > + * Convert exposure time `us' to rows. Modify `us' to make it to
> > + * correspond to the actual exposure time.
> > + */
> > +static int et8ek8_exposure_us_to_rows(struct et8ek8_sensor *sensor, u3=
2 *us)
>=20
> Should a driver do something like this to begin with?
>=20
> The smiapp driver does use the native unit of exposure (lines) for the
> control and I think the et8ek8 driver should do so as well.
>=20
> The HBLANK, VBLANK and PIXEL_RATE controls are used to provide the user w=
ith
> enough information to perform the conversion (if necessary).

Well... I believe exposure in usec is preffered format for userspace
to work with (because then it can change resolution and keep camera
settings) but I see kernel code is quite ugly. Let me see what I can do...

> > +	if (ret) {
> > +		dev_warn(dev, "can't get clock-frequency\n");
> > +		return ret;
> > +	}
> > +
> > +	mutex_init(&sensor->power_lock);
>=20
> mutex_destroy() should be called on the mutex if probe fails after this a=
nd
> in remove().

Ok.

> > +static int __exit et8ek8_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *subdev =3D i2c_get_clientdata(client);
> > +	struct et8ek8_sensor *sensor =3D to_et8ek8_sensor(subdev);
> > +
> > +	if (sensor->power_count) {
> > +		gpiod_set_value(sensor->reset, 0);
> > +		clk_disable_unprepare(sensor->ext_clk);
>=20
> How about the regulator? Could you call et8ek8_power_off() instead?

Hmm. Actually if we hit this, it indicates something funny is going
on, no? I guess I'll add WARN_ON there...

> > +++ b/drivers/media/i2c/et8ek8/et8ek8_reg.h
> > @@ -0,0 +1,96 @@
> > +/*
> > + * et8ek8.h
>=20
> et8ek8_reg.h

Ok.

Thanks for patience,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhQYoIACgkQMOfwapXb+vJQpwCeOSnpQAA/36MuSBunF6ewPl9j
ZmIAn3Kwvozz/NNxHrJBfZBzttK12Ri5
=R5Jw
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
