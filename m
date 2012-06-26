Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30994 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab2FZIku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 04:40:50 -0400
Received: from eusync2.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6700G1DUT0E120@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 09:41:24 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M6700HL0URY1A50@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 09:40:48 +0100 (BST)
Message-id: <4FE9758C.7030008@samsung.com>
Date: Tue, 26 Jun 2012 10:40:44 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Dima Zavin <dmitriyz@google.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv7 03/15] v4l: vb2: add support for shared buffer (dma_buf)
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
 <1339681069-8483-4-git-send-email-t.stanislaws@samsung.com>
 <20120620061216.GA19245@google.com>
In-reply-to: <20120620061216.GA19245@google.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dima Zavin,
Thank you for the patch and for a ping remainder :).

You are right. The unmap is missing in __vb2_queue_cancel.
I will apply your fix into next version of V4L2 support for dmabuf.

Please refer to some comments below.

On 06/20/2012 08:12 AM, Dima Zavin wrote:
> Tomasz,
> 
> I've encountered an issue with this patch when userspace does several
> stream_on/stream_off cycles. When the user tries to qbuf a buffer
> after doing stream_off, we trigger the "dmabuf already pinned" warning
> since we didn't unmap the buffer as dqbuf was never called.
> 
> The below patch adds calls to unmap in queue_cancel, but my feeling is that we
> probably should be calling detach too (i.e. put_dmabuf).
> 
> Thoughts?
> 
> --Dima
> 
> Subject: [PATCH] v4l: vb2: unmap dmabufs on STREAM_OFF event
> 
> Currently, if the user issues a STREAM_OFF request and then
> tries to re-enqueue buffers, it will trigger a warning in
> the vb2 allocators as the buffer would still be mapped
> from before STREAM_OFF was called. The current expectation
> is that buffers will be unmapped in dqbuf, but that will never
> be called on the mapped buffers after a STREAM_OFF event.
> 
> Cc: Sumit Semwal <sumit.semwal@ti.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Dima Zavin <dima@android.com>
> ---
>  drivers/media/video/videobuf2-core.c |   22 ++++++++++++++++++++--
>  1 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index b431dc6..e2a8f12 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1592,8 +1592,26 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	/*
>  	 * Reinitialize all buffers for next use.
>  	 */
> -	for (i = 0; i < q->num_buffers; ++i)
> -		q->bufs[i]->state = VB2_BUF_STATE_DEQUEUED;
> +	for (i = 0; i < q->num_buffers; ++i) {
> +		struct vb2_buffer *vb = q->bufs[i];
> +		int plane;
> +
> +		vb->state = VB2_BUF_STATE_DEQUEUED;
> +
> +		if (q->memory != V4L2_MEMORY_DMABUF)
> +			continue;
> +
> +		for (plane = 0; plane < vb->num_planes; ++plane) {
> +			struct vb2_plane *p = &vb->planes[plane];
> +
> +			if (!p->mem_priv)
> +				continue;

is the check above really needed? No check like this is done in
vb2_dqbuf.

> +			if (p->dbuf_mapped) {

If a buffer is queued then it is also mapped, so dbuf_mapped
should be always be true here (at least in theory).

> +				call_memop(q, unmap_dmabuf, p->mem_priv);
> +				p->dbuf_mapped = 0;
> +			}
> +		}
> +	}
>  }
>  
>  /**

Regards,
Tomasz Stanislawski
