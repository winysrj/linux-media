Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1KYABO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 19:01:14 -0500
Message-ID: <4ECEDAC0.7090403@redhat.com>
Date: Thu, 24 Nov 2011 22:01:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andreas Oberritter <obi@linuxtv.org>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: PATCH 05/13: 0005-TDA18271c2dd-Allow-frontend-to-set-DELSYS
References: <CAHFNz9+JkusvQ=_gazEGDqgBpCrua0088Rh7bhcUdkn53PEAeg@mail.gmail.com>
In-Reply-To: <CAHFNz9+JkusvQ=_gazEGDqgBpCrua0088Rh7bhcUdkn53PEAeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-11-2011 19:06, Manu Abraham escreveu:
> patches/lmml_8518_patch_05_13_0005_tda18271c2dd_allow_frontend_to_set_delsys.patch
> Content-Type: text/plain; charset="utf-8"
> MIME-Version: 1.0
> Content-Transfer-Encoding: 7bit
> Subject: PATCH 05/13: 0005-TDA18271c2dd-Allow-frontend-to-set-DELSYS
> Date: Mon, 21 Nov 2011 20:06:48 -0000
> From: Manu Abraham <abraham.manu@gmail.com>
> X-Patchwork-Id: 8518
> Message-Id: <CAHFNz9+JkusvQ=_gazEGDqgBpCrua0088Rh7bhcUdkn53PEAeg@mail.gmail.com>
> To: Linux Media Mailing List <linux-media@vger.kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
> 	Andreas Oberritter <obi@linuxtv.org>, Ralph Metzler <rjkm@metzlerbros.de>
> 
> 
> 
> 
> >From 73c0b7c386beae392cff568e08914582ed6329d1 Mon Sep 17 00:00:00 2001
> From: Manu Abraham <abraham.manu@gmail.com>
> Date: Sat, 19 Nov 2011 21:01:03 +0530
> Subject: [PATCH 05/13] TDA18271c2dd: Allow frontend to set DELSYS, rather than querying fe->ops.info.type
> 
> With any tuner that can tune to multiple delivery systems/standards, it does
> query fe->ops.info.type to determine frontend type and set the delivery
> system type. fe->ops.info.type can handle only 4 delivery systems, viz FE_QPSK,
> FE_QAM, FE_OFDM and FE_ATSC.
> 
> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
> ---
>  drivers/media/dvb/frontends/tda18271c2dd.c |   56 ++++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
> index 1b1bf20..6077674 100644
> --- a/drivers/media/dvb/frontends/tda18271c2dd.c
> +++ b/drivers/media/dvb/frontends/tda18271c2dd.c
> @@ -1180,6 +1180,61 @@ static int set_params(struct dvb_frontend *fe,
>  	return status;
>  }
>  
> +static int set_state(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *tuner)
> +{
> +	struct tda_state *state = fe->tuner_priv;
> +	fe_delivery_system_t delsys = SYS_UNDEFINED;
> +	u32 bandwidth = 0;
> +	int status = 0;
> +	int Standard = 0;
> +
> +	if (param & DVBFE_TUNER_DELSYS)
> +		delsys = tuner->delsys;
> +	if (param & DVBFE_TUNER_FREQUENCY)
> +		state->m_Frequency = tuner->frequency;
> +	if (param & DVBFE_TUNER_BANDWIDTH)
> +		bandwidth = tuner->bandwidth;
> +
> +	switch (delsys) {
> +	case SYS_DVBT:
> +		switch (bandwidth) {
> +		case 6000000:
> +			Standard = HF_DVBT_6MHZ;
> +			break;
> +		case 7000000:
> +			Standard = HF_DVBT_7MHZ;
> +			break;
> +		case 8000000:
> +			Standard = HF_DVBT_8MHZ;
> +			break;
> +		}
> +		break;
> +	case SYS_DVBC_ANNEX_AC:
> +		/*
> +		 * FIXME! API BUG! DVB-C ANNEX A & C are different
> +		 * This should have been simply DVBC_ANNEX_A
> +		 */
> +		Standard = HF_DVBC_6MHZ;

API inconsistency were fixed by those two patches:
	http://patchwork.linuxtv.org/patch/8501/
	http://patchwork.linuxtv.org/patch/8503/

As I've commented on patch 4/13, bandwidth is not constant. It should be calculated
based on roll-off and signal rate.

> +		break;
> +	default:
> +		status = -EINVAL;
> +		goto err;
> +	}
> +
> +	do {
> +		status = RFTrackingFiltersCorrection(state, state->m_Frequency);
> +		if (status < 0)
> +			break;
> +		status = ChannelConfiguration(state, state->m_Frequency, Standard);
> +		if (status < 0)
> +			break;
> +
> +		msleep(state->m_SettlingTime);  /* Allow AGC's to settle down */
> +	} while (0);
> +err:
> +	return status;
> +}
> +
>  #if 0
>  static int GetSignalStrength(s32 *pSignalStrength, u32 RFAgc, u32 IFAgc)
>  {
> @@ -1221,6 +1276,7 @@ static struct dvb_tuner_ops tuner_ops = {
>  	.init              = init,
>  	.sleep             = sleep,
>  	.set_params        = set_params,
> +	.set_state	   = set_state,
>  	.release           = release,
>  	.get_if_frequency  = get_if_frequency,
>  	.get_bandwidth     = get_bandwidth,
> -- 
> 1.7.1
> 
