Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3Iq2Tf026098
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:52:02 -0500
Received: from smtp-out28.alice.it (smtp-out28.alice.it [85.33.2.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3Ipk9r008382
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:51:47 -0500
Date: Wed, 3 Dec 2008 19:51:37 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-Id: <20081203195137.6ccb5d76.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0812012148060.3915@axis700.grange>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
	<874p2jbegl.fsf@free.fr>
	<Pine.LNX.4.64.0811082119280.8956@axis700.grange>
	<20081109235940.4c009a68.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0811101946200.8315@axis700.grange>
	<878wrr9z9h.fsf@free.fr>
	<20081112192746.f59ee94d.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0812012148060.3915@axis700.grange>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH, RFC] mt9m111: allow data to be received on pixelclock
 falling edge?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0452275433=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0452275433==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__3_Dec_2008_19_51_37_+0100_DJk9R6g0oafZ9g.P"

--Signature=_Wed__3_Dec_2008_19_51_37_+0100_DJk9R6g0oafZ9g.P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Dec 2008 21:54:17 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi Antonio,
>=20
> On Wed, 12 Nov 2008, Antonio Ospite wrote:
>=20
> > On Mon, 10 Nov 2008 20:06:34 +0100
> > Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> >=20
> >
> > >=20
> > > I can't think of a better solution than an inverter flag as well. As =
this would
> > > be very board specific, let it go in something board code sets up.
> > >=20
> > > That's how it's already done for inverted gpio Vbus sensing in the US=
B stack for
> > > the pxa for example.
> > >=20
> >=20
> > Ok, I hope you'll find time to add the proper solution some day, since I
> > don't think I can do it correctly with my current knowledge.
>=20
> Could you test the patch below? It applies on top of all my patches I=20
> pushed today plus a couple more that are still to be pushed... But maybe=
=20
> you can apply it to linux-next manually. You just need the parts for=20
> soc_camera.h and for mt9m111. And then you need to add to your struct=20
> soc_camera_link in platform data:
>=20
> 	.flags =3D SOCAM_SENSOR_INVERT_PCLK,
>=20

Thanks Guennadi, I can't test it before week-end. If by then you have a
single patchset, please let me know.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__3_Dec_2008_19_51_37_+0100_DJk9R6g0oafZ9g.P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk21TkACgkQ5xr2akVTsAHfCgCfRZWYS2jHjI2+yJWvslNQjDUv
QfsAn33IthNExUpvpBIFGEr/prnij/m1
=u7Bq
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Dec_2008_19_51_37_+0100_DJk9R6g0oafZ9g.P--


--===============0452275433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0452275433==--
