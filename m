Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53338 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753618AbdHXQUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 12:20:38 -0400
Date: Thu, 24 Aug 2017 19:20:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH 2/4] v4l: async: abort if memory allocation fails when
 unregistering notifiers
Message-ID: <20170824162036.k5szzrvdwnwt4pat@valkosipuli.retiisi.org.uk>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
 <20170730223158.14405-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170730223158.14405-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Mon, Jul 31, 2017 at 12:31:56AM +0200, Niklas Söderlund wrote:
> Instead of trying to cope with the failed memory allocation and still
> leaving the kernel in a semi-broken state (the subdevices will be
> released but never re-probed) simply abort. The kernel have already
> printed a warning about allocation failure but keep the error printout
> to ease pinpointing the problem if it happens.
> 
> By doing this we can increase the readability of this complex function
> which puts it in a better state to separate the v4l2 housekeeping tasks
> from the re-probing of devices. It also serves to prepare for adding
> subnotifers.

By the time the notifier has been removed from the notifier list, we're the
sole user of the notifier done list. There is thus no need to acquire the
list lock to serialise access to that list.

Is there something that prevents re-probing the devices directly off the
notifier's done list without gathering the device pointers first? As the
notifier has been removed from the notifier list already, there will be no
matches found.

> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 0acf288d7227ba97..67852f0f2d3000c9 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -215,6 +215,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	if (!dev) {
>  		dev_err(notifier->v4l2_dev->dev,
>  			"Failed to allocate device cache!\n");
> +		return;
>  	}
>  
>  	mutex_lock(&list_lock);
> @@ -234,23 +235,13 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  		/* If we handled USB devices, we'd have to lock the parent too */
>  		device_release_driver(d);
>  
> -		/*
> -		 * Store device at the device cache, in order to call
> -		 * put_device() on the final step
> -		 */
> -		if (dev)
> -			dev[i++] = d;
> -		else
> -			put_device(d);
> +		dev[i++] = d;
>  	}
>  
>  	mutex_unlock(&list_lock);
>  
>  	/*
>  	 * Call device_attach() to reprobe devices
> -	 *
> -	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
> -	 * executed.
>  	 */
>  	while (i--) {
>  		struct device *d = dev[i];
> -- 
> 2.13.3
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
