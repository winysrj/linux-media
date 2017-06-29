Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57344 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752812AbdF2MEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 08:04:37 -0400
Subject: Re: [PATCH v3 5/8] [media] s5p-jpeg: Split s5p_jpeg_parse_hdr()
To: Thierry Escande <thierry.escande@collabora.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <8935217c-8b3e-a9d1-6226-bcab434e2e28@samsung.com>
Date: Thu, 29 Jun 2017 14:04:26 +0200
MIME-version: 1.0
In-reply-to: <1498579734-1594-6-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170627160933epcas2p43434893aed7c80b51b753a0207d20eab@epcas2p4.samsung.com>
 <1498579734-1594-6-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 27.06.2017 o 18:08, Thierry Escande pisze:
> This patch moves the subsampling value decoding read from the jpeg
> header into its own function. This new function is called
> s5p_jpeg_subsampling_decode() and returns true if it successfully
> decodes the subsampling value, false otherwise.
> 
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>

Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 42 ++++++++++++++++-------------
>   1 file changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 1769744..0783809 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1096,6 +1096,29 @@ static void skip(struct s5p_jpeg_buffer *buf, long len)
>   		get_byte(buf);
>   }
>   
> +static bool s5p_jpeg_subsampling_decode(struct s5p_jpeg_ctx *ctx,
> +					unsigned int subsampling)
> +{
> +	switch (subsampling) {
> +	case 0x11:
> +		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_444;
> +		break;
> +	case 0x21:
> +		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_422;
> +		break;
> +	case 0x22:
> +		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_420;
> +		break;
> +	case 0x33:
> +		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>   static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>   			       unsigned long buffer, unsigned long size,
>   			       struct s5p_jpeg_ctx *ctx)
> @@ -1207,26 +1230,9 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>   		}
>   	}
>   
> -	if (notfound || !sos)
> +	if (notfound || !sos || !s5p_jpeg_subsampling_decode(ctx, subsampling))
>   		return false;
>   
> -	switch (subsampling) {
> -	case 0x11:
> -		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_444;
> -		break;
> -	case 0x21:
> -		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_422;
> -		break;
> -	case 0x22:
> -		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_420;
> -		break;
> -	case 0x33:
> -		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
> -		break;
> -	default:
> -		return false;
> -	}
> -
>   	result->w = width;
>   	result->h = height;
>   	result->sos = sos;
> 
