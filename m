Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab1KYBx3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 20:53:29 -0500
Message-ID: <4ECEF50B.4050803@redhat.com>
Date: Thu, 24 Nov 2011 23:53:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: PATCH 12/13: 0012-CXD2820r-Query-DVB-frontend-delivery-capabilities
References: <CAHFNz9KmxyBB4nRQZg1RdU+6wXHmaR9WHejuMqp6g9qrXykjQQ@mail.gmail.com> <4ECAD07F.9010708@iki.fi> <CAHFNz9KJ2LOhS2uoHM4iKVFTLyhe4aF6YzbqTLymdMXS2jgRqg@mail.gmail.com>
In-Reply-To: <CAHFNz9KJ2LOhS2uoHM4iKVFTLyhe4aF6YzbqTLymdMXS2jgRqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-11-2011 21:01, Manu Abraham escreveu:
> Hi,
> 
> On Tue, Nov 22, 2011 at 3:58 AM, Antti Palosaari <crope@iki.fi> wrote:
>> Hello
>>
>> On 11/21/2011 11:09 PM, Manu Abraham wrote:
>>>
>>>        /* program tuner */
>>> -       if (fe->ops.tuner_ops.set_params)
>>> -               fe->ops.tuner_ops.set_params(fe, params);
>>> +       tstate.delsys = SYS_DVBC_ANNEX_AC;
>>> +       tstate.frequency = c->frequency;
>>> +
>>> +       if (fe->ops.tuner_ops.set_state) {
>>> +               fe->ops.tuner_ops.set_state(fe,
>>> +                                           DVBFE_TUNER_DELSYS    |
>>> +                                           DVBFE_TUNER_FREQUENCY,
>>> +                                       &tstate);
>>
>> I want to raise that point, switch from .set_params() to .set_state() when
>> programming tuner. I don't see it reasonable to introduce (yes, it have
>> existed ages but not used) new way to program tuner.
> 
> 
> I didn't introduce set_state() now. It was there for quite a long
> while, as old v5API itself, IIRC.
> 
> 
>>
>> Both demod and tuner got same params;
>> .set_frontend(struct dvb_frontend *, struct dvb_frontend_parameters *)
>> .set_params(struct dvb_frontend *, struct dvb_frontend_parameters *)
> 
> 
> The argument passed to set_params: struct dvb_frontend_parameters is
> useless for any device that's been around recently. Although one can
> get the parameters from the property_cache.

I like the idea of getting rid of struct dvb_frontend_parameters.
> 
> Using set_state(), makes it independant and less kludgy, simplifying
> things. on the other hand it may be used with analog as well, llly to
> Michael Krufky said.
> 
> Eventually, it just provides the tuner an independence from struct
> dvb_frontend_parameters (which is rigid) and the frontend cache.
> 
> That said, a few tuners already uses the mentioned callback, stb6100,
> tda8261, tda665x,

Hmm... while enum tuner_param is defined as a bitmask, stb6100 implements
it as:

static int stb6100_set_state(struct dvb_frontend *fe,
			     enum tuner_param param,
			     struct tuner_state *state)
{
	struct stb6100_state *tstate = fe->tuner_priv;

	switch (param) {
	case DVBFE_TUNER_FREQUENCY:
		stb6100_set_frequency(fe, state->frequency);
		tstate->frequency = state->frequency;
		break;
	case DVBFE_TUNER_TUNERSTEP:

And get_state current implementations return only one value each time.

I agree with Antti: the way it is designed doesn't seem to help much,
for a few reasons:

1) at get, one call is needed for each parameter, on the current drivers.
   Not a big issue, as patches fixing it may be added anytime.
2) The enum tuner_param field is limited to 32 bits. Currently, DTV_MAX_COMMAND
   is equal to 44. Ok, a tuner in general only need a small subset of the
   parameters, but 32 bits may starve too fast, depending on how complex
   will be the tuner staging for upcoming standards.
3) making tuner DVB or V4L agnostic would mean that the data would need
   to be copied from/to the tuner_state struct. The current struct has 6
   parameters. Patch 3/13 added 2 more parameters. If we pass the bandwidth
   calculus for DVB-S/S2/C/C2 to the frontend, rollback and symbol_rate would
   also needed to be there. Other data that is inside dvb_frontend would also
   require to be copied. For Analog standards, the analog parameters would
   also need to be there (like, for example, the analog standard).

I'm in favor of not trying to merge analog and dvb parameter setting.

I can see two approaches:

1) a simpler interface, like:

static int set_foo(struct dvb_frontend *fe);
	and
static int get_foo(struct dvb_frontend *fe);

2) a real cache-based struct:

Add some bitmap fields at struct dtv_frontend_properties in order to
indicate what parameters are new, on a set operations, and what
parameters are dirty (e. g. were modified by the tuner) on return.


This way, a call like:

err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &state);

could still be done using the new interface, allowing drivers to just
set the frequency and preserving the rest.

This would also reduce the amount of time needed to flush data from/to
the cache inside the core (if needed). 

I suspect, however, that the code inside the core will reduce a lot if we 
get rid of struct dvb_frontend_parameters inside the demods/tuners.
So, IMHO, approach (1) is better.

> If you imply that you feel overly depressed by the use of the
> set_state in the cxd2820r module ;-), then as a workaround, the
> parameters required for operation can be retrieved from the property
> cache, but then if tuner drivers are cleaned up by someone to remove
> obsolete ? set_params, then you wouldn't have any other option, but to
> later on fall back to set_state.
> 
> I am fine with either way, but for the tuners themselves, set_state
> behaves a bit more better as it provides independence from the legacy
> dvb_frontend_properties. It takes a bit of time for someone new to
> understand that (he cannot use dvb_frontend_properties anymore)
> 
> 
>>
>> and can get access to APIv5 property_cache similarly. Both, demod and tuner,
>> can read all those params that are now passed using .set_state()
> 
> 
> If you want to pass other parameters, as what exists already in
> tuner_state, that is not possible with set_params. If you can't have
> the required parameters through a parameters which is passed, but then
> why would you want to have such a parameter itself passed in the first
> case ?
> 
>>
>> There is some new tuner drivers which are already using APIv5.
>>
>>
>> regards
>> Antti
> 
> 
> Eventually it is all a matter of taste. I am fine with either. ;-)
> 
> Regards,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

