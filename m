Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52131 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753794AbdCFJ12 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 04:27:28 -0500
Subject: Re: [PATCH v2 2/3] v4l: Clearly document interactions between
 formats, controls and buffers
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170228150320.10104-3-laurent.pinchart+renesas@ideasonboard.com>
 <30dd7931-7c7c-70ed-1a62-00756406761c@xs4all.nl>
 <20170304143704.GX3220@valkosipuli.retiisi.org.uk>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a8cf842a-59b1-3d28-6c0f-aa5246820c0b@xs4all.nl>
Date: Mon, 6 Mar 2017 10:27:13 +0100
MIME-Version: 1.0
In-Reply-To: <20170304143704.GX3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/17 15:37, Sakari Ailus wrote:
> Hi Hans (and Laurent).
>
> On Sat, Mar 04, 2017 at 11:53:45AM +0100, Hans Verkuil wrote:
>> Hi Laurent,
>>
>> Here is my review:
>>
>> On 28/02/17 16:03, Laurent Pinchart wrote:
>>> V4L2 exposes parameters that influence buffers sizes through the format
>>> ioctls (VIDIOC_G_FMT, VIDIOC_TRY_FMT and VIDIO_S_FMT). Other parameters
>>
>> S_SELECTION should be mentioned here as well (more about that later).
>>
>>> not part of the format structure may also influence buffer sizes or
>>> buffer layout in general. One existing such parameter is rotation, which
>>> is implemented by the VIDIOC_ROTATE control and thus exposed through the
>>> V4L2 control ioctls.
>>>
>>> The interaction between those parameters and buffers is currently only
>>> partially specified by the V4L2 API. In particular interactions between
>>> controls and buffers isn't specified at all. The behaviour of the
>>> VIDIOC_S_FMT ioctl when buffers are allocated is also not fully
>>> specified.
>>>
>>> This commit clearly defines and documents the interactions between
>>> formats, controls and buffers.
>>>
>>> The preparatory discussions for the documentation change considered
>>> completely disallowing controls that change the buffer size or layout,
>>> in favour of extending the format API with a new ioctl that would bundle
>>> those controls with format information. The idea has been rejected, as
>>> this would essentially be a restricted version of the upcoming request
>>> API that wouldn't bring any additional value.
>>>
>>> Another option we have considered was to mandate the use of the request
>>> API to modify controls that influence buffer size or layout. This has
>>> also been rejected on the grounds that requiring the request API to
>>> change rotation even when streaming is stopped would significantly
>>> complicate implementation of drivers and usage of the V4L2 API for
>>> applications.
>>>
>>> Applications will however be required to use the upcoming request API to
>>> change at runtime formats or controls that influence the buffer size or
>>> layout, because of the need to synchronize buffers with the formats and
>>> controls. Otherwise there would be no way to interpret the content of a
>>> buffer correctly.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>> ---
>>> Documentation/media/uapi/v4l/buffer.rst | 88 +++++++++++++++++++++++++++++++++
>>> 1 file changed, 88 insertions(+)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
>>> index ac58966ccb9b..5c58db98ab7a 100644
>>> --- a/Documentation/media/uapi/v4l/buffer.rst
>>> +++ b/Documentation/media/uapi/v4l/buffer.rst
>>> @@ -34,6 +34,94 @@ flags are copied from the OUTPUT video buffer to the CAPTURE video
>>> buffer.
>>>
>>>
>>> +Interactions between formats, controls and buffers
>>> +==================================================
>>> +
>>> +V4L2 exposes parameters that influence the buffer size, or the way data is
>>> +laid out in the buffer. Those parameters are exposed through both formats and
>>> +controls. One example of such a control is the ``V4L2_CID_ROTATE`` control
>>> +that modifies the direction in which pixels are stored in the buffer, as well
>>> +as the buffer size when the selected format includes padding at the end of
>>> +lines.
>>> +
>>> +The set of information needed to interpret the content of a buffer (e.g. the
>>> +pixel format, the line stride, the tiling orientation or the rotation) is
>>> +collectively referred to in the rest of this section as the buffer layout.
>>> +
>>> +Modifying formats or controls that influence the buffer size or layout require
>>> +the stream to be stopped. Any attempt at such a modification while the stream
>>> +is active shall cause the format or control set ioctl to return the ``EBUSY``
>>> +error code.
>>
>> This is not what happens today: it's not the streaming part that causes EBUSY to
>> be returned but whether or not buffers are allocated.
>>
>> Today we do not support changing buffer sizes on the fly, so any attempt to
>> call an ioctl that would change the buffer size is blocked and EBUSY is returned.
>> To be precise: drivers call vb2_is_busy() to determine this.
>
> It certainly shouldn't be like that. Not allowing S_FMT() while there are
> buffers allocated makes CREATE_BUFS entirely useless.

