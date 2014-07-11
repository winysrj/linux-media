Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28139 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaGKN5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 09:57:16 -0400
Message-id: <53BFED38.4050207@samsung.com>
Date: Fri, 11 Jul 2014 15:57:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/9] s5p-jpeg: Add support for Exynos3250 SoC
References: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
 <1404750730-22996-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1404750730-22996-2-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/14 18:32, Jacek Anaszewski wrote:
> +void exynos3250_jpeg_dec_scaling_ratio(void __iomem *regs,
> +						unsigned int sratio)
> +{
> +	switch (sratio) {
> +	case 1:
> +		sratio = EXYNOS3250_DEC_SCALE_FACTOR_8_8;
> +		break;
> +	case 2:
> +		sratio = EXYNOS3250_DEC_SCALE_FACTOR_4_8;
> +		break;
> +	case 4:
> +		sratio = EXYNOS3250_DEC_SCALE_FACTOR_2_8;
> +		break;
> +	case 8:
> +		sratio = EXYNOS3250_DEC_SCALE_FACTOR_1_8;
> +		break;
> +	}

Missing the 'default' case ?

> +	writel(sratio & EXYNOS3250_DEC_SCALE_FACTOR_MASK,
> +				regs + EXYNOS3250_DEC_SCALING_RATIO);
> +}

--
Regards,
Sylwester
