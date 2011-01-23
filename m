Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1AWOMl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 09:12:41 -0500
Message-ID: <4D3C3750.8060301@redhat.com>
Date: Sun, 23 Jan 2011 12:12:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alina Friedrichsen <x-alina@gmx.net>
CC: linux-media@vger.kernel.org, rglowery@exemail.com.au
Subject: Re: [RFC PATCH] Getting Hauppauge WinTV HVR-1400 (XC3028L) to work
References: <20110123001615.86290@gmx.net>
In-Reply-To: <20110123001615.86290@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Alina,

Em 22-01-2011 22:16, Alina Friedrichsen escreveu:
> With this patch my DVB-T receiver works now like before 2.6.34, only the
> first four tunings fails, after that all works fine.
> The code was still in there, only commented out. As the original author
> says, please test it with different XC3028 hardware. If no one has problems
> with it, please commit it.
> 
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff -urNp linux-2.6.37.orig/drivers/media/common/tuners/tuner-xc2028.c linux-2.6.37/drivers/media/common/tuners/tuner-xc2028.c
> --- linux-2.6.37.orig/drivers/media/common/tuners/tuner-xc2028.c	2011-01-22 23:46:57.000000000 +0100
> +++ linux-2.6.37/drivers/media/common/tuners/tuner-xc2028.c	2011-01-22 23:51:33.000000000 +0100
> @@ -967,7 +967,7 @@ static int generic_set_freq(struct dvb_f
>  		 * newer firmwares
>  		 */
>  
> -#if 1
> +#if 0
>  		/*
>  		 * The proper adjustment would be to do it at s-code table.
>  		 * However, this didn't work, as reported by

This is problematic, as it seems to be country-specific and/or demod-specific. 
We'll need to work on a different solution for it. On what Country do you live?
By looking at HVR1400 entry, it uses a dibcom 7000p demod.
We need to know what are country/demod for the users for whose the old code
were broken.

Cheers,
Mauro

