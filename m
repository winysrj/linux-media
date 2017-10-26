Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:48172 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932315AbdJZPUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 11:20:12 -0400
Received: by mail-lf0-f65.google.com with SMTP id a69so4176456lfe.5
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 08:20:12 -0700 (PDT)
Date: Thu, 26 Oct 2017 17:20:09 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 01/32] v4l: async: Remove re-probing support
Message-ID: <20171026152009.GA2297@bigcity.dyn.berto.se>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171026075342.5760-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-10-26 10:53:11 +0300, Sakari Ailus wrote:
> Remove V4L2 async re-probing support. The re-probing support has been
> there to support cases where the sub-devices require resources provided by
> the main driver's hardware to function, such as clocks.
> 
> Reprobing has allowed unbinding and again binding the main driver without
> explicitly unbinding the sub-device drivers. This is certainly not a
> common need, and the responsibility will be the user's going forward.
> 
> An alternative could have been to introduce notifier specific locks.
> Considering the complexity of the re-probing and that it isn't really a
> solution to a problem but a workaround, remove re-probing instead.
> 
> If there is a need to support the clock provider unregister/register cycle
> while keeping the clock references in the consumers in the future, this
> should be implemented in the clock framework instead, not in V4L2.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

Acked-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 54 +-----------------------------------
>  1 file changed, 1 insertion(+), 53 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index d741a8e0fdac..60a1a50b9537 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -198,78 +198,26 @@ EXPORT_SYMBOL(v4l2_async_notifier_register);
>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  {
>  	struct v4l2_subdev *sd, *tmp;
> -	unsigned int notif_n_subdev = notifier->num_subdevs;
> -	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
> -	struct device **dev;
> -	int i = 0;
>  
>  	if (!notifier->v4l2_dev)
>  		return;
>  
> -	dev = kvmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
> -	if (!dev) {
> -		dev_err(notifier->v4l2_dev->dev,
> -			"Failed to allocate device cache!\n");
> -	}
> -
>  	mutex_lock(&list_lock);
>  
>  	list_del(&notifier->list);
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		struct device *d;
> -
> -		d = get_device(sd->dev);
> -
>  		v4l2_async_cleanup(sd);
>  
> -		/* If we handled USB devices, we'd have to lock the parent too */
> -		device_release_driver(d);
> -
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, sd->asd);
>  
> -		/*
> -		 * Store device at the device cache, in order to call
> -		 * put_device() on the final step
> -		 */
> -		if (dev)
> -			dev[i++] = d;
> -		else
> -			put_device(d);
> +		list_move(&sd->async_list, &subdev_list);
>  	}
>  
>  	mutex_unlock(&list_lock);
>  
> -	/*
> -	 * Call device_attach() to reprobe devices
> -	 *
> -	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
> -	 * executed.
> -	 */
> -	while (i--) {
> -		struct device *d = dev[i];
> -
> -		if (d && device_attach(d) < 0) {
> -			const char *name = "(none)";
> -			int lock = device_trylock(d);
> -
> -			if (lock && d->driver)
> -				name = d->driver->name;
> -			dev_err(d, "Failed to re-probe to %s\n", name);
> -			if (lock)
> -				device_unlock(d);
> -		}
> -		put_device(d);
> -	}
> -	kvfree(dev);
> -
>  	notifier->v4l2_dev = NULL;
> -
> -	/*
> -	 * Don't care about the waiting list, it is initialised and populated
> -	 * upon notifier registration.
> -	 */
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>  
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas S�derlund
