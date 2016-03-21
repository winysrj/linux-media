Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55068 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbcCUMZC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 08:25:02 -0400
Date: Mon, 21 Mar 2016 09:24:57 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media/rc: postpone kfree(rc_dev)
Message-ID: <20160321092457.39435fb8@recife.lan>
In-Reply-To: <145855998541.9135.18170484612406448203.stgit@woodpecker.blarg.de>
References: <145855998541.9135.18170484612406448203.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

Em Mon, 21 Mar 2016 12:33:05 +0100
Max Kellermann <max@duempel.org> escreveu:

> CONFIG_DEBUG_KOBJECT_RELEASE found this bug.

Please, always send us your Signed-off-by on your patches, as described at:
	https://linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Developer.27s_Certificate_of_Origin_1.1



> ---
>  drivers/media/rc/rc-main.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 1042fa3..cb3e8db 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1248,6 +1248,9 @@ unlock:
>  
>  static void rc_dev_release(struct device *device)
>  {
> +	struct rc_dev *dev = to_rc_dev(device);
> +
> +	kfree(dev);
>  }
>  
>  #define ADD_HOTPLUG_VAR(fmt, val...)					\
> @@ -1369,7 +1372,9 @@ void rc_free_device(struct rc_dev *dev)
>  
>  	put_device(&dev->dev);
>  
> -	kfree(dev);
> +	/* kfree(dev) will be called by the callback function
> +	   rc_dev_release() */
> +
>  	module_put(THIS_MODULE);
>  }
>  EXPORT_SYMBOL_GPL(rc_free_device);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
