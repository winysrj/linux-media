Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49431 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678AbbCPVrh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:47:37 -0400
Message-ID: <55074F74.2080000@iki.fi>
Date: Mon, 16 Mar 2015 23:47:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>, mchehab@osg.samsung.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/10] mn88473: implement lock for all delivery systems
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-10-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-10-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>

Applied.

Antti

> ---
>   drivers/staging/media/mn88473/mn88473.c | 50 +++++++++++++++++++++++++++++++--
>   1 file changed, 48 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
> index a23e59e..ba39614 100644
> --- a/drivers/staging/media/mn88473/mn88473.c
> +++ b/drivers/staging/media/mn88473/mn88473.c
> @@ -167,7 +167,10 @@ static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   {
>   	struct i2c_client *client = fe->demodulator_priv;
>   	struct mn88473_dev *dev = i2c_get_clientdata(client);
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>   	int ret;
> +	unsigned int utmp;
> +	int lock = 0;
>
>   	*status = 0;
>
> @@ -176,8 +179,51 @@ static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
>   		goto err;
>   	}
>
> -	*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
> -			FE_HAS_SYNC | FE_HAS_LOCK;
> +	switch (c->delivery_system) {
> +	case SYS_DVBT:
> +		ret = regmap_read(dev->regmap[0], 0x62, &utmp);
> +		if (ret)
> +			goto err;
> +		if (utmp & 0xA0) {
> +			if ((utmp & 0xF) >= 0x03)
> +				*status |= FE_HAS_SIGNAL;
> +			if ((utmp & 0xF) >= 0x09)
> +				lock = 1;
> +		}
> +		break;
> +	case SYS_DVBT2:
> +		ret = regmap_read(dev->regmap[2], 0x8B, &utmp);
> +		if (ret)
> +			goto err;
> +		if (utmp & 0x40) {
> +			if ((utmp & 0xF) >= 0x07)
> +				*status |= FE_HAS_SIGNAL;
> +			if ((utmp & 0xF) >= 0x0a)
> +				*status |= FE_HAS_CARRIER;
> +			if ((utmp & 0xF) >= 0x0d)
> +				*status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
> +		}
> +		break;
> +	case SYS_DVBC_ANNEX_A:
> +		ret = regmap_read(dev->regmap[1], 0x85, &utmp);
> +		if (ret)
> +			goto err;
> +		if (utmp & 0x40) {
> +			ret = regmap_read(dev->regmap[1], 0x89, &utmp);
> +			if (ret)
> +				goto err;
> +			if (utmp & 0x01)
> +				lock = 1;
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	if (lock)
> +		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
> +				FE_HAS_SYNC | FE_HAS_LOCK;
>
>   	return 0;
>   err:
>

-- 
http://palosaari.fi/
