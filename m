Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763Ab3E3BKv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 21:10:51 -0400
Message-ID: <1369876224.3469.444.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT PULL] go7007 firmware updates
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-media <linux-media@vger.kernel.org>,
	Pete Eberlein <pete@sensoray.com>, mchehab@redhat.com
Date: Thu, 30 May 2013 02:10:24 +0100
In-Reply-To: <201305280842.01068.hverkuil@xs4all.nl>
References: <201305231025.31812.hverkuil@xs4all.nl>
	 <201305272156.18975.hverkuil@xs4all.nl>
	 <1369691595.3469.404.camel@deadeye.wl.decadent.org.uk>
	 <201305280842.01068.hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-tzixmyz75p3ylmTv3JHb"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-tzixmyz75p3ylmTv3JHb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-05-28 at 08:42 +0200, Hans Verkuil wrote:
> On Mon May 27 2013 23:53:15 Ben Hutchings wrote:
> > On Mon, 2013-05-27 at 21:56 +0200, Hans Verkuil wrote:
> > > On Mon May 27 2013 18:24:32 Ben Hutchings wrote:
> > > > On Thu, 2013-05-23 at 10:25 +0200, Hans Verkuil wrote:
> > > > > Hi Ben, David,
> > > > >=20
> > > > > The go7007 staging driver has been substantially overhauled for k=
ernel 3.10.
> > > > > As part of that process the firmware situation has been improved =
as well.
> > > > >=20
> > > > > While Micronas allowed the firmware to be redistributed, it was n=
ever made
> > > > > part of linux-firmware. Only the firmwares for the Sensoray S2250=
 were added
> > > > > in the past, but those need the go7007*.bin firmwares as well to =
work.
> > > > >=20
> > > > > This pull request collects all the firmwares necessary to support=
 all the
> > > > > go7007 devices into the go7007 directory. With this change the go=
7007 driver
> > > > > will work out-of-the-box starting with kernel 3.10.
> > > > [...]
> > > >=20
> > > > You should not rename files like this.  linux-firmware is not versi=
oned
> > > > and needs to be compatible with old and new kernel versions, so far=
 as
> > > > possible.
> > >=20
> > > I understand, and I wouldn't have renamed these two firmware files if=
 it
> > > wasn't for the fact that 1) it concerns a staging driver, so in my vi=
ew
> > > backwards compatibility is not a requirement,
> >=20
> > This driver (or set of drivers) has been requesting go7007fw.bin,
> > go7007tv.bin, s2250.fw and s2250_loader.fw for nearly 5 years.  It's a
> > bit late to say those were just temporary filenames.
>=20
> Why not? It is a staging driver for good reasons. Just because it is in s=
taging
> for a long time (because nobody found the time to actually work on it unt=
il
> 3.10) doesn't mean it magically becomes non-staging. The Kconfig in stagi=
ng
> says:
>=20
>           This option allows you to select a number of drivers that are
>           not of the "normal" Linux kernel quality level.  These drivers
>           are placed here in order to get a wider audience to make use of
>           them.  Please note that these drivers are under heavy
>           development, may or may not work, and may contain userspace
>           interfaces that most likely will be changed in the near
>           future.
>=20
> In other words, there are no guarantees. That's the whole point of stagin=
g.
[...]

But the reality is that many drivers don't get that heavy development,
and so they linger in staging for a long time.  So it shouldn't be
surprising that users start to rely on them, and distributions ship
them, and then it's a bit rough to pull the rug from under them some
years later.

I don't know how true that is of go7007 but I'd like to avoid causing
regressions.  So I've pulled from you, but I've then added back s2250.fw
and s2250_loader.fw as symlinks.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-tzixmyz75p3ylmTv3JHb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaanAOe/yOyVhhEJAQqIPw//fDDsanZ+KWFdHEe3XcDqlDuyE2aBMlSZ
e+telGeXiQUaKQyAyjvjCmYs+hfb1thsoOcWUNwn1ZMzp/24q0UpaBK6I2iEnswX
3IbsQDcxyFMJ4fvoAkpTV1RdsZ6xPfWdDO+ezTggYmyryvR77ZycLPEmM9+rhzTz
JX9xVO1p2kqCJR2vSIf7y7MiHm+zOiv+6LkC1zkjxRq1rtp8p0b+cntgaA/Ywxmn
bzRJYTFVO4hYg4cQ8biyslCZfAjfa1GMa2a3vc5yRNTtJ5YlLghxsEcWpIijgCUv
0QYSc07pdhjZD8rvVVVhlUIiko7gPYdLRbpoJX+aVMVUiJ/wn4fqrbDvFTbWtt+u
abwZXrtCWG2k7IPpufyZxHf2sMPOj2+WA/Uz6Nqr0ui+o9MHxXq8/h7Pf7Za1tFn
AneFAbgeZBhsuzTHsXfgFbDWz1/QBgv9Si8kbnC+T+F1T9bIAegdDIcGDoTE+93T
ZXuM+alSqSmHlnrIbMvWBVLpfTnjg4zRUkfYQsaM4LsVJGt2gZI5rgRn9WVHHLuh
qxZxXJAMcoy0fsA4Qvlqafgru2d9OgfTJqUNK3IwES1NHXXm3cQTUCgS9CWcKpuG
Bd6DYu1tkVMXXUyBBkKAnOCxaAREClQDivwFaccrlqxA+qA+Tiz9WuvP7Z2AkXOy
F+jdLQ0TRK8=
=mVaE
-----END PGP SIGNATURE-----

--=-tzixmyz75p3ylmTv3JHb--
