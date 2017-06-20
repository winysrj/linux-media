Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51331 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdFTL5x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 07:57:53 -0400
Subject: Re: [PATCH v2 4/6] [media] s5p-jpeg: Decode 4:1:1 chroma subsampling
 format
To: Thierry Escande <thierry.escande@collabora.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <460fd251-b0ce-5acc-db94-0d0e5fc9eb04@samsung.com>
Date: Tue, 20 Jun 2017 13:57:46 +0200
MIME-version: 1.0
In-reply-to: <1497287605-20074-5-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170612171402epcas2p22a4c2dce550ee9f9fc50b6a504778892@epcas2p2.samsung.com>
 <1497287605-20074-5-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

W dniu 12.06.2017 o 19:13, Thierry Escande pisze:
> From: Tony K Nadackal <tony.kn@samsung.com>
> 
> This patch adds support for decoding 4:1:1 chroma subsampling in the
> jpeg header parsing function.
> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 0d935f5..7ef7173 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1236,6 +1236,9 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>   	case 0x33:
>   		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
>   		break;
> +	case 0x41:
> +		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_411;
> +		break;

Merely parsing 4:1:1 subsampling is not enough.

Now the s5p_jpeg_parse_hdr() sometimes returns false, among others
it does so when unsupported subsampling is encountered in the header.

As far as I know 4:1:1 is supported only on some variants (3250, 5420, 5433)
of the hardware, so the kind of change intended by the patch author
must take hardware variants into account. In the above function
ctx is available, so accessing hardware variant information is possible.

The s5p_jpeg_parse_hdr() is a lengthy function, so probably the
switch (subsampling) part should be factored out to a separate
function and extended appropriately.

Andrzej  
