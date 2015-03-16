Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:45708 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbbCPMrp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 08:47:45 -0400
Message-ID: <5506D0F0.2070406@butterbrot.org>
Date: Mon, 16 Mar 2015 13:47:44 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.1] sur40 driver and two small DocBook fixes
References: <5506C2E9.1080008@xs4all.nl>
In-Reply-To: <5506C2E9.1080008@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wPIn6FFVPVWNlOxOmxQh2gltcREcqQdD0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wPIn6FFVPVWNlOxOmxQh2gltcREcqQdD0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

\o/ YAY! ;-)

Sorry for the spam, but that needed to be said.

Thanks again, Hans!

Best, Florian

On 16.03.2015 12:47, Hans Verkuil wrote:
> This adds video capture support to the sur40 input driver.
>=20
> To quote the author:
>=20
> "The SUR40 is a quite peculiar touchscreen device which does
> on-board image processing to provide touch data, but also allows to
> retrieve the raw video image. Unfortunately, it's a single USB device
> with two endpoints for the different data types, so everything (input &=

> video) needs to be squeezed into one driver."
>=20
> Regards,
>=20
> 	Hans
>=20
> The following changes since commit 3d945be05ac1e806af075e9315bc1b3409ad=
ae2b:
>=20
>   [media] mn88473: simplify bandwidth registers setting code (2015-03-0=
3 13:09:12 -0300)
>=20
> are available in the git repository at:
>=20
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.1m
>=20
> for you to fetch changes up to 69dc25b1cd764181a6b8c5b16b753ab645b3d55b=
:
>=20
>   add raw video stream support for Samsung SUR40 (2015-03-16 12:43:10 +=
0100)
>=20
> ----------------------------------------------------------------
> Florian Echtler (1):
>       add raw video stream support for Samsung SUR40
>=20
> Hans Verkuil (2):
>       DocBook media: fix VIDIOC_CROPCAP type description
>       DocBook media: fix awkward language in VIDIOC_QUERYCAP
>=20
>  Documentation/DocBook/media/v4l/vidioc-cropcap.xml     |   9 +-
>  Documentation/DocBook/media/v4l/vidioc-g-crop.xml      |   5 +
>  Documentation/DocBook/media/v4l/vidioc-g-selection.xml |   4 +-
>  Documentation/DocBook/media/v4l/vidioc-querycap.xml    |   8 +-
>  drivers/input/touchscreen/Kconfig                      |   2 +
>  drivers/input/touchscreen/sur40.c                      | 429 +++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  6 files changed, 436 insertions(+), 21 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
SENT FROM MY DEC VT50 TERMINAL


--wPIn6FFVPVWNlOxOmxQh2gltcREcqQdD0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUG0PAACgkQ7CzyshGvatjGcQCg/S8xVLpjAaWvyZEAY8OS72/S
r/AAn0BXLtuxcsxX1wFaj6sRNLUKyOfp
=Ecsu
-----END PGP SIGNATURE-----

--wPIn6FFVPVWNlOxOmxQh2gltcREcqQdD0--
