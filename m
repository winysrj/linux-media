Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:45639 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbZH0Xhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 19:37:40 -0400
Subject: Re: [PATCH] Fix working LifeView FlyVideo 3000 Card
From: hermann pitton <hermann-pitton@arcor.de>
To: Eugene Yudin <eugene.yudin@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200908280112.53765.Eugene.Yudin@gmail.com>
References: <200908280112.53765.Eugene.Yudin@gmail.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 01:28:32 +0200
Message-Id: <1251415712.3742.17.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eugene,

Am Freitag, den 28.08.2009, 01:12 +0400 schrieb Eugene Yudin:
> Fix this bug for this card and clones:
> > Hi, for a couple of days now, my lifeview PCI hybrid card that worked 
> flawlessly for the last 2 years doesn't work. The problem is with the driver 
> from what I understand from the logs.
> > 
> > Today 23/8/2009 I tried the drivers within vanilla kernel 2.6.30.5 (i386 and 
> amd64) and then separately latest mercurial snapshot. I always use latest 
> mercurial snapshot updating every time a new kernel is released.
> > This card works within Windows XP. I also switched the PCI slot but that 
> didn't help.
> 
> Now all is working great.
> Signed-off-by: Eugene Yudin <Eugene.Yudin@gmail.com>
> Best Regards, Eugene.
> 
> diff -uprN a/linux/drivers/media/video/saa7134/saa7134-cards.c 
> b/linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-27 
> 20:27:10.000000000 +0400
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-28 
> 01:05:14.530155113 +0400
> @@ -103,6 +103,7 @@ struct saa7134_board saa7134_boards[] = 
>  		.radio_type     = UNSET,
>  		.tuner_addr	= ADDR_UNSET,
>  		.radio_addr	= ADDR_UNSET,
> +		.tda9887_conf   = TDA9887_PRESENT,

I can assure, that there is no tda9887 on all the earlier FV3K boards
and I still have one and it was investigated very carefully.

See my previous post for an eventually possible alternative solution.

Cheers,
Hermann
 
>  		.gpiomask       = 0xe000,
>  		.inputs         = {{


