Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56831 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756021AbcIAVbT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 17:31:19 -0400
Date: Thu, 1 Sep 2016 22:31:16 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 3/7] [media] rc-core: add support for IR raw
 transmitters
Message-ID: <20160901213116.GC22198@gofer.mess.org>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-4-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160901171629.15422-4-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 02, 2016 at 02:16:25AM +0900, Andi Shyti wrote:
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
>  drivers/media/rc/rc-main.c | 39 +++++++++++++++++++++++----------------
>  include/media/rc-core.h    |  9 ++++++---
>  2 files changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 7961083..c3c1f68 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1361,20 +1361,24 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
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
> +
> +		dev->input_dev->getkeycode = ir_getkeycode;
> +		dev->input_dev->setkeycode = ir_setkeycode;
> +		input_set_drvdata(dev->input_dev, dev);
>  
> -	dev->input_dev->getkeycode = ir_getkeycode;
> -	dev->input_dev->setkeycode = ir_setkeycode;
> -	input_set_drvdata(dev->input_dev, dev);
> +		setup_timer(&dev->timer_keyup, ir_timer_keyup,
> +						(unsigned long)dev);
>  
> -	spin_lock_init(&dev->rc_map.lock);
> -	spin_lock_init(&dev->keylock);
> +		spin_lock_init(&dev->rc_map.lock);
> +		spin_lock_init(&dev->keylock);
> +	}
>  	mutex_init(&dev->lock);
> -	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
>  
>  	dev->dev.type = &rc_dev_type;
>  	dev->dev.class = &rc_class;
> @@ -1474,7 +1478,7 @@ out_table:
>  
>  static void rc_free_rx_device(struct rc_dev *dev)
>  {
> -	if (!dev)
> +	if (!dev || dev->driver_type == RC_DRIVER_IR_RAW_TX)
>  		return;
>  
>  	ir_free_table(&dev->rc_map);
> @@ -1522,11 +1526,14 @@ int rc_register_device(struct rc_dev *dev)

An tx-only device shouldn't have the sysfs attribute protocol, that
should be handled here too.

>  		dev->input_name ?: "Unspecified device", path ?: "N/A");
>  	kfree(path);
>  
> -	rc = rc_setup_rx_device(dev);
> -	if (rc)
> -		goto out_dev;
> +	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
> +		rc = rc_setup_rx_device(dev);
> +		if (rc)
> +			goto out_dev;
> +	}
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> +	if (dev->driver_type == RC_DRIVER_IR_RAW ||
> +				dev->driver_type == RC_DRIVER_IR_RAW_TX) {
>  		if (!raw_init) {
>  			request_module_nowait("ir-lirc-codec");
>  			raw_init = true;
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 4fc60dd..56e33c1 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -32,13 +32,16 @@ do {								\
>  /**
>   * enum rc_driver_type - type of the RC output
>   *
> - * @RC_DRIVER_SCANCODE:	Driver or hardware generates a scancode
> - * @RC_DRIVER_IR_RAW:	Driver or hardware generates pulse/space sequences.
> - *			It needs a Infra-Red pulse/space decoder
> + * @RC_DRIVER_SCANCODE:	 Driver or hardware generates a scancode
> + * @RC_DRIVER_IR_RAW:	 Driver or hardware generates pulse/space sequences.
> + *			 It needs a Infra-Red pulse/space decoder
> + * @RC_DRIVER_IR_RAW_TX: Device transmitter only,
> +			 driver requires pulce/spce data sequence.
>   */
>  enum rc_driver_type {
>  	RC_DRIVER_SCANCODE = 0,
>  	RC_DRIVER_IR_RAW,
> +	RC_DRIVER_IR_RAW_TX,
>  };
>  
>  /**
> -- 
> 2.9.3
