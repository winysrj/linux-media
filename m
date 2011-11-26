Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:25177 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1KZTCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 14:02:30 -0500
Date: Sat, 26 Nov 2011 22:02:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Peter Huewe <peterhuewe@gmx.de>,
	Steven Toth <stoth@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] saa7164: fix endian conversion in
 saa7164_bus_set()
Message-ID: <20111126190237.GA21128@mwanda>
References: <20111123070911.GA8561@elgon.mountain>
 <4ECFD56E.3040200@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <4ECFD56E.3040200@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2011 at 03:50:38PM -0200, Mauro Carvalho Chehab wrote:
> le16_to_cpu() is used for command. If one place needs fix, so the other o=
ne also
> requires it.
>=20

Ah yeah.  I should have looked for that.  I'll take another look and
see if there was anything else I missed and resend.

regards,
dan carpenter

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO0TfMAAoJEOnZkXI/YHqRAKgP/0YqVgnmjfnsSYMzxVgXJsx7
9GVpQ8eJ7ZGzjJwRIQEDKASVMRQdpwJG5OL9W4aFJ55Cjrm+6j0DjJl0r6N1vys/
8YOJ55IUcNvSpcP7EdugJRRhoBRU6+kRPpBIzrB2Ylu5LssTWPlnVNUn0TK9HFbY
lwzVAkUegOJKd/q4R51HoJuYsVKaL7QHDediXkGPwv0TmVDZTiBkZGFqlSphxmmq
0BssNif4lMooUO5vZw8B3v32DjFQt6OPq25lzpiCHGgSAo5yVZJoLCPjCsBAfFke
ZAce7pixTO7/uVtIKyFqglP25FF+mTY5hiq/OtBqqZL9BXTkeP+a9RHPt40umavL
Nc20G4qbfTAEb4lrqyrQSyeGCIblPryAcSVx9l8RIhr4v+688n3zTMWrOsPr8KWi
H080hhJrgi7lBGg48ydLIVt3c3m57eYrAPJ5hb4h0kirAAE0s0rMV7MvBiI4/rlG
6dPGpaeqW4n5G7H8FSMr0qU0Tb8vBOtjffNK4XsIqL1GlH3elJxe7OHxtjPkjK69
1ttIWYhPDw/EwDi9RboXoTOp+HeDrq1Vyqk9l5nhkeHxVq0iElFruePGg5sDU+tF
h3sPR1fcwH5c9FB2FE6LgXL+ikLk2IiCrXCaZFggt8J/wBhtDim5NqPxBm0S7vOK
lRD3C6pB49gZixNr5cqU
=K8kW
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
