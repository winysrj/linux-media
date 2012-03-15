Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032188Ab2COTq7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 15:46:59 -0400
Date: Thu, 15 Mar 2012 15:46:51 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: Pospone ir raw decoders loading until really
 needed
Message-ID: <20120315194651.GA25362@redhat.com>
References: <1331840342-9191-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331840342-9191-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 15, 2012 at 04:39:02PM -0300, Ezequiel Garcia wrote:
> This changes rc_core to not load the IR decoders at load time,
> postponing it to load only if a RC_DRIVER_IR_RAW device is registered
> via rc_register_device.
> 
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  drivers/media/rc/rc-main.c |    8 ++++++--
>  include/media/rc-core.h    |    2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index f6a930b..adf4a99 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1103,6 +1103,12 @@ int rc_register_device(struct rc_dev *dev)
>  	kfree(path);
>  
>  	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> +		/* Load raw decoders, if they aren't already */
> +		if (dev->raw_init) {
> +			IR_dprintk(1, "Loading raw decoders\n");
> +			ir_raw_init();
> +			dev->raw_init = true;
> +		}
>  		rc = ir_raw_event_register(dev);
>  		if (rc < 0)
>  			goto out_input;
> @@ -1176,8 +1182,6 @@ static int __init rc_core_init(void)
>  		return rc;
>  	}
>  
> -	/* Initialize/load the decoders/keymap code that will be used */
> -	ir_raw_init();
>  	rc_map_register(&empty_map);
>  
>  	return 0;

Uhm. How does this ever actually work? The only place I see raw_init set
to true is inside a conditional that requires it already be true. That's
not going to fly.

-- 
Jarod Wilson
jarod@redhat.com

