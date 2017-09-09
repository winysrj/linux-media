Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58474 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753865AbdIIPgl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 11:36:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v9 02/24] v4l: async: Remove re-probing support
Date: Sat, 09 Sep 2017 18:36:41 +0300
Message-ID: <2128463.znNVtuGJSF@avalon>
In-Reply-To: <20170908131235.30294-3-sakari.ailus@linux.intel.com>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com> <20170908131235.30294-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday, 8 September 2017 16:11:53 EEST Sakari Ailus wrote:
> Remove V4L2 async re-probing support. The re-probing support has been
> there to support cases where the sub-devices require resources provided by
> the main driver's hardware to function, such as clocks.
> 
> Reprobing has allowed unbinding and again binding the main driver without
> explicilty unbinding the sub-device drivers. This is certainly not a
> common need, and the responsibility will be the user's going forward.
> 
> An alternative could have been to introduce notifier specific locks.
> Considering the complexity of the re-probing and that it isn't really a
> solution to a problem but a workaround, remove re-probing instead.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I agree that this is a hack, and that the problem should be addressed 
differently. I'm fine with this patch as it helps later rework of the async 
notifier code, but we need a plan to fix the problem.

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 54 ---------------------------------
>  1 file changed, 54 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index d741a8e0fdac..e109d9da4653
> 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -198,78 +198,24 @@ EXPORT_SYMBOL(v4l2_async_notifier_register);
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
> -
> -		/*
> -		 * Store device at the device cache, in order to call
> -		 * put_device() on the final step
> -		 */
> -		if (dev)
> -			dev[i++] = d;
> -		else
> -			put_device(d);
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

-- 
Regards,

Laurent Pinchart
