Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:65284 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaJ0RLJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 13:11:09 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NE400D2052KXHA0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Oct 2014 13:11:08 -0400 (EDT)
Date: Mon, 27 Oct 2014 15:11:04 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 6/7] v4l-utils/libdvbv5: don't discard config-supplied
 parameters
Message-id: <20141027151104.427630df.m.chehab@samsung.com>
In-reply-to: <1414323983-15996-7-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-7-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Oct 2014 20:46:22 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> When an user enabled the option to update parameters with PSI,
> the parameters that were supplied from config file and  not mandatory
> to the delivery system were discarded.

Sorry, but I was unable to understand what you're meaning.

> ---
>  lib/libdvbv5/dvb-fe.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
> index 05f7d03..52af4e4 100644
> --- a/lib/libdvbv5/dvb-fe.c
> +++ b/lib/libdvbv5/dvb-fe.c
> @@ -575,6 +575,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
>  	int i, n = 0;
>  	const unsigned int *sys_props;
>  	struct dtv_properties prop;
> +	struct dtv_property fe_prop[DTV_MAX_COMMAND];
>  	struct dvb_frontend_parameters v3_parms;
>  	uint32_t bw;
>  
> @@ -583,19 +584,14 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
>  		return EINVAL;
>  
>  	while (sys_props[n]) {
> -		parms->dvb_prop[n].cmd = sys_props[n];
> +		fe_prop[n].cmd = sys_props[n];
>  		n++;
>  	}
> -	parms->dvb_prop[n].cmd = DTV_DELIVERY_SYSTEM;
> -	parms->dvb_prop[n].u.data = parms->p.current_sys;
> +	fe_prop[n].cmd = DTV_DELIVERY_SYSTEM;
> +	fe_prop[n].u.data = parms->p.current_sys;
>  	n++;
>  
> -	/* Keep it ready for set */
> -	parms->dvb_prop[n].cmd = DTV_TUNE;
> -	parms->n_props = n;
> -
> -	struct dtv_property fe_prop[DTV_MAX_COMMAND];
> -	n = dvb_copy_fe_props(parms->dvb_prop, n, fe_prop);
> +	n = dvb_copy_fe_props(fe_prop, n, fe_prop);

Huh? this looks weird.

>  
>  	prop.props = fe_prop;
>  	prop.num = n;
