Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47673 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaDWUuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 16:50:40 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so1191516eek.4
        for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 13:50:38 -0700 (PDT)
Message-ID: <5358279C.5060108@dragonslave.de>
Date: Wed, 23 Apr 2014 22:50:36 +0200
From: Daniel Exner <dex@dragonslave.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: dex@dragonslave.de
Subject: Re: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
References: <535823E6.8020802@dragonslave.de> <CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com>
In-Reply-To: <CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7i9OVFwafJPAs8JEufONOh3sQjRLApioT"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7i9OVFwafJPAs8JEufONOh3sQjRLApioT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Am 23.04.2014 22:42, schrieb Devin Heitmueller:
> On Wed, Apr 23, 2014 at 4:34 PM, Daniel Exner <dex@dragonslave.de> wrot=
e:
> You can get the firmware via the following procedure:
>=20
> http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtai=
n_the_Firmware
>=20
> or if you're on Ubuntu it's already packaged in
> linux-firmware-nonfree.  The file itself is 66220 bytes and has an MD5
> checksum of 293dc5e915d9a0f74a368f8a2ce3cc10.

I used that procedure and have exactly that file in my /lib/firmware dir.=


> Note that if you have that file in /lib/firmware, it's entirely
> possible that the driver is just broken (this happens quite often).
> The values read back by dmesg are from the device itself, so if the
> chip wasn't properly initialized fields such as the version will
> contain garbage values.
On the page you linked above older firmware versions are mentions that
should be supported by the driver.

My Question is: how to get them?

But you may be right, because "Device is Xceive 34584" seems also wrong
(didn't find any hint such a device exists..)

I'm willing to invest some time to repair the driver.
Anyone interested in helping me in getting this thing back to work?

Greetings
Daniel
--=20
Daniel Exner
Public-Key: https://www.dragonslave.de/pub_key.asc


--7i9OVFwafJPAs8JEufONOh3sQjRLApioT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTWCecAAoJEJzUMd6kHcEp/60QAJx+iks+93V7gIF2ea4KQoMs
u/EhST5p2SsQtfCHgWDXoMBh0YSykwFU1J1COrTF83NS/rHDzegpZSTCKUv5l9U8
jK1BjiEZ3NjPc1Ua4LsWppb7kYPDfH9IDPK9a1XW8oaj9maPtf48K9G2WjmaVvx/
8AhoQZDZuAd0PYqn+cUv6QFz+8uVKfwZ8Mywk6nOkZfhuMO8RBmPbeAsdXPTvRsN
156epcGUEZTZup8rva85wJ23/83HJb2fuA1blDWkNunYvEUyqtWNPDwaFyFBshXI
8UUQsTuBDNwA6RZT6Oxjo04qZt4THwSXU5U12sLg4iT3hQXgyXN7Z3xVYOperNUy
arM2spKowQuJtYhk4dlb7jKu6Xv2j92VXATBiTweXX/87n3LOfye91ndKQhKL9x6
kpN/tfdZrpIwmS/r97HefSoQHvakAovRJxpBeG8su2AH68te0VEBHdbJA8mfPVYK
nFkujenT65xDitEZxm8cMQfhTNU1KPCOwPx2YZjfpNVlmSN9PJ2XMQEYzxLAkLgQ
dR/hZHCU8bCcF9Vk8lJWXC2Yqc9Dlo9m/QzAyj/qBpp2mKVwTew562hYtKjpWxyo
LZBRatcDI8UALwZAro60hInET9ogWO68r4T/PRQP3zJSlWmONrBzI6cze0ZbodZi
sDLZyEczw6s9OkQGOozz
=G3KH
-----END PGP SIGNATURE-----

--7i9OVFwafJPAs8JEufONOh3sQjRLApioT--
