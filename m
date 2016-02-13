Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:53951 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbcBMSEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:04:11 -0500
Subject: Re: [PATCH 3/4] [media] s5p-mfc: don't close instance after free
 OUTPUT buffers
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
References: <1454180017-29071-1-git-send-email-ayaka@soulik.info>
 <1454180017-29071-4-git-send-email-ayaka@soulik.info>
 <003501d15f57$8f1904b0$ad4b0e10$@samsung.com>
From: ayaka <ayaka@soulik.info>
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
	mchehab@osg.samsung.com
Message-ID: <56BF700C.8060000@soulik.info>
Date: Sun, 14 Feb 2016 02:03:56 +0800
MIME-Version: 1.0
In-Reply-To: <003501d15f57$8f1904b0$ad4b0e10$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I reviewed the code again

2016-02-04 22:23, Kamil Debski wrote:
> Hi,
>
>> From: ayaka [mailto:ayaka@soulik.info]
>> Sent: Saturday, January 30, 2016 7:54 PM
>>
>> Free buffers in OUTPUT is quite normal to detect the driver's buffer
> capacity,
>> it doesn't mean the application want to close that mfc instance.
>>
>> Signed-off-by: ayaka <ayaka@soulik.info>
>> ---
>>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> index aebe4fd..609b17b 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>> @@ -474,7 +474,6 @@ static int reqbufs_output(struct s5p_mfc_dev *dev,
>> struct s5p_mfc_ctx *ctx,
>>   		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
>>   		if (ret)
>>   			goto out;
>> -		s5p_mfc_close_mfc_inst(dev, ctx);
>>   		ctx->src_bufs_cnt = 0;
>>   		ctx->output_state = QUEUE_FREE;
>>   	} else if (ctx->output_state == QUEUE_FREE) {
> What exactly do you mean by "detecting buffer capacity"  ? Is it the max
> number of buffer
> that can be allocated?
>
> Anyway, if the instance is not closed, then in a consecutive call to reqbufs
> (with cound != 0)
> the instance will be opened for a second time. So either the instance has to
> be closed, or
Does the s5p_mfc_open_mfc_inst() open a new instance?In that case if 
reqbufs->count == 0, it won't open a new instance. Also before allocate 
buffers, it will check whether the instance has been opened.
So I think the instance won't be opened twice.
> it should be opened in another place.
>
> Best wishes,

