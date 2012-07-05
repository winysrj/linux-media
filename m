Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58092 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2GEVNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 17:13:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] omap3isp: fix dqbuf description comment
Date: Thu, 05 Jul 2012 23:13:36 +0200
Message-ID: <3404714.AxthdyaIu4@avalon>
In-Reply-To: <1340809617-5914-1-git-send-email-michael.jones@matrix-vision.de>
References: <1340809617-5914-1-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

Thanks for the patch.

On Wednesday 27 June 2012 17:06:57 Michael Jones wrote:
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  drivers/media/video/omap3isp/ispqueue.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> This comment looks like it was a copy-paste from the description of qbuf.

You're right. I've applied your patch to my tree, with a slightly modified 
comment.

> diff --git a/drivers/media/video/omap3isp/ispqueue.c
> b/drivers/media/video/omap3isp/ispqueue.c index 5fda5d0..23915ce 100644
> --- a/drivers/media/video/omap3isp/ispqueue.c
> +++ b/drivers/media/video/omap3isp/ispqueue.c
> @@ -908,13 +908,8 @@ done:
>   *
>   * This function is intended to be used as a VIDIOC_DQBUF ioctl handler.
>   *
> - * The v4l2_buffer structure passed from userspace is first sanity tested.
> If
> - * sane, the buffer is then processed and added to the main queue and, if
> the
> - * queue is streaming, to the IRQ queue.
> - *
> - * Before being enqueued, USERPTR buffers are checked for address changes.
> If
> - * the buffer has a different userspace address, the old memory area is
> unlocked
> - * and the new memory area is locked.
> + * if nonblocking=1, returns -EAGAIN if no buffer is available.
> + * if nonblocking=0, waits on IRQ queue until a buffer becomes available.
>   */
>  int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
>  			       struct v4l2_buffer *vbuf, int nonblocking)
-- 
Regards,

Laurent Pinchart

