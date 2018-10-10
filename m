Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51113 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbeJJQK3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 12:10:29 -0400
Date: Wed, 10 Oct 2018 10:49:16 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] media: ov5640: fix get_light_freq on auto
Message-ID: <20181010084916.GC7677@w540>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
 <1539067682-60604-3-git-send-email-sam@elite-embedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
Content-Disposition: inline
In-Reply-To: <1539067682-60604-3-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sam,

On Mon, Oct 08, 2018 at 11:48:00PM -0700, Sam Bobrowicz wrote:
> Light frequency was not properly returned when in auto
> mode and the detected frequency was 60Hz. Fix this.
>
> Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>

This is indeed a bugfix

Acked-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
  j
> ---
>  drivers/media/i2c/ov5640.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 5031aab..f183222 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1295,6 +1295,7 @@ static int ov5640_get_light_freq(struct ov5640_dev *sensor)
>  			light_freq = 50;
>  		} else {
>  			/* 60Hz */
> +			light_freq = 60;
>  		}
>  	}
>
> --
> 2.7.4
>

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbvb0MAAoJEHI0Bo8WoVY8ECMP/RI32kjE21k3G/v9z/wL/QF6
iGobyM+XM2THVWDuu6lVyJ/H9XZEUSZ9zw5kAPQ789+74XQmstRLLDrwIihUOHKZ
RL2exdPufHM5NTstw7IfN55XlWIFO1s9YzschrlVILZSw2S6tOLX4jtOW/wObuS7
ILE/IQC2yVont7JXviNH4hvmjbOFnqXa/3TZ9G5/mSzUoiaPJVEiFOisdycsmNBL
nkA7ouvhDnhwYX0NzrATSqIG4IRH0QwBSVSp0bsjR7ef1ka9i5FAeVeXAyWgHDdF
oapbZG+yledVyTORd8mGmVff+Nd+3hfeqmZf4qzbOWRDCX+8mCU2GTxnO9Grs95H
dQno37Yx4JxEZ+3+G6PCnJxaFjrOXA3Qz2Gua/ezWRgAauckbOsZWCfZ6bpTLnZ8
eXfMUMGdENxrGpi2s3hf2/PuKWLWLmmg0Y+jbC2LiTYrlnod+pAu6/vJY1oDQstI
a4jJ45AUT6h2rWGD1mdam5TxmPsQRQ4b0PGT5/X+GhJpufmmkUNc/TPYNLK+kB6V
Wia82fUQEXKxpz1jjqfVYN9+PI/2WsrYWYKZFwLYmmiXUiW7Mb1q14XEZDfdom4U
ET/VnejVRk37yaM/uezlRj5zdpIADuSSy5HkHNkedUP1q8x3oZd90NWLFaucUVUt
anlykBVl2Bcs76ndhRDr
=sk7O
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--
