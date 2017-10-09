Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59652 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751184AbdJILpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:45:06 -0400
Subject: Re: [PATCH v15 05/32] v4l: async: Correctly serialise async
 sub-device unregistration
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-6-sakari.ailus@linux.intel.com>
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4f8d0e6f-f982-6f7f-6d49-00a9dbc1e13e@xs4all.nl>
Date: Mon, 9 Oct 2017 13:45:04 +0200
MIME-Version: 1.0
In-Reply-To: <20171004215051.13385-6-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/17 23:50, Sakari Ailus wrote:
> The check whether an async sub-device is bound to a notifier was performed
> without list_lock held, making it possible for another process to
> unbind the async sub-device before the sub-device unregistration function
> proceeds to take the lock.
> 
> Fix this by first acquiring the lock and then proceeding with the check.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 4924481451ca..cde2cf2ab4b0 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -298,20 +298,16 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
>  
>  void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  {
> -	struct v4l2_async_notifier *notifier = sd->notifier;
> -
> -	if (!sd->asd) {
> -		if (!list_empty(&sd->async_list))
> -			v4l2_async_cleanup(sd);
> -		return;
> -	}
> -
>  	mutex_lock(&list_lock);
>  
> -	list_add(&sd->asd->list, &notifier->waiting);
> +	if (sd->asd) {
> +		struct v4l2_async_notifier *notifier = sd->notifier;
>  
> -	if (notifier->unbind)
> -		notifier->unbind(notifier, sd, sd->asd);
> +		list_add(&sd->asd->list, &notifier->waiting);
> +
> +		if (notifier->unbind)
> +			notifier->unbind(notifier, sd, sd->asd);
> +	}
>  
>  	v4l2_async_cleanup(sd);
>  
> 
