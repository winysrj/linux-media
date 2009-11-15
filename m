Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2375 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZKOLik (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 06:38:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 3/5] s2250: Change module structure
Date: Sun, 15 Nov 2009 12:38:38 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1257880897.21307.1105.camel@pete-desktop>
In-Reply-To: <1257880897.21307.1105.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911151238.38231.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 November 2009 20:21:37 Pete Eberlein wrote:
> From: Pete Eberlein <pete@sensoray.com>
> 
> The s2250-board i2c module was converted to use v4l2-i2c-drv.h in
> preparation for its subdev conversion.  This change prevented the
> s2250-loader from being initialized within the same module due to
> the module_init and module_exit function definitions in v4l2-i2c-drv.h.

FYI: the v4l2-i2c-drv.h header is only needed if you have to support
kernels < 2.6.26. If that is not the case, then the i2c driver can be
written as a regular i2c driver. See for example this driver:
linux/drivers/media/video/tvp514x.c.

However, I seem to remember that you told me that this driver is actually
used on pre-2.6.26 kernels, so then you have no choice but to use it.

> Therefore, s2250-loader is now its own module, and the header for
> exporting s2250-loader functions is no longer needed.
> 
> The s2250 i2c module name was "2220-board" in some places, and was
> changed to "s2250".

Looks good.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

