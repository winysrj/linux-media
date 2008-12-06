Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6Hgv6F024737
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 12:42:57 -0500
Received: from smtp-out112.alice.it (smtp-out112.alice.it [85.37.17.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6Hg9ns016066
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 12:42:09 -0500
Date: Sat, 6 Dec 2008 18:42:00 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jim Paris <jim@jtan.com>
Message-Id: <20081206184200.703fb8e0.ospite@studenti.unina.it>
In-Reply-To: <20081204171546.GA27230@psychosis.jim.sh>
References: <patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204130557.85799da0.ospite@studenti.unina.it>
	<patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204171546.GA27230@psychosis.jim.sh>
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
Content-Type: multipart/mixed; boundary="===============0682703730=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0682703730==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Sat__6_Dec_2008_18_42_00_+0100_=IdPx/izvt10.C5/"

--Signature=_Sat__6_Dec_2008_18_42_00_+0100_=IdPx/izvt10.C5/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Dec 2008 12:15:46 -0500
Jim Paris <jim@jtan.com> wrote:

>=20
> Antonio Ospite wrote:
> > Tested the latest version, I am getting "payload error"s setting
> > frame_rate=3D50, loosing about 50% of frames. I tried raising
> > bulk_size but then I get "frame overflow" errors from gspca, I'll
> > investigate further.
>=20
> I don't think I see any payload errors even at 50fps.  For the bulk
> size, I'm not sure exactly how the payloads work into that.  I suppose
> that when bulk_size is larger than the camera's payload size (2048),
> we get another payload header at data[2048] but don't pay attention to
> it.  If this header had the EOF then we can send gspca too much data,
> causing frame overflow.  (there's no overflow check in ov534 since
> gspca handles it already).
>
> With the current setup, we're essentially getting a UVC stream.  This
> makes sense since the marketing for ov534 says it supports UVC.  So
> some documentation for this would be
>   http://www.usb.org/developers/devclass_docs/USB_Video_Class_1_1.zip
>

I need to read something more about UVC.

Ah, and from a quick test on PS3 it looks like the header is not added
here, but I haven't had the chance to see what exactly happened.

Hope to post some news soon.

Regards,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Sat__6_Dec_2008_18_42_00_+0100_=IdPx/izvt10.C5/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk6uWgACgkQ5xr2akVTsAGCkgCfWKx/esUOsrZuPKyU76iHnG8k
KTcAnjyyIFfPqwTVchD5CjKuNQ92jh5h
=9N0g
-----END PGP SIGNATURE-----

--Signature=_Sat__6_Dec_2008_18_42_00_+0100_=IdPx/izvt10.C5/--


--===============0682703730==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0682703730==--
