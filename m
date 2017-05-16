Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42942 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbdEPMpW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 08:45:22 -0400
Date: Tue, 16 May 2017 14:45:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [patch, libv4l]: Introduce define for lookup table size
Message-ID: <20170516124519.GA25650@amd>
References: <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170509110440.GC28248@amd>
 <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Make lookup table size configurable at compile-time.
>=20
> I don't think I'll take this patch. The problem is that if we really add
> support for 10 or 12 bit lookup tables in the future, then just changing
> LSIZE isn't enough.
>=20
> This patch doesn't really add anything as it stands.

Well, currently we have 256, 255 and 0xff sprinkled through the code,
when it means to say "lookup table size". That is quite wrong (because
you can't really grep "what depends on the table size).

And BTW with the LSIZE set to 1024, 10 bit processing seems to
work. So it is already useful, at least for me.

But now I noticed the patch is subtly wrong:

> > -#define CLIP256(color) (((color) > 0xff) ? 0xff : (((color) < 0) ? 0 :=
 (color)))
> > +#define CLIPLSIZE(color) (((color) > LSIZE) ? LSIZE : (((color) <
0) ? 0 : (color)))

This should be LSIZE-1.

So I need to adjust the patch. But I'd still like you to take (fixed
version) for documentation purposes...

Best regards,
									Pavel

> >  #define CLIP(color, min, max) (((color) > (max)) ? (max) : (((color) <=
 (min)) ? (min) : (color)))
> > =20
> >  static int whitebalance_active(struct v4lprocessing_data *data)
> > @@ -111,10 +111,10 @@ static int whitebalance_calculate_lookup_tables_g=
eneric(
> > =20
> >  	avg_avg =3D (data->green_avg + data->comp1_avg + data->comp2_avg) / 3;
> > =20
> > -	for (i =3D 0; i < 256; i++) {
> > -		data->comp1[i] =3D CLIP256(data->comp1[i] * avg_avg / data->comp1_av=
g);
> > -		data->green[i] =3D CLIP256(data->green[i] * avg_avg / data->green_av=
g);
> > -		data->comp2[i] =3D CLIP256(data->comp2[i] * avg_avg / data->comp2_av=
g);
> > +	for (i =3D 0; i < LSIZE; i++) {
> > +		data->comp1[i] =3D CLIPLSIZE(data->comp1[i] * avg_avg / data->comp1_=
avg);
> > +		data->green[i] =3D CLIPLSIZE(data->green[i] * avg_avg / data->green_=
avg);
> > +		data->comp2[i] =3D CLIPLSIZE(data->comp2[i] * avg_avg / data->comp2_=
avg);
> >  	}
> > =20
> >  	return 1;
> >=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlka9F8ACgkQMOfwapXb+vLRXACgotnQVYJgMCtaHzHUdxRMKASQ
fg0AoLbd6uSiQiUsMoVymtAFeZeCQQJZ
=CoNR
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
