Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:60187 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab1EWOhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 10:37:24 -0400
Message-ID: <4DDA711E.3030301@linuxtv.org>
Date: Mon, 23 May 2011 16:37:18 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
 structure is transferred from userspace to kernelspace. Keep the old ioctl
 around for compatibility so that existing code is not broken.
References: <201105231558.13084.hselasky@c2i.net>
In-Reply-To: <201105231558.13084.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/23/2011 03:58 PM, Hans Petter Selasky wrote:
> From be7d0f72ebf4d945cfb2a5c9cc871707f72e1e3c Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 15:56:31 +0200
> Subject: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated structure is transferred from userspace to kernelspace. Keep the old ioctl around for compatibility so that existing code is not broken.

Good catch, but I think _IOWR would be right, because the result gets
copied from kernelspace to userspace.

It would be nice if you could send future patches inline rather than
attached. I'd suggest using git format-patch and git send-email.

Regards,
Andreas

> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |    5 +++--
>  include/linux/dvb/frontend.h              |    3 ++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 31e2c0d..d93c1ec 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1507,7 +1507,8 @@ static int dvb_frontend_ioctl(struct file *file,
>  	if (down_interruptible (&fepriv->sem))
>  		return -ERESTARTSYS;
>  
> -	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
> +	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY) ||
> +	    (cmd == FE_GET_PROPERTY_OLD))
>  		err = dvb_frontend_ioctl_properties(file, cmd, parg);
>  	else {
>  		fe->dtv_property_cache.state = DTV_UNDEFINED;
> @@ -1562,7 +1563,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  			dprintk("%s() Property cache is full, tuning\n", __func__);
>  
>  	} else
> -	if(cmd == FE_GET_PROPERTY) {
> +	if(cmd == FE_GET_PROPERTY || cmd == FE_GET_PROPERTY_OLD) {
>  
>  		tvps = (struct dtv_properties __user *)parg;
>  
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index 493a2bf..05b38c4 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -374,7 +374,8 @@ struct dtv_properties {
>  };
>  
>  #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
> -#define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
> +#define FE_GET_PROPERTY		   _IOW('o', 83, struct dtv_properties)
> +#define FE_GET_PROPERTY_OLD	   _IOR('o', 83, struct dtv_properties)
>  
>  
>  /**
> -- 1.7.1.1

