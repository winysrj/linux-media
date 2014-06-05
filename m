Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.51]:58928 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbaFEI3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jun 2014 04:29:48 -0400
Message-ID: <53902A3F.9000204@xs4all.nl>
Date: Thu, 05 Jun 2014 10:28:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH/RFC 1/2] v4l: vb2: Don't return POLLERR during transient
 buffer underruns
References: <1401890744-22683-1-git-send-email-laurent.pinchart@ideasonboard.com> <1401890744-22683-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401890744-22683-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/14 16:05, Laurent Pinchart wrote:
> The V4L2 specification states that
> 
> "When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet
> the poll() function succeeds, but sets the POLLERR flag in the revents
> field."
> 
> The vb2_poll() function sets POLLERR when the queued buffers list is
> empty, regardless of whether this is caused by the stream not being
> active yet, or by a transient buffer underrun.
> 
> Bring the implementation in line with the specification by returning
> POLLERR only when the queue is not streaming. Buffer underruns during
> streaming are not treated specially anymore and just result in poll()
> blocking until the next event.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/video/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 11d31bf..5f38774 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1984,9 +1984,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	}
>  
>  	/*
> -	 * There is nothing to wait for if no buffers have already been queued.
> +	 * There is nothing to wait for if the queue isn't streaming.
>  	 */
> -	if (list_empty(&q->queued_list))
> +	if (!vb2_is_streaming(q))
>  		return res | POLLERR;
>  
>  	poll_wait(file, &q->done_wq, wait);
> 

