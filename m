Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63457 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752682AbdF2MEz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 08:04:55 -0400
Subject: Re: [PATCH v3 6/8] [media] s5p-jpeg: Decode 4:1:1 chroma subsampling
 format
To: Thierry Escande <thierry.escande@collabora.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <a037a6df-9a8a-f31a-1c92-6f2cbd3d1a2d@samsung.com>
Date: Thu, 29 Jun 2017 14:04:40 +0200
MIME-version: 1.0
In-reply-to: <1498579734-1594-7-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170627161047epcas2p439c3d90e17402cd06d3c820564cb0e17@epcas2p4.samsung.com>
 <1498579734-1594-7-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 27.06.2017 o 18:08, Thierry Escande pisze:
> From: Tony K Nadackal <tony.kn@samsung.com>
> 
> This patch adds support for decoding 4:1:1 chroma subsampling in the
> jpeg header parsing function.
> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 0783809..cca0fb8 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1099,6 +1099,8 @@ static void skip(struct s5p_jpeg_buffer *buf, long len)
>   static bool s5p_jpeg_subsampling_decode(struct s5p_jpeg_ctx *ctx,
>   					unsigned int subsampling)
>   {
> +	unsigned int version;
> +
>   	switch (subsampling) {
>   	case 0x11:
>   		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_444;
> @@ -1112,6 +1114,19 @@ static bool s5p_jpeg_subsampling_decode(struct s5p_jpeg_ctx *ctx,
>   	case 0x33:
>   		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
>   		break;
> +	case 0x41:
> +		/*
> +		 * 4:1:1 subsampling only supported by 3250, 5420, and 5433
> +		 * variants
> +		 */
> +		version = ctx->jpeg->variant->version;
> +		if (version != SJPEG_EXYNOS3250 &&
> +		    version != SJPEG_EXYNOS5420 &&
> +		    version != SJPEG_EXYNOS5433)
> +			return false;
> +
> +		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_411;
> +		break;
>   	default:
>   		return false;
>   	}
> 
