Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:2694 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbZLOWYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 17:24:11 -0500
Message-ID: <4B280C72.1030908@linuxtv.org>
Date: Tue, 15 Dec 2009 17:23:46 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] lgdt3305: make one-bit bitfields unsigned
References: <4B27F6F3.5000300@freemail.hu>
In-Reply-To: <4B27F6F3.5000300@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks -- I'll push this in through the lgdt3305 repository... I'll send 
in a pull request to Mauro shortly.

-Mike

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> Make one-bit bitfields unsigned which will remove the following
> sparse warning messages (see "make C=1"):
>  * lgdt3305.h:57:21: error: dubious one-bit signed bitfield
>  * lgdt3305.h:60:26: error: dubious one-bit signed bitfield
>  * lgdt3305.h:63:19: error: dubious one-bit signed bitfield
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r ba8d6bf077aa linux/drivers/media/dvb/frontends/lgdt3305.h
> --- a/linux/drivers/media/dvb/frontends/lgdt3305.h	Tue Dec 15 17:40:44 2009 +0100
> +++ b/linux/drivers/media/dvb/frontends/lgdt3305.h	Tue Dec 15 21:47:53 2009 +0100
> @@ -54,13 +54,13 @@
>  	u16 usref_qam256; /* default: 0x2a80 */
>
>  	/* disable i2c repeater - 0:repeater enabled 1:repeater disabled */
> -	int deny_i2c_rptr:1;
> +	unsigned int deny_i2c_rptr:1;
>
>  	/* spectral inversion - 0:disabled 1:enabled */
> -	int spectral_inversion:1;
> +	unsigned int spectral_inversion:1;
>
>  	/* use RF AGC loop - 0:disabled 1:enabled */
> -	int rf_agc_loop:1;
> +	unsigned int rf_agc_loop:1;
>
>  	enum lgdt3305_mpeg_mode mpeg_mode;
>  	enum lgdt3305_tp_clock_edge tpclk_edge;
>   

