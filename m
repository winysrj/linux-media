Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45560 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbbHLLmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 07:42:49 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NSY00EQGWJADS40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Aug 2015 12:42:46 +0100 (BST)
Subject: Re: [PATCH 2/2] [media] m2m: fix bad unlock balance
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Zahari Doychev <zahari.doychev@linux.com>,
	linux-media@vger.kernel.org, p.zabel@pengutronix.de,
	mchehab@osg.samsung.com, Kamil Debski <kamil@wypas.org>
References: <cover.1436361987.git.zahari.doychev@linux.com>
 <ccf89324d232ddb3861bde57379d044bc587e5d5.1436361987.git.zahari.doychev@linux.com>
 <55B74514.6010601@xs4all.nl>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <55CB3135.8080706@samsung.com>
Date: Wed, 12 Aug 2015 13:42:45 +0200
MIME-version: 1.0
In-reply-to: <55B74514.6010601@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

I'm sorry for a delay. Once again I've been busy with some other 
internal stuff.

On 2015-07-28 11:02, Hans Verkuil wrote:
> Kamil, Marek,
>
> Why does v4l2_m2m_poll unlock and lock in that function?

I've checked the code and indeed the poll_wait() function doesn't do 
anything that
should not be done with queue mutex being taken. I don't remember if it 
was always
like that. You are right that the unlock&lock code should be removed.

> Zahari is right that the locking is unbalanced, but I don't see the reason
> for the unlock/lock sequence in the first place. I'm wondering if that
> shouldn't just be removed.
>
> Am I missing something?
>
> Instead, I would expect to see a spin_lock_irqsave(&src/dst_q->done_lock, flags)
> around the list_empty(&src/dst_q->done_list) calls.

