Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.active-venture.com ([67.228.131.205]:64181 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2IBEyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Sep 2012 00:54:45 -0400
Date: Sat, 1 Sep 2012 21:54:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] mceusb: Optimize DIV_ROUND_CLOSEST call
Message-ID: <20120902045444.GA3908@roeck-us.net>
References: <20120901205357.1a75d8a1@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120901205357.1a75d8a1@endymion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 01, 2012 at 08:53:57PM +0200, Jean Delvare wrote:
> DIV_ROUND_CLOSEST is faster if the compiler knows it will only be
> dealing with unsigned dividends.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

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
> -- 
> Jean Delvare
> 
