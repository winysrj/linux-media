Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:46035 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaJHQFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 12:05:43 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400AGSVDIPYA0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 12:05:42 -0400 (EDT)
Date: Wed, 08 Oct 2014 13:05:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] v4l-utils/libdvbv5: avoid crash when failed to get a
 channel name
Message-id: <20141008130538.30430bdd.m.chehab@samsung.com>
In-reply-to: <1412770181-5420-2-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
 <1412770181-5420-2-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Oct 2014 21:09:38 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  lib/libdvbv5/dvb-file.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
> index 27d9a63..bcb1762 100644
> --- a/lib/libdvbv5/dvb-file.c
> +++ b/lib/libdvbv5/dvb-file.c
> @@ -1121,20 +1121,21 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
>  		if (rc)
>  			dvb_logerr("Couldn't get frontend props");
>  	}
> -	if (!*channel) {
> -		r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
> -		if (r < 0)
> -			dvb_perror("asprintf");
> -		if (parms->p.verbose)
> -			dvb_log("Storing as: '%s'", channel);
> -	}

I prefer to keep the code as is and fix the caller that would be passing
a null pointer here, replacing it for an empty channel name.

>  	for (j = 0; j < parms->n_props; j++) {
>  		entry->props[j].cmd = parms->dvb_prop[j].cmd;
>  		entry->props[j].u.data = parms->dvb_prop[j].u.data;
>  
> -		if (!*channel && entry->props[j].cmd == DTV_FREQUENCY)
> +		if ((!channel || !*channel) &&
> +		    entry->props[j].cmd == DTV_FREQUENCY)
>  			freq = parms->dvb_prop[j].u.data;
>  	}
> +	if (!channel || !*channel) {
> +		r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
> +		if (r < 0)
> +			dvb_perror("asprintf");
> +		if (parms->p.verbose)
> +			dvb_log("Storing as: '%s'", channel);
> +	}
>  	entry->n_props = parms->n_props;
>  	entry->channel = channel;
>  