Well, CREATE_BUFS can still be used to make large buffers in which the image
is composed. But yes, CREATE_BUFS has limited usefulness today, but the simple
fact is that nobody wrote drivers that really can do on the fly format changes.

>
>>
>> To my knowledge all vb2-using drivers behave like this. There may be old drivers
>> that do not do this (and these have a high likelyhood of being wrong).
>
> What's really needed is that the driver verifies that the buffer is large
> enough to be used for a given format. vb2_is_busy() shouldn't be used to
> check whether setting format is allowed.

Again, there are no drivers that support this. Using vb2_is_busy() prevents
userspace from trying this, since without proper driver support this *will*
fail.

Of course, drivers that do support this will not test vb2_is_busy but the
vb2_is_streaming instead (and with the request API even that can be dropped).

>
>>
>>> +
>>> +Controls that only influence the buffer layout can be modified at any time
>>> +when the stream is stopped. As they don't influence the buffer size, no
>>> +special handling is needed to synchronize those controls with buffer
>>> +allocation.
>>> +
>>> +Formats and controls that influence the buffer size interact with buffer
>>> +allocation. As buffer allocation is an expensive operation, drivers should
>>> +allow format or controls that influence the buffer size to be changed with
>>> +buffers allocated. A typical ioctl sequence to modify format and controls is
>>> +
>>> + #. VIDIOC_STREAMOFF
>>> + #. VIDIOC_S_FMT
>>> + #. VIDIOC_S_EXT_CTRLS
>>> + #. VIDIOC_QBUF
>>> + #. VIDIOC_STREAMON
>>> +
>>> +Queued buffers must be large enough for the new format or controls.
>>> +
>>> +Drivers shall return a ``ENOSPC`` error in response to format change
>>> +(:c:func:`VIDIOC_S_FMT`) or control changes (:c:func:`VIDIOC_S_CTRL` or
>>> +:c:func:`VIDIOC_S_EXT_CTRLS`) if buffers too small for the new format are
>>> +currently queued. As a simplification, drivers are allowed to return an error
>>> +from these ioctls if any buffer is currently queued, without checking the
>>> +queued buffers sizes. Drivers shall also return a ``ENOSPC`` error from the
>>> +:c:func:`VIDIOC_QBUF` ioctl if the buffer being queued is too small for the
>>> +current format or controls.
>>
>> Actually, today qbuf will return -EINVAL (from __verify_length in videobuf2-v4l2.c)
>> in these cases. I am pretty sure you can't change that to ENOSPC since this has
>> always been -EINVAL, and so changing this would break the ABI.
>
> *If* today drivers return -EBUSY on S_FMT if there are buffers allocated,
> you can't have this happening in the first place: it is a new condition so
> using a new error code is possible. I would not expect applications to try
> that either for the same reason.

Yes, this can happen when you pass in USERPTR or DMABUF buffers. It indeed can't
happen with MMAP buffers.

