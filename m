Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2AGHeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 02:34:16 -0500
Message-ID: <4F07F570.1060605@infradead.org>
Date: Sat, 07 Jan 2012 05:34:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.3] [media] dvb_frontend: Don't use ops->info.type
 anymore
References: <E1RiZbZ-0002R2-ND@www.linuxtv.org> <201201070136.45149@orion.escape-edv.de> <4F07A874.5070408@infradead.org> <201201070618.22602@orion.escape-edv.de>
In-Reply-To: <201201070618.22602@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-01-2012 03:18, Oliver Endriss wrote:
> On Saturday 07 January 2012 03:05:40 Mauro Carvalho Chehab wrote:
>> On 06-01-2012 22:36, Oliver Endriss wrote:
>>> On Wednesday 04 January 2012 20:29:36 Mauro Carvalho Chehab wrote:
>>>>  drivers/media/dvb/dvb-core/dvb_frontend.c |  541 ++++++++++++++---------------
>>>>  1 files changed, 266 insertions(+), 275 deletions(-)
>>>> ...
>>>> -static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
>>>> -				struct dvb_frontend_parameters *parms)
>>>> +static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
>>>>  {
>>>> ...
>>>> -	/* check for supported modulation */
>>>> -	if (fe->ops.info.type == FE_QAM &&
>>>> -	    (parms->u.qam.modulation > QAM_AUTO ||
>>>> -	     !((1 << (parms->u.qam.modulation + 10)) & fe->ops.info.caps))) {
>>>> -		printk(KERN_WARNING "DVB: adapter %i frontend %i modulation %u not supported\n",
>>>> -		       fe->dvb->num, fe->id, parms->u.qam.modulation);
>>>> +	/*
>>>> +	 * check for supported modulation
>>>> +	 *
>>>> +	 * This is currently hacky. Also, it only works for DVB-S & friends,
>>>> +	 * and not all modulations has FE_CAN flags
>>>> +	 */
>>>> +	switch (c->delivery_system) {
>>>> +	case SYS_DVBS:
>>>> +	case SYS_DVBS2:
>>>> +	case SYS_TURBO:
>>>> +		if ((c->modulation > QAM_AUTO ||
>>>> +		    !((1 << (c->modulation + 10)) & fe->ops.info.caps))) {
>>>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> +			printk(KERN_WARNING
>>>> +			       "DVB: adapter %i frontend %i modulation %u not supported\n",
>>>> +			       fe->dvb->num, fe->id, c->modulation);
>>>>  			return -EINVAL;
>>>> +		}
>>>> +		break;
>>>> ...
>>>
>>> This code is completely bogus: I get tons of warnings, if vdr tries to
>>> tune to DVB-S2 (modulation == 9 == PSK_8) on my stv090x.
>>>
>>> PSK_8 == 9 is > QAM_AUTO, and the shift operation does not make much
>>> sense, except for modulation == 0 == QPSK.
>>>
>>> The original version makes more sense for me.
>>
>> Oliver,
>>
>> At least for DVBv3 calls, the old code will also generate bogus
>> warnings if you try to use a DVBv3 call to set PSK_8.
> 
> No, since the checks were only performed for type==QAM, i.e. DVB-C.
> So DVB-S2 was not affected before.

Sorry, I coded it wrong.

Anyway, when DVB-C2 will be added, the code will likely break again.

>> I almost removed this validation code during the conversion for several
>> reasons:
>>
>> 1) it does some "magic" by assuming that all QAM modulations are below
>>   QAM_AUTO;
>>
>> 2) it checks modulation parameters only for DVB-S. IMO, or the core should
>> invalid parameters for all delivery systems, or should let the frontend
>> drivers do it;
>>
>> 3) frontend drivers should already be checking for invalid parameters
>> (most of them do it, anyway);
>>
>> 4) not all modulations are mapped at fe->ops.info.caps, so it is not
>> even possible to check for the valid modulations inside the core for
>> some delivery systems;
>>
>> 5) Why the core checks just the modulation, and doesn't check for other
>> types of invalid parameters, like FEC and bandwidth?
>>
>> At the end, I decided to keep it, but added that note, as I really didn't
>> like that part of the code.
>>
>> I can see two fixes for this:
>>
>> a) just remove the validation, and let the frontend check what's
>>    supported;
>>
>> b) rewrite the code with a per-standard table of valid values.
>>
>> I vote for removing the validation logic there.
> 
> Ack.
> 
> Atm the core could only do proper checks for frontends, which support a
> single delivery system. For multi-delsys frontends some values of the
> info struct might not apply to the currently selected delivery system.
> 
> To fix this, you need precise information, what is supported for a given
> delivery system. In this case we need 'per delivery system' information.
> Maybe it would make sense to add a callback, and let the driver do the
> checks?

With the changes I made, all frontends are now filling ops.delsys with
the supported delivery system. The DVB core picks ops.delsys[0] during
register and on cache clear. So, no callback is needed, and the core can
quickly check the supported delivery systems.

> Furthermore, old API-5 applications do not set the delivery system!

In this case, it will use ops.delsys[0]. On all frondends with 2G support,
the first delivery system is the 1 gen.

> For example: VDR checked the FE_CAN_2G_MODULATION flag and eventually
> issues a tune call, no matter whether the current delsys is DVB-S or
> DVB-S2. So it is difficult to do check parameters in a precise way,
> while keeping backward compatibility.

Yes. Still, the frontend may not do the right thing, as it may use different
checks for SYS_DVBS/SYS_DVBS2 internally.

I did not touch (at least not intentionally) on any of such checks, but a
quick grep for SYS_DVBS2 shows that setting the wrong delivery system will
cause troubles.

For example, on frontends/ds3000.c, ds3000_read_status() uses a different
register for DVB_S2 lock. So, an application that doesn't set the delivery
system to SYS_DVBS2 will (likely) not lock into DVB-S2 channels.

The cx24116 frontend (one of the first ones to use S2API, if not the first)
returns -EOPNOTSUPP if a DVB-S2 mode is requested with SYS_DVBS.

As far as I understand, support/need for changing the delivery system for 
the second gen is there since the addition of S2API (although this weren't
properly documented until kernel 3.1). Applications that aren't doing it
may expect erratic behavior.

All we can do about that is to ask application developers to be fast on
fixing the applications to work properly with multiple delivery systems
frontends, by always setting the delivery system via a DVBv5 call, and
using DTV_ENUM_DELSYS to check what delivery systems are supported.

Regards,
Mauro
