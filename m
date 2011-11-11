Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:54506 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1KKPGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 10:06:11 -0500
Message-ID: <4EBD39DF.8060909@linuxtv.org>
Date: Fri, 11 Nov 2011 16:06:07 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com> <4EBD3191.2040107@linuxtv.org> <4EBD347C.40801@redhat.com>
In-Reply-To: <4EBD347C.40801@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.11.2011 15:43, Mauro Carvalho Chehab wrote:
> Em 11-11-2011 12:30, Andreas Oberritter escreveu:
>> On 11.11.2011 07:26, Manu Abraham wrote:
>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
>>> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Wed Nov 09 19:52:36 2011 +0530
>>> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri Nov 11 06:05:40 2011 +0530
>>> @@ -973,6 +973,8 @@
>>>  	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>>>  	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>>>  	_DTV_CMD(DTV_HIERARCHY, 0, 0),
>>> +
>>> +	_DTV_CMD(DTV_DELIVERY_CAPS, 0, 0),
>>>  };
>>>  
>>>  static void dtv_property_dump(struct dtv_property *tvp)
>>> @@ -1226,7 +1228,11 @@
>>>  		c = &cdetected;
>>>  	}
>>>  
>>> +	dprintk("%s\n", __func__);
>>> +
>>>  	switch(tvp->cmd) {
>>> +	case DTV_DELIVERY_CAPS:
>>
>> It would be nice to have a default implementation inserted at this point, e.g. something like:
>>
>> static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct dtv_property *p)
>> {
>> 	const struct dvb_frontend_info *info = &fe->ops.info;
>> 	u32 ncaps = 0;
>>
>> 	switch (info->type) {
>> 	case FE_QPSK:
>> 		p->u.buffer.data[ncaps++] = SYS_DVBS;
>> 		if (info->caps & FE_CAN_2G_MODULATION)
>> 			p->u.buffer.data[ncaps++] = SYS_DVBS2;
>> 		if (info->caps & FE_CAN_TURBO_FEC)
>> 			p->u.buffer.data[ncaps++] = SYS_TURBO;
>> 		break;
>> 	case FE_QAM:
>> 		p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_AC;
>> 		break;
>> 	case FE_OFDM:
>> 		p->u.buffer.data[ncaps++] = SYS_DVBT;
>> 		if (info->caps & FE_CAN_2G_MODULATION)
>> 			p->u.buffer.data[ncaps++] = SYS_DVBT2;
>> 		break;
>> 	case FE_ATSC:
>> 		if (info->caps & (FE_CAN_8VSB | FE_CAN_16VSB))
>> 			p->u.buffer.data[ncaps++] = SYS_ATSC;
>> 		if (info->caps & (FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_128 | FE_CAN_QAM_256))
>> 			p->u.buffer.data[ncaps++] = SYS_DVBC_ANNEX_B;
>> 	}
>>
>> 	p->u.buffer.len = ncaps;
>> }
>>
>> I think this would be sufficient for a lot of drivers and would thus save a lot of work.
>>
>>> +		break;
>>>  	case DTV_FREQUENCY:
>>>  		tvp->u.data = c->frequency;
>>>  		break;
>>> @@ -1350,7 +1356,7 @@
>>>  		if (r < 0)
>>>  			return r;
>>>  	}
>>> -
>>> +done:
>>
>> This label is unused now and should be removed.
>>
>>>  	dtv_property_dump(tvp);
>>>  
>>>  	return 0;
>>> diff -r b6eb04718aa9 linux/drivers/media/dvb/frontends/stb0899_drv.c
>>> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	Wed Nov 09 19:52:36 2011 +0530
>>> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	Fri Nov 11 06:05:40 2011 +0530
>>> @@ -1605,6 +1605,22 @@
>>>  	return DVBFE_ALGO_CUSTOM;
>>>  }
>>>  
>>> +static int stb0899_get_property(struct dvb_frontend *fe, struct dtv_property *p)
>>> +{
>>> +	switch (p->cmd) {
>>> +	case DTV_DELIVERY_CAPS:
>>> +		p->u.buffer.data[0] = SYS_DSS;
>>> +		p->u.buffer.data[1] = SYS_DVBS;
>>> +		p->u.buffer.data[2] = SYS_DVBS2;
>>> +		p->u.buffer.len = 3;
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>
>> You should ignore all unhandled properties. Otherwise all properties handled
>> by the core will have result set to -EINVAL.
> 
> IMHO, the better is to set all parameters via stb0899_get_property(). We should
> work on deprecate the old way, as, by having all frontends implementing the
> get/set property ops, we can remove part of the legacy code inside the DVB core.

I'm not sure what "legacy code" you're referring to. If you're referring
to the big switch in dtv_property_process_get(), which presets output
values based on previously set tuning parameters, then no, please don't
deprecate it. It doesn't improve driver code if you move this switch
down into every driver.

Of course, a driver can and should override any property it knows about
in its get_property callback, if - and only if - the property value
possibly differs from the value set by the default implementation in
dvb_frontend.

However, all of this is out of scope of Manu's patch. Please just remove
the erroneous return statement.

>>
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +
>>>  static struct dvb_frontend_ops stb0899_ops = {
>>>  
>>>  	.info = {
>>> @@ -1647,6 +1663,8 @@
>>>  	.diseqc_send_master_cmd		= stb0899_send_diseqc_msg,
>>>  	.diseqc_recv_slave_reply	= stb0899_recv_slave_reply,
>>>  	.diseqc_send_burst		= stb0899_send_diseqc_burst,
>>> +
>>> +	.get_property			= stb0899_get_property,
>>>  };
>>>  
>>>  struct dvb_frontend *stb0899_attach(struct stb0899_config *config, struct i2c_adapter *i2c)
>>> diff -r b6eb04718aa9 linux/include/linux/dvb/frontend.h
>>> --- a/linux/include/linux/dvb/frontend.h	Wed Nov 09 19:52:36 2011 +0530
>>> +++ b/linux/include/linux/dvb/frontend.h	Fri Nov 11 06:05:40 2011 +0530
>>> @@ -316,7 +316,9 @@
>>>  
>>>  #define DTV_DVBT2_PLP_ID	43
>>>  
>>> -#define DTV_MAX_COMMAND				DTV_DVBT2_PLP_ID
>>> +#define DTV_DELIVERY_CAPS	44
>>> +
>>> +#define DTV_MAX_COMMAND				DTV_DELIVERY_CAPS
>>>  
>>>  typedef enum fe_pilot {
>>>  	PILOT_ON,
>>>
>>
> 

