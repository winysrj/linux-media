Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55766 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3FJKs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 06:48:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com
Subject: Re: [REVIEW PATCH v3 1/2] media: Change media device link_notify behaviour
Date: Mon, 10 Jun 2013 12:49:01 +0200
Message-ID: <17805842.6Cz4b94dag@avalon>
In-Reply-To: <51B5AEA6.1080509@samsung.com>
References: <1370808878-11379-1-git-send-email-s.nawrocki@samsung.com> <51B4FD56.6020307@iki.fi> <51B5AEA6.1080509@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 10 June 2013 12:47:02 Sylwester Nawrocki wrote:
> On 06/10/2013 12:10 AM, Sakari Ailus wrote:
> > Sylwester Nawrocki wrote:
> > ...
> > 
> >> diff --git a/drivers/media/platform/omap3isp/isp.c
> >> b/drivers/media/platform/omap3isp/isp.c index 1d7dbd5..1a2d25c 100644
> >> --- a/drivers/media/platform/omap3isp/isp.c
> >> +++ b/drivers/media/platform/omap3isp/isp.c
> >> @@ -792,9 +792,9 @@ int omap3isp_pipeline_pm_use(struct media_entity
> >> *entity, int use)>> 
> >>   /*
> >>   
> >>    * isp_pipeline_link_notify - Link management notification callback
> >> 
> >> - * @source: Pad at the start of the link
> >> - * @sink: Pad at the end of the link
> >> + * @link: The link
> >> 
> >>    * @flags: New link flags that will be applied
> >> 
> >> + * @notification: The link's state change notification type
> >> (MEDIA_DEV_NOTIFY_*)>> 
> >>    *
> >>    * React to link management on powered pipelines by updating the use
> >>    count of * all entities in the source and sink sides of the link.
> >>    Entities are powered>> 
> >> @@ -804,29 +804,38 @@ int omap3isp_pipeline_pm_use(struct media_entity
> >> *entity, int use)>> 
> >>    * off is assumed to never fail. This function will not fail for
> >>    disconnection * events.
> >>    */
> >> 
> >> -static int isp_pipeline_link_notify(struct media_pad *source,
> >> -				    struct media_pad *sink, u32 flags)
> >> +static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
> >> +				    unsigned int notification)
> >> 
> >>   {
> >> 
> >> -	int source_use = isp_pipeline_pm_use_count(source->entity);
> >> -	int sink_use = isp_pipeline_pm_use_count(sink->entity);
> >> +	struct media_entity *source = link->source->entity;
> >> +	struct media_entity *sink = link->sink->entity;
> >> +	int source_use = isp_pipeline_pm_use_count(source);
> >> +	int sink_use = isp_pipeline_pm_use_count(sink);
> >> 
> >>   	int ret;
> >> 
> >> -	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
> >> +	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> >> +	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
> >> 
> >>   		/* Powering off entities is assumed to never fail. */
> >> 
> >> -		isp_pipeline_pm_power(source->entity, -sink_use);
> >> -		isp_pipeline_pm_power(sink->entity, -source_use);
> >> +		isp_pipeline_pm_power(source, -sink_use);
> >> +		isp_pipeline_pm_power(sink, -source_use);
> >> 
> >>   		return 0;
> >>   	
> >>   	}
> >> 
> >> -	ret = isp_pipeline_pm_power(source->entity, sink_use);
> >> -	if (ret < 0)
> >> -		return ret;
> >> +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
> >> +		(flags & MEDIA_LNK_FL_ENABLED)) {
> > 
> > You could return zero here if the opposite was true, and unindent the
> > rest. Up to you --- the patch is fine.

I would personally keep the code as-is, to keep the symmetry, but I'm fine 
with both :-)

> All right, thanks for the Ack. An updated patch to follow.
> 
> > Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> >> -	ret = isp_pipeline_pm_power(sink->entity, source_use);
> >> -	if (ret < 0)
> >> -		isp_pipeline_pm_power(source->entity, -sink_use);
> >> +		ret = isp_pipeline_pm_power(source, sink_use);
> >> +		if (ret < 0)
> >> +			return ret;
> >> 
> >> -	return ret;
> >> +		ret = isp_pipeline_pm_power(sink, source_use);
> >> +		if (ret < 0)
> >> +			isp_pipeline_pm_power(source, -sink_use);
> >> +
> >> +		return ret;
> >> +	}
> >> +
> >> +	return 0;
> >> 
> >>   }

-- 
Regards,

Laurent Pinchart

