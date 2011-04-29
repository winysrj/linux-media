Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab1D2NsT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 09:48:19 -0400
Message-ID: <4DBAC19F.7010003@redhat.com>
Date: Fri, 29 Apr 2011 10:48:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steffen Barszus <steffenbpunkt@googlemail.com>
CC: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: patches missing in git ? - TT S2 1600
References: <20110306142020.7fe695ca@grobi>
In-Reply-To: <20110306142020.7fe695ca@grobi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-03-2011 10:20, Steffen Barszus escreveu:
> I have one patch lying around which will fix a kernel oops if more than
> one TT S2 1600 is build into the same computer. 

I think that the bug with two TT S2 devices at the same computer were fixed,
but I don't remember what were the adopted solution.

I think that the change were inside tuner_sleep() callback, where tuner_priv
is actually used.

So, as far as I know, this patch is obsolete. I'll mark it as rejected on
patchwork. Please test it without this patch and the latest tree, pinging
us if the error is still there.

> 
> It still applies and compiles - does someone know if this has been
> obsoleted by another patch or if that means it is still missing ? 
> 
> Thanks !
> 
> Kind Regards 
> 
> Steffen
> 
> diff -r 7c0b887911cf linux/drivers/media/dvb/frontends/stv090x.c
> --- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Apr 05 22:56:43 2010 -0400
> +++ b/linux/drivers/media/dvb/frontends/stv090x.c	Sun Apr 11 13:46:43 2010 +0200
> @@ -4664,7 +4664,7 @@ 
>  	if (stv090x_i2c_gate_ctrl(state, 1) < 0)
>  		goto err;
>  
> -	if (state->config->tuner_sleep) {
> +	if (fe->tuner_priv && state->config->tuner_sleep) {
>  		if (state->config->tuner_sleep(fe) < 0)
>  			goto err_gateoff;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

