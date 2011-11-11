Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:44761 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1KKUJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 15:09:24 -0500
Message-ID: <4EBD80EF.2010002@linuxtv.org>
Date: Fri, 11 Nov 2011 21:09:19 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <CAHFNz9KFv7XvK4Uafuk8UDZiu1GEHSZ8bUp3nAyM21ck09yOCQ@mail.gmail.com> <4EBD3191.2040107@linuxtv.org> <4EBD347C.40801@redhat.com> <4EBD39DF.8060909@linuxtv.org> <4EBD57E8.1010501@redhat.com>
In-Reply-To: <4EBD57E8.1010501@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.11.2011 18:14, Mauro Carvalho Chehab wrote:
> Em 11-11-2011 13:06, Andreas Oberritter escreveu:
>> On 11.11.2011 15:43, Mauro Carvalho Chehab wrote:
>>> IMHO, the better is to set all parameters via stb0899_get_property(). We should
>>> work on deprecate the old way, as, by having all frontends implementing the
>>> get/set property ops, we can remove part of the legacy code inside the DVB core.
>>
>> I'm not sure what "legacy code" you're referring to. If you're referring
>> to the big switch in dtv_property_process_get(), which presets output
>> values based on previously set tuning parameters, then no, please don't
>> deprecate it. It doesn't improve driver code if you move this switch
>> down into every driver.
> 
> What I mean is that drivers should get rid of implementing get_frontend() and 
> set_frontend(), restricting the usage of struct dvb_frontend_parameters for DVBv3
> calls from userspace.

This would generate quite some work without much benefit.

> In other words, it should be part of the core logic to get all the parameters
> passed from userspace and passing them via one single call to something similar
> to set_property.

That's exactly what we have now with the set_frontend, tune, search and
track callbacks.

> In other words, ideally, the implementation for DTV set should be
> like:
> 
> static int dtv_property_process_set(struct dvb_frontend *fe,
> 				    struct dtv_property *tvp,
> 				    struct file *file)
> {
> 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> 
> 	switch(tvp->cmd) {
> 	case DTV_CLEAR:
> 		dvb_frontend_clear_cache(fe);
> 		break;
> 	case DTV_FREQUENCY:
> 		c->frequency = tvp->u.data;
> 		break;
> 	case DTV_MODULATION:
> 		c->modulation = tvp->u.data;
> 		break;
> 	case DTV_BANDWIDTH_HZ:
> 		c->bandwidth_hz = tvp->u.data;
> 		break;
> ...
> 	case DTV_TUNE:
> 		/* interpret the cache of data */
> 		if (fe->ops.new_set_frontend) {
> 			r = fe->ops.new_set_frontend(fe);
> 			if (r < 0)
> 				return r;
> 		}

set_frontend is called by the frontend thread, multiple times with
alternating parameters if necessary. Depending on the tuning algorithm,
drivers may implement tune or search and track instead. You cannot just
call a "new_set_frontend" driver function from here and expect it to
work as before.

> 		break;
> 
> E. g. instead of using the struct dvb_frontend_parameters, the drivers would
> use struct dtv_frontend_properties (already stored at the frontend
> struct as fe->dtv_property_cache).

Drivers are already free to ignore dvb_frontend_parameters and use the
properties stored in dtv_property_cache today.

> Btw, with such change, it would actually make sense the original proposal
> from Manu of having a separate callback for supported delivery systems.

Why? How does setting parameters relate to querying capabilies?

Regards,
Andreas
