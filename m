Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60607 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731234AbeHPNL0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:11:26 -0400
Date: Thu, 16 Aug 2018 12:13:51 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] media: ov772x: Disable clk on error path
Message-ID: <20180816101351.GB19047@w540>
References: <1534363839-28509-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <1534363839-28509-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello Alexey,
   thanks for the patch

On Wed, Aug 15, 2018 at 11:10:39PM +0300, Alexey Khoroshilov wrote:
> If ov772x_power_on() is unable to get GPIO rstb,
> the clock is left undisabled.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>

Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks
   j

> ---
>  drivers/media/i2c/ov772x.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index e2550708abc8..7b62bf1fc5b1 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -828,6 +828,7 @@ static int ov772x_power_on(struct ov772x_priv *priv)
>  					     GPIOD_OUT_LOW);
>  	if (IS_ERR(priv->rstb_gpio)) {
>  		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
> +		clk_disable_unprepare(priv->clk);
>  		return PTR_ERR(priv->rstb_gpio);
>  	}
>
> --
> 2.7.4
>

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbdU5fAAoJEHI0Bo8WoVY8nHoQAKFTbaogq1/Umm3uZCUTcVQ1
nPdhav4jEpna4q+e5slQ9+YVMvg4gWEsEYdgO+XSZTkFJomAnLC6q8R7yKVDMxFM
zYHNbpfCT2GaL43klmLxmFv78QxMIJbu96n6VOKecyPSDg7+DtRKIXcMsvvnuYMO
yziTOOKXD1XzbcjDX0grb4A1JvpZR7Hvp8xC5eHxR31a/rQPW8tgiO5x7fQQgwer
BMB34xgGpoH50mKAz6GqmRx2at2OMXvToRl/PmWkqCl+xj0UEj7FdxJxeBqWLNSg
w7+QvGJPramJHPmXm3gBDcXsEXiY/FhiA1Z77k98d70nmCznEkdLfhbX38sEgbFp
FPnx1WEha/ZEuJcKQGsk6HraKRiVgI/OME3NEfrPXUwRhXld1zEeAgbUFfajndYB
EVgDgdhrYmcFDr6kGa8FDWg0FJdKRYQpB34xKlf35izOQ36noQaCNcyHcln9vVgd
Qey1WPIlcqw1x1VeoHIGdLdakgIHUCsiLxi8B4iOwdp0vRryF+48HmU3GXUIy+4B
tTGhenAc+rEBbNgHVHDL4PU4bLNqTjLxsZCfO7W6MCt9GkA12Iubo//WDawwCjWE
doo64vG+xLqCtBERIXPVRNYFu04V3k9fhWLXbJYRm7+bzsYpRDkRE6zCXToTFiwE
gthgWZ5fJnU6bcV1lrR3
=86Og
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
