Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42467 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbeG3JZM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 05:25:12 -0400
Date: Mon, 30 Jul 2018 09:51:25 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] mt9v111: Fix compiler warning by initialising a
 variable
Message-ID: <20180730075125.GE7615@w540>
References: <20180730072627.32014-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Content-Disposition: inline
In-Reply-To: <20180730072627.32014-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Mon, Jul 30, 2018 at 10:26:27AM +0300, Sakari Ailus wrote:
> While this isn't a bug, initialise the variable to quash the warning.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/mt9v111.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/mt9v111.c b/drivers/media/i2c/mt9v111.c
> index da8f6ab91307..58d5f2224bff 100644
> --- a/drivers/media/i2c/mt9v111.c
> +++ b/drivers/media/i2c/mt9v111.c
> @@ -884,7 +884,7 @@ static int mt9v111_set_format(struct v4l2_subdev *subdev,
>  	struct v4l2_mbus_framefmt new_fmt;
>  	struct v4l2_mbus_framefmt *__fmt;
>  	unsigned int best_fit = ~0L;
> -	unsigned int idx;
> +	unsigned int idx = 0;
>  	unsigned int i;
>

Thanks for this, but there is already a patch sent on Friday by Jasmin
addressing the warning

https://patchwork.kernel.org/patch/10547983/

>  	mutex_lock(&mt9v111->stream_mutex);
> --
> 2.11.0
>

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbXsN9AAoJEHI0Bo8WoVY8TWkQAKWwI1KuMYK9peOgWl/Zklat
g08dWsY4YHjB4qtJpRu8kvJLargduQaijjkRG2zH9NBbI55q++vrW1Zz7GLUS2Ie
prt+Lz/3a11GkrQUirtSSnMK2ZpF4qbfqXgmpQNdNdWn+R4rlN5fZObZN6d/Rs4r
gTGTy+03nu8tfPFhhHcxxQQRP0lFESjgvsoVplklOBTPp0rANqGBOryR5huMBBfg
9whTaQwx45vnNUtmNM1Y8HqQMZcMIsQRGWwaiBOLLFW7XzWseo/6esVUAYAjfYMs
Bxzpz0AqdQrKhA0V0f8iizIxuSVFAPCkH2pN91V51ZKxBq8X197438DYWRvPRb5u
LJOrkyXASkU9TNLmAc9ncE6JMxAfgBhSgpGtlYE/7luemq+ScJrws7s6Ek2DMX+6
z0kwJUfkj4S82XwrKHLWjaIVcCkIGQ99fKIw7VcqfcjDPiYeP+n++ZO5ZlXLtd3Z
cQm58DkuM75NTe3Mq13KdAKgNQ4iv6JX6mwP/EZpk1DWECJiUoUsV9okzwr6BwEx
oQYbNIKpndd4lYZoLvfdqLuOB2oP565Jgq/45eWcHmUbHU9hcMSqgSK5rmpUqnrR
BybSf8FYWHDbCG/xzCtL1hmLdQbpLZah+gRLeieeI+jN8mN6JNoMt48H8mWgVJmc
NLOAg/ZPkRFW+WhJnEF4
=VM0R
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
