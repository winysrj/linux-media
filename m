Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:36702 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2BDUbj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Feb 2012 15:31:39 -0500
Message-ID: <4F2D9581.1040809@iki.fi>
Date: Sat, 04 Feb 2012 22:30:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: Re: [PATCH v2 04/31] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <20120202235231.GC841@valkosipuli.localdomain> <1328226891-8968-4-git-send-email-sakari.ailus@iki.fi> <4F2D80C1.2050808@gmail.com>
In-Reply-To: <4F2D80C1.2050808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the comments!!

Sylwester Nawrocki wrote:
> On 02/03/2012 12:54 AM, Sakari Ailus wrote:
>> Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
>> IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
>> VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).
>>
>> VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.
>>
>> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
>> ---
>>   drivers/media/video/v4l2-subdev.c |   34 +++++++++++++++++++++---------
>>   include/linux/v4l2-subdev.h       |   41 +++++++++++++++++++++++++++++++++++++
>>   include/media/v4l2-subdev.h       |   21 +++++++++++++++---
>>   3 files changed, 82 insertions(+), 14 deletions(-)
>>
> ...
>> diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
>> index ed29cbb..192993a 100644
>> --- a/include/linux/v4l2-subdev.h
>> +++ b/include/linux/v4l2-subdev.h
>> @@ -123,6 +123,43 @@ struct v4l2_subdev_frame_interval_enum {
>>   	__u32 reserved[9];
>>   };
>>
>> +#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE			(1<<  0)
>> +#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE			(1<<  1)
>> +#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1<<  2)
>> +
>> +/* active cropping area */
>> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0
>> +/* cropping bounds */
>> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			2
> 
> You've dropped the DEFAULT targets but the target numbers stayed 
> unchanged. How about using hex numbers ? e.g.
> 
> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		0x0100
> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0101

Fine for me. Changed for the next revision.

I wanted to keep the target numbers the same since we're still using
exactly the same as the V4L2.

> ?
>> +/* current composing area */
>> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		256
>> +/* composing bounds */
>> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		258
>> +
>> +
>> +/**
>> + * struct v4l2_subdev_selection - selection info
>> + *
>> + * @which: either V4L2_SUBDEV_FORMAT_ACTIVE or V4L2_SUBDEV_FORMAT_TRY
>> + * @pad: pad number, as reported by the media API
>> + * @target: selection target, used to choose one of possible rectangles
>> + * @flags: constraints flags
> 
> s/constraints/constraint ?

Fixed.

>> + * @r: coordinates of selection window
> 
> s/selection/ the selection ?
> 
>> + * @reserved: for future use, rounds structure size to 64 bytes, set to zero
>> + *
>> + * Hardware may use multiple helper window to process a video stream.
> 
> s/window/windows ?

Same for these two.

>> + * The structure is used to exchange this selection areas between
>> + * an application and a driver.
>> + */
>> +struct v4l2_subdev_selection {
>> +	__u32 which;
>> +	__u32 pad;
>> +	__u32 target;
>> +	__u32 flags;
>> +	struct v4l2_rect r;
>> +	__u32 reserved[8];
>> +};
>> +

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
