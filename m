Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41943 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdIUOXP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:23:15 -0400
Date: Thu, 21 Sep 2017 16:23:13 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v5 6/6] i2c: dev: mark RDWR buffers as DMA_SAFE
Message-ID: <20170921142313.ghshkvl7o26gkfyp@ninjato>
References: <20170920185956.13874-1-wsa+renesas@sang-engineering.com>
 <20170920185956.13874-7-wsa+renesas@sang-engineering.com>
 <20170921151744.000054d0@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qdfqet27rre5b7op"
Content-Disposition: inline
In-Reply-To: <20170921151744.000054d0@huawei.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qdfqet27rre5b7op
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 21, 2017 at 03:17:44PM +0100, Jonathan Cameron wrote:
> On Wed, 20 Sep 2017 20:59:56 +0200
> Wolfram Sang <wsa+renesas@sang-engineering.com> wrote:
>=20
> > Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
>=20
> Makes sense as do the other drivers.
>=20
> Feel free to add
>=20
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>=20
> to all of them (though they hardly took a lot of reviewing given how simp=
le
> the patches were :)

Well, bugs can slip in everywhere, so thanks for the review!


--qdfqet27rre5b7op
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlnDy1EACgkQFA3kzBSg
KbbFsg//SgQ6W7+mzuA3sfUHggU3dmkPw+A9tdkOIlZ1S0DFStQzCAnmb0H18P1S
uy4CId++58u4B6ly9kFNtBgvoxZykTkCMTkdvPW9uLbbLbU+IPiFleZ9rZXBsI80
qA927leTNzC/oA7wXJtUQRQ1mXU5H3oGFrCCmBISGjIQ5pHoHO3kQx6iRODrrkP4
R05WXfKRO0JkMS/JvxQNnBwwsAYkLmcNV996rS0OkPT6UIHuEycMSAPkGFSUdHRe
9ZjMspsUbvr5YGufyY43aFgCvLG9Zh6OP6d8s1NDro3RAnbATm56C2x4dU0ImxpC
VXj5uEASAUym8qSUXme8Mlcl+yCjnYxwnlaaYAx34X0JpWflZVk/W5Py2FM97Zjj
1Ljuf2uf/E8XpC6D0KeMRhfMBvPUoj2R6bJ6ptbrN0p422LC+Msbqj5GzOgPxIFn
+kn4kwXbGsozvTtIZ9LYhGLxS6fQH++BbZI1Ip8+pO44tWbSmcHInDdYwYZjvqf6
+lOH8iFR+siqjuXLXCKkrRjfo3+JlHGRpIuJOIQI70WEdCJyOE++1fqWfJBlOwLc
9iXmZlxs21bCfBJ8973mIJ8P6Pag6VSHqRkhAaHz5ouSibLsWVBc1T6io1YSEuFX
SkDC7twSW4X4IvqCwTnYdvg42xeJ9eljf9diu8BPkouxwrpMUfA=
=mndP
-----END PGP SIGNATURE-----

--qdfqet27rre5b7op--
