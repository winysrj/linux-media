Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2536 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab2CBIz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 03:55:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [RFC PATCH] PnP support for the new ISA radio framework
Date: Fri, 2 Mar 2012 09:55:16 +0100
Cc: linux-media@vger.kernel.org
References: <201203012025.08605.linux@rainbow-software.org>
In-Reply-To: <201203012025.08605.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203020955.16196.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ondrej!

Thanks for working on this.

It looks good, I just have a few minor points:

On Thursday, March 01, 2012 20:25:05 Ondrej Zary wrote:
> Hello,
> this is the first attempt to add PnP support to the new ISA radio framework.
> I don't like the region_size function parameter - it's needed because PnP
> reports longer port range than drv->region_size.
> 
> There is a small patch to radio-gemtek at the end that uses this PnP support
> for AOpen FX-3D/Pro Radio card (it works).
> 
> 
> diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
> index 02bcead..8722728 100644
> --- a/drivers/media/radio/radio-isa.c
> +++ b/drivers/media/radio/radio-isa.c
> @@ -26,6 +26,7 @@
>  #include <linux/delay.h>
>  #include <linux/videodev2.h>
>  #include <linux/io.h>
> +#include <linux/slab.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-fh.h>
> @@ -198,56 +199,31 @@ static bool radio_isa_valid_io(const struct 
> radio_isa_driver *drv, int io)
>  	return false;
>  }
>  
> -int radio_isa_probe(struct device *pdev, unsigned int dev)
> +struct radio_isa_card *radio_isa_alloc(struct radio_isa_driver *drv,
> +				struct device *pdev)
>  {
> -	struct radio_isa_driver *drv = pdev->platform_data;
> -	const struct radio_isa_ops *ops = drv->ops;
>  	struct v4l2_device *v4l2_dev;
> -	struct radio_isa_card *isa;
> -	int res;
> +	struct radio_isa_card *isa = drv->ops->alloc();
> +	if (!isa)
> +		return NULL;
>  
> -	isa = drv->ops->alloc();
> -	if (isa == NULL)
> -		return -ENOMEM;
>  	dev_set_drvdata(pdev, isa);
>  	isa->drv = drv;
> -	isa->io = drv->io_params[dev];
>  	v4l2_dev = &isa->v4l2_dev;
>  	strlcpy(v4l2_dev->name, dev_name(pdev), sizeof(v4l2_dev->name));
>  
> -	if (drv->probe && ops->probe) {
> -		int i;
> -
> -		for (i = 0; i < drv->num_of_io_ports; ++i) {
> -			int io = drv->io_ports[i];
> -
> -			if (request_region(io, drv->region_size, v4l2_dev->name)) {
> -				bool found = ops->probe(isa, io);
> -
> -				release_region(io, drv->region_size);
> -				if (found) {
> -					isa->io = io;
> -					break;
> -				}
> -			}
> -		}
> -	}
> -
> -	if (!radio_isa_valid_io(drv, isa->io)) {
> -		int i;
> +	return isa;
> +}
>  
> -		if (isa->io < 0)
> -			return -ENODEV;
> -		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x%03x",
> -				drv->io_ports[0]);
> -		for (i = 1; i < drv->num_of_io_ports; i++)
> -			printk(KERN_CONT "/0x%03x", drv->io_ports[i]);
> -		printk(KERN_CONT ".\n");
> -		kfree(isa);
> -		return -EINVAL;
> -	}
> +int radio_isa_common_probe(struct radio_isa_card *isa, struct device *pdev,
> +				int radio_nr, unsigned region_size)
> +{
> +	const struct radio_isa_driver *drv = isa->drv;
> +	const struct radio_isa_ops *ops = drv->ops;
> +	struct v4l2_device *v4l2_dev = &isa->v4l2_dev;
> +	int res;
>  
> -	if (!request_region(isa->io, drv->region_size, v4l2_dev->name)) {
> +	if (!request_region(isa->io, region_size, v4l2_dev->name)) {
>  		v4l2_err(v4l2_dev, "port 0x%x already in use\n", isa->io);
>  		kfree(isa);
>  		return -EBUSY;
> @@ -300,8 +276,8 @@ int radio_isa_probe(struct device *pdev, unsigned int dev)
>  		v4l2_err(v4l2_dev, "Could not setup card\n");
>  		goto err_node_reg;
>  	}
> -	res = video_register_device(&isa->vdev, VFL_TYPE_RADIO,
> -					drv->radio_nr_params[dev]);
> +	res = video_register_device(&isa->vdev, VFL_TYPE_RADIO, radio_nr);
> +
>  	if (res < 0) {
>  		v4l2_err(v4l2_dev, "Could not register device node\n");
>  		goto err_node_reg;
> @@ -316,24 +292,107 @@ err_node_reg:
>  err_hdl:
>  	v4l2_device_unregister(&isa->v4l2_dev);
>  err_dev_reg:
> -	release_region(isa->io, drv->region_size);
> +	release_region(isa->io, region_size);
>  	kfree(isa);
>  	return res;
>  }
> +
> +int radio_isa_probe(struct device *pdev, unsigned int dev)
> +{
> +	struct radio_isa_driver *drv = pdev->platform_data;
> +	const struct radio_isa_ops *ops = drv->ops;
> +	struct v4l2_device *v4l2_dev;
> +	struct radio_isa_card *isa;
> +
> +	isa = radio_isa_alloc(drv, pdev);
> +	if (!isa)
> +		return -ENOMEM;
> +	isa->io = drv->io_params[dev];
> +	v4l2_dev = &isa->v4l2_dev;
> +
> +	if (drv->probe && ops->probe) {
> +		int i;
> +
> +		for (i = 0; i < drv->num_of_io_ports; ++i) {
> +			int io = drv->io_ports[i];
> +
> +			if (request_region(io, drv->region_size, v4l2_dev->name)) {
> +				bool found = ops->probe(isa, io);
> +
> +				release_region(io, drv->region_size);
> +				if (found) {
> +					isa->io = io;
> +					break;
> +				}
> +			}
> +		}
> +	}
> +
> +	if (!radio_isa_valid_io(drv, isa->io)) {
> +		int i;
> +
> +		if (isa->io < 0)
> +			return -ENODEV;
> +		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x%03x",
> +				drv->io_ports[0]);
> +		for (i = 1; i < drv->num_of_io_ports; i++)
> +			printk(KERN_CONT "/0x%03x", drv->io_ports[i]);
> +		printk(KERN_CONT ".\n");
> +		kfree(isa);
> +		return -EINVAL;
> +	}
> +
> +	return radio_isa_common_probe(isa, pdev, drv->radio_nr_params[dev],
> +					drv->region_size);
> +}
>  EXPORT_SYMBOL_GPL(radio_isa_probe);
>  
> -int radio_isa_remove(struct device *pdev, unsigned int dev)
> +int radio_isa_common_remove(struct radio_isa_card *isa, unsigned region_size)

I would move this function to before the radio_isa_probe function.
That way the common probe and remove functions are together.

>  {
> -	struct radio_isa_card *isa = dev_get_drvdata(pdev);
>  	const struct radio_isa_ops *ops = isa->drv->ops;
>  
>  	ops->s_mute_volume(isa, true, isa->volume ? isa->volume->cur.val : 0);
>  	video_unregister_device(&isa->vdev);
>  	v4l2_ctrl_handler_free(&isa->hdl);
>  	v4l2_device_unregister(&isa->v4l2_dev);
> -	release_region(isa->io, isa->drv->region_size);
> +	release_region(isa->io, region_size);
>  	v4l2_info(&isa->v4l2_dev, "Removed radio card %s\n", isa->drv->card);
>  	kfree(isa);
>  	return 0;
>  }
> +
> +#ifdef CONFIG_PNP
> +int radio_isa_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id 
> *dev_id)
> +{
> +	struct pnp_driver *pnp_drv = to_pnp_driver(dev->dev.driver);
> +	struct radio_isa_driver *drv = container_of(pnp_drv,
> +					struct radio_isa_driver, pnp_driver);
> +	struct radio_isa_card *isa;
> +
> +	if (!pnp_port_valid(dev, 0))
> +		return -ENODEV;
> +
> +	isa = radio_isa_alloc(drv, &dev->dev);
> +	if (!isa)
> +		return -ENOMEM;
> +
> +	isa->io = pnp_port_start(dev, 0);
> +
> +	return radio_isa_common_probe(isa, &dev->dev, 0, pnp_port_len(dev, 0));

Rather than pass 0 as radio_nr I would suggest using
drv->radio_nr_params[0]. It's not perfect, but it's better than 0.

> +}
> +EXPORT_SYMBOL_GPL(radio_isa_pnp_probe);
> +
> +int radio_isa_pnp_remove(struct pnp_dev *dev)
> +{
> +	struct radio_isa_card *isa = dev_get_drvdata(&dev->dev);

Add an empty line.

> +	return radio_isa_common_remove(isa, pnp_port_len(dev, 0));
> +}
> +EXPORT_SYMBOL_GPL(radio_isa_pnp_remove);
> +#endif
> +
> +int radio_isa_remove(struct device *pdev, unsigned int dev)
> +{
> +	struct radio_isa_card *isa = dev_get_drvdata(pdev);

Add an empty line.

> +	return radio_isa_common_remove(isa, isa->drv->region_size);
> +}
>  EXPORT_SYMBOL_GPL(radio_isa_remove);

