Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:45925 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1KLECV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 23:02:21 -0500
Message-ID: <4EBDEFC8.7030408@linuxtv.org>
Date: Sat, 12 Nov 2011 05:02:16 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com> <4EBD3191.2040107@linuxtv.org> <4EBD347C.40801@redhat.com> <4EBD39DF.8060909@linuxtv.org> <4EBD57E8.1010501@redhat.com> <4EBD80EF.2010002@linuxtv.org> <4EBD9B78.6080301@redhat.com>
In-Reply-To: <4EBD9B78.6080301@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.11.2011 23:02, Mauro Carvalho Chehab wrote:
> Em 11-11-2011 18:09, Andreas Oberritter escreveu:
>> On 11.11.2011 18:14, Mauro Carvalho Chehab wrote:
>>> Em 11-11-2011 13:06, Andreas Oberritter escreveu:
>>>> On 11.11.2011 15:43, Mauro Carvalho Chehab wrote:
>>>>> IMHO, the better is to set all parameters via stb0899_get_property(). We should
>>>>> work on deprecate the old way, as, by having all frontends implementing the
>>>>> get/set property ops, we can remove part of the legacy code inside the DVB core.
>>>>
>>>> I'm not sure what "legacy code" you're referring to. If you're referring
>>>> to the big switch in dtv_property_process_get(), which presets output
>>>> values based on previously set tuning parameters, then no, please don't
>>>> deprecate it. It doesn't improve driver code if you move this switch
>>>> down into every driver.
>>>
>>> What I mean is that drivers should get rid of implementing get_frontend() and 
>>> set_frontend(), restricting the usage of struct dvb_frontend_parameters for DVBv3
>>> calls from userspace.
>>
>> This would generate quite some work without much benefit.
> 
> Some effort is indeed needed. There are some benefits, though. Tests I made
> when writing a v5 library showed some hard to fix bugs with the current way:
> 
> 	1) DVB-C Annex C is currently broken, as there's no way to select it
> with the current API. A fix for it is simple, but requires adding one more
> parameter for example, to represent the roll-off (Annex C uses 0.13 for roll-off, 
> instead of 0.15 for Annex A);

An alternative would be to rename SYS_DVBC_ANNEX_AC to SYS_DVBC_ANNEX_A,
add SYS_DVBC_ANNEX_C, and add SYS_DVBC_ANNEX_AC as a define for
backwards compatibility.

> 
> 	2) The *legacy*() calls at the code don't handle well ATSC x ANNEX B, e. g.
> a get after a set returns the wrong delivery system.

Do you know what exactly is wrong with it?

> Ok, we may be able to find some workarounds, but that means adding some hacks at
> the core.
> 
>>> In other words, it should be part of the core logic to get all the parameters
>>> passed from userspace and passing them via one single call to something similar
>>> to set_property.
>>
>> That's exactly what we have now with the set_frontend, tune, search and
>> track callbacks.
> 
> Yes, except that the same information is passed twice at the driver for DVB-C,
> DVB-S, DVB-T and ATSC/J.83 Annex B.
> 
> The core needs to duplicate everything into the legacy structure, as it assumes
> that the drivers could use the legacy stuff.

Yes.

