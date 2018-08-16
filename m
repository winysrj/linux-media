Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:45471 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390991AbeHPNVB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:21:01 -0400
Date: Thu, 16 Aug 2018 12:23:23 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Petr Cvek <petrcvekcz@gmail.com>
Cc: marek.vasut@gmail.com, hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, robert.jarzmik@free.fr,
        slapin@ossfans.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v2 1/4] media: soc_camera: ov9640: move ov9640 out of
 soc_camera
Message-ID: <20180816102323.GC19047@w540>
References: <cover.1534339750.git.petrcvekcz@gmail.com>
 <dc99bd37408f42a342b1b878d01c16f8c25b758b.1534339750.git.petrcvekcz@gmail.com>
 <de297d12-e5eb-9e68-978c-3417cdfc0c05@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <de297d12-e5eb-9e68-978c-3417cdfc0c05@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Petr,

On Wed, Aug 15, 2018 at 03:35:39PM +0200, Petr Cvek wrote:
> BTW from the v1 discussion:
>
> Dne 10.8.2018 v 09:32 jacopo mondi napsal(a):
> > When I've been recently doing the same for ov772x and other sensor
> > driver I've been suggested to first copy the driver into
> > drivers/media/i2c/ and leave the original soc_camera one there, so
> > they can be bulk removed or moved to staging. I'll let Hans confirm
> > this, as he's about to take care of this process.
>
> I would rather used git mv for preserve the git history, but if a simple
> copy is fine then I'm fine too ;-).

Well, 'git mv' removes the soc_camera version of this driver, and my
understanding was that when those driver will be obsoleted they will
be bulk removed or moved to staging by Hans.

Also, I feel this is trivial and I'm not getting something but:

$ git mv drivers/media/i2c/soc_camera/ov9640.c drivers/media/i2c/
$ git commit  -s -m "test"
$ git log --oneline  drivers/media/i2c/ov9640.c | wc -l
  1

Hence, I don't see history be preserved (which makes sense, as git mv
is actually a shortcut for 'mv $old $new; git add $new; git add $old')
Am I missing something maybe?

Thanks
   j
>
> Petr

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbdVCbAAoJEHI0Bo8WoVY8FvEP/0HXTlAVGrNmZV5mfDBHsWoX
Mc+/SzfqtJ3mEjfKDcoZxQnIb/9kG6qtgkr8AJQAXxpKJSBBedtj254PqJee00rM
vrNgmZnFJRWA72palg2+zKa2jId9KdyI22ksS4XQ5QmI+bgJ4ngTZZ7y+sKYZQT2
zdzc3kys9X3EAV9Uidrex4/xSJw9UtQ5xQkvktC3eGPIgj1GsikaGqX9tnHkQ++j
ytt1yICb0+I903fK2SthnBDQt49mp/mjBElhRwnxDYlqvGBWOzv3JpND2kfdIMYl
bdmeRK+8RysTIk2DAARm1YodBuLZqgveue8s1pUhYIWtf8anDfUo3hrGS2BV9oHq
YmRgrUsIAlqYqn+3i2RE51ZvJI2b0c7iABKY0yD/YB0+8ZQVjsAJdMaEtnrAlPM/
GNspKsG/PvzbJJpFCXCu2QDtwxF42u9eWDdOR6yL269P/Dgc4l5fSdpIoNKR+QIK
g7DKW5uSI/RwKf0zkhio2BSUPC05iWnldvK3rZAs/NiOHsfmUK5vFrML9QXu0+Wd
Er2TODmre2LbyY5nbZLgBXOaz6MEZgEjzZ85PkvpVnd4YTRKO+ge9pBF12++p8U5
IF4hPfuSqVf45LhndOre1XkjZtu9CfeLBJfnJ2lOQdzvDra50TewZ1FumbQM70T+
x0g8V2WUBOPLEAaJxLyD
=lSpO
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
