Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48619 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932466AbcIENGW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 09:06:22 -0400
Subject: Re: [PATCH v2] [media] v4l2-async: Always unregister the subdev on
 failure
To: Alban Bedel <alban.bedel@avionic-design.de>,
        linux-media@vger.kernel.org
References: <20160824134948.21607-1-alban.bedel@avionic-design.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ecbc2938-dbd1-0862-e987-578cb86dbc70@xs4all.nl>
Date: Mon, 5 Sep 2016 15:06:14 +0200
MIME-Version: 1.0
In-Reply-To: <20160824134948.21607-1-alban.bedel@avionic-design.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alban,

On 08/24/2016 03:49 PM, Alban Bedel wrote:
> In v4l2_async_test_notify() if the registered_async callback or the
> complete notifier returns an error the subdev is not unregistered.
> This leave paths where v4l2_async_register_subdev() can fail but
> leave the subdev still registered.
> 
> Add the required calls to v4l2_device_unregister_subdev() to plug
> these holes.

This patch no longer applies after another patch from Javier was merged.

Can you rebase and post a v3?

Thanks!

	Hans

> 
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
> Changelog:
> v2: * Added the missing unbind() calls as suggested by Javier.
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index ceb28d47c3f9..abe512d0b4cb 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -113,23 +113,28 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>  	list_move(&sd->async_list, &notifier->done);
>  
>  	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
> -	if (ret < 0) {
> -		if (notifier->unbind)
> -			notifier->unbind(notifier, sd, asd);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto err_subdev_register;
>  
>  	ret = v4l2_subdev_call(sd, core, registered_async);
> -	if (ret < 0 && ret != -ENOIOCTLCMD) {
> -		if (notifier->unbind)
> -			notifier->unbind(notifier, sd, asd);
> -		return ret;
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto err_subdev_call;
> +
> +	if (list_empty(&notifier->waiting) && notifier->complete) {
> +		ret = notifier->complete(notifier);
> +		if (ret < 0)
> +			goto err_subdev_call;
>  	}
>  
> -	if (list_empty(&notifier->waiting) && notifier->complete)
> -		return notifier->complete(notifier);
> -
>  	return 0;
> +
> +err_subdev_call:
> +	v4l2_device_unregister_subdev(sd);
> +err_subdev_register:
> +	if (notifier->unbind)
> +		notifier->unbind(notifier, sd, asd);
> +
> +	return ret;
>  }
>  
>  static void v4l2_async_cleanup(struct v4l2_subdev *sd)
> 
