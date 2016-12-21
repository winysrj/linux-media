Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56278 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758236AbcLUWmT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 17:42:19 -0500
Date: Wed, 21 Dec 2016 23:42:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161221224216.GA4681@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161221134235.GH16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20161221134235.GH16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Thanks for the update.
>=20
> On Wed, Dec 14, 2016 at 01:24:51PM +0100, Pavel Machek wrote:
> ...
> > +static int et8ek8_set_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct et8ek8_sensor *sensor =3D
> > +		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_GAIN:
> > +		return et8ek8_set_gain(sensor, ctrl->val);
> > +
> > +	case V4L2_CID_EXPOSURE:
> > +	{
> > +		int rows;
> > +		struct i2c_client *client =3D v4l2_get_subdevdata(&sensor->subdev);
> > +		rows =3D ctrl->val;
> > +		return et8ek8_i2c_write_reg(client, ET8EK8_REG_16BIT, 0x1243,
> > +					    swab16(rows));
>=20
> Why swab16()? Doesn't the et8ek8_i2c_write_reg() already do the right thi=
ng?
>=20
> 16-bit writes aren't used elsewhere... and the register address and value
> seem to have different endianness there, it looks like a bug to me in that
> function.

I'm pretty sure I did not invent that swab16(). I checked, and
exposure seems to work properly. I tried swapping the bytes, but then
exposure did not seem to work. So this one seems to be correct.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhbBUgACgkQMOfwapXb+vKSugCdGC+mA+KcnksxiWXu2LkxwzyD
PeIAn2pHpBK+G0hx+3WrwYo9wJUNNRrg
=lrj/
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
