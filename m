Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60806 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1LQVy2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 16:54:28 -0500
Message-ID: <4EED0F8E.2000005@iki.fi>
Date: Sat, 17 Dec 2011 23:54:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linuxtv@stefanringel.de
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 1/3] mt2063: add get_if_frequency call
References: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1324155437-15834-1-git-send-email-linuxtv@stefanringel.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/17/2011 10:57 PM, linuxtv@stefanringel.de wrote:
> From: Stefan Ringel<linuxtv@stefanringel.de>
>
> Signed-off-by: Stefan Ringel<linuxtv@stefanringel.de>
> ---
>   drivers/media/common/tuners/mt2063.c |   24 ++++++++++++++++++------
>   1 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
> index 6743ffe..5b4b1ec 100644
> --- a/drivers/media/common/tuners/mt2063.c
> +++ b/drivers/media/common/tuners/mt2063.c
> @@ -2211,18 +2211,29 @@ static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
>   	if (!state->init)
>   		return -ENODEV;
>
> -	/*
> -	 * FIXME: This is an API abuse at DRX-K driver: in order to allow
> -	 * tda18271 to change the IF based on the standard, it uses this
> -	 * callback as "get_if_frequency".
> -	 */
> -	*freq = state->reference * 1000;
> +	*freq = state->frequency;
>
>   	dprintk(1, "frequency: %d\n", *freq);
>
>   	return 0;
>   }
>
> +static int mt2063_get_if_frequency(struct dvb_frontend *fe, u32 *freq)
> +{
> +	struct mt2063_state *state = fe->tuner_priv;
> +
> +	dprintk(2, "\n");
> +
> +	if (!state->init)
> +		return -ENODEV;
> +
> +	*freq = state->AS_Data.f_out;
> +
> +	dprintk(1, "if frequency: %d\n", *freq);
> +
> +	return 0;
> +}
> +
>   static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
>   {
>   	struct mt2063_state *state = fe->tuner_priv;
> @@ -2253,6 +2264,7 @@ static struct dvb_tuner_ops mt2063_ops = {
>   	.set_analog_params = mt2063_set_analog_params,
>   	.set_params    = mt2063_set_params,
>   	.get_frequency = mt2063_get_frequency,
> +	.get_if_frequency = mt2063_get_if_frequency,
>   	.get_bandwidth = mt2063_get_bandwidth,
>   	.release = mt2063_release,
>   };

Without looking the code itself that seems like a little bit suspicious. 
As a understand .get_frequency was abused as .get_if_frequency and you 
changed it correctly now. Anyhow, earlier is was returning IF as 
(state->reference * 1000) and now it does (state->AS_Data.f_out). Is 
that correct? And if yes, why there is two variables in state having IF ?

regards
Antti
-- 
http://palosaari.fi/
