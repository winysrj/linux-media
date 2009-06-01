Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60401 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbZFAX4R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 19:56:17 -0400
Subject: Re: [hg:v4l-dvb] Fix firmware load for DVB-T @ 6MHz
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab via Mercurial <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Terry Wu <terrywu2009@gmail.com>,
	mchehab@infradead.org
In-Reply-To: <E1MB9Iw-0003dY-4q@mail.linuxtv.org>
References: <E1MB9Iw-0003dY-4q@mail.linuxtv.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 19:56:39 -0400
Message-Id: <1243900599.3959.9.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-01 at 17:20 +0200, Patch from Mauro Carvalho Chehab
wrote:
> The patch number 11917 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
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
> Fix firmware load for DVB-T @ 6MHz
> 
> 
> bandwidth for xc3028/xc3028L
> 
> 
> The only two countries that are known to use 6MHz bandwidth are Taiwan
> and Uruguay. Both use QAM subcarriers at OFTM.
> 
> This patch fixes the firmware load for such countries, where the
> required firmware is the QAM one.
> 
> This also confirms the previous tests where it was noticed that the 6MHz
> QAM firmware doesn't work for cable. So, this patch also removes support
> for DVB-C, instead of just printing a warning.
> 
> Thanks to Terry Wu <terrywu2009@gmail.com> for pointing this issue and
> to Andy Walls <awalls@radix.net> for an initial patch for this fix.
> 
> Priority: normal
> 
> CC: Terry Wu <terrywu2009@gmail.com>
> CC: Andy Walls <awalls@radix.net>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 

Acked-by: Andy Walls <awalls@radix.net>

I looks like it accomplishes the 6 MHz DVB-T support in
xc2028_set_params() that Terry needed.  I personally wouldn't have
disabled the FE_QAM stuff.  However it doesn't matter as far as current
Linux driver use of the XC3028 is concerned - no driver currently sets
up the XC3028 with a DVB-C demod.

Regards,
Andy

> ---
> 
>  linux/drivers/media/common/tuners/tuner-xc2028.c |   17 +++++++--------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff -r d55ec37bebfa -r c78c18fe3dc9 linux/drivers/media/common/tuners/tuner-xc2028.c
> --- a/linux/drivers/media/common/tuners/tuner-xc2028.c	Mon Jun 01 05:22:37 2009 -0300
> +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c	Mon Jun 01 11:46:08 2009 -0300
> @@ -1026,21 +1026,20 @@ static int xc2028_set_params(struct dvb_
>  	switch(fe->ops.info.type) {
>  	case FE_OFDM:
>  		bw = p->u.ofdm.bandwidth;
> -		break;
> -	case FE_QAM:
> -		tuner_info("WARN: There are some reports that "
> -			   "QAM 6 MHz doesn't work.\n"
> -			   "If this works for you, please report by "
> -			   "e-mail to: v4l-dvb-maintainer@linuxtv.org\n");
> -		bw = BANDWIDTH_6_MHZ;
> -		type |= QAM;
> +		/*
> +		 * The only countries with 6MHz seem to be Taiwan/Uruguay.
> +		 * Both seem to require QAM firmware for OFDM decoding
> +		 * Tested in Taiwan by Terry Wu <terrywu2009@gmail.com>
> +		 */
> +		if (bw == BANDWIDTH_6_MHZ)
> +			type |= QAM;
>  		break;
>  	case FE_ATSC:
>  		bw = BANDWIDTH_6_MHZ;
>  		/* The only ATSC firmware (at least on v2.7) is D2633 */
>  		type |= ATSC | D2633;
>  		break;
> -	/* DVB-S is not supported */
> +	/* DVB-S and pure QAM (FE_QAM) are not supported */
>  	default:
>  		return -EINVAL;
>  	}
> 
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/c78c18fe3dc9f1338a589130c4eeed14c1d90b44
> 

