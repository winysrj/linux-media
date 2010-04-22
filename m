Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59711 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0DVJKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 05:10:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v3 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
Date: Thu, 22 Apr 2010 11:12:30 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>
References: <1271849985-368-1-git-send-email-p.osciak@samsung.com> <1271849985-368-3-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1271849985-368-3-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004221112.30988.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Wednesday 21 April 2010 13:39:44 Pawel Osciak wrote:
> From: Hans Verkuil <hverkuil@xs4all.nl>
> 
> For recoverable stream errors dqbuf() now returns 0 and the error flag
> is set instead of returning EIO.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/videobuf-core.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-core.c
> b/drivers/media/video/videobuf-core.c index 63d7043..1cf084f 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -286,8 +286,10 @@ static void videobuf_status(struct videobuf_queue *q,
> struct v4l2_buffer *b, case VIDEOBUF_ACTIVE:
>  		b->flags |= V4L2_BUF_FLAG_QUEUED;
>  		break;
> -	case VIDEOBUF_DONE:
>  	case VIDEOBUF_ERROR:
> +		b->flags |= V4L2_BUF_FLAG_ERROR;
> +		/* fall through */
> +	case VIDEOBUF_DONE:
>  		b->flags |= V4L2_BUF_FLAG_DONE;
>  		break;
>  	case VIDEOBUF_NEEDS_INIT:
> @@ -668,6 +670,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
> 
>  	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
> 
> +	memset(b, 0, sizeof(*b));
>  	mutex_lock(&q->vb_lock);
> 
>  	retval = stream_next_buffer(q, &buf, nonblocking);
> @@ -679,23 +682,20 @@ int videobuf_dqbuf(struct videobuf_queue *q,
>  	switch (buf->state) {
>  	case VIDEOBUF_ERROR:
>  		dprintk(1, "dqbuf: state is error\n");
> -		retval = -EIO;
> -		CALL(q, sync, q, buf);
> -		buf->state = VIDEOBUF_IDLE;
>  		break;
>  	case VIDEOBUF_DONE:
>  		dprintk(1, "dqbuf: state is done\n");
> -		CALL(q, sync, q, buf);
> -		buf->state = VIDEOBUF_IDLE;
>  		break;
>  	default:
>  		dprintk(1, "dqbuf: state invalid\n");
>  		retval = -EINVAL;
>  		goto done;
>  	}
> -	list_del(&buf->stream);
> -	memset(b, 0, sizeof(*b));
> +	CALL(q, sync, q, buf);
>  	videobuf_status(q, b, buf, q->type);
> +	list_del(&buf->stream);
> +	buf->state = VIDEOBUF_IDLE;
> +	b->flags &= ~V4L2_BUF_FLAG_DONE;

We do you clear the done flag here ?

>  done:
>  	mutex_unlock(&q->vb_lock);
>  	return retval;

-- 
Regards,

Laurent Pinchart
