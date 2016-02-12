Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37401 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbcBLJw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:52:56 -0500
Subject: Re: [PATCH 02/11] [media] v4l2-mc: add a routine to create USB
 media_device
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	no To-header on input <""@pop.xs4all.nl>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
 <61ab4e5c2fa8fea92730bfe261b4b2babf21f43f.1455269986.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56BDAB73.2050505@xs4all.nl>
Date: Fri, 12 Feb 2016 10:52:51 +0100
MIME-Version: 1.0
In-Reply-To: <61ab4e5c2fa8fea92730bfe261b4b2babf21f43f.1455269986.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2016 10:44 AM, Mauro Carvalho Chehab wrote:
> Instead of copying exactly the same code on all USB devices,
> add an ancillary routine that will create and fill the
> struct media_device with the values imported from the USB
> device.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-mc.c | 41 ++++++++++++++++++++++++++++++++++++++-
>  include/media/v4l2-mc.h           | 39 ++++++++++++++++++++++++++++++++-----
>  2 files changed, 74 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index b6cf6dbd4cd5..649972e87621 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -16,12 +16,13 @@
>  
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <linux/usb.h>
>  #include <media/media-entity.h>
>  #include <media/v4l2-mc.h>
>  
>  
>  struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
> -						   char *name)
> +						   const char *name)
>  {
>  #ifdef CONFIG_PCI
>  	struct media_device *mdev;
> @@ -53,6 +54,44 @@ struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
>  }
>  EXPORT_SYMBOL_GPL(v4l2_mc_pci_media_device_init);
>  
> +struct media_device * __v4l2_mc_usb_media_device_init(struct usb_device *udev,
> +						      const char *board_name,
> +						      const char *driver_name)
> +{
> +#ifdef CONFIG_USB
> +	struct media_device *mdev;
> +
> +	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> +	if (!mdev)
> +		return NULL;
> +
> +	mdev->dev = &udev->dev;
> +
> +	if (driver_name)
> +		strlcpy(mdev->driver_name, driver_name,
> +			sizeof(mdev->driver_name));
> +
> +	if (board_name)
> +		strlcpy(mdev->model, board_name, sizeof(mdev->model));
> +	else if (udev->product)
> +		strlcpy(mdev->model, udev->product, sizeof(mdev->model));
> +	else
> +		strlcpy(mdev->model, "unknown model", sizeof(mdev->model));
> +	if (udev->serial)
> +		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
> +	strcpy(mdev->bus_info, udev->devpath);

I would use strlcpy here as well. Just to be safe.

I also noticed that in v4l2_mc_pci_media_device_init() you use sprintf for bus_info
instead of snprintf. There too I would prefer to see snprintf.

Regards,

	Hans

> +	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
> +	mdev->driver_version = LINUX_VERSION_CODE;
> +
> +	media_device_init(mdev);
> +
> +	return mdev;
> +#else
> +	return NULL;
> +#endif
> +}
> +EXPORT_SYMBOL_GPL(__v4l2_mc_usb_media_device_init);
> +
>  int v4l2_mc_create_media_graph(struct media_device *mdev)
>  
>  {
> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> index 20f1ee285947..06641ba14eef 100644
> --- a/include/media/v4l2-mc.h
> +++ b/include/media/v4l2-mc.h
> @@ -95,8 +95,9 @@ enum demod_pad_index {
>  	DEMOD_NUM_PADS
>  };
>  
> -
> -struct pci_dev;		/* We don't need to include pci.h here */
> +/* We don't need to include pci.h or usb.h here */
> +struct pci_dev;
> +struct usb_device;
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  /**
> @@ -124,8 +125,24 @@ int v4l2_mc_create_media_graph(struct media_device *mdev);
>   *		name for the pci device, given by pci_name() macro.
>   */
>  struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
> -						   char *name);
> -
> +						   const char *name);
> +/**
> + * __v4l2_mc_usb_media_device_init() - create and initialize a
> + *	struct &media_device from a PCI device.
> + *
> + * @udev:	pointer to struct usb_device
> + * @board_name:	media device name. If %NULL, the routine will use the usb
> + *		product name, if available.
> + * @driver_name: name of the driver. if %NULL, the routine will use the name
> + *		given by udev->dev->driver->name, with is usually the wrong
> + *		thing to do.
> + *
> + * NOTE: It is better to call v4l2_mc_usb_media_device_init() instead, as
> + * such macro fills driver_name with %KBUILD_MODNAME.
> + */
> +struct media_device * __v4l2_mc_usb_media_device_init(struct usb_device *udev,
> +						      const char *board_name,
> +						      const char *driver_name);
>  
>  #else
>  static inline int v4l2_mc_create_media_graph(struct media_device *mdev)
> @@ -133,11 +150,23 @@ static inline int v4l2_mc_create_media_graph(struct media_device *mdev)
>  	return 0;
>  }
>  
> +static inline
>  struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
> -						   char *name) {
> +						   char *name)
> +{
>  	return NULL;
>  }
>  
> +static inline
> +struct media_device * __v4l2_mc_usb_media_device_init(struct usb_device *udev,
> +						      char *board_name,
> +						      char *driver_name)
> +{
> +	return NULL;
> +}
>  #endif
>  
> +#define v4l2_mc_usb_media_device_init(udev, name) \
> +	__v4l2_mc_usb_media_device_init(udev, name, KBUILD_MODNAME)
> +
>  #endif
> 

