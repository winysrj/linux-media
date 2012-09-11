Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758767Ab2IKTXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 15:23:44 -0400
Message-ID: <504F8FAF.1010104@redhat.com>
Date: Tue, 11 Sep 2012 16:23:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH 1/4] dvb_frontend: add routine for DVB-T parameter validation
References: <1345169022-10221-1-git-send-email-crope@iki.fi> <1345169022-10221-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345169022-10221-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-08-2012 23:03, Antti Palosaari escreveu:
> Common routine for use of dvb-core, demodulator and tuner for check
> given DVB-T parameters correctness.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 136 ++++++++++++++++++++++++++++++++++
>  drivers/media/dvb-core/dvb_frontend.h |   2 +
>  2 files changed, 138 insertions(+)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index d29d41a..4abb648 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2505,6 +2505,142 @@ int dvb_frontend_resume(struct dvb_frontend *fe)
>  }
>  EXPORT_SYMBOL(dvb_frontend_resume);
>  
> +int dvb_validate_params_dvbt(struct dvb_frontend *fe)
> +{
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +
> +	dev_dbg(fe->dvb->device, "%s:\n", __func__);
> +
> +	switch (c->delivery_system) {
> +	case SYS_DVBT:
> +		break;
> +	default:
> +		dev_dbg(fe->dvb->device, "%s: delivery_system=%d\n", __func__,
> +				c->delivery_system);
> +		return -EINVAL;
> +	}

Why do you need to check if the system is DVB-T here? The routine name 
is only for DVB-T! It should either be a generic routine for all standards,
or not having such checks, otherwise, it will end by checking if the 
delivery system is DVB-T on multiple places.

IMO, a dvb_validate_params() call that checks for all types is better.

Not sure if you have seen, but there is already something like that at
the dvb_frontend.c: dvb_frontend_check_parameters(). So, please let's not
reinvent the wheel.

> +
> +	if (c->frequency >= 174000000 && c->frequency <= 230000000) {
> +		;
> +	} else if (c->frequency >= 470000000 && c->frequency <= 862000000) {
> +		;
> +	} else {
> +		dev_dbg(fe->dvb->device, "%s: frequency=%d\n", __func__,
> +				c->frequency);
> +		return -EINVAL;
> +	}

Hmm... dvb_frontend_check_parameters() already checks for the min and max
frequencies, based on tuner/demod capabilities.

Also, I don't see any reason why the range between 230 MHz and 470 MHz should 
explicitly excluded here. Are you sure that there aren't any Country somewhere 
that might be using part of this range for TV? AFAIKT, most tuners will support 
this range anyway, so enforcing drivers to not use them without any really good 
reason doesn't make much sense.

> +
> +	switch (c->bandwidth_hz) {
> +	case 6000000:
> +	case 7000000:
> +	case 8000000:
> +		break;
> +	default:
> +		dev_dbg(fe->dvb->device, "%s: bandwidth_hz=%d\n", __func__,
> +				c->bandwidth_hz);
> +		return -EINVAL;
> +	}

Hmm... 0 is a valid value (it means AUTO, as documented at the DVB API spec).

Also, 5 MHz is also a valid value for DVB-T (see Annex G of EN 300.744 v 1.6.1).
I don't doubt you'll find some places with 5MHz on DVB-T outside Europe.

> +
> +	switch (c->transmission_mode) {
> +	case TRANSMISSION_MODE_AUTO:
> +	case TRANSMISSION_MODE_2K:
> +	case TRANSMISSION_MODE_8K:
> +		break;

DVB-T specs also allow 4K for 5 MHz bandwidth. 

> +	default:
> +		dev_dbg(fe->dvb->device, "%s: transmission_mode=%d\n", __func__,
> +				c->transmission_mode);
> +		return -EINVAL;
> +	}
> +
> +	switch (c->modulation) {
> +	case QAM_AUTO:
> +	case QPSK:
> +	case QAM_16:
> +	case QAM_64:
> +		break;
> +	default:
> +		dev_dbg(fe->dvb->device, "%s: modulation=%d\n", __func__,
> +				c->modulation);
> +		return -EINVAL;
> +	}
> +
> +	switch (c->guard_interval) {
> +	case GUARD_INTERVAL_AUTO:
> +	case GUARD_INTERVAL_1_32:
> +	case GUARD_INTERVAL_1_16:
> +	case GUARD_INTERVAL_1_8:
> +	case GUARD_INTERVAL_1_4:
> +		break;
> +	default:
> +		dev_dbg(fe->dvb->device, "%s: guard_interval=%d\n", __func__,
> +				c->guard_interval);
> +		return -EINVAL;
> +	}
> +
> +	switch (c->hierarchy) {
> +	case HIERARCHY_NONE:
> +	case HIERARCHY_AUTO:
> +	case HIERARCHY_1:
> +	case HIERARCHY_2:
> +	case HIERARCHY_4:
> +		break;
> +	default:
> +		dev_dbg(fe->dvb->device, "%s: hierarchy=%d\n", __func__,
> +				c->hierarchy);
> +		return -EINVAL;
> +	}
> +
> +	switch (c->code_rate_HP) {
> +	case FEC_AUTO:
> +	case FEC_1_2:
> +	case FEC_2_3:
> +	case FEC_3_4:
> +	case FEC_5_6:
> +	case FEC_7_8:
> +		break;
> +	default:
> +		dev_dbg(fe->dvb->device, "%s: code_rate_HP=%d\n", __func__,
> +				c->code_rate_HP);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * code_rate_LP is used only with hierarchical coding
> +	 */
> +	if (c->hierarchy == HIERARCHY_NONE) {
> +		switch (c->code_rate_LP) {
> +		case FEC_NONE:
> +		/*
> +		 * TODO: FEC_AUTO here is wrong, but for some reason
> +		 * dtv_set_frontend() forces it.
> +		 */
> +		case FEC_AUTO:
> +			break;
> +		default:
> +			dev_dbg(fe->dvb->device, "%s: code_rate_LP=%d\n",
> +					__func__, c->code_rate_LP);
> +			return -EINVAL;
> +		}
> +	} else {
> +		switch (c->code_rate_LP) {
> +		case FEC_AUTO:
> +		case FEC_1_2:
> +		case FEC_2_3:
> +		case FEC_3_4:
> +		case FEC_5_6:
> +		case FEC_7_8:
> +			break;
> +		default:
> +			dev_dbg(fe->dvb->device, "%s: code_rate_LP=%d\n",
> +					__func__, c->code_rate_LP);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(dvb_validate_params_dvbt);

Please use EXPORT_SYMBOL_GPL().

> +
>  int dvb_register_frontend(struct dvb_adapter* dvb,
>  			  struct dvb_frontend* fe)
>  {
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index 74ba563..6df0c44 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -425,4 +425,6 @@ extern int dvb_frontend_resume(struct dvb_frontend *fe);
>  extern void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec);
>  extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
>  
> +extern int dvb_validate_params_dvbt(struct dvb_frontend *fe);
> +
>  #endif
> 

