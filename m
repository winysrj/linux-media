Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:43608 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935828AbeE2PLu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 11:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <d72a1651f7b00c06dfcd8e8973293b93298a20ca.camel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
 <20180521165946.11778-2-ezequiel@collabora.com> <CAE6UAyx81nZDQEHuNn0BK5EkB-KmNdSnkiNF+NJTmiUkz72CrA@mail.gmail.com>
 <d72a1651f7b00c06dfcd8e8973293b93298a20ca.camel@collabora.com>
From: sathyam panda <panda.sathyam9@gmail.com>
Date: Tue, 29 May 2018 20:41:48 +0530
Message-ID: <CAE6UAyxoAss+oCM6QUeASU-uULaBq0tLBWaRpZwdqUnenyq-ig@mail.gmail.com>
Subject: Re: [PATCH v10 01/16] videobuf2: Make struct vb2_buffer refcounted
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On 5/29/18, Ezequiel Garcia <ezequiel@collabora.com> wrote:
> On Fri, 2018-05-25 at 12:11 +0530, sathyam panda wrote:
>> Hello,
>>
>> On 5/21/18, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>> > The in-fence implementation involves having a per-buffer fence
>> > callback,
>> > that triggers on the fence signal. The fence callback is called
>> > asynchronously
>> > and needs a valid reference to the associated ideobuf2 buffer.
>> >
>> > Allow this by making the vb2_buffer refcounted, so it can be passed
>> > to other contexts.
>> >
>>
>> -Is it really required, because when a queued buffer with an in_fence
>> is deallocated, firstly queue is cancelled.
>> -And __vb2_dqbuf is called which calls dma_fence_remove_callback.
>> -So if fence callback has been called -__vb2_dqbuf will wait to
>> acquire fence lock.
>> -So during execution of fence callback, buffers and queue are still
>> valid.
>> -And if __vb2_dqbuf remove callback first ,then dma_fence_signal will
>> wait for lock
>> - so there won't be any fence callback to call for that buffer when
>> dma_fence_signal resumes.
>>
>
> Hi Sathyam,
>
> Thanks for your review! The refcount is definitely required,
> as the fence callback only schedules a workqueue, which is
> completely asynchronous with respect to the rest of the
> ioctls.
>
> In particular, the workqueue is not synchronized with
> vb2_core_queue_release.
>
> Also, another subtle detail, dma_fence_remove_callback
> can fail to remove the callback.
>
> Thanks,
> Eze
>

- Sorry, I didn't pay attention to the use of workqueue, thanks for
bringing that into my notice. Now it make sense.
- I have a doubt about the queue since many driver specific structures
have queues which they release with kfree() after calling
vb2_queue_release().
- And since vb2_core_queue_release decrements the buffer refcount only
once if fence is already signalled, so buffer is still valid, but
queue isn't as the memory is deallocated.
- So is it safe to access queue in the __qbuf_work. Please correct me
if I am wrong.

Regards,
Sathyam
