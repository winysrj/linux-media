Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:53394 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbaEEJuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 May 2014 05:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <536109BA.7010307@xs4all.nl>
References: <1398072362-24962-1-git-send-email-arun.kk@samsung.com>
	<1398072362-24962-2-git-send-email-arun.kk@samsung.com>
	<53566601.2080801@xs4all.nl>
	<5360EEC5.5050903@gmail.com>
	<536109BA.7010307@xs4all.nl>
Date: Mon, 5 May 2014 15:20:02 +0530
Message-ID: <CALt3h78R47nns9RQXDq6QsNmgti_L+PVNB8EHWSrcEHvBgN0LQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] v4l: Add resolution change event.
From: Arun Kumar K <arun.kk@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <posciak@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Apr 30, 2014 at 8:03 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 04/30/2014 12:38 PM, Arun Kumar K wrote:
>> Hi Hans,
>>
>>
>> On 04/22/14 18:22, Hans Verkuil wrote:
>>> On 04/21/2014 11:26 AM, Arun Kumar K wrote:
>>>> From: Pawel Osciak <posciak@chromium.org>
>>>>
>>>> This event indicates that the decoder has reached a point in the stream,
>>>> at which the resolution changes. The userspace is expected to provide a new
>>>> set of CAPTURE buffers for the new format before decoding can continue.
>>>> The event can also be used for more generic events involving resolution
>>>> or format changes at runtime for all kinds of video devices.
>>>>
>>>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>>>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>>>> ---
>>>>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   16 ++++++++++++++++
>>>>  include/uapi/linux/videodev2.h                     |    6 ++++++
>>>>  2 files changed, 22 insertions(+)
>>>>
>>>> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>>> index 5c70b61..0aec831 100644
>>>> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>>> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
>>>> @@ -155,6 +155,22 @@
>>>>         </entry>
>>>>       </row>
>>>>       <row>
>>>> +       <entry><constant>V4L2_EVENT_SOURCE_CHANGE</constant></entry>
>>>> +       <entry>5</entry>
>>>> +       <entry>
>>>> +         <para>This event is triggered when a resolution or format change
>>>> +          is detected during runtime by the video device. It can be a
>>>> +          runtime resolution change triggered by a video decoder or the
>>>> +          format change happening on an HDMI connector. Application may
>>>> +          need to reinitialize buffers before proceeding further.</para>
>>>> +
>>>> +              <para>This event has a &v4l2-event-source-change; associated
>>>> +         with it. This has significance only for v4l2 subdevs where the
>>>> +         <structfield>pad_num</structfield> field will be updated with
>>>> +         the pad number on which the event is triggered.</para>
>>>> +       </entry>
>>>> +     </row>
>>>> +     <row>
>>>>         <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>>>>         <entry>0x08000000</entry>
>>>>         <entry>Base event number for driver-private events.</entry>
>>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>>> index 6ae7bbe..12e0614 100644
>>>> --- a/include/uapi/linux/videodev2.h
>>>> +++ b/include/uapi/linux/videodev2.h
>>>> @@ -1733,6 +1733,7 @@ struct v4l2_streamparm {
>>>>  #define V4L2_EVENT_EOS                             2
>>>>  #define V4L2_EVENT_CTRL                            3
>>>>  #define V4L2_EVENT_FRAME_SYNC                      4
>>>> +#define V4L2_EVENT_SOURCE_CHANGE           5
>>>>  #define V4L2_EVENT_PRIVATE_START           0x08000000
>>>>
>>>>  /* Payload for V4L2_EVENT_VSYNC */
>>>> @@ -1764,12 +1765,17 @@ struct v4l2_event_frame_sync {
>>>>     __u32 frame_sequence;
>>>>  };
>>>>
>>>> +struct v4l2_event_source_change {
>>>> +   __u32 pad_num;
>>>> +};
>>>> +
>>>>  struct v4l2_event {
>>>>     __u32                           type;
>>>>     union {
>>>>             struct v4l2_event_vsync         vsync;
>>>>             struct v4l2_event_ctrl          ctrl;
>>>>             struct v4l2_event_frame_sync    frame_sync;
>>>> +           struct v4l2_event_source_change source_change;
>>>>             __u8                            data[64];
>>>>     } u;
>>>>     __u32                           pending;
>>>>
>>>
>>> This needs to be done differently. The problem is that you really have multiple
>>> events that you want to subscribe to: one for each pad (or input: see the way
>>> VIDIOC_G/S_EDID maps pad to an input or output index when used with a video node,
>>> we have to support that for this event as well).
>>>
>>> What you want to do is similar to what is done for control events: there you can
>>> subscribe for a specific control and get notified when that control changes.
>>>
>>> The way that works in the event code is that the 'id' field in the v4l2_event
>>> struct contains that control ID, or, in this case, the pad/input/output index.
>>>
>>
>> As I am new to v4l2-events itself, I might have some noob questions.
>> I understood filling pad index into id field. But for video nodes,
>> the application is supposed to put v4l2_buf_type in the id field?
>
> No, a capture video node can have multiple inputs (those are enumerated with
> VIDIOC_ENUMINPUTS), and each input can generate a SOURCE_CHANGE event, even if it
> is not the currently active input. Hence the need of setting id to the input
> index. v4l2_buf_type makes no sense here.
>

Ok. But in a simple m2m device like mfc, the userspace has to subscribe to
the event say on the CAPTURE plane where buffers has to be re-allocated on
resolution change. So in such a case, what should be put in id field?

>>
>>> In the application you will subscribe to the SOURCE_CHANGE event for a specific
>>> pad/input/output index.
>>>
>>> In other words, the pad_num field should be dropped and the id field used
>>> instead.
>>>
>>> Assuming we will also add a 'changes' field (see my reply to the other post
>>> on that topic), then you should also provide replace and merge ops (see
>>> v4l2-ctrls.c). That way it is sufficient to use just one element when calling
>>> v4l2_event_subscribe(): you will never loose information since if multiple
>>> events arrive before the application can dequeue them, the 'changes' information
>>> will be the ORed value of all those intermediate events.
>>>
>>
>> If I understand correctly, the implementation should go somewhat in the
>> following lines:
>>
>> +void v4l2_event_src_replace(struct v4l2_event *old, const struct
>> v4l2_event *new)
>> +{
>> +       u32 old_changes = old->u.src_change.changes;
>> +
>> +       old->u.src_change = new->u.src_change;
>> +       old->u.src_change.changes |= old_changes;
>> +}
>> +
>> +void v4l2_event_src_merge(const struct v4l2_event *old, struct
>> v4l2_event *new)
>> +{
>> +       new->u.src_change.changes |= old->u.src_change.changes;
>> +}
>> +
>> +const struct v4l2_subscribed_event_ops v4l2_event_src_ch_ops = {
>> +       .replace = v4l2_event_src_replace,
>> +       .merge = v4l2_event_src_merge,
>> +};
>> +
>> +int v4l2_src_change_event_subscribe(struct v4l2_fh *fh,
>> +                               const struct v4l2_event_subscription *sub)
>> +{
>> +       if (sub->type == V4L2_EVENT_SOURCE_CHANGE)
>> +               return v4l2_event_subscribe(fh, sub, 0,
>> &v4l2_event_src_ch_ops);
>> +       return -EINVAL;
>> +}
>>
>> And v4l2-event.c is the right place to put it?
>
> Correct. Note that the replace and merge functions and v4l2_event_src_ch_ops can
> all be static, only v4l2_src_change_event_subscribe should be exported.
>

Ok will do that.

>>
>>
>> And in the videodev2.h file:
>>
>> +#define V4L2_EVENT_SRC_CH_RESOLUTION           (1 << 0)
>> +#define V4L2_EVENT_SRC_CH_FORMAT               (1 << 1)
>> +
>> +struct v4l2_event_src_change {
>> +       __u32 changes;
>> +};
>> +
>>  struct v4l2_event {
>>         __u32                           type;
>>         union {
>>                 struct v4l2_event_vsync         vsync;
>>                 struct v4l2_event_ctrl          ctrl;
>>                 struct v4l2_event_frame_sync    frame_sync;
>> +               struct v4l2_event_src_change    src_change;
>>                 __u8                            data[64];
>>         } u;
>>         __u32                           pending;
>>
>> Please correct me if my understanding is totally wrong here?
>
> No, this is correct.
>
> I do think that CH_FORMAT is too vague. 'format' is such a general concept and
> I would prefer something that is more specific as to what has changed. Do you
> actually need that at the moment?
>

No I dont need it. I will keep only the CH_RESOLUTION for now.

Regards
Arun
