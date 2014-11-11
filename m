Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44295 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbaKKK2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 05:28:42 -0500
Date: Tue, 11 Nov 2014 08:28:38 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Joerg Riechardt <J.Riechardt@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] stv090x: use lookup tables for carrier/noise ratio
Message-ID: <20141111082838.05369439@recife.lan>
In-Reply-To: <5238E030.8040203@gmx.de>
References: <5238E030.8040203@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 18 Sep 2013 01:05:20 +0200
Joerg Riechardt <J.Riechardt@gmx.de> escreveu:

> The stv090x driver uses the lookup table for signal strength already, 
> with this patch we use the lookup tables for carrier/noise ratio as well.
> This has the advantage, that values for DVB-S and DVB-S2 are now 
> corresponding, while before they were way off. The values are now 
> proportional to real carrier/noise ratio, while before they were 
> corresponding to register values. So now applications are able to give 
> the user real carrier/noise ratio.
> 
> Because the output has to be within 0x0000...0xFFFF the three negative 
> values for DVB-S2 are omitted. This is no significant loss, because 
> reception is lost at 7.5 dB already (TT S2-1600, Cine S2), so the 
> negative values are not really important, and also for DVB-S they don´t 
> exist.
> 
> Signed-off-by: Joerg Riechardt <j.riechardt@gmx.de>
> 
> Regards,
> Joerg
> 
> --- stv090x.c.bak	2013-09-06 20:59:01.132365872 +0200
> +++ stv090x.c	2013-09-10 03:21:48.884115191 +0200
> @@ -173,9 +173,9 @@
>  
>  /* DVBS2 C/N Lookup table */
>  static const struct stv090x_tab stv090x_s2cn_tab[] = {
> -	{ -30, 13348 }, /* -3.0dB */
> -	{ -20, 12640 }, /* -2d.0B */
> -	{ -10, 11883 }, /* -1.0dB */
> +//	{ -30, 13348 }, /* -3.0dB */
> +//	{ -20, 12640 }, /* -2d.0B */
> +//	{ -10, 11883 }, /* -1.0dB */
>  	{   0, 11101 }, /* -0.0dB */
>  	{   5, 10718 }, /*  0.5dB */
>  	{  10, 10339 }, /*  1.0dB */

Instead of commenting, just truncate the value at the DVBv3 stats
function.

> @@ -3697,9 +3697,10 @@
>  			}
>  			val /= 16;
>  			last = ARRAY_SIZE(stv090x_s2cn_tab) - 1;
> -			div = stv090x_s2cn_tab[0].read -
> -			      stv090x_s2cn_tab[last].read;
> -			*cnr = 0xFFFF - ((val * 0xFFFF) / div);
> +			div = stv090x_s2cn_tab[last].real -
> +			      stv090x_s2cn_tab[0].real;
> +			val = stv090x_table_lookup(stv090x_s2cn_tab, last, val);
> +			*cnr = val * 0xFFFF / div;
>  		}
>  		break;
>  
> @@ -3719,9 +3720,10 @@
>  			}
>  			val /= 16;
>  			last = ARRAY_SIZE(stv090x_s1cn_tab) - 1;
> -			div = stv090x_s1cn_tab[0].read -
> -			      stv090x_s1cn_tab[last].read;
> -			*cnr = 0xFFFF - ((val * 0xFFFF) / div);
> +			div = stv090x_s1cn_tab[last].real -
> +			      stv090x_s1cn_tab[0].real;
> +			val = stv090x_table_lookup(stv090x_s1cn_tab, last, val);
> +			*cnr = val * 0xFFFF / div;
>  		}

As, with this patch, C/N will be a properly scaled value, the best
is to add support for DVBv5 stats. With DVBv5 stats, the scale can
be sent to userspace.

>  		break;
>  	default:

Regards,
Mauro
