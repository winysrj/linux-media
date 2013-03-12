Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54714 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3CLQB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 12:01:56 -0400
Message-id: <513F5171.40603@samsung.com>
Date: Tue, 12 Mar 2013 17:01:53 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [RFC 12/12] mipi-csis: Enable all interrupts for fimc-is usage
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
 <1362754765-2651-13-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-13-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> FIMC-IS firmware needs all the MIPI-CSIS interrupts to be enabled.
> This patch enables all those MIPI interrupts.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/platform/s5p-fimc/mipi-csis.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
> index debda7c..11eef67 100644
> --- a/drivers/media/platform/s5p-fimc/mipi-csis.c
> +++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
> @@ -64,7 +64,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>  
>  /* Interrupt mask */
>  #define S5PCSIS_INTMSK			0x10
> -#define S5PCSIS_INTMSK_EN_ALL		0xf000103f
> +#define S5PCSIS_INTMSK_EN_ALL		0xfc00103f

Do you know what interrupts are assigned to the CSIS_INTMSK
bits 26, 27 ? In the documentation I have they are marked
as reserved. I have tested this patch on Exynos4x12, it seems
OK but you might want to merge it to the patch adding compatible
property for exynos5.

It would be good to know what these bits are for. And how
enabling the interrupts actually help without modifying the
interrupt handler ? Is it enough to just acknowledge those
interrupts ? Or how it works ?

--

Regards,
Sylwester
