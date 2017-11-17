Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44402 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935138AbdKQObv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 09:31:51 -0500
Subject: Re: [RFC v5 06/11] [media] vb2: add explicit fence user API
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-7-gustavo@padovan.org>
 <6fb67083-7417-0137-9449-36a4cfdb1b9d@xs4all.nl>
 <20171117115307.1b1a5a76@vento.lan>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <62f5db4a-ce47-fdee-15cc-5be1cc9daf4c@xs4all.nl>
Date: Fri, 17 Nov 2017 15:31:48 +0100
MIME-Version: 1.0
In-Reply-To: <20171117115307.1b1a5a76@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/11/17 14:53, Mauro Carvalho Chehab wrote:
> Em Fri, 17 Nov 2017 14:29:23 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 15/11/17 18:10, Gustavo Padovan wrote:
>>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>>>
>>> Turn the reserved2 field into fence_fd that we will use to send
>>> an in-fence to the kernel and return an out-fence from the kernel to
>>> userspace.
>>>
>>> Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be used
>>> when sending a fence to the kernel to be waited on, and
>>> V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-fence.
>>>
>>> v4:
>>> 	- make it a union with reserved2 and fence_fd (Hans Verkuil)
>>>
>>> v3:
>>> 	- make the out_fence refer to the current buffer (Hans Verkuil)
>>>
>>> v2: add documentation
>>>
>>> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>>> ---
>>>  Documentation/media/uapi/v4l/buffer.rst       | 15 +++++++++++++++
>>>  drivers/media/usb/cpia2/cpia2_v4l.c           |  2 +-
>>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 ++--
>>>  drivers/media/v4l2-core/videobuf2-v4l2.c      |  2 +-
>>>  include/uapi/linux/videodev2.h                |  7 ++++++-
>>>  5 files changed, 25 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
>>> index ae6ee73f151c..eeefbd2547e7 100644
>>> --- a/Documentation/media/uapi/v4l/buffer.rst
>>> +++ b/Documentation/media/uapi/v4l/buffer.rst
>>> @@ -648,6 +648,21 @@ Buffer Flags
>>>        - Start Of Exposure. The buffer timestamp has been taken when the
>>>  	exposure of the frame has begun. This is only valid for the
>>>  	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` buffer type.
>>> +    * .. _`V4L2-BUF-FLAG-IN-FENCE`:
>>> +
>>> +      - ``V4L2_BUF_FLAG_IN_FENCE``
>>> +      - 0x00200000
>>> +      - Ask V4L2 to wait on fence passed in ``fence_fd`` field. The buffer
>>> +	won't be queued to the driver until the fence signals.
>>> +
>>> +    * .. _`V4L2-BUF-FLAG-OUT-FENCE`:
>>> +
>>> +      - ``V4L2_BUF_FLAG_OUT_FENCE``
>>> +      - 0x00400000
>>> +      - Request a fence to be attached to the buffer. The ``fence_fd``
>>> +	field on
>>> +	:ref:`VIDIOC_QBUF` is used as a return argument to send the out-fence
>>> +	fd to userspace.  
>>
>> How would userspace know if fences are not supported? E.g. any driver that does
>> not use vb2 will have no support for it.
>>
>> While the driver could clear the flag on return, the problem is that it is a bit
>> late for applications to discover lack of fence support.
>>
>> Perhaps we do need a capability flag for this? I wonder what others think.
> 
> We're almost running out of flags at v4l2 caps (and at struct v4l2_buffer).

struct v4l2_capability has more than enough room to add a new device_caps2 field.
So I see no problem there, and it is very useful for applications to know what
features are supported up front and not when you start to use them.

Think about it: you're setting up complete fence support in your application, only
to discover when you queue the first buffer that there is no fence support! That
doesn't work.

The reserved[] array wasn't added for nothing to v4l2_capability.

struct v4l2_buffer is indeed very full. But I posted an RFC on October 26 introducing
a struct v4l2_ext_buffer, designed from scratch. We can switch to a u64 flags there.

See here: https://www.mail-archive.com/linux-media@vger.kernel.org/msg121215.html

I am waiting for fences and the request API to go in before continuing with that
RFC series, unless we think it is better to only support fences/request API with
this redesign. Let me know and I can pick up development of that RFC.

> 
> So, I would prefer to not add more flags on those structs if there is
> another way.
> 
> As the fences out of order flags should go to ENUM_FMT (and, currently
> there's just one flag defined there), I wander if it would make sense
> to also add CAN_IN_FENCES/CAN_OUT_FENCES flags there, as maybe we
> would want to disable/enable fences based on the format.

I don't see a reason for that. There is no relationship between formats
and fences. Fences apply to buffers, not formats. Whereas the 'ordered'
value can be specific to a format.

Regards,

	Hans
