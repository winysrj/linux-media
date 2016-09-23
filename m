Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933655AbcIWAPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 20:15:07 -0400
Date: Fri, 23 Sep 2016 02:14:48 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 5/5] smiapp: Implement support for autosuspend
Message-ID: <20160923001448.mmeo3fhheajvbqzk@earth>
References: <1473938961-16067-6-git-send-email-sakari.ailus@linux.intel.com>
 <1474374598-32451-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ebmxzf4sh66t7pxr"
Content-Disposition: inline
In-Reply-To: <1474374598-32451-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ebmxzf4sh66t7pxr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 20, 2016 at 03:29:58PM +0300, Sakari Ailus wrote:
> Delay suspending the device by 1000 ms by default.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>=20
> since v1:
>=20
> - Increment usage count before register write using
>   pm_runtime_get_noresume(), and decrement it before returning. This
>   avoids a serialisation problem with autosuspend.
>=20
>  drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++++---
>  drivers/media/i2c/smiapp/smiapp-regs.c | 21 +++++++++++++++------
>  2 files changed, 22 insertions(+), 9 deletions(-)

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--ebmxzf4sh66t7pxr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJX5HP1AAoJENju1/PIO/qarCQP/jLNKJsxwKufJiK/l6URHGAc
cQf0MiRlA5LIuFwudxaJ9pAhGXU9Qmc2USr6mptS681r67qicH0VMM/75v8EgqtI
E2QS5IzVaGCU2//SYa32sfTBcGB3w9A+h8xrZ7BLRNDx/StUikbsGAMelgmQ446/
BUJ2CmiakQa0ZbwYiw0PHrkXhY99Whqg2WHEwm/W7LZgVnIh5PYmmlc2caKL5Tf1
AF25o307nhHT5n6fUQQposEDPrroO82Ng9D1XjPUin5LlyLJxWpMDHvdLMf3fTVM
VVlc4ossnh8+3ktnALpKauyRJeIuibYsCtmyUhybrHiL+9K9JY7XexPZ7PKxRM7+
9C1zM8ke6AxmdkG1M5rVl/2pmi0KJ+eHlFbJjobsZv08IzOlT9yeFkikFA85Js/N
x2bQhV5yrmfZ8HroR/FULTca6slSIobY4GX6GOgXLqwEQeeVWHFyutAleYpPeEX7
iOh/pg+taulXeScgYulp4UjdWugzzUyz5dhMKaIrTY6W/cyC1gUH9V+ydoauxSFQ
EJ+adxM+9/4v7Z3Jc2/BvWG7WrGe9Ykc47hIK8Pd0E0pk7v0aQLs3+8hqvE2MwrF
gTXk58+Fy/DhRbdJGFYMh77TbqEhH5CeImunn2HAoKyJHQ21RoXuCawUUZeHX3rW
hVo70AxoKajTfiXzJ2bc
=xOGa
-----END PGP SIGNATURE-----

--ebmxzf4sh66t7pxr--