Indeed, that's another thing that should be fixed in this function. I 
looks that
commit c16218402a000bb25c1277c43ae98c11bcb59bd1 ("[media] videobuf2: 
return -EPIPE
from DQBUF after the last buffer") is the root cause of both issues 
(unballanced
locking and lack of spinlock protection), while the unnecessary queue 
unlock/lock
sequence was there from the beginning.

> Regards,
>
> 	Hans
>
> On 07/08/2015 03:37 PM, Zahari Doychev wrote:
>> This commit fixes bad unlock balance when polling. v4l2_m2m_poll is called
>> with mutex hold but the function releases the mutex and returns.
>> This leads to the bad unlock because after the  call of v4l2_m2m_poll in
>> v4l2_m2m_fop_poll the mutex is again unlocked. This patch makes sure that
>> the v4l2_m2m_poll returns always with balanced locks.
>>
>> [  144.990873] =====================================
>> [  144.995584] [ BUG: bad unlock balance detected! ]
>> [  145.000301] 4.1.0-00137-ga105070 #98 Tainted: G        W
>> [  145.006140] -------------------------------------
>> [  145.010851] demux:sink/487 is trying to release lock (&dev->dev_mutex) at:
>> [  145.017785] [<808cc578>] mutex_unlock+0x18/0x1c
>> [  145.022322] but there are no more locks to release!
>> [  145.027205]
>> [  145.027205] other info that might help us debug this:
>> [  145.033741] no locks held by demux:sink/487.
>> [  145.038015]
>> [  145.038015] stack backtrace:
>> [  145.042385] CPU: 2 PID: 487 Comm: demux:sink Tainted: G        W       4.1.0-00137-ga105070 #98
>> [  145.051089] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>> [  145.057622] Backtrace:
>> [  145.060102] [<80014a4c>] (dump_backtrace) from [<80014cc4>] (show_stack+0x20/0x24)
>> [  145.067679]  r6:80cedf78 r5:00000000 r4:00000000 r3:00000000
>> [  145.073421] [<80014ca4>] (show_stack) from [<808c61e0>] (dump_stack+0x8c/0xa4)
>> [  145.080661] [<808c6154>] (dump_stack) from [<80072b64>] (print_unlock_imbalance_bug+0xb8/0xe8)
>> [  145.089277]  r6:808cc578 r5:ac6cd050 r4:ac38e400 r3:00000001
>> [  145.095020] [<80072aac>] (print_unlock_imbalance_bug) from [<80077db4>] (lock_release+0x1a4/0x250)
>> [  145.103983]  r6:808cc578 r5:ac6cd050 r4:ac38e400 r3:00000000
>> [  145.109728] [<80077c10>] (lock_release) from [<808cc470>] (__mutex_unlock_slowpath+0xc4/0x1b4)
>> [  145.118344]  r9:acb27a41 r8:00000000 r7:81553814 r6:808cc578 r5:60030013 r4:ac6cd01c
>> [  145.126190] [<808cc3ac>] (__mutex_unlock_slowpath) from [<808cc578>] (mutex_unlock+0x18/0x1c)
>> [  145.134720]  r7:00000000 r6:aced7cd4 r5:00000041 r4:acb87800
>> [  145.140468] [<808cc560>] (mutex_unlock) from [<805a98b8>] (v4l2_m2m_fop_poll+0x5c/0x64)
>> [  145.148494] [<805a985c>] (v4l2_m2m_fop_poll) from [<805955a0>] (v4l2_poll+0x6c/0xa0)
>> [  145.156243]  r6:aced7bec r5:00000000 r4:ac6cc380 r3:805a985c
>> [  145.161991] [<80595534>] (v4l2_poll) from [<80156edc>] (do_sys_poll+0x230/0x4c0)
>> [  145.169391]  r5:00000000 r4:aced7be4
>> [  145.173013] [<80156cac>] (do_sys_poll) from [<801574a8>] (SyS_ppoll+0x1d4/0x1fc)
>> [  145.180414]  r10:00000000 r9:aced6000 r8:00000000 r7:00000000 r6:75c04538 r5:00000002
>> [  145.188338]  r4:00000000
>> [  145.190906] [<801572d4>] (SyS_ppoll) from [<800108c0>] (ret_fast_syscall+0x0/0x54)
>> [  145.198481]  r8:80010aa4 r7:00000150 r6:75c04538 r5:00000002 r4:00000008
>>
>> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
>> ---
>>   drivers/media/v4l2-core/v4l2-mem2mem.c | 19 ++++++++++---------
>>   1 file changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> index dc853e5..5392fb4 100644
>> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
>> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
>> @@ -583,16 +583,8 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>>   
>>   	if (list_empty(&src_q->done_list))
>>   		poll_wait(file, &src_q->done_wq, wait);
>> -	if (list_empty(&dst_q->done_list)) {
>> -		/*
>> -		 * If the last buffer was dequeued from the capture queue,
>> -		 * return immediately. DQBUF will return -EPIPE.
>> -		 */
>> -		if (dst_q->last_buffer_dequeued)
>> -			return rc | POLLIN | POLLRDNORM;
>> -
>> +	if (list_empty(&dst_q->done_list) && !dst_q->last_buffer_dequeued)
>>   		poll_wait(file, &dst_q->done_wq, wait);
>> -	}
>>   
>>   	if (m2m_ctx->m2m_dev->m2m_ops->lock)
>>   		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
>> @@ -603,6 +595,15 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>>   		}
>>   	}
>>   
>> +	if (list_empty(&dst_q->done_list) && dst_q->last_buffer_dequeued) {
>> +		/*
>> +		 * If the last buffer was dequeued from the capture queue,
>> +		 * return immediately. DQBUF will return -EPIPE.
>> +		 */
>> +		rc |= POLLIN | POLLRDNORM;
>> +		goto end;
>> +	}
>> +
>>   	spin_lock_irqsave(&src_q->done_lock, flags);
>>   	if (!list_empty(&src_q->done_list))
>>   		src_vb = list_first_entry(&src_q->done_list, struct vb2_buffer,
>>
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

