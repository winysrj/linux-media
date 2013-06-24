Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37863 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FXWF5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 18:05:57 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so4473416bkc.28
        for <linux-media@vger.kernel.org>; Mon, 24 Jun 2013 15:05:55 -0700 (PDT)
Message-ID: <51C8C2C0.4070904@gmail.com>
Date: Tue, 25 Jun 2013 00:05:52 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for events with a large payload
References: <201305131414.43685.hverkuil@xs4all.nl> <201306190832.36016.hverkuil@xs4all.nl> <20130622224657.GI2064@valkosipuli.retiisi.org.uk> <201306241457.34274.hverkuil@xs4all.nl>
In-Reply-To: <201306241457.34274.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 06/24/2013 02:57 PM, Hans Verkuil wrote:
> On Sun June 23 2013 00:46:57 Sakari Ailus wrote:
>> On Wed, Jun 19, 2013 at 08:32:35AM +0200, Hans Verkuil wrote:
>>> On Tue June 18 2013 23:22:33 Laurent Pinchart wrote:
>>>> On Friday 07 June 2013 00:38:04 Sakari Ailus wrote:
>>>>> On Mon, May 13, 2013 at 02:14:43PM +0200, Hans Verkuil wrote:
>>>>>> Currently the event API allows for a payload of up to 64 bytes. Sometimes
>>>>>> we would like to pass larger payloads to userspace such as metadata
>>>>>> associated with a particular video stream.
>>>>>>
>>>>>> A typical example of that would be object detection events.
>>>>>>
>>>>>> This RFC describes one approach for doing this.
>>>>>>
>>>>>> The event framework has the nice property of being able to use from within
>>>>>> interrupts. Copying large payloads does not fit into that framework, so
>>>>>> such payloads should be adminstrated separately.

But does it really need to be reflected in user space that much, i.e. by
introducing a separate ioctl for de-queueing the payload ?

>>>>>> In addition, I wouldn't allow large payloads to be filled in from
>>>>>> interrupt context: a worker queue would be much more appropriate.
>>>>>
>>>>> How large really is "large"? 65 bytes? 64 kiB?
>>>
>>> More than 64 bytes, which is what v4l2_event supports today.

This seems some artificial distinction which is likely inaccurate across
various systems. For many of them there is not much difference whether
we copy 64 B or 1 kB. Of course it have to be dealt in the kernel from
what context events of what size are passed from a device driver to the
v4l2-core. But once the event object has been queued in the core it
is not really relevant from what context it has been queued, is it ?

>>> In general events have no or small payloads. So for the majority 64 bytes
>>> is enough.
>>>
>>>>>
>>>>> The newer CPUs tend to be faster and faster and the same applies to memory.
>>>>> I guess threaded interrupt handlers are still nice. But using a mutex in
>>>>> order to serialise access to the struct will force drivers to use threaded
>>>>> interrupt handlers should they want to generate large events.
>>>
>>> But there are still lots of embedded systems out there that are not fast. Or
>>> that run at reduced frequency to preserve power, etc., etc.

Again, IMHO it's not the API design that should make the border, rather
a driver for a particular device/system, provided with a non-blocking API
for small/fast events and with a blocking one for the larger payload events.

>>> Interrupts should be fast, and 64 bytes seems a reasonable limit to me.

>>>>>> Note that the event API is only useful for relatively low-bandwidth data
>>>>>> since the data is always copied. When dealing with high-bandwidth data the
>>>>>> data should either be a separate plane or become a special stream I/O
>>>>>> buffer type.
>>>>>>
>>>>>> The userspace API enhancements in order to achieve this would be the
>>>>>> following:
>>>>>>
>>>>>> - Any event that has a large payload would specify a payload_sequence
>>>>>>    counter and a payload size value (in bytes).
>>>>>>
>>>>>> - A new VIDIOC_DQEVENT_PAYLOAD ioctl would be added which passes the event
>>>>>>    type, the payload_sequence counter and a pointer to a buffer to the
>>>>>>    kernel, and the payload is returned, or an error is returned if the
>>>>>>    payload data is no longer available.
>>>>>
>>>>> Do you think we should have a separate IOCTL for this? The downside is that
>>>>> to dequeue events, the application would need to try both in the worst case
>>>>> just to obtain an event.

Yes, I'm also not convinced doubling the number of ioctls and adding all
complexity related with matching an event and the payload is a good 
approach.
The system has more data to deal with and we're complicating the API and 
adding
more overhead for this case ?

>>>>> I think it'd be nicer to be able to fit that into the same IOCTL. There are
>>>>> plenty of reserved fields and, actually, the event data as well: we could
>>>>> consider the large-payload event a meta-event which would contain the
>>>>> required information to pass the event data to the user space. The type of
>>>>> such an event could be V4L2_EVENT_LARGE, for instance.
>>>>
>>>> The problem is that userspace doesn't know in advance how much memory it would
>>>> need to allocate to store the event payload. Using two ioctls allow retrieving
>>>> the size first, and then the payload. We could work around the problem by
>>>> passing the maximum size to userspace and forcing preallocation of large
>>>> enough buffers.
>>>
>>> The problem is also that you don't know what event you will get when calling
>>> DQEVENT. So you would have to figure out the maximum of the payload sizes of all
>>> subscribed events which is rather awkward.
>>
>> Is it? The application knows which events it has subscribed, and the maximum
>> event size is the maximum of that of maximum of different event types.

I side Sakari here. Since we cannot pass the information about a payload 
buffer
size to the kernel in same ioctl it looks acceptable to me to have user 
space
provided with an API to retrieve the maximum event's payload size, 
preallocating
the buffers and using them when de-queueing any event.

Also, couldn't an application subscribe to "large payload" event(s) on 
one file
handle and to any other events, like currently supported, on a separate 
file
handle ?

>>>>>> Optional enhancements:
>>>>>>
>>>>>> - Have VIDIOC_SUBSCRIBE_EVENT return the maximum payload size (lets apps
>>>>>>    preallocate payload memory, but it might be overkill).
>>>>>
>>>>> Why so? We could use a reserved field as well. The size would be zero if the
>>>>> maximum would be less than 64.
>>>
>>> I'm undecided here. Implementing support for this in an application is probably
>>> the best way to discover whether or not it is useful to supply the maximum
>>> payload size to the user. I suspect that this is actually useful.
>>
>> I agree. Otherwise the application would have to figure it out through other
>> ways which are less generic and also more difficult. On the other hand, the
>> maximum event size could be dependent on unrelated parameters, such as image
>> size. If the user changes the image size without changing the event
>> subscription this could be a problem. (Well, there's an obvious solution,
>> too, if we run into this: provide an event on it, just as on control
>> parameters. :-))

Oops, that might be indeed a bit of a problem. But first someone needs 
to come
up with such a flexible payload event... Just poking to see if there is 
anyone
already waiting with such one out there... :)

> A meta-event. You're evil :-)
>
> I do think that in practice there is always an upper worst case bound. Although
> it a probably a good idea to allow for a case where no such bound can be given.

Regards,
Sylwester
