Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42691 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbcDVMQc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 08:16:32 -0400
Date: Fri, 22 Apr 2016 09:16:22 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Junghak Sung <jh1009.sung@samsung.com>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] media: vb2: Fix regression on poll() for RW mode
Message-ID: <20160422091622.7b858565@recife.lan>
In-Reply-To: <1461230116-6909-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1461230116-6909-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Apr 2016 11:15:16 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> escreveu:

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
> +

No, we shouldn't do VB1 backward compatibility at the core, as this
is a special case that only applies for V4L2. The hole idea of splitting
the core and the v4l2-specific code is to allow VB2 to be used on other
places, like on DVB.

So, we need some other approach that would keep this specific to V4L2.

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


-- 
Thanks,
Mauro
