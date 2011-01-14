Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43028 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091Ab1ANVpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 16:45:05 -0500
Subject: Re: [PATCH] hdpvr: enable IR part
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>
In-Reply-To: <20110114195448.GA9849@redhat.com>
References: <20110114195448.GA9849@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 16:44:40 -0500
Message-ID: <1295041480.2459.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2011-01-14 at 14:54 -0500, Jarod Wilson wrote:
> A number of things going on here, but the end result is that the IR part
> on the hdpvr gets enabled, and can be used with ir-kbd-i2c and/or
> lirc_zilog.
> 
> First up, there are some conditional build fixes that come into play
> whether i2c is built-in or modular. Second, we're swapping out
> i2c_new_probed_device() for i2c_new_device(), as in my testing, probing
> always fails, but we *know* that all hdpvr devices have a z8 chip at
> 0x70 and 0x71. Third, we're poking at an i2c address directly without a
> client, and writing some magic bits to actually turn on this IR part
> (this could use some improvement in the future). Fourth, some of the
> i2c_adapter storage has been reworked, as the existing implementation
> used to lead to an oops following i2c changes c. 2.6.31.
> 
> Earlier editions of this patch have been floating around the 'net for a
> while, including being patched into Fedora kernels, and they *do* work.
> This specific version isn't yet tested, beyond loading ir-kbd-i2c and
> confirming that it does bind to the RX address of the hdpvr:
> 
> Registered IR keymap rc-hauppauge-new
> input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
> rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
> ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]
> 
> (Yes, I'm posting before fully testing, and I do have a reason for that,
> and will post a v2 after testing this weekend, if need be)...

As discussed on IRC
1. no need to probe for the Z8 as HD PVR always has one.  
2. accessing the chip at address 0x54 directly should eventually be
reworked with nicer i2c subsystem methods, but that can wait

So

Acked-by: Andy Walls <awalls@md.metrocast.net>

Note, that code in lirc_zilog.c indicates that ir-kbd-i2c.c's function
get_key_haup_xvr() *may* need some additions to account for the Rx data
format.  I'm not sure of this though.  (Or a custom get_key() in the
hdpvr module could be provided as a function pointer to ir-kbd-i2c.c via
platform_data.)

I will provide a debug patch in another email so that it's easier to see
the data ir-kbd-i2c.c sees coming from the Z8.

Regards,
Andy

> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/media/video/hdpvr/Makefile      |    4 +-
>  drivers/media/video/hdpvr/hdpvr-core.c  |   10 +--
>  drivers/media/video/hdpvr/hdpvr-i2c.c   |  120 +++++++++++++++----------------
>  drivers/media/video/hdpvr/hdpvr-video.c |    7 +--
>  drivers/media/video/hdpvr/hdpvr.h       |    2 +-
>  5 files changed, 66 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/media/video/hdpvr/Makefile b/drivers/media/video/hdpvr/Makefile
> index e0230fc..3baa9f6 100644
> --- a/drivers/media/video/hdpvr/Makefile
> +++ b/drivers/media/video/hdpvr/Makefile
> @@ -1,6 +1,4 @@
> -hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-video.o
> -
> -hdpvr-$(CONFIG_I2C) += hdpvr-i2c.o
> +hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-video.o hdpvr-i2c.o
>  
>  obj-$(CONFIG_VIDEO_HDPVR) += hdpvr.o
>  
> diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
> index f7d1ee5..a6572e5 100644
> --- a/drivers/media/video/hdpvr/hdpvr-core.c
> +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> @@ -378,19 +378,17 @@ static int hdpvr_probe(struct usb_interface *interface,
>  		goto error;
>  	}
>  
> -#ifdef CONFIG_I2C
> -	/* until i2c is working properly */
> -	retval = 0; /* hdpvr_register_i2c_adapter(dev); */
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +	retval = hdpvr_register_i2c_adapter(dev);
>  	if (retval < 0) {
>  		v4l2_err(&dev->v4l2_dev, "registering i2c adapter failed\n");
>  		goto error;
>  	}
>  
> -	/* until i2c is working properly */
> -	retval = 0; /* hdpvr_register_i2c_ir(dev); */
> +	retval = hdpvr_register_i2c_ir(dev);
>  	if (retval < 0)
>  		v4l2_err(&dev->v4l2_dev, "registering i2c IR devices failed\n");
> -#endif /* CONFIG_I2C */
> +#endif
>  
>  	/* let the user know what node this device is now attached to */
>  	v4l2_info(&dev->v4l2_dev, "device now attached to %s\n",
> diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
> index 24966aa..c0696c3 100644
> --- a/drivers/media/video/hdpvr/hdpvr-i2c.c
> +++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
> @@ -13,6 +13,8 @@
>   *
>   */
>  
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> @@ -28,55 +30,31 @@
>  #define Z8F0811_IR_TX_I2C_ADDR	0x70
>  #define Z8F0811_IR_RX_I2C_ADDR	0x71
>  
> -static const u8 ir_i2c_addrs[] = {
> -	Z8F0811_IR_TX_I2C_ADDR,
> -	Z8F0811_IR_RX_I2C_ADDR,
> -};
>  
> -static const char * const ir_devicenames[] = {
> -	"ir_tx_z8f0811_hdpvr",
> -	"ir_rx_z8f0811_hdpvr",
> +static struct i2c_board_info hdpvr_i2c_board_info = {
> +	I2C_BOARD_INFO("ir_tx_z8f0811_hdpvr", Z8F0811_IR_TX_I2C_ADDR),
> +	I2C_BOARD_INFO("ir_rx_z8f0811_hdpvr", Z8F0811_IR_RX_I2C_ADDR),
>  };
>  
> -static int hdpvr_new_i2c_ir(struct hdpvr_device *dev, struct i2c_adapter *adap,
> -			    const char *type, u8 addr)
> +int hdpvr_register_i2c_ir(struct hdpvr_device *dev)
>  {
> -	struct i2c_board_info info;
> +	struct i2c_client *c;
>  	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
> -	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
> -
> -	memset(&info, 0, sizeof(struct i2c_board_info));
> -	strlcpy(info.type, type, I2C_NAME_SIZE);
>  
>  	/* Our default information for ir-kbd-i2c.c to use */
> -	switch (addr) {
> -	case Z8F0811_IR_RX_I2C_ADDR:
> -		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
> -		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> -		init_data->type = RC_TYPE_RC5;
> -		init_data->name = "HD PVR";
> -		info.platform_data = init_data;
> -		break;
> -	}
> -
> -	return i2c_new_probed_device(adap, &info, addr_list, NULL) == NULL ?
> -	       -1 : 0;
> -}
> +	init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
> +	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> +	init_data->type = RC_TYPE_RC5;
> +	init_data->name = "HD PVR";
> +	hdpvr_i2c_board_info.platform_data = init_data;
>  
> -int hdpvr_register_i2c_ir(struct hdpvr_device *dev)
> -{
> -	int i;
> -	int ret = 0;
> +	c = i2c_new_device(&dev->i2c_adapter, &hdpvr_i2c_board_info);
>  
> -	for (i = 0; i < ARRAY_SIZE(ir_i2c_addrs); i++)
> -		ret += hdpvr_new_i2c_ir(dev, dev->i2c_adapter,
> -					ir_devicenames[i], ir_i2c_addrs[i]);
> -
> -	return ret;
> +	return (c == NULL) ? -ENODEV : 0;
>  }
>  
> -static int hdpvr_i2c_read(struct hdpvr_device *dev, unsigned char addr,
> -			  char *data, int len)
> +static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
> +			  unsigned char addr, char *data, int len)
>  {
>  	int ret;
>  	char *buf = kmalloc(len, GFP_KERNEL);
> @@ -86,7 +64,7 @@ static int hdpvr_i2c_read(struct hdpvr_device *dev, unsigned char addr,
>  	ret = usb_control_msg(dev->udev,
>  			      usb_rcvctrlpipe(dev->udev, 0),
>  			      REQTYPE_I2C_READ, CTRL_READ_REQUEST,
> -			      0x100|addr, 0, buf, len, 1000);
> +			      (bus << 8) | addr, 0, buf, len, 1000);
>  
>  	if (ret == len) {
>  		memcpy(data, buf, len);
> @@ -99,8 +77,8 @@ static int hdpvr_i2c_read(struct hdpvr_device *dev, unsigned char addr,
>  	return ret;
>  }
>  
> -static int hdpvr_i2c_write(struct hdpvr_device *dev, unsigned char addr,
> -			   char *data, int len)
> +static int hdpvr_i2c_write(struct hdpvr_device *dev, int bus,
> +			   unsigned char addr, char *data, int len)
>  {
>  	int ret;
>  	char *buf = kmalloc(len, GFP_KERNEL);
> @@ -111,7 +89,7 @@ static int hdpvr_i2c_write(struct hdpvr_device *dev, unsigned char addr,
>  	ret = usb_control_msg(dev->udev,
>  			      usb_sndctrlpipe(dev->udev, 0),
>  			      REQTYPE_I2C_WRITE, CTRL_WRITE_REQUEST,
> -			      0x100|addr, 0, buf, len, 1000);
> +			      (bus << 8) | addr, 0, buf, len, 1000);
>  
>  	if (ret < 0)
>  		goto error;
> @@ -121,7 +99,7 @@ static int hdpvr_i2c_write(struct hdpvr_device *dev, unsigned char addr,
>  			      REQTYPE_I2C_WRITE_STATT, CTRL_READ_REQUEST,
>  			      0, 0, buf, 2, 1000);
>  
> -	if (ret == 2)
> +	if ((ret == 2) && (buf[1] == (len - 1)))
>  		ret = 0;
>  	else if (ret >= 0)
>  		ret = -EIO;
> @@ -146,10 +124,10 @@ static int hdpvr_transfer(struct i2c_adapter *i2c_adapter, struct i2c_msg *msgs,
>  		addr = msgs[i].addr << 1;
>  
>  		if (msgs[i].flags & I2C_M_RD)
> -			retval = hdpvr_i2c_read(dev, addr, msgs[i].buf,
> +			retval = hdpvr_i2c_read(dev, 1, addr, msgs[i].buf,
>  						msgs[i].len);
>  		else
> -			retval = hdpvr_i2c_write(dev, addr, msgs[i].buf,
> +			retval = hdpvr_i2c_write(dev, 1, addr, msgs[i].buf,
>  						 msgs[i].len);
>  	}
>  
> @@ -168,30 +146,48 @@ static struct i2c_algorithm hdpvr_algo = {
>  	.functionality = hdpvr_functionality,
>  };
>  
> +static struct i2c_adapter hdpvr_i2c_adapter_template = {
> +	.name   = "Hauppage HD PVR I2C",
> +	.owner  = THIS_MODULE,
> +	.algo   = &hdpvr_algo,
> +	.class  = I2C_CLASS_TV_ANALOG,
> +};
> +
> +static int hdpvr_activate_ir(struct hdpvr_device *dev)
> +{
> +	char buffer[8];
> +
> +	mutex_lock(&dev->i2c_mutex);
> +
> +	hdpvr_i2c_read(dev, 0, 0x54, buffer, 1);
> +
> +	buffer[0] = 0;
> +	buffer[1] = 0x8;
> +	hdpvr_i2c_write(dev, 1, 0x54, buffer, 2);
> +
> +	buffer[1] = 0x18;
> +	hdpvr_i2c_write(dev, 1, 0x54, buffer, 2);
> +
> +	mutex_unlock(&dev->i2c_mutex);
> +
> +	return 0;
> +}
> +
>  int hdpvr_register_i2c_adapter(struct hdpvr_device *dev)
>  {
> -	struct i2c_adapter *i2c_adap;
>  	int retval = -ENOMEM;
>  
> -	i2c_adap = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
> -	if (i2c_adap == NULL)
> -		goto error;
> +	hdpvr_activate_ir(dev);
>  
> -	strlcpy(i2c_adap->name, "Hauppauge HD PVR I2C",
> -		sizeof(i2c_adap->name));
> -	i2c_adap->algo  = &hdpvr_algo;
> -	i2c_adap->owner = THIS_MODULE;
> -	i2c_adap->dev.parent = &dev->udev->dev;
> +	memcpy(&dev->i2c_adapter, &hdpvr_i2c_adapter_template,
> +	       sizeof(struct i2c_adapter));
> +	dev->i2c_adapter.dev.parent = &dev->udev->dev;
>  
> -	i2c_set_adapdata(i2c_adap, dev);
> +	i2c_set_adapdata(&dev->i2c_adapter, dev);
>  
> -	retval = i2c_add_adapter(i2c_adap);
> +	retval = i2c_add_adapter(&dev->i2c_adapter);
>  
> -	if (!retval)
> -		dev->i2c_adapter = i2c_adap;
> -	else
> -		kfree(i2c_adap);
> -
> -error:
>  	return retval;
>  }
> +
> +#endif
> diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
> index d38fe10..514aea7 100644
> --- a/drivers/media/video/hdpvr/hdpvr-video.c
> +++ b/drivers/media/video/hdpvr/hdpvr-video.c
> @@ -1220,12 +1220,9 @@ static void hdpvr_device_release(struct video_device *vdev)
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  
>  	/* deregister I2C adapter */
> -#ifdef CONFIG_I2C
> +#if defined(CONFIG_I2C) || (CONFIG_I2C_MODULE)
>  	mutex_lock(&dev->i2c_mutex);
> -	if (dev->i2c_adapter)
> -		i2c_del_adapter(dev->i2c_adapter);
> -	kfree(dev->i2c_adapter);
> -	dev->i2c_adapter = NULL;
> +	i2c_del_adapter(&dev->i2c_adapter);
>  	mutex_unlock(&dev->i2c_mutex);
>  #endif /* CONFIG_I2C */
>  
> diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
> index 37f1e4c..29f7426 100644
> --- a/drivers/media/video/hdpvr/hdpvr.h
> +++ b/drivers/media/video/hdpvr/hdpvr.h
> @@ -106,7 +106,7 @@ struct hdpvr_device {
>  	struct work_struct	worker;
>  
>  	/* I2C adapter */
> -	struct i2c_adapter	*i2c_adapter;
> +	struct i2c_adapter	i2c_adapter;
>  	/* I2C lock */
>  	struct mutex		i2c_mutex;
>  
> -- 
> 1.7.1
> 


