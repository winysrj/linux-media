Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48330
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752113AbcJSVJn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 17:09:43 -0400
Date: Wed, 19 Oct 2016 19:09:38 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jean-Baptiste Abbadie <jb@abbadie.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] Staging: media: radio-bcm2048: Fix indentation
Message-ID: <20161019190938.617ad346@vento.lan>
In-Reply-To: <20161019204714.11645-3-jb@abbadie.fr>
References: <20161019204714.11645-1-jb@abbadie.fr>
        <20161019204714.11645-3-jb@abbadie.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Oct 2016 22:47:13 +0200
Jean-Baptiste Abbadie <jb@abbadie.fr> escreveu:

> Align multiple lines statement with parentheses

Looks OK to me. Greg, do you want to pick it on your tree or do you
prefer if I pick myself?

If you prefer to pick it:

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> 
> Signed-off-by: Jean-Baptiste Abbadie <jb@abbadie.fr>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 188d045d44ad..f66bea631e8e 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -997,7 +997,7 @@ static int bcm2048_set_fm_search_tune_mode(struct bcm2048_device *bdev,
>  		timeout = BCM2048_AUTO_SEARCH_TIMEOUT;
>  
>  	if (!wait_for_completion_timeout(&bdev->compl,
> -		msecs_to_jiffies(timeout)))
> +					 msecs_to_jiffies(timeout)))
>  		dev_err(&bdev->client->dev, "IRQ timeout.\n");
>  
>  	if (value)
> @@ -2202,7 +2202,7 @@ static ssize_t bcm2048_fops_read(struct file *file, char __user *buf,
>  		}
>  		/* interruptible_sleep_on(&bdev->read_queue); */
>  		if (wait_event_interruptible(bdev->read_queue,
> -		    bdev->rds_data_available) < 0) {
> +					     bdev->rds_data_available) < 0) {
>  			retval = -EINTR;
>  			goto done;
>  		}



Thanks,
Mauro
