Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab1HCPNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2011 11:13:10 -0400
Message-ID: <4E396569.30708@codeaurora.org>
Date: Wed, 03 Aug 2011 09:12:41 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
MIME-Version: 1.0
To: Tom Cooksey <Tom.Cooksey@arm.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
References: <4E37C7D7.40301@samsung.com> <4E381B73.8050706@codeaurora.org> <20E136AF98049A48A90A7417B4343D5E1DF747A563@BUNGLE.Emea.Arm.com>
In-Reply-To: <20E136AF98049A48A90A7417B4343D5E1DF747A563@BUNGLE.Emea.Arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2011 03:33 AM, Tom Cooksey wrote:
>
>
>> -----Original Message-----
>> From: linaro-mm-sig-bounces@lists.linaro.org [mailto:linaro-mm-sig-
>> bounces@lists.linaro.org] On Behalf Of Jordan Crouse
>> Sent: 02 August 2011 16:45
>> To: Marek Szyprowski
>> Cc: linaro-mm-sig@lists.linaro.org; Tomasz Stanislawski; Kyungmin Park;
>> linux-media@vger.kernel.org
>> Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
>>
>> On 08/02/2011 03:48 AM, Marek Szyprowski wrote:
>>> Hello Everyone,
>>>
>>> This patchset introduces the proof-of-concept infrastructure for
>> buffer sharing between multiple devices using file descriptors. The
>> infrastructure has been integrated with V4L2 framework, more
>> specifically videobuf2 and two S5P drivers FIMC (capture interface) and
>> TV drivers, but it can be easily used by other kernel subsystems, like
>> DRI.
>>>
>>> In this patch the buffer object has been simplified to absolute
>> minimum - it contains only the buffer physical address (only physically
>> contiguous buffers are supported), but this can be easily extended to
>> complete scatter list in the future.
>>>
>>> Best regards
>>
>> Looks like a good start.  I'm not sure what has already been discussed
>> at the meetings, so please forgive me if any of these comments have
>> already been added to the to-do list and/or discounted.
>>
>> I would definitely consider adding lock and unlock functions. It would
>> be great to have sane fencing built right into the sharing mechanism.
>> Deferred unlock would be nice too, but that is probably hard to do in
>> a generic way.
>
> We've discussed synchronization and I think the general consensus is to
> keep it separate from the buffer sharing mechanism. Initially at least,
> user-space should be able to implement whatever mechanisms it needs on
> top of the buffer sharing system.
>
> However, it was mentioned that having to bounce up into userspace and
> then go back down into kernel space when an event occurs is sub-optimal.
> To improve things, we discussed adding a kernel-side synchronization
> object/event mechanism. Extra API could be added to V4L2/KMS/Whatever
> which tells that driver to signal the sync object when something happens
> and another bit of API to tell the driver to do something when a sync
> object is signalled. A simple example might be to tell a camera to write
> to a buffer and signal a sync object when it has written a complete
> frame. At the same time, you could tell a KMS overlay plane to switch
> to the new video frame once the synchronization object is signalled. So
> userspace sets up what needs to happen, but it all actually occurs
> asynchronously (from the application's point of view) in kernel space.
> This obviously needs some more thought and investigation, but from the
> discussions we had yesterday, I don't think anything would stop this
> kind of thing being added in the future.

I think thats is exactly what I was getting at. You solved the hard case
first. The use case I had in mind was composition where you might have a
2D surface (or video surface) being composited into a 3D scene, and you
wanted to serialize access to the surface, but it would be optimal to
asynchronously release the lock when the surface is available without
bothering user-space. I think what you describe above would handle that
perfectly.

>> The owner of the buffer should be able to attach a private information
>> structure to the object and the consumer should be able to get it. This
>> is key for sharing buffer information and out of band data, especially
>> for video buffers (width, height, fourcc, alignment, pitch, start
>> of U buffer, start of V buffer, UV pitch, etc)
>
> Passing buffer meta-data around was also discussed yesterday. Again, the
> general consensus seemed to be that this data should be kept out of the
> kernel. The userspace application should know what the buffer format
> etc. is and can provide that information to the relevant device APIs
> when is passes in the buffer.

True, but APIs change slowly. Some APIs *cough* OpenMAX *cough* are damn
near immutable over the life time of a average software release. A blob of
data attached to a buffer can evolve far more rapidly and be far more
extensible and much more vendor specific. This isn't an new idea, I think
the DRM/GEM guys have tossed it around too.

I bring up OpenMAX because this has been a thorn in my side before. Based
on quirks in the video decoder and the GPU, there are various alignment
requirements for the YUV frames which may differ slightly between different
generations of GPUs and decoders. There just isn't enough information in
the Port Definition for OMX to give us 100% certainty that we have the right
magic combination, so we have to make educated guesses based on gentleman's
agreements with the encoder drivers that the blocks will be aligned in certain
ways. It works well enough to be functional, but I hate leaving things to
agreement and chance. If we could have space to store a blob in the buffer
structure it would make all the difference in the world.

> This ties into another discussion we had yesterday about which device
> allocates buffers and how format negotiation works. I think this was a
> little more contentious. It seemed like a slight majority favoured a
> system where there wasn't a single buffer allocation device. Instead,
> each device API could allocate buffers and provide a way to get a file
> descriptor which could be passed to different devices. However, without
> a centralized buffer allocator, userspace needs to know which device it
> should use to allocate a buffer which it wants to share with another
> device. There's two aspects of this. The first is the actual memory
> allocation parameters - where in physical memory the buffer is
> allocated from, if it is physically contiguous or not, etc. This is
> information userspace shouldn't have to know. I seem to recall the
> discussion concluding that at least for the first iteration, userspace
> must "know" which device it has to use. I.e. There must be some vendor
> specific code in userspace which knows if a buffer is to be shared
> between device B and device D, device D must be used to allocate it.

I agree.  It is easy to get bogged down into details. Like say
that D has an IOMMU and that B only can access contiguous memory so then
D needs to know what B's capabilities are. These are policy decisions that
can only be rightly be done in userspace. I think in practice this will be
less complex then it sounds since most of our modern SoCs have hardware
that is flexible enough to handle the odd device with strange requirements
(Samsung encoder) but designing for the worse case is always a good
policy.

> The second aspect is format negotiation. This seemed less contentious.
> V4L2 already provides API to query what formats a device supports so
> userspace can figure out which formats, etc. are common. Not sure
> about KMS or DRM, but it at least seems feasible to be able to add
> ioctls to query supported formats even if that doesn't exist today.
> I guess for GPU drivers, the userspace part of the driver will know
> what formats the GPU it's driving supports, so no need to query.

I agree for the most part. I think it gets a little bit less clear for
things like streaming textures and EGL images where the specifications
are far less clear about what is supported and the behavior tends to be
more vendor specific. Of course, the vendors could help themselves with
a private blob on the buffer to fill in the vague details.. :)

Jordan

>
>
> Cheers,
>
> Tom
>
>
>
>
>>
>> Thinking back to anything that could be salvaged from PMEM, about the
>> only
>> thing of value that wouldn't otherwise be implemented here is the idea
>> of
>> revoking a buffer. The thought is that when the master is was done with
>> the buffer, it could revoke it so that the client couldn't hang on to
>> it
>> forever and possibly use it for nefarious purposes.  The client still
>> has
>> it mapped, but the range is remapped to garbage. I've never been very
>> clear on how useful this was from a security standpoint because the
>> master
>> has to implicitly share the fd in the first place but it seems to be a
>> feature that has survived several years of pmem hacking.
>>
>> I look forward to seeing the session notes from the meetings and seeing
>> what the other ideas are.  Thanks for your hard work.
>>
>> Jordan
>>
>> _______________________________________________
>> Linaro-mm-sig mailing list
>> Linaro-mm-sig@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>
>
> -- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.
>
>

