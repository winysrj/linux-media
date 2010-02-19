Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:42522 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008Ab0BSUWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 15:22:33 -0500
Message-ID: <4B7EF2DD.7070509@arcor.de>
Date: Fri, 19 Feb 2010 21:21:49 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/master] V4L/DVB: tuner-xc2028: fix tuning logic
 to solve a regression in Australia
References: <E1NiVOP-0004ij-2F@www.linuxtv.org>
In-Reply-To: <E1NiVOP-0004ij-2F@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.02.2010 17:07, schrieb Patch from Mauro Carvalho Chehab:
>  	}
>  
>  	div = (freq - offset + DIV / 2) / DIV;
> @@ -1114,17 +1152,22 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>  
>  	/* All S-code tables need a 200kHz shift */
>  	if (priv->ctrl.demod) {
> -		demod = priv->ctrl.demod + 200;
> +		/*
> +		 * Newer firmwares require a 200 kHz offset only for ATSC
> +		 */
> +		if (type == ATSC || priv->firm_version < 0x0302)
> +			demod = priv->ctrl.demod + 200;
>  		/*
>  		 * The DTV7 S-code table needs a 700 kHz shift.
> -		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
>  		 *
>  		 * DTV7 is only used in Australia.  Germany or Italy may also
>  		 * use this firmware after initialization, but a tune to a UHF
>  		 * channel should then cause DTV78 to be used.
> +		 *
> +		 * Unfortunately, on real-field tests, the s-code offset
> +		 * didn't work as expected, as reported by
> +		 * Robert Lowery <rglowery@exemail.com.au>
>  		 */
> -		if (type & DTV7)
> -			demod += 500;
>  	}
>  
>  	return generic_set_freq(fe, p->frequency,
>   
Hi Mauro,

your patch doesn't work. Here is not set demod for all others (demod=0).

-- 
Stefan Ringel <stefan.ringel@arcor.de>

