Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53880 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbcDVJTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 05:19:15 -0400
Subject: Re: [PATCH] media: vb2: Fix regression on poll() for RW mode
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1461230116-6909-1-git-send-email-ricardo.ribalda@gmail.com>
Cc: Junghak Sung <jh1009.sung@samsung.com>, stable@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5719EC8D.2000500@xs4all.nl>
Date: Fri, 22 Apr 2016 11:19:09 +0200
MIME-Version: 1.0
In-Reply-To: <1461230116-6909-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 04/21/2016 11:15 AM, Ricardo Ribalda Delgado wrote:
> When using a device is read/write mode, vb2 does not handle properly the
> first select/poll operation. It allways return POLLERR.
> 
> The reason for this is that when this code has been refactored, some of
> the operations have changed their order, and now fileio emulator is not
> started by poll, due to a previous check.
> 
> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
> Cc: Junghak Sung <jh1009.sung@samsung.com>
> Cc: stable@vger.kernel.org
> Fixes: 49d8ab9feaf2 ("media] media: videobuf2: Separate vb2_poll()")
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 8 ++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 8 --------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 5d016f496e0e..199c65dbe330 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2298,6 +2298,14 @@ unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
>  		return POLLERR;
>  
>  	/*
> +	 * For compatibility with vb1: if QBUF hasn't been called yet, then
> +	 * return POLLERR as well. This only affects capture queues, output
> +	 * queues will always initialize waiting_for_buffers to false.
> +	 */
> +	if (q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))
> +		return POLLERR;

The problem I have with this is that this should be specific to V4L2. The only
reason we do this is that we had to stay backwards compatible with vb1.

This is the reason this code was placed in videobuf2-v4l2.c. But you are correct
that this causes a regression, and I see no other choice but to put it in core.c.

That said, I would still only honor this when called from v4l2, so I suggest that
a new flag 'check_waiting_for_buffers' is added that is only set in vb2_queue_init
in videobuf2-v4l2.c.

So the test above becomes:

	if (q->check_waiting_for_buffers && q->waiting_for_buffers &&
	    (req_events & (POLLIN | POLLRDNORM)))

It's not ideal, but at least this keeps this v4l2 specific.

Regards,

	Hans

> +
> +	/*
>  	 * For output streams you can call write() as long as there are fewer
>  	 * buffers queued than there are buffers available.
>  	 */
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 91f552124050..c9bad9ef2104 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -818,14 +818,6 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  			poll_wait(file, &fh->wait, wait);
>  	}
>  
> -	/*
> -	 * For compatibility with vb1: if QBUF hasn't been called yet, then
> -	 * return POLLERR as well. This only affects capture queues, output
> -	 * queues will always initialize waiting_for_buffers to false.
> -	 */
> -	if (q->waiting_for_buffers && (req_events & (POLLIN | POLLRDNORM)))
> -		return POLLERR;
> -
>  	return res | vb2_core_poll(q, file, wait);
>  }
>  EXPORT_SYMBOL_GPL(vb2_poll);
> 

