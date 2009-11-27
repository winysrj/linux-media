Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out114.alice.it ([85.37.17.114]:4027 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZK0Ujp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 15:39:45 -0500
Date: Fri, 27 Nov 2009 21:39:39 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 0/3] pxa_camera: remove init() callback
Message-Id: <20091127213939.9bb235fa.ospite@studenti.unina.it>
In-Reply-To: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_21_39_39_+0100_eFNtnEH.XsZrDv6."
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__27_Nov_2009_21_39_39_+0100_eFNtnEH.XsZrDv6.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Nov 2009 23:04:20 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Hi,
>=20
> this series removes the init() callback from pxa_camera_platform_data, and
> fixes its users to do initialization statically at machine init time.
>=20
[...]
> Antonio Ospite (3):
>   em-x270: don't use pxa_camera init() callback
>   pcm990-baseboard: don't use pxa_camera init() callback

Eric, if Guennadi ACKs v2 for these two please apply them only, we are
postponing the third one, hence you can discard it.

>   pxa_camera: remove init() callback
>=20

Thanks,
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

--Signature=_Fri__27_Nov_2009_21_39_39_+0100_eFNtnEH.XsZrDv6.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksQOQsACgkQ5xr2akVTsAHcqgCfTni8YHyk12OvfG9SiT/XVvv2
GmoAn1fSPgksscLc/JeRh3gduCvsnwwB
=SbDF
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_21_39_39_+0100_eFNtnEH.XsZrDv6.--
