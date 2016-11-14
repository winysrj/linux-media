Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:57656 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932343AbcKNTTN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 14:19:13 -0500
Subject: Re: [PATCH v4 7/8] v4l: Add signal lock status to source change
 events
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>, <lars@metafoo.de>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <1470247430-11168-8-git-send-email-steve_longerbeam@mentor.com>
 <8ff2fc76-2290-d353-08cd-2aa31c31a19c@xs4all.nl>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <de4a622c-0d2b-0233-3f82-958a16319656@mentor.com>
Date: Mon, 14 Nov 2016 11:19:08 -0800
MIME-Version: 1.0
In-Reply-To: <8ff2fc76-2290-d353-08cd-2aa31c31a19c@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/14/2016 03:36 AM, Hans Verkuil wrote:
> On 08/03/2016 08:03 PM, Steve Longerbeam wrote:
>> Add a signal lock status change to the source changes bitmask.
>> This indicates there was a signal lock or unlock event detected
>> at the input of a video decoder.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> ---
>>
>> v4:
>> - converted to rst from DocBook
>>
>> v3: no changes
>> v2: no changes
>> ---
>>   Documentation/media/uapi/v4l/vidioc-dqevent.rst | 9 +++++++++
>>   Documentation/media/videodev2.h.rst.exceptions  | 1 +
>>   include/uapi/linux/videodev2.h                  | 1 +
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>> index 73c0d5b..7d8a053 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>> @@ -564,6 +564,15 @@ call.
>>   	  an input. This can come from an input connector or from a video
>>   	  decoder.
>>   
>> +    -  .. row 2
>> +
>> +       -  ``V4L2_EVENT_SRC_CH_LOCK_STATUS``
>> +
>> +       -  0x0002
>> +
>> +       -  This event gets triggered when there is a signal lock or
>> +	  unlock detected at the input of a video decoder.
>> +
>>   
>>   Return Value
>>   ============
>> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
>> index 9bb9a6c..f412cc8 100644
>> --- a/Documentation/media/videodev2.h.rst.exceptions
>> +++ b/Documentation/media/videodev2.h.rst.exceptions
>> @@ -453,6 +453,7 @@ replace define V4L2_EVENT_CTRL_CH_FLAGS ctrl-changes-flags
>>   replace define V4L2_EVENT_CTRL_CH_RANGE ctrl-changes-flags
>>   
>>   replace define V4L2_EVENT_SRC_CH_RESOLUTION src-changes-flags
>> +replace define V4L2_EVENT_SRC_CH_LOCK_STATUS src-changes-flags
>>   
>>   replace define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ v4l2-event-motion-det
>>   
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 724f43e..08a153f 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -2078,6 +2078,7 @@ struct v4l2_event_frame_sync {
>>   };
>>   
>>   #define V4L2_EVENT_SRC_CH_RESOLUTION		(1 << 0)
>> +#define V4L2_EVENT_SRC_CH_LOCK_STATUS		(1 << 1)
>>   
>>   struct v4l2_event_src_change {
>>   	__u32 changes;
>>
> Quoting from an old (July) conversation about this:
>
>>>> I'm not entirely sure I like this. Typically losing lock means that this event
>>>> is triggered with the V4L2_EVENT_SRC_CH_RESOLUTION flag set, and userspace has
>>>> to check the new timings etc., which will fail if there is no lock anymore.
>>>>
>>>> This information is also available through ENUMINPUT.
>>>>
>>>> I would need to know more about why you think this is needed, because I don't
>>>> see what this adds.
>> Hi Hans,
>>
>> At least on the ADV718x, a source resolution change (from an
>> autodetected video
>> standard change) and a signal lock status change are distinct events.
>> For example
>> there can be a temporary loss of input signal lock without a change in
>> detected
>> input video standard/resolution.
> OK, but what can the application do with that event? If the glitch didn't
> affect the video, then it is pointless.

Hi Hans, that's just it, for i.mx6 it does affect video. On i.mx6 a 
temporary
loss of signal from the adv7180 often results in a "split image", or rolling
image from captured frame to the next, and the only way to recover
from this failure is to restart the pipeline (stream off -- stream on). So
the application needs to be informed of this temporary loss of signal
event in order to restart streaming.


>
> If the lock is lost, then normally you loose video as well. If not, then
> applications are not interested in the event.

Yes, the lost lock causes a temporary or permanent loss of video,
but with no other indications from the adv7180 (such as a detected
video standard change). And on i.mx6, the lost lock often (actually
usually) causes a split or rolling image.

Steve

