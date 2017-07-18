Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50149 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751492AbdGROWX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 10:22:23 -0400
Subject: Re: [PATCH v4 2/3] v4l: async: do not hold list_lock when reprobing
 devices
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
 <20170717165917.24851-3-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5a184e14-b429-fd7d-fc0c-d0520e1cc3fa@xs4all.nl>
Date: Tue, 18 Jul 2017 16:22:14 +0200
MIME-Version: 1.0
In-Reply-To: <20170717165917.24851-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/07/17 18:59, Niklas Söderlund wrote:
> There is no good reason to hold the list_lock when reprobing the devices
> and it prevents a clean implementation of subdevice notifiers. Move the
> actual release of the devices outside of the loop which requires the
> lock to be held.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 29 ++++++++++-------------------
>  1 file changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 0acf288d7227ba97..8fc84f7962386ddd 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -206,7 +206,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	unsigned int notif_n_subdev = notifier->num_subdevs;
>  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
>  	struct device **dev;
> -	int i = 0;
> +	int i, count = 0;
>  
>  	if (!notifier->v4l2_dev)
>  		return;
> @@ -222,37 +222,28 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	list_del(&notifier->list);
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		struct device *d;
> -
> -		d = get_device(sd->dev);
> +		if (dev)
> +			dev[count] = get_device(sd->dev);
> +		count++;
>  
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, sd->asd);
>  
>  		v4l2_async_cleanup(sd);
> +	}
>  
> -		/* If we handled USB devices, we'd have to lock the parent too */
> -		device_release_driver(d);
> +	mutex_unlock(&list_lock);
>  
> -		/*
> -		 * Store device at the device cache, in order to call
> -		 * put_device() on the final step
> -		 */
> +	for (i = 0; i < count; i++) {
> +		/* If we handled USB devices, we'd have to lock the parent too */
>  		if (dev)
> -			dev[i++] = d;
> -		else
> -			put_device(d);
> +			device_release_driver(dev[i]);

This changes the behavior. If the alloc failed, then at least put_device was still called.
Now that no longer happens.

Frankly I don't understand this code, it is in desperate need of some comments explaining
this whole reprobing thing.

I have this strong feeling that this function needs to be reworked.

Regards,

	Hans

>  	}
>  
> -	mutex_unlock(&list_lock);
> -
>  	/*
>  	 * Call device_attach() to reprobe devices
> -	 *
> -	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
> -	 * executed.
>  	 */
> -	while (i--) {
> +	for (i = 0; dev && i < count; i++) {
>  		struct device *d = dev[i];
>  
>  		if (d && device_attach(d) < 0) {
> 
