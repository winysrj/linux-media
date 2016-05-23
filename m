Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35679 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932395AbcEWLjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 07:39:12 -0400
Subject: Re: [PATCH 2/3] media: add media_device_unregister_put() interface
To: Shuah Khan <shuahkh@osg.samsung.com>, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, inki.dae@samsung.com,
	g.liakhovetski@gmx.de, jh1009.sung@samsung.com
References: <cover.1463158822.git.shuahkh@osg.samsung.com>
 <14efd8cc91d49e34936fd227d1208429d16e3fa0.1463158822.git.shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5742EBDA.1010902@xs4all.nl>
Date: Mon, 23 May 2016 13:39:06 +0200
MIME-Version: 1.0
In-Reply-To: <14efd8cc91d49e34936fd227d1208429d16e3fa0.1463158822.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/13/2016 07:09 PM, Shuah Khan wrote:
> Add media_device_unregister_put() interface to release reference to a media
> device allocated using the Media Device Allocator API. The media device is
> unregistered and freed when the last driver that holds the reference to the
> media device releases the reference. The media device is unregistered and
> freed in the kref put handler.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/media-device.c | 11 +++++++++++
>  include/media/media-device.h | 15 +++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 33a9952..b5c279a 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -36,6 +36,7 @@
>  #include <media/media-device.h>
>  #include <media/media-devnode.h>
>  #include <media/media-entity.h>
> +#include <media/media-dev-allocator.h>
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  
> @@ -818,6 +819,16 @@ void media_device_unregister(struct media_device *mdev)
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister);
>  
> +void media_device_unregister_put(struct media_device *mdev)
> +{
> +	if (mdev == NULL)
> +		return;
> +
> +	dev_dbg(mdev->dev, "%s: mdev %p\n", __func__, mdev);
> +	media_device_put(mdev);
> +}
> +EXPORT_SYMBOL_GPL(media_device_unregister_put);
> +

I don't really see the need for a new unregister_put function. The only thing
it adds compared to media_device_put is the 'if (mdev == NULL)' check.

Is that check needed at all?

I would probably go for an API like this:

<brainstorm mode on>

/* Not sure if there should be a void *priv as the last argument */
int (*mdev_init_fnc)(struct media_device *mdev, struct device *dev);

/* Perhaps a void *priv is needed to pass to mdev_init_fnc?
   The callback is there to initialize the media_device and it's called
   with the lock held.
*/
struct media_device *media_device_allocate(struct device *dev, mdev_init_fnc fnc);

/* Helper function for usb devices */
struct media_device *media_device_usb_allocate(struct usb_device *udev,
					       char *driver_name);

/* counterpart of media_device_allocate, that makes more sense than allocate/put IMHO */
void media_device_release(struct media_device *mdev);

<brainstorm mode off>

Regards,

	Hans

>  static void media_device_release_devres(struct device *dev, void *res)
>  {
>  }
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index f743ae2..8bd836e 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -499,6 +499,18 @@ int __must_check __media_device_register(struct media_device *mdev,
>  void media_device_unregister(struct media_device *mdev);
>  
>  /**
> + * media_device_unregister_put() - Unregisters a media device element
> + *
> + * @mdev:	pointer to struct &media_device
> + *
> + * Should be called to unregister media device allocated with Media Device
> + * Allocator API media_device_get() interface.
> + * It is safe to call this function on an unregistered (but initialised)
> + * media device.
> + */
> +void media_device_unregister_put(struct media_device *mdev);
> +
> +/**
>   * media_device_register_entity() - registers a media entity inside a
>   *	previously registered media device.
>   *
> @@ -658,6 +670,9 @@ static inline int media_device_register(struct media_device *mdev)
>  static inline void media_device_unregister(struct media_device *mdev)
>  {
>  }
> +static inline void media_device_unregister_put(struct media_device *mdev)
> +{
> +}
>  static inline int media_device_register_entity(struct media_device *mdev,
>  						struct media_entity *entity)
>  {
> 
