Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34925 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2JCJcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 05:32:21 -0400
Message-ID: <506C060D.1020600@iki.fi>
Date: Wed, 03 Oct 2012 12:31:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] af9033: prevent unintended underflow
References: <201210031125.40850.hfvogt@gmx.net>
In-Reply-To: <201210031125.40850.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/2012 12:25 PM, Hans-Frieder Vogt wrote:
> As spotted by Dan Carpenter <dan.carpenter@oracle.com> (thanks!), we have
> improperly used an unsigned variable in a calculation that may result in a
> negative number. This may cause an unintended underflow if the interface
> frequency of the tuner is > approx. 40MHz.
> This patch should resolve the issue, following an approach similar to what is
> used in af9013.c.
>
> Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

Acked-by: Antti Palosaari <crope@iki.fi>

I will PULL-request that via my tree for 3.7. I don't see any reason 
this should go older ones.

regards
Antti


>
>   drivers/media/dvb-frontends/af9033.c |   16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
>
> --- a/drivers/media/dvb-frontends/af9033.c	2012-09-28 05:45:17.000000000 +0200
> +++ b/drivers/media/dvb-frontends/af9033.c	2012-10-03 11:08:18.160894181 +0200
> @@ -408,7 +408,7 @@ static int af9033_set_frontend(struct dv
>   {
>   	struct af9033_state *state = fe->demodulator_priv;
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	int ret, i, spec_inv;
> +	int ret, i, spec_inv, sampling_freq;
>   	u8 tmp, buf[3], bandwidth_reg_val;
>   	u32 if_frequency, freq_cw, adc_freq;
>
> @@ -465,18 +465,20 @@ static int af9033_set_frontend(struct dv
>   		else
>   			if_frequency = 0;
>
> -		while (if_frequency > (adc_freq / 2))
> -			if_frequency -= adc_freq;
> +		sampling_freq = if_frequency;
>
> -		if (if_frequency >= 0)
> +		while (sampling_freq > (adc_freq / 2))
> +			sampling_freq -= adc_freq;
> +
> +		if (sampling_freq >= 0)
>   			spec_inv *= -1;
>   		else
> -			if_frequency *= -1;
> +			sampling_freq *= -1;
>
> -		freq_cw = af9033_div(state, if_frequency, adc_freq, 23ul);
> +		freq_cw = af9033_div(state, sampling_freq, adc_freq, 23ul);
>
>   		if (spec_inv == -1)
> -			freq_cw *= -1;
> +			freq_cw = 0x800000 - freq_cw;
>
>   		/* get adc multiplies */
>   		ret = af9033_rd_reg(state, 0x800045, &tmp);
>
> Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
