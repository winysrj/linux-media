Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59046 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbbEXIIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2015 04:08:23 -0400
Message-ID: <556186EF.9010306@xs4all.nl>
Date: Sun, 24 May 2015 10:08:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	sergei.shtylyov@cogentembedded.com, rob.taylor@codethink.co.uk
Subject: Re: [PATCH 08/20] media: soc_camera pad-aware driver initialisation
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-9-git-send-email-william.towle@codethink.co.uk> <555D733E.4010100@xs4all.nl> <2679646.jJocfX2rY2@avalon>
In-Reply-To: <2679646.jJocfX2rY2@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/23/2015 08:32 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 21 May 2015 07:55:10 Hans Verkuil wrote:
>> On 05/20/2015 06:39 PM, William Towle wrote:
>>> Add detection of source pad number for drivers aware of the media
>>> controller API, so that soc_camera/rcar_vin can create device nodes
>>> to support a driver such as adv7604.c (for HDMI on Lager) underneath.
>>>
>>> Signed-off-by: William Towle <william.towle@codethink.co.uk>
>>> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
>>> ---
>>>
>>>  drivers/media/platform/soc_camera/rcar_vin.c   |    4 ++++
>>>  drivers/media/platform/soc_camera/soc_camera.c |   27 ++++++++++++++++++-
>>>  include/media/soc_camera.h                     |    1 +
>>>  3 files changed, 31 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
>>> b/drivers/media/platform/soc_camera/rcar_vin.c index 0f67646..b4e9b43
>>> 100644
>>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>>> @@ -1364,8 +1364,12 @@ static int rcar_vin_get_formats(struct
>>> soc_camera_device *icd, unsigned int idx,
>>>  		struct v4l2_mbus_framefmt *mf = &fmt.format;
>>>  		struct v4l2_rect rect;
>>>  		struct device *dev = icd->parent;
>>> +		struct media_pad *remote_pad;
>>>  		int shift;
>>>
>>> +		remote_pad = media_entity_remote_pad(
>>> +					&icd->vdev->entity.pads[0]);
>>> +		fmt.pad = remote_pad->index;
>>
>> This won't work if CONFIG_MEDIA_CONTROLLER isn't defined. All these media
>> calls would all have to be under #ifdef CONFIG_MEDIA_CONTROLLER.
>>
>> Unfortunately, if it is not defined, then you still have no way of finding
>> the source pad.
>>
>> Laurent, do you think if it would make sense to add a new subdev core op
>> that will return the default source pad (I'm saying 'default' in case there
>> are more) of a subdev? That way it can be used in non-MC drivers. We never
>> needed the source pad before, but now we do, and this op only needs to be
>> implemented if the default source pad != 0.
> 
> I'm not too fond of that. Is there something wrong with the method implemented 
> in this patch ? Is the dependency on CONFIG_MEDIA_CONTROLLER an issue ?

1) it's a heck of a lot of code just to get a simple source pad that the subdev
knows anyway,

2) soc-camera doesn't use the media controller today, so this would add a
dependency on the mc just for this,

3) it doesn't actually make a media device, it is just fakes enough to make the
subdev think it there is an MC.

It doesn't actually have to be a new op, it could be a new field in v4l2_subdev
as well. For those bridge drivers that do not use the MC but do need to know
the source pad this is important information.

It might even simplify the device tree if the default source pad is implied
unless stated otherwise (but that might be a step too far).

I wonder if a default input pad might also be useful to expose. I suspect this
might become important if we want to add MC support to all existing v4l2 drivers.

Regards,

	Hans

> 
>>>  		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
>>>  		if (ret < 0)
>>>  			return ret;
>>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c
>>> b/drivers/media/platform/soc_camera/soc_camera.c index d708df4..126d645
>>> 100644
>>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>>> @@ -1293,6 +1293,7 @@ static int soc_camera_probe_finish(struct
>>> soc_camera_device *icd)
>>>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>>>  	};
>>>  	struct v4l2_mbus_framefmt *mf = &fmt.format;
>>> +	int src_pad_idx = -1;
>>>  	int ret;
>>>  	
>>>  	sd->grp_id = soc_camera_grp_id(icd);
>>> @@ -1311,7 +1312,25 @@ static int soc_camera_probe_finish(struct
>>> soc_camera_device *icd)
>>>  	}
>>>  	
>>>  	/* At this point client .probe() should have run already */
>>> -	ret = soc_camera_init_user_formats(icd);
>>> +	ret = media_entity_init(&icd->vdev->entity, 1, &icd->pad, 0);
>>> +	if (!ret) {
>>> +		for (src_pad_idx = 0; src_pad_idx < sd->entity.num_pads;
>>> +				src_pad_idx++)
>>> +			if (sd->entity.pads[src_pad_idx].flags
>>> +						== MEDIA_PAD_FL_SOURCE)
>>> +				break;
>>> +
>>> +		if (src_pad_idx < sd->entity.num_pads) {
>>> +			if (!media_entity_create_link(
>>> +				&icd->vdev->entity, 0,
>>> +				&sd->entity, src_pad_idx,
>>> +				MEDIA_LNK_FL_IMMUTABLE |
>>> +				MEDIA_LNK_FL_ENABLED)) {
>>> +				ret = soc_camera_init_user_formats(icd);
>>> +			}
>>> +		}
>>> +	}
>>> +
>>>  	if (ret < 0)
>>>  		goto eusrfmt;
>>>
>>> @@ -1322,6 +1341,7 @@ static int soc_camera_probe_finish(struct
>>> soc_camera_device *icd)
>>>  		goto evidstart;
>>>  	
>>>  	/* Try to improve our guess of a reasonable window format */
>>> +	fmt.pad = src_pad_idx;
>>>  	if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt)) {
>>>  		icd->user_width		= mf->width;
>>>  		icd->user_height	= mf->height;
>>> @@ -1335,6 +1355,7 @@ static int soc_camera_probe_finish(struct
>>> soc_camera_device *icd)
>>>  evidstart:
>>>  	soc_camera_free_user_formats(icd);
>>>  
>>>  eusrfmt:
>>> +	media_entity_cleanup(&icd->vdev->entity);
>>>  	soc_camera_remove_device(icd);
>>>  	
>>>  	return ret;
>>> @@ -1856,6 +1877,10 @@ static int soc_camera_remove(struct
>>> soc_camera_device *icd)> 
>>>  	if (icd->num_user_formats)
>>>  		soc_camera_free_user_formats(icd);
>>>
>>> +	if (icd->vdev->entity.num_pads) {
>>> +		media_entity_cleanup(&icd->vdev->entity);
>>> +	}
>>> +
>>>  	if (icd->clk) {
>>>  		/* For the synchronous case */
>>>  		v4l2_clk_unregister(icd->clk);
>>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>>> index 2f6261f..f0c5238 100644
>>> --- a/include/media/soc_camera.h
>>> +++ b/include/media/soc_camera.h
>>> @@ -42,6 +42,7 @@ struct soc_camera_device {
>>>  	unsigned char devnum;		/* Device number per host */
>>>  	struct soc_camera_sense *sense;	/* See comment in struct definition
>>>  	*/
>>>  	struct video_device *vdev;
>>> +	struct media_pad pad;
>>>  	struct v4l2_ctrl_handler ctrl_handler;
>>>  	const struct soc_camera_format_xlate *current_fmt;
>>>  	struct soc_camera_format_xlate *user_formats;
> 

