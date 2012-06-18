Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2FRW2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 18:28:45 -0400
Message-ID: <4FDFAB96.70006@redhat.com>
Date: Mon, 18 Jun 2012 19:28:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB: stb0899: speed up getting BER values
References: <4FCA2B71.7060700@tvdr.de>
In-Reply-To: <4FCA2B71.7060700@tvdr.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 02-06-2012 12:04, Klaus Schmidinger escreveu:
> stb0899_read_ber() takes 500ms (half a second!) to deliver the current
> BER value. Apparently it takes 5 subsequent readings, with a 100ms pause
> between them (and even before the first one). This is a real performance
> brake if an application freqeuently reads the BER of several devices.
> The attached patch reduces this to a single reading, with no more pausing.
> I didn't observe any negative side effects of this change.

Yeah, waiting 0,5 s inside an ioctl is not right, especially if the driver is
in non-blocking mode. As the code doesn't check for it, the logic there is
obviously wrong.

If reading it 5 times with a delayed interval of 100ms is needed, then the right
thing to do would be to use a deferred work that could be started either after
having tuning lock or at the first time this is called, caching the result inside
state struct and returning EAGAIN while the result is not available.

Manu,

I'll apply this patch, as it fixes a POSIX non-compliance, and can cause some
issues at userspace apps. Feel free to change it later to address it via a
deferred work, if you think that this fix is not complete.

Regards,
Mauro.

> 
> Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
> 
> Klaus
> 
> 04-stb0899-ber_no_msleep.diff
> 
> 
> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	2012-04-23 15:10:35.994008188 +0200
> +++ a/linux/drivers/media/dvb/frontends/stb0899_drv.c	2012-04-23 15:29:40.544837905 +0200
> @@ -1135,7 +1135,6 @@
>   	struct stb0899_internal *internal	= &state->internal;
>   
>   	u8  lsb, msb;
> -	u32 i;
>   
>   	*ber = 0;
>   
> @@ -1143,14 +1142,9 @@
>   	case SYS_DVBS:
>   	case SYS_DSS:
>   		if (internal->lock) {
> -			/* average 5 BER values	*/
> -			for (i = 0; i < 5; i++) {
> -				msleep(100);
> -				lsb = stb0899_read_reg(state, STB0899_ECNT1L);
> -				msb = stb0899_read_reg(state, STB0899_ECNT1M);
> -				*ber += MAKEWORD16(msb, lsb);
> -			}
> -			*ber /= 5;
> +			lsb = stb0899_read_reg(state, STB0899_ECNT1L);
> +			msb = stb0899_read_reg(state, STB0899_ECNT1M);
> +			*ber = MAKEWORD16(msb, lsb);
>   			/* Viterbi Check	*/
>   			if (STB0899_GETFIELD(VSTATUS_PRFVIT, internal->v_status)) {
>   				/* Error Rate		*/
> @@ -1163,13 +1157,9 @@
>   		break;
>   	case SYS_DVBS2:
>   		if (internal->lock) {
> -			/* Average 5 PER values	*/
> -			for (i = 0; i < 5; i++) {
> -				msleep(100);
> -				lsb = stb0899_read_reg(state, STB0899_ECNT1L);
> -				msb = stb0899_read_reg(state, STB0899_ECNT1M);
> -				*ber += MAKEWORD16(msb, lsb);
> -			}
> +			lsb = stb0899_read_reg(state, STB0899_ECNT1L);
> +			msb = stb0899_read_reg(state, STB0899_ECNT1M);
> +			*ber = MAKEWORD16(msb, lsb);
>   			/* ber = ber * 10 ^ 7	*/
>   			*ber *= 10000000;
>   			*ber /= (-1 + (1 << (4 + 2 * STB0899_GETFIELD(NOE, internal->err_ctrl))));
> 


