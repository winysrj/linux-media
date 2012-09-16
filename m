Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59797 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2IPAFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 20:05:42 -0400
Message-ID: <505517C0.3020905@iki.fi>
Date: Sun, 16 Sep 2012 03:05:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH 2/4] dvb_frontend: add routine for DVB-T2 parameter validation
References: <1345169022-10221-1-git-send-email-crope@iki.fi> <1345169022-10221-3-git-send-email-crope@iki.fi> <504F91FB.20309@redhat.com>
In-Reply-To: <504F91FB.20309@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2012 10:33 PM, Mauro Carvalho Chehab wrote:
> Em 16-08-2012 23:03, Antti Palosaari escreveu:
>> Common routine for use of dvb-core, demodulator and tuner for check
>> given DVB-T2 parameters correctness.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-core/dvb_frontend.c | 118 ++++++++++++++++++++++++++++++++++
>>   drivers/media/dvb-core/dvb_frontend.h |   1 +
>>   2 files changed, 119 insertions(+)
>>
>> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
>> index 4abb648..6413c74 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb-core/dvb_frontend.c
>> @@ -2641,6 +2641,124 @@ int dvb_validate_params_dvbt(struct dvb_frontend *fe)
>>   }
>>   EXPORT_SYMBOL(dvb_validate_params_dvbt);
>>
>> +int dvb_validate_params_dvbt2(struct dvb_frontend *fe)
>> +{
>> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>> +
>> +	dev_dbg(fe->dvb->device, "%s:\n", __func__);
>> +
>> +	switch (c->delivery_system) {
>> +	case SYS_DVBT2:
>> +		break;
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: delivery_system=%d\n", __func__,
>> +				c->delivery_system);
>> +		return -EINVAL;
>> +	}
>
> Same comments made on patch 1/4 apply here.
>
>> +
>> +	/*
>> +	 * DVB-T2 specification as such does not specify any frequency bands.
>> +	 * Define real life limits still. L-Band 1452 - 1492 MHz may exits in
>> +	 * future too.
>> +	 */
>> +	if (c->frequency >= 174000000 && c->frequency <= 230000000) {
>> +		;
>> +	} else if (c->frequency >= 470000000 && c->frequency <= 862000000) {
>> +		;
>> +	} else {
>> +		dev_dbg(fe->dvb->device, "%s: frequency=%d\n", __func__,
>> +				c->frequency);
>> +		return -EINVAL;
>> +	}
>
> Same comments made on patch 1/4 apply here.

Maybe it is then better to move these limits totally for the 
responsibility of RF-tuner driver and use limits tuner really can do.

Personally I still like more to see real limits... But those limits are 
still changing over the time when ITU radio conference makes new 
allocations.

For example here in Finland upper channels from UHF DVB-T band are 
already taken for LTE, one year ago or so. IIRC it is not officially yet 
allocated for LTE as thereis transition period ongoing worldwide. But we 
need so badly fast wireless internet connections for rural areas that it 
was taken in use early, and even not used near Russian border as they 
are still using those channels for TV.

>> +	switch (c->bandwidth_hz) {
>> +	case  6000000:
>> +	case  7000000:
>> +	case  8000000:
>> +	case  1700000:
>> +	case  5000000:
>> +	case 10000000:
>> +		break;
>
> 0 is also valid. Also, better to sort the entries here.
>
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: bandwidth_hz=%d\n", __func__,
>> +				c->bandwidth_hz);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * Valid Physical Layer Pipe (PLP) values are 0 - 255
>> +	 */
>> +	if (c->dvbt2_plp_id <= 255) {
>> +		;
>> +	} else {
>> +		dev_dbg(fe->dvb->device, "%s: dvbt2_plp_id=%d\n", __func__,
>> +				c->dvbt2_plp_id);
>> +		return -EINVAL;
>> +	}
>
> Is it possible to disable it for DVB-T2? If so, a new value
> is needed here (~0), according with our discussions related to
> multistream patches.

Have to check, but I think so.

IIRC there was also some other errors in current DVB-T2 API. Smallest 
nominal bw was defined wrong and also hierarchy. Hierarchy is used for 
DVB-T, for DVB-T2 it is replaced with PLP.

>> +	switch (c->transmission_mode) {
>> +	case TRANSMISSION_MODE_AUTO:
>> +	case TRANSMISSION_MODE_2K:
>> +	case TRANSMISSION_MODE_8K:
>> +	case TRANSMISSION_MODE_1K:
>> +	case TRANSMISSION_MODE_4K:
>> +	case TRANSMISSION_MODE_16K:
>> +	case TRANSMISSION_MODE_32K:
>> +		break;
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: transmission_mode=%d\n", __func__,
>> +				c->transmission_mode);
>> +		return -EINVAL;
>> +	}
>> +
>> +	switch (c->modulation) {
>> +	case QAM_AUTO:
>> +	case QPSK:
>> +	case QAM_16:
>> +	case QAM_64:
>> +	case QAM_256:
>> +		break;
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: modulation=%d\n", __func__,
>> +				c->modulation);
>> +		return -EINVAL;
>> +	}
>> +
>> +	switch (c->guard_interval) {
>> +	case GUARD_INTERVAL_AUTO:
>> +	case GUARD_INTERVAL_1_32:
>> +	case GUARD_INTERVAL_1_16:
>> +	case GUARD_INTERVAL_1_8:
>> +	case GUARD_INTERVAL_1_4:
>> +	case GUARD_INTERVAL_1_128:
>> +	case GUARD_INTERVAL_19_128:
>> +	case GUARD_INTERVAL_19_256:
>> +		break;
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: guard_interval=%d\n", __func__,
>> +				c->guard_interval);
>> +		return -EINVAL;
>> +	}
>> +
>> +	switch (c->fec_inner) {
>> +	case FEC_AUTO:
>> +	case FEC_1_2:
>> +	case FEC_3_5:
>> +	case FEC_2_3:
>> +	case FEC_3_4:
>> +	case FEC_4_5:
>> +	case FEC_5_6:
>> +		break;
>> +	default:
>> +		dev_dbg(fe->dvb->device, "%s: fec_inner=%d\n", __func__,
>> +				c->fec_inner);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(dvb_validate_params_dvbt2);
>
> Same comments made on patch 1/4 apply here.
>
>> +
>>   int dvb_register_frontend(struct dvb_adapter* dvb,
>>   			  struct dvb_frontend* fe)
>>   {
>> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
>> index 6df0c44..bcd572d 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.h
>> +++ b/drivers/media/dvb-core/dvb_frontend.h
>> @@ -426,5 +426,6 @@ extern void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec);
>>   extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
>>
>>   extern int dvb_validate_params_dvbt(struct dvb_frontend *fe);
>> +extern int dvb_validate_params_dvbt2(struct dvb_frontend *fe);
>>
>>   #endif
>>
>


-- 
http://palosaari.fi/
