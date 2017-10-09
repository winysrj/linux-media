Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62814 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751184AbdJILWx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:22:53 -0400
Date: Mon, 9 Oct 2017 08:22:39 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v15 01/32] v4l: async: Remove re-probing support
Message-ID: <20171009082239.189b4475@vento.lan>
In-Reply-To: <20171004215051.13385-2-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
        <20171004215051.13385-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  5 Oct 2017 00:50:20 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

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

If the re-probing isn't using anywhere, that sounds a nice cleanup.
Did you check if this won't break any driver (like soc_camera)?

If not, then Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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



Thanks,
Mauro
