Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1483 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaIPOCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 10:02:36 -0400
Message-ID: <541842DC.8080406@xs4all.nl>
Date: Tue, 16 Sep 2014 16:02:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [RFC PATCH] vb2: regression fix for vbi capture & poll
References: <541802B0.2020805@xs4all.nl> <20140916105053.6b8504cf.m.chehab@samsung.com>
In-Reply-To: <20140916105053.6b8504cf.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/16/14 15:50, Mauro Carvalho Chehab wrote:
> Em Tue, 16 Sep 2014 11:28:16 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> (My proposal to fix this. Note that it is untested, I plan to do that this
>> evening)
>>
>> Commit 9241650d62f7 broke vbi capture applications that expect POLLERR to be
>> returned if STREAMON wasn't called.
>>
>> Rather than checking whether buffers were queued AND vb2 was not yet streaming,
>> just check whether streaming is in progress and return POLLERR if not.
>>
>> This change makes it impossible to poll in one thread and call STREAMON in
>> another, but doing that breaks existing applications and is also not according
>> to the spec. So be it.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 7e6aff6..0452fb2 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -2583,10 +2583,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>>  	}
>>  
>>  	/*
>> -	 * There is nothing to wait for if no buffer has been queued and the
>> -	 * queue isn't streaming, or if the error flag is set.
>> +	 * There is nothing to wait for if the queue isn't streaming, or if
>> +	 * the error flag is set.
>>  	 */
>> -	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
>> +	if (!vb2_is_streaming(q) || q->error)
>>  		return res | POLLERR;
> 
> This makes the code even more different than what VB1 does. I suspect
> that this will likely cause even more regressions.
> 
> The following (untested) patch seems to be what matches best what VB1
> does, and are likely to cause less harm, but needs test of course. 
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 5b808e25fc09..0d86526cbcb0 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2586,6 +2586,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	 * There is nothing to wait for if no buffer has been queued and the
>  	 * queue isn't streaming, or if the error flag is set.
>  	 */
> +	if (!vb2_is_streaming(q))
> +		vb2_internal_streamon(q, q->type);
> +

As mentioned in my previous email, this is certainly not what vb1 does.
VB1 returns POLLERR and does not start streaming, that's what I saw when
debugging this yesterday. The automatic streaming when poll is called is
valid only if REQBUFS was never called since it assumes read() mode.

Regards,

	Hans

>  	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
>  		return res | POLLERR;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

