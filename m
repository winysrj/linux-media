Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39989 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754367AbcLVJeS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 04:34:18 -0500
Date: Thu, 22 Dec 2016 10:34:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161222093414.GA26246@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161221134235.GH16630@valkosipuli.retiisi.org.uk>
 <20161221224216.GA4681@amd>
 <20161221232930.GI16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20161221232930.GI16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Thanks for the update.
> > >=20
> > > On Wed, Dec 14, 2016 at 01:24:51PM +0100, Pavel Machek wrote:
> > > ...
> > > > +static int et8ek8_set_ctrl(struct v4l2_ctrl *ctrl)
> > > > +{
> > > > +	struct et8ek8_sensor *sensor =3D
> > > > +		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
> > > > +
> > > > +	switch (ctrl->id) {
> > > > +	case V4L2_CID_GAIN:
> > > > +		return et8ek8_set_gain(sensor, ctrl->val);
> > > > +
> > > > +	case V4L2_CID_EXPOSURE:
> > > > +	{
> > > > +		int rows;
> > > > +		struct i2c_client *client =3D v4l2_get_subdevdata(&sensor->subde=
v);
> > > > +		rows =3D ctrl->val;
> > > > +		return et8ek8_i2c_write_reg(client, ET8EK8_REG_16BIT, 0x1243,
> > > > +					    swab16(rows));
> > >=20
> > > Why swab16()? Doesn't the et8ek8_i2c_write_reg() already do the right=
 thing?
> > >=20
> > > 16-bit writes aren't used elsewhere... and the register address and v=
alue
> > > seem to have different endianness there, it looks like a bug to me in=
 that
> > > function.
> >=20
> > I'm pretty sure I did not invent that swab16(). I checked, and
> > exposure seems to work properly. I tried swapping the bytes, but then
> > exposure did not seem to work. So this one seems to be correct.
>=20
> I can fix that too, but I have no device to test. In terms of how the
> hardware is controlled there should be no difference anyway.

Aha, now I understand; you want me to fix write_reg. I can do that. It
seems read_reg has similar problem, but as noone is using 16-bit
reads, so it is dormant. Ok, let me fix that.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhbnhYACgkQMOfwapXb+vIPNQCeOHQdXkFkvbO/o188VEWjt3eq
AtkAn1Wbhm9YVHthWQ/P0walI3wY68of
=wnc+
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
