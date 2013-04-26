Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53395 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab3DZIwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 04:52:22 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLU00HFETZ4IN50@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Apr 2013 09:52:20 +0100 (BST)
Message-id: <517A4043.3040509@samsung.com>
Date: Fri, 26 Apr 2013 10:52:19 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer
 dereference in mipi-csis.c
References: <1366951447-6202-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1366951447-6202-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/26/2013 06:44 AM, Sachin Kamat wrote:
> When 'node' is NULL, the print statement tries to dereference it.
> Remove it from the error message.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/exynos4-is/mipi-csis.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
> index a2eda9d..6ddc69f 100644
> --- a/drivers/media/platform/exynos4-is/mipi-csis.c
> +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
> @@ -745,8 +745,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
>  
>  	node = v4l2_of_get_next_endpoint(node, NULL);
>  	if (!node) {
> -		dev_err(&pdev->dev, "No port node at %s\n",
> -					node->full_name);
> +		dev_err(&pdev->dev, "Port node not available\n");

Thanks Sachin. Could you instead do
s/node->full_name/pdev->dev.of_node->full_name ?

This way we won't loose any information and it would be easier to
determine which node exactly is wrong.

