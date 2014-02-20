Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3010 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBTKYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 05:24:47 -0500
Message-ID: <5305D7D5.8080906@xs4all.nl>
Date: Thu, 20 Feb 2014 11:24:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] stv090x: remove indent levels
References: <20140206092800.GB31780@elgon.mountain>
In-Reply-To: <20140206092800.GB31780@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

This can be improved even more:

On 02/06/14 10:28, Dan Carpenter wrote:
> 1) We can flip the "if (!lock)" check to "if (lock) return lock;" and
>    then remove a big chunk of indenting.
> 2) There is a redundant "if (!lock)" which we can remove since we
>    already know that lock is zero.  This removes another indent level.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
> index 23e872f84742..76ee559577dd 100644
> --- a/drivers/media/dvb-frontends/stv090x.c
> +++ b/drivers/media/dvb-frontends/stv090x.c
> @@ -2146,7 +2146,7 @@ static int stv090x_get_coldlock(struct stv090x_state *state, s32 timeout_dmd)
>  
>  	u32 reg;
>  	s32 car_step, steps, cur_step, dir, freq, timeout_lock;
> -	int lock = 0;
> +	int lock;
>  
>  	if (state->srate >= 10000000)
>  		timeout_lock = timeout_dmd / 3;
> @@ -2154,97 +2154,96 @@ static int stv090x_get_coldlock(struct stv090x_state *state, s32 timeout_dmd)
>  		timeout_lock = timeout_dmd / 2;
>  
>  	lock = stv090x_get_dmdlock(state, timeout_lock); /* cold start wait */
> -	if (!lock) {
> -		if (state->srate >= 10000000) {
> -			if (stv090x_chk_tmg(state)) {
> -				if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
> -					goto err;
> -				if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
> -					goto err;
> -				lock = stv090x_get_dmdlock(state, timeout_dmd);
> -			} else {
> -				lock = 0;
> -			}
> +	if (lock)
> +		return lock;
> +
> +	if (state->srate >= 10000000) {
> +		if (stv090x_chk_tmg(state)) {
> +			if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
> +				goto err;
> +			if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
> +				goto err;
> +			lock = stv090x_get_dmdlock(state, timeout_dmd);

You can just return here...

>  		} else {
> -			if (state->srate <= 4000000)
> -				car_step = 1000;
> -			else if (state->srate <= 7000000)
> -				car_step = 2000;
> -			else if (state->srate <= 10000000)
> -				car_step = 3000;
> +			lock = 0;

and here. That way everything inside 'else' can be move one indent to the
left as well.

Regards,

	Hans

> +		}
> +	} else {
> +		if (state->srate <= 4000000)
> +			car_step = 1000;
> +		else if (state->srate <= 7000000)
> +			car_step = 2000;
> +		else if (state->srate <= 10000000)
> +			car_step = 3000;
> +		else
> +			car_step = 5000;
> +
> +		steps  = (state->search_range / 1000) / car_step;
> +		steps /= 2;
> +		steps  = 2 * (steps + 1);
> +		if (steps < 0)
> +			steps = 2;
> +		else if (steps > 12)
> +			steps = 12;
> +
> +		cur_step = 1;
> +		dir = 1;
> +
> +		freq = state->frequency;
> +		state->tuner_bw = stv090x_car_width(state->srate, state->rolloff) + state->srate;
> +		while ((cur_step <= steps) && (!lock)) {
> +			if (dir > 0)
> +				freq += cur_step * car_step;
>  			else
> -				car_step = 5000;
> -
> -			steps  = (state->search_range / 1000) / car_step;
> -			steps /= 2;
> -			steps  = 2 * (steps + 1);
> -			if (steps < 0)
> -				steps = 2;
> -			else if (steps > 12)
> -				steps = 12;
> -
> -			cur_step = 1;
> -			dir = 1;
> -
> -			if (!lock) {
> -				freq = state->frequency;
> -				state->tuner_bw = stv090x_car_width(state->srate, state->rolloff) + state->srate;
> -				while ((cur_step <= steps) && (!lock)) {
> -					if (dir > 0)
> -						freq += cur_step * car_step;
> -					else
> -						freq -= cur_step * car_step;
> -
> -					/* Setup tuner */
> -					if (stv090x_i2c_gate_ctrl(state, 1) < 0)
> -						goto err;
> +				freq -= cur_step * car_step;
>  
> -					if (state->config->tuner_set_frequency) {
> -						if (state->config->tuner_set_frequency(fe, freq) < 0)
> -							goto err_gateoff;
> -					}
> +			/* Setup tuner */
> +			if (stv090x_i2c_gate_ctrl(state, 1) < 0)
> +				goto err;
>  
> -					if (state->config->tuner_set_bandwidth) {
> -						if (state->config->tuner_set_bandwidth(fe, state->tuner_bw) < 0)
> -							goto err_gateoff;
> -					}
> +			if (state->config->tuner_set_frequency) {
> +				if (state->config->tuner_set_frequency(fe, freq) < 0)
> +					goto err_gateoff;
> +			}
>  
> -					if (stv090x_i2c_gate_ctrl(state, 0) < 0)
> -						goto err;
> +			if (state->config->tuner_set_bandwidth) {
> +				if (state->config->tuner_set_bandwidth(fe, state->tuner_bw) < 0)
> +					goto err_gateoff;
> +			}
>  
> -					msleep(50);
> +			if (stv090x_i2c_gate_ctrl(state, 0) < 0)
> +				goto err;
>  
> -					if (stv090x_i2c_gate_ctrl(state, 1) < 0)
> -						goto err;
> +			msleep(50);
>  
> -					if (state->config->tuner_get_status) {
> -						if (state->config->tuner_get_status(fe, &reg) < 0)
> -							goto err_gateoff;
> -					}
> +			if (stv090x_i2c_gate_ctrl(state, 1) < 0)
> +				goto err;
>  
> -					if (reg)
> -						dprintk(FE_DEBUG, 1, "Tuner phase locked");
> -					else
> -						dprintk(FE_DEBUG, 1, "Tuner unlocked");
> +			if (state->config->tuner_get_status) {
> +				if (state->config->tuner_get_status(fe, &reg) < 0)
> +					goto err_gateoff;
> +			}
>  
> -					if (stv090x_i2c_gate_ctrl(state, 0) < 0)
> -						goto err;
> +			if (reg)
> +				dprintk(FE_DEBUG, 1, "Tuner phase locked");
> +			else
> +				dprintk(FE_DEBUG, 1, "Tuner unlocked");
>  
> -					STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1c);
> -					if (STV090x_WRITE_DEMOD(state, CFRINIT1, 0x00) < 0)
> -						goto err;
> -					if (STV090x_WRITE_DEMOD(state, CFRINIT0, 0x00) < 0)
> -						goto err;
> -					if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
> -						goto err;
> -					if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
> -						goto err;
> -					lock = stv090x_get_dmdlock(state, (timeout_dmd / 3));
> +			if (stv090x_i2c_gate_ctrl(state, 0) < 0)
> +				goto err;
>  
> -					dir *= -1;
> -					cur_step++;
> -				}
> -			}
> +			STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1c);
> +			if (STV090x_WRITE_DEMOD(state, CFRINIT1, 0x00) < 0)
> +				goto err;
> +			if (STV090x_WRITE_DEMOD(state, CFRINIT0, 0x00) < 0)
> +				goto err;
> +			if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
> +				goto err;
> +			if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
> +				goto err;
> +			lock = stv090x_get_dmdlock(state, (timeout_dmd / 3));
> +
> +			dir *= -1;
> +			cur_step++;
>  		}
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

