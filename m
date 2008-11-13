Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADH57v4012028
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:05:07 -0500
Received: from smtp-out113.alice.it (smtp-out113.alice.it [85.37.17.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADH4T0S013156
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:04:46 -0500
Date: Thu, 13 Nov 2008 18:04:21 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081113180421.09c5ca05.ospite@studenti.unina.it>
In-Reply-To: <1226576038.2040.42.camel@localhost>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
	<4919E47E.4000603@hhs.nl>
	<20081112191736.bcbc1e37.ospite@studenti.unina.it>
	<1226576038.2040.42.camel@localhost>
Mime-Version: 1.0
Cc: 
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1497291103=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1497291103==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__13_Nov_2008_18_04_21_+0100_8SSrkHRwZrRX8U9K"

--Signature=_Thu__13_Nov_2008_18_04_21_+0100_8SSrkHRwZrRX8U9K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Nov 2008 12:33:58 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 2008-11-12 at 19:17 +0100, Antonio Ospite wrote:
> > Well, with my hacks to gspca.c the ov534 driver has become really
> > trivial. The source has shrunk from 33K to 13K. But these hacks could
> > not be accepted though :) But, yes, the opinion on gspca is positive.
>=20
> Hello Antonio,
>=20
> Thank you for your opinion.
>=20
> I looked again at your subdriver, and it seems good to me. So forget
> about mine which is too buggy.
>=20
> About your hacks to gspca, there are good and bad ideas. The good idea
> is to have the bulk_nurbs parameter. The bad idea is to force it to one
> when no set. To preserve the compatibility, the bulk_nurbs may be set to
> some value for webcams which accept permanent bulk read, the submit
> being done by gspca. For the other webcams, as those in finepix, a null
> bulk_nurbs will indicate that the bulk read requests are done by the
> subdriver. Is it OK for you?
>

So (cam->bulk_nurbs =3D=3D 0) would mean that the subdriver takes care of
usb tranfers, right? That would also imply that bulk_irq() is not set
for these drivers and sd_pkt_scan() is never called which looks fair to
me.

If this is really ok I'll update my changes and send for review.

> Also, I saw a little problem in your subdriver: in pkt_scan, you use a
> static variable (count). This does not work with many active webcams and
> also after stop / restart streaming. Instead, you may know the current
> byte count using the frame values data and data_end.
>

I'll take a look at that too, thanks for the hints.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Thu__13_Nov_2008_18_04_21_+0100_8SSrkHRwZrRX8U9K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkcXhUACgkQ5xr2akVTsAGhbQCeKLUdufBAP8WwFk9sdY1FCpeI
VI0An2BmDy4vN5K0WaQeQ96tio8z7P2B
=MsTE
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Nov_2008_18_04_21_+0100_8SSrkHRwZrRX8U9K--


--===============1497291103==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1497291103==--
