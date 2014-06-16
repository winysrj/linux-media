Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1907 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaFPIZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 04:25:12 -0400
Message-ID: <539EA9C2.3010704@xs4all.nl>
Date: Mon, 16 Jun 2014 10:24:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 18/30] [media] coda: let userspace force IDR frames by
 enabling the keyframe flag in the source buffer
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de> <1402675736-15379-19-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-19-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2014 06:08 PM, Philipp Zabel wrote:
> This disables forcing IDR frames at GOP size intervals on CODA7541 and CODA960,
> which is only needed to work around a firmware bug on CodaDx6.
> Instead, the V4L2_BUF_FLAG_KEYFRAME v4l2 buffer flag is cleared before marking
> the source buffer done for dequeueing. Userspace can set it before queueing a
> frame to force an IDR frame, to implement VFU (Video Fast Update).

I'd like to see an RFC for this feature. Rather than 'misuse' it, I think this
should be standardized. I have nothing against using KEYFRAME in order to
implement VFU (in fact, I like it!), but it should be documented and well-defined.

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 11e059d..cf75112 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1264,22 +1264,22 @@ static void coda_prepare_encode(struct coda_ctx *ctx)
>  	 * frame as IDR. This is a problem for some decoders that can't
>  	 * recover when a frame is lost.
>  	 */
> -	if (src_buf->v4l2_buf.sequence % ctx->params.gop_size) {
> -		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
> -		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
> -	} else {
> +	if ((src_buf->v4l2_buf.sequence % ctx->params.gop_size) == 0)
>  		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
> +	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME)
>  		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
> -	}
> +	else
> +		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
>  
>  	if (dev->devtype->product == CODA_960)
>  		coda_set_gdi_regs(ctx);
>  
>  	/*
> -	 * Copy headers at the beginning of the first frame for H.264 only.
> -	 * In MPEG4 they are already copied by the coda.
> +	 * Copy headers in front of the first frame and forced I frames for
> +	 * H.264 only. In MPEG4 they are already copied by the CODA.
>  	 */
> -	if (src_buf->v4l2_buf.sequence == 0) {
> +	if (src_buf->v4l2_buf.sequence == 0 ||
> +	    src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
>  		pic_stream_buffer_addr =
>  			vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
>  			ctx->vpu_header_size[0] +
> @@ -3245,6 +3245,8 @@ static void coda_finish_encode(struct coda_ctx *ctx)
>  		src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
>  	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
>  
> +	/* Clear keyframe flag so userspace can misuse it to force an IDR frame */
> +	src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
>  	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
>  
>  	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> 

