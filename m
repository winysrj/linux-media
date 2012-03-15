Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab2COVfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 17:35:51 -0400
Date: Thu, 15 Mar 2012 17:35:42 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: rc: Pospone ir raw decoders loading until
 really needed
Message-ID: <20120315213542.GB25362@redhat.com>
References: <1331844829-1166-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331844829-1166-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 15, 2012 at 05:53:49PM -0300, Ezequiel Garcia wrote:
> This changes rc_core to not load the IR decoders at load time,
> postponing it to load only if a RC_DRIVER_IR_RAW device is 
> registered via rc_register_device.
> We use a static boolean variable, to ensure decoders modules
> are only loaded once.
> Tested with rc-loopback device only.
> 
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
> v2: Fix broken logic in v1. 
>     Also, put raw_init as static instead of inside rc_dev
>     struct to ensure loading is only tried the first time.
> ---
>  drivers/media/rc/rc-main.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index f6a930b..d366d53 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -32,6 +32,9 @@
>  static LIST_HEAD(rc_map_list);
>  static DEFINE_SPINLOCK(rc_map_lock);
>  
> +/* Used to load raw decoders modules only if needed */
> +static bool raw_init;
> +
>  static struct rc_map_list *seek_rc_map(const char *name)
>  {
>  	struct rc_map_list *map = NULL;
> @@ -1103,6 +1106,12 @@ int rc_register_device(struct rc_dev *dev)
>  	kfree(path);
>  
>  	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> +		/* Load raw decoders, if they aren't already */
> +		if (!raw_init) {
> +			IR_dprintk(1, "Loading raw decoders\n");

I think this is slightly redundant, since we already print something for
each of the decoders loaded, but eh, its a debug printk, maybe you're
debugging why none are loading, so its good to know you're reaching the
call to ir_raw_init...

So yeah, ok, I'm fine with this. Haven't tested it with actual raw IR
hardware, but I don't see any reason it wouldn't work.

Acked-by: Jarod Wilson <jarod@redhat.com>

> +			ir_raw_init();
> +			raw_init = true;
> +		}
>  		rc = ir_raw_event_register(dev);
>  		if (rc < 0)
>  			goto out_input;
> @@ -1176,8 +1185,6 @@ static int __init rc_core_init(void)
>  		return rc;
>  	}
>  
> -	/* Initialize/load the decoders/keymap code that will be used */
> -	ir_raw_init();
>  	rc_map_register(&empty_map);
>  
>  	return 0;

-- 
Jarod Wilson
jarod@redhat.com

