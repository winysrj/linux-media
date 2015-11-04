Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39866 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965273AbbKDMlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2015 07:41:45 -0500
Subject: Re: [RFC PATCH v9 2/6] media: videobuf2: Add set_timestamp to struct
 vb2_queue
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
 <1446545802-28496-3-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5639FD00.1040001@xs4all.nl>
Date: Wed, 4 Nov 2015 13:41:36 +0100
MIME-Version: 1.0
In-Reply-To: <1446545802-28496-3-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/15 11:16, Junghak Sung wrote:
> Add set_timestamp to struct vb2_queue as a flag set if vb2-core should
> set timestamps.
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-v4l2.c |   20 +++++++-------------
>  include/media/videobuf2-core.h           |    2 ++
>  2 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 93e16375..d254452 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -118,10 +118,8 @@ static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
>  		 * For output buffers copy the timestamp if needed,
>  		 * and the timecode field and flag if needed.
>  		 */
> -		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> -				V4L2_BUF_FLAG_TIMESTAMP_COPY) {
> +		if (q->set_timestamp)
>  			vb->timestamp = timeval_to_ns(&b->timestamp);
> -		}
>  		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
>  		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
>  			vbuf->timecode = b->timecode;
> @@ -239,8 +237,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	 */
>  	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
>  	b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
> -	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> -	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
> +	if (!q->set_timestamp) {
>  		/*
>  		 * For non-COPY timestamps, drop timestamp source bits
>  		 * and obtain the timestamp source from the queue.
> @@ -404,8 +401,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  
>  	/* Zero flags that the vb2 core handles */
>  	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> -	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
> -	    V4L2_BUF_FLAG_TIMESTAMP_COPY || !V4L2_TYPE_IS_OUTPUT(b->type)) {
> +	if (!vb->vb2_queue->set_timestamp || !V4L2_TYPE_IS_OUTPUT(b->type)) {
>  		/*
>  		 * Non-COPY timestamps and non-OUTPUT queues will get
>  		 * their timestamp and timestamp source flags from the
> @@ -723,6 +719,8 @@ int vb2_queue_init(struct vb2_queue *q)
>  	q->buf_ops = &v4l2_buf_ops;
>  	q->is_multiplanar = V4L2_TYPE_IS_MULTIPLANAR(q->type);
>  	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);
> +	q->set_timestamp = (q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK)
> +			== V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  
>  	return vb2_core_queue_init(q);
>  }
> @@ -1080,9 +1078,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>  	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
>  	 * else is able to provide this information with the write() operation.
>  	 */
> -	bool set_timestamp = !read &&
> -		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> -		V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	bool set_timestamp = !read && q->set_timestamp;
>  	int ret, index;
>  
>  	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
> @@ -1271,9 +1267,7 @@ static int vb2_thread(void *data)
>  
>  	if (q->is_output) {
>  		prequeue = q->num_buffers;
> -		set_timestamp =
> -			(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> -			V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +		set_timestamp = q->set_timestamp;
>  	}
>  
>  	set_freezable();
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 6404f81..b73a28a 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -431,6 +431,7 @@ struct vb2_buf_ops {
>   *		called since poll() needs to return POLLERR in that situation.
>   * @is_multiplanar: set if buffer type is multiplanar
>   * @is_output:	set if buffer type is output
> + * @copy_timestamp: set if vb2-core should set timestamps

This says copy_timestamp,

>   * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
>   *		last decoded buffer was already dequeued. Set for capture queues
>   *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
> @@ -480,6 +481,7 @@ struct vb2_queue {
>  	unsigned int			waiting_for_buffers:1;
>  	unsigned int			is_multiplanar:1;
>  	unsigned int			is_output:1;
> +	unsigned int			set_timestamp:1;

while this is set_timestamp.

I actually think the comment is right and this field should be called
copy_timestamp. The timestamp is never actually set, it is just copied.

>  	unsigned int			last_buffer_dequeued:1;
>  
>  	struct vb2_fileio_data		*fileio;
> 

Regards,

	Hams
