Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab1G0OfU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 10:35:20 -0400
Message-ID: <4E302207.8050409@redhat.com>
Date: Wed, 27 Jul 2011 11:34:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alina Friedrichsen <x-alina@gmx.net>
CC: linux-media@vger.kernel.org, rglowery@exemail.com.au
Subject: Re: [PATCH v3] tuner_xc2028: Allow selection of the frequency adjustment
 code for XC3028
References: <20110722183552.169950@gmx.net>
In-Reply-To: <20110722183552.169950@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alina,

Em 22-07-2011 15:35, Alina Friedrichsen escreveu:
> Since many, many kernel releases my Hauppauge WinTV HVR-1400 doesn't work
> anymore, and nobody feels responsible to fix it.

No. The problem is that fixing it would require someone to travel around the
globe with several different boards, in order to see how the driver works on 
each Country (or having a DTV generator capable of simulating the Country
differences on a reliable way). In particular, Australia requires a different
setting than Europe. The code tries to figure out that, but I'm starting to 
suspect that with a few demods, such adjustments are different.

Btw, what's the video standard that you're using? DTV7? Does your device use
a xc3028 or xc3028xl? Whats's your demod and board?

> The code to get it work is still in there, it's only commented out.
> My patch to enable it was rejected, because somebody had fear that it could
> break other cards.
> So here is a new patch, that allows you to select the frequency adjustment
> code by a module parameter. Default is the old code, so it can't break
> anything.
> 
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff -urN linux-3.0.orig/drivers/media/common/tuners/tuner-xc2028.c linux-3.0/drivers/media/common/tuners/tuner-xc2028.c
> --- linux-3.0.orig/drivers/media/common/tuners/tuner-xc2028.c	2011-07-22 04:17:23.000000000 +0200
> +++ linux-3.0/drivers/media/common/tuners/tuner-xc2028.c	2011-07-22 20:15:08.212540252 +0200
> @@ -54,6 +54,11 @@
>  MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the "
>  				"default firmware name\n");
>  
> +static int freq_magic;
> +module_param(freq_magic, int, 0644);
> +MODULE_PARM_DESC(freq_magic, "Selects the frequency adjustment code "
> +			     "for XC3028. Set it to 1 if tuning fails.");

While I really prefer to fix the code, I might accept a hack like that, if
better named, and properly described. It is more like an alternate way 
to set the tuner, and for sure it won't solve all cases where the tuning
fails.

AFAIK, the driver only has problem with DTV7. So, the hack should not be applied
for other standards.


> +
>  static LIST_HEAD(hybrid_tuner_instance_list);
>  static DEFINE_MUTEX(xc2028_list_mutex);
>  
> @@ -967,34 +972,36 @@
>  		 * newer firmwares
>  		 */
>  
> -#if 1
> -		/*
> -		 * The proper adjustment would be to do it at s-code table.
> -		 * However, this didn't work, as reported by
> -		 * Robert Lowery <rglowery@exemail.com.au>
> -		 */
> -
> -		if (priv->cur_fw.type & DTV7)
> -			offset += 500000;
> -
> -#else
> -		/*
> -		 * Still need tests for XC3028L (firmware 3.2 or upper)
> -		 * So, for now, let's just comment the per-firmware
> -		 * version of this change. Reports with xc3028l working
> -		 * with and without the lines bellow are welcome
> -		 */
> +		if (!freq_magic) {
> +			/*
> +			 * The proper adjustment would be to do it at s-code
> +			 * table. However, this didn't work, as reported by
> +			 * Robert Lowery <rglowery@exemail.com.au>
> +			 */
>  
> -		if (priv->firm_version < 0x0302) {
>  			if (priv->cur_fw.type & DTV7)
>  				offset += 500000;
> +
>  		} else {
> -			if (priv->cur_fw.type & DTV7)
> -				offset -= 300000;
> -			else if (type != ATSC) /* DVB @6MHz, DTV 8 and DTV 7/8 */
> -				offset += 200000;
> +			/*
> +			 * Still need tests for XC3028L (firmware 3.2 or upper)
> +			 * So, for now, let's just comment the per-firmware
> +			 * version of this change. Reports with xc3028l working
> +			 * with and without the lines bellow are welcome
> +			 */
> +
> +			if (priv->firm_version < 0x0302) {
> +				if (priv->cur_fw.type & DTV7)
> +					offset += 500000;
> +			} else {
> +				if (priv->cur_fw.type & DTV7)
> +					offset -= 300000;
> +				else if (type != ATSC) {
> +					/* DVB @6MHz, DTV 8 and DTV 7/8 */
> +					offset += 200000;
> +				}
> +			}
>  		}
> -#endif
>  	}
>  
>  	div = (freq - offset + DIV / 2) / DIV;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

