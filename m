Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:51928 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbaLHOw4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 09:52:56 -0500
Received: from [141.54.57.131] (eduroam-057-131.scc.uni-weimar.de [141.54.57.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by butterbrot.org (Postfix) with ESMTPSA id D33CE5C00D89
	for <linux-media@vger.kernel.org>; Mon,  8 Dec 2014 15:45:08 +0100 (CET)
Message-ID: <5485B974.4050502@butterbrot.org>
Date: Mon, 08 Dec 2014 15:45:08 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [sur40] videobuf2 and/or DMA?
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="amvx3JWS2LfFD8EViNnMhVkF0UMwAwJmn"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--amvx3JWS2LfFD8EViNnMhVkF0UMwAwJmn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello everyone,

I'm preparing to finally add support for the raw sensor video stream to
my driver for the SUR40 touchscreen. However, after an extensive amount
of Googling, I'm still not clear on the relationship between DMA
transfers, the USB core and the videobuf2 framework.

Specifically, I'd like to know:

- Can I always use DMA on the USB side (for bulk transfers), or does
this in any way require support from the USB device's hardware? (I'm
guessing no, but a definite answer would be great.)

- Regardless of the USB side of things, can I use the videobuf2
framework without _having_ to use DMA? That way, I could get a basic
driver running without DMA and switch later when it's convenient and/or
the speedup is justified.

Thanks & best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL






--amvx3JWS2LfFD8EViNnMhVkF0UMwAwJmn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlSFuXQACgkQ7CzyshGvatjEUQCY8+QMzxWVCk6hEBYrZy/KjfjL
6wCdHmaRUJDFhkIYCc2YI7cO7bT6NZE=
=BBz4
-----END PGP SIGNATURE-----

--amvx3JWS2LfFD8EViNnMhVkF0UMwAwJmn--
