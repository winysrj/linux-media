Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37307 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752473AbdK1NSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 08:18:12 -0500
Date: Tue, 28 Nov 2017 14:18:14 +0100
From: Greg KH <greg@kroah.com>
To: Martin Homuth <martin@martinhomuth.de>
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging/media: lirc: style fix - replace hard-coded
 function names
Message-ID: <20171128131814.GC20021@kroah.com>
References: <8bfec3aa-8f12-365c-9cf2-10d97f54adec@martinhomuth.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bfec3aa-8f12-365c-9cf2-10d97f54adec@martinhomuth.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 26, 2017 at 08:49:42PM +0100, Martin Homuth wrote:
> This patch fixes the remaining coding style warnings in the lirc module.
> 
> It fixes the following checkpatch.pl warning:
> 
> WARNING: Prefer using '"%s...", __func__' to using 'read', this
> function's name, in a string

> >From f11f24667ba6696cb71ac33a67fc0c7d3b4cd542 Mon Sep 17 00:00:00 2001
> From: Martin Homuth <martin.homuth@emlix.com>
> Date: Sun, 26 Nov 2017 20:14:33 +0100
> Subject: [PATCH] lirc: style fix - replace hard-coded function names
> 
> Instead of hard coding the function name the __func__ variable
> should be used.
> 
> Signed-off-by: Martin Homuth <martin.homuth@emlix.com>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> index 6bd0717bf76e..be68ee652071 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -888,9 +888,9 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
>  	unsigned int m;
>  	DECLARE_WAITQUEUE(wait, current);
>  
> -	dev_dbg(ir->dev, "read called\n");
> +	dev_dbg(ir->dev, "%s called\n", __func__);
>  	if (n % rbuf->chunk_size) {
> -		dev_dbg(ir->dev, "read result = -EINVAL\n");
> +		dev_dbg(ir->dev, "%s result = -EINVAL\n", __func__);
>  		return -EINVAL;
>  	}
>  
> @@ -949,7 +949,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
>  				retries++;
>  			}
>  			if (retries >= 5) {
> -				dev_err(ir->dev, "Buffer read failed!\n");
> +				dev_err(ir->dev, "%s failed!\n", __func__);
>  				ret = -EIO;
>  			}
>  		}
> @@ -959,7 +959,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
>  	put_ir_rx(rx, false);
>  	set_current_state(TASK_RUNNING);
>  
> -	dev_dbg(ir->dev, "read result = %d (%s)\n", ret,
> +	dev_dbg(ir->dev, "%s result = %d (%s)\n", __func__, ret,
>  		ret ? "Error" : "OK");
>  
>  	return ret ? ret : written;
> -- 
> 2.13.6
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch was attached, please place it inline so that it can be
  applied directly from the email message itself.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
