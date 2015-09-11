Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43384 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbbIKQM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 12:12:28 -0400
Message-ID: <55F2FD24.90506@xs4all.nl>
Date: Fri, 11 Sep 2015 18:11:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 02/11] vb2: Move buffer cache synchronisation to
 prepare from queue
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 01:50 PM, Sakari Ailus wrote:
> The buffer cache should be synchronised in buffer preparation, not when
> the buffer is queued to the device. Fix this.
> 
> Mmap buffers do not need cache synchronisation since they are always
> coherent.
> 

While I agree with this change, I also think it is incomplete. The memop prepare()
is now done before it is queued to the driver, but the corresponding memop
finish() is only called when it is returned by the driver.

So if the application queues buffers and (without calling STREAMON) destroys them
all (REQBUFS(0)), you should get 'unbalanced' messages in the kernel log.

I'm pretty sure v4l2-compliance tests this scenario, so that would be a good thing
to check.

Regards,

	Hans

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index af6a23a..64fce4d 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1636,10 +1636,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  
>  	trace_vb2_buf_queue(q, vb);
>  
> -	/* sync buffers */
> -	for (plane = 0; plane < vb->num_planes; ++plane)
> -		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
> -
>  	call_void_vb_qop(vb, buf_queue, vb);
>  }
>  
> @@ -1694,11 +1690,19 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  		ret = -EINVAL;
>  	}
>  
> -	if (ret)
> +	if (ret) {
>  		dprintk(1, "buffer preparation failed: %d\n", ret);
> -	vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
> +		vb->state = VB2_BUF_STATE_DEQUEUED;
> +		return ret;
> +	}
>  
> -	return ret;
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
> +
> +	vb->state = VB2_BUF_STATE_PREPARED;
> +
> +	return 0;
>  }
>  
>  static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
> 

