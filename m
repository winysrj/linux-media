Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934805AbcHaOVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 10:21:43 -0400
Date: Wed, 31 Aug 2016 16:21:38 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 6/6] smiapp: Remove set_xclk() callback from hwconfig
Message-ID: <20160831142138.kqrsyx6bekvxsse5@earth>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472648497-26658-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i4nczeeuy4djyz54"
Content-Disposition: inline
In-Reply-To: <1472648497-26658-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i4nczeeuy4djyz54
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 31, 2016 at 04:01:37PM +0300, Sakari Ailus wrote:
> The clock framework is generally so well supported that there's no reason
> to keep this one around.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 49 ++++++++++++----------------=
------
>  include/media/i2c/smiapp.h             |  2 --
>  2 files changed, 17 insertions(+), 34 deletions(-)

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--i4nczeeuy4djyz54
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXxufyAAoJENju1/PIO/qaB0QP/1yWICRDDZ2nvJxsdGlGxNE7
ZaVvb/kr2tm2sbXh+c77wcppJA+X2cABqpElkoOdivVDEaONQ9MMqwtURJ7oR/KE
Ha8xW+EB1KpQYTCsfU4ebA0Kj7D1fRw9i/q/9RGgQlFScrNjy9i7kC9zntdWyuxN
vj/5xpmu3VdFr7QzJv3MgdOcsbgAgKGBve8yFsXjV8FKPJfB0i9mv1MN41UAVj12
1ms18bB6oWxSLw6bO1MQJ4eJiANmDtErkjn/WWxDDaOOa1RZ2VfDD8h86oj8RjA8
ClGewNwYIdZSq27APKEmVVMaJYo3//ls2fDOoH20SPwIUNzRxmlfbDZ6E5gRPIm6
WHZZdWcwbBbY3zh1Tbrb/yRhtMW1+a5D/cajsO1wcIsAPkoV8Z0cWUHwbq9mcdj5
BsVFK++5Qb5MmEDZzXcq1V1mTs2CWs+41UWNZm0XeoLBKyZ+rnYs+m1Ya+O+6gJ0
ix3V3PtVotup2iH7IveT6tOOfNa984V6P4c0L3VizNmrunQddvhM8sgN1i0QIclU
n5CCOcLHyV+aAQhMcdP1K9gTg/7gn8+myZp8uBRz00H9zMtP3Kmm+hCa9EL8h1ln
7WBSOB84vqB1Gc0xcaLiZ3LAosMsUHpX7x/fSn1b+7odOipNEG/klCksXIMWfMFX
lyn89A6Xz8RiyLTj05Ew
=0REJ
-----END PGP SIGNATURE-----

--i4nczeeuy4djyz54--
