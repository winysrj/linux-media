Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53280 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751041AbcEJSpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 14:45:11 -0400
Date: Tue, 10 May 2016 21:45:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] v4l2-async: Pass the v4l2_async_subdev to the
 unbind callback
Message-ID: <20160510184506.GR26360@valkosipuli.retiisi.org.uk>
References: <1462886354-2115-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462886354-2115-1-git-send-email-alban.bedel@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alban,

On Tue, May 10, 2016 at 03:19:14PM +0200, Alban Bedel wrote:
> v4l2_async_cleanup() is always called before before calling the

s/before //

> unbind() callback. However v4l2_async_cleanup() clear the asd member,

s/clear/clears/

> so when calling the unbind() callback the v4l2_async_subdev is always
> NULL. To fix this save the asd before calling v4l2_async_cleanup().

Oh dear...! How could this have happened? :-o

With the commit message changes,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> 
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index a4b224d..ceb28d4 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -220,6 +220,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	list_del(&notifier->list);
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> +		struct v4l2_async_subdev *asd = sd->asd;
>  		struct device *d;
>  
>  		d = get_device(sd->dev);
> @@ -230,7 +231,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  		device_release_driver(d);
>  
>  		if (notifier->unbind)
> -			notifier->unbind(notifier, sd, sd->asd);
> +			notifier->unbind(notifier, sd, asd);
>  
>  		/*
>  		 * Store device at the device cache, in order to call
> @@ -313,6 +314,7 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
>  void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *notifier = sd->notifier;
> +	struct v4l2_async_subdev *asd = sd->asd;
>  
>  	if (!sd->asd) {
>  		if (!list_empty(&sd->async_list))
> @@ -327,7 +329,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  	v4l2_async_cleanup(sd);
>  
>  	if (notifier->unbind)
> -		notifier->unbind(notifier, sd, sd->asd);
> +		notifier->unbind(notifier, sd, asd);
>  
>  	mutex_unlock(&list_lock);
>  }

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
