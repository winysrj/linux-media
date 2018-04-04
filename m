Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0130.outbound.protection.outlook.com ([104.47.36.130]:30016
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751255AbeDDOvv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 10:51:51 -0400
Subject: Re: [PATCH] media: platform: video-mux: propagate format from sink to
 source
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20180403195022.31188-1-chris.lesiak@licor.com>
 <1522834461.5562.13.camel@pengutronix.de>
From: Chris Lesiak <chris.lesiak@licor.com>
Message-ID: <7bee3189-0fbf-40f3-a079-9316114f5a0a@licor.com>
Date: Wed, 4 Apr 2018 09:51:46 -0500
MIME-Version: 1.0
In-Reply-To: <1522834461.5562.13.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 04/04/2018 04:34 AM, Philipp Zabel wrote:
> Hi Chris,
> 
> On Tue, 2018-04-03 at 14:50 -0500, Chris Lesiak wrote:
>> Propagate the v4l2_mbus_framefmt to the source pad when either a sink
>> pad is activated or when the format of the active sink pad changes.
> 
> Thank you, this fixes the V4L2_SUBDEV_FORMAT_TRY use case as well as
> propagation of the active format when the user calls VIDIOC_SUBDEV_S_FMT
> on the sink pad and then only VIDIOC_SUBDEV_G_FMT on the source pad.

Yes, I understood that both V4L2_SUBDEV_FORMAT_ACTIVE and 
V4L2_SUBDEV_FORMAT_TRY use cases would work.  Maybe that wasn't clear 
from the commit message.  I think understanding might be improved if the 
struct video_mux member named "active" were renamed to "selected". Would 
you consider a patch that did this?

Being able to call VIDIOC_SUBDEV_S_FMT on the sink pad and then only 
VIDIOC_SUBDEV_G_FMT on the source pad was certainly my goal.  It 
bothered me that the examples that I found for the i.MX5/6 used the 
media-ctl utility to set the format on the source pads only, relying on 
internal logic in the utility to duplicate the format on the sink pad at 
the opposite end of the link.  When I attempted to use the APIs to get 
the format of the source pads and then set them on the sink pads at the 
opposite end of the links, I found that it didn't work.  It was only 
because of this missing functionality in video-mux.

> 
>> Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
>> ---
>>   drivers/media/platform/video-mux.c | 16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
>> index ee89ad76bee2..1fb887293337 100644
>> --- a/drivers/media/platform/video-mux.c
>> +++ b/drivers/media/platform/video-mux.c
>> @@ -45,6 +45,7 @@ static int video_mux_link_setup(struct media_entity *entity,
>>   {
>>   	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
>>   	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
>> +	u16 source_pad = entity->num_pads - 1;
>>   	int ret = 0;
>>   
>>   	/*
>> @@ -74,6 +75,9 @@ static int video_mux_link_setup(struct media_entity *entity,
>>   		if (ret < 0)
>>   			goto out;
>>   		vmux->active = local->index;
>> +
>> +		/* Propagate the active format to the source */
>> +		vmux->format_mbus[source_pad] = vmux->format_mbus[vmux->active];
>>   	} else {
>>   		if (vmux->active != local->index)
>>   			goto out;
>> @@ -162,14 +166,20 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
>>   			    struct v4l2_subdev_format *sdformat)
>>   {
>>   	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
>> -	struct v4l2_mbus_framefmt *mbusformat;
>> +	struct v4l2_mbus_framefmt *mbusformat, *source_mbusformat;
>>   	struct media_pad *pad = &vmux->pads[sdformat->pad];
>> +	u16 source_pad = sd->entity.num_pads - 1;
>>   
>>   	mbusformat = __video_mux_get_pad_format(sd, cfg, sdformat->pad,
>>   					    sdformat->which);
>>   	if (!mbusformat)
>>   		return -EINVAL;
>>   
>> +	source_mbusformat = __video_mux_get_pad_format(sd, cfg, source_pad,
>> +						       sdformat->which);
>> +	if (!source_mbusformat)
>> +		return -EINVAL;
>> +
>>   	mutex_lock(&vmux->lock);
> 
> This is superfluous if pad->index != vmux->active and the same as
> mbusformat for the source pad, but I think to achieve easily readable
> code, this is ok.

I tried an alternate version where video_mux_set_format only called one 
of two new functions: video_mux_set_format_sink and 
video_mux_set_format_source.  The cost was about 30 additional lines.  I 
wasn't sure it was a good trade-off.  Would you like to see that version?

> 
>>   	/* Source pad mirrors active sink pad, no limitations on sink pads */
>> @@ -178,6 +188,10 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
>>   
>>   	*mbusformat = sdformat->format;
>>   
>> +	/* Propagate the format from an active sink to source */
>> +	if ((pad->flags & MEDIA_PAD_FL_SINK) && (pad->index == vmux->active))
> 
> The flags check could be removed. It is not necessary since vmux->active
> is never set to the source pad index.

I will make that change.

> 
>> +		*source_mbusformat = sdformat->format;
>> +
>>   	mutex_unlock(&vmux->lock);
>>   
>>   	return 0;
> 
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> regards
> Philipp
> 

Thanks for the review,
Chris
