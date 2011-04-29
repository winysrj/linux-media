Return-path: <mchehab@pedra>
Received: from smtp208.alice.it ([82.57.200.104]:40125 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759833Ab1D2QQN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 12:16:13 -0400
Date: Fri, 29 Apr 2011 18:16:04 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Drew Fisher <drew.m.fisher@gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] gspca - kinect: move
 communications buffers out of stack
Message-Id: <20110429181604.df0e6de8.ospite@studenti.unina.it>
In-Reply-To: <4DBADCBB.8000107@redhat.com>
References: <E1QFowG-0005SZ-7v@www.linuxtv.org>
	<20110429172715.4b71dfb6.ospite@studenti.unina.it>
	<4DBADCBB.8000107@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Apr_2011_18_16_04_+0200_7/eUGuFX543WUi6F"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Fri__29_Apr_2011_18_16_04_+0200_7/eUGuFX543WUi6F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Apr 2011 12:43:55 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 29-04-2011 12:27, Antonio Ospite escreveu:
> > On Fri, 29 Apr 2011 16:42:04 +0200
> > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> >=20
> >> This is an automatic generated email to let you know that the followin=
g patch were queued at the=20
> >> http://git.linuxtv.org/media_tree.git tree:
> >>
> >> Subject: [media] gspca - kinect: move communications buffers out of st=
ack
> >> Author:  Antonio Ospite <ospite@studenti.unina.it>
> >> Date:    Thu Apr 21 06:51:34 2011 -0300
> >>
> >=20
> > Hi Mauro, actually this one is from Drew Fisher as well, git-am should
> > have picked up the additional From header:
> > http://www.spinics.net/lists/linux-media/msg31576.html
>=20
> Gah!
>=20
> Patchwork suffered a crash. Patches got recovered yesterday, but all of t=
hem missed
> the e-mail body:
> 	https://patchwork.kernel.org/patch/724331/
>=20
> I'm needing to manually edit each patch before applying due to that.
>

Just FYI, gmane stores a raw representation of messages which can be
used with git-am, take:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/317=
35
and add /raw at the end of the URL.

> I'll revert the patch and re-apply it with the proper authorship.
>=20

Thanks a lot.

Best regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__29_Apr_2011_18_16_04_+0200_7/eUGuFX543WUi6F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk265EQACgkQ5xr2akVTsAEE0gCfarGOs5fGorYqAqeJBcoMnBo/
UZYAoJnRhB4RSCw2soHZmUPfiuhgwCEC
=iVj6
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Apr_2011_18_16_04_+0200_7/eUGuFX543WUi6F--
