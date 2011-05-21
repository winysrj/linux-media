Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1EUKzi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 06:55:38 -0400
Message-ID: <4DD79A24.5080107@redhat.com>
Date: Sat, 21 May 2011 07:55:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sanjeev Premi <premi@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] omap3: isp: fix compiler warning
References: <1305734811-2354-1-git-send-email-premi@ti.com>
In-Reply-To: <1305734811-2354-1-git-send-email-premi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-05-2011 13:06, Sanjeev Premi escreveu:
> This patch fixes this compiler warning:
>   drivers/media/video/omap3isp/isp.c: In function 'isp_isr_dbg':
>   drivers/media/video/omap3isp/isp.c:392:2: warning: zero-length
>    gnu_printf format string
> 
> Since printk() is used in next few statements, same was used
> here as well.
> 
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> Cc: laurent.pinchart@ideasonboard.com
> ---
> 
>  Actually full block can be converted to dev_dbg()
>  as well; but i am not sure about original intent
>  of the mix.
> 
>  Based on comments, i can resubmit with all prints
>  converted to dev_dbg.

It is probably better to convert the full block to dev_dbg.

> 
> 
> 
>  drivers/media/video/omap3isp/isp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
> index 503bd79..1d38d96 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -387,7 +387,7 @@ static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
>  	};
>  	int i;
>  
> -	dev_dbg(isp->dev, "");
> +	printk(KERN_DEBUG "%s:\n", dev_driver_string(isp->dev));
>  
>  	for (i = 0; i < ARRAY_SIZE(name); i++) {
>  		if ((1 << i) & irqstatus)

Cheers,
Mauro
