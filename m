Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933630AbcIALuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 07:50:35 -0400
Date: Thu, 1 Sep 2016 13:50:23 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.2 5/5] smiapp: Switch to gpiod API for GPIO control
Message-ID: <20160901115023.wb25qtp7icfu3lis@earth>
References: <1472648456-26608-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472712508-23577-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ufzg3kxjraiyq6sz"
Content-Disposition: inline
In-Reply-To: <1472712508-23577-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ufzg3kxjraiyq6sz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 01, 2016 at 09:48:28AM +0300, Sakari Ailus wrote:
> Switch from the old gpio API to the new descriptor based gpiod API.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> since v1.1:
> - Return the error if devm_gpiod_get_optional() fails. NULL is returned if
>   there's no GPIO defined.
> - No debug print is performed on lack of the GPIO. The GPIO framework
>   already does this.
>=20
>  drivers/media/i2c/smiapp/smiapp-core.c | 36 +++++++++++-----------------=
------
>  drivers/media/i2c/smiapp/smiapp.h      |  1 +
>  include/media/i2c/smiapp.h             |  3 ---
>  3 files changed, 12 insertions(+), 28 deletions(-)

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--ufzg3kxjraiyq6sz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXyBX4AAoJENju1/PIO/qa/k4P/A/MLhQWC5lmLvVBGFL72t9V
APdnMCc6wPUIteL5D2OsQ4ERmkqiTKeqTBI0/QK4X7e8doUqTe5CL1nxsluj63pg
u5CwA9b7hGgHnL7kTglE4ImUEqIvrqKNgzl15IdoJNePAXe+h/H+sGQEt2VXZIBb
IWYC22kasX0LGb6LD06JAs/NbQ5ptRtuGWbWCkYWHxih6mH8STvmZkp7j2Izfa1q
7GPQ6VVkNtENn3mtKhexiX2O9s19Z8JCGTk74CRWnBAyvGC81hnjq8UmPOy0yyPH
H7PvdJ0+WRU6HRb+3O36rrwKOEuEyc0rCx4CiOkIXxGddK+p5tS9vsPQttClXanl
HMDTqw8bmusKF6vfvzBEmJQPHzbmjEelMZ5Q3R8O97kmCRVvWdsBR1pftVi7tlg3
ySubgRaaYwHvBTm29wrK+vBOuruOFsYb6DGLkFBVpPWz3dHj09FPJZwzHRgJP0e1
K1EdRviciMT0U6XYa/c9e1O+kyLR9U+vP6YUqLRrpZlxNUFjxiA5UXymN/1eHuQu
Kt4TC+ubdbdin24CY5snw9YxngzKxchGxN4DnBdy7cP1FsVO3x1dHgDThNHi3beT
uUf0deGGdV8Q+oRUme9kNsgmEme+yhNmOjZsrExoMWFHGpC5qycJnjT8GOluWOqq
FEiwglX0d7TZjBM5Tzbr
=pFlO
-----END PGP SIGNATURE-----

--ufzg3kxjraiyq6sz--
