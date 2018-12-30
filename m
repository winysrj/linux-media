Return-Path: <SRS0=gp/0=PH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F4DC43387
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 09:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5637620855
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 09:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbeL3Jwa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 30 Dec 2018 04:52:30 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:56082 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeL3Jwa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Dec 2018 04:52:30 -0500
Received: from relay7-d.mail.gandi.net (unknown [217.70.183.200])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id CC4AB3A441C;
        Sun, 30 Dec 2018 10:49:33 +0100 (CET)
X-Originating-IP: 37.176.180.32
Received: from uno.localdomain (unknown [37.176.180.32])
        (Authenticated sender: jacopo@jmondi.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 55C5720003;
        Sun, 30 Dec 2018 09:49:29 +0000 (UTC)
Date:   Sun, 30 Dec 2018 10:49:27 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] media: tw9910: add missed clk_disable_unprepare() on
 failure path
Message-ID: <20181230094918.6ysahn7tr6us6uoh@uno.localdomain>
References: <1546119320-11841-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="csa27tseyhrjxlu6"
Content-Disposition: inline
In-Reply-To: <1546119320-11841-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--csa27tseyhrjxlu6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Alexey,
   thanks for the patch

On Sun, Dec 30, 2018 at 12:35:20AM +0300, Alexey Khoroshilov wrote:
> If gpiod_get_optional() fails in tw9910_power_on(), clk is left undisabled.
>

Correct, thanks for spotting this.

I think pdn_gpio should also be handled if rstb_gpio fails.
What's your opinion?

Thanks
  j

> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/media/i2c/tw9910.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
> index a54548cc4285..109770d678d2 100644
> --- a/drivers/media/i2c/tw9910.c
> +++ b/drivers/media/i2c/tw9910.c
> @@ -610,6 +610,7 @@ static int tw9910_power_on(struct tw9910_priv *priv)
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

--csa27tseyhrjxlu6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlwolKcACgkQcjQGjxah
VjyYNhAArW3S6a0VKHt1tOqepKIhIZkqkl9SIlfKx0RuP2ir7rN9CQllhhwnqeyH
p+7qzScVydDnk+tmTqXEqf3w0yFpgtCc3qqMjyYNkfBWtbb2O0YQCpcq4hDzHyHK
jeEinxZzUzn5T9eBwMpjEI9wFi+3fjUit4yRSN7O9kdfQRCpYjCHdQEVuqUwuf5w
8OrlMV6VhV3MARQdvbh4JAQ4ldQoUkx7cVRZ7rkL73qRb8pGTuIZAJbHO0A9mZKd
mkc6yjOga9VIBmx54MHHzRBNtMZjtqth05GOvp6oTZ1zMMZ9iGCR93x5f5+rM6+I
C1ep5Ju0KP4MGqzzfsmal2Cfp9Wq6HD0O+D1y3okwkV7YfZ63Fxz4PS3vDecS37J
qBD9eC4TsYBo/WPCCX/Xe0WfTeonpbDD8dMkTSoZ9kbwbbl8F5hzBj4mKOEFcrPc
c20Rea4WMWayE7WHmEKkHiEOwsrAdkGSBMxEmzb7rD48rCv5rXPISbTQXESKRFsM
c6egrbU2Blgl0pnh9RJjygjnpgARzPyLiPuy+CtAs8vH3Qd8+LHGadxkvqZ+1y6U
EZYkdF56iYTKq6SJDf5/OFJnKZi9++5dYrbgH7iZR19IPF1ZJblOgdmNKHeZQgRY
0UM3MbsiTNH421Uipf8Qf5AjS5G9MB5EQsCICYMBJ/HAP8XzZNE=
=xxg+
-----END PGP SIGNATURE-----

--csa27tseyhrjxlu6--
