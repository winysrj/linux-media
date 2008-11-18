Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIECqfX018155
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 09:12:52 -0500
Received: from smtp-out26.alice.it (smtp-out26.alice.it [85.33.2.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAIECZh8004379
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 09:12:36 -0500
Date: Tue, 18 Nov 2008 15:12:22 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-Id: <20081118151222.8eca780e.ospite@studenti.unina.it>
In-Reply-To: <4922BA7D.7010303@hhs.nl>
References: <200811172253.33396.linux@baker-net.org.uk>
	<4922924B.8050302@hhs.nl>
	<62e5edd40811180200q614d0a32l68c0e47f043d225d@mail.gmail.com>
	<4922A0FD.2040108@hhs.nl>
	<62e5edd40811180338q2527233aw37b91734465f6b49@mail.gmail.com>
	<4922BA7D.7010303@hhs.nl>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net
Subject: Re: Advice wanted on producing an in kernel sq905 driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0897324577=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0897324577==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Tue__18_Nov_2008_15_12_22_+0100_O9f=8w9GfFgSZ2wO"

--Signature=_Tue__18_Nov_2008_15_12_22_+0100_O9f=8w9GfFgSZ2wO
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Nov 2008 13:52:13 +0100
Hans de Goede <j.w.r.degoede@hhs.nl> wrote:

> Erik Andr=E9n wrote:
>
> >=20
> > I'm currently in the process of porting the old quickcam driver [1] to
> > the gspca framework sofar I have working video using the vv6410
> > sensor. Next step is to get the hdcs and pb0100 sensors up to speed.
> > The driver will be tracked in
> > http://linuxtv.org/hg/~eandren/gspca-stv06xx/ (nothing pushed yet)
> >=20
>=20
> Good! and <ugh> I've been working on the same, I'm nowhere near as far as=
 you=20
> though, can you please put a tarbal or whatever somewhere, then I can see=
 if=20
> there is anything in my version worth salvaging to improve your driver in=
 some=20
> points.
>

:) I also planned to work on this after the ov534 driver, I can do
some testing if needed.
=20
> I've access to an pb0100 using cam.
>

Me too, eager to have it working in mainline.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Tue__18_Nov_2008_15_12_22_+0100_O9f=8w9GfFgSZ2wO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkizUYACgkQ5xr2akVTsAH6gACfRfVXQQMcT0cweB/PUJoxpUrr
q50Ani8KfHYRr6knM4OHVtkYnVOw0WtE
=+OBm
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Nov_2008_15_12_22_+0100_O9f=8w9GfFgSZ2wO--


--===============0897324577==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0897324577==--
