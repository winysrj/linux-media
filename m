Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35393 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbdF2UNE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 16:13:04 -0400
Subject: Re: [PATCH v3 4/8] [media] s5p-jpeg: Don't use temporary structure in
 s5p_jpeg_buf_queue
To: Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
 <1498579734-1594-5-git-send-email-thierry.escande@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <414dfbec-8ef9-6ac5-153b-084c9a765410@gmail.com>
Date: Thu, 29 Jun 2017 22:12:20 +0200
MIME-Version: 1.0
In-Reply-To: <1498579734-1594-5-git-send-email-thierry.escande@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On 06/27/2017 06:08 PM, Thierry Escande wrote:
> If s5p_jpeg_parse_hdr() fails to parse the JPEG header, the passed
> s5p_jpeg_q_data structure is not modify so there is no need to use a

s/modify/modified/

> temporary structure and the field-by-field copy can be avoided.
> 
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 23 ++++-------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index df3e5ee..1769744 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2500,9 +2500,9 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>  
>  	if (ctx->mode == S5P_JPEG_DECODE &&
>  	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> -		struct s5p_jpeg_q_data tmp, *q_data;
> +		struct s5p_jpeg_q_data *q_data;
>  
> -		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
> +		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&ctx->out_q,
>  		     (unsigned long)vb2_plane_vaddr(vb, 0),
>  		     min((unsigned long)ctx->out_q.size,
>  			 vb2_get_plane_payload(vb, 0)), ctx);
> @@ -2511,24 +2511,9 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>  			return;
>  		}
>  
> -		q_data = &ctx->out_q;
> -		q_data->w = tmp.w;
> -		q_data->h = tmp.h;
> -		q_data->sos = tmp.sos;
> -		memcpy(q_data->dht.marker, tmp.dht.marker,
> -		       sizeof(tmp.dht.marker));
> -		memcpy(q_data->dht.len, tmp.dht.len, sizeof(tmp.dht.len));
> -		q_data->dht.n = tmp.dht.n;
> -		memcpy(q_data->dqt.marker, tmp.dqt.marker,
> -		       sizeof(tmp.dqt.marker));
> -		memcpy(q_data->dqt.len, tmp.dqt.len, sizeof(tmp.dqt.len));
> -		q_data->dqt.n = tmp.dqt.n;
> -		q_data->sof = tmp.sof;
> -		q_data->sof_len = tmp.sof_len;
> -
>  		q_data = &ctx->cap_q;
> -		q_data->w = tmp.w;
> -		q_data->h = tmp.h;
> +		q_data->w = ctx->out_q.w;
> +		q_data->h = ctx->out_q.h;
>  
>  		/*
>  		 * This call to jpeg_bound_align_image() takes care of width and
> 

-- 
Best regards,
Jacek Anaszewski
