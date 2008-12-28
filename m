Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBSAND6D031505
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 05:23:13 -0500
Received: from smtp-out114.alice.it (smtp-out114.alice.it [85.37.17.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBSAMsg1007684
	for <video4linux-list@redhat.com>; Sun, 28 Dec 2008 05:22:55 -0500
Date: Sun, 28 Dec 2008 11:22:45 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: xelapond <xelapond@gmail.com>
Message-Id: <20081228112245.7989bded.ospite@studenti.unina.it>
In-Reply-To: <99cd09480812272114n356fd157o5a416b46e1723250@mail.gmail.com>
References: <99cd09480812272114n356fd157o5a416b46e1723250@mail.gmail.com>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: PS3Eye on Debian
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1515110074=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1515110074==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Sun__28_Dec_2008_11_22_45_+0100_jJEWqB8bKWOiYcrD"

--Signature=_Sun__28_Dec_2008_11_22_45_+0100_jJEWqB8bKWOiYcrD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Dec 2008 00:14:32 -0500
xelapond <xelapond@gmail.com> wrote:

> Hello,
>=20
> I have been trying to get my PS3Eye Camera to work on Debian, and to part=
ial
> success.  I did as recommended
> here<http://forums.ps2dev.org/viewtopic.php?t=3D9238>and
> got the gspca sources from
> http://linuxtv.org/hg/~jfrancois/gspca/, and compiled those.  It compiled
> successfully(it complained about __memcpy once, but nothing big).  I can =
now
> access the camera through /dev/video0.  It works fine in
> gstreamer-properties, but when I try to open it in anything else(for
> instance mplayer), I get errors.  I have posted the output of mplayer bel=
ow:
>=20
> alex@Andromeda:~$ mplayer -vo ov534 -ao alsa -tv
> driver=3Dv4l2:device=3D/dev/video0 tv://

try removing -vo ov534, it is definitely wrong.

>=20
> Any ideas how I can get this to work?  Ultimately I would like to be able=
 to
> use the camera within openFrameworks, which uses unicap.

If unicap can handle yuyv then it will work, otherwise you have to use
libv4lconvert in some way.

Regards,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Sun__28_Dec_2008_11_22_45_+0100_jJEWqB8bKWOiYcrD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklXU3YACgkQ5xr2akVTsAGoagCfe2YEMINyhfynp7Prmn7u9tKB
Mb0AnjTvpeytqdT9vDMBiuvcXjLOQSCA
=sDXH
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Dec_2008_11_22_45_+0100_jJEWqB8bKWOiYcrD--


--===============1515110074==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1515110074==--
