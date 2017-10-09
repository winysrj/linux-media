Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:43872 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751184AbdJILXN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:23:13 -0400
Subject: Re: [PATCH v15 03/32] v4l: async: fix unbind error in
 v4l2_async_notifier_unregister()
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-4-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f5d777c8-4007-5ae8-6c05-76c0245dd99e@xs4all.nl>
Date: Mon, 9 Oct 2017 13:23:11 +0200
MIME-Version: 1.0
In-Reply-To: <20171004215051.13385-4-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/17 23:50, Sakari Ailus wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> The call to v4l2_async_cleanup() will set sd->asd to NULL so passing it to
> notifier->unbind() have no effect and leaves the notifier confused. Call

have -> has

> the unbind() callback prior to cleaning up the subdevice to avoid this.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

After fixing this small typo:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 21c748bf3a7b..ca281438a0ae 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -206,11 +206,11 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  	list_del(&notifier->list);
>  
>  	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> -		v4l2_async_cleanup(sd);
> -
>  		if (notifier->unbind)
>  			notifier->unbind(notifier, sd, sd->asd);
>  
> +		v4l2_async_cleanup(sd);
> +
>  		list_move(&sd->async_list, &subdev_list);
>  	}
>  
> @@ -268,11 +268,11 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  
>  	list_add(&sd->asd->list, &notifier->waiting);
>  
> -	v4l2_async_cleanup(sd);
> -
>  	if (notifier->unbind)
>  		notifier->unbind(notifier, sd, sd->asd);
>  
> +	v4l2_async_cleanup(sd);
> +
>  	mutex_unlock(&list_lock);
>  }
>  EXPORT_SYMBOL(v4l2_async_unregister_subdev);
> 
