Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52750 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HBIpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 04:45:43 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQW00CIBAZI4H80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Aug 2013 09:45:41 +0100 (BST)
Message-id: <51FB71B3.5060008@samsung.com>
Date: Fri, 02 Aug 2013 10:45:39 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 3/3] [media] exynos4-is: Fix potential NULL pointer
 dereference
References: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
 <1375425134-17080-3-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1375425134-17080-3-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 08/02/2013 08:32 AM, Sachin Kamat wrote:
> dev->of_node could be NULL. Hence check for the same and return before
> dereferencing it in the subsequent error message.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/exynos4-is/fimc-lite.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index 08fbfed..214bde2 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -1513,6 +1513,9 @@ static int fimc_lite_probe(struct platform_device *pdev)
>  		if (of_id)
>  			drv_data = (struct flite_drvdata *)of_id->data;
>  		fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
> +	} else {
> +		dev_err(dev, "device node not found\n");
> +		return -EINVAL;
>  	}

Thanks for the patch. I would prefer to add a check at very beginning
of fimc_lite_probe() like:

	if (!dev->of_node)
		return -ENODEV;

Those devices are only used on DT platforms.

--
Regards,
Sylwester
