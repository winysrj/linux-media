Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355Ab2AGCFt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 21:05:49 -0500
Message-ID: <4F07A874.5070408@infradead.org>
Date: Sat, 07 Jan 2012 00:05:40 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.3] [media] dvb_frontend: Don't use ops->info.type
 anymore
References: <E1RiZbZ-0002R2-ND@www.linuxtv.org> <201201070136.45149@orion.escape-edv.de>
In-Reply-To: <201201070136.45149@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-01-2012 22:36, Oliver Endriss wrote:
> On Wednesday 04 January 2012 20:29:36 Mauro Carvalho Chehab wrote:
>>  drivers/media/dvb/dvb-core/dvb_frontend.c |  541 ++++++++++++++---------------
>>  1 files changed, 266 insertions(+), 275 deletions(-)
>> ...
>> -static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
>> -				struct dvb_frontend_parameters *parms)
>> +static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
>>  {
>> ...
>> -	/* check for supported modulation */
>> -	if (fe->ops.info.type == FE_QAM &&
>> -	    (parms->u.qam.modulation > QAM_AUTO ||
>> -	     !((1 << (parms->u.qam.modulation + 10)) & fe->ops.info.caps))) {
>> -		printk(KERN_WARNING "DVB: adapter %i frontend %i modulation %u not supported\n",
>> -		       fe->dvb->num, fe->id, parms->u.qam.modulation);
>> +	/*
>> +	 * check for supported modulation
>> +	 *
>> +	 * This is currently hacky. Also, it only works for DVB-S & friends,
>> +	 * and not all modulations has FE_CAN flags
>> +	 */
>> +	switch (c->delivery_system) {
>> +	case SYS_DVBS:
>> +	case SYS_DVBS2:
>> +	case SYS_TURBO:
>> +		if ((c->modulation > QAM_AUTO ||
>> +		    !((1 << (c->modulation + 10)) & fe->ops.info.caps))) {
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +			printk(KERN_WARNING
>> +			       "DVB: adapter %i frontend %i modulation %u not supported\n",
>> +			       fe->dvb->num, fe->id, c->modulation);
>>  			return -EINVAL;
>> +		}
>> +		break;
>> ...
> 
> This code is completely bogus: I get tons of warnings, if vdr tries to
> tune to DVB-S2 (modulation == 9 == PSK_8) on my stv090x.
> 
> PSK_8 == 9 is > QAM_AUTO, and the shift operation does not make much
> sense, except for modulation == 0 == QPSK.
> 
> The original version makes more sense for me.

Oliver,

At least for DVBv3 calls, the old code will also generate bogus
warnings if you try to use a DVBv3 call to set PSK_8.

I almost removed this validation code during the conversion for several
reasons:

1) it does some "magic" by assuming that all QAM modulations are below
  QAM_AUTO;

2) it checks modulation parameters only for DVB-S. IMO, or the core should
invalid parameters for all delivery systems, or should let the frontend
drivers do it;

3) frontend drivers should already be checking for invalid parameters
(most of them do it, anyway);

4) not all modulations are mapped at fe->ops.info.caps, so it is not
even possible to check for the valid modulations inside the core for
some delivery systems;

5) Why the core checks just the modulation, and doesn't check for other
types of invalid parameters, like FEC and bandwidth?

At the end, I decided to keep it, but added that note, as I really didn't
like that part of the code.

I can see two fixes for this:

a) just remove the validation, and let the frontend check what's
   supported;

b) rewrite the code with a per-standard table of valid values.

I vote for removing the validation logic there.

Regards,
Mauro
