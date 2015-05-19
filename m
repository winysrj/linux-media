Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47722 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbbESXmD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 19:42:03 -0400
Date: Wed, 20 May 2015 01:41:43 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] omap3isp: Fix async notifier registration order
Message-ID: <20150519234143.GA20959@earth>
References: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Wed, May 20, 2015 at 02:08:05AM +0300, Sakari Ailus wrote:
> The async notifier was registered before the v4l2_device was registered a=
nd
> before the notifier callbacks were set. This could lead to missing the
> bound() and complete() callbacks and to attempting to spin_lock() and
> uninitialised spin lock.
>=20
> Also fix unregistering the async notifier in the case of an error --- the
> function may not fail anymore after the notifier is registered.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

I already noticed this during my Camera for N900 work and solved it
the same way, so:

Reviewed-By: Sebastian Reichel <sre@kernel.org>

You may want to add a Fixes Tag against the patch implementing the
async notifier support in omap3isp, since its quite easy to run into
the callback problems (at least I did) and the missing resource
freeing (due to EPROBE_AGAIN).

-- Sebastian

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVW8o0AAoJENju1/PIO/qav10P/RnbY6nociKhKf4OAVbauuKz
E26aqVq8dxuSeip/CLJURBt4lDmV2ULWpWWv9P2HyRbkw/GubDnxipHDj4nYZZ+U
wGwtwaQXJfZdOqmVyB3WuLxM51VBPOVmB4NZO46txkwQIB2dDNuAWEIvSlZ+rwhC
fDU0LR22D2C1KSb6zo512pQi6KOYXa6j3h3P+6f7yHRckSk/hEoB2RXs1EOXFfGu
geHuJ1pVJqZsURCQqLeCihqGL+O+nN4skA48BzR12Ro+LS7kg+iw29Ea/vSUAAHv
5Gb95wFANqpKz7V5R7fa3yEjLkEQtPJ/SnWgjY541JsflL84SV3Ek4eQ2PcJK357
K3zCltX+vLptyIg93Xsn2Lk7HEYz4pwSOAUchpmIqGqCrVq2qIwnMYvjfzB5QvWN
byDgcaRdFLMG9nXdoYUgG6FmEftaM1hge1aYsMrsf4aizdh483gxDpxhUFIRRISJ
uLwMa/26NjbBTp9S4JsqHQwo1AFEy0k7PBQBTTWD0u5PLHYUzM1AsK85wt0JhbSR
0zhjXfduWapG7PKGEAErJ8cCRB3oM64byG+B1nUZE51ErZBZeC2/Hb4NG60j2z3h
YRq0O7MVIaUisP4STzEKsYer46p+zGxGSy9iv6KUFhd9MnfVwpCD2tiM/54ifSDo
txCZvhJLVjh7tE/PhC2L
=kF9W
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
