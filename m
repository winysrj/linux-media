Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1L3Rgm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 12:36:42 -0500
Message-ID: <4EFDF6A3.8090200@redhat.com>
Date: Fri, 30 Dec 2011 15:36:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: e9hack <e9hack@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 00/91] Only use DVBv5 internally on frontend drivers
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <4EFB3AB8.1090608@googlemail.com> <4EFDBA77.2030006@redhat.com> <4EFDF1E4.9060703@googlemail.com>
In-Reply-To: <4EFDF1E4.9060703@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30-12-2011 15:16, e9hack wrote:
> Hi Mauro,
> 
> your patch fixes the problem for the tda10021.c and tda10023.c. The drxk_hard.c is a
> second problem. It is introduced by tda18271c2dd.c:
> 
> static int set_params(struct dvb_frontend *fe,
> 		     struct dvb_frontend_parameters *params)
> {
> 	struct tda_state *state = fe->tuner_priv;
> 	int status = 0;
> 	int Standard;
> 	u32 bw = fe->dtv_property_cache.bandwidth_hz;
> 	u32 delsys  = fe->dtv_property_cache.delivery_system;
> 
> 	state->m_Frequency = fe->dtv_property_cache.frequency;
> 
> 	switch (delsys) {
> 	case  SYS_DVBT:
> 	case  SYS_DVBT2:
> 		switch (bw) {
> 		case 6000000:
> 			Standard = HF_DVBT_6MHZ;
> 			break;
> 		case 7000000:
> 			Standard = HF_DVBT_7MHZ;
> 			break;
> 		case 8000000:
> 			Standard = HF_DVBT_8MHZ;
> 			break;
> 		default:
> 			return -EINVAL;
> 		}
> 	case SYS_DVBC_ANNEX_A:
> 	case SYS_DVBC_ANNEX_C:
> 		if (bw <= 6000000)
> 			Standard = HF_DVBC_6MHZ;
> 		else if (bw <= 7000000)
> 			Standard = HF_DVBC_7MHZ;
> 		else
> 			Standard = HF_DVBC_8MHZ;
> 	default:
> 		return -EINVAL;
> 	}
> 
> A break is missing before the default statement. Delivery systems for DVB-C result always
> in an error. It is difficult for me to find the file itself with this content in the git
> repositories. I got the file from
> http://linuxtv.org/downloads/drivers/linux-media-2011-12-25.tar.bz2.

Oh! I hate "break" statements ;) it is easy to forget one, and the
compiler doesn't warn about that.

Thanks for pointing it. I'll add a patch fixing this bug.

