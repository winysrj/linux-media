Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34308 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbaKOBCC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 20:02:02 -0500
Message-ID: <5466A606.8030805@iki.fi>
Date: Sat, 15 Nov 2014 03:01:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>,
	linux-media <linux-media@vger.kernel.org>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH 1/3] tuners: si2157: Si2148 support.
References: <1918522.5V5b9CGsli@computer>
In-Reply-To: <1918522.5V5b9CGsli@computer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I wonder if we should define own firmware for Si2148-A20 just for sure. 
Olli?

regards
Antti

On 11/14/2014 11:19 PM, CrazyCat wrote:
> Si2148-A20 silicon tuner support.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> ---
>   drivers/media/tuners/si2157.c      | 10 ++++++----
>   drivers/media/tuners/si2157.h      |  2 +-
>   drivers/media/tuners/si2157_priv.h |  2 +-
>   3 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 25146fa..91f8290 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2147/2157/2158 silicon tuner driver
> + * Silicon Labs Si2147/2148/2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
> @@ -112,11 +112,13 @@ static int si2157_init(struct dvb_frontend *fe)
>   			cmd.args[4] << 0;
>
>   	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
> +	#define SI2148_A20 ('A' << 24 | 48 << 16 | '2' << 8 | '0' << 0)
>   	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
>   	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
>
>   	switch (chip_id) {
>   	case SI2158_A20:
> +	case SI2148_A20:
>   		fw_file = SI2158_A20_FIRMWARE;
>   		break;
>   	case SI2157_A30:
> @@ -309,7 +311,7 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
>
>   static const struct dvb_tuner_ops si2157_ops = {
>   	.info = {
> -		.name           = "Silicon Labs Si2157/Si2158",
> +		.name           = "Silicon Labs Si2147/2148/2157/Si2158",
>   		.frequency_min  = 110000000,
>   		.frequency_max  = 862000000,
>   	},
> @@ -373,7 +375,7 @@ static int si2157_probe(struct i2c_client *client,
>   	i2c_set_clientdata(client, s);
>
>   	dev_info(&s->client->dev,
> -			"Silicon Labs Si2157/Si2158 successfully attached\n");
> +			"Silicon Labs Si2147/2148/2157/Si2158 successfully attached\n");
>   	return 0;
>   err:
>   	dev_dbg(&client->dev, "failed=%d\n", ret);
> @@ -414,7 +416,7 @@ static struct i2c_driver si2157_driver = {
>
>   module_i2c_driver(si2157_driver);
>
> -MODULE_DESCRIPTION("Silicon Labs Si2157/Si2158 silicon tuner driver");
> +MODULE_DESCRIPTION("Silicon Labs Si2147/2148/2157/Si2158 silicon tuner driver");
>   MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>   MODULE_LICENSE("GPL");
>   MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
> diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
> index d3b19ca..c439d0e 100644
> --- a/drivers/media/tuners/si2157.h
> +++ b/drivers/media/tuners/si2157.h
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2147/2157/2158 silicon tuner driver
> + * Silicon Labs Si2147/2148/2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
> diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
> index e71ffaf..6d2aac4 100644
> --- a/drivers/media/tuners/si2157_priv.h
> +++ b/drivers/media/tuners/si2157_priv.h
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2147/2157/2158 silicon tuner driver
> + * Silicon Labs Si2147/2148/2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
>

-- 
http://palosaari.fi/
