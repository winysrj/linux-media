Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37882 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGWIWn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 04:22:43 -0400
Message-ID: <53CF70D0.1060907@iki.fi>
Date: Wed, 23 Jul 2014 11:22:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] si2168: Fix unknown chip version message
References: <1406056450-16031-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406056450-16031-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
It is single character formatter, not string, => no need to terminate, 
so that patch is not valid.

regards
Antti


On 07/22/2014 10:14 PM, Mauro Carvalho Chehab wrote:
> At least here with my PCTV 292e, it is printing this error:
>
> 	si2168 10-0064: si2168: unkown chip version Si21170-
>
> without a \n at the end. Probably because it is doing something
> weird or firmware didn't load well. Anyway, better to print it
> in hex, instead of using %c.
>
> While here, fix the typo.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/dvb-frontends/si2168.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 41bdbc4d9f6c..842c4a555d01 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -414,9 +414,8 @@ static int si2168_init(struct dvb_frontend *fe)
>   		break;
>   	default:
>   		dev_err(&s->client->dev,
> -				"%s: unkown chip version Si21%d-%c%c%c\n",
> -				KBUILD_MODNAME, cmd.args[2], cmd.args[1],
> -				cmd.args[3], cmd.args[4]);
> +				"%s: unknown chip version: 0x%04x\n",
> +				KBUILD_MODNAME, chip_id);
>   		ret = -EINVAL;
>   		goto err;
>   	}
>

-- 
http://palosaari.fi/
