Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23982 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab1LVKv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 05:51:59 -0500
Date: Thu, 22 Dec 2011 11:51:51 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [patch 1/2] [media] Staging: dt3155v4l: update to newer API
In-reply-to: <20111222062907.GA19975@elgon.mountain>
To: 'Dan Carpenter' <dan.carpenter@oracle.com>,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>
Cc: 'Greg Kroah-Hartman' <gregkh@suse.de>,
	'H Hartley Sweeten' <hsweeten@visionengravers.com>,
	'Paul Gortmaker' <paul.gortmaker@windriver.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-id: <011201ccc097$b66d68c0$23483a40$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 8BIT
References: <20111222062907.GA19975@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, December 22, 2011 7:29 AM Dan Carpenter wrote:

> I changed the function definitions for dt3155_queue_setup() to match the
> newer API.  The dt3155_start_streaming() function didn't do anything so
> I just removed it.
> 
> This silences the following gcc warnings:
> drivers/staging/media/dt3155v4l/dt3155v4l.c:307:2: warning: initialization from incompatible
> pointer type [enabled by default]
> drivers/staging/media/dt3155v4l/dt3155v4l.c:307:2: warning: (near initialization for
> ‘q_ops.queue_setup’) [enabled by default]
> drivers/staging/media/dt3155v4l/dt3155v4l.c:311:2: warning: initialization from incompatible
> pointer type [enabled by default]
> drivers/staging/media/dt3155v4l/dt3155v4l.c:311:2: warning: (near initialization for
> ‘q_ops.start_streaming’) [enabled by default]
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

It looks correct.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> Please double check that this is sufficient.  I'm not very familiar with
> this code.
> 
> diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> index 04e93c4..25c6025 100644
> --- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> @@ -218,9 +218,10 @@ dt3155_start_acq(struct dt3155_priv *pd)
>   *	driver-specific callbacks (vb2_ops)
>   */
>  static int
> -dt3155_queue_setup(struct vb2_queue *q, unsigned int *num_buffers,
> -			unsigned int *num_planes, unsigned long sizes[],
> -						void *alloc_ctxs[])
> +dt3155_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
> +		unsigned int *num_buffers, unsigned int *num_planes,
> +		unsigned int sizes[], void *alloc_ctxs[])
> +
>  {
>  	struct dt3155_priv *pd = vb2_get_drv_priv(q);
>  	void *ret;
> @@ -262,12 +263,6 @@ dt3155_buf_prepare(struct vb2_buffer *vb)
>  }
> 
>  static int
> -dt3155_start_streaming(struct vb2_queue *q)
> -{
> -	return 0;
> -}
> -
> -static int
>  dt3155_stop_streaming(struct vb2_queue *q)
>  {
>  	struct dt3155_priv *pd = vb2_get_drv_priv(q);
> @@ -308,7 +303,6 @@ const struct vb2_ops q_ops = {
>  	.wait_prepare = dt3155_wait_prepare,
>  	.wait_finish = dt3155_wait_finish,
>  	.buf_prepare = dt3155_buf_prepare,
> -	.start_streaming = dt3155_start_streaming,
>  	.stop_streaming = dt3155_stop_streaming,
>  	.buf_queue = dt3155_buf_queue,
>  };


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



