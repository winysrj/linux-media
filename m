Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54398 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3KEFYa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 00:24:30 -0500
Message-ID: <527880D6.4070008@ti.com>
Date: Tue, 5 Nov 2013 10:53:34 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>, <m.chehab@samsung.com>,
	<grant.likely@linaro.org>, <rob.herring@calxeda.com>,
	<hans.verkuil@cisco.com>, <k.debski@samsung.com>
CC: <yongjun_wei@trendmicro.com.cn>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH -next] [media] v4l: ti-vpe: fix error return code in vpe_probe()
References: <CAPgLHd_VJKy0Eqsyjb=_CKbCZTEvpq6Gh+ri3YSTHPEqLN=U0w@mail.gmail.com>
In-Reply-To: <CAPgLHd_VJKy0Eqsyjb=_CKbCZTEvpq6Gh+ri3YSTHPEqLN=U0w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 30 October 2013 08:40 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

Reviewed-by: Archit Taneja <archit@ti.com>

Thanks,
Archit

>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/media/platform/ti-vpe/vpe.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 4e58069..0dbfd52 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -2007,8 +2007,10 @@ static int vpe_probe(struct platform_device *pdev)
>   	vpe_top_vpdma_reset(dev);
>
>   	dev->vpdma = vpdma_create(pdev);
> -	if (IS_ERR(dev->vpdma))
> +	if (IS_ERR(dev->vpdma)) {
> +		ret = PTR_ERR(dev->vpdma);
>   		goto runtime_put;
> +	}
>
>   	vfd = &dev->vfd;
>   	*vfd = vpe_videodev;
>
>

