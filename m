Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59225 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZIAI4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 04:56:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Subject: Re: [PATCH take 2] V4L: videobuf-core.c VIDIOC_QBUF should return video buffer flags
Date: Tue, 1 Sep 2009 10:56:19 +0200
Cc: linux-media@vger.kernel.org, sailus@maxwell.research.nokia.com,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200908311458.54406.tuukka.o.toivonen@nokia.com>
In-Reply-To: <200908311458.54406.tuukka.o.toivonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909011056.19731.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 31 August 2009 13:58:54 Tuukka.O Toivonen wrote:
> When user space queues a buffer using VIDIOC_QBUF, the kernel
> should set flags in struct v4l2_buffer as specified in the V4L2
> documentation.

You forgot your SoB line.

> ---
>  drivers/media/video/videobuf-core.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/videobuf-core.c
> b/drivers/media/video/videobuf-core.c index b7b0584..1322056 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -477,6 +477,7 @@ int videobuf_qbuf(struct videobuf_queue *q,
>  	struct videobuf_buffer *buf;
>  	enum v4l2_field field;
>  	unsigned long flags = 0;
> +	__u32 buffer_flags = b->flags;

Is that safe ? What if userspace sets bogus flags ? What about hardcoding the 
flags to V4L2_BUF_FLAG_QUEUED (| V4L2_BUF_FLAG_MAPPED when buf->map is not 
NULL) instead, like videobuf_status does ?

>  	int retval;
>
>  	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
> @@ -531,6 +532,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
>  				   "but buffer addr is zero!\n");
>  			goto done;
>  		}
> +		buffer_flags |= V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_QUEUED;
> +		buffer_flags &= ~V4L2_BUF_FLAG_DONE;
>  		break;
>  	case V4L2_MEMORY_USERPTR:
>  		if (b->length < buf->bsize) {
> @@ -541,6 +544,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
>  		    buf->baddr != b->m.userptr)
>  			q->ops->buf_release(q, buf);
>  		buf->baddr = b->m.userptr;
> +		buffer_flags |= V4L2_BUF_FLAG_QUEUED;
> +		buffer_flags &= ~(V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE);
>  		break;
>  	case V4L2_MEMORY_OVERLAY:
>  		buf->boff = b->m.offset;
> @@ -564,6 +569,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
>  		q->ops->buf_queue(q, buf);
>  		spin_unlock_irqrestore(q->irqlock, flags);
>  	}
> +
> +	b->flags = buffer_flags;
>  	dprintk(1, "qbuf: succeded\n");
>  	retval = 0;
>  	wake_up_interruptible_sync(&q->wait);

-- 
Laurent Pinchart
