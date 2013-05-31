Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63682 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3EaKCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:02:51 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNN009PRQIOYE70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 11:02:48 +0100 (BST)
Message-id: <51A87546.7090909@samsung.com>
Date: Fri, 31 May 2013 12:02:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hj210.choi@samsung.com,
	dh09.lee@samsung.com, a.hajda@samsung.com, shaik.ameer@samsung.com,
	arun.kk@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 09/13] media: Change media device link_notify behaviour
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
 <1368113805-20233-10-git-send-email-s.nawrocki@samsung.com>
 <3488951.XA3XI6iGCP@avalon>
In-reply-to: <3488951.XA3XI6iGCP@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 05/30/2013 04:02 AM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> Thank you for the patch, and sorry for the late reply.

Thank you for review, the timing is just fine. :-)

> On Thursday 09 May 2013 17:36:41 Sylwester Nawrocki wrote:
>> Currently the media device link_notify callback is invoked before the
>> actual change of state of a link when the link is being enabled, and
>> after the actual change of state when the link is being disabled.
>>
>> This doesn't allow a media device driver to perform any operations
>> on a full graph before a link is disabled, as well as performing
>> any tasks on a modified graph right after a link's state is changed.
>>
>> This patch modifies signature of the link_notify callback. This
>> callback is now called always before and after a link's state change.
>> To distinguish the notifications a 'notification' argument is added
>> to the link_notify callback: MEDIA_DEV_NOTIFY_PRE_LINK_CH indicates
>> notification before link's state change and
>> MEDIA_DEV_NOTIFY_POST_LINK_CH corresponds to a notification after
>> link flags change.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/media-entity.c                  |   18 +++--------
>>  drivers/media/platform/exynos4-is/media-dev.c |   16 +++++-----
>>  drivers/media/platform/omap3isp/isp.c         |   41 +++++++++++++---------
>>  include/media/media-device.h                  |    9 ++++--
>>  4 files changed, 46 insertions(+), 38 deletions(-)
[...]
>> --- a/drivers/media/platform/exynos4-is/media-dev.c
>> +++ b/drivers/media/platform/exynos4-is/media-dev.c
>> @@ -1274,34 +1274,36 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool
>> on) return __fimc_md_set_camclk(fmd, si, on);
>>  }
>>
>> -static int fimc_md_link_notify(struct media_pad *source,
>> -			       struct media_pad *sink, u32 flags)
>> +static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
>> +						unsigned int notification)
>>  {
>> +	struct media_entity *sink = link->sink->entity;
>>  	struct exynos_video_entity *ve;
>>  	struct video_device *vdev;
>>  	struct fimc_pipeline *pipeline;
>>  	int i, ret = 0;
>>
>> -	if (media_entity_type(sink->entity) != MEDIA_ENT_T_DEVNODE_V4L)
>> +	if (media_entity_type(sink) != MEDIA_ENT_T_DEVNODE_V4L ||
>> +	    notification == MEDIA_DEV_NOTIFY_LINK_PRE_CH)
> 
> Don't you need to call __fimc_pipeline_open() on post-notify instead of pre-
> notified below ?

Yes, that was the intention. I wanted to minimize changes to the drivers in
this patch. Thus this notifier function is further modified in patch 10/13.

>>  		return 0;
>>
>> -	vdev = media_entity_to_video_device(sink->entity);
>> +	vdev = media_entity_to_video_device(sink);
>>  	ve = vdev_to_exynos_video_entity(vdev);
>>  	pipeline = to_fimc_pipeline(ve->pipe);
>>
>>  	if (!(flags & MEDIA_LNK_FL_ENABLED) && pipeline->subdevs[IDX_SENSOR]) {
>> -		if (sink->entity->use_count > 0)
>> +		if (sink->use_count > 0)
>>  			ret = __fimc_pipeline_close(ve->pipe);
>>
>>  		for (i = 0; i < IDX_MAX; i++)
>>  			pipeline->subdevs[i] = NULL;
>> -	} else if (sink->entity->use_count > 0) {
>> +	} else if (sink->use_count > 0) {
>>  		/*
>>  		 * Link activation. Enable power of pipeline elements only if
>>  		 * the pipeline is already in use, i.e. its video node is open.
>>  		 * Recreate the controls destroyed during the link deactivation.
>>  		 */
>> -		ret = __fimc_pipeline_open(ve->pipe, sink->entity, true);
>> +		ret = __fimc_pipeline_open(ve->pipe, sink, true);
>>  	}
>>
>>  	return ret ? -EPIPE : ret;
>> diff --git a/drivers/media/platform/omap3isp/isp.c
>> b/drivers/media/platform/omap3isp/isp.c index 6e5ad8e..a762aeb 100644
>> --- a/drivers/media/platform/omap3isp/isp.c
>> +++ b/drivers/media/platform/omap3isp/isp.c
>> @@ -670,9 +670,9 @@ int omap3isp_pipeline_pm_use(struct media_entity
>> *entity, int use)
>>
>>  /*
>>   * isp_pipeline_link_notify - Link management notification callback
>> - * @source: Pad at the start of the link
>> - * @sink: Pad at the end of the link
>> + * @link: The link
>>   * @flags: New link flags that will be applied
>> + * @notification: The link's state change notification type
>> (MEDIA_DEV_NOTIFY_*) *
>>   * React to link management on powered pipelines by updating the use count
>>   * of all entities in the source and sink sides of the link. Entities are
>>   * powered
>> @@ -682,29 +682,38 @@ int omap3isp_pipeline_pm_use(struct
>> media_entity *entity, int use)
>>   * off is assumed to never fail. This function will not fail for
>>   * disconnection events.
>>   */
>> -static int isp_pipeline_link_notify(struct media_pad *source,
>> -				    struct media_pad *sink, u32 flags)
>> +static int isp_pipeline_link_notify(struct media_link *link, unsigned int
>> +						flags, unsigned int notification)
>>  {
>> -	int source_use = isp_pipeline_pm_use_count(source->entity);
>> -	int sink_use = isp_pipeline_pm_use_count(sink->entity);
>> +	struct media_entity *source = link->source->entity;
>> +	struct media_entity *sink = link->sink->entity;
>> +	int source_use = isp_pipeline_pm_use_count(source);
>> +	int sink_use = isp_pipeline_pm_use_count(sink);
>>  	int ret;
>>
>> -	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
>> +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
>> +	    !(flags & MEDIA_LNK_FL_ENABLED)) {
> 
> Shouldn't the condition be
> 
> 	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
> 	    (flags & MEDIA_LNK_FL_ENABLED))
> 
> here ? The code currently pre-notifies on link enable and post-notifies on 
> link disable.

Hmm, it seems I failed to retain the original behaviour :-/
But shouldn't the condition really be:

	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
	    !(flags & MEDIA_LNK_FL_ENABLED)) {
?
>>  		/* Powering off entities is assumed to never fail. */
>> -		isp_pipeline_pm_power(source->entity, -sink_use);
>> -		isp_pipeline_pm_power(sink->entity, -source_use);
>> +		isp_pipeline_pm_power(source, -sink_use);
>> +		isp_pipeline_pm_power(sink, -source_use);
>>  		return 0;
>>  	}
>>
>> -	ret = isp_pipeline_pm_power(source->entity, sink_use);
>> -	if (ret < 0)
>> -		return ret;
>> +	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
>> +	        (flags & MEDIA_LNK_FL_ENABLED)) {
> 
> Similarly, shouldn't this be
> 
> 	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> 	    !(flags & MEDIA_LNK_FL_ENABLED))

And this one

	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
	        (flags & MEDIA_LNK_FL_ENABLED)) {
?
Since originally the code notified about link activation before
activating the link ?

Regards,
Sylwester

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
Samsung Electronics
