Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37401 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbbJ2Cev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 22:34:51 -0400
Subject: Re: [RFC PATCH v7 2/7] media: videobuf2: Move timestamp to vb2_buffer
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
 <1444976863-3657-3-git-send-email-jh1009.sung@samsung.com>
 <56318418.8070501@xs4all.nl>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <563185BC.8040800@xs4all.nl>
Date: Thu, 29 Oct 2015 11:34:36 +0900
MIME-Version: 1.0
In-Reply-To: <56318418.8070501@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correction:

On 10/29/2015 11:27, Hans Verkuil wrote:
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index 647ebfe..f1e7169 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -211,6 +211,7 @@ struct vb2_queue;
>>   * @num_planes:		number of planes in the buffer
>>   *			on an internal driver queue
>>   * @planes:		private per-plane information; do not change
>> + * @timestamp:		frame timestamp
>>   */
>>  struct vb2_buffer {
>>  	struct vb2_queue	*vb2_queue;
>> @@ -219,6 +220,7 @@ struct vb2_buffer {
>>  	unsigned int		memory;
>>  	unsigned int		num_planes;
>>  	struct vb2_plane	planes[VB2_MAX_PLANES];
>> +	struct timeval		timestamp;
> 
> This should become a u64 timestamp that's filled using ktime_get_ns().
> In the v4l2 code this should be converted to a timeval when v4l2_buffer
> is filled. Using ktime_get_ns() is the recommended method to do timestamping
> without having to worry about the y2038 problem and this should be used in
> vb2 core.
> 
> v4l2_set_timestamp should be updated accordingly.

This can't be done since v4l2_set_timestamp is also used by non-vb2 drivers.
Instead vb2 drivers should just call ktime_get_ns() directly instead of calling
v4l2_set_timestamp().

Sorry for the confusion.

	Hans

> 
> Regards,
> 
> 	Hans
> 
>>  
>>  	/* private: internal use only
>>  	 *
>> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
>> index 5abab1e..110062e 100644
>> --- a/include/media/videobuf2-v4l2.h
>> +++ b/include/media/videobuf2-v4l2.h
>> @@ -28,7 +28,6 @@
>>   * @vb2_buf:	video buffer 2
>>   * @flags:	buffer informational flags
>>   * @field:	enum v4l2_field; field order of the image in the buffer
>> - * @timestamp:	frame timestamp
>>   * @timecode:	frame timecode
>>   * @sequence:	sequence count of this frame
>>   * Should contain enough information to be able to cover all the fields
>> @@ -39,7 +38,6 @@ struct vb2_v4l2_buffer {
>>  
>>  	__u32			flags;
>>  	__u32			field;
>> -	struct timeval		timestamp;
>>  	struct v4l2_timecode	timecode;
>>  	__u32			sequence;
>>  };
>> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
>> index 04ef89b..5b57d0a 100644
>> --- a/include/trace/events/v4l2.h
>> +++ b/include/trace/events/v4l2.h
>> @@ -204,7 +204,7 @@ DECLARE_EVENT_CLASS(vb2_v4l2_event_class,
>>  		__entry->minor = owner ? owner->vdev->minor : -1;
>>  		__entry->flags = vbuf->flags;
>>  		__entry->field = vbuf->field;
>> -		__entry->timestamp = timeval_to_ns(&vbuf->timestamp);
>> +		__entry->timestamp = timeval_to_ns(&vb->timestamp);
>>  		__entry->timecode_type = vbuf->timecode.type;
>>  		__entry->timecode_flags = vbuf->timecode.flags;
>>  		__entry->timecode_frames = vbuf->timecode.frames;
>> diff --git a/include/trace/events/vb2.h b/include/trace/events/vb2.h
>> index bfeceeb..35c1589 100644
>> --- a/include/trace/events/vb2.h
>> +++ b/include/trace/events/vb2.h
>> @@ -18,6 +18,7 @@ DECLARE_EVENT_CLASS(vb2_event_class,
>>  		__field(u32, index)
>>  		__field(u32, type)
>>  		__field(u32, bytesused)
>> +		__field(s64, timestamp)
>>  	),
>>  
>>  	TP_fast_assign(
>> @@ -28,14 +29,16 @@ DECLARE_EVENT_CLASS(vb2_event_class,
>>  		__entry->index = vb->index;
>>  		__entry->type = vb->type;
>>  		__entry->bytesused = vb->planes[0].bytesused;
>> +		__entry->timestamp = timeval_to_ns(&vb->timestamp);
>>  	),
>>  
>>  	TP_printk("owner = %p, queued = %u, owned_by_drv = %d, index = %u, "
>> -		  "type = %u, bytesused = %u", __entry->owner,
>> +		  "type = %u, bytesused = %u, timestamp = %llu", __entry->owner,
>>  		  __entry->queued_count,
>>  		  __entry->owned_by_drv_count,
>>  		  __entry->index, __entry->type,
>> -		  __entry->bytesused
>> +		  __entry->bytesused,
>> +		  __entry->timestamp
>>  	)
>>  )
>>  
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
