Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48132 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbcBLQcb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 11:32:31 -0500
Date: Fri, 12 Feb 2016 14:32:20 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Nicolas Pitre <nicolas.pitre@linaro.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] zl10353: use div_u64 instead of do_div
Message-ID: <20160212143220.5a440e66@recife.lan>
In-Reply-To: <1455287246-3540549-1-git-send-email-arnd@arndb.de>
References: <1455287246-3540549-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 12 Feb 2016 15:27:18 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> I noticed a build error in some randconfig builds in the zl10353 driver:
> 
> dvb-frontends/zl10353.c:138: undefined reference to `____ilog2_NaN'
> dvb-frontends/zl10353.c:138: undefined reference to `__aeabi_uldivmod'
> 
> The problem can be tracked down to the use of -fprofile-arcs (using
> CONFIG_GCOV_PROFILE_ALL) in combination with CONFIG_PROFILE_ALL_BRANCHES
> on gcc version 4.9 or higher, when it fails to reliably optimize
> constant expressions.
> 
> Using div_u64() instead of do_div() makes the code slightly more
> readable by both humans and by gcc, which gives the compiler enough
> of a break to figure it all out.

I'm not against this patch, but we have 94 occurrences of do_div() 
just at the media subsystem. If this is failing here, it would likely
fail with other drivers. So, I guess we should either fix do_div() or
convert all such occurrences to do_div64().

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/dvb-frontends/zl10353.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
> index ef9764a02d4c..160c88710553 100644
> --- a/drivers/media/dvb-frontends/zl10353.c
> +++ b/drivers/media/dvb-frontends/zl10353.c
> @@ -135,8 +135,7 @@ static void zl10353_calc_nominal_rate(struct dvb_frontend *fe,
>  
>  	value = (u64)10 * (1 << 23) / 7 * 125;
>  	value = (bw * value) + adc_clock / 2;
> -	do_div(value, adc_clock);
> -	*nominal_rate = value;
> +	*nominal_rate = div_u64(value, adc_clock);
>  
>  	dprintk("%s: bw %d, adc_clock %d => 0x%x\n",
>  		__func__, bw, adc_clock, *nominal_rate);
> @@ -163,8 +162,7 @@ static void zl10353_calc_input_freq(struct dvb_frontend *fe,
>  		if (ife > adc_clock / 2)
>  			ife = adc_clock - ife;
>  	}
> -	value = (u64)65536 * ife + adc_clock / 2;
> -	do_div(value, adc_clock);
> +	value = div_u64((u64)65536 * ife + adc_clock / 2, adc_clock);
>  	*input_freq = -value;
>  
>  	dprintk("%s: if2 %d, ife %d, adc_clock %d => %d / 0x%x\n",
