Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:30281 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab1AUNeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 08:34:25 -0500
Subject: Re: [PATCH 1/3] hdpvr: fix up i2c device registration
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1295584225-21210-2-git-send-email-jarod@redhat.com>
References: <1295584225-21210-1-git-send-email-jarod@redhat.com>
	 <1295584225-21210-2-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 08:34:58 -0500
Message-ID: <1295616898.2114.30.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-01-20 at 23:30 -0500, Jarod Wilson wrote:
> We have to actually call i2c_new_device() once for each of the rx and tx
> addresses. Also improve error-handling and device remove i2c cleanup.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

I do have some comments, but the real show-stoppers are:

- '#if defined(..' for the i2c_del_adapter() in the error path
- A very unlikely race by using file scope data

See below.

> ---
>  drivers/media/video/hdpvr/hdpvr-core.c |   21 +++++++++++++++++----
>  drivers/media/video/hdpvr/hdpvr-i2c.c  |   28 ++++++++++++++++++++--------
>  drivers/media/video/hdpvr/hdpvr.h      |    6 +++++-
>  3 files changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
> index a6572e5..f617a23 100644
> --- a/drivers/media/video/hdpvr/hdpvr-core.c
> +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> @@ -381,13 +381,21 @@ static int hdpvr_probe(struct usb_interface *interface,
>  #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>  	retval = hdpvr_register_i2c_adapter(dev);
>  	if (retval < 0) {
> -		v4l2_err(&dev->v4l2_dev, "registering i2c adapter failed\n");
> +		v4l2_err(&dev->v4l2_dev, "i2c adapter register failed\n");
>  		goto error;
>  	}
>  
> -	retval = hdpvr_register_i2c_ir(dev);
> -	if (retval < 0)
> -		v4l2_err(&dev->v4l2_dev, "registering i2c IR devices failed\n");
> +	hdpvr_register_ir_rx_i2c(dev);
> +	if (!dev->i2c_rx) {
> +		v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
> +		goto reg_fail;
> +	}
> +
> +	hdpvr_register_ir_tx_i2c(dev);
> +	if (!dev->i2c_tx) {
> +		v4l2_err(&dev->v4l2_dev, "i2c IR TX device register failed\n");
> +		goto reg_fail;
> +	}

Once your driver is debugged and complete, there is really never a need
to save pointers to the i2c_clients.  You might want to consider having
void hdpvr_register_ir_?x_i2c() instead return a pointer that you can
check against NULL.

>  #endif
>  
>  	/* let the user know what node this device is now attached to */
> @@ -395,6 +403,8 @@ static int hdpvr_probe(struct usb_interface *interface,
>  		  video_device_node_name(dev->video_dev));
>  	return 0;
>  
> +reg_fail:
> +	i2c_del_adapter(&dev->i2c_adapter);

Don't you need an '#if defined(CONFIG_I2C)...' here, in case the symbol
does not exist?

>  error:
>  	if (dev) {
>  		/* Destroy single thread */
> @@ -424,6 +434,9 @@ static void hdpvr_disconnect(struct usb_interface *interface)
>  	mutex_lock(&dev->io_mutex);
>  	hdpvr_cancel_queue(dev);
>  	mutex_unlock(&dev->io_mutex);
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +	i2c_del_adapter(&dev->i2c_adapter);
> +#endif
>  	video_unregister_device(dev->video_dev);
>  	atomic_dec(&dev_nr);
>  }
> diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
> index 89b71fa..e891bb0 100644
> --- a/drivers/media/video/hdpvr/hdpvr-i2c.c
> +++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
> @@ -31,26 +31,38 @@
>  #define Z8F0811_IR_RX_I2C_ADDR	0x71
>  
> 
> -static struct i2c_board_info hdpvr_i2c_board_info = {
> +static struct i2c_board_info hdpvr_ir_tx_i2c_board_info = {
>  	I2C_BOARD_INFO("ir_tx_z8f0811_hdpvr", Z8F0811_IR_TX_I2C_ADDR),
> +};

This does not need to be file scope.  (In fact this creates a hard to
trigger race in the function below.)

It should be non-static function scope, as the I2C subsystem will make a
copy of the string and address byte and the platform data pointer when
you add the I2C device.    See pvrusb2.



> +void hdpvr_register_ir_tx_i2c(struct hdpvr_device *dev)
> +{
> +	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
> +
> +	init_data->name = "HD-PVR";
> +	hdpvr_ir_tx_i2c_board_info.platform_data = init_data;

If hdpvr_ir_tx_i2c_board_info is file scope and static, then you have a
race for the platform data pointer when two hdpvr's are instantiated
simultaneously.  It'll be extremely rare, I know, but it is possible.

You should use a function scope copy of the board info.

The per device instance of the init_data is correct.

> +	dev->i2c_tx = i2c_new_device(&dev->i2c_adapter,
> +				     &hdpvr_ir_tx_i2c_board_info);
> +}

Again maybe just have this function 'return  i2c_new_device(...);'.
The caller can save away the i2c_client, if you want to keep a pointer
around.


> +static struct i2c_board_info hdpvr_ir_rx_i2c_board_info = {
>  	I2C_BOARD_INFO("ir_rx_z8f0811_hdpvr", Z8F0811_IR_RX_I2C_ADDR),
>  };
>  
> -int hdpvr_register_i2c_ir(struct hdpvr_device *dev)
> +void hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
>  {
> -	struct i2c_client *c;
>  	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
>  
>  	/* Our default information for ir-kbd-i2c.c to use */
>  	init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
>  	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
>  	init_data->type = RC_TYPE_RC5;
> -	init_data->name = "HD PVR";
> -	hdpvr_i2c_board_info.platform_data = init_data;
> -
> -	c = i2c_new_device(&dev->i2c_adapter, &hdpvr_i2c_board_info);
> +	init_data->name = "HD-PVR";
> +	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
>  
> -	return (c == NULL) ? -ENODEV : 0;
> +	dev->i2c_rx = i2c_new_device(&dev->i2c_adapter,
> +				     &hdpvr_ir_rx_i2c_board_info);
>  }

Same comments as for Rx.



>  static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
> diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
> index ee74e3b..41a579e 100644
> --- a/drivers/media/video/hdpvr/hdpvr.h
> +++ b/drivers/media/video/hdpvr/hdpvr.h
> @@ -108,6 +108,9 @@ struct hdpvr_device {
>  
>  	/* I2C adapter */
>  	struct i2c_adapter	i2c_adapter;
> +	/* I2C clients */
> +	struct i2c_client	*i2c_rx;
> +	struct i2c_client	*i2c_tx;

I don't see where you are using these.  If you need them, you may want
to rename them to i2c_ir_rx and i2c_ir_tx, if hdpvr will ever talk to
another device on the I2C bus.

>  	/* I2C lock */
>  	struct mutex		i2c_mutex;
>  	/* I2C message buffer space */
> @@ -313,7 +316,8 @@ int hdpvr_cancel_queue(struct hdpvr_device *dev);
>  /* i2c adapter registration */
>  int hdpvr_register_i2c_adapter(struct hdpvr_device *dev);
>  
> -int hdpvr_register_i2c_ir(struct hdpvr_device *dev);
> +void hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev);
> +void hdpvr_register_ir_tx_i2c(struct hdpvr_device *dev);
>  
>  /*========================================================================*/
>  /* buffer management */

Regards,
Andy

