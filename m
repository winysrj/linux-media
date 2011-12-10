Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1LJMu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 07:50:58 -0500
Message-ID: <4EE355AF.8090302@redhat.com>
Date: Sat, 10 Dec 2011 10:50:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 08/10] TDA18271c2dd: Allow frontend to set DELSYS
References: <CAHFNz9Jbu-Kb8+s5DmEX8NOP6K8yjwNXYucUqmUEH_LcQAvpGA@mail.gmail.com>
In-Reply-To: <CAHFNz9Jbu-Kb8+s5DmEX8NOP6K8yjwNXYucUqmUEH_LcQAvpGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 02:44, Manu Abraham wrote:
> From 707877f5a61b3259704d42e7dd5e647e9196e9a4 Mon Sep 17 00:00:00 2001
> From: Manu Abraham <abraham.manu@gmail.com>
> Date: Thu, 24 Nov 2011 19:56:34 +0530
> Subject: [PATCH 08/10] TDA18271c2dd: Allow frontend to set DELSYS, rather than querying fe->ops.info.type
>
> With any tuner that can tune to multiple delivery systems/standards, it does
> query fe->ops.info.type to determine frontend type and set the delivery
> system type. fe->ops.info.type can handle only 4 delivery systems, viz FE_QPSK,
> FE_QAM, FE_OFDM and FE_ATSC.
>
> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
> ---
>  drivers/media/dvb/frontends/tda18271c2dd.c |   42 ++++++++++++++++++++--------
>  1 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
> index 1b1bf20..43a3dd4 100644
> --- a/drivers/media/dvb/frontends/tda18271c2dd.c
> +++ b/drivers/media/dvb/frontends/tda18271c2dd.c
> @@ -1145,28 +1145,46 @@ static int set_params(struct dvb_frontend *fe,
>  	int status = 0;
>  	int Standard;
>
> -	state->m_Frequency = params->frequency;
> +	u32 bw;
> +	fe_delivery_system_t delsys;
>
> -	if (fe->ops.info.type == FE_OFDM)
> -		switch (params->u.ofdm.bandwidth) {
> -		case BANDWIDTH_6_MHZ:
> +	delsys	= fe->dtv_property_cache.delivery_system;
> +	bw	= fe->dtv_property_cache.bandwidth_hz;
> +
> +	state->m_Frequency = fe->dtv_property_cache.frequency;
> +
> +	if (!delsys || !state->m_Frequency) {
> +		printk(KERN_ERR "Invalid delsys:%d freq:%d\n", delsys, state->m_Frequency);
> +		return -EINVAL;
> +	}
> +
> +	switch (delsys) {
> +	case SYS_DVBT:
> +	case SYS_DVBT2:
> +		if (!bw)
> +			return -EINVAL;
> +		switch (bw) {
> +		case 6000000:
>  			Standard = HF_DVBT_6MHZ;
>  			break;
> -		case BANDWIDTH_7_MHZ:
> +		case 7000000:
>  			Standard = HF_DVBT_7MHZ;
>  			break;
>  		default:
> -		case BANDWIDTH_8_MHZ:
> +		case 8000000:
>  			Standard = HF_DVBT_8MHZ;
>  			break;
>  		}
> -	else if (fe->ops.info.type == FE_QAM) {
> -		if (params->u.qam.symbol_rate <= MAX_SYMBOL_RATE_6MHz)
> -			Standard = HF_DVBC_6MHZ;
> -		else
> -			Standard = HF_DVBC_8MHZ;
> -	} else
> +		break;
> +	case SYS_DVBC_ANNEX_A:
> +		Standard = HF_DVBC_6MHZ;
> +		break;
> +	case SYS_DVBC_ANNEX_C:
> +		Standard = HF_DVBC_8MHZ;
> +		break;

No, this is wrong. This patch doesn't apply anymore, due to the recent
changes that estimate the bandwidth based on the roll-off factor. Reverting
it breaks for DVB-C @ 6MHz spaced channels (and likely decreases quality
or breaks for 7MHz spaced ones too).

> +	default:
>  		return -EINVAL;
> +	}
>  	do {
>  		status = RFTrackingFiltersCorrection(state, params->frequency);
>  		if (status < 0)
> --
> 1.7.1
>
