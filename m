Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49209 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1KVOiU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 09:38:20 -0500
Message-ID: <4ECBB3D7.3080904@iki.fi>
Date: Tue, 22 Nov 2011 16:38:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: PATCH 12/13: 0012-CXD2820r-Query-DVB-frontend-delivery-capabilities
References: <CAHFNz9KmxyBB4nRQZg1RdU+6wXHmaR9WHejuMqp6g9qrXykjQQ@mail.gmail.com>	<4ECAD07F.9010708@iki.fi>	<CAHFNz9KJ2LOhS2uoHM4iKVFTLyhe4aF6YzbqTLymdMXS2jgRqg@mail.gmail.com> <CAOcJUbzsEmO-f2dkugQL=ZkoYDm+ybCwamG4wYRDDiX=9thtKw@mail.gmail.com>
In-Reply-To: <CAOcJUbzsEmO-f2dkugQL=ZkoYDm+ybCwamG4wYRDDiX=9thtKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/22/2011 01:13 AM, Michael Krufky wrote:
> On Mon, Nov 21, 2011 at 6:01 PM, Manu Abraham<abraham.manu@gmail.com>  wrote:
>> Hi,
>>
>> On Tue, Nov 22, 2011 at 3:58 AM, Antti Palosaari<crope@iki.fi>  wrote:
>>> Hello
>>>
>>> On 11/21/2011 11:09 PM, Manu Abraham wrote:
>>>>
>>>>         /* program tuner */
>>>> -       if (fe->ops.tuner_ops.set_params)
>>>> -               fe->ops.tuner_ops.set_params(fe, params);
>>>> +       tstate.delsys = SYS_DVBC_ANNEX_AC;
>>>> +       tstate.frequency = c->frequency;
>>>> +
>>>> +       if (fe->ops.tuner_ops.set_state) {
>>>> +               fe->ops.tuner_ops.set_state(fe,
>>>> +                                           DVBFE_TUNER_DELSYS    |
>>>> +                                           DVBFE_TUNER_FREQUENCY,
>>>> +&tstate);

That is useless for the CXD2820R demodulator driver adding only some 
more code.

>>> I want to raise that point, switch from .set_params() to .set_state() when
>>> programming tuner. I don't see it reasonable to introduce (yes, it have
>>> existed ages but not used) new way to program tuner.
>>
>>
>> I didn't introduce set_state() now. It was there for quite a long
>> while, as old v5API itself, IIRC.

I looked now through all driver as for Kernel 3.2. There was three tuner 
drivers implementing .set_state().

Driver name and after the driver name is field it was used.

stb6100:
frequency
bandwidth

tda665x:
frequency

tda8261:
frequency

>>> Both demod and tuner got same params;
>>> .set_frontend(struct dvb_frontend *, struct dvb_frontend_parameters *)
>>> .set_params(struct dvb_frontend *, struct dvb_frontend_parameters *)
>>
>>
>> The argument passed to set_params: struct dvb_frontend_parameters is
>> useless for any device that's been around recently. Although one can
>> get the parameters from the property_cache.
>>
>> Using set_state(), makes it independant and less kludgy, simplifying
>> things. on the other hand it may be used with analog as well, llly to
>> Michael Krufky said.
>>
>> Eventually, it just provides the tuner an independence from struct
>> dvb_frontend_parameters (which is rigid) and the frontend cache.

Making tuners independent from  DVB FE could be good reason. But if we 
end-up doing that I think it must be done as different issue. Design and 
when there is consensus about implementation then switch to that.

>> That said, a few tuners already uses the mentioned callback, stb6100,
>> tda8261, tda665x,

Those were the only ones I found when grepping. Could you say where 
those callbacks are called? For some reason I didn't find any.

> Antti is correct, this *can* be done by accessing the property cache,
> and I would naturally agree with him that we should not add yet a 3rd
> entry point for tuning.
>
> However, this set_state is v4l/dvb agnostic.  if we go with this
> set_state callback, we can in fact eliminate both set_params *and*
> set_analog_params callbacks, finally having a single entry point for
> setting the tuner.
>
> If the community would prefer to use set_params, I am fine with
> that... but I also like the idea of unifying the set_params and
> set_analog_params into a single call.  If the community wants to see
> *that*, then lets go ahead with set_state.  I think this is a good
> step into that direction.
>
> Agreeing with Manu, it is indeed a matter of taste and I am fine with
> either way.  If we choose the set_state way, then future steps can
> unify the calls into a single entry point -- that would be the best,
> ultimately, in my opinion.

I see it is better to use DVB APIv5 as for now until there is better 
choice. Not making more unneeded deviation between tuner and demod drivers.


regards
Antti

-- 
http://palosaari.fi/
