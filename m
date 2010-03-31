Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4460 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127Ab0CaJ6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 05:58:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v2 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
Date: Wed, 31 Mar 2010 11:58:54 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
References: <1270027947-28327-1-git-send-email-p.osciak@samsung.com> <1270027947-28327-3-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1270027947-28327-3-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003311158.54574.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 31 March 2010 11:32:26 Pawel Osciak wrote:
> For recoverable stream errors dqbuf() now returns 0 and the error flag
> is set instead of returning EIO.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf-core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> index 63d7043..a9cfab6 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -665,6 +665,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
>  {
>  	struct videobuf_buffer *buf = NULL;
>  	int retval;
> +	int err_flag = 0;
>  
>  	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
>  
> @@ -679,7 +680,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
>  	switch (buf->state) {
>  	case VIDEOBUF_ERROR:
>  		dprintk(1, "dqbuf: state is error\n");
> -		retval = -EIO;
> +		err_flag = V4L2_BUF_FLAG_ERROR;
>  		CALL(q, sync, q, buf);
>  		buf->state = VIDEOBUF_IDLE;
>  		break;
> @@ -696,6 +697,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
>  	list_del(&buf->stream);
>  	memset(b, 0, sizeof(*b));
>  	videobuf_status(q, b, buf, q->type);
> +	b->flags |= err_flag;
>  done:
>  	mutex_unlock(&q->vb_lock);
>  	return retval;
> 

I think we need to modify videobuf_status as well: if the buffer is in state
VIDEOBUF_ERROR, then videobuf_status should set both the DONE and ERROR flags.

And the dqbuf code can be simplified a bit as well if we do that:

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index bb0a1c8..29726d8 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -273,8 +273,10 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 	case VIDEOBUF_ACTIVE:
 		b->flags |= V4L2_BUF_FLAG_QUEUED;
 		break;
-	case VIDEOBUF_DONE:
 	case VIDEOBUF_ERROR:
+		b->flags |= V4L2_BUF_FLAG_ERROR;
+		/* fall through */
+	case VIDEOBUF_DONE:
 		b->flags |= V4L2_BUF_FLAG_DONE;
 		break;
 	case VIDEOBUF_NEEDS_INIT:
@@ -654,6 +656,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
+	memset(b, 0, sizeof(*b));
 	mutex_lock(&q->vb_lock);
 
 	retval = stream_next_buffer(q, &buf, nonblocking);
@@ -665,23 +668,20 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 	switch (buf->state) {
 	case VIDEOBUF_ERROR:
 		dprintk(1, "dqbuf: state is error\n");
-		retval = -EIO;
-		CALL(q, sync, q, buf);
-		buf->state = VIDEOBUF_IDLE;
 		break;
 	case VIDEOBUF_DONE:
 		dprintk(1, "dqbuf: state is done\n");
-		CALL(q, sync, q, buf);
-		buf->state = VIDEOBUF_IDLE;
 		break;
 	default:
 		dprintk(1, "dqbuf: state invalid\n");
 		retval = -EINVAL;
 		goto done;
 	}
-	list_del(&buf->stream);
-	memset(b, 0, sizeof(*b));
+	CALL(q, sync, q, buf);
 	videobuf_status(q, b, buf, q->type);
+	list_del(&buf->stream);
+	buf->state = VIDEOBUF_IDLE;
+	b->flags &= ~V4L2_BUF_FLAG_DONE;
 
  done:
 	mutex_unlock(&q->vb_lock);

(Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
