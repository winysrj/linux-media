Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44139 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3DSIon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 04:44:43 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLH00F8XURAGPB0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Apr 2013 09:44:40 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Wei Yongjun' <weiyj.lk@gmail.com>, kyungmin.park@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com, grant.likely@linaro.org,
	rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
References: <CAPgLHd_TwmtoaE7T7e3fRKh4NTGhOYjQZv0G7nt-iSVMLz3XEQ@mail.gmail.com>
In-reply-to: <CAPgLHd_TwmtoaE7T7e3fRKh4NTGhOYjQZv0G7nt-iSVMLz3XEQ@mail.gmail.com>
Subject: RE: [PATCH -next] [media] s5p-mfc: fix error return code in
 s5p_mfc_probe()
Date: Fri, 19 Apr 2013 10:44:29 +0200
Message-id: <015501ce3cda$1cdfa900$569efb00$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

Thank you for your patch.

Best wishes,
Kamil Debski

> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> Sent: Thursday, April 18, 2013 5:18 AM
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling case
> instead of 0, as returned elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index e810b1a..a5853fa 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1110,7 +1110,8 @@ static int s5p_mfc_probe(struct platform_device
> *pdev)
>  	}
> 
>  	if (pdev->dev.of_node) {
> -		if (s5p_mfc_alloc_memdevs(dev) < 0)
> +		ret = s5p_mfc_alloc_memdevs(dev);
> +		if (ret < 0)
>  			goto err_res;
>  	} else {
>  		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,


