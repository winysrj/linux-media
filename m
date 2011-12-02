Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab1LBSKL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 13:10:11 -0500
Message-ID: <4ED91472.9000907@redhat.com>
Date: Fri, 02 Dec 2011 16:09:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	=?UTF-8?B?J1NlYmFzdGlhbiBEcsO2Z2Un?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01> <4ED8C61C.3060404@redhat.com> <20111202135748.GO29805@valkosipuli.localdomain> <006b01ccb108$d3eafff0$7bc0ffd0$%debski@samsung.com> <4ED905E0.5020706@redhat.com> <007201ccb118$633ff890$29bfe9b0$%debski@samsung.com>
In-Reply-To: <007201ccb118$633ff890$29bfe9b0$%debski@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02-12-2011 15:32, Kamil Debski wrote:
>>> Usually there is a minimum number of buffers that has to be kept for future
>>> references. New frames reference previous frames (and sometimes the following
>>> frames as well) to achieve better compression. If we haven't got enough buffers
>>> decoding cannot be done.
>>
>> OK, but changing the resolution won't affect the number of buffers needed
>> for
>> inter-frame interpolation.
>
> Changing resolution alone will not affect it, but changing the resolution
> is very often associated with other changes in the stream. Imagine that there
> are two streams - one 720P that needs 4 buffer and second 1080P that needs 6.
> When the change is done - both resolution is increased and the minimum
> number of buffers.

OK. In this case, if just 4 buffers were pre-allocated, driver will need to
stop streaming (or the application should start with 6 buffers, if it needs
to support such changes without stopping the stream).

>> As I said before, a dqueued buffer is assomed to be a buffer where the
>> Kernel
>> won't use it anymore. If kernel still needs it, just don't dequeue it yet.
>> Anything different than that may cause memory corruption, cache coherency
>> issues, etc.
>
> I agree. This flag could be used as a hint when the display delay is enforced.
> On the other hand - when the application requests an arbitrary display delay
> then it should be aware that modifying those buffers is risky.

Looking at the issue from the other side, I can't see what the application would
do with such hint.

> The display delay is the number of buffers/frames that the codec processes before
> returning the first buffer. For example if it is set to 0 then it returns the
> buffers ASAP, not regarding their order or that they are still used.
> This functionality can be used to create thumbnail images of movies in a gallery
> (by decoding a single frame from the beginning of the movie).

A 0-delay buffer like the above described would probably mean that the userspace
application won't touch on it anyway, as it needs that buffer as soon as possible.

A single notice at the API spec should be enough to cover this case.

>>>>> The minimal number of buffers is more related to latency issues and
>>>> processing
>>>>> speed at userspace than to any driver or format-dependent hardware
>>>> constraints.
>>>>>
>>>>> On the other hand, the maximum number of buffers might eventually have
>>>> some
>>>>> constraint, e. g. a hardware might support less buffers, if the
>> resolution
>>>>> is too high.
>>>>>
>>>>> I prefer to not add anything to the V4L2 API with regards to changes at
>>>> max/min
>>>>> number of buffers, except if we actually have any limitation at the
>>>> supported
>>>>> hardware. In that case, it will likely need a separate flag, to indicate
>>>> userspace
>>>>> that buffer constraints have changed, and that audio buffers will also
>>>> need to be
>>>>> re-negotiated, in order to preserve A/V synch.
>>>>
>>>> I think that boils down to the properties of the codec and possibly also
>> the
>>>> stream.
>>>
>>> If a timestamp or sequence number is used then I don't see why should we
>>> renegotiate audio buffers. Am I wrong? Number of audio and video of
>> buffers
>>> does not need to be correlated.
>>
>> Currently, alsa doesn't put a timestamp on the buffers. Ok, this is
>> something
>> that require fixes there.
>
> Ups, I did not know this. If so then there we should think about a method to
> synchronize audio and video.

Yes. Someone needs to come up with some patches for alsa. This seems to be
the right thing to do.

>>>>>> 5) After the application does STREMON the processing should continue.
>> Old
>>>>>> buffers can still be used by the application (as CREATE_BUFS was used),
>>>> but
>>>>>> they should not be queued (error shall be returned in this case). After
>>>> the
>>>>>> application is finished with the old buffers it should free them with
>>>>>> DESTROY_BUFS.
>>>>>
>>>>> If the buffers are bigger, there's no issue on not allowing queuing them.
>>>> Enforcing
>>>>> it will likely break drivers and eventually applications.
>>>>
>>>> I think this means buffers that are too small for the new format. They
>> are
>>>> no longer needed after they have been displayed --- remember there must
>> also
>>>> be no interruption in displaying the video.
>>>
>>> Yes, I have meant the buffers that are too small.
>>>
>
>
> Best wishes,

Regards,
Mauro.
