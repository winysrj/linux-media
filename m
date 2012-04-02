Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44516 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2DBRYT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 13:24:19 -0400
Date: Mon, 2 Apr 2012 19:24:10 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9035: Add fc0011 tuner support
Message-ID: <20120402192410.1dd6cbc1@milhouse>
In-Reply-To: <4F79DBCC.6070803@iki.fi>
References: <20120402181836.0018c6ad@milhouse>
	<4F79DBCC.6070803@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Th4J55VN+cgw3iekn2AECyg"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Th4J55VN+cgw3iekn2AECyg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Apr 2012 20:03:08 +0300
Antti Palosaari <crope@iki.fi> wrote:

> On 02.04.2012 19:18, Michael B=C3=BCsch wrote:
> > This adds Fitipower fc0011 tuner support to the af9035 driver.
> >
> > Signed-off-by: Michael Buesch<m@bues.ch>
>=20
> Applied, thanks!
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_e=
xperimental
>=20
> And same checkpatch.pl issue here.
> You can ran checkpatch like that:
> git diff | ./scripts/checkpatch.pl -
> git diff --cached | ./scripts/checkpatch.pl -
> ./scripts/checkpatch.pl --file drivers/media/dvb/dvb-usb/af9035.c
>=20
> For that driver it complains you are using wrong sleep (msleep(10)).=20
> Correct sleep for that case is something like usleep_range(10000,=20
> 100000); which means as sleep at least 10ms but it does not matter if=20
> you sleep even 100ms. The wider range the better chance for Kernel to=20
> optimize power saving. There was usleep_range() already used inside that=
=20
> module.

Ok, the sleep warning is the only remotely sane checkpatch warning for these
patches. So I will send a separate patch to convert those sleeps.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/Th4J55VN+cgw3iekn2AECyg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPeeC6AAoJEPUyvh2QjYsOQlsP/3e3b5xujvbOFXWxASfobf7O
eYQrnb8t7vgY/VMmGkuosLlJdLDYLNpQdoMKQegnKVnokgFXmzjzLHoanWJxFb+6
FOcd11yYHH6rMMiLGvG4Ed8sJ+CxEPynggYcHKpGBdiFTS/Btv16DENT3SanSYmi
4zHp/gBOHdSNn/6VuMwyd1dg5dR6aRaa1h6g2bZ1R8gA1jgRIzIeSCAlJisf6SHw
WDskJXfQNk2tx7rJLPWjWRc0iipmwroHGvOVJymOojlXOWPaU3sNjYqE633iQ9pv
kyCIAcmKnF+W/jUP6luMa5m33okqfAbfxAPyvzcUti349D9QT8gdTnGFS9Fb7IkP
xHMjtW5yw9XbYSGG+456ioHK/P9kSqvrbcyF21bky/9JdUqi2NLp9Hjcll/GMGe2
PXyx3QtrU71oyLvOiZ/Obm5PC3ICoKad1XNAMJnynWhGikr5jnE6O9PEalMXJn0A
7gtrKXhJx+UeHXt7NbbNbxV5EOiZG1tWtQYsyJo+6s/I1b1g+avi9an88nm9Bkh4
9I/qP1ZCS50DPqPUnSFb/SJJcWOFHqYS/3Epl6+hxiFclm/JSrOGg9riYp6FELFH
5U0fgHfu3tIHZIaKF5e8yQLL2U1Psqw+rzUGqkIF+y3rI22stxpU6qhdX4xApfNg
BAvHS+U/l9Zug9BDtgOS
=GpB1
-----END PGP SIGNATURE-----

--Sig_/Th4J55VN+cgw3iekn2AECyg--
