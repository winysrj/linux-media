Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33768 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdDCUse (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 16:48:34 -0400
MIME-Version: 1.0
In-Reply-To: <bafe3f9d-cdf4-bb22-b9c8-fe3f677d289c@osg.samsung.com>
References: <20170313192035.29859-1-gustavo@padovan.org> <20170403081610.16a2a3fc@vento.lan>
 <bafe3f9d-cdf4-bb22-b9c8-fe3f677d289c@osg.samsung.com>
From: Shuah Khan <shuahkhan@gmail.com>
Date: Mon, 3 Apr 2017 14:48:32 -0600
Message-ID: <CAKocOOPAvkDpNXiFqsr=jxOvq2589piRV+HTMOoSy8gmZ-M67Q@mail.gmail.com>
Subject: Re: [RFC 00/10] V4L2 explicit synchronization support
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On Mon, Apr 3, 2017 at 1:46 PM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> Hello Mauro and Gustavo,
>
> On 04/03/2017 07:16 AM, Mauro Carvalho Chehab wrote:
>> Hi Gustavo,
>>
>> Em Mon, 13 Mar 2017 16:20:25 -0300
>> Gustavo Padovan <gustavo@padovan.org> escreveu:
>>
>>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>>>
>>> Hi,
>>>
>>> This RFC adds support for Explicit Synchronization of shared buffers in V4L2.
>>> It uses the Sync File Framework[1] as vector to communicate the fences
>>> between kernel and userspace.
>>
>> Thanks for your work!
>>
>> I looked on your patchset, and I didn't notice anything really weird
>> there. So, instead on reviewing patch per patch, I prefer to discuss
>> about the requirements and API, as depending on it, the code base will
>> change a lot.
>>
>
> Agree that's better to first set on an uAPI and then implement based on that.

Yes. Agreeing on uAPI first would work well.

>
>> I'd like to do some tests with it on devices with mem2mem drivers.
>> My plan is to use an Exynos board for such thing, but I guess that
>> the DRM driver for it currently doesn't. I'm seeing internally if someone
>> could be sure that Exynos driver upstream will become ready for such
>> tests.
>>
>
> Not sure if you should try to do testing before agreeing on an uAPI and
> implementation.

Running some tests might give you a better feel for m2m - export buf - drm
cases without fences on exynos. This could help understand the performance
gains with fences.

>
>> Javier wrote some patches last year meant to implement implicit
>> fences support. What we noticed is that, while his mechanism worked
>> fine for pure capture and pure output devices, when we added a mem2mem
>> device, on a DMABUF+fences pipeline, e. g.:
>>
>>       sensor -> [m2m] -> DRM
>>
>> End everything using fences/DMABUF, the fences mechanism caused dead
>> locks on existing userspace apps.
>>
>> A m2m device has both capture and output devnodes. Both should be
>> queued/dequeued. The capture queue is synchronized internally at the
>> driver with the output buffer[1].
>>
>> [1] The names here are counter-intuitive: "capture" is a devnode
>> where userspace receives a video stream; "output" is a devnode where
>> userspace feeds a video stream.
>>
>> The problem is that adding implicit fences changed the behavior of
>> the ioctls, causing gstreamer to wait forever for buffers to be ready.
>>
>
> The problem was related to trying to make user-space unaware of the implicit
> fences support, and so it tried to QBUF a buffer that had already a pending
> fence. A workaround was to block the second QBUF ioctl if the buffer had a
> pending fence, but this caused the mentioned deadlock since GStreamer wasn't
> expecting the QBUF ioctl to block.
>
>> I suspect that, even with explicit fences, the behavior of Q/DQ
>> will be incompatible with the current behavior (or will require some
>> dirty hacks to make it identical).

One big difference between implicit and explicit is that use-space is aware
of fences in the case of explicit. Can that knowledge be helpful in avoiding
the the problems we have seen with explicit?

>>
>> So, IMHO, the best would be to use a new set of ioctls, when fences are
>> used (like VIDIOC_QFENCE/DQFENCE).
>>
>
> For explicit you can check if there's an input-fence so is different than
> implicit, but still I agree that it would be better to have specific ioctls.
>

It would be nice if we can avoid adding more ioctls. As I mentioned earlier,
user-space is aware that fences are in use. Can we key off of that and make
it a queue property to be used to change the user-space action for fence vs.
no fence case?

<snip.>

thanks,
-- Shuah
