Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57189 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785Ab3FIWKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jun 2013 18:10:35 -0400
Message-ID: <51B4FD56.6020307@iki.fi>
Date: Mon, 10 Jun 2013 01:10:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, a.hajda@samsung.com,
	hj210.choi@samsung.com, shaik.ameer@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com
Subject: Re: [REVIEW PATCH v3 1/2] media: Change media device link_notify
 behaviour
References: <1370808878-11379-1-git-send-email-s.nawrocki@samsung.com> <1370808878-11379-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1370808878-11379-2-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the update.

Sylwester Nawrocki wrote:
...
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 1d7dbd5..1a2d25c 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -792,9 +792,9 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
>
>   /*
>    * isp_pipeline_link_notify - Link management notification callback
> - * @source: Pad at the start of the link
> - * @sink: Pad at the end of the link
> + * @link: The link
>    * @flags: New link flags that will be applied
> + * @notification: The link's state change notification type (MEDIA_DEV_NOTIFY_*)
>    *
>    * React to link management on powered pipelines by updating the use count of
>    * all entities in the source and sink sides of the link. Entities are powered
> @@ -804,29 +804,38 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
>    * off is assumed to never fail. This function will not fail for disconnection
>    * events.
>    */
> -static int isp_pipeline_link_notify(struct media_pad *source,
> -				    struct media_pad *sink, u32 flags)
> +static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
> +				    unsigned int notification)
>   {
> -	int source_use = isp_pipeline_pm_use_count(source->entity);
> -	int sink_use = isp_pipeline_pm_use_count(sink->entity);
> +	struct media_entity *source = link->source->entity;
> +	struct media_entity *sink = link->sink->entity;
> +	int source_use = isp_pipeline_pm_use_count(source);
> +	int sink_use = isp_pipeline_pm_use_count(sink);
>   	int ret;
>
> -	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
> +	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> +	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
>   		/* Powering off entities is assumed to never fail. */
> -		isp_pipeline_pm_power(source->entity, -sink_use);
> -		isp_pipeline_pm_power(sink->entity, -source_use);
> +		isp_pipeline_pm_power(source, -sink_use);
> +		isp_pipeline_pm_power(sink, -source_use);
>   		return 0;
>   	}
>
> -	ret = isp_pipeline_pm_power(source->entity, sink_use);
> -	if (ret < 0)
> -		return ret;
> +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
> +		(flags & MEDIA_LNK_FL_ENABLED)) {

You could return zero here if the opposite was true, and unindent the 
rest. Up to you --- the patch is fine.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

> -	ret = isp_pipeline_pm_power(sink->entity, source_use);
> -	if (ret < 0)
> -		isp_pipeline_pm_power(source->entity, -sink_use);
> +		ret = isp_pipeline_pm_power(source, sink_use);
> +		if (ret < 0)
> +			return ret;
>
> -	return ret;
> +		ret = isp_pipeline_pm_power(sink, source_use);
> +		if (ret < 0)
> +			isp_pipeline_pm_power(source, -sink_use);
> +
> +		return ret;
> +	}
> +
> +	return 0;
>   }
>
>   /* -----------------------------------------------------------------------------

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi

