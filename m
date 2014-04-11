Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1279 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbaDKI7d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:59:33 -0400
Message-ID: <5347AEC5.6050700@xs4all.nl>
Date: Fri, 11 Apr 2014 10:58:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>, linux-media@vger.kernel.org
CC: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 07/13] vb2: reject output buffers with V4L2_FIELD_ALTERNATE
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl> <1397203879-37443-8-git-send-email-hverkuil@xs4all.nl> <5347AAF5.30704@ti.com>
In-Reply-To: <5347AAF5.30704@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/2014 10:42 AM, Archit Taneja wrote:
> On Friday 11 April 2014 01:41 PM, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This is not allowed by the spec and does in fact not make any sense.
>> Return -EINVAL if this is the case.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Pawel Osciak <pawel@osciak.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 6e05495..f8c0247 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1511,6 +1511,19 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>   		dprintk(1, "plane parameters verification failed: %d\n", ret);
>>   		return ret;
>>   	}
>> +	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
>> +		/*
>> +		 * If the format's field is ALTERNATE, then the buffer's field
>> +		 * should be either TOP or BOTTOM, not ALTERNATE since that
>> +		 * makes no sense. The driver has to know whether the
>> +		 * buffer represents a top or a bottom field in order to
>> +		 * program any DMA correctly. Using ALTERNATE is wrong, since
>> +		 * that just says that it is either a top or a bottom field,
>> +		 * but not which of the two it is.
>> +		 */
>> +		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
>> +		return -EINVAL;
>> +	}
> 
> If vb2_queue had a field parameter, which tells the format's field type. 
> We could have returned an error if the field format was ALTERNATE, and 
> the buffer field was not TOP or BOTTOM.
> 
> I don't know whether having a field parameter in vb2_queue is a good 
> idea or not.

The predecessor of vb2, videobuf, had that actually.

I am not sure myself if it is a good idea or not to do the same for vb2.
For now I think we should leave it as is. There are very few drivers that
support FIELD_ALTERNATE although this should become more common for
drivers supporting interlaced HDTV formats. When we see more drivers that
support this, then we can see if it makes sense to move part of the handling
to vb2.

Regards,

	Hans
