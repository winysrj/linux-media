Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:51256 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbAEHoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 02:44:04 -0500
Message-id: <54AA40C7.3000506@samsung.com>
Date: Mon, 05 Jan 2015 13:14:07 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
MIME-version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	tony nadackal <tony.kn@samsung.com>
Subject: Re: media: platform: s5p-jpeg: jpeg-hw-exynos4: Remove some unused
 functions
References: <1420231027-2714-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-reply-to: <1420231027-2714-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Tony Nadackal

Hi Rickard,

On Saturday 03 January 2015 02:07 AM, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> exynos4_jpeg_set_timer_count() exynos4_jpeg_get_frame_size() exynos4_jpeg_set_sys_int_enable() exynos4_jpeg_get_fifo_status()
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> ---
> drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |   35 ---------------------
>   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h |    5 ---
>   2 files changed, 40 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> index ab6d6f4..5685577 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> @@ -163,15 +163,6 @@ unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
>   	return int_status;
>   }
>
> -unsigned int exynos4_jpeg_get_fifo_status(void __iomem *base)
> -{
> -	unsigned int fifo_status;
> -
> -	fifo_status = readl(base + EXYNOS4_FIFO_STATUS_REG);
> -
> -	return fifo_status;
> -}
> -
>   void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
>   {
>   	unsigned int	reg;
> @@ -186,18 +177,6 @@ void exynos4_jpeg_set_huf_table_enable(void __iomem *base, int value)
>   					base + EXYNOS4_JPEG_CNTL_REG);
>   }
>
> -void exynos4_jpeg_set_sys_int_enable(void __iomem *base, int value)
> -{
> -	unsigned int	reg;
> -
> -	reg = readl(base + EXYNOS4_JPEG_CNTL_REG) & ~(EXYNOS4_SYS_INT_EN);
> -
> -	if (value == 1)
> -		writel(reg | EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
> -	else
> -		writel(reg & ~EXYNOS4_SYS_INT_EN, base + EXYNOS4_JPEG_CNTL_REG);
> -}
> -

Above function will be needed for enabling JPEG support on Exynos7 SoC. 
There is already inflight patch [1] which will be using it.

1: https://patchwork.kernel.org/patch/5505391/


Thanks,
Pankaj Dubey
