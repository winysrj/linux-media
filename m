Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49026 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaFWJnp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 05:43:45 -0400
Message-ID: <53A7F6A3.20202@ti.com>
Date: Mon, 23 Jun 2014 15:12:59 +0530
From: "Devshatwar, Nikhil" <nikhil.nd@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
Subject: Re: [[PATCH]] vb2: verify data_offset only if nonzero bytesused
References: <1403434065-22994-1-git-send-email-nikhil.nd@ti.com> <53A7DD59.4060401@xs4all.nl>
In-Reply-To: <53A7DD59.4060401@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 June 2014 01:25 PM, Hans Verkuil wrote:
> On 06/22/2014 12:47 PM, Nikhil Devshatwar wrote:
>> verify_planes would fail if the user space fills up the data_offset field
>> and bytesused is left as zero. Correct this.
>>
>> Checking for data_offset > bytesused is not correct as it might fail some of
>> the valid use cases. e.g. when working with SEQ_TB buffers, for bottom field,
>> data_offset can be high but it can have less bytesused.
>>
>> The real check should be to verify that all the bytesused after data_offset
>> fit withing the length of the plane.
>>
>> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c |    9 +++------
>>   1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 7c4489c..9a0ccb6 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -587,12 +587,9 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>   			       ? b->m.planes[plane].length
>>   			       : vb->v4l2_planes[plane].length;
>>   
>> -			if (b->m.planes[plane].bytesused > length)
>> -				return -EINVAL;
>> -
>> -			if (b->m.planes[plane].data_offset > 0 &&
>> -			    b->m.planes[plane].data_offset >=
>> -			    b->m.planes[plane].bytesused)
>> +			if (b->m.planes[plane].bytesused > 0 &&
>> +			    b->m.planes[plane].data_offset +
>> +			    b->m.planes[plane].bytesused > length)
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> bytesused *includes* data_offset. So the effective payload is
> 'bytesused - data_offset' starting at offset 'data_offset' from the
> start of the buffer.
Ohh! I misinterpreted bytesused field
I Will correct the condition
> So your new condition is wrong.
>
> Regards,
>
> 	Hans
>
>>   				return -EINVAL;
>>   		}
>>   	} else {
>>

