Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42343 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031616AbbKEDML (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 22:12:11 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NXB01ZUMNK9WY10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Nov 2015 12:12:09 +0900 (KST)
Message-id: <563AC908.9070708@samsung.com>
Date: Thu, 05 Nov 2015 12:12:08 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v9 1/6] media: videobuf2: Move timestamp to vb2_buffer
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
 <1446545802-28496-2-git-send-email-jh1009.sung@samsung.com>
 <5639F9EA.7080400@xs4all.nl>
In-reply-to: <5639F9EA.7080400@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Dear Hans,

First of all, thank you for your review.

On 11/04/2015 09:28 PM, Hans Verkuil wrote:
> On 11/03/15 11:16, Junghak Sung wrote:
>> Move timestamp from struct vb2_v4l2_buffer to struct vb2_buffer
>> for common use, and change its type to u64 in order to handling
>> y2038 problem. This patch also includes all device drivers' changes related to
>> this restructuring.
>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> ---
>
> <snip>
>
>> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
>> index 1bd2fd4..61df3e4 100644
>> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
>> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
>> @@ -531,8 +531,8 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
>>
>>   	if (!ret) {
>>   		vbuf->sequence = solo_enc->sequence++;
>> -		vbuf->timestamp.tv_sec = vop_sec(vh);
>> -		vbuf->timestamp.tv_usec = vop_usec(vh);
>> +		vb->timestamp = ((u64) vop_sec(vh) * NSEC_PER_SEC) +
>> +				(vop_usec(vh) * NSEC_PER_USEC);
>
> This is wrong. Just use ktime_get_ns() here. It is probably best to first make a
> single patch to change the solo driver to use v4l2_get_timestamp(), then convert
> that to ktime_get_ns() in this patch.
>
> The problem is that the timestamp is taken from the mpeg header, and so it is
> not a CLOCK_MONOTONIC timestamp as is signaled to the user. Never noticed this
> before, but it is a solo driver bug.
>
OK, I will prepare a single patch for solo driver to use
v4l2_get_timestamp(), and then converting to ktime_get_ns()
will be included in next version - v10.
I'm not aware of this historical problem.
so, it's very helpful. Thank you, Hans.


>>
>>   		/* Check for motion flags */
>>   		if (solo_is_motion_on(solo_enc) && enc_buf->motion) {
>> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
>> index 26df903..44b00b8 100644
>> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
>> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
>> @@ -225,7 +225,7 @@ finish_buf:
>>   		vb2_set_plane_payload(vb, 0,
>>   			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
>>   		vbuf->sequence = solo_dev->sequence++;
>> -		v4l2_get_timestamp(&vbuf->timestamp);
>> +		vb->timestamp = ktime_get_ns();
>>   	}
>>
>>   	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>
> <snip>
>
>> diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
>> index 83cc6d3..b0ad054 100644
>> --- a/drivers/media/platform/vivid/vivid-kthread-cap.c
>> +++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
>> @@ -441,7 +441,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>>   	 * "Start of Exposure".
>>   	 */
>>   	if (dev->tstamp_src_is_soe)
>> -		v4l2_get_timestamp(&buf->vb.timestamp);
>> +		buf->vb.vb2_buf.timestamp = ktime_get_ns();
>>   	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
>>   		/*
>>   		 * 60 Hz standards start with the bottom field, 50 Hz standards
>> @@ -558,8 +558,9 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>>   	 * the timestamp now.
>>   	 */
>>   	if (!dev->tstamp_src_is_soe)
>> -		v4l2_get_timestamp(&buf->vb.timestamp);
>> -	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
>> +		buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +	buf->vb.vb2_buf.timestamp +=
>> +			((u64) dev->time_wrap_offset * NSEC_PER_SEC);
>
> I'd do this differently: make time_wrap_offset of type u64 and assign it
> accordingly with nanoseconds. That way you can just do:
>
> 	timestamp += dev->time_wrap_offset
>
> vivid-ctrls.c also needs to be modified (vivid_streaming_s_ctrl(), VIVID_CID_TIME_WRAP
> case) to:
>
> 	dev->time_wrap_offset = (0x100000000ULL - 16) * NSEC_PER_SEC - ktime_get_ns();
>
> The v4l2_get_timestamp() call there can be dropped.
>

I agree with your opinion. But it is too hard to read the code
getting time_wrap_offset.
How about this way?

  in vivid_streaming_s_ctrl() of vivid-ctrls.c
         dev->time_wrap_offset = ktime_get_ns() + 16 * NSEC_PER_SEC;
  and in vivid_fillbuff() of vivid-kthread-cap.c
	buf->vb.vb2_buf.timestamp -= dev->time_wrap_offset;


>>   }
>>
>>   /*
>> diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
>> index c2c46dc..6fd02c9 100644
>> --- a/drivers/media/platform/vivid/vivid-kthread-out.c
>> +++ b/drivers/media/platform/vivid/vivid-kthread-out.c
>> @@ -95,8 +95,9 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
>>   			 */
>>   			vid_out_buf->vb.sequence /= 2;
>>   		}
>> -		v4l2_get_timestamp(&vid_out_buf->vb.timestamp);
>> -		vid_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
>> +		vid_out_buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +		vid_out_buf->vb.vb2_buf.timestamp +=
>> +				((u64) dev->time_wrap_offset * NSEC_PER_SEC);
>>   		vb2_buffer_done(&vid_out_buf->vb.vb2_buf, dev->dqbuf_error ?
>>   				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>>   		dprintk(dev, 2, "vid_out buffer %d done\n",
>> @@ -108,8 +109,9 @@ static void vivid_thread_vid_out_tick(struct vivid_dev *dev)
>>   			vivid_sliced_vbi_out_process(dev, vbi_out_buf);
>>
>>   		vbi_out_buf->vb.sequence = dev->vbi_out_seq_count;
>> -		v4l2_get_timestamp(&vbi_out_buf->vb.timestamp);
>> -		vbi_out_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
>> +		vbi_out_buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +		vbi_out_buf->vb.vb2_buf.timestamp +=
>> +				((u64) dev->time_wrap_offset * NSEC_PER_SEC);
>>   		vb2_buffer_done(&vbi_out_buf->vb.vb2_buf, dev->dqbuf_error ?
>>   				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>>   		dprintk(dev, 2, "vbi_out buffer %d done\n",
>> diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
>> index 082c401..dbdb43d 100644
>> --- a/drivers/media/platform/vivid/vivid-sdr-cap.c
>> +++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
>> @@ -117,8 +117,9 @@ static void vivid_thread_sdr_cap_tick(struct vivid_dev *dev)
>>   	if (sdr_cap_buf) {
>>   		sdr_cap_buf->vb.sequence = dev->sdr_cap_seq_count;
>>   		vivid_sdr_cap_process(dev, sdr_cap_buf);
>> -		v4l2_get_timestamp(&sdr_cap_buf->vb.timestamp);
>> -		sdr_cap_buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
>> +		sdr_cap_buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +		sdr_cap_buf->vb.vb2_buf.timestamp +=
>> +				((u64) dev->time_wrap_offset * NSEC_PER_SEC);
>>   		vb2_buffer_done(&sdr_cap_buf->vb.vb2_buf, dev->dqbuf_error ?
>>   				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>>   		dev->dqbuf_error = false;
>> diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
>> index e903d02..2f5f330 100644
>> --- a/drivers/media/platform/vivid/vivid-vbi-cap.c
>> +++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
>> @@ -108,8 +108,9 @@ void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
>>   	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
>>   		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
>>
>> -	v4l2_get_timestamp(&buf->vb.timestamp);
>> -	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
>> +	buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +	buf->vb.vb2_buf.timestamp +=
>> +			((u64) dev->time_wrap_offset * NSEC_PER_SEC);
>>   }
>>
>>
>> @@ -133,8 +134,9 @@ void vivid_sliced_vbi_cap_process(struct vivid_dev *dev,
>>   			vbuf[i] = dev->vbi_gen.data[i];
>>   	}
>>
>> -	v4l2_get_timestamp(&buf->vb.timestamp);
>> -	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
>> +	buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +	buf->vb.vb2_buf.timestamp +=
>> +			((u64) dev->time_wrap_offset * NSEC_PER_SEC);
>>   }
>>
>>   static int vbi_cap_queue_setup(struct vb2_queue *vq, const void *parg,
>
> <snip>
>
>> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> index 27b4b9e..93e16375 100644
>> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
>> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> @@ -119,8 +119,9 @@ static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
>>   		 * and the timecode field and flag if needed.
>>   		 */
>>   		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
>> -				V4L2_BUF_FLAG_TIMESTAMP_COPY)
>> -			vbuf->timestamp = b->timestamp;
>> +				V4L2_BUF_FLAG_TIMESTAMP_COPY) {
>> +			vb->timestamp = timeval_to_ns(&b->timestamp);
>> +		}
>
> No need to add {} for a one-line statement.
>

OK, I'll fix it.

>>   		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
>>   		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
>>   			vbuf->timecode = b->timecode;
>
> <snip>
>
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index 647ebfe..6404f81 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -211,6 +211,7 @@ struct vb2_queue;
>>    * @num_planes:		number of planes in the buffer
>>    *			on an internal driver queue
>>    * @planes:		private per-plane information; do not change
>> + * @timestamp:		frame timestamp
>
> Please mention the unit (ns).
>

OK, I'll fix it.

Best regards,
Junghak

>>    */
>>   struct vb2_buffer {
>>   	struct vb2_queue	*vb2_queue;
>> @@ -219,6 +220,7 @@ struct vb2_buffer {
>>   	unsigned int		memory;
>>   	unsigned int		num_planes;
>>   	struct vb2_plane	planes[VB2_MAX_PLANES];
>> +	u64			timestamp;
>>
>>   	/* private: internal use only
>>   	 *
>
> Other than these minor issues it looks good.
>
> Regards,
>
> 	Hans
>
