Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50892 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3KHK11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Nov 2013 05:27:27 -0500
Message-ID: <527CBC5B.2000906@ti.com>
Date: Fri, 8 Nov 2013 15:56:35 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	<linux-media@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] [media] v4l: ti-vpe: checking for IS_ERR() instead of
 NULL
References: <20131108100109.GN27977@elgon.mountain>
In-Reply-To: <20131108100109.GN27977@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Friday 08 November 2013 03:31 PM, Dan Carpenter wrote:
> devm_ioremap() returns NULL on error, it doesn't return an ERR_PTR.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 4e58069..e163466 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1962,8 +1962,8 @@ static int vpe_probe(struct platform_device *pdev)
>   	 * registers based on the sub block base addresses
>   	 */
>   	dev->base = devm_ioremap(&pdev->dev, res->start, SZ_32K);
> -	if (IS_ERR(dev->base)) {
> -		ret = PTR_ERR(dev->base);
> +	if (!dev->base) {
> +		ret = -ENOMEM;
>   		goto v4l2_dev_unreg;
>   	}

Thanks for the patch, this was addressed in Wei's patch though:

"v4l: ti-vpe: fix return value check in vpe_probe()"

Thanks,
Archit
