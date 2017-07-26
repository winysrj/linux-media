Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:59914 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751466AbdGZTp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 15:45:59 -0400
From: Eric Anholt <eric@anholt.net>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        boris.brezillon@free-electrons.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 3/3] drm/vc4: add HDMI CEC support
In-Reply-To: <63e84f5d-f8f3-9601-4cac-315a388b57ed@xs4all.nl>
References: <20170716104804.48308-1-hverkuil@xs4all.nl> <20170716104804.48308-4-hverkuil@xs4all.nl> <63e84f5d-f8f3-9601-4cac-315a388b57ed@xs4all.nl>
Date: Wed, 26 Jul 2017 12:45:56 -0700
Message-ID: <874ltzyoaz.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Hi Eric,
>
> On 16/07/17 12:48, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>=20
>> This patch adds support to VC4 for CEC.
>>=20
>> Thanks to Eric Anholt for providing me with the CEC register information.
>>=20
>> To prevent the firmware from eating the CEC interrupts you need to add t=
his to
>> your config.txt:
>>=20
>> mask_gpu_interrupt1=3D0x100
>
> I put this text in the commit log, but I think it should also go into the=
 source.
> Do you agree?
>
> Should I also mention this in the kernel log via a 'dev_info'? It's not a=
n obvious
> config option, after all.
>
> Or do you have other ideas regarding this?

The firmware should have been masking this interrupt for ages (~2
years?), as long as it sees the kernel's DT instead of the downstream
one.  I've dropped the commit message comment about that, added a bit of
explanation of having a separate Kconfig, and pushed.

Huge thanks for your work on this!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAll48XQACgkQtdYpNtH8
nui0lxAAmo7vWLS+gaNtcTXhht1wPHaSzDYv1DqwLNP5rMKeEOA4Cjgv+TVPPZbw
NBuHwMmuumvXOafggwzro4g1XSv8ru30jNUAjZtx0siFd5YxIX578CnMbu0FbI1t
3mw4MdnuRGJFKpTgkiGig4nREUTy3FudiyddT0zr7bUpntiT76P2HZ73TyFr6EaX
SM//JGrgypKCh8vDsXwOkJDxPwJP+Q7UuBXcmpXp4DOS+2VLOSIOfw/QyDzgCTvK
yaT6OyFhZJh2dZ/rXQVc6bIu4Fy0po8MdQnQHFokLUMpLOgI7ATW9VF+FLfZly/Z
7mO1Fd6PEJkH752tLtu41AuduUxInsDimEG/I1qfs9yUTIvuBCgpA03fwO8HbEi7
H8TuZVzO6SGNgVUu2WnyeSC6XNO3mRvcNdR7ev4CKww8J4rq4F1yjZ4+EsvhqGrH
//9YpxeyeXtojDKRe0j/kBrTjJl8giJEZLJwWx42iFRzH4OLEqLzRrzVMlIvTAPF
gA8IzlAp2jSXD9NSLCJs4OiJgks0SUIILqrVKF/slAKZlWyFWexxwwxIpachLDMM
TCAHvAt5orQIYW5nKbzpwAM1xy/QTgBUjLN3zhGU3V9RLXi4mU5487XKbBTbZbke
XMONwoflHWtGY7zvIaFh279cvIDTR5e+/QnVp73/m3K1Rlri2jc=
=LZnM
-----END PGP SIGNATURE-----
--=-=-=--
