Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:39678 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932929AbeFTU6C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 16:58:02 -0400
Received: by mail-qk0-f173.google.com with SMTP id g14-v6so579676qkm.6
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2018 13:58:02 -0700 (PDT)
Message-ID: <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
Subject: Re: Software-only image processing for Intel "complex" cameras
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, niklas.soderlund@ragnatech.se,
        jerry.w.hu@intel.com, mario.limonciello@dell.com
Date: Wed, 20 Jun 2018 16:57:59 -0400
In-Reply-To: <20180620203838.GA13372@amd>
References: <20180620203838.GA13372@amd>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-8tppOZQzsG6k7USOMytH"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8tppOZQzsG6k7USOMytH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 20 juin 2018 =C3=A0 22:38 +0200, Pavel Machek a =C3=A9crit :
> Hi!
>=20
> On Nokia N900, I have similar problems as Intel IPU3 hardware.
>=20
> Meeting notes say that pure software implementation is not fast
> enough, but that it may be useful for debugging. It would be also
> useful for me on N900, and probably useful for processing "raw"
> images
> from digital cameras.
>=20
> There is sensor part, and memory-to-memory part, right? What is
> the format of data from the sensor part? What operations would be
> expensive on the CPU? If we did everthing on the CPU, what would be
> maximum resolution where we could still manage it in real time?

The IPU3 sensor produce a vendor specific form of bayer. If we manage
to implement support for this format, it would likely be done in
software. I don't think anyone can answer your other questions has no
one have ever implemented this, hence measure performance.

>=20
> Would it be possible to get access to machine with IPU3, or would
> there be someone willing to test libv4l2 patches?
>=20
> Thanks and best regards,
>=20
> 								=09
> Pavel
--=-8tppOZQzsG6k7USOMytH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWyq/1wAKCRBxUwItrAao
HHkAAKC4PXMfFlv3KYRD18Bj1TBAo+U0xQCeKQgvP+77cGkHBabZ7d6GH3zckp4=
=dHwr
-----END PGP SIGNATURE-----

--=-8tppOZQzsG6k7USOMytH--
