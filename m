Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35501 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbcAEVlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 16:41:35 -0500
Message-ID: <1452030090.2881.13.camel@collabora.com>
Subject: Re: Multiple open and read of vivi device
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
Date: Tue, 05 Jan 2016 16:41:30 -0500
In-Reply-To: <CAJ2oMhJGt8gL9MBWoHq9X9LcrR0bwPVk20jvqnWRWrAuSa2T-Q@mail.gmail.com>
References: <CAJ2oMhJGt8gL9MBWoHq9X9LcrR0bwPVk20jvqnWRWrAuSa2T-Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-+KM+EwpWg9wOp5r3Hi70"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-+KM+EwpWg9wOp5r3Hi70
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 05 janvier 2016 =C3=A0 23:18 +0200, Ran Shalit a =C3=A9crit=C2=A0:
> Does anyone knows why vivi is limited to one open ?
> Is there some way to patch it for multiple opens and reading ?

This is not fully exact. You can open vivid device multiple times.
Though you can only have one instance streaming at one time. This is to
mimic real hardware driver behaviour. Note that you can create multiple
devices using n_devs module parameter.

cheers,
Nicolas
--=-+KM+EwpWg9wOp5r3Hi70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaMOIoACgkQcVMCLawGqBzE2gCePaR8LVL5gpKLObbaVK34F7dK
eLsAoLnuUxPEM/QDya4c83ClqG2BlLDd
=VSVX
-----END PGP SIGNATURE-----

--=-+KM+EwpWg9wOp5r3Hi70--

