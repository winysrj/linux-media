Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2LUSkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 13:40:15 -0500
Date: Fri, 21 Dec 2012 16:39:46 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: javier.martin@vista-silicon.com
Cc: linux-media@vger.kernel.org, p.zabel@pengutronix.de
Subject: Re: [PATCH v2] media: coda: Fix H.264 header alignment.
Message-ID: <20121221163946.7e5f8b58@infradead.org>
In-Reply-To: <508e77fa.475fb40a.435a.01b7@mx.google.com>
References: <y>
	<508e77fa.475fb40a.435a.01b7@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 13:34:59 +0100
javier.martin@vista-silicon.com escreveu:

> From: Javier Martin <javier.martin@vista-silicon.com>
> 
> Length of H.264 headers is variable and thus it might not be
> aligned for the coda to append the encoded frame. This causes
> the first frame to overwrite part of the H.264 PPS.
> 
> In order to solve that, a filler NAL must be added between
> the headers and the first frame to preserve alignment.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

Please next time check it with checkpatch.pl.

Also, please send us a patch adding yourself at MAINTAINERS for this
driver.

Regards,
Mauro

> ---
> Changes since v1:
>  - Align to 64bits as requested by Philipp.
> 
> ---
>  drivers/media/platform/coda.c |   30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index a8c7a94..7febcd9 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -177,6 +177,10 @@ struct coda_ctx {
>  	int				idx;
>  };
>  
> +static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
> +			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80 };
> +static const u8 coda_filler_size[8] = { 0, 7, 14, 13, 12, 11, 10, 9 };
> +
>  static inline void coda_write(struct coda_dev *dev, u32 data, u32 reg)
>  {
>  	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
> @@ -938,6 +942,24 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_d
>  	return 0;
>  }
>  
> +static int coda_h264_padding(int size, char *p)
> +{
> +	int nal_size;
> +	int diff;
> +
> +	diff = size - (size & ~0x7);
> +	if (diff == 0)
> +		return 0;
> +
> +	nal_size = coda_filler_size[diff];
> +	memcpy(p, coda_filler_nal, nal_size);
> +
> +	/* Add rbsp stop bit and trailing at the end */
> +	*(p + nal_size - 1) = 0x80;
> +
> +	return nal_size;
> +}
> +
>  static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>  {
>  	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> @@ -1165,7 +1187,13 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>  				coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
>  		memcpy(&ctx->vpu_header[1][0], vb2_plane_vaddr(buf, 0),
>  		       ctx->vpu_header_size[1]);
> -		ctx->vpu_header_size[2] = 0;
> +		/*
> +		 * Length of H.264 headers is variable and thus it might not be
> +		 * aligned for the coda to append the encoded frame. In that is
> +		 * the case a filler NAL must be added to header 2.
> +		 */
> +		ctx->vpu_header_size[2] = coda_h264_padding((ctx->vpu_header_size[0] +
> +					ctx->vpu_header_size[1]), ctx->vpu_header[2]);
>  		break;
>  	case V4L2_PIX_FMT_MPEG4:
>  		/*




Cheers,
Mauro
