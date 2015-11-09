Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48832 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbKIHsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 02:48:03 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NXJ01FZJF01U0B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Nov 2015 16:48:01 +0900 (KST)
Message-id: <56404FB1.6050401@samsung.com>
Date: Mon, 09 Nov 2015 16:48:01 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v9 4/6] media: videobuf2: last_buffer_queued is set at
 fill_v4l2_buffer()
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
 <1446545802-28496-5-git-send-email-jh1009.sung@samsung.com>
 <563B28A0.8080202@xs4all.nl>
In-reply-to: <563B28A0.8080202@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/05/2015 07:00 PM, Hans Verkuil wrote:
> On 11/03/15 11:16, Junghak Sung wrote:
>> The location in which last_buffer_queued is set is moved to fill_v4l2_buffer().
>> So, __vb2_perform_fileio() can use vb2_core_dqbuf() instead of
>> vb2_internal_dqbuf().
>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> One comment: I think the struct vb2_buf_ops callbacks can all return void
> instead of int. I don't think they should ever be allowed to fail.
>
> If you agree, then that can be changed in a separate later.
>
Dear Hans,

IMHO, it seems to be better that vb2_buf_ops callbacks return int
as it is. Because fill_vb2_buffer() includes verifying the bytesused
value for each plane and checking ALTERNATE field for output buffer.
It can return fail if the information provided in a v4l2_buffer
by the userspace is not proper.

Best regards,
Junghak

> Regards,
>
> 	Hans
>
>> ---
>>   drivers/media/v4l2-core/videobuf2-v4l2.c |    9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> index 0ca9f23..b0293df 100644
>> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
>> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> @@ -270,6 +270,11 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>>   	if (vb2_buffer_in_use(q, vb))
>>   		b->flags |= V4L2_BUF_FLAG_MAPPED;
>>
>> +	if (!q->is_output &&
>> +		b->flags & V4L2_BUF_FLAG_DONE &&
>> +		b->flags & V4L2_BUF_FLAG_LAST)
>> +		q->last_buffer_dequeued = true;
>> +
>>   	return 0;
>>   }
>>
>> @@ -579,10 +584,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
>>
>>   	ret = vb2_core_dqbuf(q, b, nonblocking);
>>
>> -	if (!ret && !q->is_output &&
>> -			b->flags & V4L2_BUF_FLAG_LAST)
>> -		q->last_buffer_dequeued = true;
>> -
>>   	return ret;
>>   }
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
