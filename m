Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60909 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaA3Oqt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 09:46:49 -0500
Message-ID: <52EA65D2.90604@iki.fi>
Date: Thu, 30 Jan 2014 16:46:42 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] tda10071: remove a duplicative test
References: <20140130120034.GA13267@elgon.mountain>
In-Reply-To: <20140130120034.GA13267@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

I will query that to the kernel 3.15.

thanks
Antti

On 30.01.2014 14:00, Dan Carpenter wrote:
> "ret" is an error code here, we already tested that.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
> index 8ad3a57cf640..a76df29c4973 100644
> --- a/drivers/media/dvb-frontends/tda10071.c
> +++ b/drivers/media/dvb-frontends/tda10071.c
> @@ -1006,8 +1006,7 @@ static int tda10071_init(struct dvb_frontend *fe)
>   				dev_err(&priv->i2c->dev, "%s: firmware " \
>   						"download failed=%d\n",
>   						KBUILD_MODNAME, ret);
> -				if (ret)
> -					goto error_release_firmware;
> +				goto error_release_firmware;
>   			}
>   		}
>   		release_firmware(fw);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
