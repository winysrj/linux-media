Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42472 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbbAMQ50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 11:57:26 -0500
Message-ID: <54B54E74.5010908@iki.fi>
Date: Tue, 13 Jan 2015 18:57:24 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mn88472: simplify bandwidth registers setting code
References: <1420246244-6031-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1420246244-6031-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2015 02:50 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti

> ---
>   drivers/staging/media/mn88472/mn88472.c | 41 +++++++++++----------------------
>   1 file changed, 14 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 33604dc..ee933c3 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -58,35 +58,22 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
>   		goto err;
>   	}
>
> -	switch (c->delivery_system) {
> -	case SYS_DVBT:
> -	case SYS_DVBT2:
> -		if (c->bandwidth_hz <= 5000000) {
> -			memcpy(bw_val, "\xe5\x99\x9a\x1b\xa9\x1b\xa9", 7);
> -			bw_val2 = 0x03;
> -		} else if (c->bandwidth_hz <= 6000000) {
> -			/* IF 3570000 Hz, BW 6000000 Hz */
> -			memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
> -			bw_val2 = 0x02;
> -		} else if (c->bandwidth_hz <= 7000000) {
> -			/* IF 4570000 Hz, BW 7000000 Hz */
> -			memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
> -			bw_val2 = 0x01;
> -		} else if (c->bandwidth_hz <= 8000000) {
> -			/* IF 4570000 Hz, BW 8000000 Hz */
> -			memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
> -			bw_val2 = 0x00;
> -		} else {
> -			ret = -EINVAL;
> -			goto err;
> -		}
> -		break;
> -	case SYS_DVBC_ANNEX_A:
> -		/* IF 5070000 Hz, BW 8000000 Hz */
> +	if (c->bandwidth_hz <= 5000000) {
> +		memcpy(bw_val, "\xe5\x99\x9a\x1b\xa9\x1b\xa9", 7);
> +		bw_val2 = 0x03;
> +	} else if (c->bandwidth_hz <= 6000000) {
> +		/* IF 3570000 Hz, BW 6000000 Hz */
> +		memcpy(bw_val, "\xbf\x55\x55\x15\x6b\x15\x6b", 7);
> +		bw_val2 = 0x02;
> +	} else if (c->bandwidth_hz <= 7000000) {
> +		/* IF 4570000 Hz, BW 7000000 Hz */
> +		memcpy(bw_val, "\xa4\x00\x00\x0f\x2c\x0f\x2c", 7);
> +		bw_val2 = 0x01;
> +	} else if (c->bandwidth_hz <= 8000000) {
> +		/* IF 4570000 Hz, BW 8000000 Hz */
>   		memcpy(bw_val, "\x8f\x80\x00\x08\xee\x08\xee", 7);
>   		bw_val2 = 0x00;
> -		break;
> -	default:
> +	} else {
>   		ret = -EINVAL;
>   		goto err;
>   	}
>

-- 
http://palosaari.fi/
