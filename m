Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48280 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbaGQVer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 17:34:47 -0400
Message-ID: <53C84175.1030207@iki.fi>
Date: Fri, 18 Jul 2014 00:34:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] si2168: Fix i2c_add_mux_adapter return value in probe
 function. In case it failed the return value was always 0.
References: <1405625888-9056-1-git-send-email-ljalvs@gmail.com>
In-Reply-To: <1405625888-9056-1-git-send-email-ljalvs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gah, there was a bug. Will apply that. Have to check if there is same 
mistake on other drivers I have used I2C mux.

regards
Antti

On 07/17/2014 10:38 PM, Luis Alves wrote:
> Signed-off-by: Luis Alves <ljalvs@gmail.com>
> ---
>   drivers/media/dvb-frontends/si2168.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7980741..3fed522 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -619,8 +619,10 @@ static int si2168_probe(struct i2c_client *client,
>   	/* create mux i2c adapter for tuner */
>   	s->adapter = i2c_add_mux_adapter(client->adapter, &client->dev, s,
>   			0, 0, 0, si2168_select, si2168_deselect);
> -	if (s->adapter == NULL)
> +	if (s->adapter == NULL) {
> +		ret = -ENODEV;
>   		goto err;
> +	}
>
>   	/* create dvb_frontend */
>   	memcpy(&s->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
>

-- 
http://palosaari.fi/
