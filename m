Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36803 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdFBV2i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 17:28:38 -0400
Subject: Re: [PATCH 2/9] [media] s5p-jpeg: Call jpeg_bound_align_image after
 qbuf
To: Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-3-git-send-email-thierry.escande@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <563c5112-93f7-7b05-1601-c3644a2111ce@gmail.com>
Date: Fri, 2 Jun 2017 23:27:54 +0200
MIME-Version: 1.0
In-Reply-To: <1496419376-17099-3-git-send-email-thierry.escande@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

Thanks for the patch.

On 06/02/2017 06:02 PM, Thierry Escande wrote:
> From: Tony K Nadackal <tony.kn@samsung.com>
> 
> When queuing an OUTPUT buffer for decoder, s5p_jpeg_parse_hdr()
> function parses the input jpeg file and takes the width and height
> parameters from its header. These new width/height values will be used
> for the calculation of stride. HX_JPEG Hardware needs the width and
> height values aligned on a 16 bits boundary. This width/height alignment
> is handled in the s5p_jpeg_s_fmt_vid_cap() function during the S_FMT
> ioctl call.
> 
> But if user space calls the QBUF of OUTPUT buffer after the S_FMT of
> CAPTURE buffer, these aligned values will be replaced by the values in
> jpeg header.

I assume that you may want to avoid re-setting the capture buf format
when decoding a stream of JPEGs and you are certain that all of them
have the same subsampling. Nonetheless, please keep in mind that in case
of Exynos4x12 SoCs there is a risk of permanent decoder hangup if you'd
try to decode to a YUV with lower subsampling than the one of input
JPEG. s5p_jpeg_try_fmt_vid_cap() does a suitable adjustment to avoid the
problem.

I'd add a comment over this call to jpeg_bound_align_image() that
resigning from executing S_FMT on capture buf for each JPEG image
can result in a hardware hangup if forbidden decoding will be enforced.

> If the width/height values of jpeg are not aligned, the
> decoder output will be corrupted. So in this patch we call
> jpeg_bound_align_image() to align the width/height values of Capture
> buffer in s5p_jpeg_buf_queue().
> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 52dc794..6fb1ab4 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2523,6 +2523,13 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>  		q_data = &ctx->cap_q;
>  		q_data->w = tmp.w;
>  		q_data->h = tmp.h;
> +
> +		jpeg_bound_align_image(ctx, &q_data->w, S5P_JPEG_MIN_WIDTH,
> +				       S5P_JPEG_MAX_WIDTH, q_data->fmt->h_align,
> +				       &q_data->h, S5P_JPEG_MIN_HEIGHT,
> +				       S5P_JPEG_MAX_HEIGHT, q_data->fmt->v_align
> +				      );
> +		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
>  	}
>  
>  	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> 

-- 
Best regards,
Jacek Anaszewski
