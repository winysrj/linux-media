Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51830 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbdLQRDI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 12:03:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: sakari.ailus@linux.intel.com, niklas.soderlund@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/5] v4l2: async: Postpone subdev_notifier registration
Date: Sun, 17 Dec 2017 19:03:17 +0200
Message-ID: <1903051.6PYr83kQ6W@avalon>
In-Reply-To: <1513189580-32202-5-git-send-email-jacopo+renesas@jmondi.org>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org> <1513189580-32202-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Wednesday, 13 December 2017 20:26:19 EET Jacopo Mondi wrote:
> Currently, subdevice notifiers are tested against all available
> subdevices as soon as they get registered. It often happens anyway
> that the subdevice they are connected to is not yet initialized, as
> it usually gets registered later in drivers' code. This makes debug
> of v4l2_async particularly painful, as identifying a notifier with
> an unitialized subdevice is tricky as they don't have a valid
> 'struct device *' or 'struct fwnode_handle *' to be identified with.
> 
> In order to make sure that the notifier's subdevices is initialized
> when the notifier is tesed against available subdevices post-pone the
> actual notifier registration at subdevice registration time.

Aren't you piling yet another hack on top of an already dirty framework ? How 
about fixing the root cause of the issue and ensuring that subdevs are 
properly initialized when the notifier is registered ?

> It is worth noting that post-poning registration of a subdevice notifier
> does not impact on the completion of the notifiers chain, as even if a
> subdev notifier completes as soon as it gets registered, the complete()
> call chain cannot be upscaled as long as the subdevice the notifiers
> belongs to is not registered.
> 
> Also, it is now safe to access a notifier 'struct device *' as we're now
> sure it is properly initialized when the notifier is actually
> registered.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 65 +++++++++++++++++++++-----------
>  include/media/v4l2-async.h           |  2 ++
>  2 files changed, 43 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index 0a1bf1d..c13a781 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c

[snip]

> @@ -548,6 +551,20 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  			sd->fwnode = dev_fwnode(sd->dev);
>  	}
> 
> +	/*
> +	 * If the subdevice has an unregisterd notifier, it's now time
> +	 * to register it.
> +	 */
> +	subdev_notifier = sd->subdev_notifier;
> +	if (subdev_notifier && !subdev_notifier->registered) {
> +		ret = __v4l2_async_notifier_register(subdev_notifier);
> +		if (ret) {
> +			sd->fwnode = NULL;
> +			subdev_notifier->owner = NULL;
> +			return ret;
> +		}
> +	}

This is the part I like the least in this patch set. The 
v4l2_subdev::subdev_notifier field should really disappear, there's no reason 
to limit subdevs to a single notifier. Implicit registration of notifiers is a 
dirty hack in my opinion.

>  	mutex_lock(&list_lock);
> 
>  	INIT_LIST_HEAD(&sd->async_list);

[snip]

-- 
Regards,

Laurent Pinchart
