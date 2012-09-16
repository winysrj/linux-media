Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35351 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2IPAOu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 20:14:50 -0400
Message-ID: <505519E5.7050909@iki.fi>
Date: Sun, 16 Sep 2012 03:14:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH 3/4] dvb_frontend: add routine for DVB-C annex A parameter
 validation
References: <1345169022-10221-1-git-send-email-crope@iki.fi> <1345169022-10221-4-git-send-email-crope@iki.fi> <504F93BE.6020100@redhat.com>
In-Reply-To: <504F93BE.6020100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2012 10:40 PM, Mauro Carvalho Chehab wrote:
> Em 16-08-2012 23:03, Antti Palosaari escreveu:
>> Common routine for use of dvb-core, demodulator and tuner for check
>> given DVB-C annex A parameters correctness.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>
> I won't repeat myself on the stuff I commented on patch 1/4.
>
>> ---
>>   drivers/media/dvb-core/dvb_frontend.c | 54 +++++++++++++++++++++++++++++++++++
>>   drivers/media/dvb-core/dvb_frontend.h |  1 +
>>   2 files changed, 55 insertions(+)
>>
>> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
>> index 6413c74..6a19c87 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb-core/dvb_frontend.c
>> @@ -2759,6 +2759,60 @@ int dvb_validate_params_dvbt2(struct dvb_frontend *fe)
>>   }
>>   EXPORT_SYMBOL(dvb_validate_params_dvbt2);
>>
>> +int dvb_validate_params_dvbc_annex_a(struct dvb_frontend *fe)
>> +{
>> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>> +
>> +	dev_dbg(fe->dvb->device, "%s:\n", __func__);
>> +
>> +	switch (c->delivery_system) {
>> +	case SYS_DVBC_ANNEX_A:
>> +		break;
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: delivery_system=%d\n", __func__,
>> +				c->delivery_system);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * TODO: NorDig Unified 2.2 specifies input frequency range
>> +	 * 110 - 862 MHz. Do not limit it now as w_scan seems to start from
>> +	 * 73 MHz until reason is clear.
>> +	 */
>> +	if (c->frequency >= 0 && c->frequency <= 862000000) {
>> +		;
>> +	} else {
>> +		dev_dbg(fe->dvb->device, "%s: frequency=%d\n", __func__,
>> +				c->frequency);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (c->symbol_rate >= 1000000 && c->symbol_rate <= 7000000) {
>> +		;
>> +	} else {
>> +		dev_dbg(fe->dvb->device, "%s: symbol_rate=%d\n", __func__,
>> +				c->symbol_rate);
>> +		return -EINVAL;
>> +	}
>
> Hmm... Not sure if it is a good idea to limit the symbol rate for DVB-C
> (especially the upper range), as some cable operators could be doing weird
> things. This should be hardware-dependent, instead. Btw, the DVB core already
> check those limits:
>
> 	case SYS_DVBC_ANNEX_A:
> 	case SYS_DVBC_ANNEX_C:
> 		if ((fe->ops.info.symbol_rate_min &&
> 		     c->symbol_rate < fe->ops.info.symbol_rate_min) ||
> 		    (fe->ops.info.symbol_rate_max &&
> 		     c->symbol_rate > fe->ops.info.symbol_rate_max)) {
> 			dev_warn(fe->dvb->device, "DVB: adapter %i frontend %i symbol rate %u out of range (%u..%u)\n",
> 					fe->dvb->num, fe->id, c->symbol_rate,
> 					fe->ops.info.symbol_rate_min,
> 					fe->ops.info.symbol_rate_max);
> 			return -EINVAL;
> 		}
>

The aim for these checks were to check correctness very general level. I 
found symbol rate to be very challenging thus so relaxed checks. Nothing 
prevents driver to do better checks. Maximum symbol rate used here is 
more than theoretical maximum for nominal 8MHz radio channel used. But 
again, like for DVB-T corner cases, someone could use wider radio 
channel in lab :) In real life I quite sure 8 MHz is maximum used.

In real life there is still quite only few possible values used.

> Btw, DVB-C annex A and C are very similar. From hardware PoV, the only difference
> I'm aware of is at the saw filter. So, the same checks can be applied for
> both types. Well, it can be a little more rigid for modulation, on Annex C,
> but we need some support for someone at Japan, in order to be sure that
> they're using just one type of QAM there.
>
>> +
>> +	switch (c->modulation) {
>> +	case QAM_AUTO:
>> +	case QAM_16:
>> +	case QAM_32:
>> +	case QAM_64:
>> +	case QAM_128:
>> +	case QAM_256:
>> +		break;
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: modulation=%d\n", __func__,
>> +				c->modulation);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(dvb_validate_params_dvbc_annex_a);
>> +
>>   int dvb_register_frontend(struct dvb_adapter* dvb,
>>   			  struct dvb_frontend* fe)
>>   {
>> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
>> index bcd572d..e6e6fe1 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.h
>> +++ b/drivers/media/dvb-core/dvb_frontend.h
>> @@ -427,5 +427,6 @@ extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
>>
>>   extern int dvb_validate_params_dvbt(struct dvb_frontend *fe);
>>   extern int dvb_validate_params_dvbt2(struct dvb_frontend *fe);
>> +extern int dvb_validate_params_dvbc_annex_a(struct dvb_frontend *fe);
>>
>>   #endif
>>
>


-- 
http://palosaari.fi/
