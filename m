Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965311Ab2COTkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 15:40:08 -0400
Message-ID: <4F62458D.5060705@redhat.com>
Date: Thu, 15 Mar 2012 16:39:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: mchehab@infradead.org, jarod@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: Pospone ir raw decoders loading until really
 needed
References: <1331840342-9191-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1331840342-9191-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-03-2012 16:39, Ezequiel Garcia escreveu:
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

The logic here seems to be inverted. it should be, instead !dev->raw_init.

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
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index b0c494a..71c99c1 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -47,6 +47,7 @@ enum rc_driver_type {
>   *	anyone can call show_protocols or store_protocols
>   * @devno: unique remote control device number
>   * @raw: additional data for raw pulse/space devices
> + * @raw_init: used to load raw decoders modules if needed
>   * @input_dev: the input child device used to communicate events to userspace
>   * @driver_type: specifies if protocol decoding is done in hardware or software
>   * @idle: used to keep track of RX state
> @@ -95,6 +96,7 @@ struct rc_dev {
>  	struct mutex			lock;
>  	unsigned long			devno;
>  	struct ir_raw_event_ctrl	*raw;
> +	bool				raw_init;
>  	struct input_dev		*input_dev;
>  	enum rc_driver_type		driver_type;
>  	bool				idle;

