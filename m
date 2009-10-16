Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2556 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbZJPI1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 04:27:52 -0400
Message-ID: <7c87abde6f2f45f29d56c6b112de169d.squirrel@webmail.xs4all.nl>
In-Reply-To: <4AD82293.5040504@maxwell.research.nokia.com>
References: <4AD5CBD6.4030800@maxwell.research.nokia.com>
    <200910141948.33666.hverkuil@xs4all.nl>
    <200910152311.33709.laurent.pinchart@ideasonboard.com>
    <200910152337.06794.hverkuil@xs4all.nl>
    <4AD82293.5040504@maxwell.research.nokia.com>
Date: Fri, 16 Oct 2009 10:27:07 +0200
Subject: Re: [RFC] Video events, version 2
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zutshi Vimarsh" <vimarsh.zutshi@nokia.com>,
	"Ivan Ivanov" <iivanov@mm-sol.com>,
	"Cohen David Abraham" <david.cohen@nokia.com>,
	"Guru Raj" <gururaj.nagendra@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans Verkuil wrote:
>> On Thursday 15 October 2009 23:11:33 Laurent Pinchart wrote:
>>> Hi Sakari,
>>>
>>> On Wednesday 14 October 2009 19:48:33 Hans Verkuil wrote:
>>>> On Wednesday 14 October 2009 15:02:14 Sakari Ailus wrote:
>>>>> Here's the second version of the video events RFC. It's based on
>>>>> Laurent
>>>>> Pinchart's original RFC. My aim is to address the issues found in the
>>>>> old RFC during the V4L-DVB mini-summit in the Linux plumbers
>>>>> conference
>>>>> 2009. To get a good grasp of the problem at hand it's probably a good
>>>>> idea read the original RFC as well:
>>>>>
>>>>> <URL:http://www.spinics.net/lists/linux-media/msg10217.html>
>>> Thanks for the RFC update.
>
> You're welcome.
>
>>>>> Changes to version 1
>>>>> ----------------------------------
>>>>>
>>>>> struct video_event has been renamed to v4l2_event. The struct is used
>>>>> in
>>>>> userspace and V4L related structures appear to have v4l2 prefix so
>>>>> that
>>>>> should be better than video.
>>> In the end we will probably rename that to media_ or something similar
>>> in the
>>> big media controller rename (if that ever happens). For now let's keep
>>> v4l2_,
>>> that will be more consistent.
>>>
>>>>> The "entity" field has been removed from the struct v4l2_event since
>>>>> the
>>>>> subdevices will have their own device nodes --- the events should
>>>>> come
>>>>> from them instead of the media controller. Video nodes could be used
>>>>> for
>>>>> events, too.
>>> I would still keep the entity field. It would allow for parents to
>>> report
>>> children events and there could be use cases for that.
>>
>> We can always convert one of the reserved fields to an entity field in
>> the
>> future. Adding support in the new API for an even newer and as yet
>> highly
>> experimental API is not a good idea.
>
> Then the entity field stays away for now?

Yup.

