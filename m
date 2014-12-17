Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39610 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaLQEIG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 23:08:06 -0500
Message-ID: <5491019E.8060805@iki.fi>
Date: Wed, 17 Dec 2014 06:07:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] mn88472: implement lock for all delivery systems
References: <1418775366-9743-1-git-send-email-benjamin@southpole.se>
In-Reply-To: <1418775366-9743-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/17/2014 02:16 AM, Benjamin Larsson wrote:
> The increase of the lock timeout is needed for dvb-t2.
>
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Reviewed-by: Antti Palosaari <crope@iki.fi>



> ---
>   drivers/staging/media/mn88472/mn88472.c | 24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
> index 68f5036..4ddeb09 100644
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
> @@ -238,6 +238,7 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>   	int ret;
>   	unsigned int utmp;
> +	int lock = 0;
>
>   	*status = 0;
>
> @@ -248,21 +249,36 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
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
