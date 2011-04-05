Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37275 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1DEPmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 11:42:52 -0400
Received: by vws1 with SMTP id 1so362632vws.19
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 08:42:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <006401cbf28c$02105880$06310980$%szyprowski@samsung.com>
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
 <1301874670-14833-2-git-send-email-pawel@osciak.com> <006401cbf28c$02105880$06310980$%szyprowski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 5 Apr 2011 08:42:31 -0700
Message-ID: <BANLkTi=vESG-0bbyxT_3KdH+5AN9e0VKMQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] [media] vb2: redesign the stop_streaming() callback
 and make it obligatory
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	g.liakhovetski@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Apr 3, 2011 at 22:49, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Monday, April 04, 2011 1:51 AM Pawel Osciak wrote:
>
>> Drivers are now required to implement the stop_streaming() callback
>> to ensure that all ongoing hardware operations are finished and their
>> ownership of buffers is ceded.
>> Drivers do not have to call vb2_buffer_done() for each buffer they own
>> anymore.
>> Also remove the return value from the callback.
>>
>> Signed-off-by: Pawel Osciak <pawel@osciak.com>
>> ---
>>  drivers/media/video/videobuf2-core.c |   16 ++++++++++++++--
>>  include/media/videobuf2-core.h       |   16 +++++++---------
>>  2 files changed, 21 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
>> index 6e69584..59d5e8b 100644
>> --- a/drivers/media/video/videobuf2-core.c
>> +++ b/drivers/media/video/videobuf2-core.c
>> @@ -640,6 +640,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>>       struct vb2_queue *q = vb->vb2_queue;
>>       unsigned long flags;
>>
>> +     if (atomic_read(&q->queued_count) == 0)
>> +             return;
>> +
>>       if (vb->state != VB2_BUF_STATE_ACTIVE)
>>               return;
>>
>> @@ -1178,12 +1181,20 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>       unsigned int i;
>>
>>       /*
>> -      * Tell driver to stop all transactions and release all queued
>> +      * Tell the driver to stop all transactions and release all queued
>>        * buffers.
>>        */
>>       if (q->streaming)
>>               call_qop(q, stop_streaming, q);
>> +
>> +     /*
>> +      * All buffers should now not be in use by the driver anymore, but we
>> +      * have to manually set queued_count to 0, as the driver was not
>> +      * required to call vb2_buffer_done() from stop_streaming() for all
>> +      * buffers it had queued.
>> +      */
>>       q->streaming = 0;
>> +     atomic_set(&q->queued_count, 0);
>
> If you removed the need to call vb2_buffer_done() then you must also call
> wake_up_all(&q->done_wq) to wake any other threads/processes that might be
> sleeping waiting for buffers.

True, setting queued_count to 0 is not enough. Hm, I'm wondering why
tests on vivi and qv4l2 didn't catch this, it uses poll as well...

-- 
Best regards,
Pawel Osciak
