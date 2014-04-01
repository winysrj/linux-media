Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12329 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDAOei (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 10:34:38 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3C005RLWHO7N90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 01 Apr 2014 15:34:36 +0100 (BST)
Message-id: <533ACE75.1040908@samsung.com>
Date: Tue, 01 Apr 2014 16:34:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] s5p-fimc: Changed RGB32 to BGR32
References: <1395780301.11851.14.camel@nicolas-tpx230>
 <1395780923.11851.21.camel@nicolas-tpx230>
In-reply-to: <1395780923.11851.21.camel@nicolas-tpx230>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/03/14 21:55, Nicolas Dufresne wrote:
> Testing showed that HW produces BGR32 rather then RGB32 as exposed
> in the driver. The documentation seems to state the pixels are stored
> in little endian order.
> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
> index da2fc86..bfb80fb 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -56,8 +56,8 @@ static struct fimc_fmt fimc_formats[] = {
>  		.colplanes	= 1,
>  		.flags		= FMT_FLAGS_M2M,
>  	}, {
> -		.name		= "ARGB8888, 32 bpp",
> -		.fourcc		= V4L2_PIX_FMT_RGB32,
> +		.name		= "BGRB888, 32 bpp",

It should be "BGRA8888, 32 bpp", I can fix it when applying, if
you won't send next version of this patch until then.

> +		.fourcc		= V4L2_PIX_FMT_BGR32,
>  		.depth		= { 32 },
>  		.color		= FIMC_FMT_RGB888,
>  		.memplanes	= 1,

--
Thanks!
Sylwester
