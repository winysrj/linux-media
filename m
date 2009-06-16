Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58574 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbZFPPvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 11:51:45 -0400
Date: Tue, 16 Jun 2009 12:51:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: linux-media@vger.kernel.org, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH V2] poll method lose race condition
Message-ID: <20090616125134.6de8a286@pedra.chehab.org>
In-Reply-To: <1243821904.3499.5.camel@myhost>
References: <1243821904.3499.5.camel@myhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 01 Jun 2009 10:05:04 +0800
"Figo.zhang" <figo1802@gmail.com> escreveu:

>  bttv-driver.c,cx23885-video.c,cx88-video.c: poll method lose race condition for capture video.
> 
>  In v2, use the clear logic.Thanks to Trent Piepho's help.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c     |   20 ++++++++++++--------
>  drivers/media/video/cx23885/cx23885-video.c |   15 +++++++++++----
>  drivers/media/video/cx88/cx88-video.c       |   15 +++++++++++----
>  3 files changed, 34 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index 23b7499..8d20528 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -3152,6 +3152,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>  	struct bttv_fh *fh = file->private_data;
>  	struct bttv_buffer *buf;
>  	enum v4l2_field field;
> +	unsigned int rc = POLLERR;
>  
>  	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
>  		if (!check_alloc_btres(fh->btv,fh,RESOURCE_VBI))
> @@ -3160,9 +3161,10 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>  	}
>  
>  	if (check_btres(fh,RESOURCE_VIDEO_STREAM)) {
> +		mutex_lock(&fh->cap.vb_lock);
>  		/* streaming capture */
>  		if (list_empty(&fh->cap.stream))
> -			return POLLERR;
> +			return done;

Here, you're keeping the mutex locked. Maybe you wanted to do a "goto done" ?

>  		buf = list_entry(fh->cap.stream.next,struct bttv_buffer,vb.stream);
>  	} else {
>  		/* read() capture */
> @@ -3170,16 +3172,16 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>  		if (NULL == fh->cap.read_buf) {
>  			/* need to capture a new frame */
>  			if (locked_btres(fh->btv,RESOURCE_VIDEO_STREAM))
> -				goto err;
> +				goto done;
>  			fh->cap.read_buf = videobuf_sg_alloc(fh->cap.msize);
>  			if (NULL == fh->cap.read_buf)
> -				goto err;
> +				goto done;
>  			fh->cap.read_buf->memory = V4L2_MEMORY_USERPTR;
>  			field = videobuf_next_field(&fh->cap);
>  			if (0 != fh->cap.ops->buf_prepare(&fh->cap,fh->cap.read_buf,field)) {
>  				kfree (fh->cap.read_buf);
>  				fh->cap.read_buf = NULL;
> -				goto err;
> +				goto done;
>  			}
>  			fh->cap.ops->buf_queue(&fh->cap,fh->cap.read_buf);
>  			fh->cap.read_off = 0;
> @@ -3191,11 +3193,13 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>  	poll_wait(file, &buf->vb.done, wait);
>  	if (buf->vb.state == VIDEOBUF_DONE ||
>  	    buf->vb.state == VIDEOBUF_ERROR)
> -		return POLLIN|POLLRDNORM;
> -	return 0;
> -err:
> +		rc =  POLLIN|POLLRDNORM;
> +	else 
> +		rc = 0;
> +	
> +done:
>  	mutex_unlock(&fh->cap.vb_lock);
> -	return POLLERR;
> +	return rc;
>  }
>  
>  static int bttv_open(struct file *file)
> diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
> index 68068c6..f542493 100644
> --- a/drivers/media/video/cx23885/cx23885-video.c
> +++ b/drivers/media/video/cx23885/cx23885-video.c
> @@ -796,6 +796,7 @@ static unsigned int video_poll(struct file *file,
>  {
>  	struct cx23885_fh *fh = file->private_data;
>  	struct cx23885_buffer *buf;
> +	unsigned int rc = POLLERR;
>  
>  	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
>  		if (!res_get(fh->dev, fh, RESOURCE_VBI))
> @@ -803,23 +804,29 @@ static unsigned int video_poll(struct file *file,
>  		return videobuf_poll_stream(file, &fh->vbiq, wait);
>  	}
>  
> +	mutex_lock(&fh->vidq.vb_lock);
>  	if (res_check(fh, RESOURCE_VIDEO)) {
>  		/* streaming capture */
>  		if (list_empty(&fh->vidq.stream))
> -			return POLLERR;
> +			goto done;
>  		buf = list_entry(fh->vidq.stream.next,
>  			struct cx23885_buffer, vb.stream);
>  	} else {
>  		/* read() capture */
>  		buf = (struct cx23885_buffer *)fh->vidq.read_buf;
>  		if (NULL == buf)
> -			return POLLERR;
> +			goto done;
>  	}
>  	poll_wait(file, &buf->vb.done, wait);
>  	if (buf->vb.state == VIDEOBUF_DONE ||
>  	    buf->vb.state == VIDEOBUF_ERROR)
> -		return POLLIN|POLLRDNORM;
> -	return 0;
> +		rc =  POLLIN|POLLRDNORM;
> +	else
> +		rc = 0;
> +
> +done:
> +	mutex_unlock(&fh->vidq.vb_lock);
> +	return rc;
>  }
>  
>  static int video_release(struct file *file)
> diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
> index b993d42..b1ca54b 100644
> --- a/drivers/media/video/cx88/cx88-video.c
> +++ b/drivers/media/video/cx88/cx88-video.c
> @@ -869,6 +869,7 @@ video_poll(struct file *file, struct poll_table_struct *wait)
>  {
>  	struct cx8800_fh *fh = file->private_data;
>  	struct cx88_buffer *buf;
> +	unsigned int rc = POLLERR;
>  
>  	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
>  		if (!res_get(fh->dev,fh,RESOURCE_VBI))
> @@ -876,22 +877,28 @@ video_poll(struct file *file, struct poll_table_struct *wait)
>  		return videobuf_poll_stream(file, &fh->vbiq, wait);
>  	}
>  
> +	mutex_lock(&fh->vidq.vb_lock);
>  	if (res_check(fh,RESOURCE_VIDEO)) {
>  		/* streaming capture */
>  		if (list_empty(&fh->vidq.stream))
> -			return POLLERR;
> +			goto done;
>  		buf = list_entry(fh->vidq.stream.next,struct cx88_buffer,vb.stream);
>  	} else {
>  		/* read() capture */
>  		buf = (struct cx88_buffer*)fh->vidq.read_buf;
>  		if (NULL == buf)
> -			return POLLERR;
> +			goto done;
>  	}
>  	poll_wait(file, &buf->vb.done, wait);
>  	if (buf->vb.state == VIDEOBUF_DONE ||
>  	    buf->vb.state == VIDEOBUF_ERROR)
> -		return POLLIN|POLLRDNORM;
> -	return 0;
> +		rc =  POLLIN|POLLRDNORM;
> +	else
> +		rc = 0;
> +
> +done:
> +	mutex_unlock(&fh->vidq.vb_lock);
> +	return rc;
>  }
>  
>  static int video_release(struct file *file)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
