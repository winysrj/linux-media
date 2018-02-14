Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:53661 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754676AbeBNMJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 07:09:28 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
From: Florian Echtler <floe@butterbrot.org>
Subject: exposing a large-ish calibration table through V4L2?
Message-ID: <3b8e61f5-df31-8556-c9d1-2ab06c76bfab@butterbrot.org>
Date: Wed, 14 Feb 2018 13:09:23 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="O8X53DF9c2aF0YdWJ6r2wBVBHErWCeINK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O8X53DF9c2aF0YdWJ6r2wBVBHErWCeINK
Content-Type: multipart/mixed; boundary="nuxa4ros5W4E19HUFHyIPI6UbvCRItRs8";
 protected-headers="v1"
From: Florian Echtler <floe@butterbrot.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
 Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3b8e61f5-df31-8556-c9d1-2ab06c76bfab@butterbrot.org>
Subject: exposing a large-ish calibration table through V4L2?

--nuxa4ros5W4E19HUFHyIPI6UbvCRItRs8
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello Hans,

I've picked up work on the sur40 driver again recently. There is one majo=
r
feature left that is currently unsupported by the Linux driver, which is =
the
hardware-based calibration.

The internal device memory contains a table with two bytes for each senso=
r pixel
(i.e. 960x540x2 =3D 1036800 bytes) that basically provide individual blac=
k and
white levels per-pixel that are used in preprocessing. The table can eith=
er be
set externally, or the sensor can be covered with a black/white surface a=
nd a
custom command triggers an internal calibration.

AFAICT the usual V4L2 controls are unsuitable for this sort of data; do y=
ou have
any suggestions on how to approach this? Maybe something like a custom IO=
CTL?

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--nuxa4ros5W4E19HUFHyIPI6UbvCRItRs8--

--O8X53DF9c2aF0YdWJ6r2wBVBHErWCeINK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlqEJvMACgkQ7CzyshGvatj3EQCfW5ir1HaoU9+5UTuBFM+Xo+CY
PSIAoNoV7oH1Ymjf7iBqC0J7s+mrnPRs
=5nyF
-----END PGP SIGNATURE-----

--O8X53DF9c2aF0YdWJ6r2wBVBHErWCeINK--
