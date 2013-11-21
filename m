Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56589 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab3KUOwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 09:52:49 -0500
In-Reply-To: <528E101C.5070509@xs4all.nl>
References: <1384995906.1917.12.camel@palomino.walls.org> <528E101C.5070509@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RFC] videobuf2: Improve file I/O emulation to handle buffers in any order
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 21 Nov 2013 09:52:47 -0500
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	PawelOsciak <pawel@osciak.com>
Message-ID: <0cf507fa-23cd-4ef2-ab2c-a18f33ca2232@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> wrote:
>Hi Andy,
>
>This seems more complex than is necessary. See my comments below...
>
>On 11/21/13 02:05, Andy Walls wrote:
>> (This patch is RFC, because it was compiled and tested against kernel
>> v3.5)
>> 
>> videobuf2 file I/O emulation assumed that buffers dequeued from the
>> driver would return in the order they were enqueued in the driver. 
>> 
>> Improve the file I/O emulator's book-keeping to remove this
>assumption.
>> 
>> Also remove the, AFAICT, assumption that only read() calls would need
>to
>> dequeue a buffer from the driver.
>> 
>> Also set the buf->size properly, if a write() dequeues a buffer.
>> 
>> 
>> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: PawelOsciak<pawel@osciak.com>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> 
>> 
>> diff --git a/drivers/media/video/videobuf2-core.c
>b/drivers/media/video/videobuf2-core.c
>> index 9d4e9ed..f330aa4 100644
>> --- a/drivers/media/video/videobuf2-core.c
>> +++ b/drivers/media/video/videobuf2-core.c
>> @@ -1796,6 +1796,7 @@ struct vb2_fileio_data {
>>  	unsigned int dq_count;
>>  	unsigned int flags;
>>  };
>> +#define FILEIO_INDEX_NOT_SET	((unsigned int) INT_MAX)
>>  
>>  /**
>>   * __vb2_init_fileio() - initialize file io emulator
>> @@ -1889,6 +1890,7 @@ static int __vb2_init_fileio(struct vb2_queue
>*q, int read)
>>  				goto err_reqbufs;
>>  			fileio->bufs[i].queued = 1;
>>  		}
>> +		fileio->index = FILEIO_INDEX_NOT_SET;
>>  
>>  		/*
>>  		 * Start streaming.
>> @@ -1975,15 +1977,11 @@ static size_t __vb2_perform_fileio(struct
>vb2_queue *q, char __user *data, size_
>>  	 */
>>  	q->fileio = NULL;
>>  
>> -	index = fileio->index;
>> -	buf = &fileio->bufs[index];
>> -
>>  	/*
>>  	 * Check if we need to dequeue the buffer.
>>  	 */
>> -	if (buf->queued) {
>> -		struct vb2_buffer *vb;
>> -
>> +	index = fileio->index;
>> +	if (index == FILEIO_INDEX_NOT_SET) {
>>  		/*
>>  		 * Call vb2_dqbuf to get buffer back.
>>  		 */
>> @@ -1997,12 +1995,19 @@ static size_t __vb2_perform_fileio(struct
>vb2_queue *q, char __user *data, size_
>>  			goto end;
>>  		fileio->dq_count += 1;
>>  
>> +		fileio->index = fileio->b.index;
>> +		index = fileio->index;
>> +		buf = &fileio->bufs[index];
>> +		
>>  		/*
>>  		 * Get number of bytes filled by the driver
>>  		 */
>> -		vb = q->bufs[index];
>> -		buf->size = vb2_get_plane_payload(vb, 0);
>> +		buf->pos = 0;
>>  		buf->queued = 0;
>> +		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
>> +				 : vb2_plane_size(q->bufs[index], 0);
>> +	} else {
>> +		buf = &fileio->bufs[index];
>>  	}
>>  
>>  	/*
>> @@ -2070,13 +2075,28 @@ static size_t __vb2_perform_fileio(struct
>vb2_queue *q, char __user *data, size_
>>  		 */
>>  		buf->pos = 0;
>>  		buf->queued = 1;
>> -		buf->size = q->bufs[0]->v4l2_planes[0].length;
>> +		buf->size = vb2_plane_size(q->bufs[index], 0);
>>  		fileio->q_count += 1;
>>  
>>  		/*
>> -		 * Switch to the next buffer
>> +		 * Decide on the next buffer
>>  		 */
>> -		fileio->index = (index + 1) % q->num_buffers;
>> +		if (read || (q->num_buffers == 1)) {
>> +			/* Use the next buffer the driver provides back */
>> +			fileio->index = FILEIO_INDEX_NOT_SET;
>> +		} else {
>> +			/* Prefer a buffer that is not quequed in the driver */
>> +			int initial_index = fileio->index;
>> +			fileio->index = FILEIO_INDEX_NOT_SET;
>> +			do {
>> +				if (++index == q->num_buffers)
>> +					index = 0;
>> +				if (!fileio->bufs[index].queued) {
>> +					fileio->index = index;
>> +					break;
>> +				}
>> +			} while (index != initial_index);
>
>Why bother finding an unused index? There are really just two
>situations:
>either all the buffers have been queued, and after that you just
>dequeue
>and queue them (and you get the index from the dequeued buffer), or you
>are still only queuing buffers (in the write case, for the read case
>that
>already happened) and you can use a simple counter as the index.
>
>> +		}
>>  
>>  		/*
>>  		 * Start streaming if required.
>> 
>> 
>
>See my version of this patch below (it might not cleanly apply as this
>sits
>on top of a bunch of other vb2 patches that I will post soon):
>
>diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>b/drivers/media/v4l2-core/videobuf2-core.c
>index 66cd81d..257b4ca 100644
>--- a/drivers/media/v4l2-core/videobuf2-core.c
>+++ b/drivers/media/v4l2-core/videobuf2-core.c
>@@ -2309,6 +2309,7 @@ static int __vb2_init_fileio(struct vb2_queue *q,
>int read)
> 				goto err_reqbufs;
> 			fileio->bufs[i].queued = 1;
> 		}
>+		fileio->index = q->num_buffers;
> 	}
> 
> 	/*
>@@ -2384,15 +2385,11 @@ static size_t __vb2_perform_fileio(struct
>vb2_queue *q, char __user *data, size_
> 	}
> 	fileio = q->fileio;
> 
>-	index = fileio->index;
>-	buf = &fileio->bufs[index];
>-
> 	/*
> 	 * Check if we need to dequeue the buffer.
> 	 */
>-	if (buf->queued) {
>-		struct vb2_buffer *vb;
>-
>+	index = fileio->index;
>+	if (index >= q->num_buffers) {
> 		/*
> 		 * Call vb2_dqbuf to get buffer back.
> 		 */
>@@ -2405,12 +2402,18 @@ static size_t __vb2_perform_fileio(struct
>vb2_queue *q, char __user *data, size_
> 			return ret;
> 		fileio->dq_count += 1;
> 
>+		index = fileio->b.index;
>+		buf = &fileio->bufs[index];
>+		
> 		/*
> 		 * Get number of bytes filled by the driver
> 		 */
>-		vb = q->bufs[index];
>-		buf->size = vb2_get_plane_payload(vb, 0);
>+		buf->pos = 0;
> 		buf->queued = 0;
>+		buf->size = read ? vb2_get_plane_payload(q->bufs[index], 0)
>+				 : vb2_plane_size(q->bufs[index], 0);
>+	} else {
>+		buf = &fileio->bufs[index];
> 	}
> 
> 	/*
>@@ -2473,13 +2476,10 @@ static size_t __vb2_perform_fileio(struct
>vb2_queue *q, char __user *data, size_
> 		 */
> 		buf->pos = 0;
> 		buf->queued = 1;
>-		buf->size = q->bufs[0]->v4l2_planes[0].length;
>+		buf->size = vb2_plane_size(q->bufs[index], 0);
> 		fileio->q_count += 1;
>-
>-		/*
>-		 * Switch to the next buffer
>-		 */
>-		fileio->index = (index + 1) % q->num_buffers;
>+		if (fileio->index < q->num_buffers)
>+			fileio->index++;
> 	}
> 
> 	/*
>
>
>Regards,
>
>	Hans
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Hans,

You are correct.  The initial queuing for write() can just use a simple, incrementing index.

(I developed the patch at work under some deadline pressure.  Overly complex still worked to get the job done at the time.)

I will review your patch later this evening.

Regards,
Andy

