Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1HAT8xQ017176
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 05:29:08 -0500
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1HASrrC027846
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 05:28:54 -0500
Date: Tue, 17 Feb 2009 11:28:33 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-Id: <20090217112833.73bc9a13.ospite@studenti.unina.it>
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
Content-Type: multipart/mixed; boundary="===============0034508157=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0034508157==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Tue__17_Feb_2009_11_28_33_+0100_xAP9xVrL4rZZRwEz"

--Signature=_Tue__17_Feb_2009_11_28_33_+0100_xAP9xVrL4rZZRwEz
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
> > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> > >=20
> > > > I would prefer not to disregard camera flags. If we don't find a be=
tter=20
> > > > solution, I would introduce platform inverter flags, and, I think, =
we=20
> > > > better put them in camera platform data - not host platform data, t=
o=20
> > > > provide a finer granularity. In the end, inverters can also be loca=
ted on=20
> > > > camera boards, then you plug-in a different camera and, if your=20
> > > > inverter-flags were in host platform data, it doesn't work again.
> > >
> > > I'm of the same opinion.
> > >=20
> > > I was thinking of another case : imagine the host needs to be configu=
red on
> > > rising edge, and camera on falling edge. Your patch wouldn't cover th=
at devious
> > > case.
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
> Thanks
> Guennadi

Sorry for the absurdly late reply :)

I had the chanche to test this today and it works OK.

Thanks once again,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Tue__17_Feb_2009_11_28_33_+0100_xAP9xVrL4rZZRwEz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmakVEACgkQ5xr2akVTsAGN8ACdGhLO5XxpmVvxoIT8FLUFVX0y
oI0AoKi9NeWy3JwoAXW5C+pMaDUagCAK
=V+7Y
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Feb_2009_11_28_33_+0100_xAP9xVrL4rZZRwEz--


--===============0034508157==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0034508157==--
