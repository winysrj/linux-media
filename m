Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3158 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2IQOL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 10:11:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH 1/4] videobuf2-core: Replace BUG_ON and return an error at vb2_queue_init()
Date: Mon, 17 Sep 2012 16:10:43 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <1347889437-15073-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1347889437-15073-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171610.43862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon September 17 2012 15:43:54 Ezequiel Garcia wrote:
> This replaces BUG_ON() calls with WARN_ON_ONCE(), and returns
> EINVAL if some parameter is NULL, as suggested by Jonathan and Mauro.
> 
> The BUG_ON() call is too drastic to be used in this case.
> See the full discussion here:
> http://www.spinics.net/lists/linux-media/msg52462.html
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
> This patchset replaces:
> [PATCH 9/9] videobuf2-core: Change vb2_queue_init return type to void
> 
>  drivers/media/v4l2-core/videobuf2-core.c |   19 +++++++++++--------
>  include/media/videobuf2-core.h           |    2 +-
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 4da3df6..e394191 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1738,14 +1738,17 @@ EXPORT_SYMBOL_GPL(vb2_poll);
>   */
>  int vb2_queue_init(struct vb2_queue *q)
>  {
> -	BUG_ON(!q);
> -	BUG_ON(!q->ops);
> -	BUG_ON(!q->mem_ops);
> -	BUG_ON(!q->type);
> -	BUG_ON(!q->io_modes);
> -
> -	BUG_ON(!q->ops->queue_setup);
> -	BUG_ON(!q->ops->buf_queue);
> +	/*
> +	 * Sanity check
> +	 */
> +	if (WARN_ON_ONCE(!q)		||
> +	    WARN_ON_ONCE(!q->ops)	||
> +	    WARN_ON_ONCE(!q->mem_ops)	||
> +	    WARN_ON_ONCE(!q->type)	||
> +	    WARN_ON_ONCE(!q->io_modes)	||
> +	    WARN_ON_ONCE(!q->ops->queue_setup) ||
> +	    WARN_ON_ONCE(!q->ops->buf_queue))

Why WARN_ON_ONCE? I'd want to see this all the time, not just once.

It's certainly better than BUG_ON, but I'd go for WARN_ON.

Regards,

	Hans

> +		return -EINVAL;
>  
>  	INIT_LIST_HEAD(&q->queued_list);
>  	INIT_LIST_HEAD(&q->done_list);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 8dd9b6c..e04252a 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -324,7 +324,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
>  int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
>  int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
>  
> -int vb2_queue_init(struct vb2_queue *q);
> +int __must_check vb2_queue_init(struct vb2_queue *q);
>  
>  void vb2_queue_release(struct vb2_queue *q);
>  
> 