>>> In other words, ideally, the implementation for DTV set should be
>>> like:
>>>
>>> static int dtv_property_process_set(struct dvb_frontend *fe,
>>> 				    struct dtv_property *tvp,
>>> 				    struct file *file)
>>> {
>>> 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>>
>>> 	switch(tvp->cmd) {
>>> 	case DTV_CLEAR:
>>> 		dvb_frontend_clear_cache(fe);
>>> 		break;
>>> 	case DTV_FREQUENCY:
>>> 		c->frequency = tvp->u.data;
>>> 		break;
>>> 	case DTV_MODULATION:
>>> 		c->modulation = tvp->u.data;
>>> 		break;
>>> 	case DTV_BANDWIDTH_HZ:
>>> 		c->bandwidth_hz = tvp->u.data;
>>> 		break;
>>> ...
>>> 	case DTV_TUNE:
>>> 		/* interpret the cache of data */
>>> 		if (fe->ops.new_set_frontend) {
>>> 			r = fe->ops.new_set_frontend(fe);
>>> 			if (r < 0)
>>> 				return r;
>>> 		}
>>
>> set_frontend is called by the frontend thread, multiple times with
>> alternating parameters if necessary. Depending on the tuning algorithm,
>> drivers may implement tune or search and track instead. You cannot just
>> call a "new_set_frontend" driver function from here and expect it to
>> work as before.
> 
> I know. The solution is not as simple as the above.
> 
>>> 		break;
>>>
>>> E. g. instead of using the struct dvb_frontend_parameters, the drivers would
>>> use struct dtv_frontend_properties (already stored at the frontend
>>> struct as fe->dtv_property_cache).
>>
>> Drivers are already free to ignore dvb_frontend_parameters and use the
>> properties stored in dtv_property_cache today.
> 
> True, and they do that already, but this still data needs to be copied
> twice. There is also a problem with this approach on get_properties:
> as some drivers may be storing returned data into dvb_frontend_parameters, while
> others may be storing at dtv_frontend_properties, the code will need to know
> what data is reliable and what data should be discarded.
> 
> The current code assumes that "legacy" delivery systems will always return data
> via dtv_frontend_properties.
> 
> Btw, the emulation code is currently broken for ISDB-T and DVB-T2: both emulate
> a DVB-T delivery system, so, at the DVB structure info.type = FE_OFDM.
> 
> If you look at the code, you'll see things like:
> 
> ...
> 	switch (fe->ops.info.type) {
> ...
> 	case FE_OFDM:
> 		c->delivery_system = SYS_DVBT;
> 		break;
> ...

This code path only gets executed when calling FE_SET_FRONTEND from
userspace. There's no DVB-T2 support in v3, so this should be ok.

> static void dtv_property_cache_sync(struct dvb_frontend *fe,
> ...
> case FE_OFDM:
>                 if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
>                        	c->bandwidth_hz = 6000000;
>                 else if (p->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
>                         c->bandwidth_hz = 7000000;
>                 else if (p->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
>                         c->bandwidth_hz = 8000000;
>                	else
>                     	/* Including BANDWIDTH_AUTO */
>                         c->bandwidth_hz = 0;
>                 c->code_rate_HP = p->u.ofdm.code_rate_HP;
>                 c->code_rate_LP = p->u.ofdm.code_rate_LP;
>                 c->modulation = p->u.ofdm.constellation;
>                 c->transmission_mode = p->u.ofdm.transmission_mode;
>                 c->guard_interval = p->u.ofdm.guard_interval;
>                 c->hierarchy = p->u.ofdm.hierarchy_information;
>                 break;
> 
> So, even a pure ISDB-T driver will need to change DVB-T u.ofdm.*, as touching
> at c->* will be discarded by dtv_property_cache_sync().

Why do ISDB-T drivers pretend to be DVB-T drivers by specifying FE_OFDM?
Even though it's called FE_OFDM, it really means "DVB-T" and not "any
delivery system using OFDM".

ISDB-T doesn't have a v3 interface, so ISDB-T drivers shouldn't
implement the legacy get_frontend callback, in which case
dtv_property_cache_sync won't be called. Furthermore, a driver may set
all properties in its get_property callback, whether
dtv_property_cache_sync was called or not.

> The same thing will also occur with all 2 GEN drivers that fill info.type.
> 
> Such behavior is ugly, and not expected, and may lead into hard to detect
> bugs, as the driver code will look right, but won't behave as expected.
> 
> The thing is that those emulation stuff are broken, and fixing it will probably
> be more complex than a simple scriptable change applied at the drivers that would
> replace the union by a direct access to the cache info. On most drivers, the change 
> is as simple as:
> 	s/p->u.ofdm./c->/
> 	s/p->u.qpsk./c->/
> 	s/p->u.vsm./c->/
> 	s/p->u.qam./c->/
> 
>>> Btw, with such change, it would actually make sense the original proposal
>>> from Manu of having a separate callback for supported delivery systems.
>>
>> Why? How does setting parameters relate to querying capabilies?
> 
> Because, after such change, set_property() could likely be removed.

But how does this relate to get_property? set_property isn't used to
query capabilities.

Regards,
Andreas
