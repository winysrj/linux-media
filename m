Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36389 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbcCKQ23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 11:28:29 -0500
Subject: Re: [PATCH 05/10] exynos4-is: Replace "hweight32(mask) == 1" with
 "is_power_of_2(mask)"
To: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
References: <1449398669-14507-1-git-send-email-zhaoxiu.zeng@gmail.com>
Cc: kyungmin.park@samsung.com, mchehab@osg.samsung.com,
	kgene@kernel.org, k.kozlowski@samsung.com,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <56E2F225.3040109@samsung.com>
Date: Fri, 11 Mar 2016 17:28:21 +0100
MIME-version: 1.0
In-reply-to: <1449398669-14507-1-git-send-email-zhaoxiu.zeng@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2015 11:44 AM, Zhaoxiu Zeng wrote:
> From: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>

The patch looks OK, but could you also provide a proper commit
message?

> Signed-off-by: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-is-regs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
> index cfe4406..ec75a24 100644
> --- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
> +++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
> @@ -11,6 +11,7 @@
>   * published by the Free Software Foundation.
>   */
>  #include <linux/delay.h>
> +#include <linux/log2.h>
>  
>  #include "fimc-is.h"
>  #include "fimc-is-command.h"
> @@ -107,7 +108,7 @@ int fimc_is_hw_get_params(struct fimc_is *is, unsigned int num_args)
>  
>  void fimc_is_hw_set_isp_buf_mask(struct fimc_is *is, unsigned int mask)
>  {
> -	if (hweight32(mask) == 1) {
> +	if (is_power_of_2(mask)) {
>  		dev_err(&is->pdev->dev, "%s(): not enough buffers (mask %#x)\n",
>  							__func__, mask);
>  		return;

-- 
Thanks,
Sylwester
