Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58051 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753386AbdK2L57 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 06:57:59 -0500
Date: Wed, 29 Nov 2017 11:57:57 +0000
From: Sean Young <sean@mess.org>
To: Martin Homuth <martin@martinhomuth.de>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH Resend] staging: media: lirc: style fix - replace
 hard-coded function names
Message-ID: <20171129115757.kbijvbp7xxiiyty7@gofer.mess.org>
References: <8bfec3aa-8f12-365c-9cf2-10d97f54adec@martinhomuth.de>
 <671e53b1-5cfd-ee34-1680-e7c5f1722137@martinhomuth.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671e53b1-5cfd-ee34-1680-e7c5f1722137@martinhomuth.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 28, 2017 at 06:47:08PM +0100, Martin Homuth wrote:
> This patch fixes the remaining coding style warnings in the lirc module.
> Instead of hard coding the function name the __func__ variable
> should be used.
> 
> It fixes the following checkpatch.pl warning:
> 
> WARNING: Prefer using '"%s...", __func__' to using 'read', this
> function's name, in a string
> 
> Signed-off-by: Martin Homuth <martin@martinhomuth.de>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c
> b/drivers/staging/media/lirc/lirc_zilog.c
> index 6bd0717bf76e..be68ee652071 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c

I'm afraid that lirc_zilog has been re-written.

https://patchwork.linuxtv.org/patch/45189/

It hasn't been merged yet, but I suspect that is imminent.


Sean

> @@ -888,9 +888,9 @@ static ssize_t read(struct file *filep, char __user
> *outbuf, size_t n,
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
> @@ -949,7 +949,7 @@ static ssize_t read(struct file *filep, char __user
> *outbuf, size_t n,
>  				retries++;
>  			}
>  			if (retries >= 5) {
> -				dev_err(ir->dev, "Buffer read failed!\n");
> +				dev_err(ir->dev, "%s failed!\n", __func__);
>  				ret = -EIO;
>  			}
>  		}
> @@ -959,7 +959,7 @@ static ssize_t read(struct file *filep, char __user
> *outbuf, size_t n,
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
