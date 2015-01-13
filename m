Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56327 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbbAMPym (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 10:54:42 -0500
Message-ID: <54B53FC0.8090704@iki.fi>
Date: Tue, 13 Jan 2015 17:54:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mn88473: simplify bandwidth registers setting code
References: <1421105006-22437-1-git-send-email-benjamin@southpole.se> <1421105006-22437-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1421105006-22437-2-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2015 01:23 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

> ---
>   drivers/staging/media/mn88473/mn88473.c | 27 ++++++---------------------
>   1 file changed, 6 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
> index b65e519..994294c 100644
> --- a/drivers/staging/media/mn88473/mn88473.c
> +++ b/drivers/staging/media/mn88473/mn88473.c
> @@ -59,28 +59,13 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
>   		goto err;
>   	}
>
> -	switch (c->delivery_system) {
> -	case SYS_DVBT:
> -	case SYS_DVBT2:
> -		if (c->bandwidth_hz <= 6000000) {
> -			/* IF 3570000 Hz, BW 6000000 Hz */
> -			memcpy(bw_val, "\xe9\x55\x55\x1c\x29\x1c\x29", 7);
> -		} else if (c->bandwidth_hz <= 7000000) {
> -			/* IF 4570000 Hz, BW 7000000 Hz */
> -			memcpy(bw_val, "\xc8\x00\x00\x17\x0a\x17\x0a", 7);
> -		} else if (c->bandwidth_hz <= 8000000) {
> -			/* IF 4570000 Hz, BW 8000000 Hz */
> -			memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
> -		} else {
> -			ret = -EINVAL;
> -			goto err;
> -		}
> -		break;
> -	case SYS_DVBC_ANNEX_A:
> -		/* IF 5070000 Hz, BW 8000000 Hz */
> +	if (c->bandwidth_hz <= 6000000) {
> +		memcpy(bw_val, "\xe9\x55\x55\x1c\x29\x1c\x29", 7);
> +	} else if (c->bandwidth_hz <= 7000000) {
> +		memcpy(bw_val, "\xc8\x00\x00\x17\x0a\x17\x0a", 7);
> +	} else if (c->bandwidth_hz <= 8000000) {
>   		memcpy(bw_val, "\xaf\x00\x00\x11\xec\x11\xec", 7);
> -		break;
> -	default:
> +	} else {
>   		ret = -EINVAL;
>   		goto err;
>   	}
>

-- 
http://palosaari.fi/
