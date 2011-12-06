Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1LFPkb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 10:40:31 -0500
Message-ID: <4EDE375B.6010900@redhat.com>
Date: Tue, 06 Dec 2011 13:40:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?B?J1NlYmFzdGlhbiBEcsO2Z2Un?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Hans Verkuil'" <hans.verkuil@cisco.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01> <4ED905E0.5020706@redhat.com> <007201ccb118$633ff890$29bfe9b0$%debski@samsung.com> <201112061301.01010.laurent.pinchart@ideasonboard.com> <20111206142821.GC938@valkosipuli.localdomain> <4EDE29AA.8090203@redhat.com> <00de01ccb42a$7cddab70$76990250$%debski@samsung.com>
In-Reply-To: <00de01ccb42a$7cddab70$76990250$%debski@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-12-2011 13:19, Kamil Debski wrote:
>> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
>> Sent: 06 December 2011 15:42
>>
>> On 06-12-2011 12:28, 'Sakari Ailus' wrote:
>>> Hi all,
>>>
>>> On Tue, Dec 06, 2011 at 01:00:59PM +0100, Laurent Pinchart wrote:
>>> ...
>>>>>>>>> 2) new requirement is for a bigger buffer. DMA transfers need to be
>>>>>>>>> stopped before actually writing inside the buffer (otherwise, memory
>>>>>>>>> will be corrupted).
>>>>>>>>>
>>>>>>>>> In this case, all queued buffers should be marked with an error flag.
>>>>>>>>> So, both V4L2_BUF_FLAG_FORMATCHANGED and V4L2_BUF_FLAG_ERROR should
>>>>>>>>> raise. The new format should be available via G_FMT.
>>>>
>>>> I'd like to reword this as follows:
>>>>
>>>> 1. In all cases, the application needs to be informed that the format has
>>>> changed.
>>>>
>>>> V4L2_BUF_FLAG_FORMATCHANGED (or a similar flag) is all we need. G_FMT
>> will
>>>> report the new format.
>>>>
>>>> 2. In all cases, the application must have the option of reallocating
>> buffers
>>>> if it wishes.
>>>>
>>>> In order to support this, the driver needs to wait until the application
>>>> acknowledged the format change before it starts decoding the stream.
>>>> Otherwise, if the codec started decoding the new stream to the existing
>>>> buffers by itself, applications wouldn't have the option of freeing the
>>>> existing buffers and allocating smaller ones.
>>>>
>>>> STREAMOFF/STREAMON is one way of acknowledging the format change. I'm not
>>>> opposed to other ways of doing that, but I think we need an
>> acknowledgment API
>>>> to tell the driver to proceed.
>>>
>>> Forcing STRAEMOFF/STRAEMON has two major advantages:
>>>
>>> 1) The application will have an ability to free and reallocate buffers if
>> it
>>> wishes so, and
>>>
>>> 2) It will get explicit information on the changed format. Alternative
>> would
>>> require an additional API to query the format of buffers in cases the
>>> information isn't implicitly available.
>>
>> As already said, a simple flag may give this meaning. Alternatively (or
>> complementary,
>> an event may be generated, containing the new format).
>>>
>>> If we do not require STRAEMOFF/STREAMON, the stream would have to be
>> paused
>>> until the application chooses to continue it after dealing with its
>> buffers
>>> and formats.
>>
>> No. STREAMOFF is always used to stop the stream. We can't make it mean
>> otherwise.
>>
>> So, after calling it, application should assume that frames will be lost,
>> while
>> the DMA engine doesn't start again.
>
> Do you mean all buffers or just those that are queued in hardware?

Of course the ones queued.

> What has been processed stays processed, it should not matter to the buffers
> that have been processed.

Sure.

> The compressed buffer that is queued in the driver and that caused the resolution
> change is on the OUTPUT queue.

Not necessarily. If the buffer is smaller than the size needed for the resolution
change, what is there is trash, as it could be a partially filled buffer or an
empty buffer, depending if the driver detected about the format change after or
before start filling it.

> STREMOFF is only done on the CAPTURE queue, so it
> stays queued and information is retained.
>
>  From CAPTURE all processed buffers have already been dequeued, so yes the content of
> the buffers queued in hw is lost. But this is ok, because after the resolution change
> the previous frames are not used in prediction.

No. According with the spec:

	The VIDIOC_STREAMON and VIDIOC_STREAMOFF ioctl start and stop the capture or
	output process during streaming (memory mapping or user pointer) I/O.

	Specifically the capture hardware is disabled and no input buffers are filled
	(if there are any empty buffers in the incoming queue) until VIDIOC_STREAMON
	has been called. Accordingly the output hardware is disabled, no video signal
	is produced until VIDIOC_STREAMON has been called. The ioctl will succeed
	only when at least one output buffer is in the incoming queue.

	The VIDIOC_STREAMOFF ioctl, apart of aborting or finishing any DMA in progress,
	unlocks any user pointer buffers locked in physical memory, and it removes all
	buffers from the incoming and outgoing queues. That means all images captured
	but not dequeued yet will be lost, likewise all images enqueued for output
	but not transmitted yet. I/O returns to the same state as after calling
	VIDIOC_REQBUFS and can be restarted accordingly.

> My initial idea was to acknowledge the resolution change by G_FMT.
> Later in our chat it had evolved into S_FMT. Then it mutated into
> STREAMOFF/STREAMON on the CAPTURE queue.

Why application should ack with it? If the application doesn't ack, it can just send
a VIDIOC_STREAMOFF. If application doesn't do it, and the buffer size is enough to
proceed, the hardware should just keep doing the DMA transfers and assume that the
applications are OK.

>> For things like MPEG decoders, Hans proposed an ioctl, that could use to
>> pause
>> and continue the decoding.
>
> This still could be useful... But processing will also pause when hw runs out
> of buffers. It will be resumed after the application consumes/produces new
> buffers and enqueue them.

No. Capture devices will start loosing frames. For other types, it makes sense to
implicitly pause/continue.

>>> I'd still return a specific error when the size changes since it's more
>>> explicit that something is not right, rather than just a flag. But if I'm
>>> alone in thinking so I won't insist.
>>>
>>> Regards,
>>>
>
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
>

