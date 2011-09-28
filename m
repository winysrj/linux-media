Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10133 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1I1K1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 06:27:25 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LS800EKUADN5K@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Sep 2011 11:27:23 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LS800ACUADNPL@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Sep 2011 11:27:23 +0100 (BST)
Date: Wed, 28 Sep 2011 12:27:19 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 3/5] [media] v4l: simulate old crop API using extended
 crop/compose API
In-reply-to: <201109271130.55602.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com
Message-id: <4E82F687.3050200@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7BIT
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
 <1314363967-6448-4-git-send-email-t.stanislaws@samsung.com>
 <201109271130.55602.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/27/2011 11:30 AM, Hans Verkuil wrote:
> On Friday, August 26, 2011 15:06:05 Tomasz Stanislawski wrote:
>> This patch allows new video drivers to work correctly with applications that
>> use the old-style crop API.  The old crop ioctl is simulated by using selection
>> callbacks.
>>
>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   drivers/media/video/v4l2-ioctl.c |   86 +++++++++++++++++++++++++++++++++----
>>   1 files changed, 76 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
>> index 6e02b45..543405b 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>> @@ -1696,11 +1696,31 @@ static long __video_do_ioctl(struct file *file,
>>   	{
>>   		struct v4l2_crop *p = arg;
>>
>> -		if (!ops->vidioc_g_crop)
>> +		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>> +
>> +		if (ops->vidioc_g_crop) {
>> +			ret = ops->vidioc_g_crop(file, fh, p);
>> +		} else
>> +		if (ops->vidioc_g_selection) {
>> +			/* simulate capture crop using selection api */
>> +			struct v4l2_selection s = {
>> +				.type = p->type,
>> +				.target = V4L2_SEL_CROP_ACTIVE,
>> +			};
>> +
>> +			/* crop means compose for output devices */
>> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +				s.target = V4L2_SEL_COMPOSE_ACTIVE;
>> +
>> +			ret = ops->vidioc_g_selection(file, fh,&s);
>> +
>> +			/* copying results to old structure on success */
>> +			if (!ret)
>> +				p->c = s.r;
>> +		} else {
>>   			break;
>> +		}
>>
>> -		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>> -		ret = ops->vidioc_g_crop(file, fh, p);
>>   		if (!ret)
>>   			dbgrect(vfd, "",&p->c);
>>   		break;
>> @@ -1709,11 +1729,26 @@ static long __video_do_ioctl(struct file *file,
>>   	{
>>   		struct v4l2_crop *p = arg;
>>
>> -		if (!ops->vidioc_s_crop)
>> -			break;
>>   		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>>   		dbgrect(vfd, "",&p->c);
>> -		ret = ops->vidioc_s_crop(file, fh, p);
>> +
>> +		if (ops->vidioc_s_crop) {
>> +			ret = ops->vidioc_s_crop(file, fh, p);
>> +		} else
>> +		if (ops->vidioc_s_selection) {
>> +			/* simulate capture crop using selection api */
>> +			struct v4l2_selection s = {
>> +				.type = p->type,
>> +				.target = V4L2_SEL_CROP_ACTIVE,
>> +				.r = p->c,
>> +			};
>> +
>> +			/* crop means compose for output devices */
>> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +				s.target = V4L2_SEL_COMPOSE_ACTIVE;
>> +
>> +			ret = ops->vidioc_s_selection(file, fh,&s);
>> +		}
>>   		break;
>>   	}
>>   	case VIDIOC_G_SELECTION:
>> @@ -1746,12 +1781,43 @@ static long __video_do_ioctl(struct file *file,
>>   	{
>>   		struct v4l2_cropcap *p = arg;
>>
>> -		/*FIXME: Should also show v4l2_fract pixelaspect */
>> -		if (!ops->vidioc_cropcap)
>> +		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>> +		if (ops->vidioc_cropcap) {
>> +			ret = ops->vidioc_cropcap(file, fh, p);
>> +		} else
>> +		if (ops->vidioc_g_selection) {
>> +			struct v4l2_selection s = { .type = p->type };
>> +			struct v4l2_rect bounds;
>> +
>> +			/* obtaining bounds */
>> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +				s.target = V4L2_SEL_COMPOSE_BOUNDS;
>> +			else
>> +				s.target = V4L2_SEL_CROP_BOUNDS;
>> +			ret = ops->vidioc_g_selection(file, fh,&s);
>> +			if (ret)
>> +				break;
>> +			bounds = s.r;
>> +
>> +			/* obtaining defrect */
>> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>> +				s.target = V4L2_SEL_COMPOSE_DEFAULT;
>> +			else
>> +				s.target = V4L2_SEL_CROP_DEFAULT;
>> +			ret = ops->vidioc_g_selection(file, fh,&s);
>> +			if (ret)
>> +				break;
>> +
>> +			/* storing results */
>> +			p->bounds = bounds;
>> +			p->defrect = s.r;
>> +			p->pixelaspect.numerator = 1;
>> +			p->pixelaspect.denominator = 1;
>> +		} else {
>>   			break;
>> +		}
>>
>> -		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>> -		ret = ops->vidioc_cropcap(file, fh, p);
>> +		/*FIXME: Should also show v4l2_fract pixelaspect */
>
> We really need a solution for this. I'm not happy that this hasn't been
> resolved yet.
>
> What about this: if ops->vidioc_g_selection is non-NULL, then fill in bounds
> and defrect as above. But also call ops->vidioc_cropcap at the end if non-NULL,
> so that the driver can fill in the pixelaspect.
>
> So the code would look like this:
>
> 	if (ops->vidioc_g_selection) {
> 		fill in bounds and defrect and set pixelaspect to 1, 1
> 	}
> 	if (ops->vidioc_cropcap)
> 		ops->vidioc_cropcap();
>
> If a driver supports g_selection, then cropcap only needs to fill in the
> pixelaspect.

If cropcap ioctl is missing there is no way to obtain pixelaspect from 
the driver, so 1/1 value is used. On the other hand, if cropcap is 
present there is no need to call g_selection calls to get defrect and 
bounds.

I think that there is a problem with pixel aspect field. Please refer to 
post:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/38440/focus=38730

The idea was to move pixelaspect to v4l2_standard. The value would be 
selected from look-up table using standard returned by vidioc_g_std or 
using 1/1 is no analog TV is used. It should work well because majority 
of drivers use 1/1 value. Only some TV drivers behaves differently 
returning values depending on refresh rate that depends only on TV standard.

What do think about this idea?

Best regards,
Tomasz Stanislawski

>
>>   		if (!ret) {
>>   			dbgrect(vfd, "bounds ",&p->bounds);
>>   			dbgrect(vfd, "defrect ",&p->defrect);
>>
>
> And let's show the pixelaspect here as well.
>
> Does this sounds reasonable?
>
> Regards,
>
> 	Hans

