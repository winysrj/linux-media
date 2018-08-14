Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:45723 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729536AbeHNMh7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 08:37:59 -0400
Subject: Re: [PATCHv17 01/34] Documentation: v4l: document request API
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-2-hverkuil@xs4all.nl>
 <20180809144300.6ea1d040@coco.lan>
 <18b31024-2cf0-58b3-4df5-fcb89b77e50f@xs4all.nl>
 <20180814054833.69d4cc41@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b1906596-7500-4ff4-7eff-f4ec4866688b@xs4all.nl>
Date: Tue, 14 Aug 2018 11:51:30 +0200
MIME-Version: 1.0
In-Reply-To: <20180814054833.69d4cc41@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/08/18 10:48, Mauro Carvalho Chehab wrote:
> Em Tue, 14 Aug 2018 09:57:27 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 09/08/18 19:43, Mauro Carvalho Chehab wrote:
>>>> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>>>> index 9e448a4aa3aa..0e415f2551b2 100644
>>>> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>>>> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
>>>> @@ -65,7 +65,7 @@ To enqueue a :ref:`memory mapped <mmap>` buffer applications set the
>>>>  with a pointer to this structure the driver sets the
>>>>  ``V4L2_BUF_FLAG_MAPPED`` and ``V4L2_BUF_FLAG_QUEUED`` flags and clears
>>>>  the ``V4L2_BUF_FLAG_DONE`` flag in the ``flags`` field, or it returns an
>>>> -EINVAL error code.
>>>> +``EINVAL`` error code.  
>>>
>>> Side note: we should likely do a similar replacement on all other places
>>> inside the media uAPI docs.
>>>   
>>>>  
>>>>  To enqueue a :ref:`user pointer <userp>` buffer applications set the
>>>>  ``memory`` field to ``V4L2_MEMORY_USERPTR``, the ``m.userptr`` field to
>>>> @@ -98,6 +98,25 @@ dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
>>>>  :ref:`VIDIOC_REQBUFS` ioctl is called, or until the
>>>>  device is closed.
>>>>  
>>>> +The ``request_fd`` field can be used with the ``VIDIOC_QBUF`` ioctl to specify  
>>>
>>> Please prefer using :ref: for QBUF too, e. g.: 
>>> 	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>`  
>>
>> Does this make sense when you are in the QBUF documentation itself? Using :ref: will
>> just link back to the same page.
>>
>> We need some guidelines here. I personally don't think this makes sense.
> 
> I'm almost sure we're doing the same on every other place within media docs.

Not in vidioc-qbuf.rst: there you never use :ref: to refer to a QBUF/DQBUF.
I want to keep this as-is. If we really want to change this, then it should
be done for all vidioc-*.rst files.

A quick grep shows that this is very common:

git grep '``VIDIOC_' Documentation/media/uapi/v4l/vidioc-*

I honestly think it is silly and even confusing to use a :ref: to the page
you are already on.

I keep this as-is since this is consistent with the usage elsewhere in vidioc-qbuuf.rst.
If we want to change this, then that's something we should do separately from this
patch.

Regards,

	Hans

> 
>>
>> Regards,
>>
>> 	Hans
> 
> 
> 
> Thanks,
> Mauro
> 
