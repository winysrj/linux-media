Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1KYAEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 19:04:33 -0500
Message-ID: <4ECED5D3.4060305@redhat.com>
Date: Thu, 24 Nov 2011 21:40:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: PATCH 04/13: 0004-TDA18271-Allow-frontend-to-set-DELSYS
References: <CAHFNz9+e0K__EWdc=ckHURjjYMbez22=xup0d7=H7k2xQNVnyw@mail.gmail.com> <4ECAE71B.2060700@linuxtv.org>
In-Reply-To: <4ECAE71B.2060700@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-11-2011 22:04, Andreas Oberritter escreveu:
> On 21.11.2011 22:06, Manu Abraham wrote:
>>
>> 0004-TDA18271-Allow-frontend-to-set-DELSYS-rather-than-qu.patch
>>
>>
>> From 2ece38602678ae323450d0e35379147e6e086326 Mon Sep 17 00:00:00 2001
>> From: Manu Abraham <abraham.manu@gmail.com>
>> Date: Sat, 19 Nov 2011 19:50:09 +0530
>> Subject: [PATCH 04/13] TDA18271: Allow frontend to set DELSYS, rather than querying fe->ops.info.type
>>
>> With any tuner that can tune to multiple delivery systems/standards, it does
>> query fe->ops.info.type to determine frontend type and set the delivery
>> system type. fe->ops.info.type can handle only 4 delivery systems, viz FE_QPSK,
>> FE_QAM, FE_OFDM and FE_ATSC.
>>
>> The change allows the tuner to be set to any delivery system specified in
>> fe_delivery_system_t, thereby simplifying a lot of issues.
>>
>> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
>> ---
>>  drivers/media/common/tuners/tda18271-fe.c   |   80 +++++++++++++++++++++++++++
>>  drivers/media/common/tuners/tda18271-priv.h |    2 +
>>  2 files changed, 82 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
>> index 3347c5b..6e29faf 100644
>> --- a/drivers/media/common/tuners/tda18271-fe.c
>> +++ b/drivers/media/common/tuners/tda18271-fe.c
>> @@ -928,6 +928,85 @@ fail:
>>  
>>  /* ------------------------------------------------------------------ */
>>  
>> +static int tda18271_set_state(struct dvb_frontend *fe,
>> +			      enum tuner_param param,
>> +			      struct tuner_state *state)
>> +{
>> +	struct tda18271_priv *priv = fe->tuner_priv;
>> +	struct tuner_state *req = &priv->request;
>> +	struct tda18271_std_map *std_map = &priv->std;
>> +	struct tda18271_std_map_item *map;
>> +	int ret;
>> +
>> +	BUG_ON(!priv);
> 
> At this point priv has already been dereferenced.
> 
>> +	if (param & DVBFE_TUNER_DELSYS)
>> +		req->delsys = state->delsys;
>> +	if (param & DVBFE_TUNER_FREQUENCY)
>> +		req->frequency = state->frequency;
>> +	if (param & DVBFE_TUNER_BANDWIDTH)
>> +		req->bandwidth = state->bandwidth;
> 
> What happens if one of these flags is not set, when the function is
> called for the first time? priv->request doesn't seem to get initialized.
> 
> Regards,
> Andreas
> 
>> +
>> +	priv->mode = TDA18271_DIGITAL;
>> +
>> +	switch (req->delsys) {
>> +	case SYS_ATSC:
>> +		map = &std_map->atsc_6;
>> +		req->bandwidth = 6000000;
>> +		break;
>> +	case SYS_DVBC_ANNEX_B:
>> +		map = &std_map->qam_6;
>> +		req->bandwidth = 6000000;
>> +		break;
>> +	case SYS_DVBT:
>> +	case SYS_DVBT2:
>> +		switch (req->bandwidth) {
>> +		case 6000000:
>> +			map = &std_map->dvbt_6;
>> +			break;
>> +		case 7000000:
>> +			map = &std_map->dvbt_7;
>> +			break;
>> +		case 8000000:
>> +			map = &std_map->dvbt_8;
>> +			break;
>> +		default:
>> +			ret = -EINVAL;
>> +			goto fail;
>> +		}
>> +		break;
>> +	case SYS_DVBC_ANNEX_AC:
>> +		map = &std_map->qam_8;
>> +		req->bandwidth = 8000000;
>> +		break;

This premise is not correct, and causes tuning failure on places where
channels are spaced with 6MHz.

The bandwidth should be calculated as a function of the rolloff and symbol
rate. I had to fix it on a few places, for devices to work with Net Digital
Cable operator in Brazil (6MHz spaced channels, 5.217 KBauds per carrier,
DVB-C Annex A).

The correct way for doing it is:

	else if (fe->ops.info.type == FE_QAM) {
		/*
		 * Using a higher bandwidth at the tuner filter may
		 * allow inter-carrier interference.
		 * So, determine the minimal channel spacing, in order
		 * to better adjust the tuner filter.
		 * According with ITU-T J.83, the bandwidth is given by:
		 * bw = Simbol Rate * (1 + roll_off), where the roll_off
		 * is equal to 0.15 for Annex A, and 0.13 for annex C
		 */
		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
			bw = (params->u.qam.symbol_rate * 13) / 10;
		else
			bw = (params->u.qam.symbol_rate * 15) / 10;
		if (bw <= 6000000)
			Standard = HF_DVBC_6MHZ;
		else if (bw <= 7000000)
			Standard = HF_DVBC_7MHZ;
		else
			Standard = HF_DVBC_8MHZ;

(from drivers/media/dvb/frontends/tda18271c2dd.c)

Where ROLLOFF_13 is used on Annex C, and ROLLOF_15 on Annex A.

The same fix should be applied to all DVB-C capable tuners. Alternatively, we 
should put some ancillary function at the core, and let the core estimate the 
needed bandwidth for DVB-C.

PS.: While I didn't test, I suspect that places using 7MHz-spaced channels will 
also increase the reception, as less inter-channel noise will be sent to
the demod.

>> +	default:
>> +		tda_warn("Invalid delivery system!\n");
>> +		ret = -EINVAL;
>> +		goto fail;
>> +	}
>> +	tda_dbg("Trying to tune .. delsys=%d modulation=%d frequency=%d bandwidth=%d",
>> +		req->delsys,
>> +		req->modulation,
>> +		req->frequency,
>> +		req->bandwidth);
>> +
>> +	/* When tuning digital, the analog demod must be tri-stated */
>> +	if (fe->ops.analog_ops.standby)
>> +		fe->ops.analog_ops.standby(fe);
>> +
>> +	ret = tda18271_tune(fe, map, req->frequency, req->bandwidth);
>> +
>> +	if (tda_fail(ret))
>> +		goto fail;
>> +
>> +	priv->if_freq   = map->if_freq;
>> +	priv->frequency = req->frequency;
>> +	priv->bandwidth = (req->delsys == SYS_DVBT || req->delsys == SYS_DVBT2) ?
>> +			   req->bandwidth : 0;
>> +fail:
>> +	return ret;
>> +}
>> +
>> +
>>  static int tda18271_set_params(struct dvb_frontend *fe,
>>  			       struct dvb_frontend_parameters *params)
>>  {
>> @@ -1249,6 +1328,7 @@ static const struct dvb_tuner_ops tda18271_tuner_ops = {
>>  	.init              = tda18271_init,
>>  	.sleep             = tda18271_sleep,
>>  	.set_params        = tda18271_set_params,
>> +	.set_state         = tda18271_set_state,
>>  	.set_analog_params = tda18271_set_analog_params,
>>  	.release           = tda18271_release,
>>  	.set_config        = tda18271_set_config,
>> diff --git a/drivers/media/common/tuners/tda18271-priv.h b/drivers/media/common/tuners/tda18271-priv.h
>> index 454c152..bd1bf58 100644
>> --- a/drivers/media/common/tuners/tda18271-priv.h
>> +++ b/drivers/media/common/tuners/tda18271-priv.h
>> @@ -126,6 +126,8 @@ struct tda18271_priv {
>>  
>>  	u32 frequency;
>>  	u32 bandwidth;
>> +
>> +	struct tuner_state request;
>>  };
>>  
>>  /*---------------------------------------------------------------------*/
>> -- 1.7.1
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

