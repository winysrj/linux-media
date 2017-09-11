Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:58388 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751515AbdIKNfF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:35:05 -0400
Subject: Re: [PATCH v3 01/15] [media] v4l: Document explicit synchronization
 behaviour
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20170907184226.27482-1-gustavo@padovan.org>
 <20170907184226.27482-2-gustavo@padovan.org>
 <22b8926c-4a44-0f22-0717-c36d64003272@xs4all.nl>
 <6bb8df91-4cd2-2ca5-dc4b-aea5ea14e7b1@xs4all.nl> <20170911131846.GA7552@jade>
 <33e4711c-87dc-de98-a9da-33470f5ee083@xs4all.nl> <20170911133405.GB7552@jade>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5301d746-07be-7d06-6046-b3438a95e539@xs4all.nl>
Date: Mon, 11 Sep 2017 15:35:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170911133405.GB7552@jade>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 03:34 PM, Gustavo Padovan wrote:
> 2017-09-11 Hans Verkuil <hverkuil@xs4all.nl>:
> 
>> On 09/11/2017 03:18 PM, Gustavo Padovan wrote:
>>> 2017-09-11 Hans Verkuil <hverkuil@xs4all.nl>:
>>>
>>>> On 09/11/2017 12:50 PM, Hans Verkuil wrote:
>>>>> On 09/07/2017 08:42 PM, Gustavo Padovan wrote:
>>>>>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>>>>>>
>>>>>> Add section to VIDIOC_QBUF about it
>>>>>>
>>>>>> v2:
>>>>>> 	- mention that fences are files (Hans)
>>>>>> 	- rework for the new API
>>>>>>
>>>>>> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>>>>>> ---
>>>>>>  Documentation/media/uapi/v4l/vidioc-qbuf.rst | 31 ++++++++++++++++++++++++++++
>>>>>>  1 file changed, 31 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>>>>>> index 1f3612637200..fae0b1431672 100644
>>>>>> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>>>>>> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>>>>>> @@ -117,6 +117,37 @@ immediately with an ``EAGAIN`` error code when no buffer is available.
>>>>>>  The struct :c:type:`v4l2_buffer` structure is specified in
>>>>>>  :ref:`buffer`.
>>>>>>  
>>>>>> +Explicit Synchronization
>>>>>> +------------------------
>>>>>> +
>>>>>> +Explicit Synchronization allows us to control the synchronization of
>>>>>> +shared buffers from userspace by passing fences to the kernel and/or
>>>>>> +receiving them from it. Fences passed to the kernel are named in-fences and
>>>>>> +the kernel should wait them to signal before using the buffer, i.e., queueing
>>>>>
>>>>> wait them -> wait on them
>>>>>
>>>>> (do you wait 'on' a fence or 'for' a fence? I think it's 'on' but I'm not 100% sure)
>>>>>
>>>>>> +it to the driver. On the other side, the kernel can create out-fences for the
>>>>>> +buffers it queues to the drivers, out-fences signal when the driver is
>>>>>
>>>>> Start a new sentence here: ...drivers. Out-fences...
>>>>>
>>>>>> +finished with buffer, that is the buffer is ready. The fence are represented
>>>>>
>>>>> s/that is/i.e/
>>>>>
>>>>> s/The fence/The fences/
>>>>>
>>>>>> +by file and passed as file descriptor to userspace.
>>>>>
>>>>> s/by file/as a file/
>>>>> s/as file/as a file/
>>>>>
>>>>>> +
>>>>>> +The in-fences are communicated to the kernel at the ``VIDIOC_QBUF`` ioctl
>>>>>> +using the ``V4L2_BUF_FLAG_IN_FENCE`` buffer
>>>>>> +flags and the `fence_fd` field. If an in-fence needs to be passed to the kernel,
>>>>>> +`fence_fd` should be set to the fence file descriptor number and the
>>>>>> +``V4L2_BUF_FLAG_IN_FENCE`` should be set as well. Failure to set both will
>>>>>
>>>>> s/Failure to set both/Setting one but not the other/
>>>>>
>>>>>> +cause ``VIDIOC_QBUF`` to return with error.
>>>>>> +
>>>>>> +To get a out-fence back from V4L2 the ``V4L2_BUF_FLAG_OUT_FENCE`` flag should
>>>>>> +be set to notify it that the next queued buffer should have a fence attached to
>>>>>> +it. That means the out-fence may not be associated with the buffer in the
>>>>>> +current ``VIDIOC_QBUF`` ioctl call because the ordering in which videobuf2 core
>>>>>> +queues the buffers to the drivers can't be guaranteed. To become aware of the
>>>>>> +of the next queued buffer and the out-fence attached to it the
>>>>>> +``V4L2_EVENT_BUF_QUEUED`` event should be used. It will trigger an event
>>>>>> +for every buffer queued to the V4L2 driver.
>>>>>
>>>>> This makes no sense.
>>>>>
>>>>> Setting this flag means IMHO that when *this* buffer is queued up to the driver,
>>>>> then it should send the BUF_QUEUED event with an out fence.
>>>>>
>>>>> I.e. it signals that userspace wants to have the out-fence. The requirement w.r.t.
>>>>> ordering is that the BUF_QUEUED events have to be in order, but that is something
>>>>> that the driver can ensure in the case it is doing internal re-ordering.
>>>>>
>>>>> This requirement is something that needs to be documented here, BTW.
>>>>>
>>>>> Anyway, the flag shouldn't refer to some 'next buffer', since that's very confusing.
>>>>
>>>> Just ignore this comment. I assume v4 will implement it like this.
>>>
>>> What approach do you mean by "like this". I'm confused now. :)
>>>
>>> In fact, I was in doubt between these two different approaches here.
>>> Should the flag mean *this* or the *next* buffer? The buffers can still
>>> be reordered at the videobuf2 level, because they might be waiting on
>>> in-fences and the fences may signal out of order. Then I went for the
>>> *next* buffer approach because we don't know that buffer for sure.
>>> But now thinking on this again we shouldn't have problems with the 
>>> *this* buffer approach also.
>>
>> It should mean *this* buffer. It's really weird to set this flag for one
>> buffer, only for it to mean 'next' buffer.
>>
>> Keep it simple: the flag just means: send me the output fence fd for this
>> buffer once you have it. If it is not set, then no BUF_QUEUE event is sent.
>>
>> Actually, it could mean one of two things: either if it is not set, then no
>> BUF_QUEUE event is sent, or if it is not set, then the fd in the BUF_QUEUE
>> event is -1.
>>
>> I'm leaning towards the first. I can't see any use-case for sending that
>> event if you are not requesting out fences.
> 
> We could go with the first one but in this case it is better to rename it to
> V4L2_EVENT_OUT_FENCE or something like this, isn't it?

I was thinking the same thing. That would be a better name, yes.

Regards,

	Hans
