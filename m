Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:45127 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755035Ab2AGArI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 19:47:08 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.3] [media] dvb_frontend: Don't use ops->info.type anymore
Date: Sat, 7 Jan 2012 01:36:44 +0100
References: <E1RiZbZ-0002R2-ND@www.linuxtv.org>
In-Reply-To: <E1RiZbZ-0002R2-ND@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201070136.45149@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 January 2012 20:29:36 Mauro Carvalho Chehab wrote:
>  drivers/media/dvb/dvb-core/dvb_frontend.c |  541 ++++++++++++++---------------
>  1 files changed, 266 insertions(+), 275 deletions(-)
> ...
> -static int dvb_frontend_check_parameters(struct dvb_frontend *fe,
> -				struct dvb_frontend_parameters *parms)
> +static int dvb_frontend_check_parameters(struct dvb_frontend *fe)
>  {
> ...
> -	/* check for supported modulation */
> -	if (fe->ops.info.type == FE_QAM &&
> -	    (parms->u.qam.modulation > QAM_AUTO ||
> -	     !((1 << (parms->u.qam.modulation + 10)) & fe->ops.info.caps))) {
> -		printk(KERN_WARNING "DVB: adapter %i frontend %i modulation %u not supported\n",
> -		       fe->dvb->num, fe->id, parms->u.qam.modulation);
> +	/*
> +	 * check for supported modulation
> +	 *
> +	 * This is currently hacky. Also, it only works for DVB-S & friends,
> +	 * and not all modulations has FE_CAN flags
> +	 */
> +	switch (c->delivery_system) {
> +	case SYS_DVBS:
> +	case SYS_DVBS2:
> +	case SYS_TURBO:
> +		if ((c->modulation > QAM_AUTO ||
> +		    !((1 << (c->modulation + 10)) & fe->ops.info.caps))) {
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +			printk(KERN_WARNING
> +			       "DVB: adapter %i frontend %i modulation %u not supported\n",
> +			       fe->dvb->num, fe->id, c->modulation);
>  			return -EINVAL;
> +		}
> +		break;
> ...

This code is completely bogus: I get tons of warnings, if vdr tries to
tune to DVB-S2 (modulation == 9 == PSK_8) on my stv090x.

PSK_8 == 9 is > QAM_AUTO, and the shift operation does not make much
sense, except for modulation == 0 == QPSK.

The original version makes more sense for me.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
