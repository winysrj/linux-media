Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab0BIN07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 08:26:59 -0500
Message-ID: <4B71629F.7000004@infradead.org>
Date: Tue, 09 Feb 2010 11:26:55 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix compilation tm6000 module
References: <20100209164831.61d26b47@glory.loctelecom.ru>
In-Reply-To: <20100209164831.61d26b47@glory.loctelecom.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitri,

Dmitri Belimov wrote:
> Hi All
> 
> Fix compilation tm6000 module.
> 
> diff -r 690055993011 linux/drivers/staging/tm6000/tm6000-cards.c
> --- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun Feb 07 22:26:10 2010 -0200
> +++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Tue Feb 09 10:44:14 2010 +0900
> @@ -45,6 +45,8 @@
>  #define TM6000_BOARD_FREECOM_AND_SIMILAR	7
>  #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
>  #define TM6010_BOARD_HAUPPAUGE_900H		9
> +#define TM6010_BOARD_BEHOLD_WANDER		10
> +#define TM6010_BOARD_BEHOLD_VOYAGER		11
>  
>  #define TM6000_MAXBOARDS        16
>  static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
> 
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

Thanks. I just made a similar patch yesterday:
	http://git.linuxtv.org/v4l-dvb.git?a=commit;h=9b3d48aa238969e33e8642fd359991044afae9c7

Also, Stefan had added the same fix into one of his patches.

I suspect that Douglas didn't backport it yet to -hg.
> 
> 
> With my best regards, Dmitry.
> 


-- 

Cheers,
Mauro
