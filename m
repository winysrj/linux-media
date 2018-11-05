Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:44311 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbeKEURx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 15:17:53 -0500
Date: Mon, 5 Nov 2018 11:58:41 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [media] ov7670: make "xclk" clock optional
Message-ID: <20181105105841.GJ20885@w540>
References: <20181004212903.364064-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lildS9pRFgpM/xzO"
Content-Disposition: inline
In-Reply-To: <20181004212903.364064-1-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lildS9pRFgpM/xzO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Lubomir,
   +Sakari in Cc

I just noticed this, and the patch is now in v4.20, but let me comment
anyway on this.

On Thu, Oct 04, 2018 at 11:29:03PM +0200, Lubomir Rintel wrote:
> When the "xclk" clock was added, it was made mandatory. This broke the
> driver on an OLPC plaform which doesn't know such clock. Make it
> optional.
>

I don't think this is correct. The sensor needs a clock to work.

With this patch clock_speed which is used to calculate
the framerate is defaulted to 30MHz, crippling all the calculations if
that default value doesn't match what is actually installed on the
board.

If this patch breaks the OLPC, then might it be the DTS for said
device needs to be fixed instead of working around the issue here?

Also, the DT bindings should be updated too if we decide this property
can be omitted. At this point, with a follow-up patch.

Thanks
   j

> Tested on a OLPC XO-1 laptop.
>
> Cc: stable@vger.kernel.org # 4.11+
> Fixes: 0a024d634cee ("[media] ov7670: get xclk")
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/media/i2c/ov7670.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 31bf577b0bd3..64d1402882c8 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1808,17 +1808,24 @@ static int ov7670_probe(struct i2c_client *client,
>  			info->pclk_hb_disable = true;
>  	}
>
> -	info->clk = devm_clk_get(&client->dev, "xclk");
> -	if (IS_ERR(info->clk))
> -		return PTR_ERR(info->clk);
> -	ret = clk_prepare_enable(info->clk);
> -	if (ret)
> -		return ret;
> +	info->clk = devm_clk_get(&client->dev, "xclk"); /* optional */
> +	if (IS_ERR(info->clk)) {
> +		ret = PTR_ERR(info->clk);
> +		if (ret == -ENOENT)
> +			info->clk = NULL;
> +		else
> +			return ret;
> +	}
> +	if (info->clk) {
> +		ret = clk_prepare_enable(info->clk);
> +		if (ret)
> +			return ret;
>
> -	info->clock_speed = clk_get_rate(info->clk) / 1000000;
> -	if (info->clock_speed < 10 || info->clock_speed > 48) {
> -		ret = -EINVAL;
> -		goto clk_disable;
> +		info->clock_speed = clk_get_rate(info->clk) / 1000000;
> +		if (info->clock_speed < 10 || info->clock_speed > 48) {
> +			ret = -EINVAL;
> +			goto clk_disable;
> +		}
>  	}
>
>  	ret = ov7670_init_gpio(client, info);
> --
> 2.19.0
>

--lildS9pRFgpM/xzO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb4CJhAAoJEHI0Bo8WoVY8T4EP/20jk08NU+3uAbP5KtpmbirC
bfLr1t5zfjIaq6okDqw1aslMbPzlOtb0BpcJX3adttCtUUWQT7bkWfiPUZLfkLAz
zSBvPHZarIqhTtnc3wIA+2H4d1XB63j/+a8hAmqIK3CqLhUJOC3SxA7dxxive+hW
HMfY3g4g33OtehF4OzVlFlrKUHBkFFuzUjy27MAZ3si7D8nHCzKONxIXuWbTkPj6
Swsrg4Hl198IuMGdqWW9/rM84/Foa6osGZmr5DGlnw3slmbcCgiSWPQ4/+gkojNl
4AtjRtwVAVHxUyE0EvK1T8TMnLD3vRWUu6m3Xmwqs+B7T2k5Ww8FiT3uHTVfsX0c
SoOCuDfslzcK70xLeH+I/uK1PJCIVkhpNkmZnNJf0oG5C0oODg7gopYmbOQEFAF9
IQdPwxdg4Z1YuA68SdE6vwNiBfuqWq9DQ3FqRHcQqOQDe0X2YcuMLK/sMa1XYkYn
waduL0DD4LwhcnB39p1XNRRZ6UQ+rU8oWt8c/9HMq/ldVilVGkNhNE+fUmEZGtLk
V0YPVw5pQKKjye6WPmQm66VxhFUD5w9A6wpcLUhrZI4OXxuMkkrtVBSHYHpGofIi
zKAR5Fa9I5gNmXjmwvccJEi6Wir1mEDUIlAs4DR+b7EEMKyrXsRH/audZpnVEVY0
Noq3MtAR6KxAtfNpppkA
=WJ6g
-----END PGP SIGNATURE-----

--lildS9pRFgpM/xzO--
