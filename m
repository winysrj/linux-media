Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3232 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161002AbaDQKMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:12:05 -0400
Message-ID: <534FA8E5.4040101@xs4all.nl>
Date: Thu, 17 Apr 2014 12:11:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	LMML <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] vb2: Update buffer state flags after __vb2_dqbuf
References: <1397676846.10347.11.camel@nicolas-tpx230>
In-Reply-To: <1397676846.10347.11.camel@nicolas-tpx230>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2014 09:34 PM, Nicolas Dufresne wrote:
> 
> Previously we where updating the buffer state using __fill_v4l2_buffer
> before the state transition was completed through __vb2_dqbuf. This
> would cause the V4L2_BUF_FLAG_DONE to be set, which would mean it still
> queued. The spec says the dqbuf should clean the DONE flag, right not it
> alway set it.
> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Nack: this will break the V4L2_BUF_FLAG_ERROR support.

I would recommend just clearing the DONE flag explicitly.

Looking at the code I believe the flags are also set incorrectly
after QBUF (and PREPARE_BUF might have problems as well).

This needs some careful checking and I need to add v4l2-compliance
checks for this.

I don't really have time to look into this at the moment, though.

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f9059bb..ac5026a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1943,14 +1943,15 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
>  
>  	call_vb_qop(vb, buf_finish, vb);
>  
> -	/* Fill buffer information for the userspace */
> -	__fill_v4l2_buffer(vb, b);
>  	/* Remove from videobuf queue */
>  	list_del(&vb->queued_entry);
>  	q->queued_count--;
>  	/* go back to dequeued state */
>  	__vb2_dqbuf(vb);
>  
> +	/* Fill buffer information for the userspace */
> +	__fill_v4l2_buffer(vb, b);
> +
>  	dprintk(1, "dqbuf of buffer %d, with state %d\n",
>  			vb->v4l2_buf.index, vb->state);
>  
> 

