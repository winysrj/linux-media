Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab1LENB5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 08:01:57 -0500
Message-ID: <4EDCC0B3.1000303@redhat.com>
Date: Mon, 05 Dec 2011 11:01:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	=?UTF-8?B?J1NlYmFzdGlhbiBEcsO2Z2Un?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01> <4ED8C61C.3060404@redhat.com> <20111202135748.GO29805@valkosipuli.localdomain> <006b01ccb108$d3eafff0$7bc0ffd0$%debski@samsung.com> <4ED905E0.5020706@redhat.com> <20111203000854.GP29805@valkosipuli.localdomain>
In-Reply-To: <20111203000854.GP29805@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02-12-2011 22:08, 'Sakari Ailus' wrote:
> Hi Mauro,
>
> On Fri, Dec 02, 2011 at 03:07:44PM -0200, Mauro Carvalho Chehab wrote:
>>>> I'm not fully certain it is always possible to find out the largest stream
>>>> resolution. I'd like an answer from someone knowing more about video codecs
>>>> than I do.
>>>
>>> That is one thing. Also, I don't think that allocating N buffers each of
>>> 1920x1080 size up front is a good idea. In embedded systems the memory can
>>> be scarce (although recently this is changing and we see smart phones with
>>> 1 GB of ram). It is better to allow application to use the extra memory when
>>> possible, if the memory is required by the hardware then it can be reclaimed.
>>
>> It depends on how much memory you have at the device. API's should be designed
>> to allow multiple usecases. I'm sure that dedicated system (either embedded
>> or not) meant to work only streaming video will need to have enough memory to
>> work with the worse case. If there are any requirements for such server to not
>> stop streaming if the resolution changes, the right thing to do is to allocate
>> N buffers of 1920x1080.
>>
>> Also, as you've said, even on smart phones, devices new devices now can have
>> multiple cores, GB's of ram, and, soon enough, likely 64 bits kernels.
>
> Some devices may, but they then to be high end devices. Others are tighter
> on memory and even if there is plenty, one can seldom just go and waste it.
> As you also said, we must take different use cases into account.
>
>> Let's not limit the API due to a current constraint that may not be true on a
>> near future.
>>
>> What I'm saying is that it should be an option for the driver to require
>> STREAMOFF in order to change buffers size, and not a mandatory requirement.
>
> Let's assume the user does not wish that the streaming is stopped at format
> change if the buffers are big enough for the new format. The user does get a
> buffer thelling the format has changed, and requests a new format using G_FMT.
> In between the two IOCTLs time has passed and the format may have changed
> again. How would we avoid that from happening, unless we stop the stream?

I see two situations:

1) The buffer is big enough for the new format. There's no need to stop streaming.

2) The buffer is not big enough. Whatever logic used, the DMA engine should not
be able to write past the buffer (it can either stop before filling the buffer or
the harware may just partially fill the data). An ERROR flag should be rised on
this case, and a STREAMOFF event will happen. The STREAMOFF is implicit in this
case. So, even if the driver doesn't receive such ioctl, there's no sense to keep
the DMA engine working.


So, in case 1, there is enough buffer for the new format. As a flag indicates that
the format has changed, userspace could get the new format either by some event
or by a G_FMT call.

Ok, with a G_FMT call, there is a risk that the format would change again for a
newly filled buffer, but this is very unlikely (as changing the format for just
one frame doesn't make much sense on a stream, except if such frame is a high-res
snapshot). On non-snapshot streams, format resolution may happen, for example,
when an HD sports game or a 3D movie may got interrupted by some commercials
broadcasted on a different way. In such case, the new format will stay
there for more than a few buffers. So, using G_FMT on such cases would work.

An event-based implementation is for sure more robust. So, I think it is worthy
to have it also implemented.

> The underlying root cause for the problem is that the format is not bound to
> buffers.

Yes. A format-change type of event could be used to do such binding.

> I also do not see it as a problem to require streaö stop and start. Changing
> resolution during streaming is anyway something any current application
> likely hasn't prepared for, so we are not breaking anything. Quite contrary,
> actually: applicatuons now knowing the flag would only able to dequeue junk
> after receiving it the first time.

This maybe true for the current applications and usecases, but it doesn't seem to
fit forall.

Assuming a decoding block that it is receiving an MPEG block as input, and it
is converting it to RGB, before actually filling a buffer, it is possible for
such block to warn the userspace application that the format has changed, before
actually starting to fill such buffer. If the buffer is big enough, there is no
need to discard its content, nor to stop streaming.

> ...
>
>>>> The user space still wants to be able to show these buffers, so a new flag
>>>> would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for example.
>>>
>>> Currently it is done in the following way. On the CAPTURE side you have a
>>> total of N buffers. Out of them K are necessary for decoding (K = 1 + L).
>>> L is the number of buffers necessary for reference lookup and the single
>>> buffer is required as the destination for new frame. If less than K buffers
>>> are queued then no processing is done. The buffers that have been dequeued
>>> should be ok with the application changing them. However if you request some
>>> arbitrary display delay you may get buffers that still could be used as
>>> reference. Thus I agree with Sakari that the V4L2_BUF_FLAG_READ_ONLY flag
>>> should be introduced.
>>>
>>> However I see one problem with such flag. Let's assume that we dequeue a
>>> buffer. It is still needed as reference, thus it has the READ_ONLY flag
>>> set. Then we dequeue another buffer. Ditto for that buffer. But after we
>>> have dequeued the second buffer the first can be modified. How to handle this?
>>>
>>> This flag could be used as a hint for the application saying that it is risky
>>> to modify those buffers.
>>
>> As I said before, a dqueued buffer is assomed to be a buffer where the Kernel
>> won't use it anymore. If kernel still needs it, just don't dequeue it yet.
>> Anything different than that may cause memory corruption, cache coherency
>> issues, etc.
>
> If we do't dequeue, there will be a pause in the video which is played on a
> TV. This is highly undesirable. The flag is simply telling the user that the
> buffer is still being used by the hardware but only for read access.
>
> Certain other interfaces support this kind of behaviour, which is specific
> to codec devices.
>

I see.

Regards,
Mauro
