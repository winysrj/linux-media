Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48205 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbbFHNup (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 09:50:45 -0400
Message-ID: <1433771439.480.2.camel@collabora.com>
Subject: Re: [RFC] V4L2 codecs in user space
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 08 Jun 2015 09:50:39 -0400
In-Reply-To: <55751D44.6010102@igel.co.jp>
References: <em1e648821-484a-48b8-afe4-beed2241343a@damian-pc>
	 <55751D44.6010102@igel.co.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-FFP2livDermHp5q3ymMI"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-FFP2livDermHp5q3ymMI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 08 juin 2015 =C3=A0 13:42 +0900, Damian Hobson-Garcia a =C3=A9crit=
 :
> Also, if this method is not recommended, should there be a 1-2 line
> disclaimer on the "V4L2_Userspace_Library" wiki page that mentions=20
> this?

I think you may have got that wrong. The V4L2 userspace library is not
implementing any device drivers. It allow older software to work with
latest V4L2 features by emulating what is possible. It also implement
platform specific setups (media controller) and eventually will contain
needed parsers that would otherwise represent a security threat if ran
inside the Linux Kernel.

Nicolas
--=-FFP2livDermHp5q3ymMI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlV1na8ACgkQcVMCLawGqBxc5ACfVxJwdbkh2MSCg+ZkvpY+5kb7
TFYAni0vRASg9M/M9JDMtiQEwp5NC61H
=wbGh
-----END PGP SIGNATURE-----

--=-FFP2livDermHp5q3ymMI--

