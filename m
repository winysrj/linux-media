Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46969 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab2H1RKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 13:10:35 -0400
Message-ID: <1346173795.15747.28.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v2] [media] rc: ite-cir: Initialise ite_dev::rdev earlier
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	YunQiang Su <wzssyqa@gmail.com>, 684441@bugs.debian.org,
	Jarod Wilson <jarod@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Tue, 28 Aug 2012 10:09:55 -0700
In-Reply-To: <20120828114409.GA3191@zeus>
References: <1345411489.22400.76.camel@deadeye.wl.decadent.org.uk>
	 <1345419147.22400.78.camel@deadeye.wl.decadent.org.uk>
	 <20120828114409.GA3191@zeus>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LSSLgFTsibMQ5Quj4t7W"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-LSSLgFTsibMQ5Quj4t7W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-28 at 12:44 +0100, Luis Henriques wrote:
> On Mon, Aug 20, 2012 at 12:32:27AM +0100, Ben Hutchings wrote:
> > ite_dev::rdev is currently initialised in ite_probe() after
> > rc_register_device() returns.  If a newly registered device is opened
> > quickly enough, we may enable interrupts and try to use ite_dev::rdev
> > before it has been initialised.  Move it up to the earliest point we
> > can, right after calling rc_allocate_device().
>=20
> I believe this is the same bug:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D46391
>=20
> And the bug is present in other IR devices as well.
>=20
> I've sent a proposed fix:
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D134590803109050&w=3D2

It might be a worthwhile fix.  But it doesn't fix this bug - after that
patch, the driver will still enable its IRQ before initialising
ite_dev::rdev.

Ben.

> Cheers,
> --
> Luis
>=20
> >=20
> > References: http://bugs.debian.org/684441 Reported-and-tested-by:
> > YunQiang Su <wzssyqa@gmail.com> Signed-off-by: Ben Hutchings
> > <ben@decadent.org.uk> Cc: stable@vger.kernel.org --- Unlike the
> > previous version, this will apply cleanly to the media
> > staging/for_v3.6 branch.
> >=20
> > Ben.
> >=20
> >  drivers/media/rc/ite-cir.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> > index 36fe5a3..24c77a4 100644
> > --- a/drivers/media/rc/ite-cir.c
> > +++ b/drivers/media/rc/ite-cir.c
> > @@ -1473,6 +1473,7 @@ static int ite_probe(struct pnp_dev *pdev, const =
struct pnp_device_id
> >  	rdev =3D rc_allocate_device();
> >  	if (!rdev)
> >  		goto failure;
> > +	itdev->rdev =3D rdev;
> > =20
> >  	ret =3D -ENODEV;
> > =20
> > @@ -1604,7 +1605,6 @@ static int ite_probe(struct pnp_dev *pdev, const =
struct pnp_device_id
> >  	if (ret)
> >  		goto failure3;
> > =20
> > -	itdev->rdev =3D rdev;
> >  	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
> > =20
> >  	return 0;
> >=20
>=20

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-LSSLgFTsibMQ5Quj4t7W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDz7Y+e/yOyVhhEJAQoVWRAAyi8NFFmATTF3HhF/n0780z/KSs5bMWpB
BEU3bPXUM+TWlOE0qT/rG0oBbhtpR4RDbQvO9D12P86T9hW4NQYnbOxfPkWSoECk
e3wIVHUiEkyRQaFLER86F3uHHfHB5Ka+sK1Yyo1AY6hpySb2aMeaH/+mJSqSql3d
UXOB5AbW0CXMimD722uASNjkE5Uu3+V7TmRGjZa700wa+LFGlKgmYMoGZhEEZzMe
PRarTDY8i2PsmmFuQpHATzGmRUVmQaLdDzAUduKij+i1kPg7e5HN2kmnfNfTQsfL
WyPW6HW1430e7GYd8T/Ax45Fz60lHd5hCLz6dl3SUXvK15a0Tikiir4jf8/NwoLT
PPj+/YL69IwhR+IsqhasYoHkHFFRAOfKs86EnIn5K7oTJdToGciRubMHdAMnY0cr
1Z8C5alYfg8O+8mU+Puzo3i100HRuTv5wIhaEBHK4NB5sLqGsToRVINuRemYGmce
7H0tVif2IU0tr2KTggdfNYBKOXOa+GxMy0ZkR+y63clbVXoaUbRpELFwYr23pepM
5yAQXG3wNTgGN4neOH1RayZnH7wwsaimrJwC8boNzgBn/xfVUCHbD1OGhnZ/AVJC
sHY21swTawWgjpJpZuNcPCWsv5Gxk3yOMjHh7OLncA1pMqh60duXBiKsRmJh2vzw
zvDzUcjJc7A=
=cdmf
-----END PGP SIGNATURE-----

--=-LSSLgFTsibMQ5Quj4t7W--
