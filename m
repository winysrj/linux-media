Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAEE4O8g026942
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 09:04:24 -0500
Received: from smtp-out112.alice.it (smtp-out112.alice.it [85.37.17.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAEE49U9005967
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 09:04:10 -0500
Date: Fri, 14 Nov 2008 15:04:02 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Message-Id: <20081114150402.72b66ed9.ospite@studenti.unina.it>
In-Reply-To: <1226660130.1737.22.camel@localhost>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
	<4919E47E.4000603@hhs.nl>
	<20081112191736.bcbc1e37.ospite@studenti.unina.it>
	<1226576038.2040.42.camel@localhost>
	<20081113180421.09c5ca05.ospite@studenti.unina.it>
	<1226601059.1705.12.camel@localhost>
	<20081113233554.65c5a5f4.ospite@studenti.unina.it>
	<1226660130.1737.22.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1269721306=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1269721306==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Fri__14_Nov_2008_15_04_02_+0100_aRZ3Fm8GSGqhc1Lg"

--Signature=_Fri__14_Nov_2008_15_04_02_+0100_aRZ3Fm8GSGqhc1Lg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Nov 2008 11:55:30 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Thu, 2008-11-13 at 23:35 +0100, Antonio Ospite wrote:
> > > I attached the patch of the main driver.
> >=20
> > Many thanks Jean-Francois, any ETA of this change in mainline?
>=20
> Sorry, what do you mean by ETA? I uploaded the patch to my repository
> with you as the author.
>

ETA: Estimated Time of Arrival.
I wondered if you had an idea about when the change will hit Linus
tree, just that.

> > > +		if (gspca_dev->cam.bulk_nurbs !=3D 0)
> > > +			nurbs =3D gspca_dev->cam.bulk_nurbs;
> >=20
> > should we set this to min(gspca_dev->cam.bulk_nurbs, MAX_NURBS) ?
>=20
> Yes, we should, but, if a greater value is set, the subdriver will crash
> at the first development test...
>

Ok, if you think that having subdriver crash during development is ok,
then it is perfectly fine with me too.

Back to ov534 now :)

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Fri__14_Nov_2008_15_04_02_+0100_aRZ3Fm8GSGqhc1Lg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkdhVIACgkQ5xr2akVTsAGB5wCeKSei9dbbUHdG6RwMLjjmRYMY
tUoAnRDJili0pJmU9vZTGeBGiINjOScT
=/6uT
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Nov_2008_15_04_02_+0100_aRZ3Fm8GSGqhc1Lg--


--===============1269721306==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1269721306==--
