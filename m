Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab2IRPuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 11:50:35 -0400
Message-ID: <50589821.6000108@redhat.com>
Date: Tue, 18 Sep 2012 12:49:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] mceusb: Optimize DIV_ROUND_CLOSEST call
References: <20120901205357.1a75d8a1@endymion.delvare>
In-Reply-To: <20120901205357.1a75d8a1@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-09-2012 15:53, Jean Delvare escreveu:
> DIV_ROUND_CLOSEST is faster if the compiler knows it will only be
> dealing with unsigned dividends.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> ---
>  drivers/media/rc/mceusb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-3.6-rc3.orig/drivers/media/rc/mceusb.c	2012-08-04 21:49:27.000000000 +0200
> +++ linux-3.6-rc3/drivers/media/rc/mceusb.c	2012-09-01 18:53:32.053042123 +0200
> @@ -627,7 +627,7 @@ static void mceusb_dev_printdata(struct
>  			break;
>  		case MCE_RSP_EQIRCFS:
>  			period = DIV_ROUND_CLOSEST(
> -					(1 << data1 * 2) * (data2 + 1), 10);
> +					(1U << data1 * 2) * (data2 + 1), 10);
>  			if (!period)
>  				break;
>  			carrier = (1000 * 1000) / period;
> 
> 

Hmm... this generates the following warning with "W=1":

drivers/media/rc/mceusb.c:629:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
drivers/media/rc/mceusb.c:629:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]

Perhaps it makes sense to use an optimized version for unsigned, or to
change the macro to take the data types into account.

Regards,
Mauro
