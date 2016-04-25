Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:33503 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966AbcDYI4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 04:56:30 -0400
Subject: Re: [PATCH v2] media: vb2: Fix regression on poll() for RW mode
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1461571151-25848-1-git-send-email-ricardo.ribalda@gmail.com>
 <571DD7B8.9010508@xs4all.nl>
Cc: Junghak Sung <jh1009.sung@samsung.com>, stable@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571DDBB8.1030400@xs4all.nl>
Date: Mon, 25 Apr 2016 10:56:24 +0200
MIME-Version: 1.0
In-Reply-To: <571DD7B8.9010508@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/25/2016 10:39 AM, Hans Verkuil wrote:
> On 04/25/2016 09:59 AM, Ricardo Ribalda Delgado wrote:
>> When using a device is read/write mode, vb2 does not handle properly the
>> first select/poll operation.
>>
>> The reason for this, is that when this code has been refactored, some of
>> the operations have changed their order, and now fileio emulator is not
>> started.
>>
>> The reintroduced check to the core is enabled by a quirk flag, that
>> avoids this check by other subsystems like DVB.
>>
>> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
>> Cc: Junghak Sung <jh1009.sung@samsung.com>
>> Fixes: 49d8ab9feaf2 ("media] media: videobuf2: Separate vb2_poll()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>
>> v2: By  Hans Verkuil <hverkuil@xs4all.nl> and
>>  	Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
>>
>> 	Add a quirk bit to enable this behaviour on the core.
>>  drivers/media/v4l2-core/videobuf2-core.c | 9 +++++++++
>>  drivers/media/v4l2-core/videobuf2-v4l2.c | 9 +--------
>>  include/media/videobuf2-core.h           | 4 ++++
>>  3 files changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 5d016f496e0e..58eb9be13510 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -2298,6 +2298,15 @@ unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
>>  		return POLLERR;
>>  
>>  	/*
>> +	 * For compatibility with vb1: if QBUF hasn't been called yet, then
>> +	 * return POLLERR as well. This only affects capture queues, output
>> +	 * queues will always initialize waiting_for_buffers to false.
>> +	 */
> 
> This comment should be moved to where the quirk is set in v4l2. This comment shouldn't
> refer to vb2 at all. How about:

I'm sorry, I realize I was quite confusing here. I should have said:

"This comment should be copied to where the quirk is set in v4l2. This comment here
in core.c shouldn't refer to vb1 at all. How about:"

So in both places (here and in v4l2.c) there should be a comment.

Can you make a v4? Ask on irc if something is still unclear.

	Hans

> 
> "If this quirk is set and if QBUF hasn't been called..."
> 
> and perhaps at the end of the comment:
> 
> "This quirk is set by V4L2 for backwards compatibility reasons."
> 
> although I am not completely certain we need that at all here.
> 
>> +	if (q->quirk_poll_must_check_waiting_for_buffers &&
>> +	    q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))
>> +		return POLLERR;
>> +
>> +	/*
>>  	 * For output streams you can call write() as long as there are fewer
>>  	 * buffers queued than there are buffers available.
>>  	 */
>> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> index 91f552124050..3e649adf85ef 100644
>> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
>> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> @@ -765,6 +765,7 @@ int vb2_queue_init(struct vb2_queue *q)
>>  	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
>>  	q->copy_timestamp = (q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK)
>>  			== V4L2_BUF_FLAG_TIMESTAMP_COPY;
>> +	q->quirk_poll_must_check_waiting_for_buffers = true;
>>  
>>  	return vb2_core_queue_init(q);
>>  }
>> @@ -818,14 +819,6 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>>  			poll_wait(file, &fh->wait, wait);
>>  	}
>>  
>> -	/*
>> -	 * For compatibility with vb1: if QBUF hasn't been called yet, then
>> -	 * return POLLERR as well. This only affects capture queues, output
>> -	 * queues will always initialize waiting_for_buffers to false.
>> -	 */
>> -	if (q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))
>> -		return POLLERR;
>> -
>>  	return res | vb2_core_poll(q, file, wait);
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_poll);
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index 8a0f55b6c2ba..3a1620946068 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -400,6 +400,9 @@ struct vb2_buf_ops {
>>   * @fileio_read_once:		report EOF after reading the first buffer
>>   * @fileio_write_immediately:	queue buffer after each write() call
>>   * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
>> + * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
>> + *              has not been called. This is a vb1 idiom that has been adopted
>> + *              also by vb2.
>>   * @lock:	pointer to a mutex that protects the vb2_queue struct. The
>>   *		driver can set this to a mutex to let the v4l2 core serialize
>>   *		the queuing ioctls. If the driver wants to handle locking
>> @@ -463,6 +466,7 @@ struct vb2_queue {
>>  	unsigned			fileio_read_once:1;
>>  	unsigned			fileio_write_immediately:1;
>>  	unsigned			allow_zero_bytesused:1;
>> +	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
>>  
>>  	struct mutex			*lock;
>>  	void				*owner;
>>
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

