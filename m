Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4C6bV9023853
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 07:06:37 -0500
Received: from smtp-out26.alice.it (smtp-out26.alice.it [85.33.2.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4C6AkN026182
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 07:06:10 -0500
Date: Thu, 4 Dec 2008 13:05:57 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Message-Id: <20081204130557.85799da0.ospite@studenti.unina.it>
In-Reply-To: <1228378442.1733.17.camel@localhost>
References: <patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 4] ov534 patches
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1965307796=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1965307796==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__4_Dec_2008_13_05_57_+0100_sqhHkTSoLukg67Nr"

--Signature=_Thu__4_Dec_2008_13_05_57_+0100_sqhHkTSoLukg67Nr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 04 Dec 2008 09:14:02 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 2008-12-03 at 15:46 -0500, Jim Paris wrote:
> > Hi,
>

Thanks Jim.

> Hi Jim,
>=20
> > Here are some ov534 patches I've been working on.
> >=20
> > ov534: don't check status twice
> > ov534: initialization cleanup
> > ov534: Fix frame size so we don't miss the last pixel
> > ov534: frame transfer improvements
>=20
> Thank you for these patchs. Some changes were already done in my
> repository. I merged them and pushed. May you check if everything is
> correct?
>=20

Tested the latest version, I am getting "payload error"s setting
frame_rate=3D50, loosing about 50% of frames. I tried raising bulk_size
but then I get "frame overflow" errors from gspca, I'll investigate
further.

Regards,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Thu__4_Dec_2008_13_05_57_+0100_sqhHkTSoLukg67Nr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk3x6UACgkQ5xr2akVTsAF3nQCgliT1CoDOc5RTqcKDUFPBbC0T
mMMAnAooEJWDiig6MTqec8OYhZb1lJaw
=+oXA
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Dec_2008_13_05_57_+0100_sqhHkTSoLukg67Nr--


--===============1965307796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1965307796==--
