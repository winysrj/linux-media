Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab0EBQcF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 12:32:05 -0400
Message-ID: <4BDDA900.9000903@infradead.org>
Date: Sun, 02 May 2010 13:32:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] tm6000, moving cards name defines
References: <20100414173102.58b0f184@glory.loctelecom.ru>
In-Reply-To: <20100414173102.58b0f184@glory.loctelecom.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitri Belimov wrote:
> Hi
> 
> Move TV cards name defines to better place header file.

I prefer if we can keep having all board-specific stuff inside tm6000-cards.

Cheers,
Mauro
> 
> diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000-cards.c
> --- a/linux/drivers/staging/tm6000/tm6000-cards.c	Mon Apr 05 22:56:43 2010 -0400
> +++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Wed Apr 14 11:18:03 2010 +1000
> @@ -35,22 +35,6 @@
>  #include "tuner-xc2028.h"
>  #include "xc5000.h"
>  
> -#define TM6000_BOARD_UNKNOWN			0
> -#define TM5600_BOARD_GENERIC			1
> -#define TM6000_BOARD_GENERIC			2
> -#define TM6010_BOARD_GENERIC			3
> -#define TM5600_BOARD_10MOONS_UT821		4
> -#define TM5600_BOARD_10MOONS_UT330		5
> -#define TM6000_BOARD_ADSTECH_DUAL_TV		6
> -#define TM6000_BOARD_FREECOM_AND_SIMILAR	7
> -#define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
> -#define TM6010_BOARD_HAUPPAUGE_900H		9
> -#define TM6010_BOARD_BEHOLD_WANDER		10
> -#define TM6010_BOARD_BEHOLD_VOYAGER		11
> -#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
> -#define TM6010_BOARD_TWINHAN_TU501		13
> -
> -#define TM6000_MAXBOARDS        16
>  static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
>  
>  module_param_array(card,  int, NULL, 0444);
> diff -r 7c0b887911cf linux/drivers/staging/tm6000/tm6000.h
> --- a/linux/drivers/staging/tm6000/tm6000.h	Mon Apr 05 22:56:43 2010 -0400
> +++ b/linux/drivers/staging/tm6000/tm6000.h	Wed Apr 14 11:18:03 2010 +1000
> @@ -41,6 +41,23 @@
>  #include "dmxdev.h"
>  
>  #define TM6000_VERSION KERNEL_VERSION(0, 0, 2)
> +
> +#define TM6000_BOARD_UNKNOWN			0
> +#define TM5600_BOARD_GENERIC			1
> +#define TM6000_BOARD_GENERIC			2
> +#define TM6010_BOARD_GENERIC			3
> +#define TM5600_BOARD_10MOONS_UT821		4
> +#define TM5600_BOARD_10MOONS_UT330		5
> +#define TM6000_BOARD_ADSTECH_DUAL_TV		6
> +#define TM6000_BOARD_FREECOM_AND_SIMILAR	7
> +#define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
> +#define TM6010_BOARD_HAUPPAUGE_900H		9
> +#define TM6010_BOARD_BEHOLD_WANDER		10
> +#define TM6010_BOARD_BEHOLD_VOYAGER		11
> +#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
> +#define TM6010_BOARD_TWINHAN_TU501		13
> +
> +#define TM6000_MAXBOARDS        16
>  
>  /* Inputs */
>  
> 
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
> 
> With my best regards, Dmitry.
> 


-- 

Cheers,
Mauro
