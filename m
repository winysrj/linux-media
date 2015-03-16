Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45925 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524AbbCPVak (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:30:40 -0400
Message-ID: <55074B7C.4030502@iki.fi>
Date: Mon, 16 Mar 2015 23:30:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 05/10] mn88472: implement lock for all delivery systems
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-5-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-5-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> The increase of the lock timeout is needed for dvb-t2.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Applied!

regards
Antti

> ---
>   drivers/staging/media/mn88472/mn88472.c | 24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 6eebe56..5070c37 100644
> --- a/drivers/staging/media/mn88472/mn88472.c
> +++ b/drivers/staging/media/mn88472/mn88472.c
> @@ -19,7 +19,7 @@
>   static int mn88472_get_tune_settings(struct dvb_frontend *fe,
>   	struct dvb_frontend_tune_settings *s)
>   {
> -	s->min_delay_ms = 400;
> +	s->min_delay_ms = 800;
>   	return 0;
>   }
>
> @@ -201,6 +201,7 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>   	int ret;
>   	unsigned int utmp;
> +	int lock = 0;
>
>   	*status = 0;
>
> @@ -211,21 +212,36 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
>
>   	switch (c->delivery_system) {
>   	case SYS_DVBT:
> +		ret = regmap_read(dev->regmap[0], 0x7F, &utmp);
> +		if (ret)
> +			goto err;
> +		if ((utmp & 0xF) >= 0x09)
> +			lock = 1;
> +		break;
>   	case SYS_DVBT2:
> -		/* FIXME: implement me */
> -		utmp = 0x08; /* DVB-C lock value */
> +		ret = regmap_read(dev->regmap[2], 0x92, &utmp);
> +		if (ret)
> +			goto err;
> +		if ((utmp & 0xF) >= 0x07)
> +			*status |= FE_HAS_SIGNAL;
> +		if ((utmp & 0xF) >= 0x0a)
> +			*status |= FE_HAS_CARRIER;
> +		if ((utmp & 0xF) >= 0x0d)
> +			*status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
>   		break;
>   	case SYS_DVBC_ANNEX_A:
>   		ret = regmap_read(dev->regmap[1], 0x84, &utmp);
>   		if (ret)
>   			goto err;
> +		if ((utmp & 0xF) >= 0x08)
> +			lock = 1;
>   		break;
>   	default:
>   		ret = -EINVAL;
>   		goto err;
>   	}
>
> -	if (utmp == 0x08)
> +	if (lock)
>   		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
>   				FE_HAS_SYNC | FE_HAS_LOCK;
>
>

-- 
http://palosaari.fi/