> 
> Priority: normal
> 
> Signed-off-by: Pete Eberlein <pete@sensoray.com>
> 
> diff -r 99e4a0cf6788 -r 5fe2031944d4 linux/drivers/staging/go7007/Makefile
> --- a/linux/drivers/staging/go7007/Makefile	Tue Nov 10 10:47:34 2009 -0800
> +++ b/linux/drivers/staging/go7007/Makefile	Tue Nov 10 10:54:51 2009 -0800
> @@ -5,7 +5,7 @@
>  
>  obj-$(CONFIG_VIDEO_GO7007) += go7007.o
>  obj-$(CONFIG_VIDEO_GO7007_USB) += go7007-usb.o
> -obj-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD) += s2250.o
> +obj-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD) += s2250.o s2250-loader.o
>  obj-$(CONFIG_VIDEO_GO7007_SAA7113) += wis-saa7113.o
>  obj-$(CONFIG_VIDEO_GO7007_OV7640) += wis-ov7640.o
>  obj-$(CONFIG_VIDEO_GO7007_SAA7115) += wis-saa7115.o
> @@ -17,7 +17,7 @@
>  go7007-objs += go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
>  		snd-go7007.o
>  
> -s2250-objs += s2250-board.o s2250-loader.o
> +s2250-objs += s2250-board.o
>  
>  # Uncomment when the saa7134 patches get into upstream
>  #ifneq ($(CONFIG_VIDEO_SAA7134),)
> diff -r 99e4a0cf6788 -r 5fe2031944d4 linux/drivers/staging/go7007/go7007-driver.c
> --- a/linux/drivers/staging/go7007/go7007-driver.c	Tue Nov 10 10:47:34 2009 -0800
> +++ b/linux/drivers/staging/go7007/go7007-driver.c	Tue Nov 10 10:54:51 2009 -0800
> @@ -219,7 +219,7 @@
>  		modname = "wis-ov7640";
>  		break;
>  	case I2C_DRIVERID_S2250:
> -		modname = "s2250-board";
> +		modname = "s2250";
>  		break;
>  	default:
>  		modname = NULL;
> diff -r 99e4a0cf6788 -r 5fe2031944d4 linux/drivers/staging/go7007/go7007-usb.c
> --- a/linux/drivers/staging/go7007/go7007-usb.c	Tue Nov 10 10:47:34 2009 -0800
> +++ b/linux/drivers/staging/go7007/go7007-usb.c	Tue Nov 10 10:54:51 2009 -0800
> @@ -425,7 +425,7 @@
>  		.num_i2c_devs	 = 1,
>  		.i2c_devs	 = {
>  			{
> -				.type	= "s2250_board",
> +				.type	= "s2250",
>  				.id	= I2C_DRIVERID_S2250,
>  				.addr	= 0x43,
>  			},
> diff -r 99e4a0cf6788 -r 5fe2031944d4 linux/drivers/staging/go7007/s2250-board.c
> --- a/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:47:34 2009 -0800
> +++ b/linux/drivers/staging/go7007/s2250-board.c	Tue Nov 10 10:54:51 2009 -0800
> @@ -20,10 +20,13 @@
>  #include <linux/usb.h>
>  #include <linux/i2c.h>
>  #include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
> -#include "s2250-loader.h"
> +#include <media/v4l2-i2c-drv.h>
>  #include "go7007-priv.h"
> -#include "wis-i2c.h"
> +
> +MODULE_DESCRIPTION("Sensoray 2250/2251 i2c v4l2 subdev driver");
> +MODULE_LICENSE("GPL v2");
>  
>  #define TLV320_ADDRESS      0x34
>  #define VPX322_ADDR_ANALOGCONTROL1	0x02
> @@ -575,7 +578,7 @@
>  	dec->audio = audio;
>  	i2c_set_clientdata(client, dec);
>  
> -	printk(KERN_DEBUG
> +	printk(KERN_INFO
>  	       "s2250: initializing video decoder on %s\n",
>  	       adapter->name);
>  
> @@ -648,46 +651,20 @@
>  	return 0;
>  }
>  
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
>  static struct i2c_device_id s2250_id[] = {
> -	{ "s2250_board", 0 },
> +	{ "s2250", 0 },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(i2c, s2250_id);
>  
> -static struct i2c_driver s2250_driver = {
> -	.driver = {
> -		.name	= "Sensoray 2250 board driver",
> -	},
> -	.probe		= s2250_probe,
> -	.remove		= s2250_remove,
> -	.command	= s2250_command,
> -	.id_table	= s2250_id,
> +#endif
> +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> +	.name = "s2250",
> +	.probe = s2250_probe,
> +	.remove = s2250_remove,
> +	.command = s2250_command,
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> +	.id_table = s2250_id,
> +#endif
>  };
> -
> -static int __init s2250_init(void)
> -{
> -	int r;
> -
> -	r = s2250loader_init();
> -	if (r < 0)
> -		return r;
> -
> -	r = i2c_add_driver(&s2250_driver);
> -	if (r < 0)
> -		s2250loader_cleanup();
> -
> -	return r;
> -}
> -
> -static void __exit s2250_cleanup(void)
> -{
> -	i2c_del_driver(&s2250_driver);
> -
> -	s2250loader_cleanup();
> -}
> -
> -module_init(s2250_init);
> -module_exit(s2250_cleanup);
> -
> -MODULE_AUTHOR("");
> -MODULE_DESCRIPTION("Board driver for Sensoryray 2250");
> -MODULE_LICENSE("GPL v2");
> diff -r 99e4a0cf6788 -r 5fe2031944d4 linux/drivers/staging/go7007/s2250-loader.c
> --- a/linux/drivers/staging/go7007/s2250-loader.c	Tue Nov 10 10:47:34 2009 -0800
> +++ b/linux/drivers/staging/go7007/s2250-loader.c	Tue Nov 10 10:54:51 2009 -0800
> @@ -162,7 +162,7 @@
>  	.id_table	= s2250loader_ids,
>  };
>  
> -int s2250loader_init(void)
> +static int __init s2250loader_init(void)
>  {
>  	int r;
>  	unsigned i = 0;
> @@ -179,11 +179,15 @@
>  	printk(KERN_INFO "s2250loader_init: driver registered\n");
>  	return 0;
>  }
> -EXPORT_SYMBOL(s2250loader_init);
> +module_init(s2250loader_init);
>  
> -void s2250loader_cleanup(void)
> +static void __exit s2250loader_cleanup(void)
>  {
>  	printk(KERN_INFO "s2250loader_cleanup\n");
>  	usb_deregister(&s2250loader_driver);
>  }
> -EXPORT_SYMBOL(s2250loader_cleanup);
> +module_exit(s2250loader_cleanup);
> +
> +MODULE_AUTHOR("");
> +MODULE_DESCRIPTION("firmware loader for Sensoray 2250/2251");
> +MODULE_LICENSE("GPL v2");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
