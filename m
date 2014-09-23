Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35921 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaIWMgy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 08:36:54 -0400
Message-ID: <54216962.5060805@iki.fi>
Date: Tue, 23 Sep 2014 15:36:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] si2157: Add support for Si2147-A30
References: <1411296799-3525-1-git-send-email-olli.salonen@iki.fi> <1411296799-3525-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411296799-3525-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>


On 09/21/2014 01:53 PM, Olli Salonen wrote:
> This patch adds support for Si2147-A30 tuner. Fairly trivial, no firmware
> needed for this tuner. However, command 14 00 02 07 01 00 seems to be
> mandatory. On Si2157 and Si2158 the value 0x0100 is the default value, so this
> patch does not impact the existing tuners/devices. On Si2147 the default is
> 0x0000 and I can't get a lock with that value.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> Cc: crope@iki.fi
> ---
>   drivers/media/tuners/si2157.c      | 13 +++++++++++--
>   drivers/media/tuners/si2157.h      |  2 +-
>   drivers/media/tuners/si2157_priv.h |  2 +-
>   3 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index efb5cce..41965c7 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2157/2158 silicon tuner driver
> + * Silicon Labs Si2147/2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
> @@ -110,12 +110,14 @@ static int si2157_init(struct dvb_frontend *fe)
>
>   	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
>   	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
> +	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
>
>   	switch (chip_id) {
>   	case SI2158_A20:
>   		fw_file = SI2158_A20_FIRMWARE;
>   		break;
>   	case SI2157_A30:
> +	case SI2147_A30:
>   		goto skip_fw_download;
>   		break;
>   	default:
> @@ -258,7 +260,14 @@ static int si2157_set_params(struct dvb_frontend *fe)
>   	if (s->inversion)
>   		cmd.args[5] = 0x01;
>   	cmd.wlen = 6;
> -	cmd.rlen = 1;
> +	cmd.rlen = 4;
> +	ret = si2157_cmd_execute(s, &cmd);
> +	if (ret)
> +		goto err;
> +
> +	memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
> +	cmd.wlen = 6;
> +	cmd.rlen = 4;
>   	ret = si2157_cmd_execute(s, &cmd);
>   	if (ret)
>   		goto err;
> diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
> index 6da4d5d..d3b19ca 100644
> --- a/drivers/media/tuners/si2157.h
> +++ b/drivers/media/tuners/si2157.h
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2157/2158 silicon tuner driver
> + * Silicon Labs Si2147/2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
> diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
> index 3ddab5e..02350f8 100644
> --- a/drivers/media/tuners/si2157_priv.h
> +++ b/drivers/media/tuners/si2157_priv.h
> @@ -1,5 +1,5 @@
>   /*
> - * Silicon Labs Si2157/2158 silicon tuner driver
> + * Silicon Labs Si2147/2157/2158 silicon tuner driver
>    *
>    * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
>    *
>

-- 
http://palosaari.fi/