I would move this function to right after radio_isa_probe. Again, that
keeps the probe and remove functions together.

Regards,

	Hans


> diff --git a/drivers/media/radio/radio-isa.h b/drivers/media/radio/radio-isa.h
> index 8a0ea84..0e7dc25 100644
> --- a/drivers/media/radio/radio-isa.h
> +++ b/drivers/media/radio/radio-isa.h
> @@ -24,6 +24,7 @@
>  #define _RADIO_ISA_H_
>  
>  #include <linux/isa.h>
> +#include <linux/pnp.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> @@ -76,6 +77,9 @@ struct radio_isa_ops {
>  /* Top level structure needed to instantiate the cards */
>  struct radio_isa_driver {
>  	struct isa_driver driver;
> +#ifdef CONFIG_PNP
> +	struct pnp_driver pnp_driver;
> +#endif
>  	const struct radio_isa_ops *ops;
>  	/* The module_param_array with the specified I/O ports */
>  	int *io_params;
> @@ -101,5 +105,10 @@ struct radio_isa_driver {
>  int radio_isa_match(struct device *pdev, unsigned int dev);
>  int radio_isa_probe(struct device *pdev, unsigned int dev);
>  int radio_isa_remove(struct device *pdev, unsigned int dev);
> +#ifdef CONFIG_PNP
> +int radio_isa_pnp_probe(struct pnp_dev *dev,
> +			const struct pnp_device_id *dev_id);
> +int radio_isa_pnp_remove(struct pnp_dev *dev);
> +#endif
>  
>  #endif
> 
> 
> 
> diff --git a/drivers/media/radio/radio-gemtek.c 
> b/drivers/media/radio/radio-gemtek.c
> index 9d7fdae..6ea0e23 100644
> --- a/drivers/media/radio/radio-gemtek.c
> +++ b/drivers/media/radio/radio-gemtek.c
> @@ -29,6 +29,8 @@
>  #include <linux/videodev2.h>	/* kernel radio structs		*/
>  #include <linux/mutex.h>
>  #include <linux/io.h>		/* outb, outb_p			*/
> +#include <linux/pnp.h>
> +#include <linux/slab.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-device.h>
>  #include "radio-isa.h"
> @@ -282,6 +284,16 @@ static const struct radio_isa_ops gemtek_ops = {
>  
>  static const int gemtek_ioports[] = { 0x20c, 0x30c, 0x24c, 0x34c, 0x248, 
> 0x28c };
>  
> +#ifdef CONFIG_PNP
> +static struct pnp_device_id gemtek_pnp_devices[] = {
> +	/* AOpen FX-3D/Pro Radio */
> +	{.id = "ADS7183", .driver_data = 0},
> +	{.id = ""}
> +};
> +
> +MODULE_DEVICE_TABLE(pnp, gemtek_pnp_devices);
> +#endif
> +
>  static struct radio_isa_driver gemtek_driver = {
>  	.driver = {
>  		.match		= radio_isa_match,
> @@ -291,6 +303,14 @@ static struct radio_isa_driver gemtek_driver = {
>  			.name	= "radio-gemtek",
>  		},
>  	},
> +#ifdef CONFIG_PNP
> +	.pnp_driver = {
> +		.name		= "radio-gemtek",
> +		.id_table	= gemtek_pnp_devices,
> +		.probe		= radio_isa_pnp_probe,
> +		.remove		= radio_isa_pnp_remove,
> +	},
> +#endif
>  	.io_params = io,
>  	.radio_nr_params = radio_nr,
>  	.io_ports = gemtek_ioports,
> @@ -304,12 +324,14 @@ static struct radio_isa_driver gemtek_driver = {
>  static int __init gemtek_init(void)
>  {
>  	gemtek_driver.probe = probe;
> +	pnp_register_driver(&gemtek_driver.pnp_driver);
>  	return isa_register_driver(&gemtek_driver.driver, GEMTEK_MAX);
>  }
>  
>  static void __exit gemtek_exit(void)
>  {
>  	hardmute = 1;	/* Turn off PLL */
> +	pnp_unregister_driver(&gemtek_driver.pnp_driver);
>  	isa_unregister_driver(&gemtek_driver.driver);
>  }
>  
> 
> 
> 
> 
