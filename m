Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:39527 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752038AbeCNQBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 12:01:46 -0400
Subject: Re: [PATCH v8 13/13] [media] v4l: Document explicit synchronization
 behavior
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180309174920.22373-1-gustavo@padovan.org>
 <20180309174920.22373-14-gustavo@padovan.org>
 <ae50fe46-4d0a-fcf4-7c95-17b5b9a0d8a7@xs4all.nl>
Message-ID: <c42c3e90-7e6e-5308-8644-44355bc569a3@xs4all.nl>
Date: Wed, 14 Mar 2018 09:01:37 -0700
MIME-Version: 1.0
In-Reply-To: <ae50fe46-4d0a-fcf4-7c95-17b5b9a0d8a7@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/13/2018 08:33 PM, Hans Verkuil wrote:
> On 03/09/2018 09:49 AM, Gustavo Padovan wrote:
>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>>
>> Add section to VIDIOC_QBUF and VIDIOC_QUERY_BUF about it
>>
>> v6:	- Close some gaps in the docs (Hans)
>>
>> v5:
>> 	- Remove V4L2_CAP_ORDERED
>> 	- Add doc about V4L2_FMT_FLAG_UNORDERED
>>
>> v4:
>> 	- Document ordering behavior for in-fences
>> 	- Document V4L2_CAP_ORDERED capability
>> 	- Remove doc about OUT_FENCE event
>> 	- Document immediate return of out-fence in QBUF
>>
>> v3:
>> 	- make the out_fence refer to the current buffer (Hans)
>> 	- Note what happens when the IN_FENCE is not set (Hans)
>>
>> v2:
>> 	- mention that fences are files (Hans)
>> 	- rework for the new API
>>
>> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>> ---
>>  Documentation/media/uapi/v4l/vidioc-qbuf.rst     | 55 +++++++++++++++++++++++-
>>  Documentation/media/uapi/v4l/vidioc-querybuf.rst | 12 ++++--
>>  2 files changed, 63 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>> index 9e448a4aa3aa..371d84966e34 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>> @@ -54,7 +54,7 @@ When the buffer is intended for output (``type`` is
>>  or ``V4L2_BUF_TYPE_VBI_OUTPUT``) applications must also initialize the
>>  ``bytesused``, ``field`` and ``timestamp`` fields, see :ref:`buffer`
>>  for details. Applications must also set ``flags`` to 0. The
>> -``reserved2`` and ``reserved`` fields must be set to 0. When using the
>> +``reserved`` field must be set to 0. When using the
>>  :ref:`multi-planar API <planar-apis>`, the ``m.planes`` field must
>>  contain a userspace pointer to a filled-in array of struct
>>  :c:type:`v4l2_plane` and the ``length`` field must be set
>> @@ -118,6 +118,59 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
>>  The struct :c:type:`v4l2_buffer` structure is specified in
>>  :ref:`buffer`.
>>  
>> +Explicit Synchronization
>> +------------------------
>> +
>> +Explicit Synchronization allows us to control the synchronization of
>> +shared buffers from userspace by passing fences to the kernel and/or
>> +receiving them from it. Fences passed to the kernel are named in-fences and
>> +the kernel should wait on them to signal before using the buffer. On the other
>> +side, the kernel can create out-fences for the buffers it queues to the
>> +drivers. Out-fences signal when the driver is finished with buffer, i.e., the
>> +buffer is ready. The fences are represented as a file and passed as a file
>> +descriptor to userspace.
>> +
>> +The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
>> +using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer flag and the `fence_fd` field. If
>> +an in-fence needs to be passed to the kernel, `fence_fd` should be set to the
>> +fence file descriptor number and the ``V4L2_BUF_FLAG_IN_FENCE`` should be set
>> +as well. Setting one but not the other will cause ``VIDIOC_QBUF`` to return
>> +with an error.
> 
> This sentence is confusing since it is not clear what 'one' and 'the other' refer
> to. Be specific here. I think it should be 'Setting V4L2_BUF_FLAG_IN_FENCE but not
> fence_fd'.

Ignore this comment.

> 
>  The fence_fd field will be ignored if the
>> +``V4L2_BUF_FLAG_IN_FENCE`` is not set.

Looking at the code, I don't think this is correct. You get an error if IN_FENCE is
not set but fence_fd is. Removing this sentence would fix this and the previous
sentence would make a lot more sense.

>> +
>> +The videobuf2-core will guarantee that all buffers queued with an in-fence will
>> +be queued to the drivers in the same order. Fences may signal out of order, so
>> +this guarantee at videobuf2 is necessary to not change ordering. So when
>> +waiting on a fence to signal all buffers queued after will be also block until
> 
> after -> afterwards
> will be also block -> will also be blocked
> 
>> +that fence signal.
> 
> signal -> signals

What is missing in the documentation is what happens when you mix in-fence buffers
and buffers without an in-fence.

Regards,

	Hans