> 
> Regards,
> Hartmut
> 
> 
> Am 30.12.2011 14:19, schrieb Mauro Carvalho Chehab:
>> On 28-12-2011 13:50, e9hack wrote:
>>> Hi Mauro,
>>>
>>> your changset breaks the auto-inversion capability of dvb_frontend.c for frontends which
>>> doesn't implement auto-inversion. Currently tda10021.c, tda10023.c and drxk_hard.c are not
>>> working. They fail at the following check:
>>>
>>>
>>>  231 static int tda10021_set_parameters (struct dvb_frontend *fe)
>>> ....
>>>  232 {
>>>  279         if (c->inversion != INVERSION_ON && c->inversion != INVERSION_OFF)
>>>  280                 return -EINVAL;
>>>
>>> The given inversion is INVERSION_AUTO.
>>>
>>> Regards,
>>> Hartmut
>>>
>>
>> Hi Hartmut,
>>
>> Thanks for testing!
>>
>> The issue here is that the dvb_frontend sometimes update only the DVBv3 parameters. 
>>
>> This is probably affecting DVBv5 drivers that may be lacking some features,
>> like zigzag support and DVB core emulation for INVERSION_AUTO.
>>
>> The enclosed patch should fix it.
>>
>> I'll latter dig into dvb_frontend, in order to replace the tests for info.type
>> there to c->delivery_system, as it might still have some bugs there due to
>> that.
>>
>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date: Fri, 30 Dec 2011 10:30:25 -0200
>> Subject: [PATCH] dvb_frontend: Fix inversion breakage due to DVBv5 conversion
>>
>> On several places inside dvb_frontend, only the DVBv3 parameters
>> were updated. Change it to be sure that, on all places, the DVBv5
>> parameters will be changed instead.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> index 9dd30be..9d092a6 100644
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> @@ -288,12 +288,13 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
>>  	int ready = 0;
>>  	int fe_set_err = 0;
>>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>> -	int original_inversion = fepriv->parameters_in.inversion;
>> -	u32 original_frequency = fepriv->parameters_in.frequency;
>> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache, tmp;
>> +	int original_inversion = c->inversion;
>> +	u32 original_frequency = c->frequency;
>>  
>>  	/* are we using autoinversion? */
>>  	autoinversion = ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
>> -			 (fepriv->parameters_in.inversion == INVERSION_AUTO));
>> +			 (c->inversion == INVERSION_AUTO));
>>  
>>  	/* setup parameters correctly */
>>  	while(!ready) {
>> @@ -359,19 +360,20 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
>>  		fepriv->auto_step, fepriv->auto_sub_step, fepriv->started_auto_step);
>>  
>>  	/* set the frontend itself */
>> -	fepriv->parameters_in.frequency += fepriv->lnb_drift;
>> +	c->frequency += fepriv->lnb_drift;
>>  	if (autoinversion)
>> -		fepriv->parameters_in.inversion = fepriv->inversion;
>> +		c->inversion = fepriv->inversion;
>> +	tmp = *c;
>>  	if (fe->ops.set_frontend)
>>  		fe_set_err = fe->ops.set_frontend(fe);
>> -	fepriv->parameters_out = fepriv->parameters_in;
>> +	*c = tmp;
>>  	if (fe_set_err < 0) {
>>  		fepriv->state = FESTATE_ERROR;
>>  		return fe_set_err;
>>  	}
>>  
>> -	fepriv->parameters_in.frequency = original_frequency;
>> -	fepriv->parameters_in.inversion = original_inversion;
>> +	c->frequency = original_frequency;
>> +	c->inversion = original_inversion;
>>  
>>  	fepriv->auto_sub_step++;
>>  	return 0;
>> @@ -382,6 +384,7 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
>>  	fe_status_t s = 0;
>>  	int retval = 0;
>>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache, tmp;
>>  
>>  	/* if we've got no parameters, just keep idling */
>>  	if (fepriv->state & FESTATE_IDLE) {
>> @@ -393,9 +396,10 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
>>  	/* in SCAN mode, we just set the frontend when asked and leave it alone */
>>  	if (fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT) {
>>  		if (fepriv->state & FESTATE_RETUNE) {
>> +			tmp = *c;
>>  			if (fe->ops.set_frontend)
>>  				retval = fe->ops.set_frontend(fe);
>> -			fepriv->parameters_out = fepriv->parameters_in;
>> +			*c = tmp;
>>  			if (retval < 0)
>>  				fepriv->state = FESTATE_ERROR;
>>  			else
>> @@ -425,8 +429,8 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
>>  
>>  		/* if we're tuned, then we have determined the correct inversion */
>>  		if ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
>> -		    (fepriv->parameters_in.inversion == INVERSION_AUTO)) {
>> -			fepriv->parameters_in.inversion = fepriv->inversion;
>> +		    (c->inversion == INVERSION_AUTO)) {
>> +			c->inversion = fepriv->inversion;
>>  		}
>>  		return;
>>  	}
>> @@ -1976,14 +1980,14 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>>  
>>  		/* force auto frequency inversion if requested */
>>  		if (dvb_force_auto_inversion) {
>> -			fepriv->parameters_in.inversion = INVERSION_AUTO;
>> +			c->inversion = INVERSION_AUTO;
>>  		}
>>  		if (fe->ops.info.type == FE_OFDM) {
>>  			/* without hierarchical coding code_rate_LP is irrelevant,
>>  			 * so we tolerate the otherwise invalid FEC_NONE setting */
>> -			if (fepriv->parameters_in.u.ofdm.hierarchy_information == HIERARCHY_NONE &&
>> -			    fepriv->parameters_in.u.ofdm.code_rate_LP == FEC_NONE)
>> -				fepriv->parameters_in.u.ofdm.code_rate_LP = FEC_AUTO;
>> +			if (c->hierarchy == HIERARCHY_NONE &&
>> +			    c->code_rate_LP == FEC_NONE)
>> +				c->code_rate_LP = FEC_AUTO;
>>  		}
>>  
>>  		/* get frontend-specific tuning settings */
>> @@ -1996,8 +2000,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>>  			switch(fe->ops.info.type) {
>>  			case FE_QPSK:
>>  				fepriv->min_delay = HZ/20;
>> -				fepriv->step_size = fepriv->parameters_in.u.qpsk.symbol_rate / 16000;
>> -				fepriv->max_drift = fepriv->parameters_in.u.qpsk.symbol_rate / 2000;
>> +				fepriv->step_size = c->symbol_rate / 16000;
>> +				fepriv->max_drift = c->symbol_rate / 2000;
>>  				break;
>>  
>>  			case FE_QAM:
>>
> 

