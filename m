Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933162AbcLVOcu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 09:32:50 -0500
Date: Thu, 22 Dec 2016 15:32:44 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161222143244.ykza4wdxmop2t7bg@earth>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yp244s4rtpxq7vqr"
Content-Disposition: inline
In-Reply-To: <20161222133938.GA30259@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yp244s4rtpxq7vqr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Thu, Dec 22, 2016 at 02:39:38PM +0100, Pavel Machek wrote:
> N900 contains front and back camera, with a switch between the
> two. This adds support for the swich component.
>=20
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> --
>=20
> I see this needs dts documentation, anything else than needs to be
> done?

Yes. This driver takes care of the switch gpio, but the cameras also
use different bus settings. Currently omap3isp gets the bus-settings
=66rom the link connected to the CCP2 port in DT at probe time (*).

So there are two general problems:

1. Settings must be applied before the streaming starts instead of
at probe time, since the settings may change (based one the selected
camera). That should be fairly easy to implement by just moving the
code to the s_stream callback as far as I can see.

2. omap3isp should try to get the bus settings from using a callback
in the connected driver instead of loading it from DT. Then the
video-bus-switch can load the bus-settings from its downstream links
in DT and propagate the correct ones to omap3isp based on the
selected port. The DT loading part should actually remain in omap3isp
as fallback, in case it does not find a callback in the connected driver.
That way everything is backward compatible and the DT variant is
nice for 1-on-1 scenarios.

Apart from that Sakari told me at ELCE, that the port numbers
should be reversed to match the order of other drivers. That's
obviously very easy to do :)

Regarding the binding document. I actually did write one:
https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/commit/?h=
=3Dn900-camera&id=3D81e74af53fe6d180616b05792f78badc615e871f

So all in all it shouldn't be that hard to implement the remaining
bits.

(*) Actually it does not for CCP2, but there are some old patches
=66rom Sakari adding it for CCP2. It is implemented for parallel port
and CSI in this way.

-- Sebastian

--yp244s4rtpxq7vqr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhb5AkACgkQ2O7X88g7
+ppvyQ/+PXudUQ28f2hy6e74Y9094rdzaKXEU/eWwAHdTgYWrkrQ1lGf9s8maD8O
jNy7O/GFp9ZQf2rYeMjuLUGolwUGm6/cXolEnKz+mgjAd0nNcOXElWUP4r2KwpSu
CkTy+LuLEtDDzL+GolalTEXMNBa+hMgAMt4m2KO1UUlbF60eiWZ711SABnFp9EDt
szkru6+j8CNLeCD9KmO52i3tqZsr/8Dqdpmz2kFjyqjxDyn2YgP6hTQRnnAmoz86
cHbvNuXpSqHQoAJPjg2SQp7oC6ytqmXlXMhjVJpr4iDFpwIe/ZLC9JyoRMJ0bziB
zdqqwFDKGYiH/gKy/IX27m4wL18kDlKmlKQ0z2K/zunIwCEsuLhFZbYE5MF17HYm
K8WvTrlFeD9NJzub9O3aeLf00Av6g8MFhbzF3ndvcG6l7cBDnDkv8qOSJvZwUAEw
0TIcT8bpgMtrAnUqDsuPO7AQvbDItSYeKH4EELZtHHbnzYMWajSqiWbVD7GYSQ4N
5KcD4R+uE7fVaajx1L0akCAYNR5Ojl0ZJdpwRHThqHo2tZDCucgqoCsxAwMc2yjp
Iforpy3kQgFhCjV1G+64ddGiDchCTneAK768+r5+hB/sgRhoRBdQBtsjuN+CJ363
FNxZUuJX7h12wT6JLi1whyxojSmH7puKn/OBR1F+8mLr6T6/eQc=
=b9IC
-----END PGP SIGNATURE-----

--yp244s4rtpxq7vqr--
