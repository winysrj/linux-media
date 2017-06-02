Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35171 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdFBTvQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 15:51:16 -0400
Subject: Re: [PATCH 1/9] [media] s5p-jpeg: Reset the Codec before doing a soft
 reset
To: Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-2-git-send-email-thierry.escande@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <359e198e-df2b-ef47-17b9-cefe4b7ff220@gmail.com>
Date: Fri, 2 Jun 2017 21:50:31 +0200
MIME-Version: 1.0
In-Reply-To: <1496419376-17099-2-git-send-email-thierry.escande@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On 06/02/2017 06:02 PM, Thierry Escande wrote:
> From: Abhilash Kesavan <a.kesavan@samsung.com>
> 
> This patch resets the encoding and decoding register bits before doing a
> soft reset.
> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> index a1d823a..9ad8f6d 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> @@ -21,6 +21,10 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
>  	unsigned int reg;
>  
>  	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
> +	writel(reg & ~(EXYNOS4_DEC_MODE | EXYNOS4_ENC_MODE),
> +	       base + EXYNOS4_JPEG_CNTL_REG);

Why is it required? It would be nice if commit message explained that.

> +	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
>  	writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
>  
>  	udelay(100);
> 

-- 
Best regards,
Jacek Anaszewski
