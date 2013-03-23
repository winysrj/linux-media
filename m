Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56082 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3CWTCj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 15:02:39 -0400
Message-ID: <514DFC4A.2080205@gmail.com>
Date: Sat, 23 Mar 2013 20:02:34 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC 11/12] exynos-fimc-is: Adds the Kconfig and Makefile
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-12-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362754765-2651-12-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> Modifies the exynos5-is Makefile and Kconfig to include the new
> fimc-is driver.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/Kconfig  |   12 ++++++++++++
>   drivers/media/platform/exynos5-is/Makefile |    3 +++
>   2 files changed, 15 insertions(+)
>
> diff --git a/drivers/media/platform/exynos5-is/Kconfig b/drivers/media/platform/exynos5-is/Kconfig
> index 7aacf3b..588103e 100644
> --- a/drivers/media/platform/exynos5-is/Kconfig
> +++ b/drivers/media/platform/exynos5-is/Kconfig
> @@ -5,3 +5,15 @@ config VIDEO_SAMSUNG_EXYNOS5_MDEV
>   	  This is a v4l2 based media controller driver for
>   	  Exynos5 SoC.
>
> +if VIDEO_SAMSUNG_EXYNOS5_MDEV
> +
> +config VIDEO_SAMSUNG_EXYNOS5_FIMC_IS
> +	tristate "Samsung Exynos5 SoC FIMC-IS driver"
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	depends on VIDEO_SAMSUNG_EXYNOS5_MDEV
> +	select VIDEOBUF2_DMA_CONTIG
> +	help
> +	  This is a v4l2 driver for Samsung Exynos5 SoC series Imaging
> +	  subsystem known as FIMC-IS.

nit: Subsystem and V4L2 should be capitalized.
