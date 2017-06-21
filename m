Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62755 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbdFUIA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 04:00:28 -0400
Subject: Re: [PATCH v2 1/6] [media] s5p-jpeg: Reset the Codec before doing a
 soft reset
To: Thierry Escande <thierry.escande@collabora.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <bd23591d-53fe-36e8-bdc7-03737dc58c5d@samsung.com>
Date: Wed, 21 Jun 2017 10:00:22 +0200
MIME-version: 1.0
In-reply-to: <1497287605-20074-2-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170612171341epcas3p1da64f6bb1c5917de115ad841d54baed4@epcas3p1.samsung.com>
 <1497287605-20074-2-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

W dniu 12.06.2017 o 19:13, Thierry Escande pisze:
> From: Abhilash Kesavan <a.kesavan@samsung.com>
> 
> This patch resets the encoding and decoding register bits before doing a
> soft reset.

Here are my thoughts after consulting the documentation:

> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> index a1d823a..9ad8f6d 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> @@ -21,6 +21,10 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
>   	unsigned int reg;
>   
>   	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
> +	writel(reg & ~(EXYNOS4_DEC_MODE | EXYNOS4_ENC_MODE),
> +	       base + EXYNOS4_JPEG_CNTL_REG);

Indeed, if encoding/decoding "back-to-back", the bits this patch touches
should be reset.

The doc also says, that "Soft reset is asserted to all registers
of JPEG except soft reset bit itself", so, theoretically speaking,
the changes in this patch are redundant. Instead, the doc says,
these bits have to be reset after servicing the interrupt for current image
and before programming the hardware to perform the next en/decoding.
And indeed, the first thing that both ENCODE and DECODE paths
of exynos4_jpeg_device_run() do is calling sw reset.

If, however, you can show that the changes in the patch discussed here
are in fact necessary (that's the very difference between theory and practise...),
I will readily ack it.

Andrzej
