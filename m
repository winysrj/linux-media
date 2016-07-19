Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:47595 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbcGSWK3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 18:10:29 -0400
Date: Tue, 19 Jul 2016 23:10:27 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 3/7] [media] rc-core: add support for IR raw transmitters
Message-ID: <20160719221027.GB24697@gofer.mess.org>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-4-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468943818-26025-4-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 20, 2016 at 12:56:54AM +0900, Andi Shyti wrote:
> IR raw transmitter driver type is specified in the enum
> rc_driver_type as RC_DRIVER_IR_RAW_TX which includes all those
> devices that transmit raw stream of bit to a receiver.
> 
> The data are provided by userspace applications, therefore they
> don't need any input device allocation, but still they need to be
> registered as raw devices.
> 
> Suggested-by: Sean Young <sean@mess.org>
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  drivers/media/rc/rc-main.c | 35 +++++++++++++++++++++++------------
>  include/media/rc-core.h    |  1 +
>  2 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index ac91157..f555f38 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1354,20 +1354,24 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
>  	if (!dev)
>  		return NULL;
>  
> -	dev->input_dev = input_allocate_device();
> -	if (!dev->input_dev) {
> -		kfree(dev);
> -		return NULL;
> -	}
> +	if (type != RC_DRIVER_IR_RAW_TX) {
> +		dev->input_dev = input_allocate_device();
> +		if (!dev->input_dev) {
> +			kfree(dev);
> +			return NULL;
> +		}
>  
> -	dev->input_dev->getkeycode = ir_getkeycode;
> -	dev->input_dev->setkeycode = ir_setkeycode;
> -	input_set_drvdata(dev->input_dev, dev);
> +		dev->input_dev->getkeycode = ir_getkeycode;
> +		dev->input_dev->setkeycode = ir_setkeycode;
> +		input_set_drvdata(dev->input_dev, dev);
>  
> -	spin_lock_init(&dev->rc_map.lock);
> -	spin_lock_init(&dev->keylock);
> +		setup_timer(&dev->timer_keyup, ir_timer_keyup,
> +						(unsigned long)dev);
> +
> +		spin_lock_init(&dev->rc_map.lock);
> +		spin_lock_init(&dev->keylock);
> +	}
>  	mutex_init(&dev->lock);
> -	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
>  
>  	dev->dev.type = &rc_dev_type;
>  	dev->dev.class = &rc_class;
> @@ -1515,7 +1519,14 @@ int rc_register_device(struct rc_dev *dev)
>  		dev->input_name ?: "Unspecified device", path ?: "N/A");
>  	kfree(path);
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> +	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
> +		rc = rc_setup_rx_device(dev);
> +		if (rc)
> +			goto out_dev;
> +	}
> +
> +	if (dev->driver_type == RC_DRIVER_IR_RAW ||
> +				dev->driver_type == RC_DRIVER_IR_RAW_TX) {

Here the if is wrong. It should be 
"if (dev->driver_type != RC_DRIVER_IR_RAW_TX)". Note that as result
the decoder thread is not started, so patch 4 won't be needed either.


>  		if (!raw_init) {
>  			request_module_nowait("ir-lirc-codec");
>  			raw_init = true;
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index c6bf1ef..77b0893 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -32,6 +32,7 @@ do {								\
>  enum rc_driver_type {
>  	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
>  	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
> +	RC_DRIVER_IR_RAW_TX,	/* Device is transmitter, driver handles raw */

The comment should really mention the lack of receiver.

