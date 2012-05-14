Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:52854 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab2ENLSW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 07:18:22 -0400
Date: Mon, 14 May 2012 13:18:18 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 0/3] gspca - ov534: saturation and hue (using
 fixp-arith.h)
Message-Id: <20120514131818.695da2ae0665926d86de3cfc@studenti.unina.it>
In-Reply-To: <1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
References: <20120505102614.31395c2979f0b7aac0c8a107@studenti.unina.it>
	<1336299298-17517-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_May_2012_13_18_18_+0200_N8oK7G9zJIbfozhh"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Mon__14_May_2012_13_18_18_+0200_N8oK7G9zJIbfozhh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun,  6 May 2012 12:14:55 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Hi,

[...]
>=20
> Antonio Ospite (3):
>   gspca - ov534: Add Saturation control
>   Input: move drivers/input/fixp-arith.h to include/linux
>   gspca - ov534: Add Hue control
>=20

These changes are now in
http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.5

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Mon__14_May_2012_13_18_18_+0200_N8oK7G9zJIbfozhh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+w6foACgkQ5xr2akVTsAGP2gCcCNQgWuiRg/lOiPRnlVS0pDQO
sT8AoKhTvsOWk7VNSLPMQW9VZHa0zHYj
=8ZtI
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_13_18_18_+0200_N8oK7G9zJIbfozhh--
