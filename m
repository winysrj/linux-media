Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35155 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdGQXDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 19:03:44 -0400
Date: Tue, 18 Jul 2017 01:03:33 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pavel@ucw.cz, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/7] omap3isp: Ignore endpoints with invalid configuration
Message-ID: <20170717230333.mauiskmeeq2khkt7@earth>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hifcdnx2vw3kwc4e"
Content-Disposition: inline
In-Reply-To: <20170717220116.17886-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hifcdnx2vw3kwc4e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 18, 2017 at 01:01:10AM +0300, Sakari Ailus wrote:
> If endpoint has an invalid configuration, ignore it instead of happily
> proceeding to use it nonetheless. Ignoring such an endpoint is better than
> failing since there could be multiple endpoints, only some of which are
> bad.

I would expect a dev_warn(dev, "Ignore endpoint (broken configuration)!");

-- Sebastian

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Tested-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/media/platform/omap3isp/isp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index db2cccb57ceb..441eba1e02eb 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2110,10 +2110,12 @@ static int isp_fwnodes_parse(struct device *dev,
>  		if (!isd)
>  			goto error;
> =20
> -		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
> +		if (isp_fwnode_parse(dev, fwnode, isd)) {
> +			devm_kfree(dev, isd);
> +			continue;
> +		}
> =20
> -		if (isp_fwnode_parse(dev, fwnode, isd))
> -			goto error;
> +		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
> =20
>  		isd->asd.match.fwnode.fwnode =3D
>  			fwnode_graph_get_remote_port_parent(fwnode);
> --=20
> 2.11.0
>=20

--hifcdnx2vw3kwc4e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlltQj8ACgkQ2O7X88g7
+pq56A//bxUGSMXzbgdnxiuua3UA6Cr10IVaU0wzHbqPpagG9kJLwCjv3WdZTgiS
gW8e13R7z98t/blqauOFO9mfFZHq/c1ZzJXKPIuzTu3YhLyckk1ha7ulghlwOf+N
VG1BNjEO+EXllr0ISJ2x3ylIe8ky7CW5LyjyC+F4L8QsNrWzY/X7pFmwA4LLM+46
olJjv5okBZP4Bglaw48r1lD0ck2QxFsvEmiHoBfqmThQCR1J1DEg8jpbmK3bLmqn
FX7q1omMqBrRvCNjS4xNO0L5lHLe9Nw/HJ71TED6anak+vntYZR0s3/fr3JsbXOZ
gTLdC9WOK+bKMN5M6ErUwTuw+QeV/Zr7o1fzN1v3hzWpQhC/Uz8uUpQmr4MNvdv+
AXyUm/0H/lKnGHEyIN0OIp33LHjMQKg4cC/2JoF0Kzxg6UchJeqY28JXiW2NtBZL
i1gQpSkIrf5gs/CNbdOK8vZMMoRjw6VMXEAGfLcUxLusPYWJjnjrTt47RCrNQVEY
BDHBzjAHOyF26INLDv0m8gQvb9Jt7dNf0Raym6teGyn3gWNcW0x63eBIwh8b3+9w
DjjaerBIu38NLieQ+IRMzi8d39MpnjkTUl2q67ZtAg2M9DJdZRoTreDVDnj2GOP6
NdiKp+uUQdCfNfkRbZUeQIEGfWzr8XCqpVqKsmCs9Kc+b16AfZY=
=f4J4
-----END PGP SIGNATURE-----

--hifcdnx2vw3kwc4e--
