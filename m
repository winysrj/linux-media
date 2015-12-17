Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33264 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbLQXEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 18:04:16 -0500
Message-ID: <1450393444.28544.3.camel@collabora.com>
Subject: VIVID bug in BGRA and ARGB
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Date: Thu, 17 Dec 2015 18:04:04 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-wHeTBX3RPETuGT6kgfCN"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-wHeTBX3RPETuGT6kgfCN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hans,

while testing over color formats VIVID produce, I found that BGRA and
ARGB the alpha component is always 0, which leads to black frames when
composed (when the background is black of course). Is that a bug, or
intended ?

cheers,
Nicolas
--=-wHeTBX3RPETuGT6kgfCN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlZzP2QACgkQcVMCLawGqByHewCfdS2JumcidrODQnz3140jdvug
bBUAn0N9Rq5m3Nkc9VMVt4rCQnlQ/OVy
=BmlE
-----END PGP SIGNATURE-----

--=-wHeTBX3RPETuGT6kgfCN--

