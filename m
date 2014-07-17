Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44850 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaGQVjn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 17:39:43 -0400
Message-ID: <53C8429C.5070400@iki.fi>
Date: Fri, 18 Jul 2014 00:39:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] si2168: Remove testing for demod presence on probe.
 If the demod is in sleep mode it will fail.
References: <1405630604-19534-1-git-send-email-ljalvs@gmail.com>
In-Reply-To: <1405630604-19534-1-git-send-email-ljalvs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good! I did some measurements against power meter and chip seems 
to be low power state by default. After firmware is downloaded and chip 
is put to sleep, it does not answer that fw status check, until it is 
woken up. There should not be ~any I/O during I2C probe(), so removing 
that quite useless check is OK.

regards
Antti



On 07/17/2014 11:56 PM, Luis Alves wrote:
> Signed-off-by: Luis Alves <ljalvs@gmail.com>
> ---
>   drivers/media/dvb-frontends/si2168.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 3fed522..7e45eeab 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -595,7 +595,6 @@ static int si2168_probe(struct i2c_client *client,
>   	struct si2168_config *config = client->dev.platform_data;
>   	struct si2168 *s;
>   	int ret;
> -	struct si2168_cmd cmd;
>
>   	dev_dbg(&client->dev, "%s:\n", __func__);
>
> @@ -609,13 +608,6 @@ static int si2168_probe(struct i2c_client *client,
>   	s->client = client;
>   	mutex_init(&s->i2c_mutex);
>
> -	/* check if the demod is there */
> -	cmd.wlen = 0;
> -	cmd.rlen = 1;
> -	ret = si2168_cmd_execute(s, &cmd);
> -	if (ret)
> -		goto err;
> -
>   	/* create mux i2c adapter for tuner */
>   	s->adapter = i2c_add_mux_adapter(client->adapter, &client->dev, s,
>   			0, 0, 0, si2168_select, si2168_deselect);
>

-- 
http://palosaari.fi/
