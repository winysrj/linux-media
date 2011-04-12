Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1088 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1DLNkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 09:40:36 -0400
Message-ID: <e1954115c204bd35299c0ab117442af8.squirrel@webmail.xs4all.nl>
In-Reply-To: <4DA40969.0@maxwell.research.nokia.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
    <54721c1be23beb8c885ef56cdf7f782205c9dfdb.1301916466.git.hans.verkuil@cisco.com>
    <4DA2ADE6.2080704@maxwell.research.nokia.com>
    <de36e47085bf38f0b4e95740ab43b85f.squirrel@webmail.xs4all.nl>
    <4DA40969.0@maxwell.research.nokia.com>
Date: Tue, 12 Apr 2011 15:40:27 +0200
Subject: Re: [RFCv1 PATCH 4/9] v4l2-ctrls: add per-control events.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Cc: "Hans Verkuil" <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans,
>
> Hans Verkuil wrote:
>>>
>>>> +	union {
>>>> +		__s32 value;
>>>> +		__s64 value64;
>>>> +	};
>>>> +} __attribute__ ((packed));
>>>> +
>>>>  struct v4l2_event {
>>>>  	__u32				type;
>>>>  	union {
>>>>  		struct v4l2_event_vsync vsync;
>>>> +		struct v4l2_event_ctrl_ch_value ctrl_ch_value;
>>>>  		__u8			data[64];
>>>>  	} u;
>>>>  	__u32				pending;
>>>>  	__u32				sequence;
>>>>  	struct timespec			timestamp;
>>>> -	__u32				reserved[9];
>>>> +	__u32				id;
>>>
>>> id is valid only for control related events. Shouldn't it be part of
>>> the
>>> control related structures instead, or another union for control
>>> related
>>> event types? E.g.
>>>
>>> struct {
>>> 	enum v4l2_ctrl_type	id;
>>> 	union {
>>> 		struct v4l2_event_ctrl_ch_value ch_value;
>>> 	};
>>> } ctrl;
>>
>> The problem with making this dependent of the type is that the core
>> event
>> code would have to have a switch on the event type when it comes to
>> matching identifiers. By making it a core field it doesn't have to do
>> this. Also, this makes it available for use by private events as well.
>>
>> It is important to keep the send-event core code as fast as possible
>> since
>> it can be called from interrupt context.
>>
>> So this is by design.
>
> I understand your point, and agree with it. There would be a few places
> in the v4l2-event.c that one would have to know if the event is
> control-related or not.
>
> As the id field is handled in the v4l2-event.c the way it is, it must be
> zero when the event is not a control-related one. This makes it
> impossible to use it for other purposes, at least for now.
>
> What about renaming the field to ctrl_id? Or do you think we could have
> other use for the field outside the scope of the control-related events?

I believe so, yes. For example per-input or per-output events (where id
refers to the input/output index) or per-pad events (where id refers to
the pad id). In general, the id field can be used as an object identifier.

If there are no 'objects' related to the event, then it has to be 0 as you
said.

Regards,

       Hans

>
> The benefit of the current name is still that it does not suggest
> anything on the implementation.
>
> Cheers,
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


