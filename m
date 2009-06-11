Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbZFKUBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 16:01:23 -0400
Date: Thu, 11 Jun 2009 17:01:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Terry Wu <terrywu2009@gmail.com>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [PATCH v2] tuner-xc2028: Fix 7 MHz DVB-T
Message-ID: <20090611170120.2a0d7179@pedra.chehab.org>
In-Reply-To: <1244717870.3158.22.camel@palomino.walls.org>
References: <1244717870.3158.22.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Jun 2009 06:57:50 -0400
Andy Walls <awalls@radix.net> escreveu:

> All,
> 
> The following patch should fix 7 MHz DVB-T with the XC3028 using the
> DTV7 firmware from the xc3028-v27.fw firmware image.

DTV7 and DTV78 support were added and tested in Australia by Christopher
Pascoe, as can be seen on his tree that it is known to work in Australia:

	http://linuxtv.org/hg/~pascoe/xc-test/file/d4f7804a393c/linux/drivers/media/video/tuner-xc2028.c

On that time, he did some experimental tests and observed what should be the
real offset.

His code does this:

} else { /* DTV */
	offset = 27500000;
+	/*
+	 * We must adjust the offset by 500kHz in two cases in order
+	 * to correctly center the IF output:
+	 * 1) When the ZARLINK456 or DIBCOM52 tables were explicitly
+	 *    selected and a 7MHz channel is tuned;
+	 * 2) When tuning a VHF channel with DTV78 firmware.
+	 */
+	if (((priv->cur_fw.type & DTV7) &&
+	     (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
+	    ((priv->cur_fw.type & DTV78) && freq < 470000000))
		offset -= 500000; 

So, it selects ZARLINK456 or DIBCOM52, depending on the demod IF, and corrects
the offset to be 2250000Hz for DTV7 or DTV78 firmwares and VHF.

This is exactly what we're doing with the current code:

                else if (priv->cur_fw.type & DTV7)
                        offset = 2250000;
                else    /* DTV8 or DTV78 */
                        offset = 2750000;

                /*
                 * We must adjust the offset by 500kHz  when
                 * tuning a 7MHz VHF channel with DTV78 firmware
                 * (used in Australia, Italy and Germany)
                 */
                if ((priv->cur_fw.type & DTV78) && freq < 470000000)
                        offset -= 500000;

So, I suspect that the current code is correct.

For us to double check if any other change at the code didn't break for
Australia (and other DTV7/DTV78 countries), it would be really cool if people
could report about success or failure with tuner xc3028 on those countries.

For now, I'll mark this patch as RFC at patchwork.

Unfortunately, we've lost the contact with Christopher, since AFAIK, he moved
to another country.

Cheers,
Mauro.

> 
> Comments?
> 
> Regards,
> Andy Walls
> 
> Signed-off-by: Andy Walls <awalls@radix.net>
> Tested-by: Terry Wu <terrywu2009@gmail.com>
> 
> diff -r fad35ab59848 linux/drivers/media/common/tuners/tuner-xc2028.c
> --- a/linux/drivers/media/common/tuners/tuner-xc2028.c	Fri Jun 05 08:42:27 2009 -0400
> +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c	Thu Jun 11 06:52:55 2009 -0400
> @@ -1099,8 +1099,19 @@
>  	}
>  
>  	/* All S-code tables need a 200kHz shift */
> -	if (priv->ctrl.demod)
> +	if (priv->ctrl.demod) {
>  		demod = priv->ctrl.demod + 200;
> +		/*
> +		 * The DTV7 S-code table needs a 700 kHz shift.
> +		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
> +		 *
> +		 * DTV7 is only used in Australia.  Germany or Italy may also
> +		 * use this firmware after initialization, but a tune to a UHF
> +		 * channel should then cause DTV78 to be used.
> +		 */
> +		if (type & DTV7)
> +			demod += 500;
> +	}
>  
>  	return generic_set_freq(fe, p->frequency,
>  				T_DIGITAL_TV, type, 0, demod);
> 
> 




Cheers,
Mauro
