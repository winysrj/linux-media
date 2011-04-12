Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:61644 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab1DLIJ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 04:09:58 -0400
Message-ID: <4DA40969.0@maxwell.research.nokia.com>
Date: Tue, 12 Apr 2011 11:12:25 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 4/9] v4l2-ctrls: add per-control events.
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>    <54721c1be23beb8c885ef56cdf7f782205c9dfdb.1301916466.git.hans.verkuil@cisco.com>    <4DA2ADE6.2080704@maxwell.research.nokia.com> <de36e47085bf38f0b4e95740ab43b85f.squirrel@webmail.xs4all.nl>
In-Reply-To: <de36e47085bf38f0b4e95740ab43b85f.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Hans Verkuil wrote:
[clip]
>>> diff --git a/drivers/media/video/v4l2-fh.c
>>> b/drivers/media/video/v4l2-fh.c
>>> index 8635011..c6aef84 100644
>>> --- a/drivers/media/video/v4l2-fh.c
>>> +++ b/drivers/media/video/v4l2-fh.c
>>> @@ -93,10 +93,8 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
>>>  {
>>>  	if (fh->vdev == NULL)
>>>  		return;
>>> -
>>> -	fh->vdev = NULL;
>>> -
>>>  	v4l2_event_free(fh);
>>> +	fh->vdev = NULL;
>>
>> This looks like a bugfix.
> 
> But it isn't :-)
> 
> v4l2_event_free didn't use fh->vdev in the past, but now it does so the
> order had to be swapped.

Ok.

>>
>>>  }
>>>  EXPORT_SYMBOL_GPL(v4l2_fh_exit);
>>>
>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>> index 92d2fdd..f7238c1 100644
>>> --- a/include/linux/videodev2.h
>>> +++ b/include/linux/videodev2.h
>>> @@ -1787,6 +1787,7 @@ struct v4l2_streamparm {
>>>  #define V4L2_EVENT_ALL				0
>>>  #define V4L2_EVENT_VSYNC			1
>>>  #define V4L2_EVENT_EOS				2
>>> +#define V4L2_EVENT_CTRL_CH_VALUE		3
>>>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>>>
>>>  /* Payload for V4L2_EVENT_VSYNC */
>>> @@ -1795,21 +1796,33 @@ struct v4l2_event_vsync {
>>>  	__u8 field;
>>>  } __attribute__ ((packed));
>>>
>>> +/* Payload for V4L2_EVENT_CTRL_CH_VALUE */
>>> +struct v4l2_event_ctrl_ch_value {
>>> +	__u32 type;
>>
>> type is enum v4l2_ctrl_type in struct v4l2_ctrl and struct v4l2_queryctrl.
> 
> Yes, but enum's are frowned upon these days in the public API.

Agreed.

>>
>>> +	union {
>>> +		__s32 value;
>>> +		__s64 value64;
>>> +	};
>>> +} __attribute__ ((packed));
>>> +
>>>  struct v4l2_event {
>>>  	__u32				type;
>>>  	union {
>>>  		struct v4l2_event_vsync vsync;
>>> +		struct v4l2_event_ctrl_ch_value ctrl_ch_value;
>>>  		__u8			data[64];
>>>  	} u;
>>>  	__u32				pending;
>>>  	__u32				sequence;
>>>  	struct timespec			timestamp;
>>> -	__u32				reserved[9];
>>> +	__u32				id;
>>
>> id is valid only for control related events. Shouldn't it be part of the
>> control related structures instead, or another union for control related
>> event types? E.g.
>>
>> struct {
>> 	enum v4l2_ctrl_type	id;
>> 	union {
>> 		struct v4l2_event_ctrl_ch_value ch_value;
>> 	};
>> } ctrl;
> 
> The problem with making this dependent of the type is that the core event
> code would have to have a switch on the event type when it comes to
> matching identifiers. By making it a core field it doesn't have to do
> this. Also, this makes it available for use by private events as well.
> 
> It is important to keep the send-event core code as fast as possible since
> it can be called from interrupt context.
> 
> So this is by design.

I understand your point, and agree with it. There would be a few places
in the v4l2-event.c that one would have to know if the event is
control-related or not.

As the id field is handled in the v4l2-event.c the way it is, it must be
zero when the event is not a control-related one. This makes it
impossible to use it for other purposes, at least for now.

What about renaming the field to ctrl_id? Or do you think we could have
other use for the field outside the scope of the control-related events?

The benefit of the current name is still that it does not suggest
anything on the implementation.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
