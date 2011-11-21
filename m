Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46619 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1KUXNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 18:13:33 -0500
Received: by ggnr5 with SMTP id r5so2907280ggn.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 15:13:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9KJ2LOhS2uoHM4iKVFTLyhe4aF6YzbqTLymdMXS2jgRqg@mail.gmail.com>
References: <CAHFNz9KmxyBB4nRQZg1RdU+6wXHmaR9WHejuMqp6g9qrXykjQQ@mail.gmail.com>
	<4ECAD07F.9010708@iki.fi>
	<CAHFNz9KJ2LOhS2uoHM4iKVFTLyhe4aF6YzbqTLymdMXS2jgRqg@mail.gmail.com>
Date: Mon, 21 Nov 2011 18:13:32 -0500
Message-ID: <CAOcJUbzsEmO-f2dkugQL=ZkoYDm+ybCwamG4wYRDDiX=9thtKw@mail.gmail.com>
Subject: Re: PATCH 12/13: 0012-CXD2820r-Query-DVB-frontend-delivery-capabilities
From: Michael Krufky <mkrufky@linuxtv.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 21, 2011 at 6:01 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi,
>
> On Tue, Nov 22, 2011 at 3:58 AM, Antti Palosaari <crope@iki.fi> wrote:
>> Hello
>>
>> On 11/21/2011 11:09 PM, Manu Abraham wrote:
>>>
>>>        /* program tuner */
>>> -       if (fe->ops.tuner_ops.set_params)
>>> -               fe->ops.tuner_ops.set_params(fe, params);
>>> +       tstate.delsys = SYS_DVBC_ANNEX_AC;
>>> +       tstate.frequency = c->frequency;
>>> +
>>> +       if (fe->ops.tuner_ops.set_state) {
>>> +               fe->ops.tuner_ops.set_state(fe,
>>> +                                           DVBFE_TUNER_DELSYS    |
>>> +                                           DVBFE_TUNER_FREQUENCY,
>>> +                                       &tstate);
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
>
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


Antti is correct, this *can* be done by accessing the property cache,
and I would naturally agree with him that we should not add yet a 3rd
entry point for tuning.

However, this set_state is v4l/dvb agnostic.  if we go with this
set_state callback, we can in fact eliminate both set_params *and*
set_analog_params callbacks, finally having a single entry point for
setting the tuner.

If the community would prefer to use set_params, I am fine with
that... but I also like the idea of unifying the set_params and
set_analog_params into a single call.  If the community wants to see
*that*, then lets go ahead with set_state.  I think this is a good
step into that direction.

Agreeing with Manu, it is indeed a matter of taste and I am fine with
either way.  If we choose the set_state way, then future steps can
unify the calls into a single entry point -- that would be the best,
ultimately, in my opinion.

Regards,
Mike Krufky
