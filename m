Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36358 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750964AbeAPPXJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 10:23:09 -0500
Date: Tue, 16 Jan 2018 17:23:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        niklas.soderlund@ragnatech.se,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        hans.verkuil@cisco.com, mchehab@kernel.org
Subject: Re: [PATCH] v4l: async: Protect against double notifier regstrations
Message-ID: <20180116152305.j7luryentsej42yq@valkosipuli.retiisi.org.uk>
References: <1516114358-5292-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516114358-5292-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, Jan 16, 2018 at 02:52:58PM +0000, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> It can be easy to attempt to register the same notifier twice
> in mis-handled error cases such as working with -EPROBE_DEFER.
> 
> This results in odd kernel crashes where the notifier_list becomes
> corrupted due to adding the same entry twice.
> 
> Protect against this so that a developer has some sense of the pending
> failure.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 2b08d03b251d..e8476f0755ca 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -374,6 +374,7 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  	struct device *dev =
>  		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
>  	struct v4l2_async_subdev *asd;
> +	struct v4l2_async_notifier *n;
>  	int ret;
>  	int i;
>  
> @@ -385,6 +386,19 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  
>  	mutex_lock(&list_lock);
>  
> +	/*
> +	 * Registering the same notifier can occur if a driver incorrectly
> +	 * handles a -EPROBE_DEFER for example, and will break in a
> +	 * confusing fashion with linked-list corruption.
> +	 */

This would seem fine in the commit message, and it's essentially there
already. How about simply:

	/* Avoid re-registering a notifier. */
	
You should actually perform the check before initialising the notifier's
lists. Although things are likely in a quite bad shape already if this
happens.

> +	list_for_each_entry(n, &notifier_list, list) {
> +		if (n == notifier) {

if (WARN_ON(n == notifier)) {

And drop the error message below?

> +			dev_err(dev, "Notifier has already been registered\n");
> +			ret = -EEXIST;
> +			goto err_unlock;
> +		}
> +	}
> +
>  	for (i = 0; i < notifier->num_subdevs; i++) {
>  		asd = notifier->subdevs[i];
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
