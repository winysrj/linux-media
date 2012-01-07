Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:33504 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751078Ab2AGFVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 00:21:55 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] dvb_frontend: Don't use ops->info.type anymore
Date: Sat, 7 Jan 2012 06:18:21 +0100
Cc: linux-media@vger.kernel.org
References: <E1RiZbZ-0002R2-ND@www.linuxtv.org> <201201070136.45149@orion.escape-edv.de> <4F07A874.5070408@infradead.org>
In-Reply-To: <4F07A874.5070408@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201070618.22602@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 January 2012 03:05:40 Mauro Carvalho Chehab wrote:
> On 06-01-2012 22:36, Oliver Endriss wrote:
> > On Wednesday 04 January 2012 20:29:36 Mauro Carvalho Chehab wrote:
> >>  drivers/media/dvb/dvb-core/dvb_frontend.c |  541 ++++++++++++++---------------
> >>  1 files changed, 266 insertions(+), 275 deletions(-)
> >> ...
> >> -static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
> >> -				struct dvb_frontend_parameters *parms)
> >> +static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
> >>  {
> >> ...
> >> -	/* check for supported modulation */
> >> -	if (fe->ops.info.type == FE_QAM &&
> >> -	    (parms->u.qam.modulation > QAM_AUTO ||
> >> -	     !((1 << (parms->u.qam.modulation + 10)) & fe->ops.info.caps))) {
> >> -		printk(KERN_WARNING "DVB: adapter %i frontend %i modulation %u not supported\n",
> >> -		       fe->dvb->num, fe->id, parms->u.qam.modulation);
> >> +	/*
> >> +	 * check for supported modulation
> >> +	 *
> >> +	 * This is currently hacky. Also, it only works for DVB-S & friends,
> >> +	 * and not all modulations has FE_CAN flags
> >> +	 */
> >> +	switch (c->delivery_system) {
> >> +	case SYS_DVBS:
> >> +	case SYS_DVBS2:
> >> +	case SYS_TURBO:
> >> +		if ((c->modulation > QAM_AUTO ||
> >> +		    !((1 << (c->modulation + 10)) & fe->ops.info.caps))) {
> >                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >> +			printk(KERN_WARNING
> >> +			       "DVB: adapter %i frontend %i modulation %u not supported\n",
> >> +			       fe->dvb->num, fe->id, c->modulation);
> >>  			return -EINVAL;
> >> +		}
> >> +		break;
> >> ...
> > 
> > This code is completely bogus: I get tons of warnings, if vdr tries to
> > tune to DVB-S2 (modulation == 9 == PSK_8) on my stv090x.
> > 
> > PSK_8 == 9 is > QAM_AUTO, and the shift operation does not make much
> > sense, except for modulation == 0 == QPSK.
> > 
> > The original version makes more sense for me.
> 
> Oliver,
> 
> At least for DVBv3 calls, the old code will also generate bogus
> warnings if you try to use a DVBv3 call to set PSK_8.

No, since the checks were only performed for type==QAM, i.e. DVB-C.
So DVB-S2 was not affected before.

> I almost removed this validation code during the conversion for several
> reasons:
> 
> 1) it does some "magic" by assuming that all QAM modulations are below
>   QAM_AUTO;
> 
> 2) it checks modulation parameters only for DVB-S. IMO, or the core should
> invalid parameters for all delivery systems, or should let the frontend
> drivers do it;
> 
> 3) frontend drivers should already be checking for invalid parameters
> (most of them do it, anyway);
> 
> 4) not all modulations are mapped at fe->ops.info.caps, so it is not
> even possible to check for the valid modulations inside the core for
> some delivery systems;
> 
> 5) Why the core checks just the modulation, and doesn't check for other
> types of invalid parameters, like FEC and bandwidth?
> 
> At the end, I decided to keep it, but added that note, as I really didn't
> like that part of the code.
> 
> I can see two fixes for this:
> 
> a) just remove the validation, and let the frontend check what's
>    supported;
> 
> b) rewrite the code with a per-standard table of valid values.
> 
> I vote for removing the validation logic there.

Ack.

Atm the core could only do proper checks for frontends, which support a
single delivery system. For multi-delsys frontends some values of the
info struct might not apply to the currently selected delivery system.

To fix this, you need precise information, what is supported for a given
delivery system. In this case we need 'per delivery system' information.
Maybe it would make sense to add a callback, and let the driver do the
checks?

Furthermore, old API-5 applications do not set the delivery system!

For example: VDR checked the FE_CAN_2G_MODULATION flag and eventually
issues a tune call, no matter whether the current delsys is DVB-S or
DVB-S2. So it is difficult to do check parameters in a precise way,
while keeping backward compatibility.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
