Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:46444 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbcGEF3f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2016 01:29:35 -0400
Subject: Re: [GIT PULL FOR v4.8] Various fixes/improvements
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <319a2666-50e5-29ff-b5bf-b47d26723d7a@xs4all.nl>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <577B45B4.2050705@butterbrot.org>
Date: Tue, 5 Jul 2016 07:29:24 +0200
MIME-Version: 1.0
In-Reply-To: <319a2666-50e5-29ff-b5bf-b47d26723d7a@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="is70THscXrnC2VexGJHHfMGhHrQ7JloFx"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--is70THscXrnC2VexGJHHfMGhHrQ7JloFx
Content-Type: multipart/mixed; boundary="eBxQBnH0KUUKofXXPtGPJHiHTaTM883SA"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <577B45B4.2050705@butterbrot.org>
Subject: Re: [GIT PULL FOR v4.8] Various fixes/improvements
References: <319a2666-50e5-29ff-b5bf-b47d26723d7a@xs4all.nl>
In-Reply-To: <319a2666-50e5-29ff-b5bf-b47d26723d7a@xs4all.nl>

--eBxQBnH0KUUKofXXPtGPJHiHTaTM883SA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 01.07.2016 16:45, Hans Verkuil wrote:
> Florian Echtler (3):
>       sur40: properly report a single frame rate of 60 FPS
>       sur40: lower poll interval to fix occasional FPS drops to ~56 FPS=

>       sur40: fix occasional oopses on device close

Thanks for merging this, AFAICS these fixes will now be part of 4.8. We
were hoping they might also be picked for the 4.4 LTS kernel, will this
be decided by Greg KH or will it happen automatically?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--eBxQBnH0KUUKofXXPtGPJHiHTaTM883SA--

--is70THscXrnC2VexGJHHfMGhHrQ7JloFx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAld7RbcACgkQ7CzyshGvatixuQCgqLiOhJEZvJPvdRu5zlkMxQ8r
F+0AnRL3jTssHiz2iwnkmPFYVKVb9FT9
=nDVK
-----END PGP SIGNATURE-----

--is70THscXrnC2VexGJHHfMGhHrQ7JloFx--
