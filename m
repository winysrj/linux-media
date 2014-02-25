Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61339 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaBYNIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 08:08:37 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1J003F7Z6C1F60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Feb 2014 13:08:36 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-6-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1392497585-5084-6-git-send-email-sakari.ailus@iki.fi>
Subject: RE: [PATCH v5 5/7] exynos-gsc, m2m-deinterlace,
 mx2_emmaprp: Copy v4l2_buffer data from src to dst
Date: Tue, 25 Feb 2014 14:08:33 +0100
Message-id: <12f801cf322a$b06e5630$114b0290$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Saturday, February 15, 2014 9:53 PM
> 
> The timestamp and timecode fields were copied from destination to
> source, not the other way around as they should. Fix it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/exynos-gsc/gsc-m2m.c |    4 ++--
>  drivers/media/platform/m2m-deinterlace.c    |    4 ++--
>  drivers/media/platform/mx2_emmaprp.c        |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index 810c3e1..62c84d5 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -88,8 +88,8 @@ void gsc_m2m_job_finish(struct gsc_ctx *ctx, int
> vb_state)
>  	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> 
>  	if (src_vb && dst_vb) {
> -		src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
> -		src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
> +		dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
> +		dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;

It is such a silly mistake that I had to think for a while why
could it be copied the other way. I suppose this happens when
coding in a hurry :( Thank you for spotting this.

> 
>  		v4l2_m2m_buf_done(src_vb, vb_state);
>  		v4l2_m2m_buf_done(dst_vb, vb_state);
> diff --git a/drivers/media/platform/m2m-deinterlace.c
> b/drivers/media/platform/m2m-deinterlace.c
> index 6bb86b5..1f272d3 100644
> --- a/drivers/media/platform/m2m-deinterlace.c
> +++ b/drivers/media/platform/m2m-deinterlace.c
> @@ -207,8 +207,8 @@ static void dma_callback(void *data)
>  	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
>  	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
> 
> -	src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
> -	src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
> +	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
> +	dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
> 
>  	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
>  	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE); diff --git
> a/drivers/media/platform/mx2_emmaprp.c
> b/drivers/media/platform/mx2_emmaprp.c
> index c690435..91056ac0 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -377,8 +377,8 @@ static irqreturn_t emmaprp_irq(int irq_emma, void
> *data)
>  			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
>  			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
> 
> -			src_vb->v4l2_buf.timestamp = dst_vb-
> >v4l2_buf.timestamp;
> -			src_vb->v4l2_buf.timecode = dst_vb-
> >v4l2_buf.timecode;
> +			dst_vb->v4l2_buf.timestamp = src_vb-
> >v4l2_buf.timestamp;
> +			dst_vb->v4l2_buf.timecode = src_vb-
> >v4l2_buf.timecode;
> 
>  			spin_lock_irqsave(&pcdev->irqlock, flags);
>  			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
> --
> 1.7.10.4

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

