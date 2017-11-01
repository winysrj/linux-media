Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754381AbdKAJkr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 05:40:47 -0400
Date: Wed, 1 Nov 2017 10:40:43 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] media: v4l2-fwnode: use the cached value instead of
 getting again
Message-ID: <20171101094043.6cbjcccd7oyjvzdz@earth>
References: <2e926f1070f783f603806068c282399cf832bf2b.1509474169.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="b7jleouqbde23hlv"
Content-Disposition: inline
In-Reply-To: <2e926f1070f783f603806068c282399cf832bf2b.1509474169.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--b7jleouqbde23hlv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 31, 2017 at 02:22:59PM -0400, Mauro Carvalho Chehab wrote:
> There is a get/put operation in order to get firmware is_available
> data there at the __v4l2_async_notifier_parse_fwnode_endpoints()
> function. However, instead of using it, the code just reads again
> without the lock. That's probably a mistake, as a similar code on
> another function use the cached value.
>=20
> This solves this smatch warning:
>=20
> drivers/media/v4l2-core/v4l2-fwnode.c:453:8: warning: variable 'is_availa=
ble' set but not used [-Wunused-but-set-variable]
>    bool is_available;
>         ^~~~~~~~~~~~
>=20
> Fixes: 9ca465312132 ("media: v4l: fwnode: Support generic parsing of grap=
h endpoints in a device")
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-fwnode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index 3b9c6afb49a3..681b192420d9 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -455,8 +455,7 @@ static int __v4l2_async_notifier_parse_fwnode_endpoin=
ts(
>  		dev_fwnode =3D fwnode_graph_get_port_parent(fwnode);
>  		is_available =3D fwnode_device_is_available(dev_fwnode);
>  		fwnode_handle_put(dev_fwnode);
> -
> -		if (!fwnode_device_is_available(dev_fwnode))
> +		if (!is_available)
>  			continue;
> =20
>  		if (WARN_ON(notifier->num_subdevs >=3D notifier->max_subdevs)) {
> --=20
> 2.13.6
>=20

--b7jleouqbde23hlv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln5lpYACgkQ2O7X88g7
+pqPFQ/+Kh6bD3iumrUhStB4ytX+1eyCQUTT6Gx3JhLH2kEZ72IIRTM4S5uXosfy
iFLSA8n+krbuX1TdGIyr35SxY8eLkI3SIspc2bYy7SWIHQxwPJLhLUTaWXPAK2ax
Sc0eHCupDFlfQv4BpGCvlwT74qZSDz4BQ30lyfPZFnix5D00h86CI6koLjOmt/Xl
aMVTWvQS2rM/0DdWGkj6TFItY1QyhYztffEOyguswyHs6C6TyhIM4sHL16PbG27d
5Jpkp0tI44EiZj3MHVUK3VRDMgD4Sqsml4siR0IUUVIaJUQv6Qv2gjYELUFYUiv9
m8kNGaLjPDooyNVIGiMR1v6kyRZVXJt20xOfA9Xq6u9LDuZF+RLze6S1ZKzYfzMU
MT966oNkfR6LSg9fZPIYn6b15I0of2QvHJgrSwkrkcLU5ZiFgQ3RG6lwp8MWL3nA
z5/9+F4kin3IgJ1Tv0e/11UnJJ1DRZdo5qEDQ8yLgf/DN9scRI6gu8hVNJWL/Pq1
gB5jQJWxRK+L9HK/dbLoSfH2+7858ihXLBUGUTY6EFbv6sTNONoUrRkWAxgwtnuA
4wW4Z71OO3OaCJrlwwiUPb7n5yxs6k1l8Qz164qQKFtm41pPu+P2kzZkO5V8jUGJ
+V8FWym1il48gBbq4Q55p7EnSJ69tMHLxyi+ZwhuLFZJ+qLLwRg=
=8FsF
-----END PGP SIGNATURE-----

--b7jleouqbde23hlv--
