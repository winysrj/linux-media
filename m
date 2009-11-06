Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:4479 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZKFRjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 12:39:45 -0500
Date: Fri, 6 Nov 2009 18:39:42 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX
 phones
Message-Id: <20091106183942.2411ef35.ospite@studenti.unina.it>
In-Reply-To: <87y6mjlh1m.fsf@free.fr>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
	<f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
	<Pine.LNX.4.64.0911040907400.4837@axis700.grange>
	<20091104123536.9b95d161.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911061720570.4389@axis700.grange>
	<87y6mjlh1m.fsf@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Nov_2009_18_39_42_+0100_Z7CCwUvrlrpgDijZ"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__6_Nov_2009_18_39_42_+0100_Z7CCwUvrlrpgDijZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Nov 2009 18:05:57 +0100
Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>=20
> > Good that you mentioned this. In fact, I think, that .init should go. S=
o=20
> > far it is used in pcm990-baseboard.c to initialise pins. You're doing=20
> > essentially the same - requesting and configuring GPIOs. And it has bee=
n=20
> > agreed, that there is so far no real case, where a static=20
> > GPIO-configuration wouldn't work. So, I would suggest you remove .init,=
=20
> > configure GPIOs statically. And then submit a patch to remove .init=20
> > completely from struct pxacamera_platform_data. Robert, do you agree?
>=20
> Yes, fully agree, I think too that GPIO should be static.
>

Well, the other drivers I am using (pxamci, ezx-pcap, gpio-keys,
to mention some) request and configure GPIOs during their own
init/probe, they don't require the *board* init code to configure them.

But if you really like the static way I'll bend to your will.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__6_Nov_2009_18_39_42_+0100_Z7CCwUvrlrpgDijZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr0X14ACgkQ5xr2akVTsAET5ACfTV/6Aw6DViOcOcUp/qiGDaRf
pIIAni3z2MU9vWPnXuVCOzRCtx9hhKX6
=/yaY
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Nov_2009_18_39_42_+0100_Z7CCwUvrlrpgDijZ--
