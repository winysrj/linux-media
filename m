Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBAG8BZE022817
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 11:08:12 -0500
Received: from smtp-out112.alice.it (smtp-out112.alice.it [85.37.17.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBAG7sRk010354
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 11:07:55 -0500
Date: Wed, 10 Dec 2008 17:07:44 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jim Paris <jim@jtan.com>
Message-Id: <20081210170744.7af273f8.ospite@studenti.unina.it>
In-Reply-To: <20081209212127.GB21038@psychosis.jim.sh>
References: <patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204130557.85799da0.ospite@studenti.unina.it>
	<patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204171546.GA27230@psychosis.jim.sh>
	<20081206184200.703fb8e0.ospite@studenti.unina.it>
	<20081209212127.GB21038@psychosis.jim.sh>
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
Content-Type: multipart/mixed; boundary="===============1616253017=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1616253017==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__10_Dec_2008_17_07_44_+0100_YolseSfyXeG5lDb7"

--Signature=_Wed__10_Dec_2008_17_07_44_+0100_YolseSfyXeG5lDb7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Dec 2008 16:21:27 -0500
Jim Paris <jim@jtan.com> wrote:

> Antonio Ospite wrote:
> > I need to read something more about UVC.
>=20
> Me too.  This bridge chip supports it -- maybe we just need to tweak
> the USB descriptors so that the existing UVC driver knows what to do?
>=20
> > Ah, and from a quick test on PS3 it looks like the header is not added
> > here, but I haven't had the chance to see what exactly happened.
>=20
> I'm relying on power on defaults, but we can also enable the header
> explicitly if that's more reliable.
>=20
> -jim
>=20
> --
>=20
> ov534: explicitly initialize frame format
>

With this one, plus:
ov534: improve payload handling

the PlayStation eye works again on PS3 at 30fps.

I haven't tested on PC at high frame rate yet, my main PC is broken
right now. I'll also add QVGA resolution as soon as it is fixed, 320x240
is handy for skype and co.

Jim, do you think a _per_resolution_ frame rate table is acceptable for
now? We can switch to a formula in a second time if we figure out how to
do that. I guess that registers values controlling frame rate are a
function of the frame size, right?

Thanks,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__10_Dec_2008_17_07_44_+0100_YolseSfyXeG5lDb7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk/6VAACgkQ5xr2akVTsAE/pwCgpqCfUALT2XL3jfUVUY+vMp02
qhwAn0BDWxIKhmCWnJOHPBUygoLbSMGJ
=6ixX
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Dec_2008_17_07_44_+0100_YolseSfyXeG5lDb7--


--===============1616253017==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1616253017==--
