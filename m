Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbaFIPHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jun 2014 11:07:10 -0400
Message-ID: <5395CD99.3010509@redhat.com>
Date: Mon, 09 Jun 2014 17:07:05 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Thiago Santos <ts.santos@sisa.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v2 2/2] libv4l2: release the lock before doing a DQBUF
References: <1402321916-22111-1-git-send-email-ts.santos@sisa.samsung.com> <1402321916-22111-3-git-send-email-ts.santos@sisa.samsung.com>
In-Reply-To: <1402321916-22111-3-git-send-email-ts.santos@sisa.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/09/2014 03:51 PM, Thiago Santos wrote:
> In blocking mode, if there are no buffers available the DQBUF will block
> waiting for a QBUF to be called but it will block holding the streaming
> lock which will prevent any QBUF from happening, causing a deadlock.
> 
> Can be tested with: v4l2grab -t -b -s 2000
> 
> Signed-off-by: Thiago Santos <ts.santos@sisa.samsung.com>

Looks good now:

Acked-by: Hans de Goede <hdegoede@redhat.com>

I'll leave reviewing the 1st patch to someone else. Gregor and/or
Mauro feel free to push this one.

Regards,

Hans

> ---
>  lib/libv4l2/libv4l2-priv.h |  1 +
>  lib/libv4l2/libv4l2.c      | 13 ++++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
> index 585273c..ff4c8d2 100644
> --- a/lib/libv4l2/libv4l2-priv.h
> +++ b/lib/libv4l2/libv4l2-priv.h
> @@ -92,6 +92,7 @@ struct v4l2_dev_info {
>  	unsigned char *frame_pointers[V4L2_MAX_NO_FRAMES];
>  	int frame_sizes[V4L2_MAX_NO_FRAMES];
>  	int frame_queued; /* 1 status bit per frame */
> +	int frame_info_generation;
>  	/* mapping tracking of our fake (converting mmap) frame buffers */
>  	unsigned char frame_map_count[V4L2_MAX_NO_FRAMES];
>  	/* buffer when doing conversion and using read() for read() */
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index c4d69f7..1dcf34d 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -282,7 +282,7 @@ static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
>  		unsigned char *dest, int dest_size)
>  {
>  	const int max_tries = V4L2_IGNORE_FIRST_FRAME_ERRORS + 1;
> -	int result, tries = max_tries;
> +	int result, tries = max_tries, frame_info_gen;
>  
>  	/* Make sure we have the real v4l2 buffers mapped */
>  	result = v4l2_map_buffers(index);
> @@ -290,9 +290,12 @@ static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
>  		return result;
>  
>  	do {
> +		frame_info_gen = devices[index].frame_info_generation;
> +		pthread_mutex_unlock(&devices[index].stream_lock);
>  		result = devices[index].dev_ops->ioctl(
>  				devices[index].dev_ops_priv,
>  				devices[index].fd, VIDIOC_DQBUF, buf);
> +		pthread_mutex_lock(&devices[index].stream_lock);
>  		if (result) {
>  			if (errno != EAGAIN) {
>  				int saved_err = errno;
> @@ -305,6 +308,11 @@ static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
>  
>  		devices[index].frame_queued &= ~(1 << buf->index);
>  
> +		if (frame_info_gen != devices[index].frame_info_generation) {
> +			errno = -EINVAL;
> +			return -1;
> +		}
> +
>  		result = v4lconvert_convert(devices[index].convert,
>  				&devices[index].src_fmt, &devices[index].dest_fmt,
>  				devices[index].frame_pointers[buf->index],
> @@ -839,6 +847,7 @@ int v4l2_dup(int fd)
>  
>  static int v4l2_check_buffer_change_ok(int index)
>  {
> +	devices[index].frame_info_generation++;
>  	v4l2_unmap_buffers(index);
>  
>  	/* Check if the app itself still is using the stream */
> @@ -1294,9 +1303,11 @@ no_capture_request:
>  		}
>  
>  		if (!v4l2_needs_conversion(index)) {
> +			pthread_mutex_unlock(&devices[index].stream_lock);
>  			result = devices[index].dev_ops->ioctl(
>  					devices[index].dev_ops_priv,
>  					fd, VIDIOC_DQBUF, buf);
> +			pthread_mutex_lock(&devices[index].stream_lock);
>  			if (result) {
>  				saved_err = errno;
>  				V4L2_PERROR("dequeuing buf");
> 
