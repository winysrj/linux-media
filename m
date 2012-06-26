Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33097 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2FZUod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 16:44:33 -0400
Received: by gglu4 with SMTP id u4so360411ggl.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 13:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE9758C.7030008@samsung.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
	<1339681069-8483-4-git-send-email-t.stanislaws@samsung.com>
	<20120620061216.GA19245@google.com>
	<4FE9758C.7030008@samsung.com>
Date: Tue, 26 Jun 2012 13:44:32 -0700
Message-ID: <CAPz4a6Dzn+Y71QPc_YKxwp7OQvF0saScgQZsLEmVr9PCRc8F3A@mail.gmail.com>
Subject: Re: [PATCHv7 03/15] v4l: vb2: add support for shared buffer (dma_buf)
From: Dima Zavin <dima@android.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 1:40 AM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> Hi Dima Zavin,
> Thank you for the patch and for a ping remainder :).
>
> You are right. The unmap is missing in __vb2_queue_cancel.
> I will apply your fix into next version of V4L2 support for dmabuf.
>
> Please refer to some comments below.
>
> On 06/20/2012 08:12 AM, Dima Zavin wrote:
>> Tomasz,
>>
>> I've encountered an issue with this patch when userspace does several
>> stream_on/stream_off cycles. When the user tries to qbuf a buffer
>> after doing stream_off, we trigger the "dmabuf already pinned" warning
>> since we didn't unmap the buffer as dqbuf was never called.
>>
>> The below patch adds calls to unmap in queue_cancel, but my feeling is that we
>> probably should be calling detach too (i.e. put_dmabuf).
>>
>> Thoughts?
>>
>> --Dima
>>
>> Subject: [PATCH] v4l: vb2: unmap dmabufs on STREAM_OFF event
>>
>> Currently, if the user issues a STREAM_OFF request and then
>> tries to re-enqueue buffers, it will trigger a warning in
>> the vb2 allocators as the buffer would still be mapped
>> from before STREAM_OFF was called. The current expectation
>> is that buffers will be unmapped in dqbuf, but that will never
>> be called on the mapped buffers after a STREAM_OFF event.
>>
>> Cc: Sumit Semwal <sumit.semwal@ti.com>
>> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Dima Zavin <dima@android.com>
>> ---
>>  drivers/media/video/videobuf2-core.c |   22 ++++++++++++++++++++--
>>  1 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
>> index b431dc6..e2a8f12 100644
>> --- a/drivers/media/video/videobuf2-core.c
>> +++ b/drivers/media/video/videobuf2-core.c
>> @@ -1592,8 +1592,26 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>       /*
>>        * Reinitialize all buffers for next use.
>>        */
>> -     for (i = 0; i < q->num_buffers; ++i)
>> -             q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
>> +     for (i = 0; i < q->num_buffers; ++i) {
>> +             struct vb2_buffer *vb = q->bufs[i];
>> +             int plane;
>> +
>> +             vb->state = VB2_BUF_STATE_DEQUEUED;
>> +
>> +             if (q->memory != V4L2_MEMORY_DMABUF)
>> +                     continue;
>> +
>> +             for (plane = 0; plane < vb->num_planes; ++plane) {
>> +                     struct vb2_plane *p = &vb->planes[plane];
>> +
>> +                     if (!p->mem_priv)
>> +                             continue;
>
> is the check above really needed? No check like this is done in
> vb2_dqbuf.

I added it because queue_cancel gets called in release, so you never
know what the state of the buffers will be. If we called req_bufs to
allocate the buffer descriptors and then call release, then won't we
have the vb2_buffer structs but nothing in mem_priv since we haven't
attached a dmabuf yet?

>
>> +                     if (p->dbuf_mapped) {
>
> If a buffer is queued then it is also mapped, so dbuf_mapped
> should be always be true here (at least in theory).

This loop doesn't check for what the buffer status was, it just
iterates over the entire queue. The buffer may have been put into
STATE_ERROR, and then you don't know if it was ever mapped, etc. It
should always be safe to just follow the flag that says you mapped it
and unmap it. If you think that this should always be true, we can
change it to:

    if (!WARN_ON(!p->dbuf_mapped))

or something like that.

Thanks!

--Dima

>
>> +                             call_memop(q, unmap_dmabuf, p->mem_priv);
>> +                             p->dbuf_mapped = 0;
>> +                     }
>> +             }
>> +     }
>>  }
>>
>>  /**
>
> Regards,
> Tomasz Stanislawski
