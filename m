Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54150 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbZE2LHZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 07:07:25 -0400
Subject: Re: [PATCH] cx18: Use do_div for 64-bit division to fix 32-bit
 kernels
From: Andy Walls <awalls@radix.net>
To: David Ward <david.ward@gatech.edu>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4A1F2BFB.6010109@gatech.edu>
References: <4A1F2BFB.6010109@gatech.edu>
Content-Type: text/plain
Date: Fri, 29 May 2009 07:09:04 -0400
Message-Id: <1243595344.3139.5.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-05-28 at 20:27 -0400, David Ward wrote:
> Use the do_div macro for 64-bit division.  Otherwise, the module will 
> reference __udivdi3 under 32-bit kernels, which is not allowed in kernel 
> space.  Follows style used in cx88 module.

Ooopsie.  Thanks for catching this and providing a fix. :)

(FYI, You would have caught my attention earlier if you had put "cx18:"
in the subject line of the initital report.)

I'll test it tonight on my 64 bit machine, commit it, and ask Mauro to
pull it.  I assume you've tested it on your 32 bit machine.

Regards,
Andy

> Signed-off-by: David Ward <david.ward@gatech.edu>
> 
> diff -r 65ec132f20df -r 91b89f13adb7 
> linux/drivers/media/video/cx18/cx18-av-core.c
> --- a/linux/drivers/media/video/cx18/cx18-av-core.c    Wed May 27 
> 15:53:00 2009 -0300
> +++ b/linux/drivers/media/video/cx18/cx18-av-core.c    Thu May 28 
> 19:16:10 2009 -0400
> @@ -447,6 +447,7 @@ void cx18_av_std_setup(struct cx18 *cx)
> 
>       if (pll_post) {
>           int fsc, pll;
> +        u64 tmp64;
> 
>           pll = (28636360L * ((((u64)pll_int) << 25) + pll_frac)) >> 25;
>           pll /= pll_post;
> @@ -459,7 +460,9 @@ void cx18_av_std_setup(struct cx18 *cx)
>                       "= %d.%03d\n", src_decimation / 256,
>                       ((src_decimation % 256) * 1000) / 256);
> 
> -        fsc = ((((u64)sc) * 28636360)/src_decimation) >> 13L;
> +        tmp64 = ((u64)sc) * 28636360;
> +        do_div(tmp64, src_decimation);
> +        fsc = ((u32)(tmp64 >> 13L));
>           CX18_DEBUG_INFO_DEV(sd,
>                       "Chroma sub-carrier initial freq = %d.%06d "
>                       "MHz\n", fsc / 1000000, fsc % 1000000);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

