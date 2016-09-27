Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750840AbcI0NLb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 09:11:31 -0400
Date: Tue, 27 Sep 2016 15:11:24 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 4/5] smiapp: Use runtime PM
Message-ID: <20160927131124.6w75mja2hewrrkf5@earth>
References: <1473938961-16067-5-git-send-email-sakari.ailus@linux.intel.com>
 <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5n6z4cgbjiv2nm6p"
Content-Disposition: inline
In-Reply-To: <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5n6z4cgbjiv2nm6p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 16, 2016 at 01:53:29AM +0300, Sakari Ailus wrote:
> Use runtime PM to manage power. The s_power() core sub-device callback is
> removed as it is no longer needed.
>=20
> The power management of the sensor is changed so that it is no longer
> dependent on open file descriptors on sub-device or use_count in the media
> entity but solely will be powered on as needed for probing and streaming.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> since v1:
>=20
> - Both smiapp_set_ctrl() and smiapp_update_mode() perform work which is
>   unrelated to the power state of the device. Instead, check the power
>   state in smiapp_write() which is more appropriate.
>=20
> - Don't explicitly disable streaming in smiapp_remove(). It'd be an
>   unrelated change.
>=20
>  drivers/media/i2c/smiapp/smiapp-core.c | 130 ++++++++++++++++-----------=
------
>  drivers/media/i2c/smiapp/smiapp-regs.c |   5 ++
>  drivers/media/i2c/smiapp/smiapp.h      |  11 +--
>  3 files changed, 67 insertions(+), 79 deletions(-)

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--5n6z4cgbjiv2nm6p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJX6m/8AAoJENju1/PIO/qapAAP/ieWXbwF4QijWp6UFvn1gLTn
E4qOIrN7fKLoaxM7WEUjfCeQfCN3xU9c40bqbSfDSZy9UGiFCUM3qQsmjqfbryWv
QIyvOn7FlyRkS8Ov28gRRKLxRMENxJzcWAhRknHPEN72e6ZcdLsRIwBNCYwbu25A
Ip3xAFKEyWZIvpOUxqEinKmsEX8j+RoFnd580XoWWzQyR8dnbOKLsrUruUyEhLw8
QhElvt5CcQ3vwvhdtTB/S2rvqo2kozm5drhoS1Ucsx7HF1xBmfCZBQAelU4d4/iz
TNvCO5urtJomUIrwY3qw0FSLKrk1N2XsQSOKJ97DyAdeyaofk6xZQWv5ooZigt+o
Vj0+s4kUhTR0El9ZZRaKBxPoku6cHtJ28a6Sv6AXiO2eFKDykcYcxJ0Z0/U3KA/O
r1NrR4HGRQx0/99ZCDgvszLwMZqHAuhVqCFJ1cwTr7ShosZCuPJgAsz9amqeQXqK
GBnGkCwSVXEq6GuMk4acvYAoC4RVcnDNo4HTdGQ13L+I1dhGxZkhvhd8e6XVhOpQ
/hBLG38tlpoc8/ie/jlCfp/oiiO8KN7chBOoFZMp19TkddrH4qUYOg8ubNPOkLZm
LAdLDhKGQDVzR0zcSQUZPyP47K+k/fp+CrMi5SoIfww7UluocmNku0SXx4/xPHW4
pztEa06A/7ct298XXvfR
=256h
-----END PGP SIGNATURE-----

--5n6z4cgbjiv2nm6p--
