Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932329AbcISVXt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:23:49 -0400
Date: Mon, 19 Sep 2016 23:23:42 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 09/17] smiapp: Read frame format earlier
Message-ID: <20160919212342.p3yvhoxr2akd6gqy@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-10-git-send-email-sakari.ailus@linux.intel.com>
 <20160919211405.bx37cjzzkjh5r2qo@earth>
 <57E0567A.4070609@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="662jff7jnel4fhmt"
Content-Disposition: inline
In-Reply-To: <57E0567A.4070609@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--662jff7jnel4fhmt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 20, 2016 at 12:19:54AM +0300, Sakari Ailus wrote:
> Hi Sebastian,
>=20
> Sebastian Reichel wrote:
> > Hi,
> >=20
> > On Thu, Sep 15, 2016 at 02:22:23PM +0300, Sakari Ailus wrote:
> > > The information gathered during frame format reading will be required
> > > earlier in the initialisation when it was available. Also return an e=
rror
> > > if frame format cannot be obtained.
> > >=20
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > >   drivers/media/i2c/smiapp/smiapp-core.c | 8 ++++++--
> > >   1 file changed, 6 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i=
2c/smiapp/smiapp-core.c
> > > index 0b5671c..c9aee83 100644
> > > --- a/drivers/media/i2c/smiapp/smiapp-core.c
> > > +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> > > @@ -2890,6 +2890,12 @@ static int smiapp_probe(struct i2c_client *cli=
ent,
> > >   		goto out_power_off;
> > >   	}
> > >=20
> > > +	rval =3D smiapp_read_frame_fmt(sensor);
> > > +	if (rval) {
> > > +		rval =3D -ENODEV;
> > > +		goto out_power_off;
> > > +	}
> > > +
> > >   	/*
> > >   	 * Handle Sensor Module orientation on the board.
> > >   	 *
> > > @@ -3013,8 +3019,6 @@ static int smiapp_probe(struct i2c_client *clie=
nt,
> > >=20
> > >   	sensor->pixel_array->sd.entity.function =3D MEDIA_ENT_F_CAM_SENSOR;
> > >=20
> > > -	/* final steps */
> > > -	smiapp_read_frame_fmt(sensor);
> > >   	rval =3D smiapp_init_controls(sensor);
> > >   	if (rval < 0)
> > >   		goto out_cleanup;
> >=20
> > Is this missing a Fixes tag, or will it only be required earlier for
> > future patches?
>=20
> It's primarily for future patches. Reading the frame format will require
> limits but hardly any other information. On the other hand, the frame for=
mat
> will very likely be needed elsewhere, hence the move.
>=20
> The missing return value check is just a bug which I believe has been the=
re
> since around 2011.

ok, so the move is for future patches. Then

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--662jff7jnel4fhmt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FdeAAoJENju1/PIO/qamuwQAJHVlMmSWWiZh1hWMI8SLm3M
cacq56lRGcXPZe0lgjjPACw8faIRsP60goJW72XhIqEzQnkE2RrhZHfSyWxlLQRi
anQ+tS9zgapLAlWvl6frX/edkhRLNrdxfVmdQ8kr3/J4Fe8lBRXlQC2om51fvqlF
3Er4WN7EJPpXUIzdOCkwpk2bSIssga5T6bpiTjnvP/kZ6Ag/XBpIa3gM968euprd
GJdWyOFDA4RpY2j4osokmQxopn9/P6DUdnC8AdfoU3Jmq20rx/6wPsmTFZ4oSnam
mo1CKL/lM4KBfCC2bQ9bVNOfrKdFJHVS9dDa2ge437G73AkQy7CuDk7n0NG8qin/
3wwDZe4WdJAkE+PlPBsciKIonJFDJ8XysuVUT3peIK0/pLSpa+Ftqz/QXYZWVVgJ
kQQAtRCZxWf1vWreKS+7IdKcBJSaJQj4zsgKex8S/ygeYjdP1YzmBO8VsGWTQre/
7EQ+9/+TZCSJnEmOD/w3RfwGYNvDmJNFl1IN6oXqYjkBbawHV55l3MlXvMb1sLTX
mZ0vof2ByFkZP2ua0v1BcNpNI1731B4N/2v4uzvnDrcbvMlAKTZJDOBk4uDWwPhi
3vXgcWvNwfJzQ5tYtW+GVwPNH0/avcEN9MG1UgdMy6n3EoR/4seovD09ly0wb7i1
dRMAStDJ6UZwUu/BtJCm
=tPn5
-----END PGP SIGNATURE-----

--662jff7jnel4fhmt--
