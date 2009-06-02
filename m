Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60452 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbZFAX7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 19:59:14 -0400
Subject: Re: [hg:v4l-dvb] tuner-xc2028: Fix offset frequencies for DVB @
 6MHz
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab via Mercurial <mchehab@redhat.com>
Cc: Terry Wu <terrywu2009@gmail.com>, linux-media@vger.kernel.org,
	mchehab@infradead.org
In-Reply-To: <E1MB9Iw-0003dl-Fe@mail.linuxtv.org>
References: <E1MB9Iw-0003dl-Fe@mail.linuxtv.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 20:00:33 -0400
Message-Id: <1243900833.3959.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-01 at 17:20 +0200, Patch from Mauro Carvalho Chehab
wrote:
> The patch number 11918 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------
> 
> From: Mauro Carvalho Chehab  <mchehab@redhat.com>
> tuner-xc2028: Fix offset frequencies for DVB @ 6MHz
> 
> 
> Both ATSC and DVB @ 6MHz bandwidth require the same offset.
> 
> While we're fixing it, let's cleanup the bandwidth setup to better
> reflect the fact that it is a function of the bandwidth.
> 
> Thanks to Terry Wu <terrywu2009@gmail.com> for pointing this issue and
> to Andy Walls <awalls@radix.net> for an initial patch for this fix.
> 
> Priority: normal
> 
> CC: Terry Wu <terrywu2009@gmail.com>
> CC: Andy Walls <awalls@radix.net>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Andy Walls <awalls@radix.net>

You may want to emphasize with a comment that 'offset = 0' is used for
T_ANALOG_TV.  It's somewhat hidden by its initialization early in the
function.

Italy also appears to use 7 MHz VHF and 8 MHz UHF.

Regards,
Andy

> ---
> 
>  linux/drivers/media/common/tuners/tuner-xc2028.c |   32 ++++++++-------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff -r c78c18fe3dc9 -r e6a8672631a0 linux/drivers/media/common/tuners/tuner-xc2028.c
> --- a/linux/drivers/media/common/tuners/tuner-xc2028.c	Mon Jun 01 11:46:08 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c	Mon Jun 01 12:18:10 2009 -0300
> @@ -921,22 +921,28 @@ static int generic_set_freq(struct dvb_f
>  	 * that xc2028 will be in a safe state.
>  	 * Maybe this might also be needed for DTV.
>  	 */
> -	if (new_mode == T_ANALOG_TV) {
> +	if (new_mode == T_ANALOG_TV)
>  		rc = send_seq(priv, {0x00, 0x00});
> -	} else if (priv->cur_fw.type & ATSC) {
> -		offset = 1750000;
> -	} else {
> -		offset = 2750000;
> +
> +	/*
> +	 * Digital modes require an offset to adjust to the
> +	 * proper frequency
> +	 */
> +	if (new_mode != T_ANALOG_TV) {
> +		/* Sets the offset according with firmware */
> +		if (priv->cur_fw.type & DTV6)
> +			offset = 1750000;
> +		if (priv->cur_fw.type & DTV7)
> +			offset = 2250000;
> +		else	/* DTV8 or DTV78 */
> +			offset = 2750000;
> +
>  		/*
> -		 * We must adjust the offset by 500kHz in two cases in order
> -		 * to correctly center the IF output:
> -		 * 1) When the ZARLINK456 or DIBCOM52 tables were explicitly
> -		 *    selected and a 7MHz channel is tuned;
> -		 * 2) When tuning a VHF channel with DTV78 firmware.
> +		 * We must adjust the offset by 500kHz  when
> +		 * tuning a 7MHz VHF channel with DTV78 firmware
> +		 * (used in Australia)
>  		 */
> -		if (((priv->cur_fw.type & DTV7) &&
> -		     (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
> -		    ((priv->cur_fw.type & DTV78) && freq < 470000000))
> +		if ((priv->cur_fw.type & DTV78) && freq < 470000000)
>  			offset -= 500000;
>  	}
>  
> 
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/e6a8672631a0f5f549f5ee5db3acac4f35013942
> 