>>>>> A few reserved fields have been added. There are new ioctls as well
>>>>> for
>>>>> enumeration and (un)subscribing.
>>>>>
>>>>>
>>>>> Interface description
>>>>> ---------------------
>>>>>
>>>>> Event type is either a standard event or private event. Standard
>>>>> events
>>>>> will be defined in videodev2.h. Private event types begin from
>>>>> V4L2_EVENT_PRIVATE. Some high order bits could be reserved for future
>>>>> use.
>>>>>
>>>>> #define V4L2_EVENT_PRIVATE_START	0x08000000
>>>>> #define V4L2_EVENT_RESERVED		0x10000000
>>>> Suggestion: use the V4L2_EV_ prefix perhaps instead of the longer
>>>>  V4L2_EVENT?
>>> EV could be confused with electron volt, exposure value, or even escape
>>> velocity (don't underestimate the use of V4L2 in the spaceship market
>>> ;-)). On
>>> a more serious note, while I like to keep identifiers short, is the 3
>>> characters gain worth it here ?
>
> I'll use V4L2_EVENT_ in the next RFC, too.
>
>>>>> VIDIOC_ENUM_EVENT is used to enumerate the available event types. It
>>>>> works a bit the same way than VIDIOC_ENUM_FMT i.e. you get the next
>>>>> event type by calling it with the last type in the type field. The
>>>>> difference is that the range is not continuous like in querying
>>>>> controls.
>>>> Question: why do we need an ENUM_EVENT? I don't really see a use-case
>>>> for
>>>>  this.
>>>>
>>>> Also note that there are three methods in use for enumerating within
>>>> V4L:
>>>>
>>>> 1) there is an index field in the struct that starts at 0 and that the
>>>> application increases by 1 until the ioctl returns an error.
>>>>
>>>> 2) old-style controls where just enumerated from CID_BASE to
>>>> CID_LASTP1,
>>>> which is very, very ugly.
>>>>
>>>> 3) controls new-style allow one to set bit 31 on the control ID and in
>>>> that
>>>> case the ioctl will give you the first control with an ID that is
>>>> higher
>>>>  than the specified ID.
>>>>
>>>> 1 or 3 are both valid options IMHO.
>>>>
>>>> But again, I don't see why we need it in the first place.
>>> Applications will only subscribe to the events they can handle, so I
>>> don't
>>> think enumeration is really required. We might want to provide
>>> "subscribe to
>>> all" and "subscribe to none" options though, maybe as special events
>>> (V4L2_EVENT_NONE, V4L2_EVENT_ALL)
>>
>> Nice idea. Although we only need an EVENT_ALL. 'Subscribe to none'
>> equals
>> 'unsubscribe all' after all :-)
>
> Ok.
>
>>>>> VIDIOC_G_EVENT is used to get events. sequence is the event sequence
>>>>> number and the data is specific to driver or event type.
>>> For efficiency reasons a V4L2_G_EVENTS ioctl could also be provided to
>>> retrieve multiple events.
>>>
>>> struct v4l2_events {
>>> 	__u32 count;
>>> 	struct v4l2_event __user *events;
>>> };
>>>
>>> #define VIDIOC_G_EVENTS _IOW('V', xx, struct v4l2_events)
>>
>> Hmm. Premature optimization. Perhaps as a future extension.
>
> That *could* save one ioctl sometimes --- then you'd no there are no
> more events coming right now. But just one should be supported IMO,
> VIDIOC_G_EVENT or VIDIOC_G_EVENTS.

I'm not keen on using pointers insides structures unless there is a very
good reason to do so. In practice it complicates the driver code
substantially due to all the kernel-to-userspace copies that need to be
done that are normally handled by video_ioctl2. In addition it requires
custom code in the compat-ioctl32 part as well.

>>>>> The user will get the information that there's an event through
>>>>> exception file descriptors by using select(2). When an event is
>>>>> available the poll handler sets POLLPRI which wakes up select.
>>>>> -EINVAL
>>>>> will be returned if there are no pending events.
>>>>>
>>>>> VIDIOC_SUBSCRIBE_EVENT and VIDIOC_UNSUBSCRIBE_EVENT are used to
>>>>> subscribe and unsubscribe from events. The argument is event type.
>>>> Two event types can be defined already (used by ivtv):
>>>>
>>>> #define V4L2_EVENT_DECODER_STOPPED   1
>>>> #define V4L2_EVENT_OUTPUT_VSYNC      2
>>>>
>>>>> struct v4l2_eventdesc {
>>>>> 	__u32		type;
>>>>> 	__u8		description[64];
>>>>> 	__u32		reserved[4];
>>>>> };
>>>>>
>>>>> struct v4l2_event {
>>>>> 	__u32		type;
>>>>> 	__u32		sequence;
>>>>> 	struct timeval	timestamp;
>>>>> 	__u8		data[64];
>>>> This should be a union:
>>>>
>>>>
>>>> union {
>>>> 	enum v4l2_field ev_output_vsync;
>>>> 	__u8 data[64];
>>>> };
>>> The union will grow pretty big and I'm scared it would soon become a
>>> mess.
>>
>> But otherwise apps need to unpack the data array. That's very
>> user-unfriendly.
>> I've no problem with big unions.
>
> The size of the structure is now 96 bytes. I guess we could make that
> around 128 to allow a bit more space for data without really affecting
> performance.

With 'big unions' I didn't mean the memory size. I think 64 bytes (16
longs) is a decent size. I was talking about the union definition in the
videodev2.h header.

