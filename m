Return-path: <linux-media-owner@vger.kernel.org>
Received: from aotearoadigitalarts.org.nz ([72.14.179.101]:51291 "EHLO
	linode.halo.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2K0UK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 15:10:57 -0500
Message-ID: <50B519D4.7050904@paradise.net.nz>
Date: Wed, 28 Nov 2012 08:51:48 +1300
From: Douglas Bagnall <douglas@paradise.net.nz>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRl?= =?UTF-8?B?bWFu?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/2] [media] rc: unlock on error in show_protocols()
References: <20121127173509.GE1059@elgon.mountain>
In-Reply-To: <20121127173509.GE1059@elgon.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/11/12 06:35, Dan Carpenter wrote:
> We recently introduced a new return -ENODEV in this function but we need
> to unlock before returning.

There is an identical patch here (scroll down):
https://patchwork.kernel.org/patch/1284081/

I'm not sure what happened to it.

Douglas

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 601d1ac1..d593bc6 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -789,8 +789,10 @@ static ssize_t show_protocols(struct device *device,
>  	} else if (dev->raw) {
>  		enabled = dev->raw->enabled_protocols;
>  		allowed = ir_raw_get_allowed_protocols();
> -	} else
> +	} else {
> +		mutex_unlock(&dev->lock);
>  		return -ENODEV;
> +	}
>  
>  	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
>  		   (long long)allowed,
> 

