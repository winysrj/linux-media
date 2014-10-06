Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51383 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaJFMhq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 08:37:46 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so4158331lbg.0
        for <linux-media@vger.kernel.org>; Mon, 06 Oct 2014 05:37:44 -0700 (PDT)
Message-ID: <54328D18.2000606@cogentembedded.com>
Date: Mon, 06 Oct 2014 16:37:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH 2/4] [media] exynos4-is: Remove optional dependency on
 PLAT_S5P
References: <1412586485.4054.40.camel@x220>
In-Reply-To: <1412586485.4054.40.camel@x220>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 10/6/2014 1:08 PM, Paul Bolle wrote:

> Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
> removed the Kconfig symbol PLAT_S5P. Remove an optional dependency on
> that symbol from this Kconfig file too.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>   drivers/media/platform/exynos4-is/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
> index 77c951237744..775c3278d0eb 100644
> --- a/drivers/media/platform/exynos4-is/Kconfig
> +++ b/drivers/media/platform/exynos4-is/Kconfig
> @@ -2,7 +2,7 @@
>   config VIDEO_SAMSUNG_EXYNOS4_IS
>   	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
>   	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> -	depends on (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
> +	depends on (ARCH_EXYNOS || COMPILE_TEST)

    Perhaps it's time to drop the useless parens?

WBR, Sergei

