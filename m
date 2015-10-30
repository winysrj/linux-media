Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58679 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311AbbJ3PDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2015 11:03:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] vb2: fix a regression in poll() behavior for output,streams
Date: Fri, 30 Oct 2015 17:03:55 +0200
Message-ID: <11127664.nedBR2I0aM@avalon>
In-Reply-To: <5631A84E.7040101@xs4all.nl>
References: <5631A84E.7040101@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 29 October 2015 14:02:06 Hans Verkuil wrote:
> In the 3.17 kernel the poll() behavior changed for output streams:
> as long as not all buffers were queued up poll() would return that
> userspace can write. This is fine for the write() call, but when
> using stream I/O this changed the behavior since the expectation
> was that it would wait for buffers to become available for dequeuing.
> 
> This patch only enables the check whether you can queue buffers
> for file I/O only, and skips it for stream I/O.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thank you for the patch, it's really appreciated.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll be able to test it when going back home, but there's no need to wait for 
me to push this upstream.

> ---
> Note: This patch should be applied to stable for 3.17 and up.

Cc: stable@vger.kernel.org # 3.17+

(although the documentation states it should be "# 3.17.x-" but git log thinks 
otherwise)

>  drivers/media/v4l2-core/videobuf2-v4l2.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c
> b/drivers/media/v4l2-core/videobuf2-v4l2.c index dda525b..3ca8a2e 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -860,10 +860,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file
> *file, poll_table *wait) return res | POLLERR;
> 
>  	/*
> -	 * For output streams you can write as long as there are fewer buffers
> -	 * queued than there are buffers available.
> +	 * For output streams you can call write() as long as there are fewer
> +	 * buffers queued than there are buffers available.
>  	 */
> -	if (q->is_output && q->queued_count < q->num_buffers)
> +	if (q->is_output && q->fileio && q->queued_count < q->num_buffers)
>  		return res | POLLOUT | POLLWRNORM;
> 
>  	if (list_empty(&q->done_list)) {

-- 
Regards,

Laurent Pinchart

