Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:45354 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0EJRpx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 13:45:53 -0400
Received: from whale.tvdr.de (whale.tvdr.de [192.168.100.6])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id o4AHjoAg018607
	for <linux-media@vger.kernel.org>; Mon, 10 May 2010 19:45:50 +0200
Received: from [192.168.100.10] (hawk.tvdr.de [192.168.100.10])
	by whale.tvdr.de (8.14.3/8.14.3) with ESMTP id o4AHjjTb005406
	for <linux-media@vger.kernel.org>; Mon, 10 May 2010 19:45:45 +0200
Message-ID: <4BE84649.3010507@tvdr.de>
Date: Mon, 10 May 2010 19:45:45 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [hg:v4l-dvb] Add FE_CAN_PSK_8 to allow apps to identify PSK_8
 capable DVB devices
References: <E1OBKmg-0006RZ-4R@www.linuxtv.org>
In-Reply-To: <E1OBKmg-0006RZ-4R@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.05.2010 06:40, Patch from Klaus Schmidinger wrote:
> The patch number 14692 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>

This patch should not have been applied, as was decided in
the original thread.

I'm still waiting for any response to my new patch, posted in

  "[PATCH] Add FE_CAN_TURBO_FEC (was: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices)"

which replaces my original suggestion.

Klaus

> ------
> 
> From: Klaus Schmidinger  <Klaus.Schmidinger@tvdr.de>
> Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices
> 
> 
> The enum fe_caps provides flags that allow an application to detect
> whether a device is capable of handling various modulation types etc.
> A flag for detecting PSK_8, however, is missing.
> This patch adds the flag FE_CAN_PSK_8 to frontend.h and implements
> it for the gp8psk-fe.c and cx24116.c driver (apparently the only ones
> with PSK_8). Only the gp8psk-fe.c has been explicitly tested, though.
> 
> Priority: normal
> 
> Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
> Tested-by: Derek Kelly <user.vdr@gmail.com>
> Acked-by: Manu Abraham <manu@linuxtv.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
> 
> 
> ---
> 
>  linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c |    2 +-
>  linux/drivers/media/dvb/frontends/cx24116.c |    2 +-
>  linux/include/linux/dvb/frontend.h          |    1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff -r 31df1af24206 -r 0eabd1e76386 linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c
> --- a/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c	Mon May 10 01:31:11 2010 -0300
> +++ b/linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c	Mon May 10 01:32:52 2010 -0300
> @@ -349,7 +349,7 @@
>  			 * FE_CAN_QAM_16 is for compatibility
>  			 * (Myth incorrectly detects Turbo-QPSK as plain QAM-16)
>  			 */
> -			FE_CAN_QPSK | FE_CAN_QAM_16
> +		       FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_PSK_8
>  	},
>  
>  	.release = gp8psk_fe_release,
> diff -r 31df1af24206 -r 0eabd1e76386 linux/drivers/media/dvb/frontends/cx24116.c
> --- a/linux/drivers/media/dvb/frontends/cx24116.c	Mon May 10 01:31:11 2010 -0300
> +++ b/linux/drivers/media/dvb/frontends/cx24116.c	Mon May 10 01:32:52 2010 -0300
> @@ -1496,7 +1496,7 @@
>  			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
>  			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
>  			FE_CAN_2G_MODULATION |
> -			FE_CAN_QPSK | FE_CAN_RECOVER
> +		       FE_CAN_QPSK | FE_CAN_RECOVER | FE_CAN_PSK_8
>  	},
>  
>  	.release = cx24116_release,
> diff -r 31df1af24206 -r 0eabd1e76386 linux/include/linux/dvb/frontend.h
> --- a/linux/include/linux/dvb/frontend.h	Mon May 10 01:31:11 2010 -0300
> +++ b/linux/include/linux/dvb/frontend.h	Mon May 10 01:32:52 2010 -0300
> @@ -62,6 +62,7 @@
>  	FE_CAN_8VSB			= 0x200000,
>  	FE_CAN_16VSB			= 0x400000,
>  	FE_HAS_EXTENDED_CAPS		= 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
> +       FE_CAN_PSK_8                    = 0x8000000,  /* frontend supports "8psk modulation" */
>  	FE_CAN_2G_MODULATION		= 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
>  	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
>  	FE_CAN_RECOVER			= 0x40000000, /* frontend can recover from a cable unplug automatically */
> 
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/0eabd1e76386c37db6cef0a608901d3dd04a301f
