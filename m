Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3362 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbaD3Odz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 10:33:55 -0400
Message-ID: <536109BA.7010307@xs4all.nl>
Date: Wed, 30 Apr 2014 14:33:30 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: k.debski@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org
Subject: Re: [PATCH v2 1/2] v4l: Add resolution change event.
References: <1398072362-24962-1-git-send-email-arun.kk@samsung.com> <1398072362-24962-2-git-send-email-arun.kk@samsung.com> <53566601.2080801@xs4all.nl> <5360EEC5.5050903@gmail.com>
In-Reply-To: <5360EEC5.5050903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2014 12:38 PM, Arun Kumar K wrote:
> Hi Hans,
> 
> 
> On 04/22/14 18:22, Hans Verkuil wrote:
>> On 04/21/2014 11:26 AM, Arun Kumar K wrote:
>>> From: Pawel Osciak <posciak@chromium.org>
>>>
>>> This event indicates that the decoder has reached a point in the stream,
>>> at which the resolution changes. The userspace is expected to provide a new
>>> set of CAPTURE buffers for the new format before decoding can continue.
>>> The event can also be used for more generic events involving resolution
>>> or format changes at runtime for all kinds of video devices.
>>>
>>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>>> ---
>>>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   16 ++++++++++++++++
>>>  include/uapi/linux/videodev2.h                     |    6 ++++++
>>>  2 files changed, 22 insertions(+)
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>> index 5c70b61..0aec831 100644
>>> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>> @@ -155,6 +155,22 @@
>>>  	    </entry>
>>>  	  </row>
>>>  	  <row>
>>> +	    <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
>>> +	    <entry>5</entry>
>>> +	    <entry>
>>> +	      <para>This event is triggered when a resolution or format change
>>> +	       is detected during runtime by the video device. It can be a
>>> +	       runtime resolution change triggered by a video decoder or the
>>> +	       format change happening on an HDMI connector. Application may
>>> +	       need to reinitialize buffers before proceeding further.</para>
>>> +
>>> +              <para>This event has a &v4l2-event-source-change; associated
>>> +	      with it. This has significance only for v4l2 subdevs where the
>>> +	      <structfield>pad_num</structfield> field will be updated with
>>> +	      the pad number on which the event is triggered.</para>
>>> +	    </entry>
>>> +	  </row>
>>> +	  <row>
>>>  	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>>>  	    <entry>0x08000000</entry>
>>>  	    <entry>Base event number for driver-private events.</entry>
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 6ae7bbe..12e0614 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
>>>  #define V4L2_EVENT_EOS				2
>>>  #define V4L2_EVENT_CTRL				3
>>>  #define V4L2_EVENT_FRAME_SYNC			4
>>> +#define V4L2_EVENT_SOURCE_CHANGE		5
>>>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>>>  
>>>  /* Payload for V4L2_EVENT_VSYNC */
>>> @@ -1764,12 +1765,17 @@ struct v4l2_event_frame_sync {
>>>  	__u32 frame_sequence;
>>>  };
>>>  
>>> +struct v4l2_event_source_change {
>>> +	__u32 pad_num;
>>> +};
>>> +
>>>  struct v4l2_event {
>>>  	__u32				type;
>>>  	union {
>>>  		struct v4l2_event_vsync		vsync;
>>>  		struct v4l2_event_ctrl		ctrl;
>>>  		struct v4l2_event_frame_sync	frame_sync;
>>> +		struct v4l2_event_source_change source_change;
>>>  		__u8				data[64];
>>>  	} u;
>>>  	__u32				pending;
>>>
>>
>> This needs to be done differently. The problem is that you really have multiple
>> events that you want to subscribe to: one for each pad (or input: see the way
>> VIDIOC_G/S_EDID maps pad to an input or output index when used with a video node,
>> we have to support that for this event as well).
>>
>> What you want to do is similar to what is done for control events: there you can
>> subscribe for a specific control and get notified when that control changes.
>>
>> The way that works in the event code is that the 'id' field in the v4l2_event
>> struct contains that control ID, or, in this case, the pad/input/output index.
>>
> 
> As I am new to v4l2-events itself, I might have some noob questions.
> I understood filling pad index into id field. But for video nodes,
> the application is supposed to put v4l2_buf_type in the id field?

No, a capture video node can have multiple inputs (those are enumerated with
VIDIOC_ENUMINPUTS), and each input can generate a SOURCE_CHANGE event, even if it
is not the currently active input. Hence the need of setting id to the input
index. v4l2_buf_type makes no sense here.

> 
>> In the application you will subscribe to the SOURCE_CHANGE event for a specific
>> pad/input/output index.
>>
>> In other words, the pad_num field should be dropped and the id field used
>> instead.
>>
>> Assuming we will also add a 'changes' field (see my reply to the other post
>> on that topic), then you should also provide replace and merge ops (see
>> v4l2-ctrls.c). That way it is sufficient to use just one element when calling
>> v4l2_event_subscribe(): you will never loose information since if multiple
>> events arrive before the application can dequeue them, the 'changes' information
>> will be the ORed value of all those intermediate events.
>>
> 
> If I understand correctly, the implementation should go somewhat in the
> following lines:
> 
> +void v4l2_event_src_replace(struct v4l2_event *old, const struct
> v4l2_event *new)
> +{
> +       u32 old_changes = old->u.src_change.changes;
> +
> +       old->u.src_change = new->u.src_change;
> +       old->u.src_change.changes |= old_changes;
> +}
> +
> +void v4l2_event_src_merge(const struct v4l2_event *old, struct
> v4l2_event *new)
> +{
> +       new->u.src_change.changes |= old->u.src_change.changes;
> +}
> +
> +const struct v4l2_subscribed_event_ops v4l2_event_src_ch_ops = {
> +       .replace = v4l2_event_src_replace,
> +       .merge = v4l2_event_src_merge,
> +};
> +
> +int v4l2_src_change_event_subscribe(struct v4l2_fh *fh,
> +                               const struct v4l2_event_subscription *sub)
> +{
> +       if (sub->type == V4L2_EVENT_SOURCE_CHANGE)
> +               return v4l2_event_subscribe(fh, sub, 0,
> &v4l2_event_src_ch_ops);
> +       return -EINVAL;
> +}
> 
> And v4l2-event.c is the right place to put it?

Correct. Note that the replace and merge functions and v4l2_event_src_ch_ops can
all be static, only v4l2_src_change_event_subscribe should be exported.

> 
> 
> And in the videodev2.h file:
> 
> +#define V4L2_EVENT_SRC_CH_RESOLUTION           (1 << 0)
> +#define V4L2_EVENT_SRC_CH_FORMAT               (1 << 1)
> +
> +struct v4l2_event_src_change {
> +       __u32 changes;
> +};
> +
>  struct v4l2_event {
>         __u32                           type;
>         union {
>                 struct v4l2_event_vsync         vsync;
>                 struct v4l2_event_ctrl          ctrl;
>                 struct v4l2_event_frame_sync    frame_sync;
> +               struct v4l2_event_src_change    src_change;
>                 __u8                            data[64];
>         } u;
>         __u32                           pending;
> 
> Please correct me if my understanding is totally wrong here?

No, this is correct.

I do think that CH_FORMAT is too vague. 'format' is such a general concept and
I would prefer something that is more specific as to what has changed. Do you
actually need that at the moment?

Regards,

	Hans

> 
> Regards
> Arun
> 
>> It's all more work, but it is critical to ensure that the application never
>> misses events.
>>
>> Regards,
>>
>> 	Hans
>>

