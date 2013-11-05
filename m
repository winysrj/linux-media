Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54411 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab3KEFYr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 00:24:47 -0500
Message-ID: <527880E7.4070005@ti.com>
Date: Tue, 5 Nov 2013 10:53:51 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>, <m.chehab@samsung.com>,
	<grant.likely@linaro.org>, <rob.herring@calxeda.com>,
	<hans.verkuil@cisco.com>, <k.debski@samsung.com>
CC: <yongjun_wei@trendmicro.com.cn>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH -next] [media] v4l: ti-vpe: fix return value check in
 vpe_probe()
References: <CAPgLHd-YSAP+236AfZTXT3Cg_opQ+t=+nUHL+CVhXnkeA=zcBw@mail.gmail.com>
In-Reply-To: <CAPgLHd-YSAP+236AfZTXT3Cg_opQ+t=+nUHL+CVhXnkeA=zcBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 30 October 2013 08:45 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function devm_kzalloc() and devm_ioremap()
> returns NULL pointer not ERR_PTR(). The IS_ERR() test in the return
> value check should be replaced with NULL test.

Reviewed-by: Archit Taneja <archit@ti.com>

Thanks,
Archit

>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/media/platform/ti-vpe/vpe.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 4e58069..90cf369 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1942,8 +1942,8 @@ static int vpe_probe(struct platform_device *pdev)
>   	int ret, irq, func;
>
>   	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> -	if (IS_ERR(dev))
> -		return PTR_ERR(dev);
> +	if (!dev)
> +		return -ENOMEM;
>
>   	spin_lock_init(&dev->lock);
>
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
>
>
>

