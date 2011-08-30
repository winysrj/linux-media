Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51983 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1H3Si6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 14:38:58 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQR009LP7SVOL@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Aug 2011 19:38:55 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LQR00AKJ7SV5L@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Aug 2011 19:38:55 +0100 (BST)
Date: Tue, 30 Aug 2011 20:38:54 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 1/5] [media] v4l: add support for selection api
In-reply-to: <201108261701.15699.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Message-id: <4E5D2E3E.4040504@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7BIT
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com>
 <1314363967-6448-2-git-send-email-t.stanislaws@samsung.com>
 <201108261701.15699.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/2011 05:01 PM, Laurent Pinchart wrote:
> Hi Tomasz,
>
> On Friday 26 August 2011 15:06:03 Tomasz Stanislawski wrote:
>> This patch introduces new api for a precise control of cropping and
>> composing features for video devices. The new ioctls are
>> VIDIOC_S_SELECTION and VIDIOC_G_SELECTION.
>>
>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   drivers/media/video/v4l2-compat-ioctl32.c |    2 ++
>>   drivers/media/video/v4l2-ioctl.c          |   28
>> ++++++++++++++++++++++++++++ include/linux/videodev2.h                 |
>> 27 +++++++++++++++++++++++++++ include/media/v4l2-ioctl.h                |
>>     4 ++++
>>   4 files changed, 61 insertions(+), 0 deletions(-)
>>
> [snip]
>
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index fca24cc..fad4fb3 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -738,6 +738,29 @@ struct v4l2_crop {
>>   	struct v4l2_rect        c;
>>   };
>>
>> +/* Hints for adjustments of selection rectangle */
>> +#define V4L2_SEL_SIZE_GE	0x00000001
>> +#define V4L2_SEL_SIZE_LE	0x00000002
>> +
>> +enum v4l2_sel_target {
>> +	V4L2_SEL_CROP_ACTIVE  = 0,
>> +	V4L2_SEL_CROP_DEFAULT = 1,
>> +	V4L2_SEL_CROP_BOUNDS  = 2,
>> +	V4L2_SEL_COMPOSE_ACTIVE  = 256 + 0,
>> +	V4L2_SEL_COMPOSE_DEFAULT = 256 + 1,
>> +	V4L2_SEL_COMPOSE_BOUNDS  = 256 + 2,
>> +	V4L2_SEL_COMPOSE_PADDED  = 256 + 3,
>> +};
>> +
>> +struct v4l2_selection {
>> +	enum v4l2_buf_type      type;
>> +	enum v4l2_sel_target	target;
>> +	__u32                   flags;
>> +	struct v4l2_rect        r;
> Maybe rect instead of r ? Lines such as
>
> 	p->c = s.r;
>
> in patch 3/5 look a bit cryptic.
Notice that struct v4l2_crop contains field c of struct v4l2_rect type.
I wanted to keep this name as short as possible because it is obvious 
that selection is a rectangle,
so its coordinates should be accessed in "the shortest" possible way :)
>> +	__u32                   reserved[9];
>> +};
>> +
>> +
>>   /*
>>    *      A N A L O G   V I D E O   S T A N D A R D
>>    */
> [snip]
>
>> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
>> index dd9f1e7..2c0396b 100644
>> --- a/include/media/v4l2-ioctl.h
>> +++ b/include/media/v4l2-ioctl.h
>> @@ -194,6 +194,10 @@ struct v4l2_ioctl_ops {
>>   					struct v4l2_crop *a);
>>   	int (*vidioc_s_crop)           (struct file *file, void *fh,
>>   					struct v4l2_crop *a);
>> +	int (*vidioc_g_selection)      (struct file *file, void *fh,
>> +					struct v4l2_selection *a);
>> +	int (*vidioc_s_selection)      (struct file *file, void *fh,
>> +					struct v4l2_selection *a);
> Why 'a' ? Don't blindly copy past mistakes :-) 'sel' would be a more
> descriptive parameter name.
Maybe just 's' is good enough. It keeps naming used by other ops.
>>   	/* Compression ioctls */
>>   	int (*vidioc_g_jpegcomp)       (struct file *file, void *fh,
>>   					struct v4l2_jpegcompression *a);

