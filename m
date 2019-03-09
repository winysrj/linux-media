Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E7FC43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 09:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6EE20851
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 09:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfCIJ5c (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:57:32 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:37625 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfCIJ5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 04:57:32 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 48924240008;
        Sat,  9 Mar 2019 09:57:28 +0000 (UTC)
Date:   Sat, 9 Mar 2019 10:58:03 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: renesas-ceu: fix a potential NULL pointer
 dereference
Message-ID: <20190309095803.edauvethw232h45t@uno.localdomain>
References: <20190309071424.3600-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jyth2wtasn7sfcer"
Content-Disposition: inline
In-Reply-To: <20190309071424.3600-1-kjlu@umn.edu>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--jyth2wtasn7sfcer
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kangjie,
   thanks for the patch.

On Sat, Mar 09, 2019 at 01:14:24AM -0600, Kangjie Lu wrote:
> In case of_match_device cannot find a match, the check returns
> -EINVAL to avoid a potential NULL pointer dereference
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/platform/renesas-ceu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
> index 150196f7cf96..4aa807c0b6c7 100644
> --- a/drivers/media/platform/renesas-ceu.c
> +++ b/drivers/media/platform/renesas-ceu.c
> @@ -1682,7 +1682,10 @@ static int ceu_probe(struct platform_device *pdev)
>
>  	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
>  		ceu_data = of_match_device(ceu_of_match, dev)->data;
> -		num_subdevs = ceu_parse_dt(ceudev);
> +		if (unlikely(!ceu_data))
> +			num_subdevs = -EINVAL;
> +		else
> +			num_subdevs = ceu_parse_dt(ceudev);

I don't think this fix is required to be honest.

If we call of_match_device() here we're sure CONFIG_OF is enabled, and
if the driver probed, so a matching compatible string has proved to
exist.

Furthermore, if you want to protect against of_match_device()
returning a NULL pointer, you should change this line first, as it
would dereference an invalid pointer:

  		ceu_data = of_match_device(ceu_of_match, dev)->data;

but again, I don't think this might happen.

Thanks
   j

>  	} else if (dev->platform_data) {
>  		/* Assume SH4 if booting with platform data. */
>  		ceu_data = &ceu_data_sh4;
> --
> 2.17.1
>

--jyth2wtasn7sfcer
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyDjisACgkQcjQGjxah
VjxnLQ/9FLHdKAf5dcDs5iXjjQwELSi774qjj3K7vK+gXjTRbizfRiKBAg8swQ7r
+CJL0hBEfGsKOTYX+Yi6ITXQ80hdDLfatkXXnyTqjrC1W+vv8u9G5of0/mL0zbSH
MjDIOSOE1zQ+seSwbh15MSciXuRGE+C7LrIALlSmjUg/IFhVosW87q7jXdfxHZEm
IfJi2L0+Xyr7gLolLLqYjzEl84pax6heRLFsWMmMwo4jFmdQZVBhn3PohUFt8W0h
qCUlWp7+z+a7/0GB4OyMTprWqgJ1ou0i4MMgOFP4zhVjKxXAXhdnOcI63UA/Iy9U
Y0CbweOmjpgS+orUu1ZwzIVD6jQfq0t+9Ype4ARZOftjVyVQAHn+iAhc4jvaQH5k
8Z6FuSakuyvrWo6rDLxXJRIjiAhcxiI1d2zFfZfQcKsg0w435IAjlJUeE3mk+nTj
pSahEAyqHfMK5Yprfq48FsR9vHUsu2gF7YIB94oFeb+N7TrnoCAi8NjNyrEUm08x
mVt6gAYwBnN6SMSg5QasmO+z7+S7/ve5vqne3jr7RSDUtAue9abVwNnQG6vlX7qF
Ro4hfvw+5kWIGc1lS7xQ8FOTDX0RwhbczZepmfNXshMum8GYZNnmlzy6nx5T5FVz
bUhhHE/8RRrHbW+SGkUyiDijHlaz00NOzA1v20Txyutj6/6USEU=
=rU7t
-----END PGP SIGNATURE-----

--jyth2wtasn7sfcer--
