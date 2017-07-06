Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40243 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751659AbdGFJ3t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 05:29:49 -0400
Subject: Re: [PATCH 12/12] [media] vb2: add out-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-13-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <aee01ccd-530b-4c93-6510-6b6acca7e7c0@xs4all.nl>
Date: Thu, 6 Jul 2017 11:29:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-13-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> If V4L2_BUF_FLAG_OUT_FENCE flag is present on the QBUF call we create
> an out_fence for the buffer and return it to userspace on the fence_fd
> field. It only works with ordered queues.
> 
> The fence is signaled on buffer_done(), when the job on the buffer is
> finished.
> 
> v2: check if the queue is ordered.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |  6 ++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 22 +++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 

<snip>

> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index e6ad77f..e2733dd 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -204,9 +204,14 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->timestamp = ns_to_timeval(vb->timestamp);
>  	b->timecode = vbuf->timecode;
>  	b->sequence = vbuf->sequence;
> -	b->fence_fd = -1;
> +	b->fence_fd = vb->out_fence_fd;

I forgot to ask: can a buffer have both an in and an out fence? If so, then we
have a problem here since we can report only one fence fd.

If it is not allowed, then we need a check for that somewhere.

Regards,

	Hans
