Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60980 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2K2RIc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 12:08:32 -0500
Message-ID: <50B79682.1020305@ti.com>
Date: Thu, 29 Nov 2012 19:08:18 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, <hvaibhav@ti.com>,
	<linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: Re: [PATCH 0/2] omap_vout: remove cpu_is_* uses
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com> <4208124.v72gFsjH2D@avalon> <20121129162927.GF5312@atomide.com> <2148719.6v36XORg4e@avalon> <20121129150535.17ea00e9@redhat.com>
In-Reply-To: <20121129150535.17ea00e9@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig10D5E92F1217FE72CE04FBD1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig10D5E92F1217FE72CE04FBD1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-29 19:05, Mauro Carvalho Chehab wrote:
> Em Thu, 29 Nov 2012 17:39:45 +0100
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

>>> Please rather queue the cpu_is_omap removal to v3.8 so I can
>>> remove plat/cpu.h for omap2+.
>>
>> In that case the patches should go through the DSS tree. Mauro, are yo=
u fine=20
>> with that ?
>=20
> Sure.
>=20
> For both patches:
>=20
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Okay, thanks, I'll apply them to omapdss tree.

 Tomi



--------------enig10D5E92F1217FE72CE04FBD1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQt5aCAAoJEPo9qoy8lh71uJsP/jWyWZqf1/QWpVeqszGYfO3D
uQyt4jpoRrTlXggLHuoieU0+TI06ufiK1LzTFP7FBRJzuaglg0sHPndsXQA2jj14
AhdX/8L9MUsjEDggZUiK9GHUwbl+1qgiES4V1GRbknds4ZZ7O3Z4SpaK+Si2s8y5
Hq7i2vDvv7ekCw3PcXpNtGisa+fCfTTYw9mKc/TC7dnLWWtIYNvm/Xiciy0C7Nb1
geYM7ZIme7pFkR1o7U+SF2Ne/os4I95v6UiPJJ6nv8N49PUKvGtTegvodQ1dZpyy
OLQpYnNBYlvMr/89A+8CwVsVZ8HIFo8/6s7OAWzJMYfncgWC0CH/u12Pte/3i8YB
rIFb8fSO7qvBKJHFtCXeHG+lnPukO/v5coCVhkFfC5ErsKedSTX086LRHLrylKKC
Jkq5eedY7Ma7ZHYqYMm1NHKALJHPBm0+dUjWLYtGBcyKC9Mq+SFpvdIYRqoQqOgs
anomeiv/D7r3CADqyD9nRC2G3yfnVdnruqp2crhvq43GEbCU+4Dqd6VK8ChURH+A
bJrFLgZiQrXvFNFIF+P2jc+aypyzjrLFO+75F0HF/g50C2DD9PMwlDl0nD8UlZrv
emkB1wTw5HIsr2yJj2egurrObVt4bL290bvyLr3xkOkkRDJiUlrFBpZmTJnqurL0
4E5ePk9UwFHPq8JD5Jow
=0oLo
-----END PGP SIGNATURE-----

--------------enig10D5E92F1217FE72CE04FBD1--
