Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:13673 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdDMInY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 04:43:24 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
 <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
 <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <d4b49cb9-7147-c2f4-7e14-99dce1a05708@ti.com>
Date: Thu, 13 Apr 2017 11:43:15 +0300
MIME-Version: 1.0
In-Reply-To: <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="4ufNnE01BEedrKoNkQVUUkFB2Ih99qNqW"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--4ufNnE01BEedrKoNkQVUUkFB2Ih99qNqW
Content-Type: multipart/mixed; boundary="8lcDGm14oSSnrQcWtIL91DDeFlk1uhV5N";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <d4b49cb9-7147-c2f4-7e14-99dce1a05708@ti.com>
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
 <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
 <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>
In-Reply-To: <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>

--8lcDGm14oSSnrQcWtIL91DDeFlk1uhV5N
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/04/17 17:04, Hans Verkuil wrote:

>> So is some other driver supporting this already? Or is the omap4 the
>> first platform you're trying this on?
>=20
> No, there are quite a few CEC drivers by now, but typically the CEC blo=
ck is
> a totally independent IP block with its own power, irq, etc. The omap4 =
is by far
> the most complex one to set up with various GPIO pins, interrupts, regu=
lators,
> etc. to deal with.
>=20
> Normally it takes about 2 days to make a new CEC driver, but the omap4 =
is much
> more work :-(

Ok.

I mentioned the omapdrm restructuring that we've planned to do, I think
after that this will be easier to implement in a nice way.

For now, I think more or less what you have now is an acceptable
solution. We can hack the tpd12s015 to keep the level shifter always
enabled, and, afaics, everything else can be handled inside the hdmi4
driver, right?

Generally speaking, what are the "dependencies" for CEC? It needs to
access EDID? Does CEC care about HPD? Does it care if the cable is
connected or not? For Panda, the level shifter of tpd12s015 is obviously
one hard dendency.

Is there anything else CEC needs to access or control (besides the CEC
IP itself)?

 Tomi


--8lcDGm14oSSnrQcWtIL91DDeFlk1uhV5N--

--4ufNnE01BEedrKoNkQVUUkFB2Ih99qNqW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJY7zojAAoJEPo9qoy8lh71MwMP/2mx71MQNVWNEIUCOKHCx5Xt
FzC557iRaJTuEBtxurRZK2RVbZ62FqFMf5WToXQiXiS4lX/m/Mg4H9YYtzGfMw+c
TY8vh5vqaQ9QzYw23DStPPi9VIrvRR0Q2zdpNGZmHI5bWpyFvpVeKiyiVSHss6VO
SDsMC20BlSzAf8fSdOaU4lygpuHrDBxAJID+RQpxh+E5blp+1pBXSOui08BfMLzc
HhZkh87yyCc1X5AMI9OIded5VN3QQm9zXnVNTrEj2NyuiEfusIGRfavQPlPsIcV7
k+J3xOM+kpqKBAMTWTzUsKWm1TVnYHCEvMO+bGWZyCd05FYSdAg8BbsnSyU1SmTA
Sx/ylI5X3xOg3GkS+HlJm/d3v6WPSRQC0JeeHkImN6E1TSUJv/NPTGj2PkCnb8Pu
oIYP/P7ib1JDVlwvlHfDfhYfo6zSAFIM2/Mr/lVa4kgBDrEVGRxqb4bVEbquWUL4
yQi74mITYAYdcu7B6cVrOGkEe6R0uqHWPipkajfHN6S3QONF5IWvljx8XG7tdTo+
U7WicZiq2gSr3Rk8fNe7S0ZzExO6vFEc6luj9hygbKShpoVyBY2RmnQe0AqPZvdF
egbpkA+c1U3RC60zTbGyRJZMmg63KVO44oMPwVXz4r43Q6X6zzKPfFH/M3mw5O/N
BJzO11sGSA3Qf5O9hIrC
=+RlD
-----END PGP SIGNATURE-----

--4ufNnE01BEedrKoNkQVUUkFB2Ih99qNqW--
