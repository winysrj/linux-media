Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55248 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754663AbcJQORH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 10:17:07 -0400
Message-ID: <1476713822.4684.80.camel@ndufresne.ca>
Subject: Re: [ANN] Report of the V4L2 Request API brainstorm meeting
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: keith@kodi.tv
Date: Mon, 17 Oct 2016 10:17:02 -0400
In-Reply-To: <5518f06f-046f-98e8-05f3-5e9063df15e8@xs4all.nl>
References: <5518f06f-046f-98e8-05f3-5e9063df15e8@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-rt/EX2DzLXE3lt+txXN+"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-rt/EX2DzLXE3lt+txXN+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 17 octobre 2016 =C3=A0 13:37 +0200, Hans Verkuil a =C3=A9crit=C2=
=A0:
> 1.5 Requests vs. w/o requests
>=20
> There are three options for drivers w.r.t. the request API:
>=20
> 1) The driver doesn't use the request API
> 2) The driver requires the request API
> 3) The request API is optional.
>=20
> It is not clear at this stage if 3 is ever needed. So for now just
> add a capability
> flag for "requests required". And add a "requests supported with
> legacy" flag later
> on if needed.

Simply adding a new flag will make both state-less and current CODEC
M2M drivers look the same. This will likely trick existing generic code
into trying those stateless decoder.

For backward compatibility, we need to replace an existing
categorization flag, like STREAMING or similar.

regards,
Nicolas
--=-rt/EX2DzLXE3lt+txXN+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlgE3V4ACgkQcVMCLawGqBzR9gCePbZjG2//ilPJ9cyT2s0l+xhA
9MsAoIrnNwk0ByyWPJwXC0kNHD6W3h9b
=kkDG
-----END PGP SIGNATURE-----

--=-rt/EX2DzLXE3lt+txXN+--

