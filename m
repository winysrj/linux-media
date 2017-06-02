Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36193 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdFBVfm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 17:35:42 -0400
Subject: Re: [PATCH 4/9] [media] s5p-jpeg: Decode 4:1:1 chroma subsampling
 format
To: Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-5-git-send-email-thierry.escande@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <a89dc580-1979-4af9-772f-1542e918970a@gmail.com>
Date: Fri, 2 Jun 2017 23:34:58 +0200
MIME-Version: 1.0
In-Reply-To: <1496419376-17099-5-git-send-email-thierry.escande@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On 06/02/2017 06:02 PM, Thierry Escande wrote:
> From: Tony K Nadackal <tony.kn@samsung.com>
> 
> This patch adds support for decoding 4:1:1 chroma subsampling in the
> jpeg header parsing function.
> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 0d83948..770a709 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1236,6 +1236,9 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>  	case 0x33:
>  		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
>  		break;
> +	case 0x41:
> +		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_411;
> +		break;
>  	default:
>  		return false;
>  	}
> 

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
