Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54748 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752013AbdGFJTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 05:19:00 -0400
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ae203289-11cc-d5a5-0ce6-a8fbbc4742af@xs4all.nl>
Date: Thu, 6 Jul 2017 11:18:39 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-4-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Receive in-fence from userspace and add support for waiting on them
> before queueing the buffer to the driver. Buffers are only queued
> to the driver once they are ready. A buffer is ready when its
> in-fence signals.
> 
> v2:
> 	- fix vb2_queue_or_prepare_buf() ret check
> 	- remove check for VB2_MEMORY_DMABUF only (Javier)
> 	- check num of ready buffers to start streaming
> 	- when queueing, start from the first ready buffer
> 	- handle queue cancel
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/Kconfig                    |  1 +
>  drivers/media/v4l2-core/videobuf2-core.c | 97 +++++++++++++++++++++++++-------
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 15 ++++-
>  include/media/videobuf2-core.h           |  7 ++-
>  4 files changed, 99 insertions(+), 21 deletions(-)
> 

<snip>

> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 110fb45..e6ad77f 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -23,6 +23,7 @@
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
> +#include <linux/sync_file.h>
>  
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
> @@ -560,6 +561,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
>  
>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  {
> +	struct dma_fence *fence = NULL;
>  	int ret;
>  
>  	if (vb2_fileio_is_active(q)) {
> @@ -568,7 +570,18 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	}
>  
>  	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> -	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> +	if (ret)
> +		return ret;
> +
> +	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
> +		fence = sync_file_get_fence(b->fence_fd);
> +		if (!fence) {
> +			dprintk(1, "failed to get in-fence from fd\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);
>  }
>  EXPORT_SYMBOL_GPL(vb2_qbuf);

You need to adapt __fill_v4l2_buffer so it sets the IN_FENCE buffer flag
if there is a fence pending. It should also fill in fence_fd.

Regards,

	Hans
