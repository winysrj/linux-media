Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:33621 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbeECPiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 11:38:15 -0400
Date: Thu, 3 May 2018 17:38:01 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v4 02/14] media: ov772x: correct setting of banding filter
Message-ID: <20180503153801.GB19612@w540>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
 <1525021993-17789-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <1525021993-17789-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,
   thanks for the patch

On Mon, Apr 30, 2018 at 02:13:01AM +0900, Akinobu Mita wrote:
> The banding filter ON/OFF is controlled via bit 5 of COM8 register.  It
> is attempted to be enabled in ov772x_set_params() by the following line.
>
> 	ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, 1);
>
> But this unexpectedly results disabling the banding filter, because the
> mask and set bits are exclusive.
>
> On the other hand, ov772x_s_ctrl() correctly sets the bit by:
>
> 	ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, BNDF_ON_OFF);
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

One unrelated note: the fixes you have added in v4 are very welcome.
For another time, maybe you want to send incremental patches instead
of adding them to a series already in review, as increasing the series
size may slow down its inclusion due to review latencies.
V1 was 6 patches, v2 and v3 10, and this is one 14. This is fine, but
to speed up things, maybe send fixes like this one separately and
clearly state they have some dependency on an already sent series.
That said, I'm not collecting patches, so that's just how I see that,
maybe Sakari, who usually picks sensor driver contributions prefers the way
you sent this.

Thanks
   j

> ---
> * v4
> - New patch
>
>  drivers/media/i2c/ov772x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index b62860c..e255070 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1035,7 +1035,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>
>  	/* Set COM8. */
>  	if (priv->band_filter) {
> -		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, 1);
> +		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, BNDF_ON_OFF);
>  		if (!ret)
>  			ret = ov772x_mask_set(client, BDBASE,
>  					      0xff, 256 - priv->band_filter);
> --
> 2.7.4
>

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa6yzZAAoJEHI0Bo8WoVY83mYQAJZ7JZWm/qWQZacsYwGvYH6Y
DHSH2XcPwOX2cWoegU/OY6ri2exoFiMQFz6Jcngre0Qfa8+enjjE8vW5oLxvZjao
BJO9IAsppBWXisRLwdcjZJPn8XIQ5JpdV4FqzClASs6mArjuIe2txgEfb1XuOent
bznL48168HY56seEKV1CFX86xx0zADtKVTZ0T+49r+l7RZsFKN5NMJl5UVlP/ZL6
JBru1MgnOpKJsON6ezeyiHG1aS5hFsCZtFjS4LJb1e09LTNg5PlBo5ldUmhmd0cf
N/a+KHlKHZU+nwZ5PxevkVJofuY2VQpFK8IRv13YIQToKCMbaSFA7/SY9gJdZzqC
MOoWOHz0ZMwwHcTh9Mt4DS4ZgfE5TrlqasaPrqT9S3jDLRB5IJNhibkDgfGuKASJ
H1VjASAo3fbaoqL+ZKdqMniBAaJNqcuqZM9ShnM/daHKghdcA+/XD1gr0v4NrtqW
pJP3Ge6GaTuod+E+q3OvcDBgo/CILYfaAD9OeyCBBwniTY+Z61vCor6qkWm4L7iU
P93ZD/400Cgh9gAfjgE19YrFFlvYHPSWdxAYNhoUa4B/308iGo0VcEn9gy5OQE8Y
NiA7jCmlKXpJT8rDeg5lrFh/G/MD6kL0wI0KYp57d08sKwQdy+K7Uzavudac8Csx
S3znhYWDWJnhzZRTD9kx
=c3EM
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
