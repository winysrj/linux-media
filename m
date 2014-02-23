Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbaBWVr6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 16:47:58 -0500
Message-ID: <530A6C86.6010707@redhat.com>
Date: Sun, 23 Feb 2014 22:47:50 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] gspca_stv06xx: remove an unneeded check
References: <20140218150044.GC6914@elgon.mountain>
In-Reply-To: <20140218150044.GC6914@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/18/2014 04:00 PM, Dan Carpenter wrote:
> "err" is zero here so we don't need to check again.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
> index bf3e5c317a26..e60cbb3aa609 100644
> --- a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
> +++ b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
> @@ -178,7 +178,7 @@ static int vv6410_stop(struct sd *sd)
>  
>  	PDEBUG(D_STREAM, "Halting stream");
>  
> -	return (err < 0) ? err : 0;
> +	return 0;
>  }
>  
>  static int vv6410_dump(struct sd *sd)
> 

Thanks I've added this to my gspca tree for 3.15.

Regards,

Hans