> It is rather that applications designed for a particular device are more
> likely to attempt this (e.g. capturing a still image after streaming
> viewfinder first).
>
> I realised -EBUSY is not even documented for S_FMT; I'll post a patch to fix
> that.
>
>>
>> Trying to change the format while buffers are allocated will return EBUSY today.
>>
>> If you are trying to document what will happen when drivers allow format changes
>> on the fly then this is not at all clear from what you write here.
>>
>> So:
>>
>> If the driver does not support changing the format while buffers are queued, then
>> it will return EBUSY (true for almost (?) all drivers today). If it does support
>> this, then it will behave as described above, except for the ENOSPC error in QBUF.
>>
>> Note that the meaning of ENOSPC should also be explicitly documented in the ioctls
>> that can return this.
>>
>>> Together, these requirements ensure that queued
>>> +buffers will always be large enough for the configured format and controls.
>>> +
>>> +Userspace applications can query the buffer size required for a given format
>>> +and controls by first setting the desired control values and then trying the
>>> +desired format. The :c:func:`VIDIOC_TRY_FMT` ioctl will return the required
>>> +buffer size.
>>> +
>>> + #. VIDIOC_S_EXT_CTRLS(x)
>>> + #. VIDIOC_TRY_FMT()
>>> + #. VIDIOC_S_EXT_CTRLS(y)
>>> + #. VIDIOC_TRY_FMT()
>>> +
>>> +The :c:func:`VIDIOC_CREATE_BUFS` ioctl can then be used to allocate buffers
>>> +based on the queried sizes (for instance by allocating a set of buffers large
>>> +enough for all the desired formats and controls, or by allocating separate set
>>> +of appropriately sized buffers for each use case).
>>> +
>>> +To simplify their implementation, drivers may also require buffers to be
>>> +reallocated in order to change formats or controls that influence the buffer
>>> +size. In that case, to perform such changes, userspace applications shall
>>> +first stop the video stream with the :c:func:`VIDIOC_STREAMOFF` ioctl if it
>>> +is running and free all buffers with the :c:func:`VIDIOC_REQBUFS` ioctl if
>>> +they are allocated. The format or controls can then be modified, and buffers
>>> +shall then be reallocated and the stream restarted. A typical ioctl sequence
>>> +is
>>> +
>>> + #. VIDIOC_STREAMOFF
>>> + #. VIDIOC_REQBUFS(0)
>>> + #. VIDIOC_S_FMT
>>> + #. VIDIOC_S_EXT_CTRLS
>>> + #. VIDIOC_REQBUFS(n)
>>> + #. VIDIOC_QBUF
>>> + #. VIDIOC_STREAMON
>>> +
>>> +The second :c:func:`VIDIOC_REQBUFS` call will take the new format and control
>>> +value into account to compute the buffer size to allocate. Applications can
>>> +also retrieve the size by calling the :c:func:`VIDIOC_G_FMT` ioctl if needed.
>>> +
>>> +When reallocation is required, any attempt to modify format or controls that
>>> +influences the buffer size while buffers are allocated shall cause the format
>>> +or control set ioctl to return the ``EBUSY`` error code.
>>
>> Ah, here you describe the 99% situation. This should come first. You've been working
>> on the 1% that allows changing formats while buffers are allocated so that feels
>> all-important to you, but in reality almost all drivers use the 'simplified'
>> implementation. Describe that first, then go on describing what will happen for
>> your driver. That will make much more sense to me (as you can tell from the preceding
>> comments) and I'm sure to the end-user as well.
>>
>> What should be mentioned here as well is that S_SELECTION can also implicitly change
>> the format, specifically if there is no scaler or if the scaler has limitations.
>
> I think it'd be fine to mention that, but the effect is indeed implicit
> through the change in format.
>
>>
>> Also there are a few ioctls that can reset selections and formats when called:
>> S_INPUT/S_OUTPUT, S_STD and S_DV_TIMINGS.
>>
>> I think this should be mentioned here. It can be just in passing, no need to go
>> in-depth on that. As long as people are aware of it.
>>
>> The documentation of S_STD and S_DV_TIMINGS should also be updated saying that if
>> the new std or timings differ from the existing std or timings, then the format
>> will also change and selection rectangles will be reset to the defaults. Setting
>> the std/dv_timings with the current std or timings will not do anything: there
>> are applications that do this even when streaming so this should be allowed.
>>
>> Unfortunately, this is not documented but it really should.
>>
>> If you don't have time to update the S_STD/DV_TIMINGS ioctls, then let me know and
>> I will do that.
>

Regards,

	Hans
