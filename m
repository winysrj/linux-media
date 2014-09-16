Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38698 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaIPKcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 06:32:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [RFC PATCH] vb2: regression fix for vbi capture & poll
Date: Tue, 16 Sep 2014 13:32:54 +0300
Message-ID: <1622124.9R2KLtfafx@avalon>
In-Reply-To: <541810E2.4040509@cisco.com>
References: <541810E2.4040509@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 16 September 2014 12:28:50 Hans Verkuil wrote:
> (My proposal to fix this. Note that it is untested, I plan to do that this
> evening)
> 
> Commit 9241650d62f7 broke vbi capture applications that expect POLLERR to be
> returned if STREAMON wasn't called.
> 
> Rather than checking whether buffers were queued AND vb2 was not yet
> streaming, just check whether streaming is in progress and return POLLERR
> if not.
> 
> This change makes it impossible to poll in one thread and call STREAMON in
> another, but doing that breaks existing applications and is also not
> according to the spec. So be it.

I like this approach better than reverting the offending patch, as it doesn't 
break my use case :-)

If we decide that this is the right fix, we should update the V4L2 
specification to reflect that.

I've proposed an alternative solution in a reply to the "[PATCH/RFC v2 1/2] 
v4l: vb2: Don't return POLLERR during transient buffer underruns" mail thread. 
I think I like this patch better, as the behaviour is simpler, even if it 
doesn't strictly conform to the spec.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 7e6aff6..0452fb2 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2583,10 +2583,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> file *file, poll_table *wait) }
> 
>  	/*
> -	 * There is nothing to wait for if no buffer has been queued and the
> -	 * queue isn't streaming, or if the error flag is set.
> +	 * There is nothing to wait for if the queue isn't streaming, or if
> +	 * the error flag is set.
>  	 */
> -	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
> +	if (!vb2_is_streaming(q) || q->error)
>  		return res | POLLERR;
> 
>  	/*

-- 
Regards,

Laurent Pinchart

