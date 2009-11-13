Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47018 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbZKMKKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 05:10:00 -0500
Message-ID: <4AFD306F.1020802@s5r6.in-berlin.de>
Date: Fri, 13 Nov 2009 11:09:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firedtv: fix regression: tuning fails due to bogus error
 return
References: <4ADA149E.1070704@s5r6.in-berlin.de> <4ADA26D0.6010108@s5r6.in-berlin.de> <tkrat.de5abfc32fa5476d@s5r6.in-berlin.de>
In-Reply-To: <tkrat.de5abfc32fa5476d@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote on 2009-10-17:
> Since 2.6.32(-rc1), DVB core checks the return value of
> dvb_frontend_ops.set_frontend.  Now it becomes apparent that firedtv
> always returned a bogus value from its set_frontend method.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Hi Mauro,

when you committed this, you added "CC: stable@kernel.org".  This is not
necessary, 2.6.32-rc1 is the first kernel version with the regression
(see changelog).

Well, OK, the patch would become necessary in -stable if somebody was to
put the new set_frontend return code check in dvb core into -stable. But
I hope nobody is going to do that; it'd be a bad idea.

Furthermore...

> ---
>  drivers/media/dvb/firewire/firedtv-avc.c |    7 +++++--
>  drivers/media/dvb/firewire/firedtv-fe.c  |    8 +-------
>  2 files changed, 6 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-avc.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/media/dvb/firewire/firedtv-avc.c
> +++ linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-avc.c
> @@ -573,8 +573,11 @@ int avc_tuner_dsd(struct firedtv *fdtv,
>  
>  	msleep(500);
>  #if 0
> -	/* FIXME: */
> -	/* u8 *status was an out-parameter of avc_tuner_dsd, unused by caller */
> +	/*
> +	 * FIXME:
> +	 * u8 *status was an out-parameter of avc_tuner_dsd, unused by caller
> +	 * Check for AVC_RESPONSE_ACCEPTED here instead?
> +	 */
>  	if (status)
>  		*status = r->operand[2];
>  #endif

...the firedtv-avc.c part of the patch vanished when you committed it. I
guess this was accident, not deliberate --- otherwise a note in the
changelog below of my Signed-off-by would have been appreciated.

I will resubmit this missing comment change or a variation of it or even
a fix of the FIXME sometime in the future.

> Index: linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-fe.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/media/dvb/firewire/firedtv-fe.c
> +++ linux-2.6.32-rc5/drivers/media/dvb/firewire/firedtv-fe.c
> @@ -141,18 +141,12 @@ static int fdtv_read_uncorrected_blocks(
>  	return -EOPNOTSUPP;
>  }
>  
> -#define ACCEPTED 0x9
> -
>  static int fdtv_set_frontend(struct dvb_frontend *fe,
>  			     struct dvb_frontend_parameters *params)
>  {
>  	struct firedtv *fdtv = fe->sec_priv;
>  
> -	/* FIXME: avc_tuner_dsd never returns ACCEPTED. Check status? */
> -	if (avc_tuner_dsd(fdtv, params) != ACCEPTED)
> -		return -EINVAL;
> -	else
> -		return 0; /* not sure of this... */
> +	return avc_tuner_dsd(fdtv, params);
>  }
>  
>  static int fdtv_get_frontend(struct dvb_frontend *fe,
> 

-- 
Stefan Richter
-=====-==--= =-== -==-=
http://arcgraph.de/sr/