>> As an aside: I think that eventually videodev2.h should be split up.
>> Especially
>> the control section should be moved to a separate header and just be
>> included
>> by videodev2.h.
>>
>>>>> 	__u32		reserved[4];
>>>>> };
>>>>>
>>>>> #define VIDIOC_ENUM_EVENT	_IORW('V', 83, struct v4l2_eventdesc)
>>>>> #define VIDIOC_G_EVENT		_IOR('V', 84, struct v4l2_event)
>>>>> #define VIDIOC_SUBSCRIBE_EVENT	_IOW('V', 85, __u32)
>>>>> #define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 86, __u32)
>>>> For (un)subscribe I suggest that we also use a struct with the event
>>>> type
>>>> and a few reserved fields.
>>> Agreed.
>
> Ack.
>
>>>>> As it was discussed in the LPC, event subscriptions should be bound
>>>>> to
>>>>> file handle. The implementation, however, is not visible to
>>>>> userspace.
>>>>> This is why I'm not specifying it in this RFC.
>>>>>
>>>>> While the number of possible standard (and probably private) events
>>>>> would be quite small and the implementation could be a bit field, I
>>>>> do
>>>>> see that the interface must be using types passed as numbers instead
>>>>> of
>>>>> bit fields.
>>>>>
>>>>> Is it necessary to buffer events of same type or will an event
>>>>> replace
>>>>> an older event of the same type? It probably depends on event type
>>>>> which
>>>>> is better. This is also a matter of implementation.
>>>>>
>>>>>
>>>>> Comments and questions are more than welcome.
>>>> Here's a mixed bag of idea/comments:
>>>>
>>>> We need to define what to do when you unsubscribe an event and there
>>>> are
>>>>  still events of that type pending. Do we remove those pending events
>>>> as
>>>>  well? I think we should just keep them, but I'm open for other
>>>> opinions.
>>> It would be easier to keep them and I don't think that would hurt.
>
> I'd guess so, too.
>
>>>> I was wondering if a 'count' field in v4l2_event might be useful: e.g.
>>>> if
>>>>  you get multiple identical events, and that event is already
>>>> registered,
>>>>  then you can just increase the count rather than adding the same
>>>> event
>>>>  again. This might be overengineering, though. And to be honest, I
>>>> can't
>>>>  think of a use-case, but it's something to keep in mind perhaps.
>>> That's called events compression in the GUI world. The main reason to
>>> implement this is efficiency when dealing with events that can occur at
>>> a high
>>> frequency. For instance, when moving a window and thus exposing
>>> previously
>>> unexposed parts that need to be redrawn, compressing all the redraw
>>> events
>>> generated while the window moves make sense. There could be use cases
>>> in the
>>> media world as well, but I think this is a case of overengineering at
>>> the
>>> moment. We can always implement it later, and I don't think a count
>>> field
>>> would be useful anyway, as events that could be repeated will probably
>>> be
>>> intermixed with other events.
>
> Perhaps more than four reserved fields should be allocated for the event
> structure? :-) :-)
>
>>>> Would we ever need a VIDIOC_S_EVENT to let the application set an
>>>> event?
>>>> ('software events').
>>> Using a kernel driver to pass information from one userspace
>>> application to
>>> another doesn't seem like a very good design IMHO. Let's not do that
>>> for now.
>>>
>>>> Rather than naming the ioctl VIDIOC_G_EVENT, perhaps VIDIOC_DQEVENT
>>>> might
>>>> be more appropriate.
>>> No preference there.
>
> VIDIOC_DQEVENTS? :-)
>
>>>> How do we prevent the event queue from overflowing? Just hardcode a
>>>> watermark? Alternatively, when subscribing an event we can also pass
>>>> the
>>>> maximum number of allowed events as an argument.
>>> We can't prevent it from overflowing if the userspace application isn't
>>> fast
>>> enough. In that case events will be discarded, and the application will
>>> find
>>> out using the sequence number.
>>
>> Obviously, but my question is whether we use a fixed internal queue or
>> whether we make this something that the application can configure.
>>
>> That said, I think the initial implementation should be that the
>> subscribe
>> ioctl gets a struct with the event type and a few reserved fields so
>> that
>> in the future we can use one of the reserved fields as a configuration
>> parameter. So for now we just have some default watermark that is set by
>> the
>> driver.
>
> I'd like to think a queue size defined by the driver is fine at this
> point. It's probably depending on the driver rather than application how
> long the queue should to be. At some point old events start becoming
> uninteresting...

Question: will we drop old events or new events? Or make this
configurable? Or driver dependent?

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

