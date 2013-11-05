Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53147 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3KEWPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 17:15:55 -0500
Received: by mail-qa0-f46.google.com with SMTP id j7so1481912qaq.5
        for <linux-media@vger.kernel.org>; Tue, 05 Nov 2013 14:15:54 -0800 (PST)
Date: Tue, 5 Nov 2013 19:11:51 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] SOLO6x10: Fix video headers on certain hardware.
Message-ID: <20131105191151.0029b90e@pirotess.bifrost.iodev.co.uk>
In-Reply-To: <m338pab47d.fsf@t19.piap.pl>
References: <m338pab47d.fsf@t19.piap.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aWCNM7/sI5N+2QFEoCtI/0H"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/aWCNM7/sI5N+2QFEoCtI/0H
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Sep 2013 14:43:34 +0200
khalasa@piap.pl (Krzysztof Ha=C5=82asa) wrote:
> On certain platforms a sequence of dma_map_sg() and dma_unmap_sg()
> discards data previously stored in the buffers. Build video headers
> only after the DMA is completed.
>=20
> Signed-off-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>
>=20

Acked-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

<...>

--Sig_/aWCNM7/sI5N+2QFEoCtI/0H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAEBAgAGBQJSeW0nAAoJEBrCLcBAAV+Gef4IAKJsozP8ZrmcqWrcRu6rlZz6
oNjT2ZaPX7y3KHPtkf0Y7R70+qgKxzSA9wmhV38W72Snr8/zqB1+kG8Ao7KkYOnu
XW/Mtl9fYDf09omJRsRQ8KOL7DUkygC7Gq6mUOQ14usAxnk6kSWMOobXGoqOH9GB
sru2vt+1sUQw0Xs1Tgxg5WB8mpPtUw9DcdXLjfmub4YGsJJUd+Zk2PsEzINVm1AH
oSF2iiMlaF3/PxvzKtXQo44qVZtrm8Cxdmg4+yq7ENc0dazr8ZAcHSSoFBMhdM4d
n27Wn6Wz0opywdJxfoCKhxIBGIu21oSzhmjfFzLScjJweGcqWwtiP4bEhNCxr4g=
=Sxuh
-----END PGP SIGNATURE-----

--Sig_/aWCNM7/sI5N+2QFEoCtI/0H--
