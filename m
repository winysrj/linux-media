Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33182 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbcFTKMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 06:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <5767BD2F.5070205@xs4all.nl>
References: <1466413304-8328-1-git-send-email-ricardo.ribalda@gmail.com> <5767BD2F.5070205@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 20 Jun 2016 12:12:09 +0200
Message-ID: <CAPybu_251cQ7xiHm4Lb71iTE+79LfgLmP6jhaKEzwgAcvv9sJQ@mail.gmail.com>
Subject: Re: [PATCH] vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dimitrios Katsaros <patcherwork@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good catch :)

I will prepare the new version. Btw, can I also merge
vb2_internal_dqbuf and vb2_dqbuf in one function? Seems a bit
overkilled that split.

Regarding v42l_compliance... I can take care of that if you dare :)

Best regards!

On Mon, Jun 20, 2016 at 11:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 06/20/2016 11:01 AM, Ricardo Ribalda Delgado wrote:
>> According to the doc, V4L2_BUF_FLAG_DONE is cleared after DQBUF:
>>
>> V4L2_BUF_FLAG_DONE 0x00000004  ... After calling the VIDIOC_QBUF or
>> VIDIOC_DQBUF it is always cleared ...
>>
>> Unfortunately, it seems that videobuf2 keeps it set after DQBUF. This
>> can be tested with vivid and dev_debug:
>>
>> [257604.338082] video1: VIDIOC_DQBUF: 71:33:25.00260479 index=3,
>> type=vid-cap, flags=0x00002004, field=none, sequence=163,
>> memory=userptr, bytesused=460800, offset/userptr=0x344b000,
>> length=460800
>>
>> This patch changes the order when fill_user_buffer() is called,
>> to follow the documentation.
>>
>> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> Sorry, this won't work. Calling __vb2_dqbuf will overwrite the state
> VB2_BUF_STATE_ERROR and so the V4L2_BUF_FLAG_ERROR flag will never be
> set. The same is true for the last 'if' in the __fill_v4l2_buffer()
> function.
>
> I think it might be better to keep this code and instead change the
> vb2_internal_dqbuf function to just clear the DONE flag after calling
> vb2_core_dqbuf.
>
> It would be nice to have a v4l2_compliance check for this as well.
>
> Regards,
>
>         Hans
>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 633fc1ab1d7a..63981f28075e 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1771,10 +1771,6 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
>>       if (pindex)
>>               *pindex = vb->index;
>>
>> -     /* Fill buffer information for the userspace */
>> -     if (pb)
>> -             call_void_bufop(q, fill_user_buffer, vb, pb);
>> -
>>       /* Remove from videobuf queue */
>>       list_del(&vb->queued_entry);
>>       q->queued_count--;
>> @@ -1784,6 +1780,10 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
>>       /* go back to dequeued state */
>>       __vb2_dqbuf(vb);
>>
>> +     /* Fill buffer information for the userspace */
>> +     if (pb)
>> +             call_void_bufop(q, fill_user_buffer, vb, pb);
>> +
>>       dprintk(1, "dqbuf of buffer %d, with state %d\n",
>>                       vb->index, vb->state);
>>
>>



-- 
Ricardo Ribalda
