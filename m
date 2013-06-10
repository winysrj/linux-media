Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11551 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3FJK7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 06:59:48 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO6004MCBT18150@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 11:59:46 +0100 (BST)
Message-id: <51B5B19F.6000200@samsung.com>
Date: Mon, 10 Jun 2013 12:59:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com
Subject: Re: [REVIEW PATCH v3 1/2] media: Change media device link_notify
 behaviour
References: <1370808878-11379-1-git-send-email-s.nawrocki@samsung.com>
 <51B4FD56.6020307@iki.fi> <51B5AEA6.1080509@samsung.com>
 <17805842.6Cz4b94dag@avalon>
In-reply-to: <17805842.6Cz4b94dag@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2013 12:49 PM, Laurent Pinchart wrote:
>>>> -static int isp_pipeline_link_notify(struct media_pad *source,
>>>> > >> -				    struct media_pad *sink, u32 flags)
>>>> > >> +static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
>>>> > >> +				    unsigned int notification)
>>>> > >> 
>>>> > >>   {
>>>> > >> 
>>>> > >> -	int source_use = isp_pipeline_pm_use_count(source->entity);
>>>> > >> -	int sink_use = isp_pipeline_pm_use_count(sink->entity);
>>>> > >> +	struct media_entity *source = link->source->entity;
>>>> > >> +	struct media_entity *sink = link->sink->entity;
>>>> > >> +	int source_use = isp_pipeline_pm_use_count(source);
>>>> > >> +	int sink_use = isp_pipeline_pm_use_count(sink);
>>>> > >> 
>>>> > >>   	int ret;
>>>> > >> 
>>>> > >> -	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
>>>> > >> +	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
>>>> > >> +	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
>>>> > >> 
>>>> > >>   		/* Powering off entities is assumed to never fail. */
>>>> > >> 
>>>> > >> -		isp_pipeline_pm_power(source->entity, -sink_use);
>>>> > >> -		isp_pipeline_pm_power(sink->entity, -source_use);
>>>> > >> +		isp_pipeline_pm_power(source, -sink_use);
>>>> > >> +		isp_pipeline_pm_power(sink, -source_use);
>>>> > >> 
>>>> > >>   		return 0;
>>>> > >>   	
>>>> > >>   	}
>>>> > >> 
>>>> > >> -	ret = isp_pipeline_pm_power(source->entity, sink_use);
>>>> > >> -	if (ret < 0)
>>>> > >> -		return ret;
>>>> > >> +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
>>>> > >> +		(flags & MEDIA_LNK_FL_ENABLED)) {
>>> > > 
>>> > > You could return zero here if the opposite was true, and unindent the
>>> > > rest. Up to you --- the patch is fine.
>
> I would personally keep the code as-is, to keep the symmetry, but I'm fine 
> with both :-)

I had also an impression that it looks more symmetric as-is. I would leave it
unchanged then. ;)

Regards,
Sylwester
