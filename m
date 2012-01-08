Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:21538 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab2AHUyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jan 2012 15:54:23 -0500
Message-ID: <4F0A027C.1090904@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 22:54:20 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 05/17] v4l: Support s_crop and g_crop through s/g_selection
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-5-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201051713.58513.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201051713.58513.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Tuesday 20 December 2011 21:27:57 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Revert to s_selection if s_crop isn't implemented by a driver. Same for
>> g_selection / g_crop.
> 
> Shouldn't this say "Fall back" instead of "Revert" ?

Fixed all issues you mentioned in this e-mail.

>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/v4l2-subdev.c |   37
>> +++++++++++++++++++++++++++++++++++-- 1 files changed, 35 insertions(+), 2
>> deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-subdev.c
>> b/drivers/media/video/v4l2-subdev.c index e8ae098..f8de551 100644
>> --- a/drivers/media/video/v4l2-subdev.c
>> +++ b/drivers/media/video/v4l2-subdev.c
>> @@ -226,6 +226,8 @@ static long subdev_do_ioctl(struct file *file, unsigned
>> int cmd, void *arg)
>>
>>  	case VIDIOC_SUBDEV_G_CROP: {
>>  		struct v4l2_subdev_crop *crop = arg;
>> +		struct v4l2_subdev_selection sel;
>> +		int rval;
>>
>>  		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
>>  		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
>> @@ -234,11 +236,27 @@ static long subdev_do_ioctl(struct file *file,
>> unsigned int cmd, void *arg) if (crop->pad >= sd->entity.num_pads)
>>  			return -EINVAL;
>>
>> -		return v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
>> +		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
>> +		if (rval != -ENOIOCTLCMD)
>> +			return rval;
>> +
>> +		memset(&sel, 0, sizeof(sel));
>> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> 
> Shouldn't sel.which be set to crop->which ?
> 
>> +		sel.pad = crop->pad;
>> +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
>> +
>> +		rval = v4l2_subdev_call(
>> +			sd, pad, get_selection, subdev_fh, &sel);
>> +
>> +		crop->rect = sel.r;
>> +
>> +		return rval;
>>  	}
>>
>>  	case VIDIOC_SUBDEV_S_CROP: {
>>  		struct v4l2_subdev_crop *crop = arg;
>> +		struct v4l2_subdev_selection sel;
>> +		int rval;
>>
>>  		if (crop->which != V4L2_SUBDEV_FORMAT_TRY &&
>>  		    crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
>> @@ -247,7 +265,22 @@ static long subdev_do_ioctl(struct file *file,
>> unsigned int cmd, void *arg) if (crop->pad >= sd->entity.num_pads)
>>  			return -EINVAL;
>>
>> -		return v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
>> +		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
>> +		if (rval != -ENOIOCTLCMD)
>> +			return rval;
>> +
>> +		memset(&sel, 0, sizeof(sel));
>> +		sel.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> 
> Same here.
> 
>> +		sel.pad = crop->pad;
>> +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE;
>> +		sel.r = crop->rect;
>> +
>> +		rval = v4l2_subdev_call(
>> +			sd, pad, set_selection, subdev_fh, &sel);
>> +
>> +		crop->rect = sel.r;
>> +
>> +		return rval;
>>  	}
>>
>>  	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
