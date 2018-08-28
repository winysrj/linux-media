Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59512 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727177AbeH1OUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 10:20:22 -0400
Subject: Re: [PATCH] media: v4l2-subdev.h: allow V4L2_FRMIVAL_TYPE_CONTINUOUS
 & _STEPWISE
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-media@vger.kernel.org
References: <1535442907-8659-1-git-send-email-phdm@macqel.be>
 <7bfc83d5-92dd-a604-35a6-4dc659feb7b5@xs4all.nl>
 <20180828102610.GA31307@frolo.macqel>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e5379767-5bf4-e0bb-e952-1e7afd39e1a9@xs4all.nl>
Date: Tue, 28 Aug 2018 12:29:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180828102610.GA31307@frolo.macqel>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/08/18 12:26, Philippe De Muyter wrote:
> Hi Hans,
> 
> On Tue, Aug 28, 2018 at 12:03:25PM +0200, Hans Verkuil wrote:
>> Hi Philippe,
>>
>> On 28/08/18 09:55, Philippe De Muyter wrote:
>>> add max_interval and step_interval to struct
>>> v4l2_subdev_frame_interval_enum.
>>
>> Yeah, I never understood why this wasn't supported when this API was designed.
>> Clearly an oversight.
>>
>>>
>>> When filled correctly by the sensor driver, those fields must be
>>> used as follows by the intermediate level :
>>>
>>>         struct v4l2_frmivalenum *fival;
>>>         struct v4l2_subdev_frame_interval_enum fie;
>>>
>>>         if (fie.max_interval.numerator == 0) {
>>>                 fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>>>                 fival->discrete = fie.interval;
>>>         } else if (fie.step_interval.numerator == 0) {
>>>                 fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>>>                 fival->stepwise.min = fie.interval;
>>>                 fival->stepwise.max = fie.max_interval;
>>>         } else {
>>>                 fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
>>>                 fival->stepwise.min = fie.interval;
>>>                 fival->stepwise.max = fie.max_interval;
>>>                 fival->stepwise.step = fie.step_interval;
>>>         }
>>
>> This is a bit too magical for my tastes. I'd add a type field:
>>
>> #define V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE 0
>> #define V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS 1
>> #define V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE 2
> 
> Like that ?
> 
> 	struct v4l2_subdev_frame_interval_enum {
> 		__u32 index;
> 		__u32 pad;
> 		__u32 code;
> 		__u32 width;
> 		__u32 height;
> 		struct v4l2_fract interval;
> 		__u32 which;
> 		__u32 type;
> 		struct v4l2_fract max_interval;
> 		struct v4l2_fract step_interval;
> 		__u32 reserved[3];
> 	};

Yes.

> 
> 
>>
>> Older applications that do not know about the type field will just
>> see a single discrete interval containing the minimum interval.
>> I guess that's OK as they will keep working.
> 
> That's actually what also happens with the above implementation, because
> max_interval.numerator and step_interval.numerator were previously
> reserved and thus 0, and if this code is moved to a helper function,
> that does not matter if it's a little bit magical :).

It's not just the kernel, but userspace can also enumerate directly from
a v4l-subdevX device node, and they can't use any kernel helper functions.

Let's keep this API clean.

> Both implementations are equal to me, but the proposed one uses less
> space from the 'reserved' field.

That's OK.

Regards,

	Hans


> 
>>
>> While at it: it would be really nice if you can also add stepwise
>> support to VIDIOC_SUBDEV_ENUM_FRAME_SIZE. I think the only thing
>> you need to do there is to add two new fields: step_width and step_height.
>> If 0, then that just means a step size of 1.
> 
> I'll look at that if I find enough interest and test opportunity for it,
> but those things are unrelated except that they are missing :)
> 
>>
>> Add some helper functions to translate between v4l2_subdev_frame_size/interval_enum
>> and v4l2_frmsize/ivalenum and this becomes much cleaner.
> 
> OK
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>>> ---
>>>  .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst | 39 +++++++++++++++++++++-
>>>  include/uapi/linux/v4l2-subdev.h                   |  4 ++-
>>>  2 files changed, 41 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
>>> index 1bfe386..acc516e 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
>>> @@ -51,6 +51,37 @@ EINVAL error code if one of the input fields is invalid. All frame
>>>  intervals are enumerable by beginning at index zero and incrementing by
>>>  one until ``EINVAL`` is returned.
>>>  
>>> +If the sub-device can work only at the fixed set of frame intervals,
>>> +driver must enumerate them with increasing indexes, by only filling
>>> +the ``interval`` field.  If the sub-device can work with a continuous
>>> +range of frame intervals, driver must only return success for index 0
>>> +and fill ``interval`` with the minimum interval, ``max_interval`` with
>>> +the maximum interval, and ``step_interval`` with 0 or the step between
>>> +the possible intervals.
>>> +
>>> +Callers are expected to use the returned information as follows :
>>> +
>>> +.. code-block:: c
>>> +
>>> +        struct v4l2_frmivalenum * fival;
>>> +        struct v4l2_subdev_frame_interval_enum fie;
>>> +
>>> +        if (fie.max_interval.numerator == 0) {
>>> +                fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>>> +                fival->discrete = fie.interval;
>>> +        } else if (fie.step_interval.numerator == 0) {
>>> +                fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>>> +                fival->stepwise.min = fie.interval;
>>> +                fival->stepwise.max = fie.max_interval;
>>> +        } else {
>>> +                fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
>>> +                fival->stepwise.min = fie.interval;
>>> +                fival->stepwise.max = fie.max_interval;
>>> +                fival->stepwise.step = fie.step_interval;
>>> +        }
>>> +
>>> +.. code-block:: c
>>> +
>>>  Available frame intervals may depend on the current 'try' formats at
>>>  other pads of the sub-device, as well as on the current active links.
>>>  See :ref:`VIDIOC_SUBDEV_G_FMT` for more
>>> @@ -92,8 +123,14 @@ multiple pads of the same sub-device is not defined.
>>>        - ``which``
>>>        - Frame intervals to be enumerated, from enum
>>>  	:ref:`v4l2_subdev_format_whence <v4l2-subdev-format-whence>`.
>>> +    * - struct :c:type:`v4l2_fract`
>>> +      - ``max_interval``
>>> +      - Maximum period, in seconds, between consecutive video frames, or 0.
>>> +    * - struct :c:type:`v4l2_fract`
>>> +      - ``step_interval``
>>> +      - Frame interval step size, in seconds, or 0.
>>>      * - __u32
>>> -      - ``reserved``\ [8]
>>> +      - ``reserved``\ [4]
>>>        - Reserved for future extensions. Applications and drivers must set
>>>  	the array to zero.
>>>  
>>> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
>>> index 03970ce..c944644 100644
>>> --- a/include/uapi/linux/v4l2-subdev.h
>>> +++ b/include/uapi/linux/v4l2-subdev.h
>>> @@ -128,7 +128,9 @@ struct v4l2_subdev_frame_interval_enum {
>>>  	__u32 height;
>>>  	struct v4l2_fract interval;
>>>  	__u32 which;
>>> -	__u32 reserved[8];
>>> +	struct v4l2_fract max_interval;
>>> +	struct v4l2_fract step_interval;
>>> +	__u32 reserved[4];
>>>  };
>>>  
>>>  /**
>>>
> 
